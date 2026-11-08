# WSL + VS Code Developer Setup

One-command Windows 11 development-environment bootstrap for **WSL 2, Ubuntu, Visual Studio Code, GCC, GDB, Make and Git**.

**Created by Jad Matar** · [jadmatar.dev@gmail.com](mailto:jadmatar.dev@gmail.com)  
Source: https://github.com/jadmatar628-web/wsl-vscode-dev-setup

## One command from CMD

Open **Command Prompt** (CMD) on Windows 11 and paste:

```cmd
curl.exe -fL https://raw.githubusercontent.com/jadmatar628-web/wsl-vscode-dev-setup/main/bootstrap.cmd -o "%TEMP%\wsl-bootstrap.cmd" && call "%TEMP%\wsl-bootstrap.cmd"
```

You can review [bootstrap.cmd](./bootstrap.cmd) before running it. Windows may request administrator permission. **First-time WSL setup can require a restart and creating an Ubuntu username/password.** If a restart is required, rerun the same CMD command (or run `%USERPROFILE%\wsl-vscode-dev-setup\bootstrap.cmd` from the existing clone).

This bootstrap:
1. Checks for Git and installs Git with winget only when missing.
2. Clones this public repository to `%USERPROFILE%\wsl-vscode-dev-setup`, or fast-forwards the existing clone.
3. Runs `setup-wsl-vscode.ps1` with one click-free handoff; PowerShell requests elevation when required.
4. Checks for Ubuntu 24.04 or an existing Ubuntu; installs WSL + Ubuntu only when absent.
5. Checks for VS Code and its WSL extension before installing.
6. In Ubuntu, installs **only missing** packages from `build-essential`, `gdb`, `git`, `wget`, `ca-certificates`. `build-essential` includes GCC and Make.
7. Creates `~/projects` if needed and attempts to install VS Code's C/C++ extension in WSL.

## Alternative: clone manually

If you already have Git:

```cmd
git clone https://github.com/jadmatar628-web/wsl-vscode-dev-setup.git
cd wsl-vscode-dev-setup
bootstrap.cmd
```

If you already have the repository cloned, simply run `bootstrap.cmd` again.

## Usage after setup

In an Ubuntu terminal:

```bash
cd ~/projects
code .
```

Verify your Linux tools:

```bash
gcc --version
gdb --version
make --version
```

If the C/C++ extension could not be installed remotely on the first run, open VS Code connected to WSL and install **C/C++** by Microsoft (`ms-vscode.cpptools`) from Extensions.

## What it does not do

- It does **not** overwrite or unregister existing WSL distributions, delete projects, or intentionally reinstall existing tools.
- It does **not** bundle the downloaded software, and requires an internet connection for missing software.
- It does **not** guarantee a zero-interaction setup: Windows administrator consent, a possible reboot, and creating a first Ubuntu account can be required.
- It does **not** guarantee all optional features will install on every Windows configuration; failures need troubleshooting.
- The script is not yet end-to-end tested on a clean Windows 11 machine. Review its source before installing.

## Build an EXE

From the local repository directory in Windows PowerShell, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-exe.ps1
```

The output is `WSL-Installer.exe`. It embeds the PowerShell installer but still downloads missing dependencies from Microsoft and Ubuntu. It is not code-signed and may trigger SmartScreen. The **CMD bootstrap** is the recommended way to clone the repo and run the newest version.

## Attribution

Created by **Jad Matar**  
Contact: **jadmatar.dev@gmail.com**  
Repository: https://github.com/jadmatar628-web/wsl-vscode-dev-setup

Copyright © 2026 Jad Matar. All rights reserved. No license for redistribution or modification has been granted.
