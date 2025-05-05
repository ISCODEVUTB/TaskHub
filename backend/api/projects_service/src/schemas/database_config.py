from pydantic import BaseModel, Field
from typing import Optional


class DatabaseConfig(BaseModel):
    """Configuración de conexión a base de datos"""
    db_type: str = Field(..., description="Tipo de base de datos a utilizar")
    # PostgreSQL config
    postgresql_url: Optional[str] = Field(
        default="postgresql://postgres:password@localhost\
            :5432/taskhub_projects"
    )
    # MongoDB config
    mongodb_url: Optional[str] = Field(
        default="mongodb://localhost:27017"
    )
    mongodb_database: Optional[str] = Field(
        default="taskhub_projects"
    )
    # JSON config
    json_file_path: Optional[str] = Field(
        default="projects.json"
    )

    @classmethod
    def from_env(cls) -> 'DatabaseConfig':
        """Crear configuración desde variables de entorno"""
        from dotenv import load_dotenv
        import os
        load_dotenv()
        return cls(
            db_type=os.getenv("DB_USE", "JSONDB"),
            postgresql_url=os.getenv("POSTGRESQL_URL"),
            mongodb_url=os.getenv("MONGODB_URL"),
            mongodb_database=os.getenv("MONGODB_DATABASE"),
            json_file_path=os.getenv("JSON_FILE_PATH")
        )
