@echo off
rem GT2 PC Port: play Gran Turismo 2 from data\ (run install-gt2.bat once first).
rem No BIOS file is needed: --hle uses the runtime's own replacement.
rem Saves: cards\card1.mcr (a backup of the card goes to cards-backup\ before the first save of a session).
rem Mods: folders in mods\ listed in mods\load-order.txt; add --mods none to play without any.
rem Extra options can be added after the file name, e.g.  play-gt2.bat --widescreen off
cd /d "%~dp0"
psx-play.exe --hle --data "%~dp0data" --modules "%~dp0modules" --card1 "%~dp0cards\card1.mcr" --shots "%~dp0shots" %*
if errorlevel 1 pause
