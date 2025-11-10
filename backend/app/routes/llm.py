from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from typing import List, Optional
import httpx
import os
import aiofiles
from datetime import datetime

from ..database import get_db
from ..models.llm_request import LLMRequest
from ..schemas.llm_request import LLMRequestCreate, LLMRequestResponse
from ..config import settings

router = APIRouter(prefix="/api/llm", tags=["LLM"])


@router.post("/request", response_model=LLMRequestResponse)
async def create_llm_request(
    api_url: str = Form(...),
    model_key: str = Form(...),
    model_name: str = Form(...),
    prompt: Optional[str] = Form(None),
    file: Optional[UploadFile] = File(None),
    db: Session = Depends(get_db)
):
    """LLM API 요청 생성 및 실행"""

    # 데이터베이스에 요청 저장
    db_request = LLMRequest(
        api_url=api_url,
        model_key=model_key,
        model_name=model_name,
        prompt=prompt,
        status="processing"
    )

    # 파일 업로드 처리
    if file:
        # uploads 디렉토리 생성
        os.makedirs(settings.upload_dir, exist_ok=True)

        # 파일명 생성 (타임스탬프 포함)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        file_extension = os.path.splitext(file.filename)[1]
        safe_filename = f"{timestamp}_{file.filename}"
        file_path = os.path.join(settings.upload_dir, safe_filename)

        # 파일 저장
        async with aiofiles.open(file_path, 'wb') as out_file:
            content = await file.read()
            await out_file.write(content)

        db_request.file_path = file_path
        db_request.file_name = file.filename

    db.add(db_request)
    db.commit()
    db.refresh(db_request)

    # LLM API 호출
    try:
        async with httpx.AsyncClient(timeout=60.0) as client:
            # 기본적인 OpenAI 호환 형식으로 요청
            headers = {
                "Authorization": f"Bearer {model_key}",
                "Content-Type": "application/json"
            }

            payload = {
                "model": model_name,
                "messages": [
                    {"role": "user", "content": prompt or "Hello"}
                ]
            }

            response = await client.post(
                api_url,
                headers=headers,
                json=payload
            )

            if response.status_code == 200:
                result = response.json()
                # OpenAI 형식의 응답 파싱
                if "choices" in result and len(result["choices"]) > 0:
                    llm_response = result["choices"][0]["message"]["content"]
                else:
                    llm_response = str(result)

                db_request.response = llm_response
                db_request.status = "completed"
            else:
                db_request.status = "failed"
                db_request.error_message = f"API Error: {response.status_code} - {response.text}"

    except Exception as e:
        db_request.status = "failed"
        db_request.error_message = str(e)

    db.commit()
    db.refresh(db_request)

    return db_request


@router.get("/requests", response_model=List[LLMRequestResponse])
def get_all_requests(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """모든 LLM 요청 조회"""
    requests = db.query(LLMRequest).order_by(LLMRequest.created_at.desc()).offset(skip).limit(limit).all()
    return requests


@router.get("/requests/{request_id}", response_model=LLMRequestResponse)
def get_request(request_id: int, db: Session = Depends(get_db)):
    """특정 LLM 요청 조회"""
    request = db.query(LLMRequest).filter(LLMRequest.id == request_id).first()
    if not request:
        raise HTTPException(status_code=404, detail="Request not found")
    return request


@router.delete("/requests/{request_id}")
def delete_request(request_id: int, db: Session = Depends(get_db)):
    """LLM 요청 삭제"""
    request = db.query(LLMRequest).filter(LLMRequest.id == request_id).first()
    if not request:
        raise HTTPException(status_code=404, detail="Request not found")

    # 파일이 있으면 삭제
    if request.file_path and os.path.exists(request.file_path):
        os.remove(request.file_path)

    db.delete(request)
    db.commit()
    return {"message": "Request deleted successfully"}
