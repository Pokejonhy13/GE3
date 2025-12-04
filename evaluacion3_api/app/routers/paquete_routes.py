from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.database.connection import get_db
from app.schemas.paquete_schema import PaqueteCreate, PaqueteOut
from app.crud.paquete_crud import create_paquete, list_paquetes, get_paquete
from app.auth.auth_handler import get_current_agente
from app.models.agente_model import Agente

router = APIRouter(prefix="/paquetes", tags=["paquetes"])

@router.post("/", response_model=PaqueteOut, status_code=201)
def crear_paquete(
    data: PaqueteCreate,
    db: Session = Depends(get_db),
    _: Agente = Depends(get_current_agente),
):
    paquete = create_paquete(db, data)
    return PaqueteOut.model_validate(paquete)

@router.get("/", response_model=List[PaqueteOut])
def listar_paquetes(
    db: Session = Depends(get_db),
    _: Agente = Depends(get_current_agente),
):
    return [PaqueteOut.model_validate(p) for p in list_paquetes(db)]

@router.get("/{paquete_id}", response_model=PaqueteOut)
def obtener_paquete(
    paquete_id: int,
    db: Session = Depends(get_db),
    _: Agente = Depends(get_current_agente),
):
    p = get_paquete(db, paquete_id)
    if not p:
        raise HTTPException(status_code=404, detail="Paquete no encontrado")
    return PaqueteOut.model_validate(p)
