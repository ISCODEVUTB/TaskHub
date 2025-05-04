def test_login_success(client):
    response = client.post("/api/auth/login", json={
        "username": "testuser",
        "password": "password123"
    })
    assert response.status_code == 200
    assert "access_token" in response.json()


def test_login_failure(client, mock_auth_service):
    mock_auth_service.login.return_value = None
    response = client.post("/api/auth/login", json={
        "username": "wrong",
        "password": "wrong"
    })
    assert response.status_code == 401
