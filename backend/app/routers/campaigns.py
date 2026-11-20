from fastapi import APIRouter, Depends, Query, Response, status
from sqlalchemy import delete, select
from sqlalchemy.orm import Session

from app import services as svc
from app.db import get_db
from app.deps import get_current_user
from app.models import Campaign, CampaignStatus, CampaignTag, Invite, Message, User
from app.schemas import (
    CampaignIn, CampaignOut, CampaignUpdate, InviteOut, MessageOut, UserPublic,
)

router = APIRouter(prefix="/campaigns", tags=["campaigns"])


@router.get("", response_model=list[CampaignOut])
def list_campaigns(
    q: str | None = Query(None, description="Palavras separadas por espaço; casa com qualquer tag"),
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0),
    _: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Feed e pesquisa: apenas campanhas abertas (antigo `disable == true`)."""
    stmt = select(Campaign).where(Campaign.status == CampaignStatus.aberta)
    if q:
        palavras = [p for p in q.lower().split() if p]
        if palavras:
            stmt = stmt.where(
                Campaign.id.in_(select(CampaignTag.campaign_id).where(CampaignTag.tag.in_(palavras)))
            )
    stmt = stmt.order_by(Campaign.criado_em.desc()).limit(limit).offset(offset)
    return [svc.to_out(c) for c in db.execute(stmt).scalars().unique()]


@router.post("", response_model=CampaignOut, status_code=status.HTTP_201_CREATED)
def create_campaign(data: CampaignIn, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    c = svc.create_campaign(db, user, data.nome, data.descricao, data.discord, data.vagas_total, data.tags)
    db.commit()
    return svc.to_out(c)


@router.get("/{campaign_id}", response_model=CampaignOut)
def get_campaign(campaign_id: int, _: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return svc.to_out(svc.get_campaign(db, campaign_id))


@router.patch("/{campaign_id}", response_model=CampaignOut)
def update_campaign(campaign_id: int, data: CampaignUpdate, user: User = Depends(get_current_user),
                    db: Session = Depends(get_db)):
    c = svc.get_campaign(db, campaign_id, lock=True)
    svc.require_mestre(c, user)
    svc.update_campaign(db, c, data.model_dump(exclude_unset=True))
    db.commit()
    return svc.to_out(c)


@router.delete("/{campaign_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_campaign(campaign_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    c = svc.get_campaign(db, campaign_id, lock=True)
    svc.require_mestre(c, user)
    # Explícito para não depender de ON DELETE CASCADE (SQLite não aplica por padrão).
    db.execute(delete(Message).where(Message.campaign_id == c.id))
    db.execute(delete(Invite).where(Invite.campaign_id == c.id))
    db.delete(c)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)


# ---- convites -------------------------------------------------------------
@router.post("/{campaign_id}/invites", response_model=InviteOut, status_code=status.HTTP_201_CREATED)
def send_invite(campaign_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    c = svc.get_campaign(db, campaign_id, lock=True)
    invite = svc.send_invite(db, c, user)
    db.commit()
    return InviteOut(
        id=invite.id, status=invite.status, campaign_id=c.id, campaign_nome=c.nome,
        user=UserPublic.model_validate(user), criado_em=invite.criado_em,
    )


# ---- membros --------------------------------------------------------------
@router.post("/{campaign_id}/leave", response_model=CampaignOut)
def leave(campaign_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    c = svc.remove_member(db, campaign_id, user.id)
    db.commit()
    return svc.to_out(c)


@router.delete("/{campaign_id}/members/{user_id}", response_model=CampaignOut)
def kick(campaign_id: int, user_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    svc.require_mestre(svc.get_campaign(db, campaign_id), user)
    c = svc.remove_member(db, campaign_id, user_id)
    db.commit()
    return svc.to_out(c)


@router.post("/{campaign_id}/finish", response_model=CampaignOut)
def finish(campaign_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    c = svc.get_campaign(db, campaign_id, lock=True)
    svc.require_mestre(c, user)
    svc.finish_campaign(c)
    db.commit()
    return svc.to_out(c)


# ---- chat (histórico; envio e tempo real via WebSocket) -------------------
@router.get("/{campaign_id}/messages", response_model=list[MessageOut])
def messages(
    campaign_id: int,
    limit: int = Query(100, ge=1, le=500),
    before_id: int | None = None,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    svc.require_participant(svc.get_campaign(db, campaign_id), user)
    stmt = select(Message).where(Message.campaign_id == campaign_id)
    if before_id:
        stmt = stmt.where(Message.id < before_id)
    rows = db.execute(stmt.order_by(Message.id.desc()).limit(limit)).scalars().unique().all()
    return [message_out(m) for m in reversed(rows)]


def message_out(m: Message) -> MessageOut:
    return MessageOut(
        id=m.id, campaign_id=m.campaign_id, user=UserPublic.model_validate(m.user),
        texto=m.texto, criado_em=m.criado_em,
    )
