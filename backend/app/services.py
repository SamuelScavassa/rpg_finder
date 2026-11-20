"""Regras de negócio das campanhas.

Cada função roda dentro da transação da requisição (um único commit no router).
As operações que alteram vagas travam a linha da campanha (SELECT ... FOR UPDATE)
para que dois convites aceitos ao mesmo tempo não estourem o limite de vagas.
"""
from datetime import datetime, timezone

from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models import (
    Campaign, CampaignMember, CampaignStatus, CampaignTag, Invite, InviteStatus, User,
)
from app.schemas import CampaignOut, UserPublic


# ---- helpers --------------------------------------------------------------
def normalize_tags(tags: list[str]) -> list[str]:
    """Tags em minúsculo e sem duplicatas (a pesquisa original também usava minúsculas)."""
    seen: dict[str, None] = {}
    for t in tags:
        t = t.strip().lower()
        if t:
            seen[t[:50]] = None
    return list(seen)


def normalize_discord(link: str) -> str:
    link = link.strip()
    if link and not link.startswith(("http://", "https://")):
        link = "https://" + link
    return link


def vagas_restantes(c: Campaign) -> int:
    return max(0, c.vagas_total - len(c.members))


def refresh_status(c: Campaign) -> None:
    if c.status == CampaignStatus.finalizada:
        return
    c.status = CampaignStatus.lotada if vagas_restantes(c) == 0 else CampaignStatus.aberta


def to_out(c: Campaign) -> CampaignOut:
    return CampaignOut(
        id=c.id,
        nome=c.nome,
        descricao=c.descricao,
        discord=c.discord,
        tags=sorted(t.tag for t in c.tags),
        status=c.status,
        vagas_total=c.vagas_total,
        vagas_restantes=vagas_restantes(c),
        mestre=UserPublic.model_validate(c.mestre),
        membros=[UserPublic.model_validate(m.user) for m in c.members],
        criado_em=c.criado_em,
        finalizada_em=c.finalizada_em,
    )


def get_campaign(db: Session, campaign_id: int, *, lock: bool = False) -> Campaign:
    stmt = select(Campaign).where(Campaign.id == campaign_id)
    if lock:
        stmt = stmt.with_for_update().execution_options(populate_existing=True)
    c = db.execute(stmt).scalar_one_or_none()
    if c is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Campanha não encontrada")
    return c


def require_mestre(c: Campaign, user: User) -> None:
    if c.mestre_id != user.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Apenas o mestre pode fazer isso")


def is_member(c: Campaign, user_id: int) -> bool:
    return any(m.user_id == user_id for m in c.members)


def require_participant(c: Campaign, user: User) -> None:
    if c.mestre_id != user.id and not is_member(c, user.id):
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Você não participa desta campanha")


def require_not_finished(c: Campaign) -> None:
    if c.status == CampaignStatus.finalizada:
        raise HTTPException(status.HTTP_409_CONFLICT, "Campanha já finalizada")


# ---- operações ------------------------------------------------------------
def create_campaign(db: Session, mestre: User, nome: str, descricao: str, discord: str,
                    vagas_total: int, tags: list[str]) -> Campaign:
    c = Campaign(
        mestre_id=mestre.id,
        nome=nome,
        descricao=descricao,
        discord=normalize_discord(discord),
        vagas_total=vagas_total,
        status=CampaignStatus.aberta,
    )
    c.tags = [CampaignTag(tag=t) for t in normalize_tags(tags)]
    db.add(c)
    db.flush()
    db.refresh(c)
    return c


def update_campaign(db: Session, c: Campaign, data: dict) -> None:
    require_not_finished(c)
    if "vagas_total" in data and data["vagas_total"] is not None:
        if data["vagas_total"] < len(c.members):
            raise HTTPException(
                status.HTTP_409_CONFLICT,
                f"A campanha já tem {len(c.members)} jogador(es); remova alguém antes de reduzir as vagas",
            )
        c.vagas_total = data["vagas_total"]
    for campo in ("nome", "descricao"):
        if data.get(campo) is not None:
            setattr(c, campo, data[campo])
    if data.get("discord") is not None:
        c.discord = normalize_discord(data["discord"])
    if data.get("tags") is not None:
        c.tags = [CampaignTag(tag=t) for t in normalize_tags(data["tags"])]
    refresh_status(c)


def send_invite(db: Session, c: Campaign, user: User) -> Invite:
    if c.mestre_id == user.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Essa campanha é sua")
    if c.status != CampaignStatus.aberta:
        raise HTTPException(status.HTTP_409_CONFLICT, "Campanha sem vagas ou finalizada")
    if is_member(c, user.id):
        raise HTTPException(status.HTTP_409_CONFLICT, "Você já participa desta campanha")
    pending = db.execute(
        select(Invite.id).where(
            Invite.campaign_id == c.id,
            Invite.user_id == user.id,
            Invite.status == InviteStatus.pendente,
        )
    ).first()
    if pending:
        raise HTTPException(status.HTTP_409_CONFLICT, "Você já enviou um convite")
    invite = Invite(campaign_id=c.id, user_id=user.id)
    db.add(invite)
    db.flush()
    db.refresh(invite)
    return invite


def accept_invite(db: Session, invite: Invite, mestre: User) -> Campaign:
    c = get_campaign(db, invite.campaign_id, lock=True)
    require_mestre(c, mestre)
    if invite.status != InviteStatus.pendente:
        raise HTTPException(status.HTTP_409_CONFLICT, "Convite já respondido")
    if c.status != CampaignStatus.aberta:
        raise HTTPException(status.HTTP_409_CONFLICT, "Campanha sem vagas ou finalizada")
    if is_member(c, invite.user_id):
        raise HTTPException(status.HTTP_409_CONFLICT, "Jogador já participa da campanha")
    c.members.append(CampaignMember(campaign_id=c.id, user_id=invite.user_id))
    invite.status = InviteStatus.aceito
    db.flush()
    db.refresh(c)
    refresh_status(c)
    return c


def reject_invite(invite: Invite, mestre: User) -> None:
    if invite.campaign.mestre_id != mestre.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Apenas o mestre pode fazer isso")
    if invite.status != InviteStatus.pendente:
        raise HTTPException(status.HTTP_409_CONFLICT, "Convite já respondido")
    invite.status = InviteStatus.recusado


def remove_member(db: Session, campaign_id: int, user_id: int) -> Campaign:
    """Usado tanto quando o jogador sai quanto quando o mestre o remove."""
    c = get_campaign(db, campaign_id, lock=True)
    require_not_finished(c)
    membro = next((m for m in c.members if m.user_id == user_id), None)
    if membro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Jogador não participa da campanha")
    c.members.remove(membro)
    db.flush()
    refresh_status(c)
    return c


def finish_campaign(c: Campaign) -> None:
    require_not_finished(c)
    c.status = CampaignStatus.finalizada
    c.finalizada_em = datetime.now(timezone.utc)
