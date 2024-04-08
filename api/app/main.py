from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# import uvicorn

from app.database.connection import connect_to_db
from app.routes.user import user_router
from app.routes.experiment import experiment_router
from app.routes.image import image_router
from app.routes.ai import ai_router

# import pdb

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
app.include_router(ai_router)


# Define Actions on Startup
@app.on_event("startup")
def on_startup():
    connect_to_db()
