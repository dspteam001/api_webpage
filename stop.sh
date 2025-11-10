#!/bin/bash

echo "======================================"
echo "LLM API WebApp 종료"
echo "======================================"

# 로그 디렉토리 생성
mkdir -p logs

# 백엔드 종료
if [ -f "logs/backend.pid" ]; then
    BACKEND_PID=$(cat logs/backend.pid)
    echo "백엔드 서버 종료 중 (PID: $BACKEND_PID)..."
    kill $BACKEND_PID 2>/dev/null
    rm logs/backend.pid
else
    echo "백엔드 PID 파일을 찾을 수 없습니다."
fi

# 프론트엔드 종료
if [ -f "logs/frontend.pid" ]; then
    FRONTEND_PID=$(cat logs/frontend.pid)
    echo "프론트엔드 서버 종료 중 (PID: $FRONTEND_PID)..."
    kill $FRONTEND_PID 2>/dev/null
    rm logs/frontend.pid
else
    echo "프론트엔드 PID 파일을 찾을 수 없습니다."
fi

# 포트로 실행 중인 프로세스 찾아서 종료
echo ""
echo "포트 8000, 3000에서 실행 중인 프로세스 확인 중..."
lsof -ti:8000 | xargs kill -9 2>/dev/null
lsof -ti:3000 | xargs kill -9 2>/dev/null

echo ""
echo "======================================"
echo "서비스가 종료되었습니다."
echo ""
echo "데이터베이스도 종료하려면:"
echo "  docker-compose down"
echo "======================================"
