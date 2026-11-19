# 2. Play

## Start UGT2R

| Windows | Linux | macOS |
|---|---|---|
| Double-click `UGT2R.exe` in the port folder. | Double-click `UGT2R-x86_64.AppImage`, or run `./UGT2R-x86_64.AppImage` in a terminal in the port folder. | Double-click `UGT2R` (after the one-time step of guides/01-INSTALL.md). From Terminal: `./UGT2R.app/Contents/MacOS/UGT2R`. |

No flags are needed. The release starts with its own settings (the table under "Port Options" below), and you change
them in the game: title screen > **Options** > **Port Options**. guides/13-FLAGS-AND-SETTINGS.md lists every
setting and flag.

UGT2R keeps a console window (Windows) or prints into the terminal (Linux, macOS). It shows what the game is doing,
which mods are on, and any error. Leave it open.

**Some first races are slower to start.** The installer prepared the 30 main tracks and every car. The 2-player,
reverse, license and test versions of the tracks are prepared the first time you race on them, and so is anything
the installer did not finish. While that runs in the background the window title shows "warming N/M".

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
reads them through evdev; **gamepads on Linux and on macOS are untested** in this release.

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

The keys change a setting for this session only. The Port Options page (below) saves it.

Pressing F1, H, F3, F7, F8 or resizing the window during a race is fine for playing. For a recording you want to
send us, leave them alone: a replay of the recording starts from the settings the session started with.

## Port Options

Title screen > **Options**, then **Left** / **Right** to the page **PORT OPTIONS** (one page past GLOBAL OPTIONS).
**Cross** enters it, **Up** / **Down** move, **Left** / **Right** (or Cross) change the value, **Triangle** leaves.
The line under the rows says when a change takes effect: at once, at the next race, or at the next start. Every
change is saved at once in `saves/options.txt`.

What a new install starts with:

| Section | Row | Release setting | Other values |
|---|---|---|---|
| GRAPHICS | V-Sync | Adaptive | On, Off, VRR |
| | Resolution | 4x | Auto, 1x to 8x (F7) |
| | Aspect ratio | 4:3 | 16:9, 16:10, 21:9, Fit window (F3) |
| | FPS counter | On | Off |
| | Remaster look | On | Off (F1) |
| | Textures | **Original (smooth)** | Original (sharp), **Upscaled** (below) |
| | Anti-aliasing | MSAA 4x + SMAA | Off, FXAA, SMAA, MSAA 4x, SSAA 2x (J) |
| | Smooth motion | Off | On (I) |
| | Track detail | Curves | Dense, Original (GT2's polygons) |
| | Effects | every effect but Dust | All, Lean (the car's shadow only), None |
| | Car reflections / Tire smoke / Bloom | On | Off |
| | Dust | Off | On |
| | Paint coat | Subtle | Gloss, Classic |
| | Draw distance | 2.5x | GT2's, 1.5x, 2x |
| | HUD | Remastered | Original |
| GAME | Physics | **Classic** (GT2's own physics) | Modern (our physics at 120 steps a second) |
| | AI rubber band | Off | On (GT2's catch-up) |
| | 120 Hz camera | Off | On |
| | Ghosts | GT2's | Smooth (from recorded car poses) |
| CONTROLS | Stick deadzone / sensitivity / curve | 2% / 90% / Linear | |
| OTHER | Audio glide | Line | On, Snap, Off |
| | Record sessions | On | Off |
| | Debug panel | Off | On (F10 still shows it) |

A choice saved on this page also wins over a flag you type for the same setting (guides/13-FLAGS-AND-SETTINGS.md,
"How the settings work").

## Textures

UGT2R draws GT2's own textures by default, with smooth filtering (**Original (smooth)**). **Nothing is upscaled
unless you ask for it.** The upscaled textures (each texture redrawn at 4 times its size, 8 times for car paint) are
an opt-in:

| How | What it does |
|---|---|
| Port Options > Textures: **Upscaled** | saved: every start uses them until you set Original again |
| Left Alt+F1 while playing | this session only |
| `--scene-textures upscaled` | one start (only while Textures was never changed on the page; guide 13) |

With them on, each track and car takes longer the first time it is seen (its upscaled textures are made then, in
the background while you play), they take several GB more in `data/scene-cache`, and the remaster look adds its
ground and rock detail and 3D trees. To make all of them at once:

```bat
UGT2R.exe --warmup-all --scene-textures upscaled
```

```sh
./UGT2R-x86_64.AppImage --warmup-all --scene-textures upscaled
```

It takes a long time. Add `--warmup-set main` to limit it to the 30 main tracks.

## Saves

The game saves into **save slots** in the `saves` folder, one file per career: `saves/slot1.gt2s`, `slot2.gt2s`,
and so on, with no limit on the number. Each slot holds your career, your time-trial ghosts, your saved replay and
which mods were on.

* **Save Game** and **Load Game** work as in GT2, but instead of GT2's Slot1 / Slot2 box they show a list of your
  slots (number, name, days, credits) with a details panel for the slot under the cursor. **Up** / **Down** move,
  **Cross** picks, **Triangle** leaves. Save Game's last row is **New slot**.
* **Left** / **Right** on a row switch its choice: Load Game: Load, Restore backup, Delete; Save Game: Save, Delete.
  **Delete** asks first, then moves the slot file to `saves/deleted/` (not destroyed). The slot in play cannot be
  deleted.
* The game also **saves by itself** into the slot in play after a race result, a purchase or sale, a license result
  or a setting change.
* The copy before the last save is kept as `slotN.gt2s.prev`. If the slot file is ever damaged, UGT2R reads the
  backup ("Read from its backup" in the panel), and **Restore backup** loads it on purpose.
* UGT2R starts on the slot you saved last. To start on another: `--save-slot 2`. An empty slot starts a new game.

**A memory card from v0.4, DuckStation or ePSXe:** guides/01-INSTALL.md, "Updating from v0.4". `cards/card1.mcr`
is copied into a new slot by itself, once; another card: start once with `--import-card path/to/card.mcr`. While
save slots are on, the card file is neither read nor written by the game.

**Mods that add cars or courses:** play them in their own save folder, `--save-dir saves-modded`
(guides/03-MODS.md explains why).

Back up the `saves` folder now and then (copy it somewhere).

## Screenshots, recordings and logs

Everything goes into **`shots`** in the port folder:

| File | What it is |
|---|---|
| `psx-play-field*.png` | F12 screenshots (the file names keep our developer name) |
| `record-DATE-TIME.log` | every session's input (both pads, per field). Beside it, the save slots as they were at the start (`.slotN.gt2s`) and card 1 (`.card1.mcd`). We replay these to see exactly what you saw |
| `gt2-debug-*.log` | the game's debug log for the session (physics watch included) |
| `hitch.log` | a line for every slow picture |
| `psx-play-report-fieldNNNNNN.txt` | the report F9 writes |

These are for bug reports. They grow by a few MB per session; delete old ones whenever you like. To stop writing
them: Port Options > Record sessions: Off, or `--record off --debug-log off --watch off` (guide 13).

## Reporting a bug

1. When something goes wrong, press **F9**. The game stops where it is and writes
   `shots/psx-play-report-fieldNNNNNN.txt`. The window stays open; close it when you are done.
2. Send us that report, the newest `shots/record-*.log` with the files of the same name beside it, and the newest
   `shots/gt2-debug-*.log`. Say what you did and what you expected.
3. If the game hangs (the picture stands still for 10 seconds), it writes the same report by itself.

The recording holds only your button presses and your saves. No game data.

## The Grand Tour 99 menus

These menus are part of the game (the installer builds them into `data/builtin` from your disc). They change GT
Mode's city map:

* the Wheel Shop sign is now **Tuning Village**. It opens a hub with four buttons: Wheel Shop, Car Wash, Tune Shops
  (the tune shop of your current car's maker) and Machine Test. Back from Wheel Shop, Car Wash and Machine Test returns to the hub; Back from a tune shop goes to
  that maker's dealer, as in GT2;
* the Car Wash sign is now an **Arcade Mode** sign and the Machine Test sign is now **Team Home**. Both are pictures
  only for now: the cursor skips them. Arcade Mode itself is on the title screen, as before.

They stay with `--mods none` and with an empty `mods` folder. A mod of yours that replaces the same pages wins over
them (guides/03-MODS.md).

## Mods and the disc lock

Mods in `mods` load at every start (guides/03-MODS.md). `data` itself is never changed, and the disc lock checks it
at every start (guides/01-INSTALL.md). To play without mods once: `--mods none`.
