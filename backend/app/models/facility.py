from sqlalchemy import Column, Integer, String, Float, Text, ForeignKey
from app.db.database import Base


class Facility(Base):
    __tablename__ = 'facilities'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200))
    category_id = Column(Integer, ForeignKey('categories.id'))
    address = Column(String(300))
    city = Column(String(120))
    state = Column(String(120))
    lat = Column(Float)
    lng = Column(Float)
    phone = Column(String(32))
    description = Column(Text)