from typing import Any
from unittest.mock import MagicMock, patch
from datetime import datetime

from fastapi.testclient import TestClient

from api.external_tools_service.app.main import app
from api.external_tools_service.app.schemas.external_tools import OAuthProviderDTO


def test_external_tools_health_check() -> None:
    client = TestClient(app)
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}

@patch("api.external_tools_service.app.main.get_db", return_value=MagicMock()) # Keep
@patch("api.external_tools_service.app.services.external_tools_service.ExternalToolsService.get_oauth_providers")
def test_get_oauth_providers(mock_get_oauth_providers: MagicMock, mock_db_fixture: Any) -> None: # mock_user removed
    from api.external_tools_service.app.main import get_current_user # For override key
    app.dependency_overrides[get_current_user] = lambda: "uid"

    client = TestClient(app)

    mock_dto_response = [OAuthProviderDTO(
        id="prov1",
        name="GitHub",
        type="github",
        auth_url="https://auth/",
        token_url="https://token/",
        scope="repo",
        client_id="cid",
        client_secret="csecret", # OAuthProviderDTO requires client_secret
        redirect_uri="https://cb/",
        created_at=datetime.fromisoformat("2025-01-01T00:00:00+00:00"),
        additional_params={}, # Assuming optional or provide default
        updated_at=None # Assuming optional
    )]
    mock_get_oauth_providers.return_value = mock_dto_response

    # headers = {"Authorization": "Bearer testtoken"} # Not needed
    response = client.get("/oauth/providers") # Removed headers

    assert response.status_code == 200, f"Expected status 200, got {response.status_code}. Response: {response.text}"
    data = response.json()
    assert isinstance(data, list)
    assert len(data) == 1
    assert data[0]["name"] == "GitHub"
    assert data[0]["type"] == "github"
    assert data[0]["id"] == "prov1"
    assert "client_secret" not in data[0] # client_secret should not be in DTO response by default if not explicitly included

    app.dependency_overrides = {} # Clean up