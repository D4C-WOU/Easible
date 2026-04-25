from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_db
from app.models.requirement import Requirement

router = APIRouter(prefix='/requirements', tags=['Requirements'])


@router.get("/")
def get_requirements(db: Session = Depends(get_db)):
    return db.query(Requirement).all()