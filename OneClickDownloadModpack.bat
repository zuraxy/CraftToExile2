@echo off
setlocal EnableExtensions EnableDelayedExpansion

title CraftToExile2 - One Click Installer

echo ================================================
echo   CraftToExile2 - One Click Installer
echo ================================================
echo.

set "PACK_NAME=CraftToExile2"
set "SOURCE_DIR=%~dp0CraftToExile2"
set "MODS_DIR=%SOURCE_DIR%\mods"
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

if not exist "%MODS_DIR%" (
	echo [ERROR] Mods folder not found:
	echo         "%MODS_DIR%"
	pause
	exit /b 1
)

set /a JAR_COUNT=0
set /a SMALL_JAR_COUNT=0
set /a LFS_POINTER_COUNT=0
set "FIRST_BAD_JAR="

for %%F in ("%MODS_DIR%\*.jar") do (
	set /a JAR_COUNT+=1
	if %%~zF LSS 2048 (
		set /a SMALL_JAR_COUNT+=1
		if not defined FIRST_BAD_JAR set "FIRST_BAD_JAR=%%~nxF"
		findstr /B /C:"version https://git-lfs.github.com/spec/v1" "%%~fF" >nul 2>&1
		if !ERRORLEVEL! EQU 0 set /a LFS_POINTER_COUNT+=1
	)
)

if !JAR_COUNT! EQU 0 (
	echo [ERROR] No mod JAR files found in:
	echo         "%MODS_DIR%"
	echo [ERROR] This source folder is incomplete.
	pause
	exit /b 1
)

if !SMALL_JAR_COUNT! GTR 0 (
	echo [ERROR] Detected !SMALL_JAR_COUNT! suspiciously small mod JAR file(s).
	if defined FIRST_BAD_JAR (
		echo         Example: "!FIRST_BAD_JAR!"
	)
	echo.
	if !LFS_POINTER_COUNT! GTR 0 (
		echo [ERROR] These appear to be Git LFS pointer files, not real mods.
		echo         Fix by hydrating LFS files in the repo root:
		echo           git lfs install
		echo           git lfs pull
		echo.
		echo [ERROR] If you downloaded "Code ^> Download ZIP" from GitHub,
		echo         use a Release asset instead, or clone with Git LFS.
	) else (
		echo [ERROR] Source files look corrupted or incomplete.
	)
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
