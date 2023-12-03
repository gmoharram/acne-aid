import os
import numpy as np
from io import BytesIO
from supabase import create_client, Client
from fastapi import UploadFile

from models.image import ProgressImage

import pdb

url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_KEY")
supabase: Client = create_client(url, key)


async def upload_progress_image(
    image: UploadFile, image_path: str, storage_bucket: str
):
    supabase.storage.from_(storage_bucket).upload(
        file=image.file.read(),
        path=image_path,
        file_options={"content-type": image.content_type},
    )


async def download_progress_image(
    image_record: ProgressImage,
    storage_bucket: str,
):
    return supabase.storage.from_(storage_bucket).download(image_record.image_path)


async def upload_segmentation_mask(
    segmask: np.array,
    mask_path: str,
    storage_bucket: str,
):
    in_memory_file = BytesIO()
    np.save(in_memory_file, segmask)
    in_memory_file.seek(0)

    pdb.set_trace()
    # TODO: Fix this shit

    await supabase.storage.from_(storage_bucket).upload(
        file=in_memory_file.read1(),
        path=mask_path,
        file_options={"content-type": "text/"},
    )
