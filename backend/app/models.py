import enum
from datetime import datetime, timezone

from sqlalchemy import (
    DateTime, Enum, ForeignKey, Index, Integer, String, Text, UniqueConstraint,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db import Base


def _now() -> datetime:
    return datetime.now(timezone.utc)


class CampaignStatus(str, enum.Enum):
    aberta = "aberta"          # antigo campanha.disable == True
    lotada = "lotada"          # antigo disable == False por falta de vagas
    finalizada = "finalizada"  # antigo documento em `finalizadas`


class InviteStatus(str, enum.Enum):
    pendente = "pendente"
    aceito = "aceito"
    recusado = "recusado"


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    nome: Mapped[str] = mapped_column(String(120))
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    senha_hash: Mapped[str] = mapped_column(String(255))
    avatar: Mapped[str] = mapped_column(String(255), default="avatar01.jpg")
    criado_em: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)


class Campaign(Base):
    """Une as antigas coleções `campanha`, `sessoes` e `finalizadas`."""

    __tablename__ = "campaigns"

    id: Mapped[int] = mapped_column(primary_key=True)
    mestre_id: Mapped[int] = mapped_column(ForeignKey("users.id"), index=True)
    nome: Mapped[str] = mapped_column(String(120))
    descricao: Mapped[str] = mapped_column(Text, default="")
    discord: Mapped[str] = mapped_column(String(255), default="")
    # Total de vagas de jogador. As vagas restantes são calculadas a partir dos membros.
    vagas_total: Mapped[int] = mapped_column(Integer)
    status: Mapped[CampaignStatus] = mapped_column(
        Enum(CampaignStatus), default=CampaignStatus.aberta, index=True
    )
    criado_em: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)
    finalizada_em: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    mestre: Mapped[User] = relationship(foreign_keys=[mestre_id])
    tags: Mapped[list["CampaignTag"]] = relationship(
        cascade="all, delete-orphan", lazy="selectin"
    )
    members: Mapped[list["CampaignMember"]] = relationship(
        cascade="all, delete-orphan", lazy="selectin"
    )


class CampaignTag(Base):
    __tablename__ = "campaign_tags"

    campaign_id: Mapped[int] = mapped_column(
        ForeignKey("campaigns.id", ondelete="CASCADE"), primary_key=True
    )
    tag: Mapped[str] = mapped_column(String(50), primary_key=True)


class CampaignMember(Base):
    """Substitui os arrays `players-id` / `players-name` de `sessoes`."""

    __tablename__ = "campaign_members"

    campaign_id: Mapped[int] = mapped_column(
        ForeignKey("campaigns.id", ondelete="CASCADE"), primary_key=True
    )
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), primary_key=True)
    entrou_em: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)

    user: Mapped[User] = relationship(lazy="joined")


class Invite(Base):
    __tablename__ = "invites"
    __table_args__ = (Index("ix_invites_campaign_user_status", "campaign_id", "user_id", "status"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    campaign_id: Mapped[int] = mapped_column(ForeignKey("campaigns.id", ondelete="CASCADE"))
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))  # quem pediu para entrar
    status: Mapped[InviteStatus] = mapped_column(Enum(InviteStatus), default=InviteStatus.pendente)
    criado_em: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now)

    campaign: Mapped[Campaign] = relationship(lazy="joined")
    user: Mapped[User] = relationship(lazy="joined")


class Message(Base):
    __tablename__ = "messages"

    id: Mapped[int] = mapped_column(primary_key=True)
    campaign_id: Mapped[int] = mapped_column(
        ForeignKey("campaigns.id", ondelete="CASCADE"), index=True
    )
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    texto: Mapped[str] = mapped_column(Text)
    criado_em: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_now, index=True)

    user: Mapped[User] = relationship(lazy="joined")
