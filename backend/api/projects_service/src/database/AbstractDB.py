from abc import ABC, abstractmethod


class AbstractDB(ABC):
    @abstractmethod
    def create_project(self, project):
        """Create a new project in the database."""
        pass

    @abstractmethod
    def get_projects(self):
        """Retrieve all projects from the database."""
        pass

    @abstractmethod
    def get_project(self, project_id):
        """Retrieve a specific project by its ID."""
        pass

    @abstractmethod
    def delete_project(self, project_id):
        """Delete a project from the database."""
        pass

    @abstractmethod
    def update_project(self, project_id, project_data):
        """Update an existing project."""
        pass
