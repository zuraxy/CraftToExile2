@echo off
setlocal EnableExtensions

title CraftToExile2 - One Click Installer

echo ================================================
echo   CraftToExile2 - One Click Installer
echo ================================================
echo.

set "PACK_NAME=CraftToExile2"
set "SOURCE_DIR=%~dp0CraftToExile2"
set "MINECRAFT_DIR=%APPDATA%\.minecraft"
set "VERSIONS_DIR=%MINECRAFT_DIR%\versions"
set "TARGET_DIR=%VERSIONS_DIR%\%PACK_NAME%"

if "%APPDATA%"=="" (
	echo [ERROR] APPDATA is not available in this session.
	pause
	exit /b 1
)

if not exist "%SOURCE_DIR%" (
	echo [ERROR] Source modpack folder not found:
	echo         "%SOURCE_DIR%"
	echo [ERROR] Make sure this BAT file is in the repository root,
	echo         with the CraftToExile2 folder next to it.
	pause
	exit /b 1
)

if not exist "%MINECRAFT_DIR%" (
	echo [INFO] Minecraft directory not found. Creating it now:
	echo        "%MINECRAFT_DIR%"
	mkdir "%MINECRAFT_DIR%" >nul 2>&1
)

if not exist "%VERSIONS_DIR%" (
	mkdir "%VERSIONS_DIR%" >nul 2>&1
)

echo [INFO] Source folder:
echo        "%SOURCE_DIR%"
echo [INFO] Destination folder:
echo        "%TARGET_DIR%"
echo.

if exist "%TARGET_DIR%" (
	echo [INFO] Existing install detected. Removing old folder...
	rmdir /s /q "%TARGET_DIR%"
	if exist "%TARGET_DIR%" (
		echo [ERROR] Could not remove existing target folder.
		echo         Close Minecraft/SKLauncher and try again.
		pause
		exit /b 1
	)
)

mkdir "%TARGET_DIR%" >nul 2>&1
if not exist "%TARGET_DIR%" (
	echo [ERROR] Could not create destination folder.
	pause
	exit /b 1
)

echo [INFO] Copying modpack files...

robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /R:2 /W:1 /NFL /NDL /NP /NJH /NJS ^
	/XD ".git" ".github" ^
	/XF "OneClickDownloadModpack.bat"

set "ROBO_EXIT=%ERRORLEVEL%"

if %ROBO_EXIT% GEQ 8 (
	echo.
	echo [ERROR] Copy failed with robocopy exit code %ROBO_EXIT%.
	echo         Please verify folder permissions and try again.
	pause
	exit /b %ROBO_EXIT%
)

echo.
echo [SUCCESS] Installation complete.
echo [SUCCESS] Modpack installed to:
echo           "%TARGET_DIR%"
echo.
echo You can now launch SKLauncher and select:
echo "%PACK_NAME%"
echo.
pause
exit /b 0
