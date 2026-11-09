# 9. Example: splice two tracks into a new one

`gt2-tools track splice` takes two tracks, keeps the first half of one and the second half of the other, and joins
them into a new circuit. It writes a normal track spec (JSON) that you build and play like any other track from
guide 07. This page walks through it with the samples in `kit/samples`, in a command window in the port folder.

**Limits, up front:**

* The result is an **added course**, so it runs **only in this port** (guides/07-BUILD-A-TRACK.md).
* The halves are cut by length from the start line. The tool places the second half and draws two smooth
  connecting roads, choosing the placement with the shortest, gentlest connectors that pass the builder's checks.
  It does not make bridges: the two halves and the connectors never cross.
* The look of the result is not something you choose. If you do not like it, change where the tracks are cut
  (`--cut-a`, `--cut-b`) or try `--mirror yes` / `--mirror no`. To shape it by hand, edit the points in the JSON.
* Scenery from the sources (grandstands, trees and so on) is not carried over.
* A long result gets longer road rows (a coarser road mesh) so that the course file stays within the game's limit
  of 700,000 bytes; the tool says when it does this.
* The same inputs always give the same file.

## 1. Splice the two samples

```bat
gt2-tools.exe track splice kit\samples\sample_track.json kit\samples\oval_scenery.json --out work\splice\splice.json --name "Splice Test"
```

```sh
./gt2-tools track splice kit/samples/sample_track.json kit/samples/oval_scenery.json --out work/splice/splice.json --name "Splice Test"
```

This keeps the first half of **Sample Track** (start line to its 50% mark) and the second half of **Test Oval**,
and writes `work/splice/splice.json`. The new course's name is `zz_splice` and the race pages show "Splice Test".
The tool prints what it did, for example:

```text
splice: Sample Track: circuit, 2948 m long; kept start line to 50%: 1474 m
splice: Test Oval: circuit, 1065 m long; kept 50% to the end: 533 m
splice: result: 2788 m lap = Sample Track's part 1474 m + connector 67 m + Test Oval's part 533 m + connector 714 m; 697 points
splice: connectors: 67 m (tightest radius 40 m) from Sample Track's cut to Test Oval's, 714 m (tightest radius 56 m) back to the start line; grade 1.1%
```

The start line stays where the first track has it. Road width and banking come from each half and blend along the
connectors. Kerbs, verges, walls, the start grid and the sky come from the first track's file.

Options:

| Option | What it does |
|---|---|
| `--cut-a 0.5` | how much of the first track to keep, from its start line (0.1 to 0.9) |
| `--cut-b 0.5` | where the second track's part starts (0.1 to 0.9); it runs from there to the end of its lap |
| `--mirror auto` | `auto` tries the second part as is and mirrored; `yes` or `no` forces one |
| `--name "..."` | the name on the race pages (default: both tracks' names) |
| `--add zz_splice` | the new course's file name (must start with `zz_`, guides/11-COURSES-IN-MENUS.md) |

Either track can be a JSON spec, a `.glb` or a `.csv` center line. A point-to-point track (such as
`kit/samples/climb.json`) is cut along its road from start to finish; the result is always a circuit.

If no placement passes, the tool says so and shows the last check that failed. Try other cut points.

## 2. Build it

```bat
gt2-tools.exe track new work\splice\splice.json --out work\splice\out --mod SpliceTrack
```

```sh
./gt2-tools track new work/splice/splice.json --out work/splice/out --mod SpliceTrack
```

The last line should be `0 errors, 0 warnings`. The full report is `work/splice/out/report.txt`.

## 3. Install the mod

```bat
xcopy /e /i work\splice\out\mods\SpliceTrack mods\SpliceTrack
echo SpliceTrack>> mods\load-order.txt
```

```sh
cp -r work/splice/out/mods/SpliceTrack mods/
echo SpliceTrack >> mods/load-order.txt
```

Open `mods/load-order.txt` and put `#` in front of any other mod that adds a course (such as `MyTrack` from the
Blender add-on). Each such mod carries the whole course table, so only one of them can be on at a time
(guides/11-COURSES-IN-MENUS.md explains how to put several courses in one mod).

## 4. Play it

Use a separate memory card for added courses (a save made with an added course needs its mod; guides/03-MODS.md).
UGT2R creates the card when it does not exist:

```bat
UGT2R.exe --course zz_splice --card1 cards\splice.mcr
```

```text
./UGT2R-x86_64.AppImage --course zz_splice --card1 cards/splice.mcr
```

Every race now runs on the new course. The quickest look is any license test; a full race with AI cars is any
GT Mode race your car qualifies for.

## 5. Optional: splice two of GT2's own courses

The tool can also read a circuit of the game from **your** install (`course:NAME`), from the data folder beside
gt2-tools:

```bat
gt2-tools.exe track splice course:laguna course:seattle --out work\mine\laguna_seattle.json --name "Laguna Seattle" --add zz_lagsea
gt2-tools.exe track new work\mine\laguna_seattle.json --out work\mine\out --mod LagunaSeattle
```

```sh
./gt2-tools track splice course:laguna course:seattle --out work/mine/laguna_seattle.json --name "Laguna Seattle" --add zz_lagsea
./gt2-tools track new work/mine/laguna_seattle.json --out work/mine/out --mod LagunaSeattle
```

Then install and play it as in steps 3 and 4 (`mods/LagunaSeattle`, `--course zz_lagsea`).

* Course names are the game's file names; `gt2-tools course list` lists them.
* Only the road's center line, height, width and banking are taken (from the course's track sections). The result
  gets the builder's own road, kerbs, grass, walls and textures, not the original scenery.
* Point-to-point courses (Pikes Peak) and test courses are refused. Some courses have stretches steeper or tighter
  than the builder allows (Laguna Seca's Corkscrew is in its second half): then that half cannot be used, and the
  tool says which check failed. Where a kept corner is too tight for its road, the road is narrowed there and the
  report says so.
* `gt2-tools track decompose laguna --out work/laguna_spec.json` turns one course into an approximate track spec, to
  start a track of your own from.

**The result contains the layout of GT2's courses. Keep it on your PC; do not share the JSON or the built mod.**
The samples splice in steps 1-4 has no game data in it.
