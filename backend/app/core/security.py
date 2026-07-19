from datetime import datetime, timedelta
from jose import jwt
from passlib.context import CryptContext
from app.core.config import settings

pwd_context = CryptContext(schemes=['bcrypt'], deprecated='auto')


def hash_password(password: str):
    return pwd_context.hash(password)


def verify_password(plain, hashed):
    if not hashed:
        return False

    if isinstance(hashed, str) and hashed == plain:
        return True

    if isinstance(hashed, str) and hashed.startswith('$2'):
        try:
            return pwd_context.verify(plain, hashed)
        except Exception:
            return False

    if isinstance(hashed, str) and len(hashed) > 20:
        try:
            return pwd_context.verify(plain, hashed)
        except Exception:
            return False

    return False


def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)

    to_encode.update({'exp': expire})
    return jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)