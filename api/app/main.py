# import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# import uvicorn

from app.database.connection import conn
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


#
@app.on_event("startup")
def on_startup():
    conn()


# if __name__ == "__main__":

#     ssl_certfile = os.environ.get("SSL_CERTFILE")
#     ssl_keyfile = os.environ.get("SSL_KEYFILE")

#     uvicorn.run(
#         "main:app",
#         port=8000,
#         reload=False,  # Set to True for development
#         ssl_certfile=ssl_certfile,
#         ssl_keyfile=ssl_keyfile,
#     )
