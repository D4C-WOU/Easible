from sqlalchemy import Column, Integer, ForeignKey
from app.db.database import Base

class Admin(Base):
  __tablename__ = 'admins'

  id = Column(Integer, primary_key= True, index = True)
  user_id = Column(Integer, ForeignKey('users.id'))