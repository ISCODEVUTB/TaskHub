from unittest.mock import MagicMock
import pytest


class TestCodeUnderTest:

    # create_project successfully adds a new project to the database
    def test_create_project_success(self):
        # Arrange
        from sqlalchemy.orm import Session
        from src import Project
        from src import ProjectCreate
        from src import create_project
        # Mock session
        mock_db = MagicMock(spec=Session)
        # Create project data
        project_data = {
            "name": "Test Project",
            "description": "Test Description",
            "owner_id": 1
        }
        project_create = ProjectCreate(**project_data)
        # Act
        result = create_project(mock_db, project_create)
        # Assert
        mock_db.add.assert_called_once()
        mock_db.commit.assert_called_once()
        mock_db.refresh.assert_called_once()
        assert isinstance(result, Project)
        assert result.name == project_data["name"]
        assert result.description == project_data["description"]
        assert result.owner_id == project_data["owner_id"]

    # create_project with missing required fields (name, owner_id)
    def test_create_project_missing_required_fields(self):
        # Arrange
        from sqlalchemy.orm import Session
        from src import ProjectCreate
        from src import create_project
        from sqlalchemy.exc import IntegrityError
        # Mock session
        mock_db = MagicMock(spec=Session)
        # Set up the mock to raise IntegrityError when commit is called
        mock_db.commit.side_effect = IntegrityError(
            "(sqlite3.IntegrityError) NOT NULL constraint failed", None, None
        )
        # Create project with missing required fields
        project_data = {
            "description": "Test Description"
            # Missing name and owner_id
        }
        project_create = ProjectCreate(**project_data)
        # Act & Assert
        with pytest.raises(IntegrityError):
            create_project(mock_db, project_create)
        # Verify the session interactions
        mock_db.add.assert_called_once()
        mock_db.commit.assert_called_once()
        mock_db.refresh.assert_not_called()
