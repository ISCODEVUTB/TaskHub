# API Gateway

## Descripción General

El API Gateway es el punto de entrada centralizado para la aplicación TaskHub. Gestiona y enruta las solicitudes a los microservicios correspondientes, proporcionando una interfaz unificada para los clientes. Implementado con FastAPI, incluye características como autenticación, manejo de errores y enrutamiento de solicitudes.

## Estructura del Proyecto

📁 Gateway/
├── 📄 main.py
├── 📄 config.py
├── 📄 Auth_middleware.py
├── 📄 dependencies.py
└── 📁 routes/
    ├── 📄 __init__.py
    ├── 📄 projects.py
    ├── 📄 documents.py
    ├── 📄 externaltools.py
    └── 📄 notification.py

## Componentes Principales

### 1. `main.py`

Punto de entrada principal que configura la aplicación FastAPI y registra los routers:

- Configuración de CORS
- Registro de rutas de microservicios
- Endpoints de salud y raíz

### 2. `config.py`

Gestiona la configuración del gateway usando Pydantic:

```python
class Settings(BaseSettings):
    AUTH_SERVICE_URL: str = "http://localhost:8000"
    PROJECT_SERVICE_URL: str = "http://localhost:8001"
    DOCUMENT_SERVICE_URL: str = "http://localhost:8002"
    NOTIFICATION_SERVICE_URL: str = "http://localhost:8003"
    EXTERNAL_SERVICE_URL: str = "http://localhost:8004"
    JWT_ALGORITHM: str = "HS256"
```

### 3. `Auth_middleware.py`

Middleware de autenticación que:

- Valida tokens JWT
- Gestiona roles de usuario
- Protege rutas no públicas

### 4. Rutas Implementadas

#### Proyectos (`/api/projects`)

- `POST /`: Crear nuevo proyecto
- `GET /`: Listar todos los proyectos
- `GET /{project_id}`: Obtener proyecto específico
- `PUT /{project_id}`: Actualizar proyecto
- `DELETE /{project_id}`: Eliminar proyecto

#### Documentos (`/api/documents`)

- `POST /`: Subir nuevo documento
- `GET /{document_id}`: Obtener documento
- `PUT /{document_id}`: Actualizar documento
- `DELETE /{document_id}`: Eliminar documento

#### Herramientas Externas (`/api/externaltools`)

- `POST /analyze`: Análisis de texto
- `POST /pay`: Procesamiento de pagos
- `GET /storage-url`: Obtener URL de almacenamiento

#### Notificaciones (`/api/notifications`)

- `POST /email`: Enviar notificación por email
- `POST /push`: Enviar notificación push

## Manejo de Errores

El gateway implementa un manejo de errores consistente:

- `401`: Error de autenticación
- `403`: Error de permisos
- `404`: Recurso no encontrado
- `500`: Error interno del servidor
- Errores específicos de microservicios

## Seguridad

### Autenticación

- Validación de tokens JWT
- Middleware de autenticación personalizado
- Verificación de roles de usuario

### CORS

Configuración de CORS para permitir:

- Todos los orígenes (configurable)
- Métodos HTTP estándar
- Headers personalizados

## Consideraciones Técnicas

### Escalabilidad

- Diseño sin estado
- Fácil adición de nuevos microservicios
- Balanceo de carga preparado

### Mantenibilidad

- Estructura modular
- Configuración centralizada
- Documentación automática con OpenAPI

### Monitoreo

- Endpoint de salud (`/api/health`)
- Logging de errores
- Métricas de rendimiento

## Dependencias Principales

- __FastAPI__: Framework web moderno y rápido
- __httpx__: Cliente HTTP asíncrono
- __pydantic__: Validación de datos
- __python-jose__: Manejo de JWT

## Instalación y Ejecución

1. Instalar dependencias:

```bash
pip install -r requirements.txt
```

2.Configurar variables de entorno o usar valores por defecto en `config.py`

3.Ejecutar el gateway:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## Endpoints Base

### Root

```code
GET /
Response: {"message": "Welcome to TaskHub API"}
```

### Health Check

```code
GET /api/health
Response: {"status": "healthy"}
```

## Notas de Desarrollo

- Todos los endpoints requieren autenticación excepto las rutas públicas
- Las respuestas de error incluyen detalles útiles para debugging
- Los timeouts están configurados para manejar latencia de servicios
- Implementa retry patterns para tolerancia a fallos
