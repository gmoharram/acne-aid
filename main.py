from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

from database.connection import conn
from routes.user import user_router
from routes.experiment import experiment_router
from routes.image import image_router

app = FastAPI()

# Register origins (allowed to access API)

origins = ["*"]  # TODO: Restrict origins to frontend app
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Define routes


@app.get("/")
async def welcome() -> dict:
    return {"message": "Welcome to the SkinAssist API!"}


# Register Routes
app.include_router(user_router)
app.include_router(experiment_router)
app.include_router(image_router)


@app.on_event("startup")
def on_startup():
    conn()


if __name__ == "__main__":
    uvicorn.run("main:app", port=8000, reload=True)
