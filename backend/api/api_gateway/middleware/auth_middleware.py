import os
from typing import Awaitable, Callable, Optional

from dotenv import load_dotenv
from fastapi import HTTPException, Request, status
from fastapi.responses import JSONResponse
from jose import ExpiredSignatureError, JWTError, jwt

# Load environment variables
load_dotenv()

SUPABASE_JWT_SECRET = os.getenv("SUPABASE_JWT_SECRET")
SUPABASE_AUDIENCE = os.getenv("SUPABASE_AUDIENCE", "authenticated")
# Optional: Add SUPABASE_ISSUER if you want to validate the 'iss' claim, e.g.:
# SUPABASE_ISSUER = os.getenv("SUPABASE_ISSUER")


async def auth_middleware(
    request: Request, call_next: Callable[[Request], Awaitable[JSONResponse]]
) -> JSONResponse:
    if request.method == "OPTIONS":
        return await call_next(request)
    """
    Middleware for authentication.

    Args:
        request (Request): FastAPI request
        call_next (Callable[[Request], Awaitable[JSONResponse]]): Next middleware or route handler

    Returns:
        JSONResponse: Response
    """
    # Skip authentication for certain paths
    if _should_skip_auth(request.url.path):
        return await call_next(request)

    # Get token from request
    token = _get_token_from_request(request)

    # Check if token exists
    if not token:
        return JSONResponse(
            status_code=status.HTTP_401_UNAUTHORIZED,
            content={"detail": "Not authenticated"},
        )

    # Validate token
    try:
        user_id = await _validate_token(token)

        # Add user ID to request state
        request.state.user_id = user_id

        # Continue with request
        return await call_next(request)
    except HTTPException as e:
        return JSONResponse(status_code=e.status_code, content={"detail": e.detail})
    except Exception as e:
        return JSONResponse(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            content={"detail": str(e)},
        )


def _should_skip_auth(path: str) -> bool:
    """
    Check if authentication should be skipped for a path.

    Args:
        path (str): Request path

    Returns:
        bool: True if authentication should be skipped, False otherwise
    """
    # Skip authentication for health check and auth endpoints
    skip_paths = [
        "/health",
        "/docs",
        "/redoc",
        "/openapi.json",
        "/auth/login",
        "/auth/register",
        "/auth/refresh",
    ]

    return any(path.startswith(skip_path) for skip_path in skip_paths)


def _get_token_from_request(request: Request) -> Optional[str]:
    """
    Get token from request.

    Args:
        request (Request): FastAPI request

    Returns:
        Optional[str]: Token or None
    """
    # Get token from Authorization header
    authorization = request.headers.get("Authorization")

    if authorization and authorization.startswith("Bearer "):
        return authorization.replace("Bearer ", "")

    return None


async def _validate_token(token: str) -> str:
    if not SUPABASE_JWT_SECRET:
        print('ERROR: SUPABASE_JWT_SECRET is not configured in the environment.')
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail='Authentication system configuration error.',
        )

    try:
        payload = jwt.decode(
            token,
            SUPABASE_JWT_SECRET,
            algorithms=['HS256'], 
            audience=SUPABASE_AUDIENCE
            # If validating issuer, add: issuer=SUPABASE_ISSUER 
        )
        
        user_id = payload.get('sub')
        if not user_id:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail='Invalid token: User ID (sub) not found in token.',
            )
        
        return user_id

    except ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail='Token has expired.'
        )
    except JWTError as e:
        print(f'JWTError during token validation: {str(e)}') # Server log
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Invalid token.', 
        )
    except Exception as e:
        print(f'Unexpected error during token validation: {str(e)}') # Server log
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail='An unexpected error occurred during token validation.',
        )
