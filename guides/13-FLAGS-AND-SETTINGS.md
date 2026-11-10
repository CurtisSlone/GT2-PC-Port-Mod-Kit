# 13. Flags and settings

UGT2R has no options page yet. Everything is set with **flags** on the command line (`--scale 3`) and
**environment variables** (`PSX_PHYSICS=classic`). This page lists every one: what it does, the release's default,
and how to change it on Windows and Linux.

`UGT2R.exe --help` (Linux: `./UGT2R-x86_64.AppImage --help`) prints the program's own full list. It ends with the
built-in settings of this release.

## How the defaults work

Started with no flags (a double-click), UGT2R runs our **test setup**: the flags and variables in the two tables
below. You change a setting by giving it yourself:

* **A flag you give wins** over the built-in one. Built-in flags come first and yours after, and the last one
  counts. `UGT2R.exe --scale 3` opens a smaller window; everything else stays as built in.
* **A variable you set wins** over the built-in one. UGT2R sets a built-in variable only when it is not set at all,
  or set to nothing. So `PSX_PHYSICS=` (empty) gives you the built-in `modern`, not GT2's default. Give a value.
* A switch that is on by default is turned off with `off`: `--debug-panel off`, `--record off`, `--warmup off`.
* Settings that change how the game plays (physics, swaps, rubber band) are written into the session's recording,
  so we can replay it. Exception: the `GT2_MODERN_*` comparison switches below are not recorded. If you send a
  recording made with one of them, tell us which.

## How to set them

### Windows

**Once, from a command window** (in the port folder, guides/04-TOOLS-SETUP.md):

```bat
UGT2R.exe --scale 3
set PSX_PHYSICS=classic
UGT2R.exe --scale 3
```

A `set` stays in that command window until you close it. `set PSX_PHYSICS=` removes it again.

**A shortcut, for flags:** right-click `UGT2R.exe` > **Create shortcut** (Windows 11: Show more options first).
Right-click the new shortcut > **Properties**. In **Target**, add the flags after the closing quote:

```text
"C:\Games\gt2-pc-port\UGT2R.exe" --scale 3 --record off
```

Leave **Start in** as the port folder. A shortcut cannot set environment variables; use a `.bat` file for those.

**A `.bat` file, for variables and flags:** in the port folder, make a new text file, name it for example
`UGT2R classic physics.bat` (Notepad: Save as type "All files"), and put in:

```bat
@echo off
cd /d "%~dp0"
set PSX_PHYSICS=classic
UGT2R.exe --scale 3 %*
```

Double-click it to play. `%*` passes on any flags you add when you run it from a command window. You can make a
shortcut to the `.bat` for your desktop.

### Linux

**Once, from a terminal** (in the port folder):

```text
./UGT2R-x86_64.AppImage --scale 3
PSX_PHYSICS=classic ./UGT2R-x86_64.AppImage --scale 3
```

A variable written before the program applies to that run only.

**A shell script:** in the port folder, a file `ugt2r-classic.sh`:

```text
#!/bin/sh
cd "$(dirname "$0")"
PSX_PHYSICS=classic exec ./UGT2R-x86_64.AppImage --scale 3 "$@"
```

Make it executable (`chmod +x ugt2r-classic.sh`) and run it.

**A `.desktop` launcher** (for your desktop's menu): a file
`~/.local/share/applications/ugt2r-classic.desktop` with your own port folder in `Path` and `Exec`:

```ini
[Desktop Entry]
Type=Application
Name=UGT2R (classic physics)
Path=/home/you/Games/gt2-pc-port-v0.4.0-debug-linux
Exec=env PSX_PHYSICS=classic /home/you/Games/gt2-pc-port-v0.4.0-debug-linux/UGT2R-x86_64.AppImage --scale 3
Terminal=false
```

`env NAME=value` sets the variables; the flags go after the program. With `Terminal=true` a terminal opens beside
the game with its messages.

## Examples

| You want | Windows | Linux |
|---|---|---|
| a smaller window | `UGT2R.exe --scale 3` | `./UGT2R-x86_64.AppImage --scale 3` |
| GT2's own physics (classic, 30 Hz) | `set PSX_PHYSICS=classic` then `UGT2R.exe` | `PSX_PHYSICS=classic ./UGT2R-x86_64.AppImage` |
| GT2's own drawing (no remaster look) | `UGT2R.exe --scene off` | `./UGT2R-x86_64.AppImage --scene off` |
| the AI rubber band back on (GT2's catch-up) | `UGT2R.exe --rubber-band on` | `./UGT2R-x86_64.AppImage --rubber-band on` |
| no recordings, no debug panel | `UGT2R.exe --record off --debug-panel off --debug-log off --watch off` | `./UGT2R-x86_64.AppImage --record off --debug-panel off --debug-log off --watch off` |
| card backups | `UGT2R.exe --card-backups cards-backup` | `./UGT2R-x86_64.AppImage --card-backups cards-backup` |
| another memory card | `UGT2R.exe --card1 cards\modded.mcr` | `./UGT2R-x86_64.AppImage --card1 cards/modded.mcr` |
| every race on one course | `UGT2R.exe --course zz_mytrack` | `./UGT2R-x86_64.AppImage --course zz_mytrack` |
| no mods this time | `UGT2R.exe --mods none` | `./UGT2R-x86_64.AppImage --mods none` |
| GT2's own city map, without the Grand Tour 99 menus (testing) | `UGT2R.exe --builtin off` | `./UGT2R-x86_64.AppImage --builtin off` |
| the software renderer (a driver problem) | `UGT2R.exe --gpu soft` | `./UGT2R-x86_64.AppImage --gpu soft` |
| GT2's car-to-car contacts in modern physics | `set GT2_MODERN_CARS=gt2` then `UGT2R.exe` | `GT2_MODERN_CARS=gt2 ./UGT2R-x86_64.AppImage` |
| the yaw inertia from the car's mass and size (experimental: cars rotate more easily) | `set GT2_MODERN_YAW_INERTIA=physical` then `UGT2R.exe` | `GT2_MODERN_YAW_INERTIA=physical ./UGT2R-x86_64.AppImage` |
| the plain port: GT2's own code everywhere (no swaps) | `set PSX_SWAP=tick=off` then `UGT2R.exe --scene off` | `PSX_SWAP=tick=off ./UGT2R-x86_64.AppImage --scene off` |

## The built-in flags

| Flag (built in) | What it does | Change it |
|---|---|---|
| `--hle` | no BIOS file: the runtime's own kernel replaces the PlayStation BIOS | keep it (without it a BIOS file is needed: `--bios FILE`) |
| `--card-backups none` | no backup copies of the card | `--card-backups cards-backup`: a dated copy goes there before the session's first save |
| `--draw-distance off` | GT2's own draw distance in GT2's drawing (the remaster look has its own reach, `--scene-reach`) | `--draw-distance 2` (1 to 2.5) draws farther in the classic look |
| `--scale 5` | the window opens at 5 x 320x240 | `--scale 2`, `3`, `4`, ... |
| `--pad dualshock` | both controller ports are DualShock pads | `digital` (the plain pad), `negcon` (a Namco neGcon: the left stick twists, RT and LT are I and II) |
| `--analog on` | the DualShock starts in analog mode (left stick steers) | `--analog off` (then M or Select+R3 switches it) |
| `--stick-shape gt2` | the stick shaped for GT2: past a small dead zone every movement reaches GT2 | `--stick-shape off`: the stick as the system reports it |
| `--scene native` | the remaster look: the race's 3D drawn by the runtime's renderer, GT2's HUD over it | `--scene off`: GT2 draws everything (F1 switches while playing) |
| `--scene-batch on` | the renderer packs meshes into shared buffers: fewer draw calls, the same picture | `--scene-batch off` |
| `--scene-fx all` | every drawing effect of the remaster look (shadow, sun glow, bloom, lamp glows, reflections, live car reflections, smoke, dust, detail, 3D trees, ...) | `--scene-fx none`, or a list: `--scene-fx shadow,sun,bloom` (the names: `--help`) |
| `--scene-textures upscaled` | the remaster's textures, redrawn 4x and smooth | `original`: GT2's texels, sharp (Left Alt+F1) |
| `--scene-detail curves` | the tracks' bends smoothed | `dense` (also denser track, objects and cars) or `original` (GT2's polygons) (Left Shift+F1) |
| `--scene-lod upscaled` | every car at its most detailed model, with the rounded body | `game` (GT2's detail by distance) or `0` (most detailed, not rounded) |
| `--scene-reach modern` | trackside objects drawn 3x farther, no pop-in | `game` (GT2's distances) or a number 1 to 8 (Left Ctrl+Left Shift+F1) |
| `--scene-aa fxaa` | anti-aliasing of the 3D picture | `off`, `smaa`, `msaa4`, `msaa4+smaa`, `ssaa2` (J cycles) |
| `--warmup on` | tracks and cars are prepared in the background while you play (the title shows "warming N/M") | `mine` (skip the every-car part: far less disk) or `off` |
| `--debug-log auto` | the game's debug log into `shots/gt2-debug-DATE-TIME.log` | `--debug-log off`, or a file name |
| `--watch physics` | the physics values the debug log watches | `--watch off`, `default`, or a file |
| `--record auto` | records the session: `shots/record-DATE-TIME.log` and the card as it was | `--record off`, or a file name |
| `--debug-panel` | the debug panel shown at start (F10) | `--debug-panel off` |
| `--shots <port>/shots` | where screenshots, recordings and reports go | `--shots DIR` |
| Linux only: `--gpu wgpu --gpu-scale auto` | the GPU renderer, at the window's resolution (Windows uses this by default) | `--gpu soft` (software) or `--gpu-scale 1` to `8` |

Data, cards, mods and modules are found beside the program: `data`, `cards/card1.mcr`, `mods`, `modules`.

## The built-in variables

| Variable (built in) | What it does | Change it |
|---|---|---|
| `PSX_PHYSICS=modern` | our modern physics, 120 steps a second (needs `tick=native` in `PSX_SWAP`) | `classic`: GT2's own physics at its 30 Hz tick |
| `PSX_SWAP=tick=native,save=native,menu_draw=native,menu_leaf=native,menu_engine=native,menu_actions=native,race_flow=native,camera=native,replay=native` | the parts of GT2 run by our own code instead of GT2's: the race tick, saving, menu drawing and logic, the race flow, the camera, replays | a value you give **replaces the whole list**; parts you leave out run GT2's own code. `tick=off` turns them all off |
| `PSX_CAMERA_RATE=physics` | the chase camera follows the car at every physics step (smooth at 120 Hz) | `gt2`: GT2's camera at its 30 Hz tick |
| `PSX_MENU_FEEL=ease,fastload` | GT Mode's menu with our hand ease and half the page-load time | `ease`, `fastload` or `off` |
| `PSX_RUBBER_BAND=off` | every AI car at the event's fixed pace, no catch-up or slow-down | `on`: GT2's rubber band (also `--rubber-band on`) |
| `PSX_FAST_BOOT=on` | fast-forward through the boot's card autoload to the title (a button press ends it) | `off` (also `--fast-boot off`) |
| `PSX_GHOST=poses` | time-trial ghosts from recorded car poses (kept beside the card: `card1.mcr.ghosts.gt2drive`) | `gt2`: GT2's own ghost |
| `GT2_MODERN_YAW_INERTIA=gt2` | modern physics uses GT2's yaw inertia for each car | `physical`: from the car's mass and size (experimental: cars rotate more easily) |
| `PSX_PHYS_TIME=1` | the time of each physics tick goes into the hitch log | `0` |
| `PSX_HITCH_LOG=<port>/shots/hitch.log` | a line per slow picture | another file name |
| `PSX_MODULES=<port>/modules` | GT2's compiled code | keep it |

With modern physics two more settings are on by themselves:

| Variable | What it does | Change it |
|---|---|---|
| `PSX_REPLAY_POSES` | replays of a modern race play the race's recorded car poses (exact); saved replays keep theirs beside the card (`card1.mcr.replays.gt2pose`) | `off`, or `always` |
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
| `--gpu-scale 1..8\|auto` (`PSX_GPU_SCALE`) | `auto` | the internal resolution (F7 cycles) |
| `--gpu-dither native\|fine\|off` (`PSX_GPU_DITHER`) | `native` | the dither pattern at high resolution (F6) |
| `--gpu-filter auto\|nearest\|linear\|area` (`PSX_GPU_FILTER`) | `auto` | how the picture is scaled into the window |
| `--gpu-deinterlace` (`PSX_GPU_DEINTERLACE=1`) | off | 480i screens drawn whole at every field |
| `--gpu-subpixel [on\|off]` (`PSX_GPU_SUBPIXEL=1\|0`) | on | sub-pixel vertices: no wobble (F5) |
| `--gpu-perspective [on\|off]` (`PSX_GPU_PERSPECTIVE=1\|0`) | on | perspective-correct textures (F4) |
| `--gpu-depth [on\|off]` (`PSX_GPU_DEPTH=1\|0`) | off | a depth buffer for GT2's 3D polygons |
| `--widescreen 16:9\|16:10\|21:9\|window\|off[,fill=...][,hud=...][,cull=...]` (`PSX_WIDESCREEN`) | `16:9` | a wider picture than GT2's 4:3 (F3 cycles). `fill=black\|clamp\|smear\|magenta`, `hud=edges\|centre`, `cull=wide\|4:3` |
| `--pace console\|display\|vrr` (`PSX_PACE`) | `display` on Windows, `console` on Linux | frame pacing: the console's 59.29 fields a second, locked to your display, or for FreeSync / G-Sync |
| `--refresh HZ` (`PSX_REFRESH`) | | your display's refresh, when the system reports it wrongly |
| `--pace-log FILE` (`PSX_PLAY_PACE_LOG`) | | every present as CSV |
| `--shot-at FIELD` | | take a screenshot by itself at that field |

### The remaster look (native scene)

| Flag | Default | What it does |
|---|---|---|
| `--scene feed\|native\|off` | `native` | see the built-in flags; `feed` is for testing |
| `--scene-cache DIR` | `data/scene-cache` | where the prepared tracks and cars go |
| `--scene-sites LIST` | `all` | which parts the runtime draws: `track,objects,sky,sprites,cars`, `all` or `none` |
| `--scene-distance METRES\|off` | | a draw distance for the native scene |
| `--scene-2d native\|original` | `native` | GT2's text drawn sharp by the runtime (H switches) |
| `--scene-hud native\|original` | `native` | the race HUD drawn sharp by the runtime from GT2's values |
| `--scene-interp on\|off` | `on` | render interpolation between GT2's game ticks (I switches) |
| `--scene-menu-car on\|off` | `on` | the GT Mode menu car drawn by the runtime's car renderer |
| `--scene-menu-shine gt2\|race` | `gt2` | the menu car's shine: GT2's reflection pass or the race's look |
| `--scene-screen-car on\|off` | `on` | the cars on the pre-race, results, prize and car-select screens drawn by the runtime |
| `PSX_SCENE_COAT=coat\|subtle\|old` | `coat` | how glossy the live car reflections (`cuberefl` in `--scene-fx`) look. `coat`: a clear coat, weak where you look straight at the paint and strong where it turns away from you (the roof and flanks at a low angle). `subtle`: less of the world in the paint. `old`: the first look, the world reflected at full strength everywhere (glossier). Also `FACE,EDGE`, two numbers (`0.45,1.6` is `coat`). K turns the live reflections off and on while playing |
| `--scene-debug off\|layers\|paint\|reflection\|sum\|mask` | `off` | debug views of the renderer |
| `PSX_DRAW_FIX=all\|none\|LIST` | `all` | the renderer's loading and memory fixes (`-name` turns one off). `cube` is not in `all`: it redraws the live reflections only 5 times a second (cheaper, but choppy); add it to a list only on a slow machine |
| `PSX_EXIT_FADE=on\|off\|MS` | `on` (200 ms) | the last race picture fades to black when GT2 leaves a race |
| `--warmup-all` (`--warmup-threads N`) | | prepare every track and car now, then exit (the installer runs this) |

### Controls and sound

| Flag (variable) | Default | What it does |
|---|---|---|
| `--pads A,B,...` | connection order | which player (1 to 4) each connected gamepad is |
| `--stick-steer KEY=VALUE,...` | `axis=auto` | the steering axis: `axis=rx\|ry\|lx\|ly`, `deadzone=0.05`, `sens=1.0`, `curve=1.0` |
| `--stick-pedals KEY=VALUE,...` | `axis=auto` | the throttle and brake on a stick, same keys |
| `--pad-debug` | | print every gamepad and key event |
| `PSX_PAD_RATE=world\|frame` | `world` with modern physics | the sticks read at 120 Hz for the modern physics |
| `PSX_RUMBLE=off` | on | no rumble |
| `--no-audio` | sound on | no sound |
| `--audio-latency MS` | `80` | sound queued ahead |
| `--audio-test` | | a 440 Hz tone for one second at start |
| `PSX_AUDIO_GLIDE=off\|snap\|line\|on` | `on` with modern physics | engine and tire sounds glide between GT2's updates |

### Game, cards and mods

| Flag (variable) | Default | What it does |
|---|---|---|
| `--course NAME` | | every race runs on that course (guide 07) |
| `--rubber-band on\|off` (`PSX_RUBBER_BAND`) | `off` | see the built-in variables |
| `--fast-boot on\|off` (`PSX_FAST_BOOT`) | `on` | see the built-in variables |
| `--card1 FILE\|none`, `--card2 FILE\|none` | `cards/card1.mcr`, slot 2 empty | the memory cards; a missing file is created formatted |
| `--card-mods check\|ignore` | `check` | refuse a card saved with a missing mod that adds things (guide 03) |
| `--card-backups DIR\|none` | `none` | see the built-in flags |
| `--save-edit EDIT` | | a save edit applied with the Insert key (testing) |
| `--mods DIR\|none` (`PSX_MODS`) | `mods` | the mods folder, or no mods (`data/builtin` stays) |
| `--builtin on\|off` (`PSX_BUILTIN`) | `on` | the game's built-in content in `data/builtin` (the Grand Tour 99 menus), loaded under your mods. `off` is for testing: GT2's own city map |
| `--ram 2\|8` (`PSX_RAM`) | `8` | 8 MB like the development console, or the console's 2 MB (mods that add files need 8) |
| `--quick-start`, `--quick-event ID` | | straight into a Test Run with the card's car (testing) |
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
