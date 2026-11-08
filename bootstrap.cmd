@echo off
setlocal EnableExtensions
rem WSL + VS Code Developer Setup bootstrapper
rem Jad Matar | jadmatar.dev@gmail.com
rem https://github.com/jadmatar628-web/wsl-vscode-dev-setup

set "REPO_URL=https://github.com/jadmatar628-web/wsl-vscode-dev-setup.git"
set "CHECKOUT=%USERPROFILE%\wsl-vscode-dev-setup"
set "GIT_EXE="

echo.
echo ===============================================
echo WSL + VS Code Developer Setup
echo Created by Jad Matar
echo Contact: jadmatar.dev@gmail.com
echo Source: https://github.com/jadmatar628-web/wsl-vscode-dev-setup
echo ===============================================
echo.

where git.exe >nul 2>&1
if not errorlevel 1 set "GIT_EXE=git.exe"
if not defined GIT_EXE if exist "%ProgramFiles%\Git\cmd\git.exe" set "GIT_EXE=%ProgramFiles%\Git\cmd\git.exe"
if not defined GIT_EXE if exist "%LOCALAPPDATA%\Programs\Git\cmd\git.exe" set "GIT_EXE=%LOCALAPPDATA%\Programs\Git\cmd\git.exe"

if not defined GIT_EXE (
    where winget.exe >nul 2>&1
    if errorlevel 1 (
        echo ERROR: Neither Git nor winget is available. Install Microsoft App Installer first.
        exit /b 1
    )
    echo Git was not found. Installing Git for Windows...
    winget install --id Git.Git --exact --source winget --accept-source-agreements --accept-package-agreements
    if errorlevel 1 (
        echo ERROR: Could not install Git.
        exit /b 1
    )
    if exist "%ProgramFiles%\Git\cmd\git.exe" set "GIT_EXE=%ProgramFiles%\Git\cmd\git.exe"
    if not defined GIT_EXE if exist "%LOCALAPPDATA%\Programs\Git\cmd\git.exe" set "GIT_EXE=%LOCALAPPDATA%\Programs\Git\cmd\git.exe"
    if not defined GIT_EXE (
        echo Git installed, but its executable is not yet in PATH. Open a new CMD and retry.
        exit /b 1
    )
)

if exist "%CHECKOUT%\.git" (
    echo Using existing repository at "%CHECKOUT%".
    "%GIT_EXE%" -C "%CHECKOUT%" pull --ff-only
    if errorlevel 1 (
        echo ERROR: Could not fast-forward the local clone. Resolve local changes and retry.
        exit /b 1
    )
) else (
    if exist "%CHECKOUT%" (
        echo ERROR: "%CHECKOUT%" exists but is not a Git repository.
        exit /b 1
    )
    echo Cloning repository into "%CHECKOUT%"...
    "%GIT_EXE%" clone "%REPO_URL%" "%CHECKOUT%"
    if errorlevel 1 (
        echo ERROR: Clone failed.
        exit /b 1
    )
)

if not exist "%CHECKOUT%\setup-wsl-vscode.ps1" (
    echo ERROR: setup-wsl-vscode.ps1 is missing from the clone.
    exit /b 1
)

echo Launching the environment setup...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%CHECKOUT%\setup-wsl-vscode.ps1"
exit /b %ERRORLEVEL%
