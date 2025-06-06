from typing import Any
from unittest.mock import MagicMock, patch
from datetime import datetime

from fastapi.testclient import TestClient

from api.document_service.app.main import app
from api.document_service.app.schemas.document import DocumentType, DocumentResponseDTO


def test_document_health_check() -> None:
    client = TestClient(app)
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}

@patch("api.document_service.app.main.get_db", return_value=MagicMock()) # Keep this patch
@patch("api.document_service.app.services.document_service.DocumentService.create_document")
def test_create_document(mock_create_document: MagicMock, mock_db_fixture: Any) -> None: # Renamed mock_db to avoid clash if get_db is imported
    # Import get_current_user from the app's module to use as a key for dependency_overrides
    from api.document_service.app.main import get_current_user

    app.dependency_overrides[get_current_user] = lambda: "uid" # Override dependency

    client = TestClient(app)

    mock_dto_response = DocumentResponseDTO(
        id="docid",
        name="TestDoc",
        project_id="pid",
        type=DocumentType.FILE,
        version=1,
        creator_id="uid",
        created_at=datetime.fromisoformat("2025-01-01T00:00:00+00:00"),
        parent_id=None,
        content_type="application/octet-stream",
        size=0,
        url=None,
        description=None,
        tags=[],
        meta_data={},
        updated_at=None
    )
    mock_create_document.return_value = mock_dto_response
    
    payload = {
        "name": "TestDoc",
        "project_id": "pid",
        "type": "file"
    }
    # headers = {"Authorization": "Bearer testtoken"} # Not needed if get_current_user is properly overridden
    response = client.post("/documents", json=payload) # Removed headers
    
    assert response.status_code == 200, f"Expected status 200, got {response.status_code}. Response: {response.text}"
    data = response.json()
    assert data["name"] == "TestDoc"
    assert data["project_id"] == "pid"
    assert data["type"] == "file"
    assert data["id"] == "docid"
    assert data["creator_id"] == "uid"

    app.dependency_overrides = {} # Clean up