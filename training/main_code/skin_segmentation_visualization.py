import matplotlib.pyplot as plt
import torch
from math import sqrt, ceil
import numpy as np
from .skin_segmentation_dataset import label_img_to_rgb

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

def visualizer(model, test_data=None, num_imgs = 1):
    num_example_imgs = num_imgs
    plt.figure(figsize=(15, 5 * num_example_imgs))
    for i, (img, target) in enumerate(test_data[:num_example_imgs]):
        inputs = img.unsqueeze(0)
        inputs = inputs.to(device)

        outputs = model.forward(inputs)
        _, preds = torch.max(outputs, 1)
        pred = preds[0].data.cpu()
        pred = pred + 1  # undo -1 target operation while training, artifact of annotation tool forcing category ids to start at 1
        img, target, pred = img.numpy(), target.numpy(), pred.numpy()

        # img
        plt.subplot(num_example_imgs, 3, i * 3 + 1)
        plt.axis('off')
        plt.imshow(img.transpose(1, 2, 0))
        if i == 0:
            plt.title("Input image")

        # target
        plt.subplot(num_example_imgs, 3, i * 3 + 2)
        plt.axis('off')
        plt.imshow(label_img_to_rgb(target))
        if i == 0:
            plt.title("Target image")

        # pred
        plt.subplot(num_example_imgs, 3, i * 3 + 3)
        plt.axis('off')
        plt.imshow(label_img_to_rgb(pred))
        if i == 0:
            plt.title("Prediction image")

    plt.show()