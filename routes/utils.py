from datetime import datetime, time
from typing import List

from models.experiment import (
    Experiment,
    RoutineStep,
    ExperimentData,
    RoutineStepData,
    Timing,
    Object,
    Action,
)
import pdb


timing_mapping = {
    Timing.MORNING: 8,
    Timing.NOON: 12,
    Timing.AFTERNOON: 16,
    Timing.NIGHT: 20,
}


def timing_and_order_to_timestamp(timing: Timing, order: int) -> time:
    """Convert timing and step_order attributes to the timestamp stored in the db.
    The timestamp is currently only used for clustering and ordering the routine steps
    i.e. 8am -> morning, 12pm -> noon, 4pm -> afternoon, 8pm -> night and nth second -> nth step
    """
    time_str = f"{timing_mapping[timing]}:0:{order}"
    timestamp = datetime.strptime(time_str, "%H:%M:%S").time()
    return timestamp


def set_experiment_end_date(experiment_record: Experiment) -> Experiment:
    experiment_record.date_ended = datetime.today().strftime("%Y-%m-%d")
    return experiment_record


def joined_records_to_experiment_data(joined_records: List) -> ExperimentData:
    experiment_data = {}
    pdb.set_trace()
    """     experiment_data["experiment_name"] = experiment_record.name
    experiment_data["routine_steps"] = []

    for routinestep_record in routinestep_records:
        routinestep_data = routinestep_record_to_data(routinestep_record)
        experiment_data["routine_steps"].append(routinestep_data)
    """
    return ExperimentData(experiment_data)
