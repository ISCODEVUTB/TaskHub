def test_login_success(client):
    data = {
        "username": "testuser",
        "password": "password123"
    }
    response = client.post("/login", json=data)

    assert response.status_code == 200
    assert "access_token" in response.json()
    assert response.json()["token_type"] == "bearer"


def test_login_failure(client):
    data = {
        "username": "wronguser",
        "password": "wrongpassword"
    }
    response = client.post("/login", json=data)

    assert response.status_code == 401
