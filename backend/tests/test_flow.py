import os

# Banco de teste isolado; precisa ser definido antes de importar a app.
os.environ["DATABASE_URL"] = "sqlite:///./test.db"

import pytest
from fastapi.testclient import TestClient

from app.db import Base, engine
from app.main import app


@pytest.fixture()
def client():
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(engine)
    with TestClient(app) as c:
        yield c


def signup(client, nome):
    r = client.post("/auth/register", json={"nome": nome, "email": f"{nome}@x.com", "senha": "segredo1"})
    assert r.status_code == 201, r.text
    return {"Authorization": f"Bearer {r.json()['access_token']}"}


def nova_campanha(client, h, vagas=1, tags=("Terror", "d&d")):
    r = client.post("/campaigns", headers=h, json={
        "nome": "Maldição", "descricao": "x", "discord": "discord.gg/abc",
        "vagas_total": vagas, "tags": list(tags)})
    assert r.status_code == 201, r.text
    return r.json()


def test_auth(client):
    signup(client, "ana")
    assert client.post("/auth/register", json={"nome": "a", "email": "ana@x.com", "senha": "segredo1"}).status_code == 409
    assert client.post("/auth/login", json={"email": "ana@x.com", "senha": "errada!"}).status_code == 401
    assert client.get("/me").status_code == 401


def test_full_flow(client):
    mestre, p1, p2 = signup(client, "mestre"), signup(client, "p1"), signup(client, "p2")

    c = nova_campanha(client, mestre, vagas=1)
    assert c["status"] == "aberta" and c["vagas_restantes"] == 1
    assert c["discord"] == "https://discord.gg/abc" and c["tags"] == ["d&d", "terror"]

    # pesquisa por tag (case-insensitive) e feed
    assert len(client.get("/campaigns", headers=p1, params={"q": "TERROR outra"}).json()) == 1
    assert client.get("/campaigns", headers=p1, params={"q": "comedia"}).json() == []

    # mestre não convida a si mesmo; jogador convida uma vez só
    assert client.post(f"/campaigns/{c['id']}/invites", headers=mestre).status_code == 403
    inv1 = client.post(f"/campaigns/{c['id']}/invites", headers=p1)
    assert inv1.status_code == 201
    assert client.post(f"/campaigns/{c['id']}/invites", headers=p1).status_code == 409
    inv2 = client.post(f"/campaigns/{c['id']}/invites", headers=p2).json()

    # só o mestre vê/responde convites
    assert len(client.get("/me/invites", headers=mestre).json()) == 2
    assert client.post(f"/invites/{inv1.json()['id']}/accept", headers=p2).status_code == 403

    # aceitar o 1º lota a campanha; o 2º já não cabe
    r = client.post(f"/invites/{inv1.json()['id']}/accept", headers=mestre)
    assert r.status_code == 200
    assert r.json()["status"] == "lotada" and r.json()["vagas_restantes"] == 0
    assert client.post(f"/invites/{inv2['id']}/accept", headers=mestre).status_code == 409
    assert client.get("/campaigns", headers=p2).json() == []  # sumiu do feed

    # telas "ativas" e "participando"
    assert len(client.get("/me/campaigns", headers=mestre, params={"papel": "mestre"}).json()) == 1
    assert len(client.get("/me/campaigns", headers=p1, params={"papel": "jogador"}).json()) == 1
    assert client.get("/me/campaigns", headers=p2, params={"papel": "jogador"}).json() == []

    # jogador sai -> campanha reabre
    r = client.post(f"/campaigns/{c['id']}/leave", headers=p1)
    assert r.json()["status"] == "aberta" and r.json()["vagas_restantes"] == 1

    # mestre recusa convite pendente; não dá para reduzir vagas abaixo dos membros
    assert client.post(f"/invites/{inv2['id']}/reject", headers=mestre).status_code == 204
    inv3 = client.post(f"/campaigns/{c['id']}/invites", headers=p2).json()
    client.post(f"/invites/{inv3['id']}/accept", headers=mestre)
    assert client.patch(f"/campaigns/{c['id']}", headers=mestre, json={"vagas_total": 2}).json()["status"] == "aberta"
    # mestre remove o jogador
    p2_id = client.get("/me", headers=p2).json()["id"]
    assert client.delete(f"/campaigns/{c['id']}/members/{p2_id}", headers=p1).status_code == 403
    assert client.delete(f"/campaigns/{c['id']}/members/{p2_id}", headers=mestre).status_code == 200

    # finalizar -> vai para o histórico e não aceita mais convites
    assert client.post(f"/campaigns/{c['id']}/finish", headers=p1).status_code == 403
    assert client.post(f"/campaigns/{c['id']}/finish", headers=mestre).json()["status"] == "finalizada"
    assert client.post(f"/campaigns/{c['id']}/invites", headers=p1).status_code == 409
    hist = client.get("/me/campaigns", headers=mestre, params={"finalizadas": True}).json()
    assert [x["id"] for x in hist] == [c["id"]]
    assert client.get("/me/campaigns", headers=mestre).json() == []


def test_reduce_slots_below_members_is_rejected(client):
    mestre, p1 = signup(client, "mestre"), signup(client, "p1")
    c = nova_campanha(client, mestre, vagas=2)
    inv = client.post(f"/campaigns/{c['id']}/invites", headers=p1).json()
    client.post(f"/invites/{inv['id']}/accept", headers=mestre)
    assert client.patch(f"/campaigns/{c['id']}", headers=mestre, json={"vagas_total": 1}).status_code == 200
    # 1 membro e 1 vaga -> lotada; reduzir para 0 é inválido (ge=1)
    assert client.patch(f"/campaigns/{c['id']}", headers=mestre, json={"vagas_total": 0}).status_code == 422


def test_delete_campaign_removes_everything(client):
    mestre, p1 = signup(client, "mestre"), signup(client, "p1")
    c = nova_campanha(client, mestre)
    client.post(f"/campaigns/{c['id']}/invites", headers=p1)
    assert client.delete(f"/campaigns/{c['id']}", headers=p1).status_code == 403
    assert client.delete(f"/campaigns/{c['id']}", headers=mestre).status_code == 204
    assert client.get(f"/campaigns/{c['id']}", headers=mestre).status_code == 404


def test_chat_websocket_and_history(client):
    mestre, p1, intruso = signup(client, "mestre"), signup(client, "p1"), signup(client, "intruso")
    c = nova_campanha(client, mestre, vagas=2)
    inv = client.post(f"/campaigns/{c['id']}/invites", headers=p1).json()
    client.post(f"/invites/{inv['id']}/accept", headers=mestre)

    tok = lambda h: h["Authorization"].split()[1]
    url = f"/ws/campaigns/{c['id']}/chat"

    # quem não participa não entra
    with pytest.raises(Exception):
        with client.websocket_connect(f"{url}?token={tok(intruso)}"):
            pass

    with client.websocket_connect(f"{url}?token={tok(mestre)}") as ws_m, \
         client.websocket_connect(f"{url}?token={tok(p1)}") as ws_p:
        ws_p.send_json({"texto": "Olá, mesa!"})
        assert ws_m.receive_json()["texto"] == "Olá, mesa!"
        assert ws_p.receive_json()["user"]["nome"] == "p1"

    hist = client.get(f"/campaigns/{c['id']}/messages", headers=mestre).json()
    assert [m["texto"] for m in hist] == ["Olá, mesa!"]
    assert client.get(f"/campaigns/{c['id']}/messages", headers=intruso).status_code == 403
