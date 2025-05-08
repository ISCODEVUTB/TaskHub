from pydantic import BaseModel, Field, ConfigDict
from typing import Optional
from datetime import datetime


class ProjectBase(BaseModel):
    """DTO base para proyectos"""
    name: str = Field(..., min_length=1, max_length=100,
                      description="Nombre del proyecto")
    description: Optional[str] = Field(None,
                                       description="Descripción del proyecto")
    owner_id: int = Field(..., gt=0, description="ID del propietario")


class ProjectCreateDTO(ProjectBase):
    """DTO para crear proyectos"""
    pass


class ProjectUpdateDTO(ProjectBase):
    """DTO para actualizar proyectos"""
    name: Optional[str] = None
    description: Optional[str] = None
    owner_id: Optional[int] = None


class ProjectOutputDTO(ProjectBase):
    """DTO para respuestas de proyecto"""
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    model_config = ConfigDict(
        from_attributes=True,
        json_schema_extra={
            "example": {
                "id": 1,
                "name": "Project A",
                "description": "Description of Project A",
                "owner_id": 1,
                "created_at": "2023-10-01T12:00:00Z",
                "updated_at": "2023-10-01T12:00:00Z"
            }
        }
    )
