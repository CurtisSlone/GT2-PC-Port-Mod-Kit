# GT2 PC Port + Mod Kit v0.5.1

This runs **Gran Turismo 2** natively on Windows, Linux and macOS (Apple Silicon). It is built from a byte-matched decompilation of the
game's code and runs on the PSX Runtime, a native PlayStation runtime, so it is not an emulator. The game logic is
GT2's own. The program is called **UGT2R**.

It includes a **mod kit**: `gt2-tools`, one command-line program to export GT2's courses, cars and textures into
editable formats, retexture a course, build your own tracks, edit GT2's own courses and cars in Blender, and add new
cars and courses to the game with their own menu entries. A Blender add-on drives the same program.

**No game data is included.** You install the game from **your own disc**. The release holds no game code, no
graphics, no sounds and no music. Everything the game needs is read from your disc on your own PC.

**Remaster + Mod in progress** join us at [Grand Tour '99](https://discord.gg/fmMeQDFkMe)

## New in v0.5.1

The game changed, and so did the mod kit: the current `gt2-tools` (the game's Grand Tour 99 menus need it) and the
Blender add-on 0.5.0 (`kit/gt2_track_tools-0.5.0.zip`). Where a guide says something else about the points below,
this README is right.

* **New default settings** (see "Settings on a new install" below): GT2's own physics, GT2's own textures
  smoothly filtered (nothing is upscaled unless you ask for it), smoothed track bends, no debug panel. Every one is
  on the in-game Port Options page, and your choices there are kept.
* **A smaller first install.** The installer prepares the 30 main tracks only. The 2-player, reverse, license and
  test versions of the tracks are prepared the first time you race on them (a short wait at that race's start).
* **Save slots.** Your career now lives in `saves/` (see "Saves" below). A v0.4 card comes along by itself.
* **macOS on Apple Silicon** (new; see Limits).
* More of the game runs on our own code (course loading and the race start, career, car database, sound, the AI's
  race step, drawing set-up, the tune sheet), each part proven against the original first.

## Limits (read first)

* **This is a beta debug build.** Out of the box UGT2R records every session into `shots` (an input log, the save
  as it was, a debug log and a hitch log) and runs our own code for the parts we have proven (race tick, menus,
  camera, replays, career, sound and more). The settings on a new install are listed below; the debug panel is off
  (F10 shows it). Modern physics (120 steps a second), the 120 Hz camera and smooth ghosts are one Port Options
  choice away. guides/13-FLAGS-AND-SETTINGS.md lists the flags and these defaults.
* **One disc only:** Gran Turismo 2 (USA, NTSC-U) Simulation Mode, v1.0, SCUS-94488, dumped from your own disc. Every other
  disc (the Arcade disc, PAL, Japanese, v1.1 and v1.2, patched images) is refused by the installer and by UGT2R at
  every start.
* **Disk space:** about 2 GB for the game files in `data`, plus the prepared tracks and cars in
  `data/scene-cache`: about 1.3 GB after the install (our estimate: 30 main tracks with smoothed bends at about
  20 MB each, every car about 0.7 GB), growing by about 20 MB for each other track version you race on. You can
  stop the prepare step and play: whatever is not ready is prepared when a race needs it. The upscaled textures, or
  another Track detail, are prepared separately when you turn them on and take more.
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
* **macOS is the least tested:**
  * Apple Silicon (M1 and newer) only, macOS 11 or newer. Intel Macs are not supported.
  * The graphics (Metal), sound (CoreAudio) and gamepads on a Mac have **not been tested by us yet**. Reports
    welcome.
  * `gt2-tools` and the Blender add-on are built for macOS too, but untested there.
  * The app is signed ad hoc, not by a registered Apple developer, so macOS blocks it until you allow it once
    (see "macOS: the first start" below).
* **Windows gamepads:** XInput (Xbox-type pads). PS4 and PS5 pads work through Steam Input or DS4Windows.
* **The Blender add-on 0.5.0** passed our scripted tests in Blender 4.2 LTS and 5.2 LTS on Linux. Its panels have not
  been checked by hand on Windows yet.
* **Mods that add cars or courses run only in this port**, not on a PlayStation (guides/12-CONSOLE-SAFE.md).

## Requirements

| | |
|---|---|
| **Windows** | Windows 10 or 11, 64-bit. A graphics card with DirectX 12 or Vulkan. |
| **Linux** | 64-bit, glibc 2.35 or newer (Ubuntu 22.04+, Debian 12+, Fedora 36+, Arch). X11 or XWayland, Vulkan driver, libudev, ALSA. |
| **macOS** | Apple Silicon (M1 or newer), macOS 11 Big Sur or newer. |
| **Your disc** | **Gran Turismo 2 (USA), Simulation Mode disc, v1.0, SCUS-94488**, as a `.cue` + `.bin` image you made from your own disc. |
| **BIOS** | Not needed. The runtime has its own replacement. |
| **Controller** | Optional. A gamepad or the keyboard. |
| **Mod kit** | `gt2-tools` is included. **Blender 4.2 LTS or newer** (free, [blender.org](https://www.blender.org/download/)) for the add-on. |
| **Disk space** | About 2 GB, plus several GB for the prepared tracks and cars (see Limits). |

## Install and play

| | Windows | Linux | macOS |
|---|---|---|---|
| 1. Unpack | Unzip `gt2-pc-port-v0.5.1-windows.zip` anywhere you can write, for example `C:\Games\gt2-pc-port`. Avoid `Program Files`. | `tar xf gt2-pc-port-v0.5.1-linux.tar.gz` (keeps the programs executable) somewhere you can write, for example `~/Games`. | Double-click `gt2-pc-port-v0.5.1-macos.zip` and move the folder somewhere you can write, for example a `Games` folder in your home folder. Then allow it once (below). |
| 2. Install from your disc | Double-click `install-gt2.bat` and pick your `.cue` (or drag the `.cue` onto it). | `./install-gt2.sh` (a file picker opens with zenity or kdialog; without one it asks for the path), or `./install-gt2.sh /path/to/game.cue`. | Double-click `install-gt2.command` and pick your `.cue`, or in Terminal `./install-gt2.command /path/to/game.cue`. |
| 3. Play | Double-click `UGT2R.exe`. | Double-click `UGT2R-x86_64.AppImage`, or `./UGT2R-x86_64.AppImage`. | Double-click `UGT2R`. |

Updating from v0.4: unpack v0.5.1 into a new folder and move `data`, `cards` and `mods` over from the old one.
Running the installer again is not needed.

### macOS: the first start

macOS stops apps from developers it does not know. Do this once, after unpacking and before step 2:

1. Open **Terminal**, type `cd ` (with a space), drag the unpacked folder onto the Terminal window, press Return.
2. Run `xattr -dr com.apple.quarantine .` (the dot is part of it). This tells macOS you trust this folder, so
   UGT2R and the installer start normally and the game can write its data beside itself.

Without step 2, macOS either refuses to open UGT2R (then right-click UGT2R, **Open**, **Open**; on macOS 15 and
newer: System Settings, Privacy & Security, **Open Anyway**), or runs it from a temporary read-only copy where
nothing can be saved. UGT2R notices that and tells you to run the command above.

From Terminal, UGT2R is `./UGT2R.app/Contents/MacOS/UGT2R` (flags as on Linux, for example
`./UGT2R.app/Contents/MacOS/UGT2R --scale 3`).

### Settings on a new install

What the **Port Options** page (title screen > Options) shows before you change anything. Nothing is locked. A flag
you give on the command line wins over these; a choice you make on the page is saved in `saves/options.txt` and
then wins over both (to go back to flags for a setting, set it on the page again or delete `saves/options.txt`).

| Graphics | | Game, controls, other | |
|---|---|---|---|
| V-Sync | Adaptive | Physics | Classic (GT2's own) |
| Resolution | 4x | AI rubber band | Off |
| Aspect ratio | 4:3 | 120 Hz camera | Off |
| FPS counter | On | Ghosts | GT2's |
| Remaster look | On | Stick deadzone | 2% |
| Textures | Original (smooth) | Stick sensitivity | 90% |
| Anti-aliasing | MSAA 4x + SMAA | Stick curve | Linear |
| Smooth motion | Off | Audio glide | Line |
| Track detail | Curves | Record sessions | On |
| Effects | All | Debug panel | Off |
| Car reflections | On | | |
| Paint coat | Subtle | | |
| Tire smoke | On | | |
| Dust | Off | | |
| Bloom | On | | |
| Draw distance | 2.5x | | |
| HUD | Remastered | | |

V-Sync Adaptive lets a late picture out at once instead of waiting a whole refresh, where the graphics driver
offers it. Where it does not (we expect this on Windows with DirectX 12 and on macOS), it works as On.

### Textures

Upscaled textures: title screen > Options > Port Options page (Graphics) > Textures. The first race on each course
after switching takes longer while they are built.

UGT2R draws GT2's original textures by default (smoothly filtered), and nothing is upscaled unless you ask for it. The installer
prepares the tracks and cars with the original textures only. The upscaled textures (each texture redrawn at 4
times its size, 8 times for car paint, with smooth filtering) are one switch away:

| How | What it does |
|---|---|
| title screen > Options > **Port Options** page (Graphics): **Textures: Upscaled** | saved (in `saves/options.txt`): every start uses them until you set Original again |
| Left Alt+F1 while playing | this session only: upscaled and original in turn |
| `--scene-textures upscaled` | this start only, while no Textures choice is saved on the page (guides/13 shows how to make a shortcut) |

With them on, each track and car takes longer the first time it is seen (its upscaled textures are made then, in
the background while you play), they take several GB more in `data/scene-cache` (the `tex-upscaled` folders), and
the remaster look adds its ground and rock detail and 3D trees. To make all of them at once (what the v0.4
installer did): `UGT2R.exe --warmup-all --scene-textures upscaled` (Linux: `./UGT2R-x86_64.AppImage --warmup-all
--scene-textures upscaled`). It takes a long time. `--warmup-set main` limits it to the main tracks. **Original (smooth)** on the same row (`--scene-textures
smooth`) is GT2's textures with smooth filtering, nothing upscaled.

### Saves

The game saves into **save slots** in the `saves` folder, one file per career (`saves/slot1.gt2s`, `slot2.gt2s`,
...). Save and load in the game as always. Each slot holds your career, your time-trial ghosts and which mods were on.
The copy before the last save is kept as `slotN.gt2s.prev`, and UGT2R reads it if the slot file is ever damaged.
UGT2R starts the slot you saved last; another one: `--save-slot 2`. An empty slot starts a new game.

**Your v0.4 card:** if `cards/card1.mcr` holds a GT2 save, its career (with its replay, ghosts and mods list) is
copied into a new save slot the first time v0.5.1 starts. Once per card; the card file itself is not changed.
Another card (from DuckStation or ePSXe, for example): start once with `--import-card path/to/card.mcr`. While
save slots are on, the card file is not written. Mods that add cars or courses: play them in their own save folder,
`--save-dir saves-modded` (where the guides say `--card1 cards/....mcr`, use `--save-dir saves-...`).

The **Grand Tour 99 menus** are part of the game: on GT Mode's city map, Tuning Village (Wheel Shop, Car Wash, Tune
Shops, Machine Test) and the Arcade Mode and Team Home signs. The installer makes them on your PC from your disc, into
`data/builtin`. They are not a mod: they stay with an empty `mods` folder, and your own mods load on top of them.

No flags are needed. guides/01-INSTALL.md has the details, guides/02-PLAY.md the controls, saves, screenshots and
bug reports.

## Guides

| Guide | What you get |
|---|---|
| [guides/01-INSTALL.md](guides/01-INSTALL.md) | the disc, the installer, the disc lock, checking an install, troubleshooting |
| [guides/02-PLAY.md](guides/02-PLAY.md) | UGT2R, controls, the Port Options page, textures, save slots, screenshots, recordings, F9 bug reports |
| [guides/03-MODS.md](guides/03-MODS.md) | how the `mods` folder works, load order, saves and mods, what you may share |
| [guides/04-TOOLS-SETUP.md](guides/04-TOOLS-SETUP.md) | `gt2-tools` and the Blender add-on, set up once |
| [guides/05-EXPORT.md](guides/05-EXPORT.md) | export courses to JSON, PNG and glTF, the texture catalog, import back |
| [guides/06-RETEXTURE-A-COURSE.md](guides/06-RETEXTURE-A-COURSE.md) | replace a course's textures with your own pictures; one mod for the classic and the remaster look |
| [guides/07-BUILD-A-TRACK.md](guides/07-BUILD-A-TRACK.md) | draw a track in Blender (or a file), build it into a GT2 course, race it |
| [guides/08-EDIT-A-COURSE.md](guides/08-EDIT-A-COURSE.md) | reshape one of GT2's own courses in Blender, with its textures (worked example: a 20 m hill on Laguna Seca); check it, build it for the port or for A-Spec, share the edit as a small patch |
| [guides/09-SPLICE.md](guides/09-SPLICE.md) | worked example: splice two tracks into a new circuit |
| [guides/10-CARS.md](guides/10-CARS.md) | export, edit and preview a car; edit its model in Blender; add a new car with its own code |
| [guides/11-COURSES-IN-MENUS.md](guides/11-COURSES-IN-MENUS.md) | give a new course its own menu entry and events |
| [guides/12-CONSOLE-SAFE.md](guides/12-CONSOLE-SAFE.md) | check a course against what an unmodified PlayStation can run (`--target ps1`), and how the disc image is made |
| [guides/13-FLAGS-AND-SETTINGS.md](guides/13-FLAGS-AND-SETTINGS.md) | every Port Options row and UGT2R flag and environment variable, its setting on a new install, and how to change it |
| [guides/14-A-SPEC-PATCH.md](guides/14-A-SPEC-PATCH.md) | build a course edit, a new track or a retexture as a verified `.xdelta` for Gran Turismo 2 A-Spec v1.2.1 (`--target aspec`), apply it, drive it, share it |
| [guides/15-TEXTURE-LIBRARY.md](guides/15-TEXTURE-LIBRARY.md) | your own pictures and other courses' textures on a course's faces, packed into its video memory, with the fit report |
| [guides/16-NEW-TRACK-FROM-COURSE.md](guides/16-NEW-TRACK-FROM-COURSE.md) | open a GT2 course with every part editable (route, walls, AI lines, grid, cameras, objects) and build it as a new track |
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
UGT2R.exe / UGT2R-x86_64.AppImage / UGT2R.app   the game: plays GT2 from data (and installs it from your disc)
gt2-tools.exe / gt2-tools           the mod kit's program (cars, courses, tracks, edits; builds the Grand Tour 99 menus)
install-gt2.bat / .sh / .command    install from your disc, then prepare the tracks and cars
modules/                            GT2's decompiled code, compiled (no game data)
cards/blank.mcd                     an empty, formatted memory card
mods/                               your mods (see mods/README.txt)
kit/                                the Blender add-on (gt2_track_tools-0.5.0.zip) and sample tracks
guides/                             the guides above
explainers/                         how GT2 works, in pages: open explainers/index.html in a browser
THIRD-PARTY.md                      license notices for the AppImage runtime
THIRD-PARTY-LICENSES.txt            licenses of the open-source libraries compiled into our programs
LICENSE.txt                         the guides, scripts, samples and Blender add-on are public domain (CC0)
VERSION.txt                         the release and build date
```

After the install: `data/` (the game files from your disc and the prepared tracks and cars), `saves/` (your save
slots and your Port Options choices) and `shots/` (screenshots, recordings, reports).

## Legal

Gran Turismo and Gran Turismo 2 are trademarks of Sony Interactive Entertainment. This project is a fan project. It
is not affiliated with or endorsed by Sony Interactive Entertainment or Polyphony Digital. It includes no copyrighted
game data. You need your own legally obtained copy of the game. The guides, scripts, samples and Blender add-on in
this release are public domain (CC0 1.0, LICENSE.txt).
