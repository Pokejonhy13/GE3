from sqlalchemy.orm import Session
from app.models.evidencia_model import EvidenciaEntrega

def crear_evidencia(
    db: Session,
    entrega_id: int,
    ruta_foto: str,
    descripcion_foto: str | None,
    latitude: float,
    longitude: float,
    direccion_texto: str | None,
) -> EvidenciaEntrega:
    ev = EvidenciaEntrega(
        entrega_id=entrega_id,
        ruta_foto=ruta_foto,
        descripcion_foto=descripcion_foto,
        latitude=latitude,
        longitude=longitude,
        direccion_texto=direccion_texto,
    )
    db.add(ev)
    db.commit()
    db.refresh(ev)
    return ev
