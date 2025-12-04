from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.database.connection import Base, engine
from app.models import agente_model, paquete_model, entrega_model, evidencia_model
from app.routers import auth_routes, paquete_routes, entrega_routes, evidencia_routes

Base.metadata.create_all(bind=engine)

app = FastAPI(title="API Paquexpress")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Carpeta de fotos
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

# Routers
app.include_router(auth_routes.router)
app.include_router(paquete_routes.router)
app.include_router(entrega_routes.router)
app.include_router(evidencia_routes.router)
