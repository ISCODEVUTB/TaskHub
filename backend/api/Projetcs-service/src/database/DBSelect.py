from database.JSONDB import JSONDB
from database.PostgreSQLDB import PostgreSQLDB
from sqlalchemy import SessionLocal
from pymongo import MongoClient
from database.MongoDB import MongoDB


def get_repo(db_type: str):
    """Get the appropriate database repository based on the type."""
    if db_type == "JSONDB":
        return JSONDB("projects.json")

    elif db_type == "PostgreSQL":
        return PostgreSQLDB(SessionLocal())

    elif db_type == "MongoDB":
        return MongoDB(MongoClient("mongodb://localhost:27017/"),
                       "projects_db")

    else:
        raise ValueError("Unknown DB type")
