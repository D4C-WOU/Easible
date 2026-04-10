from pydantic import BaseModel

class SlotCreate(BaseModel):
  facility_id : int
  date:str
  time: str

class SlotResponse(BaseModel):
  id: int
  facility_id: int
  date: str
  time: str  
  status: str

  class Config:
    orm_mode =  True
