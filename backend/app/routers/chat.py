"""Chat em tempo real por campanha (substitui o StreamBuilder em `chat`).

Conexão: ws://host/ws/campaigns/{id}/chat?token=<JWT>
Cliente envia:  {"texto": "olá"}
Servidor envia: MessageOut (JSON) para todos os conectados da campanha.

Os conectados ficam em memória: com mais de um processo/instância é preciso um
broker (ex.: Redis pub/sub) para distribuir as mensagens entre eles.
"""
from collections import defaultdict

from fastapi import APIRouter, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.concurrency import run_in_threadpool
from fastapi.encoders import jsonable_encoder

from app import services as svc
from app.db import SessionLocal
from app.models import CampaignStatus, Message, User
from app.routers.campaigns import message_out
from app.security import decode_token

router = APIRouter(tags=["chat"])
_rooms: dict[int, set[WebSocket]] = defaultdict(set)


def _authorize(campaign_id: int, token: str | None) -> int | None:
    """Retorna o id do usuário se ele puder participar do chat, senão None."""
    user_id = decode_token(token) if token else None
    if not user_id:
        return None
    with SessionLocal() as db:
        user = db.get(User, user_id)
        if user is None:
            return None
        try:
            c = svc.get_campaign(db, campaign_id)
            svc.require_participant(c, user)
        except HTTPException:
            return None
        return None if c.status == CampaignStatus.finalizada else user.id


def _save(campaign_id: int, user_id: int, texto: str) -> dict:
    with SessionLocal() as db:
        m = Message(campaign_id=campaign_id, user_id=user_id, texto=texto)
        db.add(m)
        db.commit()
        db.refresh(m)
        return jsonable_encoder(message_out(m))


@router.websocket("/ws/campaigns/{campaign_id}/chat")
async def chat(ws: WebSocket, campaign_id: int, token: str | None = None):
    user_id = await run_in_threadpool(_authorize, campaign_id, token)
    if user_id is None:
        await ws.close(code=4401)
        return
    await ws.accept()
    _rooms[campaign_id].add(ws)
    try:
        while True:
            data = await ws.receive_json()
            texto = str(data.get("texto", "")).strip()[:2000]
            if not texto:
                continue
            payload = await run_in_threadpool(_save, campaign_id, user_id, texto)
            for peer in list(_rooms[campaign_id]):
                try:
                    await peer.send_json(payload)
                except Exception:
                    _rooms[campaign_id].discard(peer)
    except WebSocketDisconnect:
        pass
    finally:
        _rooms[campaign_id].discard(ws)
