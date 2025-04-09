@echo off

REM Stop old server (optional)
taskkill /IM node.exe /F

REM Start Backend
cd backend
start /B cmd /C "npm start"

REM Serve Frontend build (optional)
cd ../frontend
start /B cmd /C "npx serve -s build -l 3000"

echo Deployment completed!
