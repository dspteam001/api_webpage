#!/bin/bash

# 프로덕션 배포 스크립트 (SSL 포함)

set -e

echo "======================================"
echo "🚀 프로덕션 배포 시작"
echo "======================================"

# 환경변수 확인
if [ ! -f ".env" ]; then
    echo ""
    echo "❌ .env 파일이 없습니다!"
    echo "📝 .env.example을 참고하여 .env 파일을 생성하세요."
    exit 1
fi

# 도메인 설정 확인
source .env
if [ -z "$DOMAIN" ]; then
    echo ""
    echo "❌ .env 파일에 DOMAIN이 설정되지 않았습니다!"
    echo "📝 .env 파일을 수정하여 DOMAIN을 설정하세요."
    exit 1
fi

echo ""
echo "🌐 도메인: $DOMAIN"
echo "📧 이메일: $EMAIL"
echo ""

# 배포 확인
read -p "프로덕션 배포를 진행하시겠습니까? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "❌ 취소되었습니다."
    exit 0
fi

# Nginx 설정 파일 도메인 확인
echo ""
echo "📝 Nginx 설정 파일의 도메인을 확인합니다..."
if grep -q "example.com" nginx/conf.d/default.conf; then
    echo ""
    echo "⚠️  경고: nginx/conf.d/default.conf에 아직 example.com이 있습니다!"
    echo "📝 실제 도메인으로 변경이 필요합니다."
    echo ""
    read -p "자동으로 변경하시겠습니까? (y/N): " auto_replace
    if [ "$auto_replace" = "y" ] || [ "$auto_replace" = "Y" ]; then
        sed -i "s/example.com/$DOMAIN/g" nginx/conf.d/default.conf
        echo "✅ 도메인이 $DOMAIN으로 변경되었습니다."
    else
        echo "❌ nginx/conf.d/default.conf를 수동으로 수정한 후 다시 실행하세요."
        exit 1
    fi
fi

# init-letsencrypt.sh 설정 확인
echo ""
echo "📝 SSL 인증서 스크립트의 도메인을 확인합니다..."
if grep -q "example.com" init-letsencrypt.sh; then
    echo ""
    echo "⚠️  경고: init-letsencrypt.sh에 아직 example.com이 있습니다!"
    echo "📝 실제 도메인으로 변경이 필요합니다."
    echo ""
    read -p "자동으로 변경하시겠습니까? (y/N): " auto_replace2
    if [ "$auto_replace2" = "y" ] || [ "$auto_replace2" = "Y" ]; then
        sed -i "s/domains=(example.com www.example.com)/domains=($DOMAIN www.$DOMAIN)/" init-letsencrypt.sh
        if [ ! -z "$EMAIL" ]; then
            sed -i "s/email=\"admin@example.com\"/email=\"$EMAIL\"/" init-letsencrypt.sh
        fi
        echo "✅ 도메인이 $DOMAIN으로 변경되었습니다."
    else
        echo "❌ init-letsencrypt.sh를 수동으로 수정한 후 다시 실행하세요."
        exit 1
    fi
fi

# SSL 인증서 발급 여부 확인
echo ""
if [ -d "certbot/conf/live/$DOMAIN" ]; then
    echo "✅ SSL 인증서가 이미 존재합니다."
    ssl_exists=true
else
    echo "⚠️  SSL 인증서가 없습니다."
    ssl_exists=false

    read -p "SSL 인증서를 발급하시겠습니까? (y/N): " ssl_confirm
    if [ "$ssl_confirm" = "y" ] || [ "$ssl_confirm" = "Y" ]; then
        echo ""
        echo "🔒 SSL 인증서 발급 중..."
        chmod +x init-letsencrypt.sh
        ./init-letsencrypt.sh
    else
        echo ""
        echo "⚠️  SSL 없이 HTTP로만 배포됩니다."
        echo "📝 나중에 ./init-letsencrypt.sh를 실행하여 SSL을 활성화하세요."
    fi
fi

# Docker Compose 빌드 및 시작
echo ""
echo "🐳 Docker Compose 빌드 및 시작..."
docker compose up -d --build

echo ""
echo "⏳ 서비스 시작 대기 중..."
sleep 10

# 서비스 상태 확인
echo ""
echo "📊 서비스 상태:"
docker compose ps

echo ""
echo "======================================"
echo "✅ 프로덕션 배포 완료!"
echo "======================================"
echo ""
if [ "$ssl_exists" = true ] || [ "$ssl_confirm" = "y" ] || [ "$ssl_confirm" = "Y" ]; then
    echo "🌐 접속 주소:"
    echo "   - Frontend:    https://$DOMAIN"
    echo "   - Backend API: https://$DOMAIN/api"
    echo "   - API Docs:    https://$DOMAIN/docs"
else
    echo "🌐 접속 주소 (HTTP):"
    echo "   - Frontend:    http://$DOMAIN"
    echo "   - Backend API: http://$DOMAIN/api"
    echo "   - API Docs:    http://$DOMAIN/docs"
fi
echo ""
echo "📝 유용한 명령어:"
echo "   - 로그 확인:         docker compose logs -f"
echo "   - 서비스 재시작:     docker compose restart [서비스명]"
echo "   - SSL 인증서 갱신:   docker compose run --rm certbot renew"
echo "   - Nginx 재시작:      docker compose exec nginx nginx -s reload"
echo ""
echo "======================================"
