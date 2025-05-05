from src.database.AbstractDB import AbstractDB
from src.models.projects import Project
from src.schemas import ProjectCreateDTO as ProjectCreate
import json

file_path = "projectsDB.json"

# JSONDB is a simple file-based database for storing project data in JSON.
# It implements the AbstractDB interface and provides methods for creating,


class JSONDB(AbstractDB):
    def __init__(self, file_path: str):
        """Initialize the JSONDB with a file path."""
        self.file_path = file_path
        self.projects = []
        self.load_data()

    def load_data(self):
        """Load data from the JSON file."""
        try:
            with open(self.file_path, "r") as file:
                self.projects = json.load(file)
        except FileNotFoundError:
            self.projects = []

    def save_data(self):
        """Save data to the JSON file."""
        with open(self.file_path, "w") as file:
            json.dump(self.projects, file, indent=4)

    def create_project(self, project: ProjectCreate) -> Project:
        """Create a new project in the database."""
        new_project = Project(**project.dict())
        self.projects.append(new_project.dict())
        self.save_data()
        return new_project

    def get_projects(self) -> list[Project]:
        """Retrieve all projects from the database."""
        return [Project(**project) for project in self.projects]

    def get_project(self, project_id: int) -> Project | None:
        """Retrieve a specific project by its ID."""
        for project in self.projects:
            if project["id"] == project_id:
                return Project(**project)
        return None

    def delete_project(self, project_id: int) -> None:
        """Delete a project from the database."""
        self.projects = [
            project for project in self.projects if project["id"] != project_id
        ]
        self.save_data()

    def update_project(
        self, project_id: int, project_data: ProjectCreate
    ) -> Project | None:
        """Update an existing project."""
        for project in self.projects:
            if project["id"] == project_id:
                for key, value in project_data.dict().items():
                    project[key] = value
                self.save_data()
                return Project(**project)
        return None
