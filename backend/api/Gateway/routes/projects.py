from fastapi import APIRouter, HTTPException
import httpx
from config import settings

router = APIRouter()


@router.post("/projects/", status_code=201)
async def create_project(project: dict):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"{settings.PROJECT_SERVICE_URL}/projects/", json=project)
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(status_code=e.response.status_code,
                                detail=str(e))
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error connecting to project service: {str(e)}")


@router.get("/projects/")
async def get_projects():
    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(
                f"{settings.PROJECT_SERVICE_URL}/projects/")
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(status_code=e.response.status_code,
                                detail=str(e))
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error connecting to project service: {str(e)}")


@router.get("/projects/{project_id}")
async def get_project(project_id: str):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(
                f"{settings.PROJECT_SERVICE_URL}/projects/{project_id}")
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(status_code=e.response.status_code,
                                detail=str(e))
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error connecting to project service: {str(e)}")


@router.delete("/projects/{project_id}")
async def delete_project(project_id: str):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.delete(
                f"{settings.PROJECT_SERVICE_URL}/projects/{project_id}")
            response.raise_for_status()
            return {"detail": "Project deleted"}
        # Or return response.json() if the service returns JSON
        except httpx.HTTPStatusError as e:
            raise HTTPException(status_code=e.response.status_code,
                                detail=str(e))
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error connecting to project service: {str(e)}")


@router.put("/projects/{project_id}")
async def update_project(project_id: str, project: dict):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.put(
                f"{settings.PROJECT_SERVICE_URL}/projects/{project_id}",
                json=project)
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            raise HTTPException(status_code=e.response.status_code,
                                detail=str(e))
        except httpx.RequestError as e:
            raise HTTPException(
                status_code=500,
                detail=f"Error connecting to project service: {str(e)}")
