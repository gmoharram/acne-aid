from PIL import Image
from torchvision import transforms
import numpy as np

from constants import INPUT_HEIGHT, INPUT_WIDTH


### Transformations ###

to_tensor = transforms.ToTensor()
resizer = transforms.Resize(
    size=(INPUT_HEIGHT, INPUT_WIDTH), interpolation=transforms.InterpolationMode.NEAREST
)
# center_crop = transforms.CenterCrop(512)


def transform_image(img):
    """Apply transformations to image after opening with PIL."""

    # img = center_crop(img)
    img = resizer(img)
    img = to_tensor(img)

    return img


def transform_target(target):
    # target = center_crop(target)
    target = resizer(target)
    target = np.array(target, dtype=np.int64)
