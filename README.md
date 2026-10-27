# GT2 PC Port + Mod Kit

This runs **Gran Turismo 2** natively on Windows. It is built from a byte-matched decompilation of the
game's code and runs on the PSX Runtime, a native PlayStation runtime, so it is not an emulator. The game logic is
GT2's own, and the picture is the game's renderer drawn on your graphics card: widescreen, sub-pixel vertices,
perspective-correct textures and a longer draw distance.

It includes a **mod kit**: tools to export GT2's courses and textures into editable formats, build your own
tracks in Blender, and add new cars and courses to the game with their own menu entries.

**No game data is included.** You install the game from **your own disc**. The release holds no game code, no
graphics, no sounds and no music. Everything the game needs is read from your disc on your own PC.

**Remaster + Mod in progress** join us at [Grand Tour '99]((https://discord.gg/fmMeQDFkMe))

## Requirements (read first)

| | |
|---|---|
| **PC** | Windows 10 or 11, 64-bit. A graphics card with DirectX 12 or Vulkan (any card from the last ~8 years). |
| **Your disc** | **Gran Turismo 2 (USA), Simulation Mode disc, v1.0, SCUS-94488**, as a `.cue` + `.bin` image you made from your own disc. **Only this exact disc works.** The installer checks the disc's fingerprint (SHA-256) and refuses any other disc: the Arcade disc, PAL or Japanese versions, other revisions, patched or modified images. |
| **BIOS** | Not needed. The runtime has its own replacement. |
| **Controller** | Optional. Any XInput or DualShock/DualSense pad, or the keyboard. |
| **Mod kit only** | **Blender 4.2 LTS or newer** (free, [blender.org](https://www.blender.org/download/)) for the track tools. The car tools are pez2k's GT2 tools, downloaded by `kit\setup-kit.bat`, which need the .NET 8 Desktop Runtime. See [THIRD-PARTY.md](THIRD-PARTY.md). |
| **Disk space** | About 2 GB after install. |

## Install

1. Unzip this folder anywhere you like, for example `C:\Games\gt2-pc-port`. Avoid `Program Files`.
2. Make an image of your disc (`.cue` + `.bin`) with any ripping tool, such as ImgBurn or CDRWIN-style dumpers.
   No-Intro-verified dumps of the US v1.0 disc match.
3. Double-click **`install-gt2.bat`** and pick your `.cue` file, or drag the `.cue` onto `install-gt2.bat`.
   The installer:
   * checks the disc (wrong disc → it stops and says which disc is needed);
   * copies the game files into `data\` (about 1 minute; the disc is not needed afterwards);
   * gives you a blank memory card, `cards\card1.mcr`, if you do not have one yet.
4. Double-click **`play-gt2.bat`**.

To check an install against the disc later: `install-gt2.bat "path\to\game.cue" verify`.

## Controls

| PlayStation | Keyboard |
|---|---|
| D-pad | Arrow keys |
| ✕ / ○ / □ / △ | X / Z / S / A |
| L1 / R1 / L2 / R2 | Q / W / E / R |
| Start / Select | Enter / Right Shift |

While playing: **F3** widescreen (16:9 / 4:3), **F4** perspective-correct textures, **F5** sub-pixel vertices,
**F6** dither, **F7** render scale, **F8** software / GPU renderer, **F12** screenshot (into `shots\`),
**P** pause, **Tab** fast-forward (hold).

## Saves

The game saves to `cards\card1.mcr`, a standard 128 KB PlayStation memory card image. It works with
DuckStation and ePSXe, so you can bring your own card: copy it over `cards\card1.mcr`. Before the first write of
each session a timestamped backup goes into `cards-backup\`.

Use a separate card for modded play (guides\02-MODS.md explains why).

## Mod kit

Start with **`kit\setup-kit.bat`**. It finds Blender, installs the GT2 Track Tools add-on into it, and downloads
pez2k's car tools (pinned versions, checked by SHA-256) into `kit\tools\`. Then follow the guides:

| Guide | What you get |
|---|---|
| [guides/01-INSTALL.md](guides/01-INSTALL.md) | install, the data folder, troubleshooting |
| [guides/02-MODS.md](guides/02-MODS.md) | how the `mods\` folder works, load order, saves and mods |
| [guides/03-EXPORT.md](guides/03-EXPORT.md) | export courses to glTF + JSON, export the texture/sprite catalogue as PNG |
| [guides/04-BUILD-A-TRACK.md](guides/04-BUILD-A-TRACK.md) | draw a track in Blender, build it into a GT2 course, race it |
| [guides/05-CARS.md](guides/05-CARS.md) | edit a car's model, paint and specs; add a new car with its own ID |
| [guides/06-COURSES-IN-MENUS.md](guides/06-COURSES-IN-MENUS.md) | give a new course its own menu entry and events |
| [guides/07-EDIT-A-COURSE.md](guides/07-EDIT-A-COURSE.md) | reshape one of GT2's own courses in Blender and race it; share the edit as a small patch |
| [guides/08-CONSOLE-SAFE.md](guides/08-CONSOLE-SAFE.md) | check a course against what an unmodified PlayStation can run (`--target ps1`) |
| [guides/09-EXAMPLE-SPLICE.md](guides/09-EXAMPLE-SPLICE.md) | worked example: splice two tracks into a new circuit with `gt2-trackc splice`, then build and race it |
| [guides/reference/](guides/reference/README.md) | GT2's course file format field by field, the track spec, every limit (course, car, archive, saves) |

Everything the kit makes from game data, such as exported courses, texture sheets and the Blender starter scene
with Laguna Seca, is **generated on your PC from your install** and stays there. Please do not share files that
contain GT2's data: exported textures, models and courses, or game files edited with the tools. What is your own
work: a track's course files (`crsobj\*.tro.gz`, `*.trp.gz`) and minimap from `gt2-trackc` hold only your
geometry and textures the compiler generates, a course edit's `.gt2patch` holds only your changes, and your own
car model or paint. The course table (`.crsinfo`) and
the car tools' outputs (`usa_gtmode_data.dat`, menu pages, name tables) are edited copies of game files, so do not
share them. guides\02-MODS.md lists which file is which.

## What is in this folder

```text
psx-play.exe          the runtime: plays GT2 from data\ (and installs it from your disc)
gt2-course.exe        course/texture export and import, add-car, add-course   (mod kit)
gt2-trackc.exe        the track compiler                                       (mod kit)
gt2-scenec.exe        the scene compiler: builds edited courses back (guide 07)  (mod kit)
modules\              GT2's decompiled code, compiled (no game data)
install-gt2.bat       install from your disc
play-gt2.bat          play
cards\blank.mcd       an empty, formatted memory card
mods\                 your mods (empty; see mods\README.txt)
kit\                  setup-kit.bat, the Blender add-on, samples, downloaded third-party tools
guides\               the guides above
THIRD-PARTY.md        every outside tool the kit uses, where it comes from, and what it is used for
LICENSE.txt           the guides, scripts, samples and Blender add-on are public domain (CC0)
```

## Legal

Gran Turismo and Gran Turismo 2 are trademarks of Sony Interactive Entertainment. This project is not affiliated
with or endorsed by Sony or Polyphony Digital. It includes no copyrighted game data. You need your own legally
obtained copy of the game. The decompiled source this port is built from is public: GT2-Decomp, https://github.com/CurtisSlone/GT2-Decomp.
The guides, scripts, samples and Blender add-on in this release are public domain (CC0 1.0, LICENSE.txt).
