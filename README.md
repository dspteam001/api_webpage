<div align="center">

# 🚀 API Tester

### 강력하고 직관적인 API 테스팅 도구

Postman이나 Insomnia처럼 API를 쉽게 테스트할 수 있는 웹 애플리케이션입니다.

[![React](https://img.shields.io/badge/React-18.2-61dafb?style=for-the-badge&logo=react)](https://reactjs.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104-009688?style=for-the-badge&logo=fastapi)](https://fastapi.tiangolo.com/)
[![Python](https://img.shields.io/badge/Python-3.8+-3776ab?style=for-the-badge&logo=python)](https://www.python.org/)

</div>

---

## ✨ 주요 기능

<table>
<tr>
<td width="50%">

### 🎯 완벽한 HTTP 지원
- ✅ GET, POST, PUT, DELETE, PATCH 메서드
- ✅ 커스텀 헤더 설정 (JSON 형식)
- ✅ Request Body 입력 지원
- ✅ 실시간 응답 확인

</td>
<td width="50%">

### 📊 강력한 모니터링
- ⚡ 응답 시간 측정 (ms 단위)
- 📦 응답 크기 표시
- 🎨 Status Code 색상 구분
- 💾 요청 히스토리 자동 저장

</td>
</tr>
</table>

### 🎨 모던한 UI/UX
- 깔끔하고 직관적인 인터페이스
- 다크 모드 코드 에디터
- 반응형 디자인
- 원클릭 예제 로드

---

## 📸 스크린샷

### 메인 화면
애플리케이션의 메인 인터페이스입니다. 왼쪽에서 API 요청을 작성하고, 오른쪽에서 히스토리를 확인할 수 있습니다.

### 응답 화면
API 요청 후 응답이 표시됩니다:
- **Status Code**: 색상으로 구분 (200=녹색, 400=주황, 500=빨강)
- **Response Time**: 응답 속도를 ms 단위로 표시
- **Response Size**: 바이트 단위 크기
- **Response Body**: JSON 자동 포맷팅, 다크 테마 코드 뷰어
<img width="1196" height="749" alt="image" src="https://github.com/user-attachments/assets/45ea2a8f-34f8-4dea-8782-48ceeb67a781" />

---

## 🛠️ 기술 스택

| 카테고리 | 기술 |
|---------|------|
| **Frontend** | React 18.2, Axios, Modern CSS |
| **Backend** | FastAPI, Uvicorn, SQLAlchemy |
| **Database** | SQLite (기본) / PostgreSQL (Docker) |
| **API Client** | HTTPX (비동기 HTTP 요청) |

---

## 📋 사전 요구사항

```
✅ Python 3.8 이상
✅ Node.js 14 이상
✅ Docker Desktop (선택사항 - PostgreSQL 사용 시)
```

---

## 🚀 빠른 시작

### 방법 1: 자동 실행 (Windows)

가장 간단한 방법입니다! 한 번의 클릭으로 모든 서비스를 시작할 수 있습니다.

```bash
run.bat
```

> **💡 Tip:** `run.bat`을 더블클릭하면 데이터베이스, 백엔드, 프론트엔드가 자동으로 실행됩니다.

### 방법 2: 수동 실행

<details>
<summary><b>📦 1. 데이터베이스 실행 (선택사항)</b></summary>

PostgreSQL을 사용하려면:
```bash
docker-compose up -d
```

SQLite는 별도 설정 없이 자동으로 사용됩니다.
</details>

<details>
<summary><b>🐍 2. 백엔드 실행</b></summary>

```bash
cd backend
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Mac/Linux
pip install -r requirements.txt
python main.py
```

백엔드가 **http://localhost:8000** 에서 실행됩니다.
</details>

<details>
<summary><b>⚛️ 3. 프론트엔드 실행</b></summary>

```bash
cd frontend
npm install
npm start
```

프론트엔드가 **http://localhost:3000** 에서 자동으로 열립니다.
</details>

---

## 🌐 접속 주소

| 서비스 | URL | 설명 |
|--------|-----|------|
| 🎨 **Frontend** | http://localhost:3000 | 메인 웹 애플리케이션 |
| ⚙️ **Backend API** | http://localhost:8000 | FastAPI 서버 |
| 📚 **API Docs** | http://localhost:8000/docs | Swagger UI 문서 |

---

## 📖 사용 방법

### 1️⃣ 기본 사용법

1. 🌐 웹 브라우저에서 **http://localhost:3000** 접속
2. 🔘 HTTP 메서드 선택 (GET, POST, PUT, DELETE, PATCH)
3. 📝 API URL 입력 (예: `https://api.example.com/users`)
4. 📋 필요시 Headers와 Body 입력 (JSON 형식)
5. 🚀 **Send Request** 버튼 클릭
6. ✅ 응답 결과 확인 (Status, Time, Size, Body)
7. 📜 오른쪽 History 패널에서 이전 요청 확인

### 2️⃣ 예제로 시작하기

처음 사용하시나요? **"Load Example"** 버튼을 클릭하면 JSONPlaceholder API를 사용한 예제가 자동으로 로드됩니다!

```json
GET https://jsonplaceholder.typicode.com/users/1
Headers: {
  "Accept": "application/json"
}
```

### 3️⃣ POST 요청 예제

```http
POST https://jsonplaceholder.typicode.com/posts
Headers: {
  "Content-Type": "application/json"
}
Body: {
  "title": "My Post",
  "body": "This is my post content",
  "userId": 1
}
```

---

## 📁 프로젝트 구조

```
📦 api-tester/
┣ 📂 backend/                 # 🐍 Python FastAPI 백엔드
┃ ┣ 📜 main.py               # 메인 API 서버
┃ ┣ 📜 models.py             # 데이터베이스 모델
┃ ┣ 📜 database.py           # DB 연결 설정
┃ ┣ 📜 requirements.txt      # Python 의존성
┃ ┗ 📜 .env                  # 환경 변수
┣ 📂 frontend/               # ⚛️ React 프론트엔드
┃ ┣ 📂 public/               # 정적 파일
┃ ┃ ┗ 📜 index.html
┃ ┣ 📂 src/                  # 소스 코드
┃ ┃ ┣ 📜 App.js             # 메인 컴포넌트
┃ ┃ ┣ 📜 App.css            # 스타일시트
┃ ┃ ┗ 📜 index.js           # 진입점
┃ ┗ 📜 package.json         # npm 의존성
┣ 📜 docker-compose.yml      # 🐳 Docker 설정
┣ 📜 run.bat                 # 🚀 실행 스크립트
┣ 📜 .gitignore              # Git 제외 파일
┗ 📜 README.md               # 문서
```

---

## 🎯 주요 API 엔드포인트

### Backend API

| Method | Endpoint | 설명 |
|--------|----------|------|
| `POST` | `/api/request` | API 요청 전송 및 응답 저장 |
| `GET` | `/api/history` | 요청 히스토리 조회 (최근 50개) |
| `GET` | `/api/history/{id}` | 특정 요청의 상세 정보 조회 |

---

## 🤝 기여하기

이 프로젝트에 기여하고 싶으신가요? 환영합니다!

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

---

## 👨‍💻 개발자

Made with ❤️ by [Your Name]

---

<div align="center">

### ⭐ 이 프로젝트가 유용했다면 Star를 눌러주세요!

**[🐛 버그 리포트](../../issues)** • **[💡 기능 요청](../../issues)** • **[📖 문서](../../wiki)**

</div>
