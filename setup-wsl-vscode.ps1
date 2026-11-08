<#
.SYNOPSIS
  Idempotent Windows 11 WSL + Ubuntu + VS Code + C toolchain installer.
.AUTHOR
  Jad Matar | jadmatar.dev@gmail.com
.SOURCE
  https://github.com/jadmatar628-web/wsl-vscode-dev-setup
#>
$ErrorActionPreference = 'Stop'
$repoUrl = 'https://github.com/jadmatar628-web/wsl-vscode-dev-setup'
Write-Host '================================================' -ForegroundColor Cyan
Write-Host 'WSL + VS Code Developer Setup' -ForegroundColor Cyan
Write-Host 'Created by Jad Matar'
Write-Host 'Contact: jadmatar.dev@gmail.com'
Write-Host "Source: $repoUrl"
Write-Host 'Copyright (c) 2026 Jad Matar'
Write-Host '================================================' -ForegroundColor Cyan
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host 'Requesting administrator permission...' -ForegroundColor Yellow
    $argLine = '-NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '"'
    Start-Process powershell.exe -ArgumentList $argLine -Verb RunAs -Wait
    exit
}
function Require-Success([string]$step) {
    if ($LASTEXITCODE -ne 0) { throw "$step failed (exit code $LASTEXITCODE)." }
}
function Get-Distros {
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { $result = (& wsl.exe --list --quiet 2>$null | Out-String) }
    finally { $ErrorActionPreference = $old }
    return $result.Replace([string][char]0, '')
}
function Find-Code {
    $paths = @(
        (Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\bin\code.cmd'),
        (Join-Path $env:ProgramFiles 'Microsoft VS Code\bin\code.cmd')
    )
    $x86 = [Environment]::GetEnvironmentVariable('ProgramFiles(x86)')
    if ($x86) { $paths += (Join-Path $x86 'Microsoft VS Code\bin\code.cmd') }
    foreach ($p in $paths) { if (Test-Path -LiteralPath $p) { return $p } }
    $cmd = Get-Command code.cmd -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}
if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
    throw 'winget is missing. Install Microsoft App Installer, then rerun.'
}
Write-Host '[1/5] WSL and Ubuntu...' -ForegroundColor Cyan
$distros = Get-Distros
if ($distros -match '(?im)^\s*Ubuntu-24\.04\s*$') {
    $distro = 'Ubuntu-24.04'
    Write-Host 'Ubuntu 24.04 already installed: skipping.'
} elseif ($distros -match '(?im)^\s*Ubuntu\s*$') {
    $distro = 'Ubuntu'
    Write-Host 'Existing Ubuntu found: reusing it.'
} else {
    $distro = 'Ubuntu-24.04'
    & wsl.exe --install --distribution $distro --no-launch
    Require-Success 'WSL installation'
    if ((Get-Distros) -notmatch '(?im)^\s*Ubuntu-24\.04\s*$') {
        Write-Host 'Restart Windows, then rerun bootstrap.cmd.' -ForegroundColor Yellow
        exit 3010
    }
}
Write-Host '[2/5] VS Code...' -ForegroundColor Cyan
$codeCli = Find-Code
if (-not $codeCli) {
    & winget.exe install --id Microsoft.VisualStudioCode --exact --source winget --accept-source-agreements --accept-package-agreements --silent
    Require-Success 'VS Code installation'
    $codeCli = Find-Code
    if (-not $codeCli) { throw 'VS Code CLI not found. Restart the terminal and rerun bootstrap.cmd.' }
} else { Write-Host 'VS Code already installed: skipping.' }
Write-Host '[3/5] WSL extension...' -ForegroundColor Cyan
$ext = (& $codeCli --list-extensions | Out-String)
Require-Success 'Extension inventory'
if ($ext -notmatch '(?im)^\s*ms-vscode-remote\.remote-wsl\s*$') {
    & $codeCli --install-extension ms-vscode-remote.remote-wsl
    Require-Success 'WSL extension installation'
} else { Write-Host 'WSL extension already installed: skipping.' }
Write-Host '[4/5] Ubuntu initialization and Linux tools...' -ForegroundColor Cyan
Write-Host 'If prompted, create Ubuntu credentials and then type exit.' -ForegroundColor Yellow
& wsl.exe -d $distro
if ($LASTEXITCODE -ne 0) { throw 'Ubuntu failed to launch. Restart Windows if required, then rerun bootstrap.cmd.' }
$linuxSetup = 'missing=""; for pkg in build-essential gdb git wget ca-certificates; do dpkg-query -W -f="${Status}" "$pkg" 2>/dev/null | grep -q "install ok installed" || missing="$missing $pkg"; done; if [ -n "$missing" ]; then apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $missing; else echo "Linux packages already present: skipping."; fi'
& wsl.exe -d $distro -u root -- bash -lc $linuxSetup
Require-Success 'Linux tool installation'
& wsl.exe -d $distro -- bash -lc 'mkdir -p "$HOME/projects" && gcc --version | head -n 1 && gdb --version | head -n 1 && make --version | head -n 1'
Require-Success 'Linux tool verification'
Write-Host '[5/5] Remote C/C++ extension...' -ForegroundColor Cyan
& $codeCli --remote ("wsl+" + $distro) --install-extension ms-vscode.cpptools
if ($LASTEXITCODE -ne 0) {
    Write-Warning 'Remote C/C++ extension not ready. Open a WSL-connected VS Code window and install ms-vscode.cpptools.'
}
Write-Host 'Setup complete. Open Ubuntu and run: cd ~/projects && code .' -ForegroundColor Green
Write-Host "Source: $repoUrl"
Write-Host 'Created by Jad Matar | jadmatar.dev@gmail.com'
