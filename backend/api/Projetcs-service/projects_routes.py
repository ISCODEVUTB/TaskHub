from fastapi import APIRouter, HTTPException
from config import DB_USE
from src import ProjectCreate, ProjectOut
from src import get_repo

ProjectRouter = APIRouter()

db = get_repo(DB_USE)


@ProjectRouter.post("/projects/", response_model=ProjectOut)
def create_project(project: ProjectCreate):
    """Create a new project."""
    return db.create_project(project)


@ProjectRouter.get("/projects/", response_model=list[ProjectOut])
def get_projects():
    """Get all projects."""
    return db.get_projects()


@ProjectRouter.get("/projects/{project_id}", response_model=ProjectOut)
def get_project(project_id: str):
    """Get a project by ID."""
    project = db.get_project(project_id)
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")
    return project


@ProjectRouter.delete("/projects/{project_id}")
def delete_project(project_id: str):
    """Delete a project by ID."""
    db.delete_project(project_id)
    return {"detail": "Project deleted"}


@ProjectRouter.put("/projects/{project_id}", response_model=ProjectOut)
def update_project(project_id: str, project: ProjectCreate):
    """Update a project by ID."""
    updated_project = db.update_project(project_id, project)
    if not updated_project:
        raise HTTPException(status_code=404, detail="Project not found")
    return updated_project
