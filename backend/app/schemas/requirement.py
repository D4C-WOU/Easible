from pydantic import BaseModel

class RequirementResponse(BaseModel):
    id: int
    facility_id: int
    category_id: int
    name: str
    documents: str
    description: str

    class Config:
        orm_mode = True