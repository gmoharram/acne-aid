from fastapi import APIRouter, Depends, status, HTTPException
from firebase_admin import auth as firebase_auth

from app.auth.authenticate import firebase, authenticate
from app.database.connection import get_session
from app.database.querying import (
    insert_record,
    get_record,
    get_records_by_field,
    update_record,
    delete_record,
)
from app.models.user import UserSignup, UserSignin, User, UserUpdate
from app.models.response import (
    ResponseModel,
    ResponseOneUser,
    TokenResponse,
)


user_router = APIRouter(tags=["Users"])


@user_router.post(
    "/user/signup",
    response_model=ResponseModel,
    status_code=status.HTTP_201_CREATED,
)
async def signup_user(user_data: UserSignup, session=Depends(get_session)) -> dict:
    try:
        firebase_user = firebase_auth.create_user(
            email=user_data.email, password=user_data.password
        )

        user = User(
            firebase_id=firebase_user.uid,
            email=user_data.email,
            username=user_data.username,
            sex=user_data.sex,
            birthdate=user_data.birthdate,
        )
        await insert_record(user, session)

        return {"message": "User successfully registered!"}

    except firebase_auth.EmailAlreadyExistsError:
        raise HTTPException(
            status_code=400, detail="User with this email already exists."
        )


@user_router.post("/user/signin", response_model=TokenResponse)
async def singin_user(user_data: UserSignin, session=Depends(get_session)) -> dict:

    # authenticate user with password via firebase
    try:
        firebase_user = firebase.auth().sign_in_with_email_and_password(
            user_data.email, user_data.password
        )  # Caution: Not the same datatype as in signup function
        firebase_token = firebase_user["idToken"]

        user = await get_records_by_field(
            firebase_user["localId"], "firebase_id", User, session
        )
        user = user[0]
        assert user.email == user_data.email, "Major error in user authentication."

        return {"access_token": firebase_token, "data": {"user_id": user.id}}

    except firebase_auth.EmailNotFoundError:
        raise HTTPException(status_code=400, detail="Invalid email.")
    except ValueError:  # TODO: Check if this occurs in other cases
        raise HTTPException(status_code=400, detail="Invalid password.")


@user_router.get("/user/get", response_model=ResponseOneUser)
async def retrieve_user(
    user_id: int = Depends(authenticate),
    session=Depends(get_session),
) -> dict:
    record = await get_record(user_id, User, session)
    return {"data": record}


@user_router.put("/user/", response_model=ResponseOneUser)
async def update_user(
    updated_user: UserUpdate,
    user_id: int = Depends(authenticate),
    session=Depends(get_session),
) -> dict:
    record = await update_record(user_id, User, updated_user, session)
    return {"message": "User sucessfully updated!", "data": record}


@user_router.delete("/user/", response_model=ResponseModel)
async def delete_user(
    user_id: int = Depends(authenticate),
    session=Depends(get_session),
) -> dict:
    await delete_record(user_id, User, session)
    return {"message": "User successfully deleted!"}
