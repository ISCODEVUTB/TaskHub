from typing import Any
from unittest.mock import MagicMock, patch
from datetime import datetime

from fastapi.testclient import TestClient

from api.notification_service.app.main import app
from api.notification_service.app.schemas.notification import NotificationResponseDTO


def test_notification_health_check() -> None:
    client = TestClient(app)
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}

@patch("api.notification_service.app.main.get_db", return_value=MagicMock()) # Keep this
@patch("api.notification_service.app.services.notification_service.NotificationService.create_notification")
def test_create_notification(mock_create_notification: MagicMock, mock_db_fixture: Any) -> None: # mock_user removed
    from api.notification_service.app.main import get_current_user # For override key
    app.dependency_overrides[get_current_user] = lambda: "uid"

    client = TestClient(app)

    # Ensure all required fields for NotificationResponseDTO are present
    mock_dto_response = NotificationResponseDTO(
        id="nid",
        user_id="uid",
        type="system",
        title="TestNotif",
        message="Hello",
        priority="normal",
        channels=["in_app"],
        created_at=datetime.fromisoformat("2025-01-01T00:00:00+00:00"),
        is_read=False, # Add missing required fields
        # Add other optional fields if necessary, with default or None values
        related_entity_type=None,
        related_entity_id=None,
        action_url=None,
        meta_data=None,
        read_at=None,
        scheduled_at=None,
        sent_at=None,
        updated_at=None # Assuming optional from BaseModel
    )
    mock_create_notification.return_value = mock_dto_response

    payload = {
        # user_id in payload for NotificationCreateDTO is fine
        "user_id": "uid",
        "type": "system",
        "title": "TestNotif",
        "message": "Hello",
        "priority": "normal",
        "channels": ["in_app"]
        # Add other fields if NotificationCreateDTO requires them
    }

    # headers = {"Authorization": "Bearer testtoken"} # Not needed
    response = client.post("/notifications", json=payload) # Removed headers

    assert response.status_code == 200, f"Expected status 200, got {response.status_code}. Response: {response.text}"
    data = response.json()
    assert data["title"] == "TestNotif"
    assert data["message"] == "Hello"
    assert data["type"] == "system"
    assert data["user_id"] == "uid"
    assert data["id"] == "nid"
    assert data["is_read"] == False

    app.dependency_overrides = {} # Clean up