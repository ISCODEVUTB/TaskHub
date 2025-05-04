def test_register_user(client):
    response = client.post("/api/auth/register", json={
        "username": "newuser",
        "password": "password123"
    })
    assert response.status_code == 201
    assert "id" in response.json()
