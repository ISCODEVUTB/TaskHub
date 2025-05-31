import pytest
from unittest.mock import Mock
from fastapi.testclient import TestClient
from backend.api.auth_service.main import app, get_auth_service
from datetime import datetime, timedelta, timezone

@pytest.fixture
def mock_auth_service():
    mock_service = Mock()
    mock_service.login.return_value = "mock_token_123"
    mock_service.register.return_value = "user_123"
    mock_service.logout.return_value = True
    mock_service.create_token.return_value = {
        "sub": "testuser",
        "exp": datetime.now(timezone.utc) + timedelta(seconds=360)
    }
    mock_service.validate_token.return_value = True
    return mock_service

@pytest.fixture
def client(mock_auth_service):
    app.dependency_overrides[get_auth_service] = lambda: mock_auth_service
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()  # Limpieza
