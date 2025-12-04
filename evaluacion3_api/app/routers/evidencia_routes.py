from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from typing import Optional
import os
import shutil
import requests

from app.database.connection import get_db
from app.schemas.evidencia_schema import EvidenciaOut
from app.crud.evidencia_crud import crear_evidencia
from app.crud.entrega_crud import marcar_entrega_completada
from app.auth.auth_handler import get_current_agente
from app.models.agente_model import Agente

router = APIRouter(prefix="/evidencias", tags=["evidencias"])

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("/entrega", response_model=EvidenciaOut)
async def registrar_evidencia_entrega(
    entrega_id: int = Form(...),
    latitude: float = Form(...),
    longitude: float = Form(...),
    descripcion_foto: Optional[str] = Form(None),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current: Agente = Depends(get_current_agente),
):
    # Guardar archivo foto
    filename = file.filename
    file_path = os.path.join(UPLOAD_DIR, filename)

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Reverse geocoding con Nominatim
    try:
        url = (
            f"https://nominatim.openstreetmap.org/reverse"
            f"?format=json&lat={latitude}&lon={longitude}"
        )
        headers = {"User-Agent": "PaquexpressApp/1.0"}
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            direccion = response.json().get("display_name", "Dirección no disponible")
        else:
            direccion = "Error al obtener dirección"
    except Exception:
        direccion = None

    # Crear registro de evidencia
    evidencia = crear_evidencia(
        db=db,
        entrega_id=entrega_id,
        ruta_foto=file_path,
        descripcion_foto=descripcion_foto,
        latitude=latitude,
        longitude=longitude,
        direccion_texto=direccion,
    )

    # Marcar entrega como completada
    marcar_entrega_completada(db, entrega_id)

    return EvidenciaOut.model_validate(evidencia)
