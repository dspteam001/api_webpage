from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class LLMRequestBase(BaseModel):
    api_url: str = Field(..., description="LLM API 주소")
    model_key: str = Field(..., description="API 키/토큰")
    model_name: str = Field(..., description="선택한 모델명")
    prompt: Optional[str] = Field(None, description="사용자 입력 프롬프트")


class LLMRequestCreate(LLMRequestBase):
    pass


class LLMRequestUpdate(BaseModel):
    response: Optional[str] = None
    status: Optional[str] = None
    error_message: Optional[str] = None


class LLMRequestResponse(LLMRequestBase):
    id: int
    file_path: Optional[str] = None
    file_name: Optional[str] = None
    response: Optional[str] = None
    status: str
    error_message: Optional[str] = None
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
