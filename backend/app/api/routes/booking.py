from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user, get_current_admin
from app.models.booking import Booking
from app.models.slot import Slot
from app.models.facility import Facility
from app.models.category import Category
from app.models.user import User
from app.schemas.booking import BookingCreate

router = APIRouter(prefix="/bookings", tags=["Bookings"])


# USER: REQUEST BOOKING (status = pending, awaiting admin approval)
@router.post("/create")
def create_booking(
    booking: BookingCreate,
    db: Session = Depends(get_db),
    user=Depends(get_current_user),
):
    slot = db.query(Slot).filter(Slot.id == booking.slot_id).first()

    if not slot:
        raise HTTPException(status_code=404, detail="Slot not found")

    if not slot.available:
        raise HTTPException(status_code=400, detail="Slot not available")

    # Check if user already has a pending/confirmed booking for this slot
    existing = db.query(Booking).filter(
        Booking.slot_id == booking.slot_id,
        Booking.status.in_(["pending", "confirmed", "accepted"])
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Slot already has a pending or confirmed booking")

    new_booking = Booking(
        user_id=user["user_id"],
        slot_id=booking.slot_id,
        facility_id=slot.facility_id,
        status="pending",  # Requires admin approval
    )

    # Mark slot as unavailable immediately to prevent double-booking
    slot.available = False

    db.add(new_booking)
    db.commit()
    db.refresh(new_booking)

    return {"message": "Booking request submitted. Awaiting admin approval.", "booking_id": new_booking.id, "status": "pending"}


# USER: MY BOOKINGS
@router.get("/my")
def get_my_bookings(
    db: Session = Depends(get_db),
    user=Depends(get_current_user),
):
    query = db.query(
        Booking.id,
        Booking.status,
        Booking.slot_id,
        Slot.start_time,
        Slot.end_time,
        Facility.name.label("facility_name"),
        Facility.address.label("facility_address"),
        Facility.city.label("facility_city"),
        Category.name.label("category_name")
    ).outerjoin(Slot, Booking.slot_id == Slot.id)\
     .outerjoin(Facility, Slot.facility_id == Facility.id)\
     .outerjoin(Category, Facility.category_id == Category.id)\
     .filter(Booking.user_id == user["user_id"]).all()

    return [
        {
            "id": r[0],
            "status": r[1],
            "slot_id": r[2],
            "start_time": str(r[3]) if r[3] else None,
            "end_time": str(r[4]) if r[4] else None,
            "facility_name": r[5] or "N/A",
            "facility_address": r[6] or "N/A",
            "facility_city": r[7] or "",
            "category_name": r[8] or "N/A"
        }
        for r in query
    ]


# ADMIN: VIEW ALL BOOKINGS
@router.get("/")
def get_bookings(
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin),
):
    query = db.query(
        Booking.id,
        Booking.status,
        Booking.slot_id,
        User.name.label("user_name"),
        User.email.label("user_email"),
        User.phone.label("user_phone"),
        Slot.start_time,
        Slot.end_time,
        Facility.name.label("facility_name"),
        Facility.address.label("facility_address"),
        Facility.city.label("facility_city"),
        Category.name.label("category_name")
    ).join(User, Booking.user_id == User.id)\
     .outerjoin(Slot, Booking.slot_id == Slot.id)\
     .outerjoin(Facility, Slot.facility_id == Facility.id)\
     .outerjoin(Category, Facility.category_id == Category.id)\
     .all()

    return [
        {
            "id": r[0],
            "status": r[1],
            "slot_id": r[2],
            "user_name": r[3],
            "user_email": r[4],
            "user_phone": r[5] or "",
            "start_time": str(r[6]) if r[6] else None,
            "end_time": str(r[7]) if r[7] else None,
            "facility_name": r[8] or "N/A",
            "facility_address": r[9] or "",
            "facility_city": r[10] or "",
            "category_name": r[11] or "General"
        }
        for r in query
    ]


# ADMIN: UPDATE BOOKING STATUS
@router.put("/{booking_id}")
def update_booking(
    booking_id: int,
    status: str,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin),
):
    booking = db.query(Booking).filter(Booking.id == booking_id).first()

    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")

    booking.status = status

    # Free up slot if rejected or cancelled
    if status in ("rejected", "cancelled"):
        slot = db.query(Slot).filter(Slot.id == booking.slot_id).first()
        if slot:
            slot.available = True

    db.commit()
    return {"message": f"Booking {status}"}
