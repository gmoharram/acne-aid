import os
from supabase import create_client, Client
from fastapi import UploadFile
from typing import List
import pdb
from models.image import ProgressImage

url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_KEY")
supabase: Client = create_client(url, key)

res = supabase.storage.list_buckets()


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
