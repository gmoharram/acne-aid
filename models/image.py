from pydantic import BaseModel
from datetime import date


class Image(BaseModel):
    id: int
    experiment_id: int
    image_file: str
    image_format: str
    date_uploaded: date
