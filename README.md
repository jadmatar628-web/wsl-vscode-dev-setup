# WSL + VS Code Developer Setup

A Windows 11 PowerShell installer that configures a Linux-based C development environment for Visual Studio Code.

**Author:** Jad Matar  
**Contact:** [jadmatar.dev@gmail.com](mailto:jadmatar.dev@gmail.com)  
**Repository:** https://github.com/jadmatar628-web/wsl-vscode-dev-setup

## What it installs

- WSL 2 and Ubuntu 24.04 (or uses an existing Ubuntu installation)
- Visual Studio Code
- Microsoft's VS Code **WSL** extension (`ms-vscode-remote.remote-wsl`)
- Linux development tools: GCC, GDB, Make, Git, and related build essentials
- `~/projects` directory inside Ubuntu

## Requirements

- Windows 11 with administrator access
- Internet connection
- Windows Package Manager (`winget`)
- Hardware virtualization enabled (if required by your system)
- Enough free space for Ubuntu and development tools

## Run the installer

1. Download [`setup-wsl-vscode.ps1`](./setup-wsl-vscode.ps1).
2. Open **Windows PowerShell as Administrator** in its folder.
3. Run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\setup-wsl-vscode.ps1
   ```

4. If Windows requests a restart, restart and **run the same script again**.
5. When Ubuntu opens for the first time, create your Linux username and password if prompted, then enter `exit` to return to the installer.
6. After installation, launch Ubuntu and run:

   ```bash
   cd ~/projects && code .
   ```

7. In your WSL-connected VS Code window, install the Microsoft **C/C++** extension (`ms-vscode.cpptools`) for C debugging.

The script may need multiple runs to finish a first-time WSL installation across Windows restarts. It checks for existing components and does not deliberately delete WSL distributions or project files.

## Verify

Inside the Ubuntu / WSL terminal:

```bash
uname -a
gcc --version
gdb --version
make --version
```

## Build the Windows EXE

On Windows, from the repository directory, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-exe.ps1
```

This creates `WSL-Installer.exe` using the community PS2EXE PowerShell module. It embeds the PowerShell script; it **does not** bundle Ubuntu, WSL, VS Code, or their downloads. An internet connection is still required.

The executable is **not code-signed**. Windows may show a SmartScreen warning, and its author metadata is not proof of cryptographic identity. Only distribute builds you have reviewed and tested.

## Source and attribution

This project is maintained by **Jad Matar**. For feedback or questions, contact **jadmatar.dev@gmail.com**. The PowerShell header, terminal banner, and EXE metadata carry source and attribution details.

Copyright © 2026 Jad Matar. All rights reserved. **No open-source license has been granted.** Public visibility of source code does not, by itself, grant redistribution or modification rights.
