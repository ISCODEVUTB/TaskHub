import pytest
from datetime import datetime, timezone
from utils.jwt_manager import JWTManager


@pytest.fixture
def jwt_manager():
    return JWTManager()


def test_create_and_verify_token(jwt_manager):
    data = {"sub": "testuser"}
    token = jwt_manager.generate_token(data)
    payload = jwt_manager.verify_token(token)
    assert payload["sub"] == "testuser"


def test_token_expiration():
    jwt_manager = JWTManager()
    test_data = {"sub": "testuser"}

    # Crear token con expiración
    token = jwt_manager.generate_token(test_data)
    decoded = jwt_manager.verify_token(token)

    # Verificar que la expiración es una fecha válida
    assert isinstance(decoded["exp"], datetime)
    assert decoded["exp"] > datetime.now(timezone.utc)


def test_invalid_token(jwt_manager):
    invalid_token = "invalid.token.here"
    payload = jwt_manager.verify_token(invalid_token)
    assert payload is None


def test_token_with_extra_data(jwt_manager):
    data = {
        "sub": "testuser",
        "role": "admin",
        "email": "test@example.com"
    }
    token = jwt_manager.generate_token(data)
    payload = jwt_manager.verify_token(token)
    assert payload["sub"] == "testuser"
    assert payload["role"] == "admin"
    assert payload["email"] == "test@example.com"
