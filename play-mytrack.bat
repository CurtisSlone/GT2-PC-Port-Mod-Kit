@echo off
rem Play the track built in Blender (GT2 tab > Build track for GT2): every race runs on course zz_mytrack.
rem The mod MyTrack must be on in mods\load-order.txt (the add-on does that). Use a separate card for it:
rem saves made with an added course need its mod (guides\02-MODS.md).
call "%~dp0play-gt2.bat" --course zz_mytrack --card1 "%~dp0cards\mytrack.mcr" %*
