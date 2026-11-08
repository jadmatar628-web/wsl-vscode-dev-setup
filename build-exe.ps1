# Build branded Windows EXE using PS2EXE
# Author: Jad Matar | jadmatar.dev@gmail.com
# Source: https://github.com/jadmatar628-web/wsl-vscode-dev-setup
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
if (-not (Test-Path '.\setup-wsl-vscode.ps1')) { throw 'Installer source is missing.' }
if (-not (Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue)) {
    Install-Module -Name ps2exe -Scope CurrentUser -Force -AllowClobber
    Import-Module ps2exe
}
$options = @{
    inputFile = '.\setup-wsl-vscode.ps1'
    outputFile = '.\WSL-Installer.exe'
    requireAdmin = $true
    x64 = $true
    title = 'WSL + VS Code Developer Setup'
    product = 'WSL Development Environment Installer'
    company = 'Jad Matar'
    description = 'WSL 2, Ubuntu, VS Code and C tools | Jad Matar | jadmatar.dev@gmail.com'
    copyright = 'Copyright (c) 2026 Jad Matar'
    version = '1.0.0.0'
}
Invoke-ps2exe @options
Write-Host 'Created: WSL-Installer.exe'
Write-Host 'Source: https://github.com/jadmatar628-web/wsl-vscode-dev-setup'
