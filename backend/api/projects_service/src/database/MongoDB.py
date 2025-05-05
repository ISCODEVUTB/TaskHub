from pymongo import MongoClient
from src.database import AbstractDB
from src.models.projects import Project


class MongoDB(AbstractDB):
    def __init__(self, uri: str, db_name: str):
        """Initialize the MongoDB client and database."""
        self.uri = uri
        self.client = MongoClient(uri)
        self.db = self.client[db_name]
        self.collection = self.db["projects"]

    def create_project(self, project: Project) -> Project:
        """Create a new project in the database."""
        project_dict = project.dict()
        result = self.collection.insert_one(project_dict)
        project.id = str(result.inserted_id)
        return project

    def get_projects(self) -> list[Project]:
        """Retrieve all projects from the database."""
        projects = self.collection.find()
        return [Project(**project) for project in projects]

    def get_project(self, project_id: str) -> Project | None:
        """Retrieve a specific project by its ID."""
        project = self.collection.find_one({"_id": project_id})
        if project:
            return Project(**project)
        return None

    def delete_project(self, project_id: str) -> None:
        """Delete a project from the database."""
        self.collection.delete_one({"_id": project_id})
