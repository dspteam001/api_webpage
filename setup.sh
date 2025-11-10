#!/bin/bash

echo "======================================"
echo "LLM API WebApp 설치 스크립트"
echo "======================================"

# 데이터베이스 시작
echo ""
echo "[1/4] PostgreSQL 데이터베이스 시작 중..."
docker-compose up -d

echo "데이터베이스 준비 대기 중 (10초)..."
sleep 10

# 백엔드 설정
echo ""
echo "[2/4] 백엔드 설정 중..."
cd backend

if [ ! -d "venv" ]; then
    echo "Python 가상환경 생성 중..."
    python3 -m venv venv
fi

echo "가상환경 활성화 및 의존성 설치 중..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "환경변수 파일 확인 중..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo ".env 파일이 생성되었습니다."
fi

cd ..

# 프론트엔드 설정
echo ""
echo "[3/4] 프론트엔드 설정 중..."
cd frontend

echo "npm 의존성 설치 중..."
npm install

echo "환경변수 파일 확인 중..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo ".env 파일이 생성되었습니다."
fi

cd ..

echo ""
echo "[4/4] 설치 완료!"
echo ""
echo "======================================"
echo "다음 명령어로 애플리케이션을 시작하세요:"
echo ""
echo "  ./start.sh"
echo ""
echo "또는 개별적으로 시작:"
echo "  1. 백엔드: cd backend && source venv/bin/activate && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"
echo "  2. 프론트엔드: cd frontend && npm run dev"
echo ""
echo "- PostgreSQL: http://localhost:5432"
echo "- pgAdmin: http://localhost:5050"
echo "- 백엔드 API: http://localhost:8000"
echo "- API 문서: http://localhost:8000/docs"
echo "- 프론트엔드: http://localhost:3000"
echo "======================================"
