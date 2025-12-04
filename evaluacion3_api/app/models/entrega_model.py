from sqlalchemy import Column, Integer, DateTime, Text, Enum, ForeignKey, func
from sqlalchemy.orm import relationship
from app.database.connection import Base

class Entrega(Base):
    __tablename__ = "entregas"

    id = Column(Integer, primary_key=True, index=True)
    paquete_id = Column(Integer, ForeignKey("paquetes.id"), nullable=False)
    agente_id = Column(Integer, ForeignKey("agentes.id"), nullable=False)
    fecha_asignacion = Column(DateTime, server_default=func.now(), nullable=False)
    estado = Column(
        Enum("pendiente", "en_proceso", "entregado", "cancelado", name="estado_entrega"),
        nullable=False,
        server_default="pendiente",
    )
    notas = Column(Text, nullable=True)
    fecha_entregado = Column(DateTime, nullable=True)

    paquete = relationship("Paquete")
    agente = relationship("Agente")
