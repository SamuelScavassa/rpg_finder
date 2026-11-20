from datetime import datetime

from pydantic import BaseModel, ConfigDict, EmailStr, Field

from app.models import CampaignStatus, InviteStatus


class ORM(BaseModel):
    model_config = ConfigDict(from_attributes=True)


# ---- usuários -------------------------------------------------------------
class RegisterIn(BaseModel):
    nome: str = Field(min_length=1, max_length=120)
    email: EmailStr
    senha: str = Field(min_length=6, max_length=128)


class LoginIn(BaseModel):
    email: EmailStr
    senha: str


class TokenOut(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserPublic(ORM):
    id: int
    nome: str
    avatar: str


class UserMe(UserPublic):
    email: EmailStr


class UserUpdate(BaseModel):
    nome: str | None = Field(default=None, min_length=1, max_length=120)
    email: EmailStr | None = None
    avatar: str | None = Field(default=None, max_length=255)


# ---- campanhas ------------------------------------------------------------
class CampaignIn(BaseModel):
    nome: str = Field(min_length=1, max_length=120)
    descricao: str = ""
    discord: str = ""
    vagas_total: int = Field(ge=1, le=100)
    tags: list[str] = []


class CampaignUpdate(BaseModel):
    nome: str | None = Field(default=None, min_length=1, max_length=120)
    descricao: str | None = None
    discord: str | None = None
    vagas_total: int | None = Field(default=None, ge=1, le=100)
    tags: list[str] | None = None


class CampaignOut(BaseModel):
    id: int
    nome: str
    descricao: str
    discord: str
    tags: list[str]
    status: CampaignStatus
    vagas_total: int
    vagas_restantes: int
    mestre: UserPublic
    membros: list[UserPublic]
    criado_em: datetime
    finalizada_em: datetime | None


# ---- convites -------------------------------------------------------------
class InviteOut(BaseModel):
    id: int
    status: InviteStatus
    campaign_id: int
    campaign_nome: str
    user: UserPublic
    criado_em: datetime


# ---- chat -----------------------------------------------------------------
class MessageIn(BaseModel):
    texto: str = Field(min_length=1, max_length=2000)


class MessageOut(BaseModel):
    id: int
    campaign_id: int
    user: UserPublic
    texto: str
    criado_em: datetime
