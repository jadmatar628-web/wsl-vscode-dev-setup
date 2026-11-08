<#
.SYNOPSIS
  Windows 11 WSL 2, Ubuntu 24.04, VS Code and C toolchain setup.
.AUTHOR
  Jad Matar
.CONTACT
  jadmatar.dev@gmail.com
.SOURCE
  https://github.com/jadmatar628-web/wsl-vscode-dev-setup
#>
$ErrorActionPreference = 'Stop'
$RepoUrl = 'https://github.com/jadmatar628-web/wsl-vscode-dev-setup'
Write-Host '================================================' -ForegroundColor Cyan
Write-Host 'WSL + VS Code Developer Setup' -ForegroundColor Cyan
Write-Host 'Created by Jad Matar' -ForegroundColor White
Write-Host 'Contact: jadmatar.dev@gmail.com' -ForegroundColor White
Write-Host "Source: $RepoUrl" -ForegroundColor White
Write-Host 'Copyright (c) 2026 Jad Matar' -ForegroundColor DarkGray
Write-Host '================================================' -ForegroundColor Cyan
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run this installer as Administrator.'
}
function Assert-Success([string]$Step) {
    if ($LASTEXITCODE -ne 0) { throw "$Step failed (exit code $LASTEXITCODE)." }
}
if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
    throw 'winget not found. Install Microsoft App Installer, then retry.'
}
Write-Host '[1/4] Checking WSL and Ubuntu...' -ForegroundColor Cyan
$old = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try { $distros = @(& wsl.exe --list --quiet 2>$null) -join [Environment]::NewLine }
finally { $ErrorActionPreference = $old }
$distros = $distros.Replace([string][char]0, '')
if ($distros -match '(?m)^\s*Ubuntu-24\.04\s*$') { $Distro = 'Ubuntu-24.04' }
elseif ($distros -match '(?m)^\s*Ubuntu\s*$') { $Distro = 'Ubuntu' }
else {
    $Distro = 'Ubuntu-24.04'
    & wsl.exe --install -d $Distro --no-launch
    Assert-Success 'WSL/Ubuntu installation'
}
Write-Host '[2/4] Checking VS Code...' -ForegroundColor Cyan
$old = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try { $installed = (& winget.exe list --id Microsoft.VisualStudioCode --exact --accept-source-agreements 2>$null | Out-String) }
finally { $ErrorActionPreference = $old }
if ($installed -notmatch 'Microsoft\.VisualStudioCode') {
    & winget.exe install --id Microsoft.VisualStudioCode --exact --source winget --accept-source-agreements --accept-package-agreements --silent
    Assert-Success 'VS Code installation'
}
$codePaths = @(
    "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd",
    "$env:ProgramFiles\Microsoft VS Code\bin\code.cmd"
)
$programFilesX86 = [Environment]::GetEnvironmentVariable('ProgramFiles(x86)')
if ($programFilesX86) { $codePaths += (Join-Path $programFilesX86 'Microsoft VS Code\bin\code.cmd') }
$codeCli = $codePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $codeCli) {
    $cmd = Get-Command code.cmd -ErrorAction SilentlyContinue
    if ($cmd) { $codeCli = $cmd.Source }
}
if (-not $codeCli) { throw 'VS Code code.cmd not found. Restart PowerShell and rerun this installer.' }
Write-Host '[3/4] Installing VS Code WSL extension...' -ForegroundColor Cyan
& $codeCli --install-extension ms-vscode-remote.remote-wsl --force
Assert-Success 'WSL extension installation'
Write-Host '[4/4] Initializing Ubuntu...' -ForegroundColor Cyan
Write-Host 'Create a Linux username/password if prompted; then type exit.' -ForegroundColor Yellow
& wsl.exe -d $Distro
if ($LASTEXITCODE -ne 0) {
    Write-Host 'Restart Windows if requested, then rerun this installer.' -ForegroundColor Yellow
    exit 1
}
Write-Host 'Installing GCC, GDB, Make and Git inside Ubuntu...' -ForegroundColor Cyan
& wsl.exe -d $Distro -u root -- bash -lc 'apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential gdb git wget ca-certificates'
Assert-Success 'Ubuntu development tools installation'
& wsl.exe -d $Distro -- bash -lc 'mkdir -p "$HOME/projects" && gcc --version | head -n 1 && gdb --version | head -n 1'
Assert-Success 'Development tools verification'
Write-Host 'DONE: WSL + Ubuntu + VS Code + C tools are installed!' -ForegroundColor Green
Write-Host 'Open Ubuntu and run: cd ~/projects && code .'
Write-Host 'Install the Microsoft C/C++ extension inside WSL-connected VS Code for debugging.'
Write-Host 'Created by Jad Matar | jadmatar.dev@gmail.com' -ForegroundColor DarkGray
Write-Host "Source: $RepoUrl" -ForegroundColor DarkGray
