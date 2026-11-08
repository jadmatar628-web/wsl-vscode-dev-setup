# Build the installer as an EXE (Windows PowerShell)
# Author: Jad Matar | jadmatar.dev@gmail.com
# Source: https://github.com/jadmatar628-web/wsl-vscode-dev-setup

$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
if (-not (Test-Path '.\setup-wsl-vscode.ps1')) {
    throw 'setup-wsl-vscode.ps1 was not found next to build-exe.ps1.'
}

if (-not (Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue)) {
    Write-Host 'Installing PS2EXE from PowerShell Gallery...' -ForegroundColor Yellow
    Install-Module -Name ps2exe -Scope CurrentUser -Force -AllowClobber
    Import-Module ps2exe
}

Invoke-ps2exe ` `
    -inputFile '.\setup-wsl-vscode.ps1' `
    -outputFile '.\WSL-Installer.exe' `
    -requireAdmin `
    -x64 `
    -title 'WSL + VS Code Developer Setup' `
    -product 'WSL Development Environment Installer' `
    -company 'Jad Matar' `
    -description 'WSL 2, Ubuntu, VS Code and C tools | Jad Matar | jadmatar.dev@gmail.com' `
    -copyright 'Copyright (c) 2026 Jad Matar' `
    -version '1.0.0.0'

Write-Host 'Created: WSL-Installer.exe' -ForegroundColor Green
Write-Host 'Source: https://github.com/jadmatar628-web/wsl-vscode-dev-setup'
