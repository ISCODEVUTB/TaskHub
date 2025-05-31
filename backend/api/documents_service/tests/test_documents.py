import os
import io
import pytest
from unittest.mock import patch
from fastapi.testclient import TestClient
from backend.api.documents_service.main import app
from ..database import Base, engine, SessionLocal
from ..src.models.document import Document as DocumentModel

# Crear base de datos limpia para tests
@pytest.fixture(scope="function", autouse=True)
def setup_database():
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)

# Cliente de prueba
@pytest.fixture
def client():
    with TestClient(app) as c:
        yield c

# Mock para evitar llamadas reales a notification-service
@pytest.fixture(autouse=True)
def mock_notify():
    with patch("backend.api.documents_service.src.routes.document_routes.notify") as mock:
        yield mock

def test_listar_documentos_vacio(client):
    response = client.get("/api/documents/")
    assert response.status_code == 200
    assert response.json() == []

def test_subir_documento(client):
    data = {
        "title": "Mi Documento",
        "author": "Alguien"
    }
    file_content = b"Contenido de prueba"
    files = {"archivo": ("documento.txt", file_content, "text/plain")}

    response = client.post("/api/documents/", data=data, files=files)
    assert response.status_code == 200
    assert response.json()["title"] == "Mi Documento"


def test_listar_documentos_con_datos(client):
    db = SessionLocal()
    doc = DocumentModel(title="test", id=1, content="/tmp/test.txt")
    db.add(doc)
    db.commit()
    db.close()

    response = client.get("/api/documents/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 1
    assert data[0]["title"] == "test"

def test_eliminar_documento(client):
    db = SessionLocal()
    doc = DocumentModel(title="test", id=1, content="/tmp/test.txt")
    db.add(doc)
    db.commit()
    db.refresh(doc)
    doc_id = doc.id
    db.close()

    with open("/tmp/test.txt", "w") as f:
        f.write("test")

    response = client.delete(f"/api/documents/{doc_id}")
    assert response.status_code == 200
    assert response.json()["msg"] == "Documento eliminado"

