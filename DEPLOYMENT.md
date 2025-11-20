# Docker Compose + Nginx + SSL 배포 가이드

이 문서는 React + FastAPI + PostgreSQL 프로젝트를 Docker Compose로 배포하고 Nginx 리버스 프록시와 Let's Encrypt SSL 인증서를 적용하는 방법을 설명합니다.

## 📋 사전 요구사항

- Docker 및 Docker Compose 설치
- 도메인 이름 (예: example.com)
- 도메인의 DNS A 레코드가 서버 IP를 가리키도록 설정
- 방화벽에서 80번, 443번 포트 오픈

## 📁 프로젝트 구조

```
llm-api-webapp/
├── frontend/
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── package.json
│   └── src/
├── backend/
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── requirements.txt
│   └── app/
├── nginx/
│   ├── nginx.conf
│   └── conf.d/
│       └── default.conf
├── docker-compose.yml
├── init-letsencrypt.sh
├── .env.example
└── .env
```

## 🚀 배포 단계

### 1. 환경 변수 설정

`.env.example` 파일을 복사하여 `.env` 파일을 생성하고 실제 값으로 수정합니다:

```bash
cp .env.example .env
```

`.env` 파일 수정:
```env
# Database Configuration
POSTGRES_USER=your_db_user
POSTGRES_PASSWORD=your_secure_password
POSTGRES_DB=your_db_name

# PgAdmin Configuration
PGADMIN_EMAIL=your_email@example.com
PGADMIN_PASSWORD=your_admin_password

# Domain Configuration
DOMAIN=your-domain.com
EMAIL=your-email@example.com

# Application Configuration
VITE_API_URL=https://your-domain.com/api
```

### 2. 도메인 설정

`nginx/conf.d/default.conf` 파일에서 도메인을 수정합니다:

```nginx
server_name example.com www.example.com;
```

위 부분을 실제 도메인으로 변경:
```nginx
server_name your-domain.com www.your-domain.com;
```

SSL 인증서 경로도 수정:
```nginx
ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
```

### 3. SSL 인증서 초기화 스크립트 수정

`init-letsencrypt.sh` 파일을 수정합니다:

```bash
domains=(your-domain.com www.your-domain.com)
email="your-email@example.com"
staging=0  # 테스트 시 1로 설정
```

**중요**: 처음 테스트할 때는 `staging=1`로 설정하여 Let's Encrypt의 rate limit을 피하세요!

### 4. 스크립트 실행 권한 부여

```bash
chmod +x init-letsencrypt.sh
```

### 5. Docker 이미지 빌드

```bash
docker compose build
```

### 6. SSL 인증서 발급

먼저 테스트 모드로 실행 (`init-letsencrypt.sh`에서 `staging=1`):

```bash
./init-letsencrypt.sh
```

테스트가 성공하면, `staging=0`으로 변경하고 다시 실행:

```bash
./init-letsencrypt.sh
```

### 7. 모든 서비스 시작

```bash
docker compose up -d
```

## 🔍 서비스 확인

### 컨테이너 상태 확인
```bash
docker compose ps
```

### 로그 확인
```bash
# 모든 서비스 로그
docker compose logs -f

# 특정 서비스 로그
docker compose logs -f nginx
docker compose logs -f backend
docker compose logs -f frontend
```

### 접속 테스트
- **Frontend**: https://your-domain.com
- **Backend API Docs**: https://your-domain.com/docs
- **Backend API**: https://your-domain.com/api

## 🔧 주요 명령어

### 서비스 재시작
```bash
docker compose restart
```

### 특정 서비스만 재시작
```bash
docker compose restart nginx
docker compose restart backend
```

### 서비스 중지
```bash
docker compose down
```

### 볼륨까지 삭제하고 중지
```bash
docker compose down -v
```

### 이미지 재빌드 및 재시작
```bash
docker compose up -d --build
```

## 🔐 SSL 인증서 갱신

Certbot 컨테이너는 자동으로 12시간마다 인증서 갱신을 시도합니다. 수동 갱신이 필요한 경우:

```bash
docker compose run --rm certbot renew
docker compose exec nginx nginx -s reload
```

## 🛠 문제 해결

### 1. Nginx 설정 검증
```bash
docker compose exec nginx nginx -t
```

### 2. SSL 인증서 확인
```bash
docker compose run --rm certbot certificates
```

### 3. 데이터베이스 연결 확인
```bash
docker compose exec backend python -c "from app.database import engine; engine.connect()"
```

### 4. 포트 충돌 확인
```bash
# Windows
netstat -ano | findstr :80
netstat -ano | findstr :443

# Linux/Mac
netstat -tuln | grep :80
netstat -tuln | grep :443
```

### 5. 방화벽 확인 (Linux)
```bash
sudo ufw status
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

## 📊 개발 환경 vs 프로덕션 환경

### 개발 환경 (로컬)
```bash
# Frontend
cd frontend
npm run dev

# Backend
cd backend
uvicorn app.main:app --reload

# Database only
docker compose up -d postgres pgadmin
```

### 프로덕션 환경 (서버)
```bash
docker compose up -d
```

## 🔄 업데이트 배포

### 코드 변경 후 배포
```bash
# 1. Git pull (코드 업데이트)
git pull origin main

# 2. 이미지 재빌드 및 재시작
docker compose up -d --build

# 3. 특정 서비스만 업데이트
docker compose up -d --build backend
docker compose up -d --build frontend
```

## 📝 추가 설정

### Backend 환경 변수 추가

`docker-compose.yml`의 backend 서비스에 환경 변수 추가:

```yaml
backend:
  environment:
    DATABASE_URL: postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
    SECRET_KEY: ${SECRET_KEY}
    ALGORITHM: HS256
    ACCESS_TOKEN_EXPIRE_MINUTES: 30
```

### Frontend 빌드 시 환경 변수 사용

`frontend/Dockerfile`에서 build args 사용:

```dockerfile
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL
```

`docker-compose.yml`에서:

```yaml
frontend:
  build:
    context: ./frontend
    dockerfile: Dockerfile
    args:
      VITE_API_URL: ${VITE_API_URL}
```

## 🔒 보안 권장사항

1. **.env 파일 보호**: `.gitignore`에 `.env` 추가 (이미 되어있음)
2. **강력한 비밀번호 사용**: PostgreSQL, PgAdmin 비밀번호
3. **정기적인 업데이트**: Docker 이미지 및 패키지
4. **로그 모니터링**: 비정상적인 접근 감지
5. **백업**: 정기적인 데이터베이스 백업

```bash
# 데이터베이스 백업
docker compose exec postgres pg_dump -U llmuser llmdb > backup_$(date +%Y%m%d).sql

# 데이터베이스 복원
docker compose exec -T postgres psql -U llmuser llmdb < backup_20250101.sql
```

## 📞 참고 자료

- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [React Documentation](https://react.dev/)

## 🆘 도움이 필요한 경우

문제가 발생하면 다음을 확인하세요:
1. 모든 컨테이너가 실행 중인지 (`docker compose ps`)
2. 로그에 에러가 있는지 (`docker compose logs`)
3. DNS 설정이 올바른지
4. 방화벽/보안 그룹 설정이 올바른지
5. SSL 인증서가 유효한지
