# -*- coding: utf-8 -*-
from fastapi import status


def test_login_success(client):
    test_data = {
        "username": "testuser",
        "password": "password123"
    }
    response = client.post("/api/auth/login", json=test_data)

    assert response.status_code == status.HTTP_200_OK
    assert "access_token" in response.json()
    assert response.json()["access_token"] == "mock_token_123"


def test_login_failure(client, mock_auth_service):
    # Configuramos el mock para simular un fallo de login
    mock_auth_service.login.return_value = None

    test_data = {
        "username": "wrong",
        "password": "wrong"
    }
    response = client.post("/api/auth/login", json=test_data)

    assert response.status_code == status.HTTP_401_UNAUTHORIZED
