import os
from typing import Generator

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy.pool import NullPool

# Load environment variables
load_dotenv()

# Database URL
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./test.db") 
print(f"🔌 Intentando conectarse a la base de datos:\n{DATABASE_URL}")
# Create database engine
engine = create_engine(DATABASE_URL, poolclass=NullPool)

try:
    conn = engine.connect()
    print("✅ Conexión exitosa")
    conn.close()
except Exception as e:
    print("❌ Error:", str(e))

# Create session local
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db() -> Generator[Session, None, None]:
    """
    Get database session.

    Yields:
        Session: Database session
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
