# test_notifications.py

import os
import sys
from unittest.mock import patch, MagicMock

import pytest
from fastapi.testclient import TestClient

from notifications_service.main import app

# Añade el path del servicio si es necesario
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

client = TestClient(app)


# === Fixtures ===

@pytest.fixture
def mock_notification_service():
    with patch(
        "notifications_service.notification.NotificationService"
    ) as mock_service:
        yield mock_service


@pytest.fixture
def mock_db():
    mock_database = MagicMock()
    yield mock_database
    mock_database.reset_mock()


# === Tests: Email ===

def test_send_email_success(mock_notification_service):
    mock_notification_service.return_value.send_email.return_value = True

    response = client.post(
        "/email",
        json={
            "to": "test@example.com",
            "subject": "Test",
            "body": "This is a test email."
        }
    )

    assert response.status_code == 200
    assert response.json() == {"message": "Email sent"}


def test_send_email_failure(mock_notification_service):
    mock_notification_service.return_value.send_email.return_value = False

    response = client.post(
        "/email",
        json={
            "to": "test@example.com",
            "subject": "Test",
            "body": "This is a test email."
        }
    )

    assert response.status_code == 500
    assert response.json() == {"detail": "Failed to send email"}


# === Tests: Push notifications ===

def test_send_push_success(mock_notification_service):
    mock_notification_service.return_value.send_push.return_value = True

    response = client.post(
        "/push",
        json={
            "user_id": "user123",
            "title": "Hola",
            "message": "Tienes una notificación"
        }
    )

    assert response.status_code == 200
    assert response.json() == {"message": "Push notification sent"}


def test_send_push_failure(mock_notification_service):
    mock_notification_service.return_value.send_push.return_value = False

    response = client.post(
        "/push",
        json={
            "user_id": "user123",
            "title": "Hola",
            "message": "Tienes una notificación"
        }
    )

    assert response.status_code == 500
    assert response.json() == {"detail": "Failed to send push notification"}


# === Tests: Notifications DB ===

def test_create_notification_success(mock_db):
    mock_db.create_notification.return_value = {
        "id": 1,
        "message": "Notification created"
    }

    response = client.post(
        "/notifications",
        json={
            "user_id": "user123",
            "title": "Test Notification",
            "message": "This is a test notification."
        }
    )

    assert response.status_code == 201
    assert response.json() == {
        "id": 1,
        "message": "Notification created"
    }


def test_create_notification_failure(mock_db):
    mock_db.create_notification.side_effect = Exception("Database error")

    response = client.post(
        "/notifications",
        json={
            "user_id": "user123",
            "title": "Test Notification",
            "message": "This is a test notification."
        }
    )

    assert response.status_code == 500
    assert response.json() == {"detail": "Failed to create notification"}


def test_get_notifications_success(mock_db):
    mock_db.get_notifications.return_value = [
        {
            "id": 1,
            "user_id": "user123",
            "title": "Test Notification",
            "message": "This is a test notification."
        }
    ]

    response = client.get("/notifications?user_id=user123")

    assert response.status_code == 200
    assert response.json() == mock_db.get_notifications.return_value


def test_delete_notification_success(mock_db):
    mock_db.delete_notification.return_value = True

    response = client.delete("/notifications/1")

    assert response.status_code == 200
    assert response.json() == {"message": "Notification deleted"}
