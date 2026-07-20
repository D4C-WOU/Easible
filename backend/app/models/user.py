from sqlalchemy import Column, Integer, String, DateTime
from app.db.database import Base


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100))
    email = Column(String(100), unique=True, index=True)
    password = Column(String(255))
    role = Column(String(20), default='user')
    phone = Column(String(32))
    created_at = Column(DateTime)