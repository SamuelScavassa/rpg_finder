# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository layout

RPG Finder helps tabletop RPG players find campaigns. Game masters ("mestres") post campaigns, players search by tag and request to join, and members chat. The repo holds three projects; code identifiers, API fields and UI text are in Portuguese.

- `backend/`: **current** API (FastAPI + SQLAlchemy 2, PostgreSQL in production, SQLite in dev/tests).
- `frontend/`: **current** web client (React 18 + TypeScript + Vite + React Router).
- `rpg_finder/`: the **legacy** Flutter + Firebase app that the two projects above replace. It is kept as reference and has its own [CLAUDE.md](rpg_finder/CLAUDE.md). Do not extend it. `RPG-Finder.pdf` is the original project spec.

Decided out of scope: e-mail password recovery and migrating existing Firestore data. Don't add them back unprompted.

## Commands

Backend (run from `backend/`; needs `python3-venv`):

```bash
python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
uvicorn app.main:app --reload            # API on :8000, docs at /docs
pytest -v                                # SQLite test.db, no Postgres needed
pytest tests/test_flow.py::test_full_flow   # single test
docker compose up -d                     # (in backend/) optional dev Postgres; set DATABASE_URL (see .env.example)
```

Frontend (run from `frontend/`; needs Node 18+):

```bash
npm install && cp .env.example .env      # VITE_API_URL=http://localhost:8000
npm run dev                              # :5173 (the backend's default CORS origin)
npm run build                            # tsc --noEmit, then vite build; there is no test or lint setup
```

Full stack (from the repo root; `.env` from `.env.example`, `DOMAIN=:80` for local HTTP): `docker compose up -d --build`, then http://localhost (API under `/api`). See `DEPLOY.md`.

## Backend architecture

- `app/models.py` defines the schema. Tables are created at startup with `create_all`; there are no migrations yet.
- `app/services.py` holds **all campaign business rules** (invite, accept, leave, kick, finish, status refresh). Routers in `app/routers/` stay thin: they authenticate, call a service and `commit()`. Put new rules in the services, not in the routers.
- Status is derived, not stored independently: `Campaign.status` is `aberta`/`lotada`/`finalizada`, and `vagas_restantes = vagas_total - len(members)` is computed. Always call `refresh_status` after changing members or `vagas_total`.
- Operations that change membership load the campaign with `get_campaign(..., lock=True)` (`SELECT … FOR UPDATE`) to stop concurrent accepts from overfilling. SQLite ignores the lock, so pytest cannot prove it. It was verified against the Docker Postgres stack: 6 simultaneous accepts on a 1-slot campaign gave exactly one 200 and five 409s, over 3 rounds.
- Deleting a campaign explicitly deletes its messages and invites first, because SQLite doesn't enforce `ON DELETE CASCADE`.
- Chat (`app/routers/chat.py`): WebSocket at `/ws/campaigns/{id}/chat?token=<JWT>`; history is `GET /campaigns/{id}/messages`. Rooms live in process memory, so running several instances would need a broker such as Redis.
- Auth is JWT bearer (`app/security.py`, `app/deps.py`). `JWT_SECRET`, `DATABASE_URL` and `CORS_ORIGINS` come from the environment (`app/config.py`).
- `backend/README.md` has a table mapping every old Firestore/Dart function to its endpoint.

## Frontend architecture

- `src/api.ts` is the only place that talks to the backend: typed `api.*` functions mirroring `app/schemas.py`, the token kept in `localStorage`, and `chatUrl()` for the WebSocket. Keep its types in sync with the Pydantic schemas by hand; nothing generates them.
- `src/auth.tsx` provides the session context; `components/Layout.tsx` is the guard for all private routes (redirects to `/login`).
- `src/hooks.ts` `useLoad` is the data-fetching pattern used by the pages (no data-fetching library).
- `pages/CampaignDetail.tsx` is one screen whose actions depend on the viewer's role (visitor, member or mestre), replacing three Flutter screens.

## Gotchas

- In the legacy Firestore model `disable: true` meant "open" and `players` meant "slots remaining". The new model uses `status` and `vagas_total`; don't carry those names over.
- The frontend type-checks and builds (verified through `docker compose build`; there is still no Node on the dev machine, so builds go through Docker).
- SQLite returns datetimes without a timezone, while Postgres returns them with one; the chat time in the UI is only reliable on Postgres.
