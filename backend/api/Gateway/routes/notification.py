from fastapi import APIRouter, HTTPException
import httpx
from config import settings

router = APIRouter()


@router.post("/notifications/email")
async def send_email(request: dict):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"{settings.NOTIFICATION_SERVICE_URL}/email",
                json=request,
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(
                status_code=e.response.status_code,
                detail=str(e),
            )
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=(
                    "Error al conectar con el servicio de notificaciones: "
                    f"{str(e)}"
                ),
            )


@router.post("/notifications/push")
async def send_push(request: dict):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"{settings.NOTIFICATION_SERVICE_URL}/push",
                json=request,
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(
                status_code=e.response.status_code,
                detail=str(e),
            )
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=(
                    "Error al conectar con el servicio de notificaciones: "
                    f"{str(e)}"
                ),
            )
