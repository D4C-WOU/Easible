from sqlalchemy import Integer, Column, String, ForeignKey
from app.db.database import Base

class Booking(Base):
  __tablename__ ='booking'

  id = Column(Integer, primary_key = True,index = True)
  user_id = Column(Integer, ForeignKey('users.id'))
  slot_id = Column(Integer, ForeignKey('slots.id'))
  status = Column(String(20), default = 'pending')