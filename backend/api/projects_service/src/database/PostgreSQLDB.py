from sqlalchemy.orm import Session
from src.models.projects import Project
from src.schemas import ProjectCreateDTO as ProjectCreate
from src.database.AbstractDB import AbstractDB


class PostgreSQLDB(AbstractDB):
    def __init__(self, db: Session):
        self.db = db

    def create_project(self, project: ProjectCreate) -> Project:
        """Create a new project in the database."""
        db_project = Project(**project.dict())
        self.db.add(db_project)
        self.db.commit()
        self.db.refresh(db_project)
        return db_project

    def get_projects(self) -> list[Project]:
        """Retrieve all projects from the database."""
        return self.db.query(Project).all()

    def get_project(self, project_id: int) -> Project:
        """Retrieve a specific project by its ID."""
        return self.db.query(Project).filter(Project.id == project_id).first()

    def delete_project(self, project_id: int) -> None:
        """Delete a project from the database."""
        project = self.get_project(project_id)
        if project:
            self.db.delete(project)
            self.db.commit()

    def update_project(
        self, project_id: int, project_data: ProjectCreate
    ) -> Project | None:
        """Update an existing project."""
        project = self.get_project(project_id)
        if project:
            for key, value in project_data.dict().items():
                setattr(project, key, value)
            self.db.commit()
            self.db.refresh(project)
            return project
        return None
