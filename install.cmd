@echo off
setlocal enableDelayedExpansion

rem installer for claude oracle on windows
rem ensure 'oracle.py', 'schemas.py', and 'fullauto.md' are in the same directory as this script.

set "ORACLE_INSTALL_DIR=%USERPROFILE%\.oracle"
set "CLAUDE_COMMANDS_DIR=%USERPROFILE%\.claude\commands"
set "OAUTH_DIR=%ORACLE_INSTALL_DIR%\oauth"

echo Installing Claude Oracle...

rem check for python 3.8+
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: python is required but not found in path.
    echo please install python 3.8+ from python.org.
    goto :error_exit
)

for /f "tokens=*" %%i in ('python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"') do (
    set PYTHON_VERSION=%%i
)
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VERSION%") do (
    set PYTHON_MAJOR=%%a
    set PYTHON_MINOR=%%b
)

if %PYTHON_MAJOR% lss 3 (
    echo Error: python 3.8+ is required. found python %PYTHON_VERSION%
    goto :error_exit
)
if %PYTHON_MAJOR% equ 3 if %PYTHON_MINOR% lss 8 (
    echo Error: python 3.8+ is required. found python %PYTHON_VERSION%
    goto :error_exit
)
echo Python %PYTHON_VERSION% detected

rem create installation directory
if not exist "%ORACLE_INSTALL_DIR%" (
    echo Creating installation directory: %ORACLE_INSTALL_DIR%
    mkdir "%ORACLE_INSTALL_DIR%"
)

rem copy files
echo Copying core files...
if not exist "oracle.py" (
    echo Error: 'oracle.py' not found. place it next to this script.
    goto :error_exit
)
copy /Y "oracle.py" "%ORACLE_INSTALL_DIR%\oracle.py" >nul

if not exist "schemas.py" (
    echo Error: 'schemas.py' not found. place it next to this script.
    goto :error_exit
)
copy /Y "schemas.py" "%ORACLE_INSTALL_DIR%\schemas.py" >nul

rem create oracle.cmd launcher
echo Creating 'oracle.cmd' launcher...
echo @echo off > "%ORACLE_INSTALL_DIR%\oracle.cmd"
echo "%ORACLE_INSTALL_DIR%\venv\Scripts\python.exe" ^
"%ORACLE_INSTALL_DIR%\oracle.py" %%* >> "%ORACLE_INSTALL_DIR%\oracle.cmd"

rem create virtual environment
echo Creating virtual environment...
python -m venv "%ORACLE_INSTALL_DIR%\venv"
if %errorlevel% neq 0 (
    echo Failed to create virtual environment.
    goto :error_exit
)

rem install dependencies
echo Installing dependencies...
"%ORACLE_INSTALL_DIR%\venv\Scripts\pip.exe" install -q --upgrade pip
if %errorlevel% neq 0 (echo Failed to upgrade pip. && goto :error_exit)
"%ORACLE_INSTALL_DIR%\venv\Scripts\pip.exe" ^
install -q google-genai requests Pillow google-auth-oauthlib ^
google-auth-httplib2
if %errorlevel% neq 0 (
    echo Failed to install dependencies.
    goto :error_exit
)

rem add to path
echo Adding "%ORACLE_INSTALL_DIR%" to user path...
echo !PATH! | findstr /i "%ORACLE_INSTALL_DIR:\=\\%" >nul
if %errorlevel% equ 0 (
    echo Path already configured.
) else (
    setx PATH "%PATH%;%ORACLE_INSTALL_DIR%" >nul
    if %errorlevel% neq 0 (echo Failed to update path. && goto :error_exit)
    echo Added "%ORACLE_INSTALL_DIR%" to user path.
)

rem create oauth directory
echo Creating oauth directory: %OAUTH_DIR%
if not exist "%OAUTH_DIR%" (
    mkdir "%OAUTH_DIR%"
) else (
    echo OAuth directory already exists.
)

rem install claude code command
echo Installing /fullauto command for claude code...
if not exist "%CLAUDE_COMMANDS_DIR%" mkdir "%CLAUDE_COMMANDS_DIR%"
if not exist "fullauto.md" (
    echo 'fullauto.md' not found. skipping claude code command.
) else (
    copy /Y "fullauto.md" "%CLAUDE_COMMANDS_DIR%\fullauto.md" >nul
    if %errorlevel% neq 0 (echo Failed to copy fullauto.md. && goto :error_exit)
    echo Installed /fullauto command for claude code.
)

echo.
echo Installation complete!
echo.
echo Next steps:
echo    1. restart your terminal for path changes.
echo    2. for google account login:
echo       a. go to google cloud console credentials (https://console.cloud.google.com/apis/credentials)
echo       b. create oauth 2.0 client id ^> desktop application.
echo       c. download json, save as: "%OAUTH_DIR%\client_secret.json"
echo       d. run 'oracle login' in your new terminal.
echo    3. alternatively, set api key with:
echo       setx GEMINI_API_KEY "your-key-here"
echo    4. for image generation (geo-restricted regions):
echo       setx VAST_API_KEY "your-vast-key-here"
echo.
echo Usage:
echo    oracle ask "how should i implement x?"
echo    oracle login
echo.
goto :eof

:error_exit
echo.
echo Installation failed. review errors.
echo.
pause
endlocal
exit /b 1