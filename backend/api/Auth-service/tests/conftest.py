import pytest
from unittest.mock import Mock, patch
from fastapi.testclient import TestClient
from main import app
from auth_service import AuthService
from datetime import datetime, timedelta, timezone


@pytest.fixture
def mock_auth_service():
    mock_service = Mock(spec=AuthService)

    # Configuramos comportamientos mock específicos
    mock_service.login.return_value = "mock_token_123"
    mock_service.register.return_value = "user_123"
    mock_service.logout.return_value = True

    # Configuramos el comportamiento para jwt_manager
    mock_exp_time = datetime.now(timezone.utc) + timedelta(hours=1)
    mock_service.create_token.return_value = {
        "sub": "testuser",
        "exp": mock_exp_time
    }

    return mock_service


@pytest.fixture
def client(mock_auth_service):
    # Patch el AuthService en la aplicación
    with patch('main.auth_service', mock_auth_service):
        with TestClient(app) as test_client:
            yield test_client
