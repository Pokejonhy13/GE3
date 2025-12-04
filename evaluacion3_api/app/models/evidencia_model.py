from sqlalchemy import Column, Integer, String, Text, DECIMAL, TIMESTAMP, ForeignKey, func
from sqlalchemy.orm import relationship
from app.database.connection import Base

class EvidenciaEntrega(Base):
    __tablename__ = "evidencias_entrega"

    id = Column(Integer, primary_key=True, index=True)
    entrega_id = Column(Integer, ForeignKey("entregas.id"), nullable=False)
    ruta_foto = Column(String(255), nullable=False)
    descripcion_foto = Column(String(255), nullable=True)
    latitude = Column(DECIMAL(10, 8), nullable=False)
    longitude = Column(DECIMAL(11, 8), nullable=False)
    direccion_texto = Column(Text, nullable=True)
    creado_en = Column(TIMESTAMP, server_default=func.now(), nullable=False)

    entrega = relationship("Entrega")
