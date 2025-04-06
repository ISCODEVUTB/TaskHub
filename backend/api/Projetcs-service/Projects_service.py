from fastapi import FastAPI
from src import Base, engine
from src import router as project_router

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Project Service")

app.include_router(project_router, prefix="/api", tags=["Projects"])
