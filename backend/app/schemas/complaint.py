from pydantic import BaseModel

class ComplaintCreate(BaseModel):
  message: str

class ComplaintResponse(BaseModel):
  id: int
  user_id: int
  message: str
  status : str

  class Config:
    orm_mode = True  