from fastapi import FastAPI, Depends
from manager import ExternalToolManager
from adapters.ai import AIServiceAdapter
from adapters.payment import PaymentAdapter
from adapters.storage import CloudStorageAdapter

app = FastAPI()
tool_manager = ExternalToolManager()

def require_auth():
    return True

@app.post("/analyze")
def analyze(data: dict, auth=Depends(require_auth)):
    tool = AIServiceAdapter()
    return tool_manager.use_tool(tool, data)

@app.post("/pay")
def pay(data: dict, auth=Depends(require_auth)):
    tool = PaymentAdapter()
    return tool_manager.use_tool(tool, data)

@app.get("/storage-url")
def get_storage_url(filename: str, auth=Depends(require_auth)):
    tool = CloudStorageAdapter()
    return tool_manager.use_tool(tool, {"filename": filename})
