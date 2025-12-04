from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.database.connection import get_db
from app.schemas.agente_schema import AgenteCreate, AgenteOut, TokenOut
from app.crud.agente_crud import create_agente
from app.auth.auth_handler import authenticate_agente, create_access_token, get_current_agente
from app.models.agente_model import Agente

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/register", response_model=AgenteOut, status_code=201)
def register_agente(agente_in: AgenteCreate, db: Session = Depends(get_db)):
    try:
        agente = create_agente(db, agente_in)
        return AgenteOut.model_validate(agente)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/login", response_model=TokenOut)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
):
    user = authenticate_agente(db, email=form_data.username, password=form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales inválidas",
        )
    access_token = create_access_token(data={"sub": user.email})
    return TokenOut(access_token=access_token, token_type="bearer")

@router.get("/me", response_model=AgenteOut)
def me(current: Agente = Depends(get_current_agente)):
    return AgenteOut.model_validate(current)
