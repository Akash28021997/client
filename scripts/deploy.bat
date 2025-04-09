@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

echo ===================================================
echo 🚀 Starting Deployment...
echo ===================================================

REM Kill any existing node processes (optional safety)
echo 🔪 Killing any old node servers...
taskkill /F /IM node.exe >nul 2>&1

REM Start Backend
echo 🔧 Starting Backend...
cd backend
IF EXIST node_modules (
    echo ✅ Dependencies exist
) ELSE (
    echo 📦 Installing backend dependencies...
    npm install
)
start /B cmd /C "npm start"
cd ..

REM Serve Frontend build
echo 🌐 Serving Frontend...
cd frontend
IF EXIST node_modules (
    echo ✅ Frontend dependencies exist
) ELSE (
    echo 📦 Installing frontend dependencies...
    npm install
)
IF EXIST build (
    echo 🏗️ Build folder found
) ELSE (
    echo ❌ Build folder not found. Run 'npm run build' in Jenkins before deploy.
    exit /b 1
)

REM Install 'serve' globally only if not present
where serve >nul 2>&1
IF ERRORLEVEL 1 (
    echo 📦 Installing 'serve' package...
    npm install -g serve
)

start /B cmd /C "serve -s build -l 3000"

cd ..
echo ===================================================
echo ✅ Deployment completed! React app on http://localhost:3000
echo ===================================================
