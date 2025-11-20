#!/bin/bash

# 개발 환경 설정 및 시작 스크립트

set -e

echo "======================================"
echo "🔧 개발 환경 설정"
echo "======================================"

# 환경변수 파일 확인
if [ ! -f ".env" ]; then
    echo ""
    echo "📝 .env 파일 생성 중..."
    cp .env.example .env
    echo "✅ .env 파일이 생성되었습니다."
fi

# 로그 디렉토리 생성
mkdir -p logs

echo ""
echo "개발 환경 모드를 선택하세요:"
echo "  1) 전체 Docker Compose (권장)"
echo "  2) DB만 Docker, Backend/Frontend는 로컬"
echo ""
read -p "선택 (1-2, 기본값: 1): " mode
mode=${mode:-1}

case $mode in
    1)
        echo ""
        echo "🐳 전체 서비스를 Docker Compose로 시작합니다..."
        ./docker-start.sh
        ;;
    2)
        echo ""
        echo "🐳 PostgreSQL만 Docker로 시작합니다..."
        docker compose up -d postgres pgadmin

        echo ""
        echo "⏳ 데이터베이스 준비 대기 중..."
        sleep 5

        echo ""
        echo "======================================"
        echo "✅ 데이터베이스가 시작되었습니다!"
        echo "======================================"
        echo ""
        echo "📝 다음 단계:"
        echo ""
        echo "1️⃣  백엔드 실행:"
        echo "   cd backend"
        echo "   source venv/bin/activate  # Windows: venv\\Scripts\\activate"
        echo "   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"
        echo ""
        echo "2️⃣  프론트엔드 실행 (새 터미널):"
        echo "   cd frontend"
        echo "   npm run dev"
        echo ""
        echo "🌐 접속 주소:"
        echo "   - PostgreSQL: localhost:5432"
        echo "   - pgAdmin:    http://localhost:5050"
        echo ""
        ;;
    *)
        echo "❌ 잘못된 선택입니다."
        exit 1
        ;;
esac

echo ""
echo "======================================"
