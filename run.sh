#!/bin/bash

# 서비스 한 번에 실행하는 간단한 스크립트

echo "🚀 서비스 시작 중..."

# .env 파일 없으면 생성
[ ! -f ".env" ] && cp .env.example .env && echo "✅ .env 파일 생성됨"

# Docker Compose 실행
docker compose up -d --build

echo ""
echo "✅ 완료!"
echo "   - Frontend:    http://localhost"
echo "   - Backend API: http://localhost/api"
echo "   - API Docs:    http://localhost/docs"
echo ""
echo "로그 보기: docker compose logs -f"
echo "중지하기: docker compose down"
