from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import (projects_router,
                    documents_router,
                    externaltools_router,
                    notifications_router)
import os

app = FastAPI(title="TaskHub API", version="0.1.0")

HOST = os.getenv("HOST", "localhost")
PORT = int(os.getenv("PORT", 8000))

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

app.include_router(projects_router,
                   prefix="/api/projects",
                   tags=["projects"])

app.include_router(documents_router,
                   prefix="/api/documents",
                   tags=["documents"])

app.include_router(externaltools_router,
                   prefix="/api/externaltools",
                   tags=["externaltools"])

app.include_router(notifications_router,
                   prefix="/api/notifications",
                   tags=["notifications"])


@app.get("/")
async def root():
    return {"message": "Welcome to TaskHub API"}


@app.get("/api/health")
async def health_check():
    return {"status": "healthy"}
