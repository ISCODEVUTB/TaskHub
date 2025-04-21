from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    AUTH_SERVICE_URL: str = "http://localhost:8000"
    PROJECT_SERVICE_URL: str = "http://localhost:8001"
    DOCUMENT_SERVICE_URL: str = "http://localhost:8002"
    NOTIFICATION_SERVICE_URL: str = "http://localhost:8003"
    EXTERNAL_SERVICE_URL: str = "http://localhost:8004"
    JWT_ALGORITHM: str = "HS256"


settings = Settings()
