#!/bin/bash

echo "======================================"
echo "LLM API WebApp 상태 확인"
echo "======================================"

# 데이터베이스 상태
echo ""
echo "[데이터베이스]"
docker-compose ps

# 백엔드 상태
echo ""
echo "[백엔드 서버]"
if [ -f "logs/backend.pid" ]; then
    BACKEND_PID=$(cat logs/backend.pid)
    if ps -p $BACKEND_PID > /dev/null; then
        echo "✓ 실행 중 (PID: $BACKEND_PID)"
        echo "  URL: http://localhost:8000"
        echo "  Docs: http://localhost:8000/docs"
    else
        echo "✗ 실행 중이 아님"
    fi
else
    echo "✗ PID 파일 없음"
fi

# 프론트엔드 상태
echo ""
echo "[프론트엔드 서버]"
if [ -f "logs/frontend.pid" ]; then
    FRONTEND_PID=$(cat logs/frontend.pid)
    if ps -p $FRONTEND_PID > /dev/null; then
        echo "✓ 실행 중 (PID: $FRONTEND_PID)"
        echo "  URL: http://localhost:3000"
    else
        echo "✗ 실행 중이 아님"
    fi
else
    echo "✗ PID 파일 없음"
fi

# 포트 확인
echo ""
echo "[포트 상태]"
echo "PostgreSQL (5432):"
lsof -i:5432 | grep LISTEN || echo "  ✗ 사용 중이 아님"

echo "pgAdmin (5050):"
lsof -i:5050 | grep LISTEN || echo "  ✗ 사용 중이 아님"

echo "백엔드 (8000):"
lsof -i:8000 | grep LISTEN || echo "  ✗ 사용 중이 아님"

echo "프론트엔드 (3000):"
lsof -i:3000 | grep LISTEN || echo "  ✗ 사용 중이 아님"

echo ""
echo "======================================"
