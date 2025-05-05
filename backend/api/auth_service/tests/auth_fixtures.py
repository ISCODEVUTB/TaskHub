# -*- coding: utf-8 -*-
import pytest
from unittest.mock import Mock, patch
from fastapi.testclient import TestClient
from main import app
from datetime import datetime, timedelta, timezone


@pytest.fixture
def mock_auth_service():
    # Creamos un mock más completo con todos los métodos necesarios
    mock_service = Mock()

    # Definimos explícitamente todos los métodos que necesitamos
    mock_service.login = Mock(return_value="mock_token_123")
    mock_service.register = Mock(return_value="user_123")
    mock_service.logout = Mock(return_value=True)
    mock_service.create_token = Mock(return_value={
        "sub": "testuser",
        "exp": datetime.now(timezone.utc) + timedelta(seconds=360)
    })
    mock_service.validate_token = Mock(return_value=True)

    return mock_service


@pytest.fixture
def client(mock_auth_service):
    with patch('main.AuthService', return_value=mock_auth_service):
        with TestClient(app) as test_client:
            yield test_client
