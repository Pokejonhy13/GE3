from sqlalchemy.orm import Session
from typing import Optional, List
from app.models.agente_model import Agente
from app.schemas.agente_schema import AgenteCreate
from app.auth.auth_handler import get_password_hash

def get_agente_by_id(db: Session, agente_id: int) -> Optional[Agente]:
    return db.query(Agente).filter(Agente.id == agente_id).first()

def get_agente_by_email(db: Session, email: str) -> Optional[Agente]:
    return db.query(Agente).filter(Agente.email == email).first()

def create_agente(db: Session, data: AgenteCreate) -> Agente:
    exists = get_agente_by_email(db, data.email)
    if exists:
        raise ValueError("El email ya está registrado")
    agente = Agente(
        nombre=data.nombre,
        email=data.email,
        password_hash=get_password_hash(data.password),
    )
    db.add(agente)
    db.commit()
    db.refresh(agente)
    return agente

def list_agentes(db: Session, skip: int = 0, limit: int = 50) -> List[Agente]:
    return db.query(Agente).offset(skip).limit(limit).all()
