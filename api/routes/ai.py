from fastapi import APIRouter, Depends, status, HTTPException

from ai.load_model import load_model
from ai.skin_segmentation_nn import SkinSegmentationNN
from auth.authenticate import authenticate
from database.connection import get_session
from database.querying import get_record
from database.storing import download_progress_image
from models.image import ProgressImage
from models.response import ResponseModel

import pdb

ai_router = APIRouter(tags=["AI"])
segmentation_model = load_model(SkinSegmentationNN, "ai/models/model")


@ai_router.post(
    "/ai/segment",
    response_model=ResponseModel,
    status_code=status.HTTP_201_CREATED,
)
async def segment_image(
    image_id: int,
    user_id: int = Depends(authenticate),
    session=Depends(get_session),
):
    image_record = await get_record(image_id, ProgressImage, session)
    if image_record.user_id != user_id:
        raise HTTPException(
            status_code=400, detail="Cannot segment image of another user"
        )

    storage_bucket = "progress.skin"
    image = await download_progress_image(image_record, storage_bucket)

    pdb.set_trace()

    return {"message": "Segmentation Successfull!"}
