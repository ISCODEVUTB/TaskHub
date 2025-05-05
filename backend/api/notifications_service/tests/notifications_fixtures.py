import pytest
from unittest.mock import MagicMock


@pytest.fixture
def mock_db():
    return MagicMock()


@pytest.fixture
def mock_notification_service():
    return MagicMock()


@pytest.fixture
def notification_db(base_mock_db):
    return base_mock_db


@pytest.fixture
def notification_service():
    return MagicMock(name="NotificationService")
