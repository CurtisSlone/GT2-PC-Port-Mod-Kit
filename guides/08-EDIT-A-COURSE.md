# 8. Edit a course in Blender

Open one of GT2's own courses in Blender, with its textures, reshape it, and race the result: widen a corner, add a
crest, move a wall, delete or add faces, put another texture on some faces. When you build, the parts you did not
touch keep the game's own data byte for byte, and only what you changed is recomputed. You build it **for the port**
(a mod) or **for A-Spec** (a verified patch for Gran Turismo 2 A-Spec v1.2.1 that runs on GT2's own code), and you
share a small file that holds only your changes.

The worked example is the one from the video: a **20 m hill on Laguna Seca's main straight**, just past the grid.

**What this does and does not do (read first):**

* You can **move vertices, delete faces, add faces**, and change a face's texture or surface. The road stays on its
  original route: the course's sections, its lap distance, the replay cameras and the AI cars' line are kept, and
  things near the road (the mirror's mesh, trackside objects, the start grid, the AI line) follow your changes.
* You cannot **re-route** the road here. A road moved far from its original line, for example across into the next
  section, keeps the old section boundaries, and the game will place the car oddly there. Small and medium reshapes
  are fine. To move the route, the walls, the AI lines, the pit lane or single trackside objects, open the course as
  a **new track** instead (guides/16-NEW-TRACK-FROM-COURSE.md).
* Faces can use **this course's own textures** (any of them, by number), a surface name, or a picture from the
  course's **texture library**: your own pictures and pictures pulled from other courses
  (guides/15-TEXTURE-LIBRARY.md). To paint over a texture the course already has, retexture it
  (guides/06-RETEXTURE-A-COURSE.md); a retexture and an edit of the same course work together.
* Trackside objects (trees, grandstands, gantries) are not in the edit file. They follow the road, but you cannot
  move them one by one here (guide 16 can).
* **A-Spec:** one course per patch, and it **replaces** that course (a disc has no room to add one). Every A-Spec
  build is checked against the stock game first; a build over a limit stops with where and why, and no patch is
  written.
* **Share the `.gt2patch` (port) or the `.xdelta` and `.cue` (A-Spec), never the .blend or the textures folder.**
  The textures are GT2's own pictures, made from your install. The .blend links to them and never holds them.

## In Blender

Set up the add-on first (guides/04-TOOLS-SETUP.md). For A-Spec builds also set up your A-Spec image once there
(**Set up A-Spec** in the add-on's preferences).

### 1. Bring a course in

1. Save a new empty file first (**Ctrl+S**), for example `Documents\GT2 edits\laguna-hill.blend` (Linux:
   `~/GT2 edits/laguna-hill.blend`). The course files are written next to it.
2. Press **N**, open the **GT2** tab, and the panel **Edit a GT2 course**.
3. Pick a course in the list (the game's file names: `laguna`, `seattle`, ...), leave **Show textures** on, and click
   **Edit**.

**Build for: Port / A-Spec** in the same panel says what the build makes. Set it **before Edit** when the edit is
for A-Spec: the course then comes from your A-Spec setup. That matters for the 8 courses A-Spec changed (Test Course
`speed`, `lic_seattle`, `test_s2`, `test_z`, `tahiti_test7` and the three `tahiti_d_new` versions): an edit of the
retail copy of those is refused for A-Spec. For every other course, Laguna Seca included, both copies are the same.

After a few seconds the course is in the scene as two objects: `gt2_track` (the road and scenery you see when
driving) and `gt2_track_low` (the mirror's simpler copy, hidden; it follows the main mesh). Each face's material is
named after the game's texture, for example `tex:0042`.

With **Show textures**, the add-on writes the course's texture pages from your install into
`gt2-edit/<course>/textures` next to the .blend and **links** them: the .blend points at the files and never holds
them. If you pack them anyway (File > External Data > Pack Resources), the panel turns red with an **Unpack the
textures** button, and saving links them again by itself. Without **Show textures** the course is mesh only: each
`tex:` material is a flat color.

This .blend contains the game's course geometry. Keep it for yourself.

### 2. Edit

Select `gt2_track`, press **Tab** for Edit Mode, and work as usual: **G** to move, **X** to delete, **E** to
extrude, **F** to fill a face. Some rules:

* **Moving vertices** is the common edit. Use proportional editing (**O**) for smooth changes.
* **New faces need a material.** Give each new face one of the course's `tex:NNNN` materials (the picker below
  does that), `untex` (a plain colored face), a library picture `lib:<ID>` (guide 15), or one of these surface
  names, which also make it a face the cars drive on: `tarmac`, `kerb`, `grass`, `gravel`, `offroad`, `dirt`. A new
  face without a material is an error at build time, with its position.
* **Extrude and duplicate** copy the original face's look and settings, so the new faces need nothing more.
* **Keep each part of the course light.** A section of track may hold at most 512 vertices (the PlayStation's
  limit, which GT2's code relies on). Adding a lot of detail in one place fails the build with the section's number.
* Edit `gt2_track_low` only if you want the mirror to differ; otherwise it follows `gt2_track`.

**The hill, step by step** (Laguna Seca):

1. Select `gt2_track`, **Tab** into Edit Mode, top view (**Numpad 7**), and frame the main straight and the grid.
2. Box-select a strip of road a little past the front of the grid, across the full width.
3. Press **O** (proportional editing), set the falloff to **Smooth**, then **G**, **Z**, type `20`, and scroll the
   mouse wheel to grow the circle to about 60 m, so the slope starts past the grid and ends well before the first
   corner.
4. **Tab** out and **Ctrl+S**.

That is about 20 m high and 120 m across, steepest about 28 degrees, over five sections (8 to 12), 328 vertices
moved. Moving vertices adds none, so the 512 limit is safe. The walls, barriers and scenery on those faces come up
with the road.

### 3. Change a face's texture

1. In Edit Mode, select the faces.
2. In the panel, pick a texture: the picture grid, **Find** by number, or **From face** (takes the active face's).
   The picker offers every texture of the course, not only the ones you can see.
3. Click **Apply to selected faces**. The faces get that texture's material `tex:NNNN` and its texture
   coordinates, so Blender shows them as the game will.

For a picture that is not one of the course's own, use the **GT2 texture library** panel (guide 15): pick the
picture, select faces, **Use on selected faces** (material `lib:<ID>`).

### 4. Check it (A-Spec)

With **Build for: A-Spec**, the panel shows **Check for A-Spec**. It runs every stock-game check without building
anything, and fills the **budget box**:

| Row | Green | Yellow | Red |
|---|---|---|---|
| Course bytes (the `.tro` and `.trp`, each of 700,000) | up to 90 % | up to the limit | over: the race would not load |
| VRAM fill (the course's part of video memory) | up to 90 % | up to it | any texture outside it |
| Vertices per section (the worst section, of 512) | up to 85 % | up to 512 | over: the section cannot be stored |
| Draw load (of the busiest course GT2 shipped) | up to 80 % | up to it | over: the console has no time left |

When something is over, the status bar says what, and the add-on **selects the faces it is about** (the section's
faces, or the faces with that texture), enters Edit Mode and zooms to them. Each problem in the box has a **Show**
button that does the same. The hill passes: course bytes about 413,000 / 288,000, VRAM fill 140,390 of 159,868,
at most 283 vertices in a section, draw load 894 of 2,908.

The same checks run at every A-Spec build, so the check is optional; it is the quick way to see the numbers.

### 5. Build

1. Save (**Ctrl+S**).
2. Click **Build edited course**.
3. The status bar says *Built ...* or tells you what to change; the full report is `build-log.txt` next to your
   .blend.

**Build for: Port** compiles your edit with `gt2-tools edit` against the course in your install, writes
`out/<course>-edit` and **`<course>.gt2patch`** next to your .blend, installs the mod `Edit_<course>` into `mods` and
turns it on in `mods/load-order.txt`. (An unchanged course writes no mod, and an older `Edit_<course>` is removed.)
The edited course **replaces** the original, so race it as usual: any race, license test or Machine Test on that
course. To race the original again, put `#` in front of `Edit_<course>` in `mods/load-order.txt`.

**Build for: A-Spec** runs the checks, builds a new A-Spec image, makes the patch and verifies it, then deletes the
image again. Nothing is installed in the port. The result is in `out\<course>-aspec\aspec\` next to your .blend:

```text
GT2-A-Spec-Edit_laguna.xdelta   the patch (the hill: 241,326 bytes)
GT2-A-Spec-Edit_laguna.cue      the cue sheet for the patched image
README.txt                      the base, result and patch hashes, how to apply it, where the course is driven
report.txt                      every check and step
check.json                      the findings (what the budget box shows)
```

guides/14-A-SPEC-PATCH.md says how to apply the patch and where to drive it. The build takes about a minute and a
half and needs about 1.3 GB free on the drive of your .blend while it runs (it checks first).

Before it writes anything, every build runs the game's own road tests on the result. If your edit leaves the road
in a state the original course did not have (a car could fall through, a section loses its road), it stops and says
where. Warnings that the original course has too (for example about its AI lines or replay positions) are listed in
the report and do not stop the build.

**Faces with library pictures (`lib:` materials)** are built from the **GT2 texture library** panel's
**Build (port)** or **Build (PS1)** buttons, not from **Build edited course** (guide 15). For an A-Spec patch with
library pictures, use the command line below with `--library`, or a new track (guide 16).

## Share an edit

**Port:** share the **`.gt2patch`** file, never the .blend or the `gt2-edit` folder. The patch holds only your
changes: moved positions, new faces with their material names, the faces you deleted. It contains no game data. It
names the original course file it was made from, by checksum.

**A-Spec:** share the `.xdelta`, the `.cue` and `README.txt` (guide 14). You can share the `.gt2patch` as well: a
player with the port builds it as a mod, and a player with A-Spec can build the patch from it themselves.

To use someone's `.gt2patch`, put it in the port folder and run:

```bat
gt2-tools.exe edit laguna laguna.gt2patch --out work\laguna-from-patch --mod Edit_laguna
xcopy /e /i work\laguna-from-patch\mods\Edit_laguna mods\Edit_laguna
echo Edit_laguna>> mods\load-order.txt
```

```sh
./gt2-tools edit laguna laguna.gt2patch --out work/laguna-from-patch --mod Edit_laguna
cp -r work/laguna-from-patch/mods/Edit_laguna mods/
echo Edit_laguna >> mods/load-order.txt
```

The result is identical to what the author built. A patch made from a different version of the course is refused
(`--force` applies it anyway, at your own risk). Add `--target aspec` to build an A-Spec patch from it instead.

## Without Blender

The same steps from the command line. The edit file is a `.glb` with the course's ids in vertex attributes
(`_GT2_SEC`, `_GT2_FACE`, `_GT2_CORNER`, ...); edit it in any tool that keeps them.

```bat
gt2-tools.exe course export laguna --edit --textures --out work\laguna-edit
gt2-tools.exe edit laguna work\laguna-edit\laguna.edit.glb --out work\laguna-edit-built --mod Edit_laguna --patch-out work\laguna.gt2patch
```

```sh
./gt2-tools course export laguna --edit --textures --out work/laguna-edit
./gt2-tools edit laguna work/laguna-edit/laguna.edit.glb --out work/laguna-edit-built --mod Edit_laguna --patch-out work/laguna.gt2patch
```

(Between the two commands you edit `work/laguna-edit/laguna.edit.glb`. `--textures` writes the texture pages into
`work/laguna-edit/textures`, linked from the `.glb`; leave it out for mesh only.) The mod is in
`work/laguna-edit-built/mods/Edit_laguna`; install it as above. And a patch from the command line:

```sh
./gt2-tools edit laguna work/laguna.gt2patch --out work/laguna-from-patch --mod Edit_laguna
```

The A-Spec build of the same edit (after `gt2-tools aspec setup`, guide 14):

```bat
gt2-tools.exe edit laguna work\laguna-edit\laguna.edit.glb --out work\laguna-aspec --mod MyLaguna --target aspec
```

```sh
./gt2-tools edit laguna work/laguna-edit/laguna.edit.glb --out work/laguna-aspec --mod MyLaguna --target aspec
```

It writes `work/laguna-aspec/aspec/GT2-A-Spec-MyLaguna.xdelta` and the files above. `--check-only` runs the checks
alone; `--json FILE` writes the findings. For one of the 8 courses A-Spec changed, export from the A-Spec setup:
`course export <course> --edit --textures --data aspec\data --out ...` (Linux: `--data aspec/data`).

More options: `--add NEWNAME` keeps the original and adds the edit as a new course, port only
(guides/11-COURSES-IN-MENUS.md gives it a menu entry); `--library DIR` lets faces use texture library pictures
(guide 15); `--target ps1` checks against the stock game without making a patch (guides/12-CONSOLE-SAFE.md).
`gt2-tools help edit` lists every option. How the edit file and the patch are laid out is in
`guides/reference/COURSE-EDIT.md`.
