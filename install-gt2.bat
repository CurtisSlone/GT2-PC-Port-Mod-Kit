@echo off
setlocal
rem UGT2R: install Gran Turismo 2 from YOUR OWN disc image into data\, then prepare the tracks and cars.
rem   install-gt2.bat                      pick the .cue file in a window
rem   install-gt2.bat "game.cue"           install from that image (or drag the .cue onto this file)
rem   install-gt2.bat "game.cue" verify    compare an existing install with the disc (and repair it)
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
UGT2R.exe "%CUE%" --install-only
if errorlevel 1 goto failed
if not exist "cards\card1.mcr" copy /y "cards\blank.mcd" "cards\card1.mcr" >nul
goto warm

:verify
echo Checking data\ against: %CUE%
UGT2R.exe "%CUE%" --install-only --verify-data
if errorlevel 1 goto failed
echo The install matches the disc.
goto warm

:warm
echo.
echo Preparing your tracks and cars. This runs once, takes a while and uses several GB in data\scene-cache.
echo You can close this window and play now instead; anything not ready yet is prepared when the game needs it.
echo.
UGT2R.exe --warmup-all
if errorlevel 1 goto warm_failed
echo.
echo Done. Start UGT2R.exe to play. Your saves go to cards\card1.mcr.
pause
exit /b 0

:warm_failed
echo.
echo Preparing the tracks and cars stopped early (see the message above). The game still plays: what is missing
echo is prepared when a race needs it. You can run install-gt2.bat again later to finish it.
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
