from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional
from app.schemas.paquete_schema import PaqueteOut

class EntregaBase(BaseModel):
    paquete_id: int
    agente_id: int

class EntregaCreate(EntregaBase):
    notas: Optional[str] = None

class EntregaOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    paquete_id: int
    agente_id: int
    fecha_asignacion: datetime
    estado: str
    notas: Optional[str]
    fecha_entregado: Optional[datetime]
    paquete: Optional[PaqueteOut] = None
