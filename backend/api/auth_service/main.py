from fastapi import FastAPI, APIRouter, HTTPException, Depends
from auth_service import AuthService
from models.schemas import LoginRequest, TokenResponse
from utils.dependencies import get_current_user

app = FastAPI(title="Auth Service", version="1.0.0")
router = APIRouter(prefix="/api/auth")  # Añadimos el prefijo

auth_service = AuthService()


@router.post("/login", response_model=TokenResponse)
def login_route(request: LoginRequest):
    """
    Endpoint for user login.

    Args:
    request (LoginRequest): The login request containing username and password.

    Returns:
    TokenResponse: A response containing the access token if login is done.

    Raises:
        HTTPException: If the credentials are invalid.
    """
    token = auth_service.login(request.username, request.password)
    if not token:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return TokenResponse(access_token=token)


@router.post("/register", status_code=201)  # Añadimos la ruta de registro
def register_route(request: LoginRequest):
    """
    Endpoint for user registration.

    Args:
    request (LoginRequest): The registration
    request containing username and password.

    Returns:
        dict: A response containing the user ID.
    """
    user_id = auth_service.register(request.username, request.password)
    return {"id": user_id}


@router.get("/validate")
def validate_route(user=Depends(get_current_user)):
    """
    Endpoint to validate a JWT token.

    Args:
    user: The user information extracted from the token (injected by Depends).

    Returns:
        dict: A message indicating the token is valid and the user information.
    """
    return {"message": f"Token válido. Usuario: {user['sub']}"}


@router.post("/logout")
def logout_route(token: str):
    """
    Endpoint for user logout.

    Args:
        token (str): The token to invalidate.

    Returns:
        dict: A message indicating the session was closed successfully.

    Raises:
        HTTPException: If the logout process fails.
    """
    success = auth_service.logout(token)
    if not success:
        raise HTTPException(status_code=400, detail="Logout failed")
    return {"message": "Sesión cerrada correctamente"}


@app.get("/")
def root():
    """
    Root endpoint to check if the service is running.

    Returns:
        dict: A message indicating the service is running.
    """
    return {"message": "Auth Service is running"}


# Añadimos el router al final
app.include_router(router)
