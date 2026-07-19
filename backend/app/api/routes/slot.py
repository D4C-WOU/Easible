from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_admin
from app.models.slot import Slot
from app.models.facility import Facility
from app.schemas.slot import SlotCreate

router = APIRouter(prefix='/slots', tags=['Slots'])


@router.post('/create')
def create_slot(
    slot: SlotCreate,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin),
):
    # Ensure facility exists
    facility = db.query(Facility).filter(Facility.id == slot.facility_id).first()
    if not facility:
        raise HTTPException(status_code=404, detail="Facility not found")

    new_slot = Slot(
        facility_id=slot.facility_id,
        start_time=slot.start_time,
        end_time=slot.end_time,
        available=True
    )

    db.add(new_slot)
    db.commit()
    db.refresh(new_slot)

    return new_slot


@router.get('/')
def get_slots(db: Session = Depends(get_db)):
    query = db.query(
        Slot.id,
        Slot.facility_id,
        Slot.start_time,
        Slot.end_time,
        Slot.available,
        Facility.name.label("facility_name"),
        Facility.address.label("facility_address"),
        Facility.city.label("facility_city"),
        Facility.state.label("facility_state")
    ).outerjoin(Facility, Slot.facility_id == Facility.id).all()

    return [
        {
            "id": r[0],
            "facility_id": r[1],
            "start_time": r[2],
            "end_time": r[3],
            "available": r[4],
            "facility_name": r[5] or "Unknown",
            "facility_address": r[6] or "",
            "facility_city": r[7] or "",
            "facility_state": r[8] or ""
        }
        for r in query
    ]


@router.delete('/{slot_id}')
def delete_slot(
    slot_id: int,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin),
):
    slot = db.query(Slot).filter(Slot.id == slot_id).first()

    if not slot:
        raise HTTPException(status_code=404, detail="Slot not found")

    db.delete(slot)
    db.commit()

    return {"message": "Slot deleted successfully"}