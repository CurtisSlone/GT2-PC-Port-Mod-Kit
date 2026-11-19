# 12. Courses for a PlayStation or an emulator

Everything in this kit runs in this port. Some of it would also run on an unmodified PlayStation (or a plain
emulator such as DuckStation), and some would not: the port has more RAM, an archive that can grow, and fixes for
coordinates far from the course's center. Two `--target` values are for the stock game:

* **`--target ps1`** checks a build against what the stock game can run. Anything that only the port can run becomes
  an error, with where it is and why. The result is a mod folder, as always.
* **`--target aspec`** runs the same checks, then **writes the disc image and a verified `.xdelta` patch** for
  Gran Turismo 2 A-Spec v1.2.1. That is the finished mod for a PlayStation or an emulator:
  guides/14-A-SPEC-PATCH.md.

Both work on a course that **replaces** one of the game's courses (its "slot"). Adding a course needs the port's
archive extension and its 8 MB of RAM, so both refuse it.

## `--target ps1`

A new track in an existing course's slot (the oval sample replaces `laguna2`):

```bat
gt2-tools.exe track new kit\samples\oval_scenery.json --out work\oval-ps1 --mod Oval --target ps1
```

```sh
./gt2-tools track new kit/samples/oval_scenery.json --out work/oval-ps1 --mod Oval --target ps1
```

A course edit, from the edited `.glb` or from a patch (guides/08-EDIT-A-COURSE.md):

```bat
gt2-tools.exe edit laguna work\laguna-edit\laguna.edit.glb --out work\laguna-ps1 --target ps1
gt2-tools.exe edit laguna work\laguna.gt2patch --out work\laguna-ps1-patch --target ps1
```

```sh
./gt2-tools edit laguna work/laguna-edit/laguna.edit.glb --out work/laguna-ps1 --target ps1
./gt2-tools edit laguna work/laguna.gt2patch --out work/laguna-ps1-patch --target ps1
```

A retexture (guides/06-RETEXTURE-A-COURSE.md) and a new track from a GT2 course (guides/16-NEW-TRACK-FROM-COURSE.md):

```sh
./gt2-tools course texture replace laguna t004 my-pictures/board.png --mod RetexLaguna --target ps1
./gt2-tools track build work/nt-laguna --target ps1 --out work/nt-laguna-ps1
```

And any course in a folder, as a check only (a mod folder or a folder with `<slot>.tro` and `.trp`; a file it does
not hold comes from your install):

```sh
./gt2-tools course check mods/Edit_laguna --slot laguna --budget ps1 --json work/check.json
```

**A new track must replace an existing course** for this: leave out `add` in its spec and set `"slot"` to the
course it takes the place of (default `laguna2`, which no event of the game uses; guides/reference/TRACK-SPEC.md).

## What it checks

| Check | Limit | Why |
|---|---|---|
| Course file size | `.tro` and `.trp` at most 700,000 bytes each, inflated | the game loads the course to a fixed address, right before the cars' models; past this it overwrites them. This one is checked for every build, not only for the stock game |
| Distance from the center | every vertex, object, grid slot and AI node within +/-2,048 m | the PlayStation's geometry chip saturates beyond it; only this port corrects that |
| Detail per section | at most 512 vertices per section mesh | GT2's face format has 9-bit vertex indices |
| Draw load | at most 256 sections in a visibility list, and no more drawn from any one section than the busiest course GT2 shipped (test_in2: 2,864 track faces; 2,908 with its trees and lamps) | the console has no spare frame time; this port's longer draw distance does not exist there |
| Textures | every image and palette inside the slot's **course VRAM region**: the replaced course's own area of video memory, plus the part every course load overwrites anyway, less the sky's | the rest holds fonts, the HUD, cars, the sky and the sponsor boards |
| Archive space | reported: how many sectors the new compressed file needs beyond the original's | with `--target aspec` the archive is repacked to fit (guide 14); a sector-for-sector patch would need the old size |
| Files | no added courses | as above |

All 126 courses of A-Spec v1.2.1 pass unchanged (`course check --budget ps1`; a few report validator errors the
game itself ships with). The full list with the code behind each limit is in guides/reference/LIMITS.md.

A course **retexture** keeps every texture's size and place in video memory; `texture replace --target ps1` checks
the rest. Its remaster pictures exist only in this port.

## Making the disc

With `--target ps1` the result is the same mod folder as always (`work/.../mods/.../crsobj/<course>.tro.gz`,
`.trp.gz`). Turning it into a disc image is one more command, or one option:

* **A-Spec v1.2.1:** use `--target aspec` instead of `--target ps1` on the same command (or
  `gt2-tools aspec build MODDIR --slot STEM --out DIR` on a folder you already built). It writes the image, makes the
  `.xdelta`, applies it to your image again and compares the result byte for byte, then deletes the image unless you
  ask for it (`--keep-image`). guides/14-A-SPEC-PATCH.md.
* **Another GT2 image:** the building blocks are commands too: `gt2-tools disc extract`, `disc build`,
  `patch make`, `patch verify` (`gt2-tools help disc`, `help patch`). Only A-Spec v1.2.1 has the one-command path
  and is tested; the retail Simulation disc as a base comes later.

A course that passes was checked against the limits above. That is not a guarantee on hardware: drive it in your
emulator or on your console before you share it.
