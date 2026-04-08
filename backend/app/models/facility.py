from sqlalchemy import Column, Integer, String
from app.db.database import Base

class Facility(Base):
  __tablename__ = 'facilities'

  id = Column(Integer,primary_key = True, index = True)
  name = Column(String(100))
  location = Column(String(255))