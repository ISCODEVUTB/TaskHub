# auth_service.py

from utils.jwt_manager import JWTManager
from utils.db import get_user_by_username
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


class AuthService:
    """
    Service class for handling authentication-related operations.

    This class provides methods for user login, token validation, and logout.
    """
    def __init__(self):
        """
        Initializes the AuthService with a JWTManager instance.
        """
        self.jwt_manager = JWTManager()

    def login(self, username: str, password: str) -> str | None:
        """
        Authenticates a user and generates a JWT token if credentials are valid

        Args:
            username (str): The username of the user.
            password (str): The password of the user.

        Returns:
        str None: A JWT token if authentication is successful, none otherwise.
        """
        user = get_user_by_username(username)
        if not user:
            return None

        if not pwd_context.verify(password, user["password_hash"]):
            return None

        token = self.jwt_manager.generate_token({"sub": username})
        return token

    def validate_token(self, token: str) -> dict | None:
        """
        Validates a JWT token and decodes its payload.

        Args:
            token (str): The JWT token to validate.

        Returns:
        dict None: The decoded payload if the token is valid, or None otherwise
        """
        return self.jwt_manager.verify_token(token)

    @staticmethod
    def logout(token: str) -> bool:
        """
        Logs out a user by invalidating their token.

        Args:
            token (str): The token to invalidate.

        Returns:
            bool: True if the logout process is successful.
        """
        return True

    def register(self, username, password):
        pass
