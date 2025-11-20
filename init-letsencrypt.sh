#!/bin/bash

# init-letsencrypt.sh
# SSL 인증서 초기 발급 스크립트

if ! [ -x "$(command -v docker compose)" ]; then
  echo 'Error: docker compose is not installed.' >&2
  exit 1
fi

# 설정값 (반드시 수정하세요!)
domains=(example.com www.example.com)
rsa_key_size=4096
data_path="./certbot"
email="admin@example.com" # 인증서 만료 알림을 받을 이메일
staging=0 # 테스트 시 1로 설정 (Let's Encrypt rate limit 방지)

echo "### Let's Encrypt SSL 인증서 초기화 시작 ###"
echo

# 기존 데이터 확인
if [ -d "$data_path" ]; then
  read -p "기존 certbot 데이터가 발견되었습니다. 삭제하고 진행하시겠습니까? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    echo "중단되었습니다."
    exit
  fi
fi

# 기존 데이터 삭제
if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### TLS 파라미터 다운로드 중... ###"
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi

# 더미 인증서 생성
echo "### 더미 인증서 생성 중... ###"
path="/etc/letsencrypt/live/${domains[0]}"
mkdir -p "$data_path/conf/live/${domains[0]}"
docker compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:$rsa_key_size -days 1\
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo

# Nginx 시작
echo "### Nginx 시작 중... ###"
docker compose up --force-recreate -d nginx
echo

# 더미 인증서 삭제
echo "### 더미 인증서 삭제 중... ###"
docker compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/${domains[0]} && \
  rm -Rf /etc/letsencrypt/archive/${domains[0]} && \
  rm -Rf /etc/letsencrypt/renewal/${domains[0]}.conf" certbot
echo

# 실제 인증서 요청
echo "### 실제 인증서 요청 중... ###"

# Staging 모드 설정
staging_arg=""
if [ $staging != "0" ]; then staging_arg="--staging"; fi

# 도메인 인자 구성
domain_args=""
for domain in "${domains[@]}"; do
  domain_args="$domain_args -d $domain"
done

# 이메일 인자
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Certbot 실행
docker compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal" certbot
echo

# Nginx 재시작
echo "### Nginx 재시작 중... ###"
docker compose exec nginx nginx -s reload

echo
echo "### 완료! ###"
echo "이제 https://${domains[0]} 로 접속할 수 있습니다."
