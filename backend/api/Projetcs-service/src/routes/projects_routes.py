from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.projects_schema import ProjectCreate, ProjectOut
from database.crud import create_project, get_projects, get_project
from database.database import SessionLocal

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/projects", response_model=ProjectOut)
def create(project: ProjectCreate, db: Session = Depends(get_db)):
    return create_project(db, project)


@router.get("/projects", response_model=list[ProjectOut])
def list_projects(db: Session = Depends(get_db)):
    return get_projects(db)


@router.get("/projects/{project_id}", response_model=ProjectOut)
def get(project_id: int, db: Session = Depends(get_db)):
    proj = get_project(db, project_id)
    if not proj:
        raise HTTPException(status_code=404, detail="No encontrado")
    return proj
