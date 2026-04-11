from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user, get_current_admin
from app.models.booking import Booking
from app.models.slot import Slot
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

    if slot.status != "available":
        raise HTTPException(status_code=400, detail="Slot already booked")

    new_booking = Booking(
        user_id=user["user_id"],
        slot_id=booking.slot_id,
    )

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
    return db.query(Booking).filter(
        Booking.user_id == user["user_id"]
    ).all()


# 🛠️ ADMIN: VIEW BOOKINGS
@router.get("/")
def get_bookings(
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin),
):
    return db.query(Booking).all()


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
        slot.status = "booked"

    db.commit()
    return {"message": "Updated"}