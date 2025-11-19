# Podman으로 API Tester 실행하기

## 사전 요구사항
- Podman 설치
- podman-compose 설치 (선택사항)

## 실행 방법

### 방법 1: podman-compose 사용

```bash
# 이미지 빌드 및 컨테이너 실행
podman-compose -f podman-compose.yml up --build

# 백그라운드로 실행
podman-compose -f podman-compose.yml up -d --build

# 중지
podman-compose -f podman-compose.yml down

# 볼륨까지 삭제
podman-compose -f podman-compose.yml down -v
```

### 방법 2: Podman 명령어 직접 사용

#### 1. 네트워크 생성
```bash
podman network create api-network
```

#### 2. 볼륨 생성
```bash
podman volume create postgres_data
```

#### 3. PostgreSQL 컨테이너 실행
```bash
podman run -d \
  --name api-tester-db \
  --network api-network \
  -e POSTGRES_USER=apiuser \
  -e POSTGRES_PASSWORD=apipass \
  -e POSTGRES_DB=apitester \
  -p 5432:5432 \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:15-alpine
```

#### 4. 백엔드 이미지 빌드 및 실행
```bash
# 이미지 빌드
podman build -t api-tester-backend ./backend

# 컨테이너 실행
podman run -d \
  --name api-tester-backend \
  --network api-network \
  -e DATABASE_URL=postgresql://apiuser:apipass@db:5432/apitester \
  -p 8000:8000 \
  api-tester-backend
```

#### 5. 프론트엔드 이미지 빌드 및 실행
```bash
# 이미지 빌드
podman build -t api-tester-frontend ./frontend

# 컨테이너 실행
podman run -d \
  --name api-tester-frontend \
  --network api-network \
  -p 3000:80 \
  api-tester-frontend
```

### 방법 3: Podman Pod 사용 (Kubernetes와 유사)

```bash
# Pod 생성 및 포트 매핑
podman pod create --name api-tester-pod -p 3000:80 -p 8000:8000 -p 5432:5432

# PostgreSQL 컨테이너
podman run -d \
  --pod api-tester-pod \
  --name api-tester-db \
  -e POSTGRES_USER=apiuser \
  -e POSTGRES_PASSWORD=apipass \
  -e POSTGRES_DB=apitester \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:15-alpine

# 백엔드 컨테이너
podman build -t api-tester-backend ./backend
podman run -d \
  --pod api-tester-pod \
  --name api-tester-backend \
  -e DATABASE_URL=postgresql://apiuser:apipass@localhost:5432/apitester \
  api-tester-backend

# 프론트엔드 컨테이너
podman build -t api-tester-frontend ./frontend
podman run -d \
  --pod api-tester-pod \
  --name api-tester-frontend \
  api-tester-frontend
```

## 접속 정보

- **애플리케이션**: http://localhost:8080 (Nginx를 통한 단일 진입점)
  - 정적 파일 (HTML/CSS/JS): Nginx가 직접 서빙
  - API 요청 (/api/*): Nginx가 백엔드로 프록시
- **PostgreSQL**: localhost:5432 (직접 접속용)

## 유용한 명령어

```bash
# 컨테이너 상태 확인
podman ps -a

# Pod 상태 확인
podman pod ps

# 로그 확인
podman logs api-tester-backend
podman logs api-tester-frontend
podman logs api-tester-db

# 컨테이너 중지
podman stop api-tester-frontend api-tester-backend api-tester-db

# 컨테이너 삭제
podman rm api-tester-frontend api-tester-backend api-tester-db

# Pod 삭제 (Pod 내 모든 컨테이너 삭제)
podman pod rm -f api-tester-pod

# 네트워크 삭제
podman network rm api-network

# 볼륨 삭제
podman volume rm postgres_data
```

## 문제 해결

### DB 연결 실패
백엔드가 DB에 연결하지 못하면:
```bash
# DB가 준비될 때까지 대기 후 백엔드 재시작
podman restart api-tester-backend
```

### 이미지 재빌드
코드 변경 후 이미지를 다시 빌드하려면:
```bash
podman build --no-cache -t api-tester-backend ./backend
podman build --no-cache -t api-tester-frontend ./frontend
```
