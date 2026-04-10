from sqlalchemy import Column,Integer,String,ForeignKey
from app.db.database import Base

class Slot(Base):
  __tablename__ ='Slots'

  id= Column(Integer,primary_key=True,index = True)
  facility_id = Column (Integer,ForeignKey('facilities.id'))
  date = Column(String(50))
  time = Column(String(50))
  status = Column(String(20), default='available') 
