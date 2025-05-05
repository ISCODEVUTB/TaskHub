from sqlalchemy.orm import Session
from src.models.projects import Project
from src.schemas.project_dto import ProjectCreateDTO, ProjectUpdateDTO
from typing import List, Optional


class ProjectRepository:
    def __init__(self, db: Session):
        self.db = db

    def create(self, project: ProjectCreateDTO) -> Project:
        db_project = Project(**project.model_dump())
        self.db.add(db_project)
        self.db.commit()
        self.db.refresh(db_project)
        return db_project

    def get_by_id(self, project_id: int) -> Optional[Project]:
        return self.db.query(Project).filter(Project.id == project_id).first()

    def get_all(self) -> List[Project]:
        return self.db.query(Project).all()

    def update(
        self, project_id: int, project: ProjectUpdateDTO
    ) -> Optional[Project]:
        db_project = self.get_by_id(project_id)
        if db_project:
            update_data = project.model_dump(exclude_unset=True)
            for key, value in update_data.items():
                setattr(db_project, key, value)
            self.db.commit()
            self.db.refresh(db_project)
        return db_project

    def delete(self, project_id: int) -> bool:
        db_project = self.get_by_id(project_id)
        if db_project:
            self.db.delete(db_project)
            self.db.commit()
            return True
        return False
