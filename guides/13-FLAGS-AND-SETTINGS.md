# 13. Flags and settings

Most settings a player wants are on the game's own **Port Options** page (title screen > Options > PORT OPTIONS;
guides/02-PLAY.md). Everything else, and everything for testing, is set with **flags** on the command line
(`--scale 3`) and **environment variables** (`PSX_PHYSICS=modern`). This page lists them: what each does, the
release's setting, and how to change it on Windows, Linux and macOS.

`UGT2R.exe --help` (Linux: `./UGT2R-x86_64.AppImage --help`; macOS: `./UGT2R.app/Contents/MacOS/UGT2R --help`)
prints the program's own full list. It ends with the release's built-in flags and variables. (It does not list the
save slot flags yet: they are under "Saves, cards and mods" below.)

## How the settings work

Started with no flags (a double-click), UGT2R uses three layers. A later layer wins:

1. **The release's settings.** The Port Options rows of a new install (the table below), and the built-in flags and
   variables of the two tables after it.
2. **Your flags and variables.** A flag you give comes after the built-in ones, and the last one counts:
   `UGT2R.exe --scale 3` opens a smaller window. A variable you set wins over a built-in one (UGT2R sets a built-in
   variable only when it is not set at all, or set to nothing: `PSX_PHYSICS=` (empty) gives the release's
   `classic`, so give a value).
3. **Your saved Port Options choices** (`saves/options.txt`, in the save folder). Once you change anything on the
   page, the file holds **every row**, and those rows win over a flag or variable for the same setting. So after you
   have used the page, `--scene-textures upscaled` on the command line does nothing while the page says Original:
   change it on the page instead, or lock it for one start (below), or delete `saves/options.txt` to start over from
   the release's settings.

`--option-lock key=value[,key=value...]` (or `PSX_OPTION_LOCK=...`) wins over all three, for that start: the page
shows the row dim ("Set by the launcher") and the choice is not saved. The keys are the names in `options.txt`
(`textures`, `physics`, `detail`, ... the "key" column below). Example: `--option-lock textures=upscaled`.

Also:

* A switch that is on by default is turned off with `off`: `--debug-log off`, `--record off`, `--warmup off`.
* Settings that change how the game plays (physics, swaps, rubber band) are written into the session's recording,
  so we can replay it. Exception: the `GT2_MODERN_*` comparison switches below are not recorded. If you send a
  recording made with one of them, tell us which.
* A folder you name on the command line (`--save-dir saves-modded`) is relative to the folder you start UGT2R in. A
  shortcut or launcher should use the full path, or start in the port folder.

## The Port Options rows

| Key | Row | Release setting | Same as the flag or variable |
|---|---|---|---|
| `vsync` | V-Sync | `adaptive` | `--pace adaptive` (`on`, `off`, `vrr`) |
| `scale` | Resolution | `4` | `--gpu-scale 4` (`auto`, `1` to `8`; F7) |
| `aspect` | Aspect ratio | `off` (4:3) | `--widescreen off` (`16:9`, `16:10`, `21:9`, `window`; F3) |
| `fps` | FPS counter | `on` | `--fps-counter on` |
| `look` | Remaster look | `on` | `--scene native` (`off`: GT2 draws everything; F1) |
| `textures` | Textures | `smooth` | `--scene-textures smooth` (`original`: sharp; `upscaled`; Left Alt+F1) |
| `aa` | Anti-aliasing | `msaa4+smaa` | `--scene-aa msaa4+smaa` (`off`, `fxaa`, `smaa`, `msaa4`, `ssaa2`; J) |
| `interp` | Smooth motion | `off` | `--scene-interp off` (I) |
| `detail` | Track detail | `curves` | `--scene-detail curves` (`dense`, `original`: GT2's polygons; Left Shift+F1) |
| `effects`, `reflections`, `smoke`, `dust`, `bloom` | Effects and its four rows | every effect but dust | `--scene-fx` (a list; Left Ctrl+F1) |
| `coat` | Paint coat | `subtle` | `PSX_SCENE_COAT=subtle` (`coat`: Gloss, `old`: Classic) |
| `draw` | Draw distance | `2.5` | `--draw-distance 2.5` (`off`: GT2's, `1.5`, `2`) |
| `hud` | HUD | `native` | `--scene-hud native` (`original`) |
| `physics` | Physics | `classic` | `PSX_PHYSICS=classic` (`modern`: our physics at 120 steps a second) |
| `rubber` | AI rubber band | `off` | `--rubber-band off` (`on`: GT2's catch-up) |
| `camera120` | 120 Hz camera | `off` | `PSX_CAMERA_RATE=gt2` (`on` = `physics`: the chase camera at every physics step) |
| `ghosts` | Ghosts | `gt2` | `PSX_GHOST=gt2` (`poses`: Smooth, from recorded car poses) |
| `deadzone`, `sens`, `curve` | Stick deadzone, sensitivity, curve | `0.02`, `0.9`, `1` | `--stick-steer deadzone=0.02,sens=0.9,curve=1` |
| `glide` | Audio glide | `line` | `PSX_AUDIO_GLIDE=line` (`on`, `snap`, `off`) |
| `record` | Record sessions | `on` | `--record auto` (`--record off`) |
| `debug` | Debug panel | `off` | `--debug-panel off` (F10 shows it anyway) |

## How to set flags and variables

### Windows

**Once, from a command window** (in the port folder, guides/04-TOOLS-SETUP.md):

```bat
UGT2R.exe --scale 3
set PSX_PHYSICS=modern
UGT2R.exe --scale 3
```

A `set` stays in that command window until you close it. `set PSX_PHYSICS=` removes it again.

**A shortcut, for flags:** right-click `UGT2R.exe` > **Create shortcut** (Windows 11: Show more options first).
Right-click the new shortcut > **Properties**. In **Target**, add the flags after the closing quote:

```text
"C:\Games\gt2-pc-port\UGT2R.exe" --scale 3 --save-dir "C:\Games\gt2-pc-port\saves-modded"
```

Leave **Start in** as the port folder. A shortcut cannot set environment variables; use a `.bat` file for those.

**A `.bat` file, for variables and flags:** in the port folder, make a new text file, name it for example
`UGT2R modded.bat` (Notepad: Save as type "All files"), and put in:

```bat
@echo off
cd /d "%~dp0"
set PSX_AUTOSAVE=off
UGT2R.exe --save-dir saves-modded %*
```

Double-click it to play. `%*` passes on any flags you add when you run it from a command window. You can make a
shortcut to the `.bat` for your desktop.

### Linux

**Once, from a terminal** (in the port folder):

```sh
./UGT2R-x86_64.AppImage --scale 3
PSX_PHYSICS=modern ./UGT2R-x86_64.AppImage --scale 3
```

A variable written before the program applies to that run only.

**A shell script:** in the port folder, a file `ugt2r-modded.sh`:

```sh
#!/bin/sh
cd "$(dirname "$0")"
exec ./UGT2R-x86_64.AppImage --save-dir saves-modded "$@"
```

Make it executable (`chmod +x ugt2r-modded.sh`) and run it.

**A `.desktop` launcher** (for your desktop's menu): a file
`~/.local/share/applications/ugt2r-modded.desktop` with your own port folder in `Path` and `Exec`:

```ini
[Desktop Entry]
Type=Application
Name=UGT2R (modded saves)
Path=/home/you/Games/gt2-pc-port-v0.5.0-linux
Exec=/home/you/Games/gt2-pc-port-v0.5.0-linux/UGT2R-x86_64.AppImage --save-dir /home/you/Games/gt2-pc-port-v0.5.0-linux/saves-modded
Terminal=false
```

`env NAME=value` before the program sets variables (`Exec=env PSX_AUTOSAVE=off /home/you/...`). With
`Terminal=true` a terminal opens beside the game with its messages.

### macOS

From Terminal in the port folder, as on Linux with the program inside the app:

```sh
./UGT2R.app/Contents/MacOS/UGT2R --scale 3
PSX_PHYSICS=modern ./UGT2R.app/Contents/MacOS/UGT2R
```

A shell script works the same way as on Linux, with that program path.

## Examples

| You want | Windows | Linux |
|---|---|---|
| a smaller window | `UGT2R.exe --scale 3` | `./UGT2R-x86_64.AppImage --scale 3` |
| the upscaled textures | Port Options > Textures: Upscaled | the same |
| our modern physics (120 steps a second) | Port Options > Physics: Modern | the same |
| GT2's own drawing (no remaster look) | Port Options > Remaster look: Off, or `UGT2R.exe --scene off` | `./UGT2R-x86_64.AppImage --scene off` |
| a separate save folder (mods that add cars or courses) | `UGT2R.exe --save-dir saves-modded` | `./UGT2R-x86_64.AppImage --save-dir saves-modded` |
| start on save slot 2 | `UGT2R.exe --save-slot 2` | `./UGT2R-x86_64.AppImage --save-slot 2` |
| bring a memory card's career into a new slot | `UGT2R.exe --import-card cards\other.mcr` | `./UGT2R-x86_64.AppImage --import-card cards/other.mcr` |
| no recordings, no debug log | `UGT2R.exe --record off --debug-log off --watch off` | `./UGT2R-x86_64.AppImage --record off --debug-log off --watch off` |
| every race on one course | `UGT2R.exe --course zz_mytrack` | `./UGT2R-x86_64.AppImage --course zz_mytrack` |
| no mods this time | `UGT2R.exe --mods none` | `./UGT2R-x86_64.AppImage --mods none` |
| GT2's own city map, without the Grand Tour 99 menus (testing) | `UGT2R.exe --builtin off` | `./UGT2R-x86_64.AppImage --builtin off` |
| the software renderer (a driver problem) | `UGT2R.exe --gpu soft` | `./UGT2R-x86_64.AppImage --gpu soft` |
| prepare every track version and car now | `UGT2R.exe --warmup-all` | `./UGT2R-x86_64.AppImage --warmup-all` |
| GT2's car-to-car contacts in modern physics | `set GT2_MODERN_CARS=gt2` then `UGT2R.exe` | `GT2_MODERN_CARS=gt2 ./UGT2R-x86_64.AppImage` |
| the plain port: GT2's own code everywhere (no swaps) | `set PSX_SWAP=tick=off` then `UGT2R.exe --scene off` | `PSX_SWAP=tick=off ./UGT2R-x86_64.AppImage --scene off` |

`PSX_SWAP=tick=off` also turns the save slots off (they need `save=native`): the game then saves to
`cards/card1.mcr`, as v0.4 did.

## The built-in flags

Besides the Port Options rows above:

| Flag (built in) | What it does | Change it |
|---|---|---|
| `--hle` | no BIOS file: the runtime's own kernel replaces the PlayStation BIOS | keep it (without it a BIOS file is needed: `--bios FILE`) |
| `--save-dir <port>/saves` | the save slots and the Port Options choices live here | `--save-dir DIR` (another folder) |
| `--import-card <port>/cards/card1.mcr` | only when that card holds a GT2 save: its career goes into a new slot, once per card | `--import-card FILE` (another card) |
| `--card-backups none` | no backup copies of a memory card (cards are only used with save slots off) | `--card-backups cards-backup` |
| `--scale 5` | the window opens at 5 x 320x240 | `--scale 2`, `3`, `4`, ... |
| `--pad dualshock` | both controller ports are DualShock pads | `digital` (the plain pad), `negcon` (a Namco neGcon: the left stick twists, RT and LT are I and II) |
| `--analog on` | the DualShock starts in analog mode (left stick steers) | `--analog off` (then M or Select+R3 switches it) |
| `--stick-shape gt2` | the stick shaped for GT2: past a small dead zone every movement reaches GT2 | `--stick-shape off`: the stick as the system reports it |
| `--scene-batch on` | the renderer packs meshes into shared buffers: fewer draw calls, the same picture | `--scene-batch off` |
| `--scene-lod game` | GT2's car models, its detail by distance | `upscaled` (every car at its most detailed model, with the rounded body) or `0` (most detailed, not rounded) |
| `--scene-reach modern` | trackside objects drawn 3x farther, no pop-in | `game` (GT2's distances) or a number 1 to 8 (Left Ctrl+Left Shift+F1) |
| `--warmup on` | tracks and cars are prepared in the background while you play (the title shows "warming N/M") | `mine` (skip the every-car part: far less disk) or `off` |
| `--debug-log auto` | the game's debug log into `shots/gt2-debug-DATE-TIME.log` | `--debug-log off`, or a file name |
| `--watch physics` | the physics values the debug log watches | `--watch off`, `default`, or a file |
| `--shots <port>/shots` | where screenshots, recordings and reports go | `--shots DIR` |
| Linux and macOS: `--gpu wgpu` | the GPU renderer (Windows uses it by default) | `--gpu soft` (software) |

Data, saves, cards, mods and modules are found beside the program: `data`, `saves`, `cards`, `mods`, `modules`
(macOS: beside `UGT2R.app`).

## The built-in variables

| Variable (built in) | What it does | Change it |
|---|---|---|
| `PSX_SWAP=tick=native,save=native,menu_draw=native,menu_leaf=native,menu_engine=native,menu_actions=native,race_flow=native,camera=native,replay=native,course=native,course_start=native,career=native,sound=native,cardb=native,tick_ai=native,sound_fx=native,sound_seq=native,gfx_frame=native,gfx_view=native,settings=native` | the parts of GT2 run by our own code instead of GT2's: the race tick, saving, menu drawing and logic, the race flow, the camera, replays, course loading and the race start, career, sound, the car database, the AI's race step, drawing set-up, the tune sheet | a value you give **replaces the whole list**; parts you leave out run GT2's own code. `tick=off` turns them all off |
| `PSX_MENU_FEEL=ease,fastload` | GT Mode's menu with our hand ease and half the page-load time | `ease`, `fastload` or `off` |
| `PSX_FAST_BOOT=on` | fast-forward through the boot's card autoload to the title (a button press ends it) | `off` (also `--fast-boot off`) |
| `GT2_MODERN_YAW_INERTIA=gt2` | modern physics uses GT2's yaw inertia for each car | `physical`: from the car's mass and size (experimental: cars rotate more easily) |
| `PSX_PHYS_TIME=1` | the time of each physics tick goes into the hitch log | `0` |
| `PSX_HITCH_LOG=<port>/shots/hitch.log` | a line per slow picture | another file name |
| `PSX_MODULES=<port>/modules` | GT2's compiled code | keep it |

`PSX_PHYSICS`, `PSX_CAMERA_RATE`, `PSX_GHOST`, `PSX_SCENE_COAT` and `PSX_AUDIO_GLIDE` come from the Port Options rows
above. With modern physics (Physics: Modern) two more settings are on by themselves:

| Variable | What it does | Change it |
|---|---|---|
| `PSX_REPLAY_POSES` | replays of a modern race play the race's recorded car poses (exact); saved replays keep theirs with the save | `off`, or `always` |
| `PSX_ATTRACT_AI` | the title's attract races are driven by GT2's AI on the session's physics | `off` |

## Modern physics: comparison switches

The modern physics has a few choices we made, each with GT2's way as the other setting. Set one to feel the
difference. They change only the modern physics, and **they are not recorded** (see above).

| Variable | Default | Other settings |
|---|---|---|
| `GT2_MODERN_CARS` | `rigid`: cars touch as rigid bodies | `gt2`: GT2's car-to-car push; `impulse`: a simple impulse |
| `GT2_MODERN_YAW_INERTIA` | `gt2`: GT2's value per car | `physical`: the yaw inertia from the car's mass and size (experimental: cars rotate more easily) |
| `GT2_MODERN_AI_ASSISTS` | `own`: AI cars use their own driving assists | `table`: GT2's table |
| `GT2_MODERN_AI_REACTION` | `0.2`: seconds the AI holds its controls after a hit | `0` or another number of seconds |
| `GT2_MODERN_BRAKE_SIZE` | `real`: brakes sized like the real car's | `gt2` |
| `GT2_MODERN_BRAKE_BALANCE` | `real`: the brake controller is a front/rear balance, 5% a step | `gt2`: GT2's ABS gain |
| `GT2_MODERN_DAMPER_RANGE` | `wide`: the damper settings act over a wider range | `gt2` |
| `GT2_MODERN_STAB_MODEL` | `linear` anti-roll bars | `gt2` |
| `GT2_MODERN_STAB_LOADS` | `1`: the bars take part in the load split | `0` |
| `GT2_MODERN_WALLS` | `gt2`: GT2's wall response | `impulse` |

More `GT2_MODERN_*` variables exist for our own tuning work; they are not covered here.

## Every other flag

### Window and picture

| Flag (variable) | Default | What it does |
|---|---|---|
| `--gpu soft\|wgpu\|compare\|compare-stop` (`PSX_GPU`) | `wgpu` | the renderer: `wgpu` on your graphics card, `soft` the software renderer (the console's exact picture; F8 switches); `compare`, `compare-stop` are for testing |
| `--gpu-backend auto\|vulkan\|dx12\|metal\|gl` (`PSX_GPU_BACKEND`) | `auto` | the graphics API |
| `--gpu-adapter NAME` (`PSX_GPU_ADAPTER`) | | pick the graphics card by part of its name |
| `PSX_GPU_PRESENT=fifo\|mailbox\|immediate` | | the present mode |
| `--gpu-scale 1..8\|auto` (`PSX_GPU_SCALE`) | `4` (Port Options: Resolution) | the internal resolution (F7 cycles) |
| `--gpu-dither native\|fine\|off` (`PSX_GPU_DITHER`) | `native` | the dither pattern at high resolution (F6) |
| `--gpu-filter auto\|nearest\|linear\|area` (`PSX_GPU_FILTER`) | `auto` | how the picture is scaled into the window |
| `--gpu-deinterlace` (`PSX_GPU_DEINTERLACE=1`) | off | 480i screens drawn whole at every field |
| `--gpu-subpixel [on\|off]` (`PSX_GPU_SUBPIXEL=1\|0`) | on | sub-pixel vertices: no wobble (F5) |
| `--gpu-perspective [on\|off]` (`PSX_GPU_PERSPECTIVE=1\|0`) | on | perspective-correct textures (F4) |
| `--gpu-depth [on\|off]` (`PSX_GPU_DEPTH=1\|0`) | off | a depth buffer for GT2's 3D polygons |
| `--widescreen 16:9\|16:10\|21:9\|window\|off[,fill=...][,hud=...][,cull=...]` (`PSX_WIDESCREEN`) | `off` (Port Options: Aspect ratio) | a wider picture than GT2's 4:3 (F3 cycles). `fill=black\|clamp\|smear\|magenta`, `hud=edges\|centre`, `cull=wide\|4:3` |
| `--pace on\|adaptive\|off\|vrr` (`PSX_PACE`) | `adaptive` (Port Options: V-Sync) | frame pacing: locked to your display (`on`; `adaptive` tears a late picture instead of waiting), the console's 59.29 fields a second (`off`), or for FreeSync / G-Sync (`vrr`) |
| `--refresh HZ` (`PSX_REFRESH`) | | your display's refresh, when the system reports it wrongly |
| `--pace-log FILE` (`PSX_PLAY_PACE_LOG`) | | every present as CSV |
| `--fps-counter on\|off` (`PSX_FPS_COUNTER`) | `on` (Port Options: FPS counter) | pictures a second and the game's speed at the window's top right |
| `--shot-at FIELD` | | take a screenshot by itself at that field |

### The remaster look (native scene)

| Flag | Default | What it does |
|---|---|---|
| `--scene feed\|native\|off` | `native` | the remaster look (Port Options: Remaster look); `feed` is for testing |
| `--scene-cache DIR` | `data/scene-cache` | where the prepared tracks and cars go |
| `--scene-sites LIST` | `all` | which parts the runtime draws: `track,objects,sky,sprites,cars`, `all` or `none` |
| `--scene-distance METRES\|off` | | a draw distance for the native scene |
| `--scene-2d native\|original` | `native` | GT2's text drawn sharp by the runtime (H switches) |
| `--scene-menu-car on\|off` | `on` | the GT Mode menu car drawn by the runtime's car renderer |
| `--scene-menu-shine gt2\|race` | `gt2` | the menu car's shine: GT2's reflection pass or the race's look |
| `--scene-screen-car on\|off` | `on` | the cars on the pre-race, results, prize and car-select screens drawn by the runtime |
| `PSX_SCENE_COAT=coat\|subtle\|old` | `subtle` (Port Options: Paint coat) | how glossy the live car reflections look. `coat` (Gloss): a clear coat, weak where you look straight at the paint and strong where it turns away. `subtle`: less of the world in the paint. `old` (Classic): the world reflected at full strength everywhere. Also `FACE,EDGE`, two numbers. K turns the live reflections off and on while playing |
| `--scene-debug off\|layers\|paint\|reflection\|sum\|mask` | `off` | debug views of the renderer |
| `PSX_DRAW_FIX=all\|none\|LIST` | `all` | the renderer's loading and memory fixes (`-name` turns one off). `cube` is not in `all`: it redraws the live reflections only 5 times a second (cheaper, but choppy); add it to a list only on a slow machine |
| `PSX_EXIT_FADE=on\|off\|MS` | `on` (200 ms) | the last race picture fades to black when GT2 leaves a race |
| `--warmup-all [--warmup-set main\|all] [--warmup-threads N]` | `all` | prepare tracks and cars now, then exit, with the `--scene-detail` and `--scene-textures` given (the installer runs it with `--warmup-set main`: the 30 main tracks and every car) |

### Controls and sound

| Flag (variable) | Default | What it does |
|---|---|---|
| `--pads A,B,...` | connection order | which player (1 to 4) each connected gamepad is |
| `--stick-steer KEY=VALUE,...` | `deadzone=0.02,sens=0.9,curve=1` (Port Options: Stick rows) | the steering axis: `axis=rx\|ry\|lx\|ly`, `deadzone`, `sens`, `curve` |
| `--stick-pedals KEY=VALUE,...` | `axis=auto` | the throttle and brake on a stick, same keys |
| `--pad-debug` | | print every gamepad and key event |
| `PSX_PAD_RATE=world\|frame` | `world` with modern physics | the sticks read at 120 Hz for the modern physics |
| `PSX_RUMBLE=off` | on | no rumble |
| `--no-audio` | sound on | no sound |
| `--audio-latency MS` | `80` | sound queued ahead |
| `--audio-test` | | a 440 Hz tone for one second at start |
| `PSX_AUDIO_GLIDE=off\|snap\|line\|on` | `line` (Port Options: Audio glide) | engine and tire sounds glide between GT2's updates |

### Saves, cards and mods

| Flag (variable) | Default | What it does |
|---|---|---|
| `--save-dir DIR` (`PSX_SAVE_DIR`) | `<port>/saves` | the save slots (`slotN.gt2s`) and the Port Options choices (`options.txt`); created at the first save |
| `--save-slot N` (`PSX_SAVE_SLOT`) | the slot saved last (slot 1 in an empty folder) | the slot to start on |
| `--import-card FILE` (`PSX_IMPORT_CARD`) | `cards/card1.mcr` when it holds a GT2 save | a memory card's career into a new slot, once per card (with `--save-slot N`: into that slot, only when it is empty). The card is only read |
| `PSX_AUTOSAVE=off` | on | no saving by itself after a race, purchase or license result (Save Game still saves) |
| `--option-lock key=value,...` (`PSX_OPTION_LOCK`) | | Port Options rows set for this start and shown locked (see "How the settings work") |
| `--course NAME` | | every race runs on that course (guide 07) |
| `--rubber-band on\|off` (`PSX_RUBBER_BAND`) | `off` (Port Options: AI rubber band) | GT2's AI catch-up and slow-down |
| `--fast-boot on\|off` (`PSX_FAST_BOOT`) | `on` | see the built-in variables |
| `--card1 FILE\|none`, `--card2 FILE\|none` | `cards/card1.mcr`, slot 2 empty | the memory cards, used only with save slots off (`PSX_SWAP` without `save=native`); a missing file is created formatted |
| `--card-mods check\|ignore` | `check` | refuse a card saved with a missing mod that adds things (guide 03); save slots only warn |
| `--card-backups DIR\|none` | `none` | see the built-in flags |
| `--save-edit EDIT` | | a save edit applied with the Insert key (testing) |
| `--mods DIR\|none` (`PSX_MODS`) | `mods` | the mods folder, or no mods (`data/builtin` stays) |
| `--builtin on\|off` (`PSX_BUILTIN`) | `on` | the game's built-in content in `data/builtin` (the Grand Tour 99 menus), loaded under your mods. `off` is for testing: GT2's own city map |
| `--ram 2\|8` (`PSX_RAM`) | `8` | 8 MB like the development console, or the console's 2 MB (mods that add files need 8) |
| `--quick-start`, `--quick-event ID` | | straight into a Test Run with the save's car (testing) |
| `--cruising`, `--debug-doors FILE` | | for the overworld work; not used in this release |

### Install and data

| Flag (variable) | Default | What it does |
|---|---|---|
| `DISC` (`PSX_DISC`) | | your disc image (`.cue`), for the install |
| `--install-only` | | install (or check) and exit (the installer runs this) |
| `--verify-data` | | compare `data` with the disc and repair it |
| `--data DIR` (`PSX_DATA`) | `data` | the installed game |
| `--disc FILE` | | play from the disc image itself |
| `--cd files\|drive` | `files` | how disc reads are served |
| `--no-unpack` | | read `GT2.VOL` from `data/files` instead of `data/gt2vol` |
| `--modules DIR` (`PSX_MODULES`) | `modules` | GT2's compiled code |
| `--bios FILE` (`PSX_BIOS`) | | a BIOS file (not needed with `--hle`) |

### Debugging (for us)

These are for finding bugs. You do not need them to play.

| Flag (variable) | What it does |
|---|---|
| `--debug-panel [on\|off]` | the debug panel shown at start (F10 switches it; Port Options: Debug panel) |
| `--report-at FIELD` | stop with the F9 report at that field, then exit |
| `--exit-at FIELD` | end at that field |
| `--keep-going-on-fault` | let the game's exception handler run after a CPU fault |
| `--null-trap` (`PSX_NULL_TRAP=1`), `--null-trap-log` (`PSX_NULL_TRAP=log`) | stop at, or count, reads through a null pointer |
| `--trace` | a call trace in the stop report (slower) |
| `--stop ADDR`, `--show N` | stop points |
| `--poll-cost N`, `--no-poll` | the runtime's polling |
| `--hle-groups LIST` | which kernel functions the runtime runs (with a BIOS) |
| `--hw-api LIST` (`PSX_HW_API`) | which hardware the runtime takes over from the registers |
| `--sdk-lib faithful\|native\|check` (`PSX_SDK_LIB`) | the runtime's library functions or the disc's |
| `--hle` (`PSX_HLE=1`) | see the built-in flags |
| `--mdec model\|standin` | the movie decoder |
| `--names FILE` | function names for the stop report |
| `--override NAME=PATH` | replace a file of the disc (testing) |
| `PSX_MEASURE=DIR` | a measured session: hitch log, per-picture table, present log |
| `PSX_SCENE_STATS=FILE`, `PSX_SCENE_TIMING=1` | the per-picture table, with the GPU time |
