from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional

class EvidenciaOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    entrega_id: int
    ruta_foto: str
    descripcion_foto: Optional[str]
    latitude: float
    longitude: float
    direccion_texto: Optional[str]
    creado_en: datetime
