from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app import config, models  # noqa: F401  (models registra as tabelas em Base.metadata)
from app.db import Base, engine
from app.routers import auth, campaigns, chat, invites, users


@asynccontextmanager
async def lifespan(_: FastAPI):
    # Conveniente em desenvolvimento. Em produção, trocar por migrações (Alembic).
    Base.metadata.create_all(engine)
    yield


app = FastAPI(title="RPG Finder API", lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=config.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
for r in (auth.router, users.router, campaigns.router, invites.router, chat.router):
    app.include_router(r)


@app.get("/health", tags=["meta"])
def health():
    return {"status": "ok"}
