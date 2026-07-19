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


# 👤 USER: CREATE BOOKING
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
        raise HTTPException(status_code=400, detail="Slot already booked")

    new_booking = Booking(
        user_id=user["user_id"],
        slot_id=booking.slot_id,
    )

    slot.available = False  # ✅ FIX

    db.add(new_booking)
    db.commit()
    db.refresh(new_booking)

    return new_booking

#users bookings
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
            "start_time": r[3],
            "end_time": r[4],
            "facility_name": r[5] or "N/A",
            "facility_address": r[6] or "N/A",
            "category_name": r[7] or "N/A"
        }
        for r in query
    ]


# 🛠️ ADMIN: VIEW BOOKINGS
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
        Slot.start_time,
        Slot.end_time,
        Facility.name.label("facility_name")
    ).join(User, Booking.user_id == User.id)\
     .outerjoin(Slot, Booking.slot_id == Slot.id)\
     .outerjoin(Facility, Slot.facility_id == Facility.id)\
     .all()

    return [
        {
            "id": r[0],
            "status": r[1],
            "slot_id": r[2],
            "user_name": r[3],
            "user_email": r[4],
            "start_time": r[5],
            "end_time": r[6],
            "facility_name": r[7] or "N/A"
        }
        for r in query
    ]


# 🛠️ ADMIN: UPDATE STATUS
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

    # 🔄 Update slot status if accepted
    if status == "accepted":
        slot = db.query(Slot).filter(Slot.id == booking.slot_id).first()
        if slot:
            slot.available = False
    elif status == "rejected" or status == "cancelled":
        slot = db.query(Slot).filter(Slot.id == booking.slot_id).first()
        if slot:
            slot.available = True

    db.commit()
    return {"message": "Updated"}