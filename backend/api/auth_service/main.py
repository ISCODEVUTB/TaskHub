from fastapi import FastAPI, APIRouter, HTTPException, Depends
from .auth_service import AuthService
from .models.schemas import LoginRequest, TokenResponse
from .utils.dependencies import get_current_user
import os

app = FastAPI(title="Auth Service", version="1.0.0")
router = APIRouter(prefix="/api/auth")


# === Nuevo: función para inyectar el servicio ===
def get_auth_service():
    return AuthService()


@router.post("/login", response_model=TokenResponse)
def login_route(
    request: LoginRequest,
    auth_service: AuthService = Depends(get_auth_service)
):
    token = auth_service.login(request.username, request.password)
    if not token:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return TokenResponse(access_token=token)


@router.post("/register", status_code=201)
def register_route(
    request: LoginRequest,
    auth_service: AuthService = Depends(get_auth_service)
):
    user_id = auth_service.register(request.username, request.password)
    return {"id": user_id}


@router.get("/validate")
def validate_route(user=Depends(get_current_user)):
    return {"message": f"Token válido. Usuario: {user['sub']}"}


@router.post("/logout")
def logout_route(
    token: str,
    auth_service: AuthService = Depends(get_auth_service)
):
    success = auth_service.logout(token)
    if not success:
        raise HTTPException(status_code=400, detail="Logout failed")
    return {"message": "Sesión cerrada correctamente"}


@app.get("/")
def root():
    return {"message": "Auth Service is running"}


# Finalmente, añadimos las rutas
app.include_router(router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        app,
        host=str(os.getenv("HOST", "127.0.0.1")),
        port=int(os.getenv("PORT", 8000)),
        log_level="info"
    )
