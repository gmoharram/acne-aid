import os
from contextlib import contextmanager

from sqlmodel import SQLModel, Session, create_engine

from models.user import User


db_uri = os.getenv("DB_URI")
assert db_uri is not None, "DB_URI environment variable not defined!"
engine = create_engine(db_uri, echo=True)


def conn():
    # Whenever you create a class that inherits from SQLModel and is
    # configured with table = True, it is registered in this metadata attribute.
    # For that the class definitions have to be executed though
    # (e.g. importing User classes above)

    SQLModel.metadata.create_all(engine)


def get_session():
    with Session(engine) as session:
        yield session
