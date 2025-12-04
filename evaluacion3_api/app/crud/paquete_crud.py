from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.paquete_model import Paquete
from app.schemas.paquete_schema import PaqueteCreate

def create_paquete(db: Session, data: PaqueteCreate) -> Paquete:
    paquete = Paquete(**data.model_dump())
    db.add(paquete)
    db.commit()
    db.refresh(paquete)
    return paquete

def get_paquete(db: Session, paquete_id: int) -> Optional[Paquete]:
    return db.query(Paquete).filter(Paquete.id == paquete_id).first()

def get_paquete_by_codigo(db: Session, codigo: str) -> Optional[Paquete]:
    return db.query(Paquete).filter(Paquete.codigo == codigo).first()

def list_paquetes(db: Session, skip: int = 0, limit: int = 50) -> List[Paquete]:
    return db.query(Paquete).offset(skip).limit(limit).all()
