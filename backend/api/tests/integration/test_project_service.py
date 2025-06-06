from datetime import datetime
from typing import Any
from unittest.mock import MagicMock, patch

from fastapi.testclient import TestClient

from api.project_service.app.main import app
from api.shared.dtos.project_dtos import ProjectStatus
from api.project_service.app.schemas.project import ProjectResponseDTO


def test_project_health_check() -> None:
    client = TestClient(app)
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}

@patch("api.project_service.app.main.get_db", return_value=MagicMock()) # Keep this patch
@patch("api.project_service.app.services.project_service.ProjectService.create_project")
def test_create_project(mock_create_project: MagicMock, mock_db_fixture: Any) -> None:
    from api.project_service.app.main import get_current_user # Import for override key
    app.dependency_overrides[get_current_user] = lambda: "uid"

    client = TestClient(app)

    # Ensure all required fields for ProjectResponseDTO are present
    mock_dto_response = ProjectResponseDTO(
        id="pid",
        name="TestProject",
        description=None, # Add missing required fields or ensure they are optional
        start_date=None,
        end_date=None,
        status=ProjectStatus.PLANNING,
        owner_id="uid",
        tags=[],
        meta_data={},
        created_at=datetime.now(),
        updated_at=None
    )
    mock_create_project.return_value = mock_dto_response
    
    payload = {
        "name": "TestProject",
        "status": "planning",
        # Add other fields if ProjectCreateDTO requires them, e.g., description
        "description": "Test Description"
    }
    # headers = {"Authorization": "Bearer testtoken"} # Not needed
    response = client.post("/projects", json=payload) # Removed headers
    
    assert response.status_code == 200, f"Expected status 200, got {response.status_code}. Response: {response.text}"
    data = response.json()
    assert data["name"] == "TestProject"
    assert data["status"] == ProjectStatus.PLANNING.value # Compare with enum value
    assert data["owner_id"] == "uid"
    assert data["id"] == "pid"

    app.dependency_overrides = {} # Clean up