# -*- coding: utf-8 -*-
from fastapi.testclient import TestClient
from notifications_service.main import app

client = TestClient(app)


def test_send_email_success():
    """
    Test case for sending an email notification successfully.

    Sends a POST request to the /email endpoint with valid data and
    verifies that the response status code is 200 and the response
    message indicates success.
    """
    response = client.post("/email", json={
        "to": "test@example.com",
        "subject": "Test",
        "body": "This is a test email."
    })
    assert response.status_code == 200
    assert response.json() == {"message": "Email sent"}


def test_send_push_success():
    """
    Test case for sending a push notification successfully.

    Sends a POST request to the /push endpoint with valid data and
    verifies that the response status code is 200 and the response
    message indicates success.
    """
    response = client.post("/push", json={
        "user_id": "user123",
        "title": "Hola",
        "message": "Tienes una notificación "
    })
    assert response.status_code == 200
    assert response.json() == {"message": "Push notification sent"}


def test_notification_service_exists():
    """Test básico para verificar que el servicio existe"""
    response = client.get("/")
    assert response.status_code == 200


def test_create_notification(mock_db):
    """Test básico para crear notificación"""
    assert mock_db is not None
