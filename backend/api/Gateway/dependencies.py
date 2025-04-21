from fastapi import Request, HTTPException


def require_role(allowed_roles: list[str]):
    async def role_checker(request: Request):
        user_info = getattr(request.state, "user_info", None)
        if not user_info or user_info["role"] not in allowed_roles:
            raise HTTPException(status_code=403,
                                detail="Forbidden: insufficient role")
        return user_info
    return role_checker
