from fastapi import APIRouter, Depends, status, HTTPException, Response
from datetime import datetime
from io import BytesIO
from PIL import Image, UnidentifiedImageError
import torch

from ai.load_model import load_model
from ai.skin_segmentation_nn import SkinSegmentationNN
import ai.utils as utils
from auth.authenticate import authenticate
from database.connection import get_session
from database.querying import get_record, update_record
from database.storing import download_progress_image, upload_segmentation_mask
from models.image import ProgressImage
from models.response import ResponseModel

import pdb

ai_router = APIRouter(tags=["AI"])
segmentation_model = load_model(SkinSegmentationNN, "ai/models/model")
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")


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

    try:
        image = Image.open(BytesIO(image))
    except UnidentifiedImageError:
        raise HTTPException(status_code=500, detail="Stored image corrupted.")

    image = utils.transform_image(image)
    image = image.to(device)

    segmask = utils.segment_image(image, segmentation_model)
    segmask_path = (
        f"{image_record.image_path.split('_')[0]}"
        "_mask.csv"
        f"{datetime.today().strftime('%Y-%m-%d')}"
    )

    await upload_segmentation_mask(segmask, segmask_path, storage_bucket)

    image_record.segmask_path = segmask_path
    await update_record(image_id, ProgressImage, image_record, session)

    return {
        "message": f"Image segmented successfully and segmentation mask stored at {segmask_path} ."
    }
