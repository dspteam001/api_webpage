#!/bin/bash

echo "======================================"
echo "LLM API WebApp 시작"
echo "======================================"

# 데이터베이스 확인
echo ""
echo "[1/3] 데이터베이스 상태 확인 중..."
docker-compose ps | grep llm_postgres | grep Up > /dev/null

if [ $? -ne 0 ]; then
    echo "데이터베이스가 실행 중이지 않습니다. 시작 중..."
    docker-compose up -d
    echo "데이터베이스 준비 대기 중 (10초)..."
    sleep 10
else
    echo "데이터베이스가 이미 실행 중입니다."
fi

# 백엔드 시작
echo ""
echo "[2/3] 백엔드 서버 시작 중..."
cd backend
source venv/bin/activate

# 백그라운드에서 실행
nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
echo "백엔드 서버 시작됨 (PID: $BACKEND_PID)"
echo $BACKEND_PID > ../logs/backend.pid

cd ..

# 프론트엔드 시작
echo ""
echo "[3/3] 프론트엔드 서버 시작 중..."
cd frontend

# 백그라운드에서 실행
nohup npm run dev > ../logs/frontend.log 2>&1 &
FRONTEND_PID=$!
echo "프론트엔드 서버 시작됨 (PID: $FRONTEND_PID)"
echo $FRONTEND_PID > ../logs/frontend.pid

cd ..

echo ""
echo "======================================"
echo "모든 서비스가 시작되었습니다!"
echo ""
echo "- PostgreSQL: http://localhost:5432"
echo "- pgAdmin: http://localhost:5050"
echo "- 백엔드 API: http://localhost:8000"
echo "- API 문서: http://localhost:8000/docs"
echo "- 프론트엔드: http://localhost:3000"
echo ""
echo "로그 확인:"
echo "  - 백엔드: tail -f logs/backend.log"
echo "  - 프론트엔드: tail -f logs/frontend.log"
echo ""
echo "서비스 종료: ./stop.sh"
echo "======================================"
