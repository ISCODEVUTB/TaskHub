from fastapi import FastAPI, HTTPException, Depends
from auth_service import AuthService
from models import LoginRequest, TokenResponse
from utils.jwt_manager import get_current_user

app = FastAPI()
auth_service = AuthService()


@app.post("/login", response_model=TokenResponse)
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


@app.get("/validate")
def validate_route(user=Depends(get_current_user)):
    """
    Endpoint to validate a JWT token.

    Args:
    user: The user information extracted from the token (injected by Depends).

    Returns:
        dict: A message indicating the token is valid and the user information.
    """
    return {"message": f"Token válido. Usuario: {user['sub']}"}

    return {"message": f"Token válido. Usuario: {user['sub']}"}


@app.post("/logout")
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
