#!/bin/bash

# Docker Compose 전체 서비스 중지 스크립트

echo "======================================"
echo "🛑 Docker Compose 서비스 중지"
echo "======================================"

# 서비스 중지 옵션 선택
echo ""
echo "중지 옵션을 선택하세요:"
echo "  1) 서비스만 중지 (데이터 유지)"
echo "  2) 서비스 중지 + 컨테이너 삭제"
echo "  3) 서비스 중지 + 컨테이너 + 볼륨 삭제 (데이터 삭제)"
echo ""
read -p "선택 (1-3, 기본값: 1): " choice
choice=${choice:-1}

case $choice in
    1)
        echo ""
        echo "🛑 서비스를 중지합니다..."
        docker compose stop
        echo "✅ 서비스가 중지되었습니다."
        echo "💡 데이터는 유지됩니다."
        ;;
    2)
        echo ""
        echo "🛑 서비스를 중지하고 컨테이너를 삭제합니다..."
        docker compose down
        echo "✅ 서비스가 중지되고 컨테이너가 삭제되었습니다."
        echo "💡 볼륨(데이터)은 유지됩니다."
        ;;
    3)
        echo ""
        echo "⚠️  경고: 모든 데이터(데이터베이스 포함)가 삭제됩니다!"
        read -p "정말 진행하시겠습니까? (y/N): " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            echo ""
            echo "🛑 서비스, 컨테이너, 볼륨을 모두 삭제합니다..."
            docker compose down -v
            echo "✅ 모든 데이터가 삭제되었습니다."
        else
            echo "❌ 취소되었습니다."
        fi
        ;;
    *)
        echo "❌ 잘못된 선택입니다."
        exit 1
        ;;
esac

echo ""
echo "======================================"
echo "📝 유용한 명령어:"
echo "  - 다시 시작:       ./docker-start.sh"
echo "  - 상태 확인:       docker compose ps"
echo "  - 로그 확인:       docker compose logs"
echo "======================================"
