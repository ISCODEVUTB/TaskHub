import pytest
from fastapi.testclient import TestClient
from backend.api.Gateway.main import app  # This is your actual FastAPI app


@pytest.fixture
def client():
    return TestClient(app)
