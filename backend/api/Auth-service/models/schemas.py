from pydantic import BaseModel


class LoginRequest(BaseModel):
    """
    Schema for a login request.

    Attributes:
        username (str): The username of the user.
        password (str): The password of the user.
    """
    username: str
    password: str


class TokenResponse(BaseModel):
    """
    Schema for a token response.

    Attributes:
        access_token (str): The access token issued to the user.
        token_type (str): The type of the token, default is "bearer".
    """
    access_token: str
    token_type: str = "bearer"


class TokenValidationRequest(BaseModel):
    """
    Schema for a token validation request.

    Attributes:
        token (str): The token to be validated.
    """
    token: str
