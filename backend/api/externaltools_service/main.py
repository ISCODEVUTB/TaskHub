from fastapi import FastAPI, APIRouter, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from adapters import AIServiceAdapter
from adapters import PaymentAdapter
from adapters import CloudStorageAdapter
from adapters import ExternalToolManager
from fastapi.security import HTTPBasic, HTTPBasicCredentials
import os
from contextlib import asynccontextmanager
from dotenv import load_dotenv
load_dotenv()


@asynccontextmanager
async def lifespan(app: FastAPI):
    print("Starting up...")
    yield
    print("Shutting down...")


app = FastAPI(title="External Tools Service",
              version="1.0.0",
              description="Service for external tools integration",
              docs_url="/docs",
              lifespan=lifespan)
router = APIRouter()
security = HTTPBasic()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)


def require_auth(credentials: HTTPBasicCredentials = Depends(security)):
    if credentials.username != "admin" or credentials.password != "123":
        raise HTTPException(status_code=401, detail="Unauthorized")


@router.post("/analyze")
def analyze(data: dict, _=Depends(require_auth)):
    tool = AIServiceAdapter()
    manager = ExternalToolManager()
    return manager.use_tool(tool, data)


@router.post("/pay")
def pay(data: dict, _=Depends(require_auth)):
    tool = PaymentAdapter()
    manager = ExternalToolManager()
    return manager.use_tool(tool, data)


@router.get("/storage-url")
def get_storage_url(filename: str, _=Depends(require_auth)):
    tool = CloudStorageAdapter()
    manager = ExternalToolManager()
    return manager.use_tool(tool, {"filename": filename})


@app.get("/")
async def root():
    return {"message": "Welcome to External Tools Service",
            "version": "1.0.0",
            "description": "Service for external tools integration",
            "docs_url": "/docs",
            }

app.include_router(router, prefix="/api/externaltools", tags=["externaltools"])


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host=str(os.getenv("HOST")),
                port=int(os.getenv("PORT")),
                log_level="info")
