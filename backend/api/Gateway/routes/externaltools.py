from fastapi import APIRouter, HTTPException
import httpx
from config import settings

router = APIRouter()


@router.post("/external-tools/analyze")
async def analyze_text(text: str):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"{settings.EXTERNAL_SERVICE_URL}/analyze",
                json={"text": text}
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(
                status_code=e.response.status_code,
                detail=str(e)
            )
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error al conectar con el \
                servicio de herramientas externas: {str(e)}"
            )


@router.post("/external-tools/pay")
async def make_payment(payment_data: dict):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"{settings.EXTERNAL_SERVICE_URL}/pay",
                json=payment_data
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(
                status_code=e.response.status_code,
                detail=str(e)
            )
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error al conectar con el \
                servicio de herramientas externas: {str(e)}"
            )


@router.get("/external-tools/storage-url")
async def get_storage_url(file_name: str):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(
                f"{settings.EXTERNAL_SERVICE_URL}/storage-url? \
                file_name={file_name}"
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(
                status_code=e.response.status_code,
                detail=str(e)
            )
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error al conectar con el \
                servicio de herramientas externas: {str(e)}"
            )
