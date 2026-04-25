from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_db
from app.models.facility import Facility

router = APIRouter(prefix="/facilities", tags=["Facilities"])


@router.get("/")
def get_facilities(category_id: int = None, db: Session = Depends(get_db)):
    query = db.query(Facility)

    if category_id:
        query = query.filter(Facility.category_id == category_id)

    return query.all()