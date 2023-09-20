from pydantic import BaseModel
from datetime import date, time
from typing import Optional


class Experiment(BaseModel):
    id: int
    user_id: int

    date_started: date
    date_ended: Optional[date] = None


class RoutineStep(BaseModel):
    experiment_id: int
    action_id: int
    object_id: int

    # the timestamp is currently only used for clustering and ordering the routine steps
    # i.e. 8am -> morning, 8pm -> night, nth second -> nth step
    timestamp: time


class Object(BaseModel):
    id: int
    name: str


class Action(BaseModel):
    id: int
    name: str
