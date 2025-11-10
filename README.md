# LLM API WebApp

다양한 LLM(Large Language Model) API를 쉽게 테스트하고 관리할 수 있는 웹 애플리케이션입니다.

## 기술 스택

### Frontend
- React 19
- Vite
- Axios (API 통신)

### Backend
- FastAPI
- SQLAlchemy (ORM)
- PostgreSQL
- Alembic (마이그레이션)
- httpx (비동기 HTTP 클라이언트)

### Infrastructure
- Docker & Docker Compose
- PostgreSQL 15
- pgAdmin 4

## 주요 기능

- LLM API 요청 관리 (OpenAI, Claude, Gemini 등)
- API 주소, 모델 키, 모델명 입력
- 파일 첨부 기능
- 요청 기록 저장 및 조회
- 실시간 요청 상태 확인
- 요청 상세 정보 모달
- 요청 기록 삭제

## 프로젝트 구조

```
llm-api-webapp/
├── frontend/              # React 애플리케이션
│   ├── src/
│   │   ├── components/    # React 컴포넌트
│   │   │   ├── LLMForm.jsx       # LLM API 요청 폼
│   │   │   └── RequestList.jsx   # 요청 기록 리스트
│   │   ├── services/      # API 서비스
│   │   │   └── api.js
│   │   ├── App.jsx
│   │   ├── App.css
│   │   └── main.jsx
│   ├── package.json
│   └── vite.config.js
│
├── backend/               # FastAPI 애플리케이션
│   ├── app/
│   │   ├── models/        # SQLAlchemy 모델
│   │   │   └── llm_request.py
│   │   ├── schemas/       # Pydantic 스키마
│   │   │   └── llm_request.py
│   │   ├── routes/        # API 라우트
│   │   │   └── llm.py
│   │   ├── config.py      # 설정
│   │   ├── database.py    # DB 연결
│   │   └── main.py        # 메인 앱
│   ├── alembic/           # DB 마이그레이션
│   └── requirements.txt
│
└── docker-compose.yml     # PostgreSQL 컨테이너
```

## 시작하기

### 사전 요구사항

- **Linux (Red Hat 8.10)** 환경
- **Node.js 18+** (프론트엔드)
- **Python 3.10+** (백엔드)
- **Docker & Docker Compose** (데이터베이스)

### 1. 데이터베이스 실행

```bash
# PostgreSQL 및 pgAdmin 시작
docker-compose up -d

# 데이터베이스 상태 확인
docker-compose ps
```

- PostgreSQL: `localhost:5432`
- pgAdmin: `http://localhost:5050`
  - Email: admin@admin.com
  - Password: admin

### 2. 백엔드 설정 및 실행

```bash
cd backend

# 가상환경 생성 및 활성화
python3 -m venv venv
source venv/bin/activate

# 의존성 설치
pip install -r requirements.txt

# 환경변수 설정
cp .env.example .env
# .env 파일을 편집하여 필요한 설정 변경

# 데이터베이스 마이그레이션 (선택사항)
alembic upgrade head

# 서버 실행
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

백엔드 API: `http://localhost:8000`
API 문서: `http://localhost:8000/docs`

### 3. 프론트엔드 설정 및 실행

```bash
cd frontend

# 의존성 설치
npm install

# 환경변수 설정
cp .env.example .env
# .env 파일을 편집하여 API URL 설정

# 개발 서버 실행
npm run dev
```

프론트엔드 앱: `http://localhost:3000`

## API 엔드포인트

### LLM 요청

- `POST /api/llm/request` - LLM API 요청 생성 및 실행
  - Form Data:
    - `api_url`: LLM API 주소
    - `model_key`: API 키/토큰
    - `model_name`: 모델명
    - `prompt`: 프롬프트 (선택)
    - `file`: 첨부파일 (선택)

- `GET /api/llm/requests` - 모든 요청 조회
  - Query Parameters:
    - `skip`: 오프셋 (기본값: 0)
    - `limit`: 제한 (기본값: 100)

- `GET /api/llm/requests/{request_id}` - 특정 요청 조회

- `DELETE /api/llm/requests/{request_id}` - 요청 삭제

## 데이터베이스 스키마

### llm_requests 테이블

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | INTEGER PRIMARY KEY | 요청 ID |
| api_url | VARCHAR(500) | LLM API 주소 |
| model_key | VARCHAR(500) | API 키/토큰 |
| model_name | VARCHAR(100) | 선택한 모델명 |
| prompt | TEXT | 사용자 입력 프롬프트 |
| file_path | VARCHAR(500) | 첨부파일 경로 |
| file_name | VARCHAR(255) | 첨부파일 이름 |
| response | TEXT | LLM API 응답 |
| status | VARCHAR(50) | 요청 상태 (pending, processing, completed, failed) |
| error_message | TEXT | 에러 메시지 |
| created_at | TIMESTAMP | 생성 시간 |
| updated_at | TIMESTAMP | 수정 시간 |

## 환경변수

### Backend (.env)

```env
DATABASE_URL=postgresql://llmuser:llmpass@localhost:5432/llmdb
APP_NAME=LLM API WebApp
DEBUG=True
API_VERSION=v1
CORS_ORIGINS=http://localhost:3000,http://localhost:5173
UPLOAD_DIR=./uploads
MAX_UPLOAD_SIZE=10485760
```

### Frontend (.env)

```env
VITE_API_URL=http://localhost:8000
```

## 사용 방법

1. **LLM API 요청 생성**
   - API 주소 입력 (예: https://api.openai.com/v1/chat/completions)
   - 모델 키/토큰 입력
   - 사용할 모델 선택
   - 프롬프트 입력 (선택사항)
   - 파일 첨부 (선택사항)
   - "API 요청 전송" 버튼 클릭

2. **요청 기록 확인**
   - 오른쪽 패널에서 요청 기록 확인
   - 요청 항목 클릭 시 상세 정보 모달 표시
   - 삭제 버튼으로 요청 기록 제거

3. **상태 확인**
   - 완료: 성공적으로 처리된 요청
   - 처리중: 현재 처리 중인 요청
   - 실패: 오류가 발생한 요청
   - 대기: 대기 중인 요청

## 지원하는 LLM 모델

- GPT-4, GPT-4 Turbo, GPT-3.5 Turbo (OpenAI)
- Claude 3 Opus, Sonnet, Haiku (Anthropic)
- Gemini Pro (Google)
- 기타 OpenAI 호환 API

## 개발

### 백엔드 개발

```bash
# 가상환경 활성화
source backend/venv/bin/activate

# 서버 실행 (핫 리로드)
cd backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 프론트엔드 개발

```bash
# 개발 서버 실행
cd frontend
npm run dev
```

### 데이터베이스 마이그레이션

```bash
cd backend

# 새 마이그레이션 생성
alembic revision --autogenerate -m "설명"

# 마이그레이션 적용
alembic upgrade head

# 마이그레이션 롤백
alembic downgrade -1
```

## 배포

### 프론트엔드 빌드

```bash
cd frontend
npm run build
# dist/ 폴더에 빌드 결과 생성
```

### 프로덕션 설정

1. `.env` 파일에서 `DEBUG=False` 설정
2. `CORS_ORIGINS`를 프로덕션 도메인으로 변경
3. 데이터베이스 비밀번호 변경
4. HTTPS 설정 (nginx, caddy 등)

## 문제 해결

### 데이터베이스 연결 오류

```bash
# PostgreSQL 컨테이너 상태 확인
docker-compose ps

# 로그 확인
docker-compose logs postgres
```

### 포트 충돌

- 백엔드 포트 변경: `uvicorn app.main:app --port 8001`
- 프론트엔드 포트 변경: `vite.config.js`에서 `server.port` 수정

## 라이센스

MIT License

## 기여

이슈 및 PR 환영합니다!
