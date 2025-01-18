import psycopg2
from psycopg2 import OperationalError
from psycopg2.extras import RealDictCursor
import os
from dotenv import load_dotenv

# load the .env file
load_dotenv("/workspaces/moolah-di-ob-la-da/.env")

def connect_db():

    try:
        # get local variables from .env
        conn = psycopg2.connect(
            user = os.getenv("DB_USER"),
            password = os.getenv("DB_PASSWORD"), 
            database = os.getenv("DB_NAME"),
            host = os.getenv("DB_HOST", "localhost"),
            port = os.getenv("DB_PORT", "5432")
        )
        print("Wooohooo! Connection successful!")
        # return connection
        return conn
    # operationalerror to catch connection issue specifically first
    except OperationalError as e:
        print(f"Error connecting to the database: {e}")
    # general catch all
    except Exception as e:
        print(f"Exception: An unexpected error occurred: {e}")
        return None


def get_cursor(conn):
    # returning a cursor where rows can be accessed by column name like a dict
    return conn.cursor()
