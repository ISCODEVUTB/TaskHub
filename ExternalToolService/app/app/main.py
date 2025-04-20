from fastapi import FastAPI, Depends
from adapters.ai import AIServiceAdapter
from adapters.payment import PaymentAdapter
from adapters.storage import CloudStorageAdapter
from adapters.manager import ExternalToolManager
from fastapi.security import HTTPBasic, HTTPBasicCredentials


app = FastAPI()
security = HTTPBasic()


def require_auth(credentials: HTTPBasicCredentials = Depends(security)):
    if credentials.username != "admin" or credentials.password != "123":
        raise Exception("Unauthorized")


@app.post("/analyze")
def analyze(data: dict, _=Depends(require_auth)):
    tool = AIServiceAdapter()
    manager = ExternalToolManager()
    return manager.use_tool(tool, data)


@app.post("/pay")
def pay(data: dict, _=Depends(require_auth)):
    tool = PaymentAdapter()
    manager = ExternalToolManager()
    return manager.use_tool(tool, data)


@app.get("/storage-url")
def get_storage_url(filename: str, _=Depends(require_auth)):
    tool = CloudStorageAdapter()
    manager = ExternalToolManager()
    return manager.use_tool(tool, {"filename": filename})
