from fastapi import APIRouter, Depends, Path, status
from fastapi.security import OAuth2PasswordRequestForm
import pdb

from auth.jwt_handler import create_access_token
from auth.hash_password import HashPassword
from database.connection import get_session
from database.querying import (
    insert_record,
    get_record,
    get_records_by_field,
    update_record,
    delete_record,
    select_all,
)
from models.user import User, UserUpdate
from models.response import (
    ResponseModel,
    ResponseAllUsers,
    ResponseOneUser,
    TokenResponse,
)

password_hasher = HashPassword()
user_router = APIRouter(tags=["Users"])


@user_router.post(
    "/user/signup",
    response_model=ResponseModel,
    status_code=status.HTTP_201_CREATED,
)
async def signup_user(user: User, session=Depends(get_session)) -> dict:
    hashed_password = password_hasher.create_hash(user.password)
    user.password = hashed_password
    await insert_record(user, session)
    return {"message": "User successfully registered!"}


@user_router.post("/user/signin", response_model=TokenResponse)
async def singin_user(
    user_form: OAuth2PasswordRequestForm = Depends(), session=Depends(get_session)
) -> dict:
    # check that there is exactly one user with the email provided
    users_found = await get_records_by_field(user_form.username, "email", User, session)
    assert len(users_found) == 1
    user = users_found[0]

    # authenticate user with password
    if password_hasher.verify_hash(user_form.password, user.password):
        access_token = create_access_token(user.id)
        return {
            "message": "Sign-in successful!",
            "access_token": access_token,
            "token_type": "Bearer",
        }


@user_router.get("/user/{user_id}", response_model=ResponseOneUser)
async def retrieve_user(
    user_id: int = Path(..., title="The ID of the user to retrieve."),
    session=Depends(get_session),
) -> dict:
    record = await get_record(user_id, User, session)
    return {"data": record}


@user_router.get("/user/", response_model=ResponseAllUsers)
async def retrieve_all_users(session=Depends(get_session)) -> dict:
    records = await select_all(User, session)
    return {"data": records}


@user_router.put("/user/{user_id}", response_model=ResponseOneUser)
async def update_user(
    user_id: int, updated_user: UserUpdate, session=Depends(get_session)
) -> dict:
    record = await update_record(user_id, User, updated_user, session)
    return {"message": "User sucessfully updated!", "data": record}


@user_router.delete("/user/{user_id}", response_model=ResponseModel)
async def delete_user(
    user_id: int = Path(..., title="The ID of the user to delete"),
    session=Depends(get_session),
) -> dict:
    await delete_record(user_id, User, session)
    return {"message": "User successfully deleted!"}
