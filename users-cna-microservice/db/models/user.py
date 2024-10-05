from sqlalchemy import Column, Integer, String
from db.config import Base
from pydantic import BaseModel
from typing import Optional

# SQLAlchemy Model
class User(Base):
    __tablename__ = 'user'

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    email = Column(String, nullable=False)
    mobile = Column(Integer, nullable=False)

# Pydantic Model for API Responses
class UserResponse(BaseModel):
    id: Optional[int]
    name: str
    email: str
    mobile: int  # Changed to int to match the SQLAlchemy model

    class Config:
        from_attributes = True  # Updated for Pydantic v2 to work with SQLAlchemy models

