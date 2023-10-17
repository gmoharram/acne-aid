import numpy as np
import torch
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

from .skin_segmentation_dataset import SEG_LABELS_LIST

from IPython.core.debugger import set_trace

def evaluate_model(model, dataloader):
    report = {}
    accuracy_scores = []
    recall_scores = {}
    precision_scores = {}
    num_instances = {}
    
    model.eval()
    for inputs, targets in dataloader:
        inputs, targets = inputs.to(device), targets.to(device)

        outputs = model.forward(inputs)
        probs, preds = torch.max(outputs, 1)
        preds = preds + 1
        
        #overall accuracy
        targets_mask = targets > 0 #0 is void so only count labels greater, artifact of annotation tool forcing category ids to start at 1
        accuracy_scores.append(np.mean((preds.cpu() == targets.cpu())[targets_mask].numpy()))
        
        #class recall, precision
        for item in SEG_LABELS_LIST:
            item_name = item['name']
            item_id = item['id']
            if item_id> 0:
                targets_mask = targets == item_id
                prediction_mask = torch.logical_and(preds == item_id, targets > 0)
                try:
                    recall_scores[item_name].append(np.mean((preds.cpu() == targets.cpu())[targets_mask].numpy()))
                    precision_scores[item_name].append(np.mean((preds.cpu() == targets.cpu())[prediction_mask].numpy()))
                    num_instances[item_name].append(torch.sum(targets_mask))
                except KeyError:
                    recall_scores[item_name] = []
                    precision_scores[item_name] = []
                    num_instances[item_name] = []
                    recall_scores[item_name].append(np.mean((preds.cpu() == targets.cpu())[targets_mask].numpy()))
                    precision_scores[item_name].append(np.mean((preds.cpu() == targets.cpu())[prediction_mask].numpy()))
                    num_instances[item_name].append(torch.sum(targets_mask))
                    
    report['accuracy'] = np.mean(accuracy_scores)
    for key in recall_scores.keys():
        report[key + ' ' + 'num instances'] = np.sum(num_instances[key])
        report[key + ' ' + 'recall'] = np.mean(recall_scores[key])
        report[key + ' ' + 'precision'] = np.mean(precision_scores[key])
        report[key + ' ' + 'f1 score'] = (2 * report[key + ' ' + 'recall'] * report[key + ' ' + 'precision']) / (report[key + ' ' + 'recall'] + report[key + ' ' + 'precision'])
        
    return report