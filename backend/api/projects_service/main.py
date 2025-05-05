from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from projects_routes import router as projects_router
from src.database.database import Base, engine
import os

app = FastAPI(title="Projects Service", version="1.0.0")

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def read_root():
    return {"message": "Welcome to the Projects Service!"}


@app.get("/health")
def health_check():
    return {"status": "healthy"}


# Incluir rutas
app.include_router(projects_router, prefix="/projects", tags=["projects"])

# Crear tablas
Base.metadata.create_all(bind=engine)

if __name__ == "__main__":
    import uvicorn

    HOST = os.getenv("PROJECTS_SERVICE_HOST", "localhost")
    PORT = int(os.getenv("PROJECTS_SERVICE_PORT", 8001))
    uvicorn.run(app, host=HOST, port=PORT)
