from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user, get_current_admin
from app.models.complaint import Complaint
from app.schemas.complaint import ComplaintCreate

router = APIRouter(prefix="/complaints", tags=["Complaints"])



@router.post("/")
def create_complaint(
    data: ComplaintCreate,
    db: Session = Depends(get_db),
    user=Depends(get_current_user),
):
    new = Complaint(
        user_id=user["user_id"],
        message=data.message,
    )

    db.add(new)
    db.commit()
    db.refresh(new)

    return new



@router.get("/")
def get_complaints(
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin),
):
    return db.query(Complaint).all()