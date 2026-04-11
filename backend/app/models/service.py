from sqlalchemy import Column, Integer, String, ForeignKey
from app.db.database import Base

class Service(Base):
  __tablename__ = 'services'

  id = Column(Integer, primary_key = True, index = True)
  name = Column(String(100))
  documents = Column(String(500))