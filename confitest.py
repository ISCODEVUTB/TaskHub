"""
Archivo conftest.py raíz que importa fixtures específicos de cada servicio.
Este archivo debe colocarse en la raíz del proyecto.
"""
import pytest
import sys
from pathlib import Path

# Obtener la ruta raíz del proyecto
ROOT_DIR = Path(__file__).parent.absolute()

# Asegurar que la raíz del proyecto esté en sys.path
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))


# Función para importar fixtures de un servicio específico
def import_service_fixtures(service_name, fixture_file):
    """
    Importa fixtures de un servicio específico de manera segura.

    Args:
        service_name: Nombre del servicio (ej. 'Auth-service')
        fixture_file: Nombre del archivo de fixtures (ej. 'auth_fixtures.py')
    """
    service_path = ROOT_DIR / 'backend' / 'api' / service_name / 'tests'
    fixture_path = service_path / fixture_file

    if not service_path.exists():
        print(f"Advertencia: La ruta {service_path} no existe")
        return

    if not fixture_path.exists():
        print(f"Advertencia: El archivo de fixtures {fixture_path} no existe")
        return

    # Añadir la ruta del servicio al sys.path temporalmente
    if str(service_path.parent) not in sys.path:
        sys.path.insert(0, str(service_path.parent))

    # Importar el módulo de fixtures
    module_name = f"tests.{fixture_file[:-3]}"  # Quitar la extensión .py
    try:
        __import__(module_name)
        print(f"Fixtures importados correctamente de {service_name}")
    except ImportError as e:
        print(f"Error importando fixtures de {service_name}: {e}")
    # Opcional: Eliminar la ruta temporal para evitar conflictos
    if str(service_path.parent) in sys.path:
        sys.path.remove(str(service_path.parent))


# Importar fixtures de cada servicio
import_service_fixtures('auth_service', 'auth_fixtures.py')
import_service_fixtures('notifications_service', 'notifications_fixtures.py')
import_service_fixtures('documents_service', 'document_fixtures.py')
import_service_fixtures('gateway', 'gateway_fixtures.py')


# Fixtures globales compartidos por todos los servicios
@pytest.fixture
def base_mock_db():
    """Base mock database que puede ser utilizada por todos los servicios"""
    from unittest.mock import MagicMock
    return MagicMock()


@pytest.fixture
def global_config():
    """Configuración global para todos los tests"""
    return {
        "environment": "test",
        "log_level": "ERROR",
        "timeout": 5
    }


@pytest.fixture
def global_app_context():
    """Contexto global de la aplicación para pruebas"""
    return {
        "app_name": "TaskHub",
        "version": "1.0.0",
        "testing": True
    }
