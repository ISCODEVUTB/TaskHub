# Auth-Service

## Descripción General
El `auth-service` es un microservicio responsable de gestionar la autenticación de usuarios, incluyendo inicio de sesión, validación de tokens y cierre de sesión. Utiliza FastAPI para la capa de API e integra una base de datos PostgreSQL para los datos de los usuarios.

---

## Estructura de Carpetas

📁 auth-service  
├── 📁 models  
│   ├── 📄 schemas.py  
├── 📁 utils  
│   ├── 📄 db.py  
│   ├── 📄 jwt_manager.py  
│   ├── 📄 dependencies.py  
├── 📄 auth_service.py  
├── 📄 main.py  

---

## Descripción de Archivos

### 1. `models/schemas.py`
- Contiene modelos de Pydantic para la validación de solicitudes y respuestas.
- Ejemplo:
  ```python
  class LoginRequest(BaseModel):
      username: str
      password: str
  ```

### 2. `utils/db.py`
- Maneja las conexiones y consultas a la base de datos.
- Ejemplo:
  ```python
  def get_connection():
      """Establece una conexión con la base de datos PostgreSQL."""
  ```

### 3. `utils/jwt_manager.py`
- Administra los JSON Web Tokens (JWT) para la autenticación.
- Ejemplo:
  ```python
  def generate_token(data: dict) -> str:
      """Genera un JWT con la carga útil proporcionada."""
  ```

### 4. `utils/dependencies.py`
- Proporciona dependencias reutilizables para las rutas de FastAPI, como la validación de tokens.
- Ejemplo:
  ```python
  def get_current_user(token: str = Depends(oauth2_scheme)):
      """Extrae el usuario actual del token JWT."""
  ```

### 5. `auth_service.py`
- Implementa la lógica principal de autenticación, incluyendo inicio de sesión y validación de tokens.
- Ejemplo:
  ```python
  def login(self, username: str, password: str) -> str | None:
      """Autentica a un usuario y genera un token JWT."""
  ```

### 6. `main.py`
- Define la aplicación FastAPI y las rutas para el servicio de autenticación.
- Ejemplo:
  ```python
  @router.post("/login", response_model=TokenResponse)
  def login_route(request: LoginRequest):
      """Punto de entrada para el inicio de sesión del usuario."""
  ```

---

## Funcionalidades

- **Inicio de Sesión**: Valida las credenciales del usuario y genera tokens JWT.
- **Validación de Tokens**: Verifica la validez de los tokens JWT.
- **Cierre de Sesión**: Invalida las sesiones de los usuarios (implementación futura).

---

## Flujo de Datos

1. El usuario envía una solicitud de inicio de sesión con sus credenciales.
2. El servicio valida las credenciales contra la base de datos.
3. Si son válidas, se genera y devuelve un token JWT.
4. Las solicitudes posteriores utilizan el token para la autenticación.

---

## Consideraciones

- **Seguridad**: Asegúrate de que el `JWT_SECRET` se almacene de forma segura (por ejemplo, en variables de entorno).
- **Escalabilidad**: El servicio está diseñado para ser sin estado, lo que lo hace escalable.
- **Extensibilidad**: Es fácil agregar nuevos métodos de autenticación o backends de bases de datos.