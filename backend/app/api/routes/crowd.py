from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_db
from app.models.slot import Slot

router = APIRouter(prefix='/crowd', tags=['Crowd'])

@router.get('/')

def get_crowd_status (db: Session = Depends(get_db)):
  total = db.query(Slot).count()
  booked = db.query(Slot).filter(Slot.status == 'booked').count()

  if total == 0:
    return {'Status' : 'No Data'}
  
  ratio = booked/total

  if ratio <0.3:
    level = 'Low'
  elif ratio < 0.7:
    level = 'Medium'   
  else:
    level = 'High'  

  return {
    'total_slots': total,
    'booked_slots': booked,
    'crowd_level' : level  
}  