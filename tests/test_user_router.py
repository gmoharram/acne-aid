from fastapi import status
import httpx
import pytest

from tests.fixtures import *


@pytest.mark.asyncio
async def test_sign_up(mocker, default_client: httpx.AsyncClient) -> None:
    mocker.patch("routes.user.insert_record", return_value=None)
    payload = {
        "email": "testuser@mail.com",
        "password": "testpassword",
        "username": "test-user",
        "sex": "female",
        "birthdate": "2000-01-07",
    }
    headers = {"accept": "application/json", "Content-Type": "application/json"}
    expected_response = {"data": None, "message": "User successfully registered!"}

    response = await default_client.post("/user/signup", json=payload, headers=headers)
    assert response.status_code == status.HTTP_201_CREATED
    assert response.json() == expected_response
