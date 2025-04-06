from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from src import ProjectCreate, ProjectOut
from src import create_project, get_projects, get_project, update_project
from src import delete_project
from src.database import SessionLocal
from src import require_auth  # ← importamos el extractor

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/projects", response_model=ProjectOut)
def create(
    project: ProjectCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(require_auth),
):
    return create_project(db, project, user_id)


@router.get("/projects", response_model=list[ProjectOut])
def list_projects(
    db: Session = Depends(get_db),
    user_id: int = Depends(require_auth),
):
    return get_projects(db, user_id)


@router.get("/projects/{project_id}", response_model=ProjectOut)
def get(
    project_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(require_auth),
):
    proj = get_project(db, project_id)
    if not proj or proj.owner_id != user_id:
        raise HTTPException(status_code=404, detail="No encontrado")
    return proj


@router.put("/projects/{project_id}", response_model=ProjectOut)
def update(
    project_id: int,
    project: ProjectCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(require_auth),
):
    return update_project(db, project_id, project, user_id)


@router.delete("/projects/{project_id}")
def delete(
    project_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(require_auth),
):
    return delete_project(db, project_id, user_id)
