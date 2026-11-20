from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy.orm import Session

from app import services as svc
from app.db import get_db
from app.deps import get_current_user
from app.models import Invite, User
from app.schemas import CampaignOut

router = APIRouter(prefix="/invites", tags=["invites"])


def _get_invite(db: Session, invite_id: int) -> Invite:
    invite = db.get(Invite, invite_id)
    if invite is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Convite não encontrado")
    return invite


@router.post("/{invite_id}/accept", response_model=CampaignOut)
def accept(invite_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    c = svc.accept_invite(db, _get_invite(db, invite_id), user)
    db.commit()
    return svc.to_out(c)


@router.post("/{invite_id}/reject", status_code=status.HTTP_204_NO_CONTENT)
def reject(invite_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    svc.reject_invite(_get_invite(db, invite_id), user)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
