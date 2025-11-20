# Nginx 설정 가이드

## 1. Nginx 설치

### Red Hat 8.10의 경우:

```bash
# Nginx 설치
sudo dnf install nginx -y

# Nginx 서비스 시작
sudo systemctl start nginx

# 부팅 시 자동 시작 설정
sudo systemctl enable nginx

# Nginx 상태 확인
sudo systemctl status nginx
```

## 2. Nginx 설정 적용

### 방법 1: 설정 파일 직접 복사

```bash
# 기본 설정 백업
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# 프로젝트의 nginx.conf를 sites-available로 복사
sudo cp nginx.conf /etc/nginx/conf.d/llm-webapp.conf

# 설정 파일 편집 - 도메인 주소 변경
sudo vi /etc/nginx/conf.d/llm-webapp.conf
# server_name your-domain.com; 라인을 실제 도메인으로 변경
# 예: server_name llm.mysite.com; 또는 localhost;
```

### 방법 2: 심볼릭 링크 사용

```bash
# sites-available 및 sites-enabled 디렉토리 생성
sudo mkdir -p /etc/nginx/sites-available
sudo mkdir -p /etc/nginx/sites-enabled

# 설정 파일 복사
sudo cp nginx.conf /etc/nginx/sites-available/llm-webapp

# 심볼릭 링크 생성
sudo ln -s /etc/nginx/sites-available/llm-webapp /etc/nginx/sites-enabled/

# 도메인 주소 변경
sudo vi /etc/nginx/sites-available/llm-webapp

# /etc/nginx/nginx.conf 파일에 아래 내용 추가 (http 블록 안에)
# include /etc/nginx/sites-enabled/*;
```

## 3. 설정 파일 수정

`/etc/nginx/conf.d/llm-webapp.conf` 파일을 열어 다음을 수정하세요:

```nginx
server_name your-domain.com;  # 실제 도메인 또는 IP 주소로 변경
```

**로컬 테스트 시:**
- `server_name localhost;` 또는 `server_name 127.0.0.1;`

**실제 도메인 사용 시:**
- `server_name llm.example.com;` (실제 도메인으로 변경)

## 4. 방화벽 설정

```bash
# HTTP (포트 80) 허용
sudo firewall-cmd --permanent --add-service=http

# HTTPS (포트 443) 허용 (SSL 사용 시)
sudo firewall-cmd --permanent --add-service=https

# 방화벽 재시작
sudo firewall-cmd --reload

# 또는 직접 포트 열기
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload
```

## 5. SELinux 설정 (Red Hat/CentOS)

```bash
# SELinux가 활성화된 경우 네트워크 연결 허용
sudo setsebool -P httpd_can_network_connect 1

# 또는 SELinux를 일시적으로 비활성화 (테스트용)
# sudo setenforce 0
```

## 6. Nginx 설정 테스트 및 재시작

```bash
# 설정 파일 문법 검사
sudo nginx -t

# Nginx 재시작
sudo systemctl restart nginx

# 또는 설정만 리로드
sudo systemctl reload nginx
```

## 7. /etc/hosts 파일 수정 (로컬 테스트용)

로컬에서 도메인 이름으로 테스트하려면:

```bash
# hosts 파일 편집
sudo vi /etc/hosts

# 아래 라인 추가 (your-domain.com을 설정한 도메인으로 변경)
127.0.0.1   your-domain.com
```

## 8. 애플리케이션 실행

Nginx 설정 후 백엔드와 프론트엔드를 실행하세요:

```bash
# 백엔드 실행 (터미널 1)
cd backend
source venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# 프론트엔드 실행 (터미널 2)
cd frontend
npm run dev -- --host 0.0.0.0 --port 3000
```

## 9. 접속 확인

브라우저에서 다음 주소로 접속:

- **메인 페이지:** `http://your-domain.com/`
- **API 문서:** `http://your-domain.com/docs`
- **pgAdmin:** `http://your-domain.com/pgadmin` (선택사항)

## 10. HTTPS 설정 (Let's Encrypt)

프로덕션 환경에서는 HTTPS를 권장합니다:

```bash
# Certbot 설치
sudo dnf install certbot python3-certbot-nginx -y

# SSL 인증서 발급 및 Nginx 자동 설정
sudo certbot --nginx -d your-domain.com

# 인증서 자동 갱신 테스트
sudo certbot renew --dry-run
```

## 문제 해결

### Nginx 에러 로그 확인
```bash
sudo tail -f /var/log/nginx/error.log
```

### Nginx 액세스 로그 확인
```bash
sudo tail -f /var/log/nginx/access.log
```

### 포트 사용 확인
```bash
sudo netstat -tlnp | grep nginx
sudo ss -tlnp | grep nginx
```

### Nginx 프로세스 확인
```bash
ps aux | grep nginx
```

### 설정 파일 위치
- 메인 설정: `/etc/nginx/nginx.conf`
- 사이트 설정: `/etc/nginx/conf.d/*.conf`
- 로그: `/var/log/nginx/`

## 주의사항

1. **프론트엔드 포트**: Vite는 기본적으로 포트 5173을 사용할 수 있습니다. `package.json` 확인 후 필요시 nginx.conf의 포트를 변경하세요.

2. **CORS 설정**: 백엔드의 `.env` 파일에서 `CORS_ORIGINS`에 도메인을 추가하세요:
   ```env
   CORS_ORIGINS=http://your-domain.com,https://your-domain.com
   ```

3. **프론트엔드 API URL**: 프론트엔드의 `.env` 파일에서:
   ```env
   VITE_API_URL=http://your-domain.com
   ```

4. **파일 업로드**: 큰 파일 업로드가 필요하면 nginx.conf의 `client_max_body_size`를 조정하세요.
