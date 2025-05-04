from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os
from dotenv import load_dotenv
import logging

load_dotenv()

# Configuración de logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuración de base de datos
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:password@localhost:5432/taskhub_projects"
    )
DB_TYPE = os.getenv("DB_USE", "PostgreSQL")

# Crear engine según el tipo de base de datos
if DB_TYPE == "PostgreSQL":
    engine = create_engine(DATABASE_URL, pool_pre_ping=True)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
else:
    raise ValueError(f"Tipo de base de datos no soportado: {DB_TYPE}")

Base = declarative_base()

__all__ = ['Base', 'SessionLocal', 'engine']


# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
