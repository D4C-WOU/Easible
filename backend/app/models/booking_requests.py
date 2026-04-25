from sqlalchemy import Column, Integer, String, DateTime
from app.db.database import Base


class BookingRequest(Base):
    __tablename__ = "booking_requests"

    id = Column(Integer, primary_key=True, index=True)
    category_id = Column(Integer)
    name = Column(String(120))
    phone = Column(String(32))
    preferred_time = Column(String(50))
    status = Column(String(32), default="pending")
    created_at = Column(DateTime)