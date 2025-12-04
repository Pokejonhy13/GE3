from pydantic import BaseModel, Field, ConfigDict
from datetime import datetime
from typing import Optional

class PaqueteBase(BaseModel):
    codigo: str = Field(..., min_length=3, max_length=50)
    descripcion: Optional[str] = Field(None, max_length=255)
    direccion_destino: str
    ciudad: Optional[str] = None
    estado_region: Optional[str] = None
    codigo_postal: Optional[str] = None
    nombre_destinatario: Optional[str] = None

class PaqueteCreate(PaqueteBase):
    pass

class PaqueteOut(PaqueteBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    creado_en: datetime
