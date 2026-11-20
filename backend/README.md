# RPG Finder — API

FastAPI + SQLAlchemy 2 + PostgreSQL. Substitui o Firebase (Auth + Firestore) do app Flutter.

## Rodando

```bash
sudo apt install python3.12-venv        # se o módulo venv não existir
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

docker compose up -d                    # Postgres (opcional: sem DATABASE_URL usa SQLite dev.db)
cp .env.example .env && export $(grep -v '^#' .env | xargs)

uvicorn app.main:app --reload           # docs em http://localhost:8000/docs
pytest                                  # usa SQLite (test.db), não precisa do Postgres
```

As tabelas são criadas no startup (`create_all`). Antes de ir para produção, adicionar Alembic.

## Mapa Firestore → API

| Antes (Flutter / Firestore)                         | Agora                                                      |
|-----------------------------------------------------|------------------------------------------------------------|
| `createUser`, `userLogin`                           | `POST /auth/register`, `POST /auth/login` (JWT)            |
| `updateUser`, coleção `usuario`                     | `GET/PATCH /me`                                            |
| `salvarCampanha` (`campanha` + `sessoes`)           | `POST /campaigns` (uma única tabela)                       |
| feed (`campanha where disable == true`)            | `GET /campaigns`                                           |
| `procurar` (tags `arrayContainsAny`)                | `GET /campaigns?q=terror dnd`                              |
| `atualizarCampanha`                                 | `PATCH /campaigns/{id}`                                    |
| `deletarCampanha`                                   | `DELETE /campaigns/{id}`                                   |
| `enviarConvite`                                     | `POST /campaigns/{id}/invites`                             |
| tela convites                                       | `GET /me/invites`                                          |
| `aceitarConvite` / `negarConvite`                   | `POST /invites/{id}/accept` / `/reject`                    |
| `sairCampanha`                                      | `POST /campaigns/{id}/leave`                               |
| `retirarUserCampanha`                               | `DELETE /campaigns/{id}/members/{user_id}`                 |
| `finalizarCampanha` (+ coleção `finalizadas`)       | `POST /campaigns/{id}/finish` (muda o status)              |
| telas ativas / participando / histórico             | `GET /me/campaigns?papel=mestre\|jogador&finalizadas=bool` |
| `chat` (StreamBuilder)                              | `WS /ws/campaigns/{id}/chat?token=…` + `GET …/messages`    |

## Mudanças de modelo (de propósito)

- `disable` (invertido) e `players` (vagas restantes) foram substituídos por `status`
  (`aberta` / `lotada` / `finalizada`) e `vagas_total`; `vagas_restantes` é calculado.
- `sessoes` e `finalizadas` deixam de existir: são a própria campanha com `status`.
- `players-id` / `players-name` viraram a tabela `campaign_members` (sem nomes duplicados).
- Convites ficam registrados com status (`pendente`/`aceito`/`recusado`) em vez de serem apagados.
- Aceitar convite, sair, remover e finalizar rodam numa transação, com a campanha travada
  (`SELECT … FOR UPDATE`), o que evita estourar vagas com aceites simultâneos.
- Ao finalizar, as mensagens do chat **são mantidas** (o app antigo as apagava). O WebSocket
  não aceita novas conexões em campanhas finalizadas.

## Pendências conhecidas

- Não há recuperação de senha por e-mail (decisão do projeto).
- Migrações com Alembic e migração dos dados existentes do Firestore.
- Chat com várias instâncias do servidor exige Redis pub/sub (as salas ficam em memória).
- Rate limiting no login.
