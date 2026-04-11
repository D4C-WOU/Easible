from fastapi import APIRouter, Depends, HTTPException
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

@router.get("/my")
def get_my_complaints(
    db: Session = Depends(get_db),
    user=Depends(get_current_user),
):
    return db.query(Complaint).filter(
        Complaint.user_id == user["user_id"]
    ).all()

@router.put("/{complaint_id}")
def update_complaint(
    complaint_id: int,
    status: str,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin),
):
    complaint = db.query(Complaint).filter(Complaint.id == complaint_id).first()

    if not complaint:
        raise HTTPException(status_code=404, detail="Not found")

    complaint.status = status
    db.commit()

    return {"message": "Updated"}