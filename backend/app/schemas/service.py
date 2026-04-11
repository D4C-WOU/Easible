from pydantic import BaseModel

class ServiceResponse(BaseModel):
  id: int
  name: str
  documents: str

  class Config:
    orm_mode = True