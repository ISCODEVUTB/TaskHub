from fastapi import FastAPI
from src.routes.document_routes import router as document_router
from database import Base, engine

# Crear tablas
Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(document_router, prefix="/api/documents",
                   tags=["Documents"])
