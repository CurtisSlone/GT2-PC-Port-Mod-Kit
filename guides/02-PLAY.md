# 2. Play

## Start UGT2R

| Windows | Linux |
|---|---|
| Double-click `UGT2R.exe` in the port folder. | Double-click `UGT2R-x86_64.AppImage`, or run `./UGT2R-x86_64.AppImage` in a terminal in the port folder. |

No flags are needed: the built-in settings are our test setup (guides/13-FLAGS-AND-SETTINGS.md lists each one).
The window opens at 5 times 320x240 (1600x1200). On a smaller screen, resize it or start with `--scale 3`
(guide 13 shows how to make a shortcut for that).

UGT2R keeps a console window (Windows) or prints into the terminal (Linux). It shows what the game is doing,
which mods are on, and any error. Leave it open.

**The first starts are slower in races.** Tracks and cars are converted for the remaster look the first time they
are used, unless the installer already prepared them. While that runs in the background the window title shows
"warming N/M".

## Controls

Keyboard (pad in port 1):

| PlayStation | Keyboard |
|---|---|
| D-pad | Arrow keys |
| Cross / Circle / Square / Triangle | X / Z / S / A |
| L1 / R1 / L2 / R2 | Q / W / E / R |
| Start / Select | Enter / Right Shift |
| ANALOG button (DualShock mode on or off) | M |

Gamepads: face buttons by position (bottom = Cross, right = Circle, left = Square, top = Triangle), d-pad or left
stick, LB/RB = L1/R1, LT/RT = L2/R2, Start, Select (Back). The pad is a **DualShock with analog mode on**: the left
stick steers with GT2's analog steering. M on the keyboard, or Select+R3 on the gamepad, switches analog mode.
Two gamepads: the first is player 1, the second player 2; Y on the keyboard swaps them. The keyboard always drives
player 1.

Windows reads gamepads through XInput (Xbox-type pads; PS4 and PS5 pads through Steam Input or DS4Windows). Linux
reads them through evdev; **gamepads on Linux are untested** in this release.

While playing:

| Key | What it does |
|---|---|
| F12 | screenshot (PNG into `shots`) |
| P | pause / resume |
| Tab (hold) | fast-forward |
| F9 | stop the game and write a bug report (below) |
| F10 | debug panel on / off (F11 next page, Left Shift+F11 previous) |
| T | Track Select: every course as a Test Run with the current car (gamepad: Select+L1+R1) |
| F1 | remaster look (native scene) on / off |
| Left Shift+F1 / Left Ctrl+F1 / Left Alt+F1 | scene detail / effects / textures (upscaled or original) |
| Left Ctrl+Left Shift+F1 | object reach, modern / game |
| V | 3D trees and bushes on / off |
| H | GT2's text and HUD drawn sharp, or GT2's own sprites |
| J | anti-aliasing: off, FXAA, SMAA, 4x MSAA, 4x MSAA + SMAA, 2x supersampling |
| I | render interpolation on / off (smooth motion between GT2's game ticks) |
| F3 | widescreen: off, 16:9, 16:10, 21:9, the window's shape |
| F4 / F5 / F6 / F7 / F8 | perspective-correct textures / sub-pixel vertices / dither / internal resolution / GPU or software renderer |
| F2 | debug teleport (type map X Y, Enter; Esc cancels); Page Down / Page Up: next / previous door |

Pressing F1, H, F3, F7, F8 or resizing the window during a race is fine for playing. For a recording you want to
send us, leave them alone: a replay of the recording starts from the settings the session started with.

## Saves

The game saves to **`cards/card1.mcr`**, a standard 128 KB PlayStation memory card image. It works with
DuckStation and ePSXe, so you can bring your own card: copy it over `cards/card1.mcr`.

Beside the card, UGT2R keeps:

* `card1.mcr.ghosts.gt2drive`: the time-trial ghosts, recorded as car poses;
* `card1.mcr.replays.gt2pose`: the poses of saved replays (a replay of a modern-physics race plays from them);
* `card1.mcr.mods.json`: which mods were on when you saved (guides/03-MODS.md).

Keep them with the card when you copy it.

**Card backups are off by default** in this release. To have a dated copy of the card written to `cards-backup`
before the first save of each session, start with `--card-backups cards-backup` (guide 13). Or copy
`cards/card1.mcr` yourself now and then.

Play mods that add cars or courses on a separate card (guides/03-MODS.md explains why):
`--card1 cards/modded.mcr`. A card file that does not exist is created formatted.

## Screenshots, recordings and logs

Everything goes into **`shots`** in the port folder:

| File | What it is |
|---|---|
| `psx-play-field*.png` | F12 screenshots (the file names keep our developer name) |
| `record-DATE-TIME.log` + `record-DATE-TIME.log.card1.mcd` | every session's input (both pads, per field) and card 1 as it was at the start. We replay these to see exactly what you saw |
| `gt2-debug-*.log` | the game's debug log for the session (physics watch included) |
| `hitch.log` | a line for every slow picture |
| `psx-play-report-fieldNNNNNN.txt` | the report F9 writes |

These are for bug reports. They grow by a few MB per session; delete old ones whenever you like. To stop writing
them: `--record off --debug-log off --watch off` (guide 13).

## Reporting a bug

1. When something goes wrong, press **F9**. The game stops where it is and writes
   `shots/psx-play-report-fieldNNNNNN.txt`. The window stays open; close it when you are done.
2. Send us that report, the newest `shots/record-*.log` with its `.card1.mcd`, and the newest
   `shots/gt2-debug-*.log`. Say what you did and what you expected.
3. If the game hangs (the picture stands still for 10 seconds), it writes the same report by itself.

The recording holds only your button presses and your memory card. No game data.

## Mods and the disc lock

Mods in `mods` load at every start (guides/03-MODS.md). `data` itself is never changed, and the disc lock checks it
at every start (guides/01-INSTALL.md). To play without mods once: `--mods none`.
