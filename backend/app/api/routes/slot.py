from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_db,get_current_admin
from app.models.slot import Slot
from app.schemas.slot import SlotCreate

router = APIRouter(prefix='/slots', tags=['Slots'])

@router.post('/create')
def create_slot(
  slot: SlotCreate,
  db: Session = Depends(get_db),
  admin = Depends(get_current_admin),
):
  new_slot = Slot(
    facility_id = slot.facility_id,\
    date = slot.date,
    time =  slot.time
  )

  db.add(new_slot)
  db.commit()
  db.refresh(new_slot)


@router.get('/')
def get_slots(db:Session = Depends(get_db)):
  return db.query(Slot).all()
