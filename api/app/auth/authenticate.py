import os
import json

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
import firebase_admin
import pyrebase

# Initialize Firebase Admin SDK for Authentication
firebase_keyfile = os.getenv("FIREBASE_SERVICE_ACCOUNT_KEY_FILE")
if not firebase_admin._apps:
    firebase_cred = firebase_admin.credentials.Certificate(firebase_keyfile)
    firebase_admin.initialize_app(firebase_cred)
firebase_config = json.load(open(os.getenv("FIREBASE_CONFIG_FILE"), "r"))
firebase = pyrebase.initialize_app(firebase_config)

# Which route to get the token from
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/user/signin")


async def authenticate(token: str = Depends(oauth2_scheme)) -> str:
    if not token:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Sign in for access."
        )

    return token["data"]["user_id"]
