@echo off
REM Docker Compose 전체 서비스 시작 스크립트 (Windows)

echo ======================================
echo 🐳 Docker Compose 서비스 시작
echo ======================================

REM 환경변수 파일 확인
if not exist ".env" (
    echo.
    echo ⚠️  .env 파일이 없습니다. .env.example을 복사합니다...
    copy .env.example .env
    echo ✅ .env 파일이 생성되었습니다.
    echo 📝 필요한 경우 .env 파일을 수정하세요.
    echo.
)

REM Docker Compose 파일 확인
if not exist "docker-compose.yml" (
    echo ❌ docker-compose.yml 파일을 찾을 수 없습니다!
    exit /b 1
)

REM 서비스 시작
echo.
echo 🚀 모든 서비스를 시작합니다...
echo.

docker compose up -d --build

echo.
echo ⏳ 서비스가 준비될 때까지 대기 중...
timeout /t 5 /nobreak >nul

REM 서비스 상태 확인
echo.
echo 📊 서비스 상태:
docker compose ps

echo.
echo ======================================
echo ✅ 모든 서비스가 시작되었습니다!
echo ======================================
echo.
echo 🌐 접속 주소:
echo   - Frontend:    http://localhost
echo   - Backend API: http://localhost/api
echo   - API Docs:    http://localhost/docs
echo   - PostgreSQL:  localhost:5432
echo.
echo 📝 유용한 명령어:
echo   - 로그 확인:       docker compose logs -f
echo   - 특정 로그:       docker compose logs -f [서비스명]
echo   - 서비스 재시작:   docker compose restart [서비스명]
echo   - 서비스 중지:     docker-stop.bat
echo.
echo 🔧 개별 서비스 로그:
echo   docker compose logs -f frontend
echo   docker compose logs -f backend
echo   docker compose logs -f nginx
echo   docker compose logs -f postgres
echo.
echo ======================================

pause
