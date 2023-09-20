from fastapi import FastAPI
import uvicorn

from routes.user import user_router
from database.connection import conn

app = FastAPI()


@app.get("/")
async def welcome() -> dict:
    return {"message": "Welcome to the SkinAssist API!"}


# Register Routes
app.include_router(user_router)


@app.on_event("startup")
def on_startup():
    conn()


if __name__ == "__main__":
    uvicorn.run("main:app", port=8000, reload=True)
