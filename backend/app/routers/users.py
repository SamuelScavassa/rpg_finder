from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import get_current_user
from app.models import Campaign, CampaignMember, CampaignStatus, Invite, InviteStatus, User
from app.schemas import CampaignOut, InviteOut, UserMe, UserPublic, UserUpdate
from app.services import to_out

router = APIRouter(prefix="/me", tags=["me"])


@router.get("", response_model=UserMe)
def me(user: User = Depends(get_current_user)):
    return user


@router.patch("", response_model=UserMe)
def update_me(data: UserUpdate, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if data.email and data.email.lower() != user.email:
        taken = db.execute(select(User.id).where(User.email == data.email.lower())).first()
        if taken:
            raise HTTPException(status.HTTP_409_CONFLICT, "E-mail já cadastrado")
        user.email = data.email.lower()
    if data.nome:
        user.nome = data.nome
    if data.avatar:
        user.avatar = data.avatar
    db.commit()
    return user


@router.get("/campaigns", response_model=list[CampaignOut])
def my_campaigns(
    papel: str | None = Query(None, pattern="^(mestre|jogador)$"),
    finalizadas: bool = False,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Telas antigas: 'ativas' = papel=mestre; 'participando' = papel=jogador;
    'histórico' = finalizadas=true."""
    como_mestre = Campaign.mestre_id == user.id
    como_jogador = Campaign.id.in_(
        select(CampaignMember.campaign_id).where(CampaignMember.user_id == user.id)
    )
    cond = {"mestre": como_mestre, "jogador": como_jogador}.get(papel, or_(como_mestre, como_jogador))
    stmt = select(Campaign).where(cond)
    if finalizadas:
        stmt = stmt.where(Campaign.status == CampaignStatus.finalizada).order_by(Campaign.finalizada_em.desc())
    else:
        stmt = stmt.where(Campaign.status != CampaignStatus.finalizada).order_by(Campaign.criado_em.desc())
    return [to_out(c) for c in db.execute(stmt).scalars().unique()]


@router.get("/invites", response_model=list[InviteOut])
def invites_received(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    """Convites pendentes nas campanhas em que sou mestre (tela 'convites')."""
    stmt = (
        select(Invite)
        .join(Campaign, Invite.campaign_id == Campaign.id)
        .where(Campaign.mestre_id == user.id, Invite.status == InviteStatus.pendente)
        .order_by(Invite.criado_em)
    )
    return [
        InviteOut(
            id=i.id, status=i.status, campaign_id=i.campaign_id,
            campaign_nome=i.campaign.nome, user=UserPublic.model_validate(i.user),
            criado_em=i.criado_em,
        )
        for i in db.execute(stmt).scalars().unique()
    ]
