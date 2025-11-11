from sqlalchemy import Column, Integer, String, Text, DateTime
from datetime import datetime
from database import Base

class APIRequest(Base):
    __tablename__ = "api_requests"

    id = Column(Integer, primary_key=True, index=True)
    method = Column(String(10), nullable=False)
    url = Column(String(2048), nullable=False)
    headers = Column(Text)
    body = Column(Text)
    response_status = Column(Integer)
    response_body = Column(Text)
    response_time = Column(Integer)  # in milliseconds
    created_at = Column(DateTime, default=datetime.utcnow)
