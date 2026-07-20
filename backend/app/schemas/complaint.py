from pydantic import BaseModel
from typing import Optional

class ComplaintCreate(BaseModel):
    message: str
    facility_id: Optional[int] = None
    category_id: Optional[int] = None

class ComplaintResponse(BaseModel):
    id: int
    user_id: int
    message: str
    status: str
    facility_id: Optional[int] = None

    class Config:
        from_attributes = True