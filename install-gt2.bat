@echo off
setlocal
rem GT2 PC Port: install Gran Turismo 2 from YOUR OWN disc image into data\.
rem   install-gt2.bat                      pick the .cue file in a window
rem   install-gt2.bat "game.cue"           install from that image (or drag the .cue onto this file)
rem   install-gt2.bat "game.cue" verify    compare an existing install with the disc
rem Only Gran Turismo 2 (USA) Simulation Mode v1.0 (SCUS-94488) is accepted; any other disc is refused.
rem The disc is read once; afterwards the game plays from data\ and the image is not needed.
cd /d "%~dp0"
set "CUE=%~1"
if not "%CUE%"=="" goto have_cue
for /f "usebackq delims=" %%F in (`powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.OpenFileDialog; $d.Title = 'Pick your Gran Turismo 2 (USA) Simulation disc image (.cue)'; $d.Filter = 'Disc image (*.cue)|*.cue'; if ($d.ShowDialog() -eq 'OK') { $d.FileName }"`) do set "CUE=%%F"
if "%CUE%"=="" goto no_cue
:have_cue
if not exist "%CUE%" goto missing
if /i "%~2"=="verify" goto verify

echo Installing from: %CUE%
echo.
psx-play.exe "%CUE%" --install-only --data "%~dp0data" --modules "%~dp0modules"
if errorlevel 1 goto failed
if not exist "cards\card1.mcr" copy /y "cards\blank.mcd" "cards\card1.mcr" >nul
echo.
echo Done. Start play-gt2.bat to play. Your saves go to cards\card1.mcr.
pause
exit /b 0

:verify
echo Checking data\ against: %CUE%
psx-play.exe "%CUE%" --install-only --verify-data --data "%~dp0data" --modules "%~dp0modules"
if errorlevel 1 goto failed
echo The install matches the disc.
pause
exit /b 0

:no_cue
echo No disc image picked. Drag your .cue file onto install-gt2.bat, or run: install-gt2.bat "path\to\game.cue"
pause
exit /b 1

:missing
echo Cannot find the file: %CUE%
pause
exit /b 1

:failed
echo.
echo The install did not complete (see the message above). If it says the disc is not known: this release only
echo works with Gran Turismo 2 (USA) Simulation Mode v1.0, SCUS-94488, dumped from your own disc.
pause
exit /b 1
