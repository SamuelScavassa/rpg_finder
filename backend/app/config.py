import os

_DEV_SECRET = "dev-only-secret-change-me-in-production-0123456789"

DATABASE_URL = os.environ.get("DATABASE_URL", "sqlite:///./dev.db")
JWT_SECRET = os.environ.get("JWT_SECRET", _DEV_SECRET)
JWT_ALGORITHM = "HS256"
JWT_EXPIRE_MINUTES = int(os.environ.get("JWT_EXPIRE_MINUTES", "60"))
CORS_ORIGINS = [o for o in os.environ.get("CORS_ORIGINS", "http://localhost:5173").split(",") if o]

# Em produção (APP_ENV=production) o servidor se recusa a subir com segredo fraco.
if os.environ.get("APP_ENV") == "production" and (JWT_SECRET == _DEV_SECRET or len(JWT_SECRET) < 32):
    raise RuntimeError("Defina JWT_SECRET com pelo menos 32 caracteres aleatórios")
