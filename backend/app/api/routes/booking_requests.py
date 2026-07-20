from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from app.api.deps import get_db, get_current_admin
from app.models.booking_requests import BookingRequest
from app.models.category import Category

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
def get_requests(
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin)
):
    query = db.query(
        BookingRequest.id,
        BookingRequest.category_id,
        BookingRequest.name,
        BookingRequest.phone,
        BookingRequest.preferred_time,
        BookingRequest.status,
        BookingRequest.created_at,
        Category.name.label("category_name")
    ).outerjoin(Category, BookingRequest.category_id == Category.id).all()

    return [
        {
            "id": r[0],
            "category_id": r[1],
            "name": r[2],
            "phone": r[3],
            "preferred_time": r[4],
            "status": r[5],
            "created_at": r[6],
            "category_name": r[7] or "General"
        }
        for r in query
    ]


@router.put("/{request_id}")
def update_request(
    request_id: int,
    status: str,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin)
):
    req = db.query(BookingRequest).filter(BookingRequest.id == request_id).first()

    if not req:
        raise HTTPException(status_code=404, detail="Request not found")

    req.status = status
    db.commit()

    return {"message": "Booking request updated"}
