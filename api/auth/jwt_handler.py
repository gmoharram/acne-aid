import time
from datetime import datetime
import os

from fastapi import HTTPException, status
from jose import jwt, JWTError

jwt_secret_key = os.getenv("JWT_SECRET_KEY")
assert jwt_secret_key is not None, "JWT_SECRET_KEY environment variable not defined!"


def create_access_token(user_id: str):
    payload = {
        "user": user_id,
        "expires": time.time() + 3600,
    }
    token = jwt.encode(payload, jwt_secret_key, algorithm="HS256")
    return token


def verify_access_token(token: str):
    try:
        data = jwt.decode(token, jwt_secret_key, algorithms=["HS256"])

        expiration_time = data.get("expires")
        if expiration_time is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="No access token supplied!",
            )
        elif datetime.utcnow() > datetime.utcfromtimestamp(expiration_time):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN, detail="Token expired!"
            )
        return data
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid token."
        )
