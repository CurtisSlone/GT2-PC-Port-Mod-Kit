# 4. Build a track in Blender

Draw where the road goes as a line in Blender. The track compiler (`gt2-trackc.exe`) builds everything else:
the road with lanes, kerbs, grass and walls, collision, the AI cars' racing line, the start grid, replay cameras,
textures, the minimap and the game's course record. No Blender scripting is needed, and no game files are edited
by hand.

**What this guide covers:** **new** tracks from a center line. To reshape one of GT2's own courses in Blender
instead, see guides\07-EDIT-A-COURSE.md.

Tracks built this way, as an added course, run **only in this port**. A new course is added to the game's archive,
which needs the port's archive extension and 8 MB of RAM. A track that replaces an existing course instead can be
checked for the original PlayStation: guides\08-CONSOLE-SAFE.md.

## 0. Set up (once)

1. Install **Blender 4.2 or newer** (blender.org, free).
2. Run `kit\setup-kit.bat`. It installs the **GT2 Track Tools** add-on into your Blender.
   To install it by hand instead: in Blender, Edit > Preferences > Get Extensions, use the small arrow at the top
   right, Install from Disk, and pick `kit\gt2_track_tools-0.3.0.zip`.
3. In Blender: **Edit > Preferences > Add-ons > GT2 Track Tools**, open its settings and set **Port folder** to
   this port folder (the one with `psx-play.exe`). The line below it must say *Port folder OK*.

## 1. The starter project

1. In the 3D view press **N**. A sidebar opens; click its **GT2** tab.
2. Click **Create starter project** and choose where to save, for example
   `Documents\GT2 tracks\GT2_Track_Starter.blend`.
3. Wait about half a minute. The add-on reads Laguna Seca from **your** installed game data and builds the scene
   (mesh only: no game textures go into Blender; surfaces show flat colours by material name):
   a 100 m / 1 km grid, Laguna Seca at true size, a car, a house, a grandstand and a tree for scale, and a sample
   road, the orange line named **Track**. The text **READ ME FIRST** inside the file explains moving around and
   editing the road.

This file contains game data (Laguna Seca). Keep it for yourself; do not share it.

## 2. Draw your road

The orange **Track** line is the center of the road. Select it, press **Tab** for Edit Mode, and move points
with **G** (add **Z** to move them up or down: that is the road's height). Some rules of thumb:

* **Corners:** a radius of 20 m is a hairpin for a 10 m road; 60-150 m is a normal corner; long bends are 200 m
  and more.
* **Hills:** keep climbs under about 15% (15 m of height per 100 m of road).
* **Bridges:** where the road crosses itself, one stretch must be at least 6 m higher than the other.
* **Width and banking per point (optional):** the line's `_width` attribute (meters) and `_bank` attribute
  (degrees; positive raises the right edge). Set them with Edit Mode, select points, F3 > **Set Attribute**.
* **Start line:** the cars start at the line's first point. To start elsewhere, move the **Start** empty onto the
  line.
* **GT2 course for reference:** in the GT2 tab, pick any of the game's 125 courses and click **Add**. It appears
  at true size in its own collection, so you can trace a real corner or compare sizes. It is never exported with
  your track.

## 3. Build it

1. Save the file (**Ctrl+S**).
2. In the GT2 tab, type a **Name** (what the game shows on the race pages) and click **Build track for GT2**.
3. The status bar says *Built "..."* or tells you what to change. The full report is `build-log.txt` next to your
   .blend file.

The add-on writes `track.glb`, `track.json` and `out\` next to your .blend, installs the mod **MyTrack** into
`mods\`, and turns the other course mods off in `mods\load-order.txt` (only one added course at a time for now).

## 4. Race it

Start **`play-mytrack.bat`**. Every race now runs on your track (course `zz_mytrack`). The quickest look is any
licence test or Machine Test; a full race with AI cars is any GT-mode race your car qualifies for. It uses its own
memory card, `cards\mytrack.mcr`, because a save made on an added course needs that course's mod.

To give the track its own place in the game's menus instead, see guides\06-COURSES-IN-MENUS.md.

## When the compiler says no

| Message | Fix |
|---|---|
| *the turn at ... is too tight for the road* | make the corner rounder, or narrow the road there (`_width`) |
| *the track crosses itself ... with only 0.0 m between the two levels* | raise one stretch by 6 m or more where they cross |
| *two stretches of track run 10 m apart* (warning) | move them apart; their verges and walls overlap |
| *a gradient of 40%* | spread the climb over more road |
| *the centerline does not close* | join the line's two ends (select both end points, **F**) |
| *a point's width is 0 m* | a `_width` value left at 0: select all points, Set Attribute to e.g. 13, then adjust |
| *N vertices per section: at most 512* | too much detail in one place: fewer `lanes`, or a longer `row_length` in the spec (guides\reference\TRACK-SPEC.md) |
| *the .tro would be N bytes, ... over the game's course buffer of 700000 bytes* | the course is too big for the game, so nothing is built: a longer `row_length` (6 or 8 m), fewer `lanes`, a shorter lap, a shorter `visibility` or less scenery |

## Without Blender: the command line

`gt2-trackc.exe` reads a center line from a `.glb`, a `.csv` (`x,y,z[,width[,bank]]` per line, meters) or a
JSON description, and builds the mod. Try it on the samples, from the port folder:

```text
gt2-trackc.exe compile kit\samples\sample_track.json --out work\sample --data data\gt2vol --mod SampleTrack
xcopy /e /i work\sample\mods\SampleTrack mods\SampleTrack
    add SampleTrack to mods\load-order.txt (and put # in front of other course mods)
play-gt2.bat --course zz_sample
```

* `kit\samples\climb.json`: a point-to-point hill climb (`"open": true`): one run with a Finish banner.
* `kit\samples\oval_scenery.json`: an oval with grandstands, trees, lamps, barriers and sponsor boards (trackside
  scenery from the compiler's library, or your own glTF models).

`gt2-trackc.exe --help` lists every option. The JSON format (road width and lanes, kerbs, verges, walls, grid,
cameras, scenery) is described in `guides\reference\TRACK-SPEC.md`; every limit a track must respect is in `guides\reference\LIMITS.md`.

## Sharing your track

Share your `.blend` **without** imported GT2 courses or the Laguna reference (delete those collections first), or
just `track.glb` + `track.json`. The other player builds it on their own PC with the add-on or `gt2-trackc`. The
compiled course files hold only your road and generated textures; the `.crsinfo` in the mod is the game's course
table, so do not share that file (guides\02-MODS.md).
