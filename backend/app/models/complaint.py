from sqlalchemy import Column, Integer, String, ForeignKey
from app.db.database import Base

class Complaint(Base):
  __tablename__='complaints'

  id = Column(Integer,primary_key=True,index=True)
  user_id= Column(Integer,ForeignKey('users.id'))
  message = Column(String(500))
  status = Column(String(20), default="open")