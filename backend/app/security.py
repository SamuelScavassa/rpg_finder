from datetime import datetime, timedelta, timezone

import bcrypt
import jwt

from app import config


def hash_password(senha: str) -> str:
    return bcrypt.hashpw(senha.encode()[:72], bcrypt.gensalt()).decode()


def verify_password(senha: str, senha_hash: str) -> bool:
    return bcrypt.checkpw(senha.encode()[:72], senha_hash.encode())


def create_token(user_id: int, minutes: int | None = None, purpose: str = "access") -> str:
    exp = datetime.now(timezone.utc) + timedelta(minutes=minutes or config.JWT_EXPIRE_MINUTES)
    return jwt.encode(
        {"sub": str(user_id), "exp": exp, "purpose": purpose},
        config.JWT_SECRET,
        algorithm=config.JWT_ALGORITHM,
    )


def decode_token(token: str, purpose: str = "access") -> int | None:
    try:
        data = jwt.decode(token, config.JWT_SECRET, algorithms=[config.JWT_ALGORITHM])
    except jwt.PyJWTError:
        return None
    if data.get("purpose") != purpose:
        return None
    try:
        return int(data["sub"])
    except (KeyError, ValueError):
        return None
