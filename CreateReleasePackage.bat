@echo off
setlocal EnableExtensions

title CraftToExile2 - Create Release Package

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0CreateReleasePackage.ps1"
if errorlevel 1 (
	echo.
	echo [ERROR] Release packaging failed.
	pause
	exit /b 1
)

echo.
echo [SUCCESS] Release package is ready in the release folder.
pause
exit /b 0