import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()


def get_connection():
    """
    Establishes a connection to the PostgreSQL database.

    Returns:
    psycopg2.extensions.connection: A connection object to interact with db.
    """
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        dbname=os.getenv("DB_NAME")
    )


def get_user_by_username(username: str) -> dict | None:
    """
    Retrieves a user's details from the database by their username.

    Args:
        username (str): The username of the user to retrieve.

    Returns:
    dict None: A dictionary containing the usernames and passwords.
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT username, password_hash FROM users = %s", (username,))
            row = cur.fetchone()
            if row:
                return {"username": row[0], "password_hash": row[1]}
    finally:
        conn.close()
    return None
