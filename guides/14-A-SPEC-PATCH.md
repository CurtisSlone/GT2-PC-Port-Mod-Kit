# 14. Make an A-Spec patch

Build a course you edited, a new track or a retextured course for **Gran Turismo 2 A-Spec v1.2.1** and get a small
`.xdelta` patch that turns an A-Spec image into one with your course in it. The patch runs on GT2's own code: a
PlayStation or a plain emulator such as DuckStation, not only this port. One command (or one button in Blender) does
every step: the stock game's checks, the new disc image, the patch, and a byte-for-byte check of the patch.

The worked example is the video's: a 20 m hill on Laguna Seca's main straight (guides/08-EDIT-A-COURSE.md).

**What this does and does not do (read first):**

* **A-Spec v1.2.1 only**, the exact `.bin` of that release (SHA-256 `94866e3d...a599f`, 709,243,248 bytes). Another
  image, the retail Simulation disc, or a re-ripped copy is refused. Other base discs: not yet.
* **One course per patch, replacing a course** (its "slot"). A disc image cannot add a course. Your course loads
  wherever the game loads that slot: its GT Mode events, license tests, Machine Test runs. Laps, AI cars, pit rules
  and license targets belong to the events, not the course; menu pictures stay GT2's.
* **Every build is checked against the stock game first**: 700,000 bytes per course file, 512 vertices per section,
  the draw load of the busiest course GT2 shipped, textures inside the slot's part of video memory. A build over a
  limit stops with where and why, and no patch is written. Passing the checks is not a guarantee on hardware: drive
  it in your emulator before you share it.
* A-Spec changed 8 courses: Test Course `speed`, `lic_seattle`, `test_s2`, `test_z`, `tahiti_test7` and the three
  `tahiti_d_new` versions. Those must be edited from A-Spec's own copy (below); an edit exported from the retail
  disc is refused. Every other course is the same on both.
* **Share the `.xdelta` and the `.cue`** (and `README.txt`). Never share the patched `.bin`, your A-Spec image or the
  `aspec` setup folder: they are the whole game.

## Once: set up your A-Spec image

```bat
gt2-tools.exe aspec setup "C:\Games\GT2\Gran Turismo 2 A-Spec (v1.2.1).bin"
```

```sh
./gt2-tools aspec setup "$HOME/Games/GT2/Gran Turismo 2 A-Spec (v1.2.1).bin"
```

It checks the image (the `.bin` or its `.cue`) and unpacks it into the `aspec` folder beside gt2-tools: about
1.9 GB, a few minutes (`--cache DIR` puts it elsewhere; then give `--cache DIR` to the builds too). Your image is
only read, and it must stay where it is: every build reads it again, and refuses it if it changed. If you move the
image, run the setup again.

In Blender: **Edit > Preferences > Add-ons > GT2 Tools**, choose **A-Spec image**, click **Set up A-Spec**
(guides/04-TOOLS-SETUP.md).

## In Blender: a course edit

1. In the **Edit a GT2 course** panel set **Build for: A-Spec**, then pick the course and click **Edit**: the
   course comes from your A-Spec setup.
2. Edit it as in guides/08-EDIT-A-COURSE.md (the hill: section "The hill, step by step").
3. Click **Check for A-Spec**. Nothing is built; the budget box shows course bytes, VRAM fill, vertices per section
   and draw load in green, yellow or red. A problem selects the faces it is about and zooms to them; each problem in
   the box has a **Show** button.
4. Click **Build edited course**. The patch is in `out\<course>-aspec\aspec\` next to your .blend (next section).

**Build for: Port** is the port build of guide 08, unchanged.

The other panels:

* **GT2 new track** (guides/16-NEW-TRACK-FROM-COURSE.md): **Build for: A-Spec**, then **Check for A-Spec** or
  **Build for A-Spec**. The patch is in `gt2-newtrack\out\<course>-aspec\aspec\`.
* Faces with texture library pictures (guides/15-TEXTURE-LIBRARY.md): build them as a new track, or on the command
  line with `edit ... --library DIR --target aspec`. The course edit panel's A-Spec build does not take the library.

## Without Blender

Every build command takes `--target aspec`:

```bat
gt2-tools.exe edit laguna laguna.edited.glb --out work\laguna-aspec --mod MyLaguna --target aspec
gt2-tools.exe edit laguna laguna.gt2patch --out work\laguna-aspec --mod MyLaguna --target aspec
gt2-tools.exe track build work\nt-laguna --target aspec --out work\nt-laguna-out
gt2-tools.exe track new kit\samples\oval_scenery.json --out work\oval-aspec --mod Oval --target aspec
gt2-tools.exe course texture replace laguna t004 my-pictures\board.png --mod MySigns --target aspec --out work\signs-aspec
```

```sh
./gt2-tools edit laguna laguna.edited.glb --out work/laguna-aspec --mod MyLaguna --target aspec
./gt2-tools edit laguna laguna.gt2patch --out work/laguna-aspec --mod MyLaguna --target aspec
./gt2-tools track build work/nt-laguna --target aspec --out work/nt-laguna-out
./gt2-tools track new kit/samples/oval_scenery.json --out work/oval-aspec --mod Oval --target aspec
./gt2-tools course texture replace laguna t004 my-pictures/board.png --mod MySigns --target aspec --out work/signs-aspec
```

* An edit: export it from your A-Spec setup when it is one of the 8 courses A-Spec changed
  (`course export <course> --edit --textures --data aspec\data --out ...`). A `.gt2patch` someone shared builds the
  same way.
* A new track from a GT2 course (guide 16) replaces its source course unless you give `--slot STEM`.
* A track from a spec (guide 07) replaces the spec's `"slot"` (the oval: `laguna2`).
* A retexture (guide 06) also writes the mod into the port's `mods` folder, as `texture replace` always does.
* A mods folder you built another way (`--target ps1`): `gt2-tools aspec build MODDIR --slot STEM --out DIR`.

Options: `--check-only` (the checks and `check.json`, no image), `--keep-image` (keep the patched `.bin` for your own
test: 709 MB; otherwise it is deleted after the verify), `--patch-name NAME` (default `GT2-A-Spec-<mod name>`),
`--json FILE` (a copy of `check.json`), `--cache DIR` (another setup). Any exit code other than 0: over a limit or
refused, and no patch (`report.txt` and `check.json` say where).

A build takes about a minute and a half and needs free space for one image (about 1.3 GB on the output's drive;
it checks before writing anything).

## The output folder

Everything is in `<out>/aspec/` (in Blender: `out\<course>-aspec\aspec\` beside the .blend):

```text
GT2-A-Spec-MyLaguna.xdelta   the patch (the hill: 241,326 bytes)
GT2-A-Spec-MyLaguna.cue      the cue sheet for the patched image
README.txt                   for the player: the base, result and patch SHA-256, how to apply it, where the course
                             is driven, the limits that were checked
report.txt                   every check and build step
check.json                   the findings with their places, and the budget numbers
```

Before it writes these, the build applied the patch to your image and compared the result with the image it built,
byte for byte (`patch verify`). The `.bin` itself is then deleted (unless `--keep-image`).

## Apply the patch

What a player does, with their own A-Spec v1.2.1 image:

```sh
xdelta3 -d -s "Gran Turismo 2 A-Spec (v1.2.1).bin" GT2-A-Spec-MyLaguna.xdelta GT2-A-Spec-MyLaguna.bin
```

On Windows the same with `xdelta3.exe`, or a patcher with an xdelta front end (Delta Patcher, for example): source
file = the A-Spec `.bin`, patch = the `.xdelta`, output = `GT2-A-Spec-MyLaguna.bin`. Then put the `.cue` in the same
folder as the new `.bin` and open the `.cue` in DuckStation (or another emulator), or burn it. `README.txt` lists the
new image's SHA-256 to check the result. If xdelta3 says the source does not match, the `.bin` is not A-Spec v1.2.1
exactly.

## Where to drive it

```bat
gt2-tools.exe aspec targets laguna
```

```sh
./gt2-tools aspec targets laguna
```

```text
Slot laguna: "Laguna Seca Raceway" in the game (race slot; flags no boards; sky lagunasky)
GT Mode events: 14: 4WD0003, ELS0001, GT30502, GT50501, GTA0005, GTW0502 (+8)
License tests: LIS06
```

Without a slot it lists all 126 slots with their events. The same lines are in the patch's `README.txt`.

## When the check says no

| Finding | What to do |
|---|---|
| *section N (high mesh) needs more than 512 vertices* | too much new detail in one place: fewer new faces there (the add-on selects that section's faces) |
| course bytes over 700,000 | the course file is too big for the game's buffer: less new geometry, or delete faces you do not need |
| VRAM: a TIM or palette outside the slot's region (with its place) | a texture is outside the course's part of video memory: use fewer or smaller new pictures (guide 15's fit report) |
| draw load over the busiest shipped course | too much is drawn from one section: less geometry there |
| validator: more errors than the original | the road is broken somewhere (a car could fall through): `report.txt` names the section |
| the edit or patch was made against another copy of the course | one of the 8 courses A-Spec changed: export it again from the A-Spec setup |

## Share it

Share `GT2-A-Spec-<name>.xdelta`, the `.cue` and `README.txt`. Players apply it to their own A-Spec image. Never
share the patched `.bin`, the `.blend`, an export, a `textures` folder or a scene folder: they hold GT2's data
(guides/03-MODS.md, "Sharing mods").
