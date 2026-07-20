from sqlalchemy import Column, Integer, String, ForeignKey, Text, DateTime
from datetime import datetime
from app.db.database import Base

class Complaint(Base):
    __tablename__ = 'complaints'

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    facility_id = Column(Integer, ForeignKey('facilities.id'), nullable=True)
    message = Column(Text)
    status = Column(String(32), default='open')
    created_at = Column(DateTime, default=datetime.utcnow)