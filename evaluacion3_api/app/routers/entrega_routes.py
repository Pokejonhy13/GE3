from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.database.connection import get_db
from app.schemas.entrega_schema import EntregaCreate, EntregaOut
from app.crud.entrega_crud import (
    create_entrega,
    list_entregas_por_agente,
    marcar_entrega_completada,
)
from app.auth.auth_handler import get_current_agente
from app.models.agente_model import Agente

router = APIRouter(prefix="/entregas", tags=["entregas"])

@router.post("/", response_model=EntregaOut, status_code=201)
def asignar_entrega(
    data: EntregaCreate,
    db: Session = Depends(get_db),
    _: Agente = Depends(get_current_agente),
):
    entrega = create_entrega(db, data)
    return EntregaOut.model_validate(entrega)

@router.get("/asignadas", response_model=List[EntregaOut])
def entregas_asignadas(
    db: Session = Depends(get_db),
    current: Agente = Depends(get_current_agente),
):
    entregas = list_entregas_por_agente(db, current.id)
    return [EntregaOut.model_validate(e) for e in entregas]

@router.post("/{entrega_id}/completar", response_model=EntregaOut)
def completar_entrega(
    entrega_id: int,
    db: Session = Depends(get_db),
    current: Agente = Depends(get_current_agente),
):
    entrega = marcar_entrega_completada(db, entrega_id)
    if not entrega or entrega.agente_id != current.id:
        raise HTTPException(status_code=404, detail="Entrega no encontrada")
    return EntregaOut.model_validate(entrega)
