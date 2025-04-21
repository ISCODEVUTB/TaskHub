from fastapi import APIRouter, Depends, HTTPException
from adapters import AIServiceAdapter
from adapters import PaymentAdapter
from adapters import CloudStorageAdapter
from adapters import ExternalToolManager
from fastapi.security import HTTPBasic, HTTPBasicCredentials


router = APIRouter()
security = HTTPBasic()


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
