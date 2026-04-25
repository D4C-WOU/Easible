from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from datetime import datetime
from app.api.deps import get_db
from app.models.booking_requests import BookingRequest

router = APIRouter(prefix="/booking-requests", tags=["Booking Requests"])


@router.post("/")
def create_request(data: dict, db: Session = Depends(get_db)):
    req = BookingRequest(
        category_id=data.get("category_id"),
        name=data.get("name"),
        phone=data.get("phone"),
        preferred_time=data.get("preferred_time"),
        status="pending",
        created_at=datetime.utcnow()
    )

    db.add(req)
    db.commit()
    db.refresh(req)

    return req


@router.get("/")
def get_requests(db: Session = Depends(get_db)):
    return db.query(BookingRequest).all()