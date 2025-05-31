from .auth_fixtures import client, mock_auth_service


def test_register_user(client):
    response = client.post("/api/auth/register", json={
        "username": "newuser",
        "password": "password123"
    })
    assert response.status_code == 201
    assert "id" in response.json()
