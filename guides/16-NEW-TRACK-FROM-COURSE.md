# 16. A GT2 course as a new track

Open one of GT2's courses with **every part editable**, change what you like, and build it as a **new track**: for
the port (a new course next to the original), for the stock game's limits, or as an A-Spec patch. Unlike the course
edit of guide 08, this moves more than the road surface:

| Part | In Blender | What you can do |
|---|---|---|
| the route (one point per section, the start line, the sector splits) | a line `route`, empties `start`, `split.N` | move points: the road's sections, lap distance and split times follow |
| the drawn mesh, the mirror's mesh | `gt2_track`, `gt2_track_low` (hidden) | as in guide 08: move, add, delete faces, change textures |
| the collision faces (what the cars drive on) and their surfaces | `gt2_collision` | move a face between `gt2_track` and `gt2_collision` to make it drivable or not |
| the walls (invisible, the ones the cars hit) | edges in `walls` | move, delete, add (a new edge becomes a wall facing away from the road) |
| the AI lines: race line, two passing lines, side selector, pit entry and exit, pit lane | lines `ai.K` (`ai.K.preview` shows the arcs) | move, add nodes (subdivide an edge), delete nodes (dissolve) |
| the start grid | empties `grid.NN` | move the slots; the heading is a field in the panel |
| replay and TV cameras | empties `cam.NNN` | move a camera (its whole path moves with it) |
| trackside objects, trees, lamps | empties `obj.G.I`, `bb.S.M.I`, `glow.S.M.I` | move, delete, copy (**Shift+D**: a new copy of the same object) |
| the course record | fields in the panel | display name, sky, flags, the sky or car lighting of another course |
| textures | `tex:NNNN` and `lib:<ID>` materials | the course's own textures, or texture library pictures (guide 15) |

**Limits, up front:**

* **The sections are fixed.** Moving route points moves them, but no section is added or removed. You can bend and
  reshape the road, but you cannot make the lap much longer or add a new loop. A road moved very far from its
  section's old place is where the game's road tests complain; the build says where.
* **No new 3D models yet.** New trackside objects are copies of the course's own objects. Models from glTF are not
  compiled here.
* **Cameras are moved, not reshaped:** a camera's path keeps its curve.
* **AI lines follow the road** where you moved it (they gain nodes where the road bends). Lines you move yourself are
  refitted around the nodes you moved. The pit lane keeps its number of nodes (each pit box is a node).
* **For A-Spec and PS1, the track replaces a course** (a disc has no room to add one). For the port it is added as
  a new course next to the original.
* **The scene folder holds your install's data** (the source course's own files and the texture pages). Never share
  it, the .blend or the built mod. Sharing a port build as a small file: not yet. Share an A-Spec patch (guide 14).
* The add-on's panel opens **Laguna Seca**; other courses are one line in Blender's Python console (below).

Tested: all 125 courses of the retail disc and 126 of A-Spec export and build back byte for byte unchanged (and
through Blender, open and save, unchanged). Laguna Seca with a corner pushed out 5 m, a chicane on the straight, the
pit lines moved, a grid slot moved and a new trackside object: built, within the stock game's limits, and the AI cars
ran their laps.

## In Blender

Set up the add-on first (guides/04-TOOLS-SETUP.md; for A-Spec also **Set up A-Spec** there).

### 1. Open a course as a new track

1. Save a new empty file first (**Ctrl+S**), for example `Documents\GT2 tracks\laguna-new.blend`. The scene folder
   is written next to it, in `gt2-newtrack\<course>`.
2. Press **N**, **GT2** tab, panel **GT2 new track**, click **New track from course**. Laguna Seca opens as the
   collection `GT2 new track laguna`, with its textures.

Another course: **Scripting** workspace (or a **Python Console** area), then type, with the course's file name
(`gt2-tools course list`):

```python
bpy.ops.gt2track.newtrack_export(course="seattle")
```

### 2. Edit

* Move the `route` line's points, the walls' edges, the AI lines' points, the `grid.NN`, `cam.NNN` and `obj.` empties
  as you would any object or vertex. 1 Blender unit = 1 meter; the top view is the course map.
* Drawn and collision faces share vertices in the game's data: a vertex moved in one object drags the vertex at the
  same place in the other along when you save.
* The course record is in the panel: **display name**, **sky** (a sky number or a course name to copy it from),
  **flags**, **sky from**, **lighting from**, and the grid heading.
* Anything you did not move is written back exactly as it was (to under a millimeter), so an untouched part keeps
  GT2's own data.

### 3. Save, check, build

* **Save scene** writes the parts back into the scene folder (every build saves first).
* **Build for: Port**: **Build for the port** (a new course `zz_<course>` in the mod `NewTrack_<course>`, installed
  into the port's `mods`) or **Build for PS1** (the stock game's limits, guide 12; the files in
  `gt2-newtrack\out\<course>-ps1`).
* **Build for: A-Spec**: **Check for A-Spec** (the checks only) or **Build for A-Spec** (the verified patch in
  `gt2-newtrack\out\<course>-aspec\aspec`, guide 14). The budget box and the **Show** buttons are the same as in
  guide 08, step 4.
* When a build fails, the full report is `gt2-newtrack\newtrack-build-log.txt`.

### 4. Race it (port)

The port build adds the course **next to** the original, as `zz_<course>` (for Laguna Seca: `zz_laguna`). Only one
mod that adds courses can be on at a time (put `#` in front of the others in `mods/load-order.txt`). Race it as a
track of guide 07, in its own save folder:

```bat
UGT2R.exe --course zz_laguna --save-dir saves-newtrack
```

```sh
./UGT2R-x86_64.AppImage --course zz_laguna --save-dir saves-newtrack
```

guides/11-COURSES-IN-MENUS.md gives it its own menu entry.

## Without Blender

```bat
gt2-tools.exe course export laguna --new-track --textures --out work\nt-laguna
gt2-tools.exe track build work\nt-laguna --target port --out work\nt-laguna-port
gt2-tools.exe track build work\nt-laguna --target ps1 --out work\nt-laguna-ps1
gt2-tools.exe track build work\nt-laguna --target aspec --out work\nt-laguna-aspec
```

```sh
./gt2-tools course export laguna --new-track --textures --out work/nt-laguna
./gt2-tools track build work/nt-laguna --target port --out work/nt-laguna-port
./gt2-tools track build work/nt-laguna --target ps1 --out work/nt-laguna-ps1
./gt2-tools track build work/nt-laguna --target aspec --out work/nt-laguna-aspec
```

The scene folder holds `scene.json` (the course record), `mesh.glb` (drawn, collision and mirror meshes),
`route.json`, `walls.json`, `ai.json`, `grid.json`, `cameras.json`, `objects.json`, `textures/` and `base/` (the
source course's own files). Edit the JSON or the `.glb` with any tool that keeps the ids; an item without an id is
new, an id missing from a file is deleted.

`track build` options:

| Option | What it does |
|---|---|
| `--target port --add NAME` | a new course NAME (default `zz_<course>`; must sort after the game's courses: start with `zz_`), in `OUT/mods/<mod>` |
| `--target ps1 --slot STEM` | replaces the course STEM (default the source course) |
| `--target aspec [--slot STEM]` | as ps1 against your A-Spec setup, then the patch in `OUT/aspec` (guide 14; `--check-only`, `--keep-image`, `--patch-name`, `--json`, `--cache`) |
| `--mod NAME` | the mod folder's name (default `NewTrack_` + the new course or the slot: `NewTrack_zz_laguna`, `NewTrack_laguna`) |
| `--name "Display"` | the name the game shows |
| `--visibility keep\|compute` | `keep` (default): each section's original draw list. `compute`: new lists from the new geometry, checked against the draw load of the busiest shipped course |
| `--ai follow\|keep` | `follow` (default): AI lines follow the moved road. `keep`: as the source |
| `--room none\|unused\|far\|compact` | how far the texture packer may go to make room (guide 15) |
| `--force` | build even when the game's road tests find more errors than the source course has |

Unchanged, a scene builds the source course's files byte for byte (no mod is written for `--target ps1`).

## Sharing

Share the A-Spec patch (`.xdelta`, `.cue`, `README.txt`; guide 14) and your own texture library pictures. Never
share the scene folder, the .blend, the built mod or its `.crsinfo`: they hold GT2's course. A small share file
for port builds (only your changes) is not there yet.
