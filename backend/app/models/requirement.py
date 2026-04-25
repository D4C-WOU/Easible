from sqlalchemy import Column, Integer, String, ForeignKey, Text
from app.db.database import Base

class Requirement(Base):
    __tablename__ = 'requirements'

    id = Column(Integer, primary_key=True, index=True)
    facility_id = Column(Integer, ForeignKey('facilities.id'))
    category_id = Column(Integer, ForeignKey('categories.id'))

    name = Column(String(200))
    documents = Column(Text)
    description = Column(Text)