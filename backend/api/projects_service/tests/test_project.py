import pytest
from fastapi.testclient import TestClient
from unittest.mock import MagicMock
from main import app  # o desde donde expongas tus rutas
from src.schemas.project_dto import ProjectUpdateDTO, ProjectOutputDTO

client = TestClient(app)

# Mocks
mock_project = ProjectOutputDTO(id=1,
                                name="Proyecto 1",
                                description="Desc",
                                owner="Juan",
                                owner_id=42,
                                created_at="2023-10-01T12:00:00Z",
                                updated_at="2023-10-01T12:00:00Z"
                                )

mock_project_list = [mock_project]


@pytest.fixture
def mock_repo(monkeypatch):
    repo = MagicMock()
    monkeypatch.setattr("src.routes.project_routes.ProjectRepository",
                        lambda db: repo)
    return repo


def test_create_project(mock_repo):
    mock_repo.create.return_value = mock_project

    response = client.post("/projects/", json={
        "name": "Proyecto 1",
        "description": "Desc",
        "owner": "Juan"
    })

    assert response.status_code == 200
    assert response.json()["id"] == 1
    mock_repo.create.assert_called_once()


def test_get_project_found(mock_repo):
    mock_repo.get_by_id.return_value = mock_project

    response = client.get("/projects/1")
    assert response.status_code == 200
    assert response.json()["name"] == "Proyecto 1"
    mock_repo.get_by_id.assert_called_with(1)


def test_get_project_not_found(mock_repo):
    mock_repo.get_by_id.return_value = None

    response = client.get("/projects/999")
    assert response.status_code == 404
    assert "no encontrado" in response.json()["detail"].lower()


def test_get_all_projects(mock_repo):
    mock_repo.get_all.return_value = [mock_project]

    response = client.get("/projects/")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    assert response.json()[0]["id"] == 1


def test_update_project_found(mock_repo):
    mock_repo.update.return_value = mock_project

    response = client.put("/projects/1", json={
        "name": "Proyecto 1",
        "description": "Desc actualizada",
        "owner": "Juan"
    })

    assert response.status_code == 200
    mock_repo.update.assert_called_with(1,
                                        ProjectUpdateDTO(name="Proyecto 1",
                                                         description="DA",
                                                         owner="Juan",
                                                         owner_id=42))


def test_update_project_not_found(mock_repo):
    mock_repo.update.return_value = None

    response = client.put("/projects/999", json={
        "name": "No existe",
        "description": "Nada",
        "owner": "Nadie"
    })

    assert response.status_code == 404


def test_delete_project_found(mock_repo):
    mock_repo.delete.return_value = True

    response = client.delete("/projects/1")
    assert response.status_code == 200
    assert response.json()["message"] == "Proyecto eliminado"


def test_delete_project_not_found(mock_repo):
    mock_repo.delete.return_value = False

    response = client.delete("/projects/999")
    assert response.status_code == 404
