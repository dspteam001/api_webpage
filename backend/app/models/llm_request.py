from sqlalchemy import Column, Integer, String, Text, DateTime, func
from ..database import Base


class LLMRequest(Base):
    __tablename__ = "llm_requests"

    id = Column(Integer, primary_key=True, index=True)
    api_url = Column(String(500), nullable=False, comment="LLM API 주소")
    model_key = Column(String(500), nullable=False, comment="API 키/토큰")
    model_name = Column(String(100), nullable=False, comment="선택한 모델명")
    prompt = Column(Text, nullable=True, comment="사용자 입력 프롬프트")
    file_path = Column(String(500), nullable=True, comment="첨부파일 경로")
    file_name = Column(String(255), nullable=True, comment="첨부파일 이름")
    response = Column(Text, nullable=True, comment="LLM API 응답")
    status = Column(String(50), default="pending", comment="요청 상태")
    error_message = Column(Text, nullable=True, comment="에러 메시지")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
