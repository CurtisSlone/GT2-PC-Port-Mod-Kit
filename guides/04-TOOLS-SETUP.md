# 4. Set up the mod tools

The mod kit is two things:

* **`gt2-tools`** (`gt2-tools.exe` on Windows, `gt2-tools` on Linux and macOS), in the port folder. One program for
  every mod command: cars, courses, textures, tracks, course edits, new tracks, texture libraries and A-Spec patches.
  It reads **your** GT2 install (`data`) and writes mod folders for `mods`. It runs in a command window.
* **The GT2 Tools add-on for Blender** (`kit/gt2_track_tools-0.5.0.zip`). It adds a GT2 tab to Blender that runs
  `gt2-tools` for you: draw a track, edit a GT2 course with its textures, open a course as a new track, keep a
  course's texture library, build for the port or as an A-Spec patch, edit a car's model.

Neither installs anything outside the port folder and your Blender.

## gt2-tools

### Open a command window in the port folder

* **Windows:** in File Explorer, open the port folder, click the address bar, type `cmd` and press Enter. A Command
  Prompt opens in that folder.
* **Linux:** open a terminal in the port folder (most file managers: right-click > Open in Terminal), or
  `cd ~/Games/gt2-pc-port-v0.5.1-linux`.
* **macOS:** open **Terminal**, type `cd ` (with a space), drag the port folder onto the window, press Return.

Every command in the guides is typed there. The guides show each command twice: once for Windows, once for Linux.
They are the same command; Windows writes `gt2-tools.exe` and `\` in paths, Linux `./gt2-tools` and `/`. macOS is
typed as on Linux (`./gt2-tools`); `gt2-tools` on macOS is built but untested.

### Check that it works

```bat
gt2-tools.exe --version
gt2-tools.exe help all
gt2-tools.exe course list
```

```sh
./gt2-tools --version
./gt2-tools help all
./gt2-tools course list
```

`help all` prints every command with its options (`help course`, `help track`, `help edit`, `help aspec`, ... one
group). `course list` prints the game's 125 courses with their numbers (`laguna`, `seattle`, `TC_lisence`, ...): if
it does, the tools found your install.

### Where it reads and writes

* **`--data DIR`** is your GT2 install. Left out, gt2-tools uses the `data` folder beside itself, so from the port
  folder you never type it. Give it when your install is elsewhere: `--data D:\Games\gt2-pc-port\data`.
* **`--out DIR`** is where a command writes its results. The guides use a `work` folder in the port folder. Keep
  your work out of `data`.
* **`--mods DIR`** is the mods folder, for the commands that write straight into it (`course texture replace`).
  Default: the `mods` folder beside gt2-tools, where UGT2R reads mods.
* **`--mod NAME`** names the mod a command makes.
* **`--target port|ps1|aspec`** says what a build is for: the port (the default for most commands), the stock game's
  limits (guides/12-CONSOLE-SAFE.md), or a finished A-Spec patch (guides/14-A-SPEC-PATCH.md).

Every command is deterministic: the same install and the same input give the same files. Exit code 0 means done.
Anything else means the command failed, or (for `track new`, `track build`, `track check` and `edit`) it ran and
found problems in your track or edit; the printed message and the report say what.

### A-Spec v1.2.1 (optional, once)

For A-Spec patches (guides/14-A-SPEC-PATCH.md), point gt2-tools at your own **Gran Turismo 2 A-Spec v1.2.1** image
once:

```bat
gt2-tools.exe aspec setup "C:\Games\GT2\Gran Turismo 2 A-Spec (v1.2.1).bin"
```

```sh
./gt2-tools aspec setup "$HOME/Games/GT2/Gran Turismo 2 A-Spec (v1.2.1).bin"
```

It checks the image's SHA-256 (any other image is refused) and unpacks it into the `aspec` folder beside gt2-tools:
about 1.9 GB, a few minutes. Your image is only read. In Blender the same is a button (below).

## The Blender add-on

You need **Blender 4.2 LTS or newer** (free, [blender.org](https://www.blender.org/download/), also on Steam and the
Microsoft Store; Linux: blender.org's download, your distribution's package if it is 4.2 or newer, Flatpak or Snap;
macOS: blender.org's Apple Silicon download).
The add-on 0.5.0 was tested headless with Blender 4.2.3 LTS and 5.2.3 LTS on Linux (scripted tests of every panel
below). Its panels have not been checked by hand on Windows or macOS yet: tell us if something looks wrong there.

### Install

1. Start Blender.
2. **Edit > Preferences**. On the left, click **Get Extensions**.
3. Top right of that page, click the small arrow (**v**) and choose **Install from Disk...**.
4. Pick `kit/gt2_track_tools-0.5.0.zip` in the port folder and click **Install from Disk**. Do not unzip it.
5. Make sure **GT2 Tools** has a tick next to it (Edit > Preferences > **Add-ons**).

An older add-on (GT2 Tools 0.4, GT2 Track Tools 0.3) is replaced: it is the same add-on.

The same from a command line (with Blender closed; on Windows use the full path to `blender.exe` if it is not on
your PATH, for example `"C:\Program Files\Blender Foundation\Blender 4.2\blender.exe"`):

```bat
blender.exe --command extension install-file --repo user_default --enable kit\gt2_track_tools-0.5.0.zip
```

```sh
blender --command extension install-file --repo user_default --enable kit/gt2_track_tools-0.5.0.zip
```

### Tell it where the game is

Edit > Preferences > Add-ons, click the arrow next to **GT2 Tools**:

* **Port folder**: the port folder, the one with `UGT2R.exe` (Linux: `UGT2R-x86_64.AppImage`), `gt2-tools.exe`
  (Linux and macOS: `gt2-tools`), `data` and `mods`.
* **gt2-tools program**: leave it empty. Fill it in only when `gt2-tools` is somewhere else. The add-on looks for it
  in the port folder, beside its own files and on your PATH.

Below them a line says *Port folder OK*, or what is missing (for example *data/gt2vol is missing*: install the
game from your disc first, guides/01-INSTALL.md). Preferences save by themselves.

**A-Spec v1.2.1** (optional, the box under them): choose your **A-Spec image** (the `.bin` or its `.cue`), leave
**A-Spec setup folder** empty (it then uses the `aspec` folder beside gt2-tools), and click **Set up A-Spec** once.
It runs `gt2-tools aspec setup` (a few minutes; Blender waits). After that, **Build for: A-Spec** works in the course
panels (guides/14-A-SPEC-PATCH.md). If you move the image, set it up again.

### The GT2 tab

In the 3D view, press **N** with the mouse over the view: a sidebar opens. Click its **GT2** tab. It has five
panels:

| Panel | What it does | Guide |
|---|---|---|
| **GT2 Track** | starter project with Laguna Seca for scale, draw a road, build it into a course, place markers, add a GT2 course for reference | guides/07-BUILD-A-TRACK.md |
| **Edit a GT2 course** | open one of GT2's courses (with its textures), reshape it, change face textures, check it, build it for the port or as an A-Spec patch, write a `.gt2patch` | guides/08-EDIT-A-COURSE.md, guides/14-A-SPEC-PATCH.md |
| **GT2 new track** | open a GT2 course as a new track with every part editable (route, walls, AI lines, grid, cameras, objects), build it for the port, PS1 or A-Spec | guides/16-NEW-TRACK-FROM-COURSE.md |
| **GT2 texture library** | the pictures a course's faces may use: your own, the course's, pictures pulled from other courses; the video memory fill | guides/15-TEXTURE-LIBRARY.md |
| **GT2 Car** | open a car's model, edit it, build it back, preview pictures | guides/10-CARS.md |

Each button runs `gt2-tools`. The status bar at the bottom says what happened; when a build fails, the full report
is `build-log.txt` next to your .blend file (the new track panel: `newtrack-build-log.txt` beside its scene folder).

**Your .blend files hold GT2 data** as soon as a GT2 course, car or the starter's Laguna Seca is in them. Keep them
for yourself. The textures of a course edit are never packed into the .blend: they stay in a folder beside it
(guides/08-EDIT-A-COURSE.md).
