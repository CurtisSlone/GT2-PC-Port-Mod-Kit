@echo off
rem GT2 PC Port mod kit setup. Safe to run again at any time.
rem  - downloads pez2k's GT2 tools (pinned versions, SHA-256 checked) into kit\tools\  (see THIRD-PARTY.md)
rem  - finds Blender 4.2 or newer and installs the GT2 Track Tools add-on into it (never installs Blender)
rem  - checks for the .NET 8 Runtime the car tools need (never installs it)
rem  setup-kit.bat "D:\path\to\blender.exe"   use that Blender
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-kit.ps1" %*
pause
