def test_register_user(client):
    data = {
        "username": "testuser",
        "password": "password123"
    }
    response = client.post("/register", json=data)

    assert response.status_code == 201
    assert "id" in response.json()
