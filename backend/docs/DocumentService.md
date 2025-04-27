```markdown
# Document Service

El microservicio **Document Service** es responsable de gestionar documentos, permitiendo su creación, listado y eliminación. Este servicio está construido con **FastAPI** y utiliza **SQLAlchemy** para la gestión de la base de datos.

## Endpoints

### 1. Subir Documento
**POST** `/api/documents/`

Sube un nuevo documento al sistema.

#### Parámetros:
- `nombre` (form-data, requerido): Nombre del documento.
- `proyecto_id` (form-data, requerido): ID del proyecto asociado.
- `archivo` (form-data, requerido): Archivo a subir.

#### Respuesta:
- **200 OK**: Devuelve el documento creado.
- **Ejemplo de respuesta:**
  ```json
  {
    "id": 1,
    "title": "Documento de ejemplo",
    "content": "Contenido del documento",
    "author": "Autor"
  }
  ```

---

### 2. Listar Documentos
**GET** `/api/documents/`

Obtiene una lista de todos los documentos almacenados.

#### Respuesta:
- **200 OK**: Devuelve una lista de documentos.
- **Ejemplo de respuesta:**
  ```json
  [
    {
      "id": 1,
      "title": "Documento de ejemplo",
      "content": "Contenido del documento",
      "author": "Autor"
    }
  ]
  ```

---

### 3. Eliminar Documento
**DELETE** `/api/documents/{doc_id}`

Elimina un documento por su ID.

#### Parámetros:
- `doc_id` (path, requerido): ID del documento a eliminar.

#### Respuesta:
- **200 OK**: Documento eliminado exitosamente.
- **404 Not Found**: Si el documento no existe.
- **Ejemplo de respuesta:**
  ```json
  {
    "msg": "Documento eliminado"
  }
  ```

---

## Estructura del Proyecto

```
backend/
└── api/
    └── Documents-service/
        ├── database.py
        ├── document_service.py
        ├── src/
            ├── models/
            │   ├── document.py
            │   └── document_schema.py
            └── routes/
                └── document_routes.py
```

### Archivos principales:
- **`database.py`**: Configuración de la base de datos SQLite y creación de la sesión.
- **`document_service.py`**: Punto de entrada del microservicio.
- **`document_routes.py`**: Define los endpoints del servicio.
- **`document.py`**: Modelo de base de datos para documentos.
- **`document_schema.py`**: Esquemas de Pydantic para validación de datos.

---

## Configuración de la Base de Datos

El servicio utiliza una base de datos SQLite. La configuración se encuentra en el archivo [`database.py`](backend/api/Documents-service/database.py):

```python
DATABASE_URL = "sqlite:///./documents.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
```

---

## Notificaciones

El servicio envía notificaciones a un microservicio externo cuando se sube o elimina un documento. Esto se realiza mediante el método `notify` en [`document_routes.py`](backend/api/Documents-service/src/routes/document_routes.py):

```python
def notify(action: str, doc_id: int):
    try:
        requests.post("http://notification-service/notify", json={
            "action": action,
            "document_id": doc_id
        })
    except:
        print(f"No se pudo notificar la acción {action} del documento {doc_id}")
```

---

## Instalación y Ejecución

1. Clona el repositorio.
2. Instala las dependencias:
   ```bash
   pip install -r requirements.txt
   ```
3. Ejecuta el servicio:
   ```bash
   uvicorn document_service:app --reload
   ```

---

## Dependencias

- **FastAPI**: Framework para construir APIs.
- **SQLAlchemy**: ORM para la gestión de la base de datos.
- **Pydantic**: Validación de datos.

---