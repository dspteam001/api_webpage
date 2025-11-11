@echo off
echo ========================================
echo Starting API Tester Application
echo ========================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo [1/4] Starting PostgreSQL database with Docker...
docker-compose up -d
if errorlevel 1 (
    echo [ERROR] Failed to start database
    pause
    exit /b 1
)
echo Database started successfully!
echo.

echo [2/4] Waiting for database to be ready...
timeout /t 5 /nobreak >nul
echo.

echo [3/4] Installing Python dependencies...
cd backend
if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
)
call venv\Scripts\activate.bat
pip install -r requirements.txt >nul 2>&1
echo.

echo [4/4] Starting backend server...
start cmd /k "title Backend Server && echo Backend starting on http://localhost:8000 && python main.py"
cd ..
echo.

echo [5/5] Installing frontend dependencies and starting React app...
cd frontend
if not exist node_modules (
    echo Installing npm packages... This may take a few minutes...
    call npm install
)
echo Starting frontend on http://localhost:3000
start cmd /k "title Frontend Server && npm start"
cd ..

echo.
echo ========================================
echo Application is starting!
echo ========================================
echo.
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:3000
echo Database: PostgreSQL on localhost:5432
echo.
echo Press any key to stop all services...
pause >nul

echo.
echo Stopping services...
docker-compose down
taskkill /FI "WindowTitle eq Backend Server*" /F >nul 2>&1
taskkill /FI "WindowTitle eq Frontend Server*" /F >nul 2>&1
echo All services stopped.
pause
