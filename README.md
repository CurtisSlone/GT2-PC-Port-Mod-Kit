# GT2 PC Port + Mod Kit v0.4.3-debug

This runs **Gran Turismo 2** natively on Windows and Linux. It is built from a byte-matched decompilation of the
game's code and runs on the PSX Runtime, a native PlayStation runtime, so it is not an emulator. The game logic is
GT2's own. The program is called **UGT2R**.

It includes a **mod kit**: `gt2-tools`, one command-line program to export GT2's courses, cars and textures into
editable formats, retexture a course, build your own tracks, edit GT2's own courses and cars in Blender, and add new
cars and courses to the game with their own menu entries. A Blender add-on drives the same program.

**No game data is included.** You install the game from **your own disc**. The release holds no game code, no
graphics, no sounds and no music. Everything the game needs is read from your disc on your own PC.

**Remaster + Mod in progress** join us at [Grand Tour '99](https://discord.gg/fmMeQDFkMe)

## Limits (read first)

* **This is a debug release.** It is the build we test with. Out of the box UGT2R shows the debug panel (F10 hides
  it), records every session into `shots` (an input log, a copy of card 1, a debug log and a hitch log), and runs
  every new piece we have proven so far: modern physics at 120 steps a second, our own race tick, menus, camera and
  replays, the remaster look, a 120 Hz camera, time-trial ghosts from recorded poses, and the AI rubber band off.
  Each of those is a switch. guides/13-FLAGS-AND-SETTINGS.md lists every one, with its default and how to change it.
* **One disc only:** Gran Turismo 2 (USA, NTSC-U) Simulation Mode, v1.0, SCUS-94488, dumped from your own disc. Every other
  disc (the Arcade disc, PAL, Japanese, v1.1 and v1.2, patched images) is refused by the installer and by UGT2R at
  every start.
* **Disk space:** about 2 GB for the game files in `data`, plus the prepared tracks and cars in
  `data/scene-cache`: several GB more (our estimate for everything is about 12 GB; we have not measured a full run
  yet). The installer prepares them at the end. You can stop that step and play: whatever is not ready is prepared
  when a race needs it.
* **The recordings grow** by a few MB per session in `shots`. Delete old ones when you like, or turn recording off
  (`--record off`).
* **Linux is less tested than Windows:**
  * Tested only under WSLg (Windows 11's Linux desktop): window, keyboard and sound. There the GPU path ran on the
    CPU (llvmpipe), so we tested races with `--gpu soft`. The GPU path (Vulkan through wgpu) on a real Linux desktop
    is **unproven**.
  * **Gamepads on Linux are untested.** They go through evdev. The keyboard always works.
  * The window uses X11. On a Wayland desktop it runs through XWayland (GNOME, KDE and most others have it).
  * Nothing is bundled: your system needs `libudev`, `libasound` (ALSA; PipeWire and PulseAudio provide it) and a
    Vulkan driver (any current Mesa or NVIDIA driver). Built on Ubuntu 22.04: glibc 2.35 or newer.
  * The AppImage needs FUSE to start by double-click. Without FUSE:
    `./UGT2R-x86_64.AppImage --appimage-extract-and-run`.
* **Windows gamepads:** XInput (Xbox-type pads). PS4 and PS5 pads work through Steam Input or DS4Windows.
* **The Blender add-on 0.4** passed our scripted tests in Blender 4.2 LTS and 5.2 LTS on Linux. Its panels have not
  been checked by hand on Windows yet.
* **Mods that add cars or courses run only in this port**, not on a PlayStation (guides/12-CONSOLE-SAFE.md).

## Requirements

| | |
|---|---|
| **Windows** | Windows 10 or 11, 64-bit. A graphics card with DirectX 12 or Vulkan. |
| **Linux** | 64-bit, glibc 2.35 or newer (Ubuntu 22.04+, Debian 12+, Fedora 36+, Arch). X11 or XWayland, Vulkan driver, libudev, ALSA. |
| **Your disc** | **Gran Turismo 2 (USA), Simulation Mode disc, v1.0, SCUS-94488**, as a `.cue` + `.bin` image you made from your own disc. |
| **BIOS** | Not needed. The runtime has its own replacement. |
| **Controller** | Optional. A gamepad or the keyboard. |
| **Mod kit** | `gt2-tools` is included. **Blender 4.2 LTS or newer** (free, [blender.org](https://www.blender.org/download/)) for the add-on. |
| **Disk space** | About 2 GB, plus several GB for the prepared tracks and cars (see Limits). |

## Install and play

| | Windows | Linux |
|---|---|---|
| 1. Unpack | Unzip `gt2-pc-port-v0.4.3-debug-windows.zip` anywhere you can write, for example `C:\Games\gt2-pc-port`. Avoid `Program Files`. | `tar xf gt2-pc-port-v0.4.3-debug-linux.tar.gz` (keeps the programs executable) somewhere you can write, for example `~/Games`. |
| 2. Install from your disc | Double-click `install-gt2.bat` and pick your `.cue` (or drag the `.cue` onto it). | `./install-gt2.sh` (a file picker opens with zenity or kdialog; without one it asks for the path), or `./install-gt2.sh /path/to/game.cue`. |
| 3. Play | Double-click `UGT2R.exe`. | Double-click `UGT2R-x86_64.AppImage`, or `./UGT2R-x86_64.AppImage`. |

The **Grand Tour 99 menus** are part of the game: on GT Mode's city map, Tuning Village (Wheel Shop, Car Wash, Tune
Shops, Machine Test) and the Arcade Mode and Team Home signs. The installer makes them on your PC from your disc, into
`data/builtin`. They are not a mod: they stay with an empty `mods` folder, and your own mods load on top of them.

No flags are needed. guides/01-INSTALL.md has the details, guides/02-PLAY.md the controls, saves, screenshots and
bug reports.

## Guides

| Guide | What you get |
|---|---|
| [guides/01-INSTALL.md](guides/01-INSTALL.md) | the disc, the installer, the disc lock, checking an install, troubleshooting |
| [guides/02-PLAY.md](guides/02-PLAY.md) | UGT2R, controls, saves, screenshots, recordings, F9 bug reports |
| [guides/03-MODS.md](guides/03-MODS.md) | how the `mods` folder works, load order, saves and mods, what you may share |
| [guides/04-TOOLS-SETUP.md](guides/04-TOOLS-SETUP.md) | `gt2-tools` and the Blender add-on, set up once |
| [guides/05-EXPORT.md](guides/05-EXPORT.md) | export courses to JSON, PNG and glTF, the texture catalog, import back |
| [guides/06-RETEXTURE-A-COURSE.md](guides/06-RETEXTURE-A-COURSE.md) | replace a course's textures with your own pictures; one mod for the classic and the remaster look |
| [guides/07-BUILD-A-TRACK.md](guides/07-BUILD-A-TRACK.md) | draw a track in Blender (or a file), build it into a GT2 course, race it |
| [guides/08-EDIT-A-COURSE.md](guides/08-EDIT-A-COURSE.md) | reshape one of GT2's own courses in Blender, with its textures; share the edit as a small patch |
| [guides/09-SPLICE.md](guides/09-SPLICE.md) | worked example: splice two tracks into a new circuit |
| [guides/10-CARS.md](guides/10-CARS.md) | export, edit and preview a car; edit its model in Blender; add a new car with its own code |
| [guides/11-COURSES-IN-MENUS.md](guides/11-COURSES-IN-MENUS.md) | give a new course its own menu entry and events |
| [guides/12-CONSOLE-SAFE.md](guides/12-CONSOLE-SAFE.md) | check a course against what an unmodified PlayStation can run (`--target ps1`) |
| [guides/13-FLAGS-AND-SETTINGS.md](guides/13-FLAGS-AND-SETTINGS.md) | every UGT2R flag and environment variable, its default, and how to change it |
| [guides/reference/](guides/reference/README.md) | file formats, the track spec, the course edit format, every limit |

Every `gt2-tools` command in the guides was run by our test script on Linux before this release. The Windows forms
are the same commands with `\` in paths.

Everything the kit makes from game data, such as exported courses, texture sheets, the Blender starter scene with
Laguna Seca, or a course opened for editing with its textures, is **generated on your PC from your install** and
stays there. Do not share files that contain GT2's data. What is your own work: a new track's course files, a course
edit's `.gt2patch`, the pictures you paint, your own car model. guides/03-MODS.md lists which file is which.

## How GT2 works

Open `explainers/index.html` in any browser (no internet needed): 40 pages on GT2's physics, AI, events,
cars, menus, graphics and sound, and on what the port's modern physics changes, with the graphs and formulas.

## What is in this folder

```text
UGT2R.exe / UGT2R-x86_64.AppImage   the game: plays GT2 from data (and installs it from your disc)
gt2-tools.exe / gt2-tools           the mod kit's program (cars, courses, tracks, edits; builds the Grand Tour 99 menus)
install-gt2.bat / install-gt2.sh    install from your disc, then prepare the tracks and cars
modules/                            GT2's decompiled code, compiled (no game data)
cards/blank.mcd                     an empty, formatted memory card
mods/                               your mods (see mods/README.txt)
kit/                                the Blender add-on (gt2_track_tools-0.4.0.zip) and sample tracks
guides/                             the guides above
explainers/                         how GT2 works, in pages: open explainers/index.html in a browser
THIRD-PARTY.md                      license notices for the AppImage runtime
THIRD-PARTY-LICENSES.txt            licenses of the open-source libraries compiled into our programs
LICENSE.txt                         the guides, scripts, samples and Blender add-on are public domain (CC0)
VERSION.txt                         the release and build date
```

After the install: `data/` (the game files from your disc and the prepared tracks and cars), `cards/card1.mcr`
(your memory card) and `shots/` (screenshots, recordings, reports).

## Legal

Gran Turismo and Gran Turismo 2 are trademarks of Sony Interactive Entertainment. This project is a fan project. It
is not affiliated with or endorsed by Sony Interactive Entertainment or Polyphony Digital. It includes no copyrighted
game data. You need your own legally obtained copy of the game. The guides, scripts, samples and Blender add-on in
this release are public domain (CC0 1.0, LICENSE.txt).
