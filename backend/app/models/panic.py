from sqlalchemy import Column, Integer, Float, ForeignKey, DateTime
from app.db.database import Base
import datetime

class PanicAlert(Base):
    __tablename__ = "panic_alerts"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    latitude = Column(Float)
    longitude = Column(Float)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
