from fastapi import APIRouter, HTTPException, UploadFile, File
import httpx
from config import settings

router = APIRouter()


@router.get("/documents/{document_id}")
async def get_document(document_id: str):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(
                f"{settings.DOCUMENT_SERVICE_URL}/documents/{document_id}")
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(
                status_code=e.response.status_code, detail=str(e)
            )
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error al conectar con el \
                servicio de documentos: {str(e)}"
            )


@router.post("/documents/")
async def create_document(file: UploadFile = File(...)):
    async with httpx.AsyncClient() as client:
        try:
            files = {'file': (file.filename, file.file, file.content_type)}
            response = await client.post(
                f"{settings.DOCUMENT_SERVICE_URL}/documents/", files=files
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(
                status_code=e.response.status_code, detail=str(e)
            )
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error al conectar con el \
                    servicio de documentos: {str(e)}"
            )


@router.put("/documents/{document_id}")
async def update_document(document_id: str, data: dict):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.put(
                f"{settings.DOCUMENT_SERVICE_URL}/documents/{document_id}",
                json=data
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(
                status_code=e.response.status_code, detail=str(e)
            )
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error al conectar con el \
                servicio de documentos: {str(e)}"
            )


@router.delete("/documents/{document_id}")
async def delete_document(document_id: str):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.delete(
                f"{settings.DOCUMENT_SERVICE_URL}/documents/{document_id}")
            response.raise_for_status()
            return {"message": "Documento eliminado"}
        except httpx.HTTPStatusError as e:
            raise HTTPException(
                status_code=e.response.status_code, detail=str(e))
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error al conectar con el \
                servicio de documentos: {str(e)}")
