"""Data utility functions."""
import os
import numpy as np
import torch
import torch.utils.data as data
from PIL import Image

from constants import INPUT_HEIGHT, INPUT_WIDTH
from utils import transform_image, transform_target

from IPython.core.debugger import set_trace

SEG_LABELS_LIST = [
    {"id": 0, "name": "void", "rgb_values": [0, 0, 0]},
    {"id": 1, "name": "non-skin", "rgb_values": [0, 0, 128]},
    {"id": 2, "name": "skin", "rgb_values": [0, 128, 0]},
    {"id": 3, "name": "acne", "rgb_values": [128, 0, 0]},
]


def label_img_to_rgb(label_img):
    label_img = np.squeeze(label_img)
    labels = np.unique(label_img)
    label_infos = [l for l in SEG_LABELS_LIST if l["id"] in labels]

    label_img_rgb = np.array([label_img, label_img, label_img]).transpose(1, 2, 0)
    for l in label_infos:
        mask = label_img == l["id"]
        label_img_rgb[mask] = l["rgb_values"]

    return label_img_rgb.astype(np.uint8)


class SkinSegmentationData(data.Dataset):
    def __init__(
        self, image_paths_file, input_height=INPUT_HEIGHT, input_width=INPUT_WIDTH
    ):
        self.root_dir_name = os.path.dirname(image_paths_file)
        self.input_size = (input_height, input_width)

        with open(image_paths_file) as f:
            self.image_names = f.read().splitlines()

    def __getitem__(self, key):
        if isinstance(key, slice):
            # get the start, stop, and step from the slice
            return [self[ii] for ii in range(*key.indices(len(self)))]
        elif isinstance(key, int):
            # handle negative indices
            if key < 0:
                key += len(self)
            if key < 0 or key >= len(self):
                raise IndexError("The index (%d) is out of range." % key)
            # get the data from direct index
            return self.get_item_from_index(key)
        else:
            raise TypeError("Invalid argument type.")

    def __len__(self):
        return len(self.image_names)

    def get_item_from_index(self, index):
        img_id = self.image_names[index].replace(".png", "")

        img = Image.open(
            os.path.join(self.root_dir_name, "images", img_id + ".png")
        ).convert("RGB")

        img = transform_image(img)

        target = Image.open(
            os.path.join(self.root_dir_name, "targets", img_id + "_t.png")
        )
        target = transform_target(target)

        target_labels = target[..., 0]
        for label in SEG_LABELS_LIST:
            mask = np.all(target == label["rgb_values"], axis=2)
            target_labels[mask] = label["id"]

        target_labels = torch.from_numpy(target_labels.copy())

        return img, target_labels
