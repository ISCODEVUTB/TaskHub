# ExternalToolService

El servicio `ExternalToolService` es una aplicación basada en FastAPI que proporciona una interfaz para interactuar con herramientas externas como servicios de inteligencia artificial, procesamiento de pagos y almacenamiento en la nube.

## Estructura del Proyecto

ExternalToolService/
├── app/
│   ├── app/
│   │   ├── adapters/
│   │   │   ├── __init__.py
│   │   │   ├── ai.py
│   │   │   ├── manager.py
│   │   │   ├── payment.py
│   │   │   ├── storage.py
│   │   ├── main.py

### Archivos Principales

#### `main.py`

Este archivo define las rutas principales de la API y gestiona la autenticación básica.

- __Rutas__:
  - `POST /analyze`: Analiza datos utilizando un servicio de inteligencia artificial.
  - `POST /pay`: Procesa pagos utilizando un adaptador de pago.
  - `GET /storage-url`: Genera una URL de almacenamiento para un archivo.

- __Autenticación__:
  Utiliza autenticación básica con un usuario y contraseña predeterminados (`admin` y `123`).

#### `adapters/manager.py`

Define la clase base `ExternalTool` y el gestor `ExternalToolManager` para interactuar con herramientas externas.

- __Clases__:
  - `ExternalTool`: Clase abstracta que define el método `execute`.
  - `ExternalToolManager`: Clase que utiliza herramientas externas para ejecutar operaciones.

#### `adapters/ai.py`

Implementa el adaptador `AIServiceAdapter` para servicios de inteligencia artificial.

- __Método__:
  - `execute(data)`: Devuelve un resumen y un análisis de sentimiento del contenido proporcionado.

#### `adapters/payment.py`

Implementa el adaptador `PaymentAdapter` para procesamiento de pagos.

- __Método__:
  - `execute(data)`: Simula el procesamiento de un pago y devuelve el estado.

#### `adapters/storage.py`

Implementa el adaptador `CloudStorageAdapter` para generar URLs de almacenamiento.

- __Método__:
  - `execute(data)`: Genera una URL simulada para un archivo.

## Ejemplo de Uso

### Análisis de Datos

```bash
curl -X POST "http://localhost:8000/analyze" \
-H "Authorization: Basic $(echo -n 'admin:123' | base64)" \
-H "Content-Type: application/json" \
-d '{"content": "Este es un ejemplo de texto para analizar."}'
```

### Procesamiento de Pagos

```bash
curl -X POST "http://localhost:8000/pay" \
-H "Authorization: Basic $(echo -n 'admin:123' | base64)" \
-H "Content-Type: application/json" \
-d '{"amount": 100}'
```

### Generación de URL de Almacenamiento

```bash
curl -X GET "http://localhost:8000/storage-url?filename=example.txt" \
-H "Authorization: Basic $(echo -n 'admin:123' | base64)"
```

## Requisitos

- __Python__: 3.8 o superior
- __Dependencias__: FastAPI, Uvicorn

## Instalación

1. Clona el repositorio:

   ```bash
   git clone <url-del-repositorio>
   cd ExternalToolService/app
   ```

2. Instala las dependencias:

   ```bash
   pip install -r requirements.txt
   ```

3. Ejecuta el servidor:

   ```bash
   uvicorn main:app --reload
   ```

## Notas

- Este servicio utiliza autenticación básica para proteger las rutas.
- Los adaptadores implementan lógica simulada y pueden extenderse para integrarse con servicios reales.
