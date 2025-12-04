from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.entrega_model import Entrega
from app.schemas.entrega_schema import EntregaCreate
from datetime import datetime

def create_entrega(db: Session, data: EntregaCreate) -> Entrega:
    entrega = Entrega(
        paquete_id=data.paquete_id,
        agente_id=data.agente_id,
        notas=data.notas,
    )
    db.add(entrega)
    db.commit()
    db.refresh(entrega)
    return entrega

def list_entregas_por_agente(db: Session, agente_id: int) -> List[Entrega]:
    return (
        db.query(Entrega)
        .filter(Entrega.agente_id == agente_id)
        .all()
    )

def marcar_entrega_completada(db: Session, entrega_id: int) -> Optional[Entrega]:
    entrega = db.query(Entrega).filter(Entrega.id == entrega_id).first()
    if not entrega:
        return None
    entrega.estado = "entregado"
    entrega.fecha_entregado = datetime.utcnow()
    db.commit()
    db.refresh(entrega)
    return entrega
