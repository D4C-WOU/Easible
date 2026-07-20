from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user, get_current_admin
from app.models.complaint import Complaint
from app.models.facility import Facility
from app.models.category import Category
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
        facility_id=data.facility_id,
    )

    db.add(new)
    db.commit()
    db.refresh(new)

    return new


@router.get("/my")
def get_my_complaints(
    db: Session = Depends(get_db),
    user=Depends(get_current_user),
):
    query = db.query(
        Complaint.id,
        Complaint.message,
        Complaint.status,
        Complaint.facility_id,
        Complaint.created_at,
        Facility.name.label("facility_name"),
        Facility.city.label("facility_city"),
        Category.name.label("category_name")
    ).outerjoin(Facility, Complaint.facility_id == Facility.id)\
     .outerjoin(Category, Facility.category_id == Category.id)\
     .filter(Complaint.user_id == user["user_id"]).all()

    return [
        {
            "id": r[0],
            "message": r[1],
            "status": r[2],
            "facility_id": r[3],
            "created_at": str(r[4]) if r[4] else None,
            "facility_name": r[5] or "General",
            "facility_city": r[6] or "",
            "category_name": r[7] or "General"
        }
        for r in query
    ]


@router.get("/")
def get_complaints(
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin),
):
    query = db.query(
        Complaint.id,
        Complaint.message,
        Complaint.status,
        Complaint.user_id,
        Complaint.facility_id,
        Complaint.created_at,
        Facility.name.label("facility_name"),
        Facility.city.label("facility_city"),
        Category.name.label("category_name")
    ).outerjoin(Facility, Complaint.facility_id == Facility.id)\
     .outerjoin(Category, Facility.category_id == Category.id)\
     .all()

    return [
        {
            "id": r[0],
            "message": r[1],
            "status": r[2],
            "user_id": r[3],
            "facility_id": r[4],
            "created_at": str(r[5]) if r[5] else None,
            "facility_name": r[6] or "General",
            "facility_city": r[7] or "",
            "category_name": r[8] or "General"
        }
        for r in query
    ]


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