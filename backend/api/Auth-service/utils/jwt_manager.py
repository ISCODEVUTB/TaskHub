import jwt
from datetime import datetime, timedelta, timezone
from dotenv import load_dotenv
import os


load_dotenv()

SECRET_KEY = os.getenv("JWT_SECRET", "secretkey")
ALGORITHM = "HS256"
TOKEN_EXPIRE_MINUTES = 60


class JWTManager:
    """
    A utility class for managing JSON Web Tokens (JWT).

    This class provides methods to generate and verify JWTs using a secret key
    and specified algorithm.
    """
    def generate_token(self, data: dict) -> str:
        """
        Generates a JWT with the given data and expiration time.

        Args:
            data (dict): The payload data to include in the token.

        Returns:
            str: The encoded JWT as a string.
        """
        expires = datetime.now(timezone.utc) + timedelta(hours=1)  # Usamos UTC
        to_encode = data.copy()
        to_encode.update({"exp": expires})
        return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

    def verify_token(self, token: str) -> dict | None:
        """
        Verifies and decodes a JWT.

        Args:
            token (str): The JWT to verify.

        Returns:
        dict None:The decoded payload if the token is valid, or None if no.
        """
        try:
            return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        except jwt.ExpiredSignatureError:
            print("Expired Token")
        except jwt.InvalidTokenError:
            print("Invalid token")
        return None
