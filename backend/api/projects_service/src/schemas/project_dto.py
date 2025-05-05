from pydantic import BaseModel, Field
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

    class Config:
        from_attributes = True
