from sqlalchemy import Column, Integer, String, Text, DateTime, func
from app.database.connection import Base

class Paquete(Base):
    __tablename__ = "paquetes"

    id = Column(Integer, primary_key=True, index=True)
    codigo = Column(String(50), unique=True, index=True, nullable=False)
    descripcion = Column(String(255), nullable=True)
    direccion_destino = Column(Text, nullable=False)
    ciudad = Column(String(100), nullable=True)
    estado_region = Column(String(100), nullable=True)
    codigo_postal = Column(String(20), nullable=True)
    nombre_destinatario = Column(String(100), nullable=True)
    creado_en = Column(DateTime, server_default=func.now(), nullable=False)
