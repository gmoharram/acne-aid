from fastapi import APIRouter, Depends, status, UploadFile, Path, HTTPException
from datetime import datetime
from auth.authenticate import authenticate
from database.connection import get_session
from database.querying import (
    insert_record,
    get_record,
    get_records_by_field,
    update_record,
)
from database.storing import upload_progress_image
from models.image import ProgressImage
from models.experiment import Experiment
from models.response import ResponseModel


image_router = APIRouter(tags=["Images"])


@image_router.post(
    "/image/create",
    response_model=ResponseModel,
    status_code=status.HTTP_201_CREATED,
)
async def upload_image(
    image: UploadFile,
    experiment_id: int,
    user_id: int = Depends(authenticate),
    session=Depends(get_session),
):
    experiment_record = await get_record(experiment_id, Experiment, session)
    if experiment_record.user_id != user_id:
        return {
            "message": "User attempting to upload image to an experiment belonging to another user."
        }

    storage_bucket = "progress.skin"
    image_path = (
        f"{user_id}/{experiment_id}/{image.filename}_"
        f"{datetime.today().strftime('%Y-%m-%d')}"
    )

    await upload_progress_image(image, image_path, storage_bucket=storage_bucket)

    image_record = ProgressImage(
        experiment_id=experiment_id,
        storage_bucket=storage_bucket,
        image_path=image_path,
        image_format=image.content_type.split("/")[1],
        image_size=image.size,
    )

    await insert_record(image_record, session)

    return {
        "message": f"Image successfully uploaded to {experiment_record.name} experiment!"
    }


@image_router.get(
    "/image/retrieve", response_model=ResponseModel, status_code=status.HTTP_201_CREATED
)
async def retrieve_experiment_images(
    experiment_id: int,
    user_id: int = Depends(authenticate),
    session=Depends(get_session),
):
    """Function which only returns the image paths and storage buckets."""

    image_records = await get_records_by_field(
        experiment_id, "experiment_id", ProgressImage, session
    )

    data = [
        (
            image_record.storage_bucket,
            image_record.image_path,
            f"image/{image_record.image_format}",
        )
        for image_record in image_records
        if not image_record.deleted
    ]

    return {"message": "Experiment image paths successfully retrieved!", "data": data}


@image_router.put("/image/delete/{image_id}")
async def delete_image(
    image_id: int = Path(..., title="ID of image to delete."),
    user_id=Depends(authenticate),
    session=Depends(get_session),
):
    image_record = await get_record(image_id, ProgressImage, session)
    if image_record.image_path.split("/")[0] != user_id:
        raise HTTPException(
            status_code=400,
            detail="User is attempting to delete image not belonging to them.",
        )

    image_record.deleted = True
    await update_record(image_id, ProgressImage, image_record, session)

    return {"message": "Image successfuly deleted!"}
