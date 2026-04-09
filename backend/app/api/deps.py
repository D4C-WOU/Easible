from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from jose import jwt
from app.core.config import settings

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

def get_current_user(token: str = Depends(oauth2_scheme)):  # ✅ FIX
    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=[settings.ALGORITHM]
        )
        return payload
    except:
        raise HTTPException(status_code=401, detail='Invalid token')


def get_current_admin(token: dict = Depends(get_current_user)):
    if token.get("role") != 'admin':
        raise HTTPException(
            status_code=403,
            detail='Restricted Area: only admins are allowed'
        )
    return token
def get_db():
  db = SessionLocal()
  try:
    yield db
  finally:
    db.close()
      