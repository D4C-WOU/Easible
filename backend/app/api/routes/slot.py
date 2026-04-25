from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_admin
from app.models.slot import Slot
from app.schemas.slot import SlotCreate

router = APIRouter(prefix='/slots', tags=['Slots'])


@router.post('/create')
def create_slot(
    slot: SlotCreate,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin),
):
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
    return db.query(Slot).all()