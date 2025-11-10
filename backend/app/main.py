from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os

from .config import settings
from .database import engine, Base
from .routes import llm_router

# 데이터베이스 테이블 생성
Base.metadata.create_all(bind=engine)

# FastAPI 앱 생성
app = FastAPI(
    title=settings.app_name,
    version=settings.api_version,
    debug=settings.debug
)

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 업로드 디렉토리 생성
os.makedirs(settings.upload_dir, exist_ok=True)

# 정적 파일 서빙 (업로드된 파일)
if os.path.exists(settings.upload_dir):
    app.mount("/uploads", StaticFiles(directory=settings.upload_dir), name="uploads")

# 라우터 등록
app.include_router(llm_router)


@app.get("/")
def root():
    return {
        "message": "LLM API WebApp",
        "version": settings.api_version,
        "docs": "/docs"
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}
