# 8. Courses for a PlayStation or an emulator

Everything in this kit runs in this port. Some of it would also run on an unmodified PlayStation (or a plain
emulator), and some would not: the port has more RAM, an archive that can grow, and fixes for coordinates far from
the course's center. If you make mods that ship as a patched disc for the original console, add **`--target ps1`**
to a build. Then anything that only the port can run becomes an error, with where it is and why.

```text
gt2-trackc.exe compile MYTRACK.json --out work\mytrack --data data\gt2vol --target ps1          (a new track in an existing slot)
gt2-scenec.exe course --original data\gt2vol --course laguna --edited laguna.edit.glb --out work\laguna-edit --target ps1
gt2-scenec.exe course --original data\gt2vol --course laguna --patch-in laguna.gt2patch --out work\laguna-edit --target ps1
```

**A new track must replace an existing course** for this: leave out `add` in its spec and set `"slot"` to the course
it takes the place of (default `laguna2`, which no event of the game uses; guides\reference\TRACK-SPEC.md). Adding
a course needs the port's archive extension and its 8 MB of RAM, so `--target ps1` refuses it.

## What it checks

| Check | Limit | Why |
|---|---|---|
| Course file size | `.tro` and `.trp` at most 700,000 bytes each, inflated | the game loads the course to a fixed address, right before the cars' models; past this it overwrites them. This one is checked for every build, not only with `--target ps1` |
| Distance from the center | every vertex, object, grid slot and AI node within ±2,048 m | the PlayStation's geometry chip saturates beyond it; only this port corrects that |
| Detail per section | at most 512 vertices per section mesh | GT2's face format has 9-bit vertex indices |
| Draw load | at most 256 sections in a visibility list, and at most 2,864 faces drawn from any one (the busiest shipped course) | the console has no spare frame time; this port's longer draw distance does not exist there |
| Textures | every image and palette inside the replaced course's own area of video memory | the rest holds fonts, the HUD, cars, the sky and the sponsor boards |
| Archive space | each replaced file's new compressed copy fits the sectors of the original | GT2.VOL fills its space on the disc with no gap; a larger file would move everything after it |
| Files | no added courses | as above |

All 125 courses of the game pass unchanged. The full list with the code behind each limit is in
guides\reference\LIMITS.md.

## What it does not do

It does not write a disc image or a GT2.VOL. The result is the same mod folder as always
(`work\...\mods\...\crsobj\<course>.tro.gz`, `.trp.gz`); putting those files into the game's archive and a disc
image is up to you and your own tools. A course that passes was checked against the limits above. That is not a
guarantee on hardware: test it on your emulator or console before you share it.
