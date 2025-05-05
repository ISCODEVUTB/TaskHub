import os
from src.database.database import SessionLocal
from src.database.JSONDB import JSONDB
from src.database.PostgreSQLDB import PostgreSQLDB
from src.database.MongoDB import MongoDB


def get_repo():
    """
    Selecciona el repositorio de base de datos según la configuración
    """
    db_type = os.getenv("DB_USE", "JSONDB")

    if db_type == "PostgreSQL":
        db = SessionLocal()
        try:
            return PostgreSQLDB(db)
        finally:
            db.close()
    elif db_type == "MongoDB":
        return MongoDB()
    else:
        return JSONDB("projects.json")
