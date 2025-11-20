<div align="center">

# 🤖 LLM API WebApp

**다양한 LLM API를 쉽게 테스트하고 관리할 수 있는 웹 애플리케이션**

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)](https://reactjs.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat-square&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)](https://nginx.org/)

[주요 기능](#-주요-기능) • [빠른 시작](#-빠른-시작) • [배포](#-배포-프로덕션) • [API 문서](#-api-엔드포인트)

</div>

---

## 🛠 기술 스택

<table>
<tr>
<td>

**Frontend**
- ⚛️ React 19
- ⚡ Vite
- 🔄 Axios

</td>
<td>

**Backend**
- 🚀 FastAPI
- 🗄️ SQLAlchemy
- 🐘 PostgreSQL
- 🔀 Alembic
- 📡 httpx

</td>
<td>

**Infrastructure**
- 🐳 Docker & Compose
- 🔒 Nginx + SSL
- 📜 Let's Encrypt
- 🛡️ Certbot

</td>
</tr>
</table>

## ✨ 주요 기능

- 🎯 **LLM API 통합 관리** - OpenAI, Claude, Gemini 등 다양한 LLM API 지원
- 📝 **요청 관리** - API 주소, 모델 키, 모델명을 통한 손쉬운 요청 생성
- 📎 **파일 첨부** - 이미지 및 문서 파일 업로드 지원
- 💾 **요청 기록** - 모든 요청 기록을 데이터베이스에 저장 및 조회
- ⚡ **실시간 상태** - 요청의 진행 상태를 실시간으로 확인
- 🔍 **상세 정보** - 요청 및 응답 상세 정보 모달 뷰
- 🗑️ **기록 관리** - 불필요한 요청 기록 삭제
- 🔐 **보안** - HTTPS/SSL 인증서 자동 갱신

## 📁 프로젝트 구조

```
llm-api-webapp/
├── 📱 frontend/                 # React 애플리케이션
│   ├── src/
│   │   ├── components/         # React 컴포넌트
│   │   │   ├── LLMForm.jsx
│   │   │   └── RequestList.jsx
│   │   ├── services/
│   │   │   └── api.js
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── Dockerfile              # Frontend 도커 설정
│   ├── .dockerignore
│   └── package.json
│
├── 🚀 backend/                  # FastAPI 애플리케이션
│   ├── app/
│   │   ├── models/             # SQLAlchemy 모델
│   │   ├── schemas/            # Pydantic 스키마
│   │   ├── routes/             # API 라우트
│   │   ├── config.py
│   │   ├── database.py
│   │   └── main.py
│   ├── alembic/                # DB 마이그레이션
│   ├── Dockerfile              # Backend 도커 설정
│   ├── .dockerignore
│   └── requirements.txt
│
├── 🔒 nginx/                    # Nginx 리버스 프록시
│   ├── nginx.conf              # Nginx 메인 설정
│   └── conf.d/
│       └── default.conf        # SSL 및 프록시 설정
│
├── 🐳 Docker 설정
│   ├── docker-compose.yml      # 전체 서비스 오케스트레이션
│   ├── init-letsencrypt.sh     # SSL 인증서 초기화
│   ├── .env.example            # 환경변수 템플릿
│   └── DEPLOYMENT.md           # 배포 가이드
│
└── 📚 문서
    └── README.md               # 이 문서
```

## 🚀 빠른 시작

### 📋 사전 요구사항

<table>
<tr>
<td width="50%">

**개발 환경**
- Node.js 18+
- Python 3.10+
- Docker & Docker Compose

</td>
<td width="50%">

**프로덕션 환경**
- Docker & Docker Compose
- 도메인 이름
- 포트 80, 443 오픈

</td>
</tr>
</table>

### 🔧 개발 환경 설정

#### 1️⃣ 저장소 클론 및 환경변수 설정

```bash
git clone <repository-url>
cd llm-api-webapp

# 환경변수 파일 생성
cp .env.example .env
# .env 파일을 실제 값으로 수정
```

#### 2️⃣ 데이터베이스 실행 (PostgreSQL)

```bash
# PostgreSQL 및 pgAdmin 시작
docker compose up -d postgres pgadmin

# 데이터베이스 상태 확인
docker compose ps
```

**서비스 접속**
- 🐘 PostgreSQL: `localhost:5432`
- 🔧 pgAdmin: `http://localhost:5050`
  - Email: `admin@admin.com`
  - Password: `admin`

#### 3️⃣ 백엔드 설정 및 실행

```bash
cd backend

# 가상환경 생성 및 활성화
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 의존성 설치
pip install -r requirements.txt

# 환경변수 설정
cp .env.example .env

# 데이터베이스 마이그레이션
alembic upgrade head

# 개발 서버 실행
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**백엔드 서비스**
- 🚀 API: `http://localhost:8000`
- 📚 API 문서: `http://localhost:8000/docs`

#### 4️⃣ 프론트엔드 설정 및 실행

```bash
cd frontend

# 의존성 설치
npm install

# 환경변수 설정
cp .env.example .env

# 개발 서버 실행
npm run dev
```

**프론트엔드 서비스**
- ⚛️ React 앱: `http://localhost:3000`

---

### ⚡ 편의 스크립트로 빠르게 시작하기

프로젝트에는 서비스를 쉽게 관리할 수 있는 스크립트들이 포함되어 있습니다.

#### 🚀 가장 간단한 실행 (추천!)

**Linux/Mac/WSL:**
```bash
./run.sh
```

**Windows:**
```cmd
run.bat
```

이 명령어 하나로:
- ✅ 환경변수 파일 자동 생성 (`.env`)
- ✅ 모든 서비스 빌드 및 시작
- ✅ 접속 주소 안내

#### 🛠️ 상세 제어 스크립트

| 스크립트 | 설명 | 사용법 |
|---------|------|--------|
| `run.sh` / `run.bat` | **가장 간단한 실행** | `./run.sh` |
| `docker-start.sh` / `.bat` | 상세 정보와 함께 시작 | `./docker-start.sh` |
| `docker-stop.sh` / `.bat` | 중지 (옵션 선택 가능) | `./docker-stop.sh` |
| `docker-dev.sh` / `.bat` | 개발 환경 설정 | `./docker-dev.sh` |
| `docker-prod.sh` | 프로덕션 배포 (SSL) | `./docker-prod.sh` |

**중지 옵션** (`docker-stop.sh` 실행 시):
1. 서비스만 중지 (데이터 유지)
2. 서비스 중지 + 컨테이너 삭제
3. 서비스 중지 + 컨테이너 + 볼륨 삭제 (데이터 삭제)

---

### 🌐 Docker Compose 직접 실행

스크립트 없이 Docker Compose 명령어를 직접 사용하려면:

#### ⚠️ 첫 실행 시 주의사항

로컬 개발 환경에서 처음 실행하기 전에 다음을 확인하세요:

**1. Frontend package-lock.json 생성**
```bash
cd frontend
npm install
cd ..
```

**2. Backend .env 설정 확인**
```bash
# backend/.env 파일에서 CORS_ORIGINS 형식 확인
# ❌ 잘못된 형식: CORS_ORIGINS=http://localhost:3000,http://localhost:5173
# ✅ 올바른 형식: CORS_ORIGINS=["http://localhost", "http://localhost:3000", "http://localhost:5173"]
```

`backend/.env` 올바른 설정 예시:
```env
DATABASE_URL=postgresql://llmuser:llmpass@postgres:5432/llmdb
CORS_ORIGINS=["http://localhost", "http://localhost:3000", "http://localhost:5173"]
```

**3. Nginx 설정 (로컬 개발용)**

로컬 환경에서는 SSL 없이 HTTP만 사용하도록 `nginx/conf.d/default.conf` 수정:
```nginx
# HTTP Server - Development mode (no SSL)
server {
    listen 80;
    server_name localhost;
    # ... 나머지 설정
}
```

#### 🚀 서비스 실행

```bash
# 모든 서비스 빌드 및 실행
docker compose up -d --build

# 로그 확인
docker compose logs -f

# 서비스 중지
docker compose down
```

**접속 주소**
- Frontend: `http://localhost` (Nginx를 통해)
- Backend API: `http://localhost/api`
- API Docs: `http://localhost/docs`

---

## 🚢 배포 (프로덕션)

### SSL/HTTPS를 사용한 프로덕션 배포

프로덕션 환경에서는 Nginx + Let's Encrypt SSL 인증서를 사용하여 HTTPS를 제공합니다.

#### 1️⃣ 환경 설정

```bash
# 1. 환경변수 설정
cp .env.example .env
nano .env
```

`.env` 파일 예시:
```env
# Database
POSTGRES_USER=your_db_user
POSTGRES_PASSWORD=your_secure_password
POSTGRES_DB=your_db_name

# Domain
DOMAIN=your-domain.com
EMAIL=your-email@example.com

# API URL (프론트엔드에서 사용)
VITE_API_URL=https://your-domain.com/api
```

#### 2️⃣ Nginx 설정 수정

`nginx/conf.d/default.conf`에서 도메인 변경:

```nginx
# example.com을 실제 도메인으로 변경
server_name your-domain.com www.your-domain.com;

# SSL 인증서 경로도 변경
ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
```

#### 3️⃣ SSL 인증서 초기화

`init-letsencrypt.sh` 파일 수정:

```bash
# 도메인과 이메일 설정
domains=(your-domain.com www.your-domain.com)
email="your-email@example.com"
staging=0  # 테스트 시 1로 설정
```

**실행 (Linux/Mac/WSL):**

```bash
# 실행 권한 부여
chmod +x init-letsencrypt.sh

# SSL 인증서 발급
./init-letsencrypt.sh
```

> **💡 팁**: 처음 테스트할 때는 `staging=1`로 설정하여 Let's Encrypt rate limit을 피하세요!

#### 4️⃣ 전체 서비스 시작

```bash
# 모든 서비스 빌드 및 시작
docker compose up -d --build

# 로그 확인
docker compose logs -f

# 특정 서비스 로그만 확인
docker compose logs -f nginx
docker compose logs -f backend
```

#### 5️⃣ 접속 확인

- ✅ **Frontend**: `https://your-domain.com`
- ✅ **API Docs**: `https://your-domain.com/docs`
- ✅ **API**: `https://your-domain.com/api`

### 📌 주요 명령어

```bash
# 서비스 재시작
docker compose restart

# 특정 서비스만 재시작
docker compose restart backend

# 서비스 중지
docker compose down

# 이미지 재빌드 및 재시작
docker compose up -d --build backend

# SSL 인증서 수동 갱신
docker compose run --rm certbot renew
docker compose exec nginx nginx -s reload
```

> 📖 **상세한 배포 가이드는 [DEPLOYMENT.md](./DEPLOYMENT.md) 참고**

---

## 📡 API 엔드포인트

### 🎯 LLM 요청 관리

#### `POST /api/llm/request`
LLM API 요청 생성 및 실행

**Request (Form Data)**
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `api_url` | string | ✅ | LLM API 주소 |
| `model_key` | string | ✅ | API 키/토큰 |
| `model_name` | string | ✅ | 모델명 |
| `prompt` | string | ⬜ | 프롬프트 |
| `file` | file | ⬜ | 첨부파일 |

**Response**
```json
{
  "id": 1,
  "api_url": "https://api.openai.com/v1/chat/completions",
  "model_name": "gpt-4",
  "status": "completed",
  "response": "...",
  "created_at": "2025-01-20T10:00:00"
}
```

#### `GET /api/llm/requests`
모든 요청 조회

**Query Parameters**
- `skip`: 오프셋 (기본값: 0)
- `limit`: 제한 (기본값: 100)

#### `GET /api/llm/requests/{request_id}`
특정 요청 상세 조회

#### `DELETE /api/llm/requests/{request_id}`
요청 삭제

---

## 🗄️ 데이터베이스 스키마

### `llm_requests` 테이블

| 컬럼 | 타입 | 설명 |
|------|------|------|
| `id` | INTEGER PRIMARY KEY | 🔑 요청 ID |
| `api_url` | VARCHAR(500) | 🌐 LLM API 주소 |
| `model_key` | VARCHAR(500) | 🔐 API 키/토큰 |
| `model_name` | VARCHAR(100) | 🤖 선택한 모델명 |
| `prompt` | TEXT | 💬 사용자 입력 프롬프트 |
| `file_path` | VARCHAR(500) | 📁 첨부파일 경로 |
| `file_name` | VARCHAR(255) | 📄 첨부파일 이름 |
| `response` | TEXT | 📨 LLM API 응답 |
| `status` | VARCHAR(50) | 📊 요청 상태 (`pending`, `processing`, `completed`, `failed`) |
| `error_message` | TEXT | ⚠️ 에러 메시지 |
| `created_at` | TIMESTAMP | 🕐 생성 시간 |
| `updated_at` | TIMESTAMP | 🕑 수정 시간 |

## ⚙️ 환경변수

### 📦 루트 디렉토리 `.env`

전체 시스템 환경변수 (Docker Compose에서 사용):

```env
# 데이터베이스 설정
POSTGRES_USER=llmuser
POSTGRES_PASSWORD=llmpass
POSTGRES_DB=llmdb

# PgAdmin 설정
PGADMIN_EMAIL=admin@admin.com
PGADMIN_PASSWORD=admin

# 도메인 설정 (프로덕션)
DOMAIN=example.com
EMAIL=admin@example.com

# API URL (프론트엔드 빌드 시 사용)
VITE_API_URL=https://example.com/api
```

### 🚀 Backend `.env`

**로컬 개발 환경** (직접 실행 시):
```env
DATABASE_URL=postgresql://llmuser:llmpass@localhost:5432/llmdb
APP_NAME=LLM API WebApp
DEBUG=True
API_VERSION=v1
CORS_ORIGINS=["http://localhost:3000", "http://localhost:5173"]
UPLOAD_DIR=./uploads
MAX_UPLOAD_SIZE=10485760
```

**Docker 환경** (컨테이너에서 실행 시):
```env
DATABASE_URL=postgresql://llmuser:llmpass@postgres:5432/llmdb
APP_NAME=LLM API WebApp
DEBUG=True
API_VERSION=v1
CORS_ORIGINS=["http://localhost", "http://localhost:3000", "http://localhost:5173"]
UPLOAD_DIR=./uploads
MAX_UPLOAD_SIZE=10485760
```

> ⚠️ **중요**: `CORS_ORIGINS`는 JSON 배열 형식으로 작성해야 합니다. 콤마로 구분된 문자열이 아닙니다!

### ⚛️ Frontend `.env` (개발 환경)

```env
VITE_API_URL=http://localhost:8000
```

## 📖 사용 방법

### 1️⃣ LLM API 요청 생성

1. **API 정보 입력**
   - 🌐 API 주소 (예: `https://api.openai.com/v1/chat/completions`)
   - 🔑 모델 키/토큰
   - 🤖 사용할 모델 선택

2. **요청 내용 작성**
   - 💬 프롬프트 입력 (선택사항)
   - 📎 파일 첨부 (선택사항)

3. **전송**
   - ✉️ "API 요청 전송" 버튼 클릭

### 2️⃣ 요청 기록 확인

- 📋 오른쪽 패널에서 요청 기록 확인
- 🔍 요청 항목 클릭 → 상세 정보 모달 표시
- 🗑️ 삭제 버튼으로 요청 기록 제거

### 3️⃣ 상태 확인

| 상태 | 설명 | 아이콘 |
|------|------|--------|
| **완료** | ✅ 성공적으로 처리된 요청 | 🟢 |
| **처리중** | ⏳ 현재 처리 중인 요청 | 🟡 |
| **실패** | ❌ 오류가 발생한 요청 | 🔴 |
| **대기** | ⏸️ 대기 중인 요청 | ⚪ |

---

## 🤖 지원하는 LLM 모델

<table>
<tr>
<td width="33%">

**OpenAI**
- GPT-4
- GPT-4 Turbo
- GPT-3.5 Turbo

</td>
<td width="33%">

**Anthropic**
- Claude 3 Opus
- Claude 3 Sonnet
- Claude 3 Haiku

</td>
<td width="33%">

**Google**
- Gemini Pro
- Gemini Ultra

**기타**
- OpenAI 호환 API

</td>
</tr>
</table>

## 🛠️ 개발

### 🔧 개발 워크플로우

#### Backend 개발

```bash
cd backend

# 가상환경 활성화
source venv/bin/activate  # Windows: venv\Scripts\activate

# 핫 리로드로 서버 실행
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

#### Frontend 개발

```bash
cd frontend

# 개발 서버 실행 (핫 리로드)
npm run dev

# 린트 체크
npm run lint

# 프로덕션 빌드 테스트
npm run build
npm run preview
```

### 🗃️ 데이터베이스 마이그레이션

```bash
cd backend

# 새 마이그레이션 생성
alembic revision --autogenerate -m "Add new column"

# 마이그레이션 적용
alembic upgrade head

# 이전 버전으로 롤백
alembic downgrade -1

# 마이그레이션 히스토리 확인
alembic history
```

---

## 🔧 문제 해결

### ❌ Backend 시작 실패 (CORS_ORIGINS 오류)

**증상**: Backend 컨테이너가 시작되지 않고 `error parsing value for field "cors_origins"` 오류 발생

**해결**:
```bash
# backend/.env 파일의 CORS_ORIGINS 형식 확인
# ❌ 잘못된 형식
CORS_ORIGINS=http://localhost:3000,http://localhost:5173

# ✅ 올바른 형식 (JSON 배열)
CORS_ORIGINS=["http://localhost", "http://localhost:3000", "http://localhost:5173"]
```

### 🔨 Frontend 빌드 실패 (package-lock.json 누락)

**증상**: `npm ci` 명령 실패, "package-lock.json not found" 오류

**해결**:
```bash
cd frontend
npm install  # package-lock.json 생성
cd ..
docker compose up -d --build
```

### 🔒 Nginx SSL 오류 (로컬 개발)

**증상**: Nginx가 계속 재시작되며 SSL 인증서 파일을 찾을 수 없다는 오류 발생

**해결**: `nginx/conf.d/default.conf`를 로컬 개발용으로 수정
```nginx
# HTTP Server - Development mode (no SSL)
server {
    listen 80;
    server_name localhost;

    client_max_body_size 10M;

    # Backend API
    location /api {
        proxy_pass http://backend:8000;
        # ... 나머지 프록시 설정
    }

    # Frontend
    location / {
        proxy_pass http://frontend:80;
        # ... 나머지 프록시 설정
    }
}
```

### 🐘 데이터베이스 연결 오류

```bash
# PostgreSQL 컨테이너 상태 확인
docker compose ps

# 로그 확인
docker compose logs postgres

# 컨테이너 재시작
docker compose restart postgres

# 데이터베이스 접속 테스트
docker compose exec postgres psql -U llmuser -d llmdb
```

### 🔌 포트 충돌

**백엔드 포트 변경**
```bash
uvicorn app.main:app --port 8001
```

**프론트엔드 포트 변경**
`vite.config.js`:
```javascript
export default defineConfig({
  server: {
    port: 3001
  }
})
```

### 🔒 SSL 인증서 오류

```bash
# 인증서 상태 확인
docker compose run --rm certbot certificates

# 강제 갱신
docker compose run --rm certbot renew --force-renewal

# Nginx 재시작
docker compose restart nginx
```

### 🐳 Docker 빌드 캐시 문제

```bash
# 캐시 없이 재빌드
docker compose build --no-cache

# 모든 컨테이너, 이미지, 볼륨 정리
docker compose down -v
docker system prune -a
```

### 📝 로그 확인

```bash
# 전체 로그
docker compose logs -f

# 특정 서비스 로그
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f nginx

# 마지막 100줄만
docker compose logs --tail=100 backend
```

---

## 📚 참고 자료

- [FastAPI 공식 문서](https://fastapi.tiangolo.com/)
- [React 공식 문서](https://react.dev/)
- [Docker Compose 문서](https://docs.docker.com/compose/)
- [Let's Encrypt 가이드](https://letsencrypt.org/getting-started/)
- [Nginx 설정 가이드](https://nginx.org/en/docs/)

---

## 📄 라이센스

MIT License

---

## 🤝 기여

이슈 및 Pull Request를 환영합니다!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 지원

문제가 발생하거나 질문이 있으시면 이슈를 생성해주세요.

---

<div align="center">

**Made with ❤️ for LLM Developers**

[⬆️ 맨 위로 돌아가기](#-llm-api-webapp)

</div>
