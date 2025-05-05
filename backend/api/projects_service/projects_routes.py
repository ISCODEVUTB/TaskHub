from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from src.database.database import get_db
from src.database.repository import ProjectRepository
from src.schemas.project_dto import (ProjectCreateDTO, ProjectUpdateDTO,
                                     ProjectOutputDTO)

router = APIRouter()

NOT_FOUND = "Proyecto no encontrado {id}"


@router.post("/", response_model=ProjectOutputDTO)
def create_project(project: ProjectCreateDTO, db: Session = Depends(get_db)):
    repository = ProjectRepository(db)
    return repository.create(project)


@router.get("/{project_id}", response_model=ProjectOutputDTO)
def get_project(project_id: int,
                db: Session = Depends(get_db)):
    repository = ProjectRepository(db)
    project = repository.get_by_id(project_id)
    if project is None:
        raise HTTPException(status_code=404,
                            detail=NOT_FOUND.format(id=project_id))
    return project


@router.get("/", response_model=List[ProjectOutputDTO])
def get_projects(db: Session = Depends(get_db)):
    repository = ProjectRepository(db)
    return repository.get_all()


@router.put("/{project_id}", response_model=ProjectOutputDTO)
def update_project(project_id: int,
                   project: ProjectUpdateDTO,
                   db: Session = Depends(get_db)):
    repository = ProjectRepository(db)
    updated_project = repository.update(project_id, project)
    if updated_project is None:
        raise HTTPException(status_code=404,
                            detail=NOT_FOUND.format(id=project_id))
    return updated_project


@router.delete("/{project_id}")
def delete_project(project_id: int,
                   db: Session = Depends(get_db)):
    repository = ProjectRepository(db)
    if not repository.delete(project_id):
        raise HTTPException(status_code=404,
                            detail=NOT_FOUND.format(id=project_id))
    return {"message": "Proyecto eliminado"}
