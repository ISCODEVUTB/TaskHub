from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from src.routes.document_routes import router as documents_router

app = FastAPI(title="Documents Service", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

app.include_router(documents_router,
                   prefix="/api/documents",
                   tags=["documents"])


@app.get("/")
def read_root():
    return {"message": "Welcome to the Documents Service"}


@app.get("/health")
def health_check():
    return {"status": "healthy"}


@app.exception_handler(HTTPException)
def http_exception_handler(request, exc):
    return {
        "status_code": exc.status_code,
        "detail": exc.detail
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="localhost", port=8000, log_level="info")
