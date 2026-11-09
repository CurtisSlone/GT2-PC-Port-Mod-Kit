# 7. Build a track

Draw where the road goes as a line, in Blender or in a file. `gt2-tools track new` builds everything else: the road
with lanes, kerbs, grass and walls, collision, the AI cars' racing line, the start grid, replay cameras, textures,
the minimap and the game's course record. No Blender scripting is needed, and no game files are edited by hand.

**What this guide covers:** **new** tracks from a center line. To reshape one of GT2's own courses instead, see
guides/08-EDIT-A-COURSE.md.

**Limits, up front:**

* Tracks built as an **added** course (a new name such as `zz_mytrack`) run **only in this port**: a new course is
  added to the game's archive, which needs the port's archive extension and 8 MB of RAM. A track that **replaces**
  an existing course can be checked for the original PlayStation: guides/12-CONSOLE-SAFE.md.
* Only one mod that adds courses can be on at a time, unless you build them into one mod
  (guides/11-COURSES-IN-MENUS.md).
* A save made with an added course needs that course's mod. Use a separate memory card for it.

## In Blender

Set up the add-on first (guides/04-TOOLS-SETUP.md).

### 1. The starter project

1. In the 3D view press **N**. A sidebar opens; click its **GT2** tab, panel **GT2 Track**.
2. Click **Create starter project** and choose a folder and a file name, for example
   `Documents\GT2 tracks\GT2_Track_Starter.blend` (Linux: `~/GT2 tracks/GT2_Track_Starter.blend`).
3. Wait about half a minute. The add-on reads Laguna Seca from **your** installed game data and builds the scene,
   saves it and opens it: a 100 m / 1 km grid, Laguna Seca at true size, a car, a house, a grandstand and a tree
   for scale, and a sample road, the orange line named **Track**. It is mesh only: surfaces show flat colors by
   material name. The text **READ ME FIRST** inside the file explains moving around and editing the road.

This file contains game data (Laguna Seca). Keep it for yourself; do not share it.

### 2. Draw your road

The orange **Track** line is the center of the road. Select it, press **Tab** for Edit Mode, and move points
with **G** (add **Z** to move them up or down: that is the road's height). 1 Blender unit = 1 meter. Rules of thumb:

* **One closed loop:** each point joined to the next, the last joined to the first.
* **Corners:** a radius of 20 m is a hairpin for a 10 m road; 60-150 m is a normal corner; long bends are 200 m
  and more.
* **Hills:** keep climbs under about 15% (15 m of height per 100 m of road).
* **Bridges:** where the road crosses itself, one stretch must be at least 6 m higher than the other.
* **Width and banking per point (optional):** the line's `_width` attribute (meters) and `_bank` attribute
  (degrees; positive raises the right edge). Set them in Edit Mode: select points, F3 > **Set Attribute**.
* **Start line:** the cars start at the line's first point. To start elsewhere, move the **Start** empty onto the
  line.
* **GT2 course for reference:** pick any of the game's courses in the panel and click **Add**. It appears at true
  size in its own collection, so you can trace a real corner or compare sizes. It is never exported with your
  track.
* **Place markers** (Home, Dealer, Race, License: an arrow at the 3D cursor) are saved with the track for later
  work. The game does not use them yet.

### 3. Build it

1. Save the file (**Ctrl+S**).
2. In the GT2 tab, type a **Name** (what the game shows on the race pages) and click **Build track for GT2**.
3. The status bar says *Built "..."* or tells you what to change. The full report is `build-log.txt` next to your
   .blend file.

The add-on writes `track.glb`, `track.json` and `out` next to your .blend, builds it with `gt2-tools track new`,
installs the mod **MyTrack** into the port's `mods` folder and turns the other course mods off in
`mods/load-order.txt`.

### 4. Race it

Start UGT2R with `--course zz_mytrack` and its own memory card. Every race now runs on your track. The quickest
look is any license test or Machine Test; a full race with AI cars is any GT Mode race your car qualifies for.

```bat
UGT2R.exe --course zz_mytrack --card1 cards\mytrack.mcr
```

```text
./UGT2R-x86_64.AppImage --course zz_mytrack --card1 cards/mytrack.mcr
```

guides/13-FLAGS-AND-SETTINGS.md shows how to make a shortcut (Windows) or a launcher (Linux) for this. To give the
track its own place in the game's menus instead, see guides/11-COURSES-IN-MENUS.md.

## Without Blender: the command line

`gt2-tools track new` reads a center line from a `.glb`, a `.csv` (`x,y,z[,width[,bank]]` per line, meters) or a
JSON description (a track spec), and builds the course and a mod folder. Try it on the samples:

```bat
gt2-tools.exe track new kit\samples\sample_track.json --out work\sample --mod SampleTrack
xcopy /e /i work\sample\mods\SampleTrack mods\SampleTrack
echo SampleTrack>> mods\load-order.txt
```

```sh
./gt2-tools track new kit/samples/sample_track.json --out work/sample --mod SampleTrack
cp -r work/sample/mods/SampleTrack mods/
echo SampleTrack >> mods/load-order.txt
```

Put `#` in front of other mods that add courses in `mods/load-order.txt`, then race it:

```bat
UGT2R.exe --course zz_sample --card1 cards\mytrack.mcr
```

```text
./UGT2R-x86_64.AppImage --course zz_sample --card1 cards/mytrack.mcr
```

The other samples:

* `kit/samples/climb.json`: a point-to-point hill climb (`"open": true`): one run with a Finish banner.
* `kit/samples/oval_scenery.json`: an oval with grandstands, trees, lamps, barriers and sponsor boards (trackside
  scenery from the compiler's library, or your own glTF models). It replaces the course slot `laguna2` instead of
  adding a course (guides/12-CONSOLE-SAFE.md).

```bat
gt2-tools.exe track new kit\samples\climb.json --out work\climb --mod Climb
gt2-tools.exe track new kit\samples\oval_scenery.json --out work\oval --mod Oval
```

```sh
./gt2-tools track new kit/samples/climb.json --out work/climb --mod Climb
./gt2-tools track new kit/samples/oval_scenery.json --out work/oval --mod Oval
```

A center line as a spec you can edit by hand (points and keys), and the validator over a built course:

```bat
gt2-tools.exe track spec kit\samples\sample_track.csv --out work\my_spec.json --name "My Track"
gt2-tools.exe track check work\sample --slot zz_sample
```

```sh
./gt2-tools track spec kit/samples/sample_track.csv --out work/my_spec.json --name "My Track"
./gt2-tools track check work/sample --slot zz_sample
```

Other options of `track new`: `--add NAME` (add the course under that name, `zz_...`), `--name "Display Name"`,
`--gltf` (also a glTF view of the result), `--target ps1` (guide 12). `gt2-tools help track` lists them all. The JSON
format (road width and lanes, kerbs, verges, walls, grid, cameras, scenery) is described in
`guides/reference/TRACK-SPEC.md`; every limit a track must respect is in `guides/reference/LIMITS.md`.

## When the builder says no

| Message | Fix |
|---|---|
| *the turn at ... is too tight for the road* | make the corner rounder, or narrow the road there (`_width`) |
| *the track crosses itself ... with only 0.0 m between the two levels* | raise one stretch by 6 m or more where they cross |
| *two stretches of track run 10 m apart* (warning) | move them apart; their verges and walls overlap |
| *a gradient of 40%* | spread the climb over more road |
| *the centerline does not close* | join the line's two ends (select both end points, **F**) |
| *a point's width is 0 m* | a `_width` value left at 0: select all points, Set Attribute to e.g. 13, then adjust |
| *N vertices per section: at most 512* | too much detail in one place: fewer `lanes`, or a longer `row_length` in the spec (guides/reference/TRACK-SPEC.md) |
| *the .tro would be N bytes, ... over the game's course buffer of 700000 bytes* | the course is too big for the game, so nothing is built: a longer `row_length` (6 or 8 m), fewer `lanes`, a shorter lap, a shorter `visibility` or less scenery |

## Sharing your track

Share your `.blend` **without** imported GT2 courses or the Laguna reference (delete those collections first), or
just `track.glb` + `track.json`. The other player builds it on their own PC with the add-on or `gt2-tools track
new`. The built course files hold only your road and generated textures; the `.crsinfo` in the mod is the game's
course table, so do not share that file (guides/03-MODS.md).
