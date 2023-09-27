import asyncio
import httpx
import pytest

from main import app
from models.user import User


@pytest.fixture(scope="session")
async def default_client():
    async with httpx.AsyncClient(app=app, base_url="http://app") as client:
        yield client
