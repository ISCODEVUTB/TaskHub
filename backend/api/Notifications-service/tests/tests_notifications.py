from fastapi.testclient import TestClient
from models import app

client = TestClient(app)


def test_send_email_success():
    response = client.post("/email", json={
        "to": "test@example.com",
        "subject": "Test",
        "body": "This is a test email."
    })
    assert response.status_code == 200
    assert response.json() == {"message": "Email sent"}


def test_send_push_success():
    response = client.post("/push", json={
        "user_id": "user123",
        "title": "Hola",
        "message": "Tienes una notificación "
    })
    assert response.status_code == 200
    assert response.json() == {"message": "Push notification sent"}
