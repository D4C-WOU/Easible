from sqlalchemy import Column, Integer, String, Float
from app.db.database import Base

class Facility(Base):
  __tablename__ = 'facilities'

  id = Column(Integer,primary_key = True, index = True)
  name = Column(String(100))
  type = Column(String(50)) #example hospital,police etc.
  latitude = Column(Float)
  longitude = Column(Float)