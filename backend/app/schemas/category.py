from pydantic import BaseModel

class CategoryResponse(Base):
  id: int
  name: str
  description : str

  class Config:
    orm_mode = True