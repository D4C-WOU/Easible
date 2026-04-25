from pydantic import BaseModel
from datetime import datetime

class SlotCreate(BaseModel):
    facility_id: int
    start_time: datetime
    end_time: datetime

class SlotResponse(BaseModel):
    id: int
    facility_id: int
    start_time: datetime
    end_time: datetime
    available: bool

    class Config:
        orm_mode = True