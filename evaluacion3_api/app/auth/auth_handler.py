import os
from datetime import datetime, timedelta, timezone
from typing import Optional

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.database.connection import get_db
from app.models.agente_model import Agente

SECRET_KEY = os.getenv("SECRET_KEY", "CLAVE_SUPER_SECRETA")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))

pwd_context = CryptContext(schemes=["pbkdf2_sha256"], deprecated="auto")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, password_hash: str) -> bool:
    return pwd_context.verify(plain_password, password_hash)



def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + (
        expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def authenticate_agente(db: Session, email: str, password: str) -> Optional[Agente]:
    user = db.query(Agente).filter(Agente.email == email).first()
    if not user:
        return None
    if not verify_password(password, user.password_hash):
        return None
    return user


def get_current_agente(
    db: Session = Depends(get_db), token: str = Depends(oauth2_scheme)
) -> Agente:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="No se pudo validar el token",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = db.query(Agente).filter(Agente.email == email).first()
    if user is None or not user.is_active:
        raise credentials_exception
    return user
