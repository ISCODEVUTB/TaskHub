from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
import os

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/login")
JWT_SECRET = os.getenv("JWT_SECRET")
ALGORITHM = "HS256"


def get_current_user(token: str = Depends(oauth2_scheme)):
    """
    Extracts the current user from the provided JWT token.

    Args:
        token (str): The JWT token provided in the request.

    Returns:
        dict: A dictionary containing the username and role of the user.

    Raises:
        HTTPException: If the token is invalid or missing required fields.
    """
    try:
        payload = jwt.decode(token, JWT_SECRET, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        role: str = payload.get("role")
        if username is None or role is None:
            raise HTTPException(status_code=401, detail="Invalid token")
        return {"username": username, "role": role}
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")


def role_required(required_role: str):
    """
    Dependency to enforce role-based access control.

    Args:
        required_role (str): The role required to access the endpoint.

    Returns:
        Callable: A dependency function that checks the user's role.

    Raises:
        HTTPException: If the user's role does not match the required role.
    """
    def role_checker(user: dict = Depends(get_current_user)):
        if user["role"] != required_role:
            raise HTTPException(status_code=403, detail="Forbidden")
        return user
    return role_checker
