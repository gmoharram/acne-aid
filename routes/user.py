from fastapi import APIRouter, Depends, Path, status
from fastapi.security import OAuth2PasswordRequestForm

from auth.hash_password import HashPassword
from database.connection import get_session
from database.querying import (
    insert_record,
    get_record,
    update_record,
    delete_record,
    select_all,
)
from models.user import User, UserUpdate
from models.response import ResponseModel, ResponseAllUsers, ResponseOneUser

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


@user_router.post("/user/signin", response_model=ResponseModel)
async def singin_user(user: OAuth2PasswordRequestForm = Depends()) -> dict:
    pass


@user_router.get("/user/{user_id}", response_model=ResponseOneUser)
async def retrieve_user(
    user_id: int = Path(..., title="The ID of the user to retrieve."),
    session=Depends(get_session),
) -> dict:
    record = get_record(user_id, User, session)
    return {"data": record}


@user_router.get("/user/", response_model=ResponseAllUsers)
async def retrieve_all_users(session=Depends(get_session)) -> dict:
    records = select_all(User, session)
    return {"data": records}


@user_router.put("/user/{user_id}", response_model=ResponseOneUser)
async def update_user(
    user_id: int, updated_user: UserUpdate, session=Depends(get_session)
) -> dict:
    record = update_record(user_id, User, updated_user, session)
    return {"message": "User sucessfully updated!", "data": record}


@user_router.delete("/user/{user_id}", response_model=ResponseModel)
async def delete_user(
    user_id: int = Path(..., title="The ID of the user to delete"),
    session=Depends(get_session),
) -> dict:
    delete_record(user_id, User, session)
    return {"message": "User successfully deleted!"}
