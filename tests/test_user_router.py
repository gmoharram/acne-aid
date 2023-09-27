from fastapi import status
import httpx
import pytest


@pytest.mark.asyncio
async def test_sign_up(default_client: httpx.AsyncClient) -> None:
    payload = {"email": "testuser@mail.com", "password": "testpassword"}
    headers = {"accept": "application/json", "Content-Type": "application/json"}
    expected_response = {"message": "User successfully registered!"}

    response = await default_client.post("/user/signup", json=payload, headers=headers)
    assert response.status_code == status.HTTP_200_OK
    assert response.json() == expected_response
