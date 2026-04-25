from sqlalchemy import Column, Integer, DateTime, ForeignKey, Boolean
from app.db.database import Base

class Slot(Base):
    __tablename__ = "slots"

    id = Column(Integer, primary_key=True, index=True)
    facility_id = Column(Integer, ForeignKey("facilities.id"))

    start_time = Column(DateTime)
    end_time = Column(DateTime)

    available = Column(Boolean, default=True)