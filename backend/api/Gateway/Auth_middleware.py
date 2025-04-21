from fastapi import Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware
import httpx


AUTH_SERVICE_URL = "http://localhost:8000"  # Cambiar según tu despliegue


class AuthMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Rutas públicas permitidas
        if request.url.path.startswith("/public"):
            return await call_next(request)

        auth_header = request.headers.get("Authorization")
        if not auth_header or not auth_header.startswith("Bearer "):
            raise HTTPException(
                status_code=401,
                detail="Authorization header missing or invalid"
                )

        token = auth_header.split(" ")[1]

        async with httpx.AsyncClient() as client:
            try:
                response = await client.post(
                    f"{AUTH_SERVICE_URL}/validateToken",
                    json={"token": token}
                    )
                if response.status_code != 200:
                    raise HTTPException(status_code=401,
                                        detail="Invalid token")
                result = response.json()
                request.state.user_info = {
                    "email": result["user"],
                    "role": result["role"]
                }
            except httpx.RequestError:
                raise HTTPException(status_code=503,
                                    detail="AuthService not reachable")

        return await call_next(request)
