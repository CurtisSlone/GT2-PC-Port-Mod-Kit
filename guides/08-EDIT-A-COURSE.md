# 8. Edit a course in Blender

Open one of GT2's own courses in Blender, with its textures, reshape it, and race the result: widen a corner, add a
crest, move a wall, delete or add faces, put another of the course's textures on some faces. When you build, the
parts you did not touch keep the game's own data byte for byte, and only what you changed is recomputed. You share
the result as a small `.gt2patch` that holds only your changes.

**What this does and does not do (read first):**

* You can **move vertices, delete faces, add faces**, and change a face's texture or surface. The road stays on its
  original route: the course's sections, its lap distance, the replay cameras and the AI cars' line are kept, and
  things near the road (the mirror's mesh, trackside objects, the start grid, the AI line) follow your changes.
* You cannot **re-route** the road yet. A road moved far from its original line, for example across into the next
  section, keeps the old section boundaries, and the game will place the car oddly there. Small and medium reshapes
  are fine; a new layout is a new track (guides/07-BUILD-A-TRACK.md).
* Faces can use **this course's own textures** (any of them, by number) or a surface name. Textures from other
  courses are not supported. To paint your own pictures onto the course, retexture it
  (guides/06-RETEXTURE-A-COURSE.md); a retexture and an edit of the same course work together.
* Trackside objects (trees, grandstands, gantries) are not in the edit file. They follow the road, but you cannot
  move them one by one.
* **Share the `.gt2patch`, never the .blend or the textures folder.** The textures are GT2's own pictures, made from
  your install. The .blend links to them and never holds them.

## In Blender

Set up the add-on first (guides/04-TOOLS-SETUP.md).

### 1. Bring a course in

1. Save a new empty file first (**Ctrl+S**), for example `Documents\GT2 edits\laguna-edit.blend` (Linux:
   `~/GT2 edits/laguna-edit.blend`). The course files are written next to it.
2. Press **N**, open the **GT2** tab, and the panel **Edit a GT2 course**.
3. Pick a course in the list (the game's file names: `laguna`, `seattle`, ...), leave **Show textures** on, and click
   **Edit**.

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

* **Moving vertices** is the common edit. Use proportional editing (**O**) for smooth changes: a corner widened by a
  few meters, a crest of a meter or two.
* **New faces need a material.** Give each new face one of the course's `tex:NNNN` materials (the picker below
  does that), `untex` (a plain colored face), or one of these surface names, which also make it a face the cars
  drive on: `tarmac`, `kerb`, `grass`, `gravel`, `offroad`, `dirt`. A new face without a material is an error at
  build time, with its position.
* **Extrude and duplicate** copy the original face's look and settings, so the new faces need nothing more.
* **Keep each part of the course light.** A section of track may hold at most 512 vertices (the PlayStation's
  limit, which GT2's code relies on). Adding a lot of detail in one place fails the build with the section's number.
* Edit `gt2_track_low` only if you want the mirror to differ; otherwise it follows `gt2_track`.

### 3. Change a face's texture

1. In Edit Mode, select the faces.
2. In the panel, pick a texture: the picture grid, **Find** by number, or **From face** (takes the active face's).
   The picker offers every texture of the course, not only the ones you can see.
3. Click **Apply to selected faces**. The faces get that texture's material `tex:NNNN` and its texture
   coordinates, so Blender shows them as the game will.

### 4. Build and race

1. Save (**Ctrl+S**).
2. In the panel, click **Build edited course**.
3. The status bar says *Built ...* or tells you what to change; the full report is `build-log.txt` next to your
   .blend.

The build compiles your edit with `gt2-tools edit` against the course in your install, writes `out/<course>-edit`
and **`<course>.gt2patch`** next to your .blend, installs the mod `Edit_<course>` into `mods` and turns it on in
`mods/load-order.txt`. (An unchanged course writes no mod, and an older `Edit_<course>` is removed.) The edited
course **replaces** the original, so race it as usual: any race, license test or Machine Test on that course. To
race the original again, put `#` in front of `Edit_<course>` in `mods/load-order.txt`.

Before it writes anything, the build runs the game's own road tests on the result. If your edit leaves the road in
a state the original course did not have (a car could fall through, a section loses its road), it stops and says
where. Warnings that the original course has too (for example about its AI lines or replay positions) are listed in
the report and do not stop the build.

## Share an edit

Share the **`.gt2patch`** file, never the .blend or the `gt2-edit` folder. The patch holds only your changes: moved
positions, new faces with their material names, the faces you deleted. It contains no game data. It names the
original course file it was made from, by checksum.

To use someone's patch, put it in the port folder and run:

```bat
gt2-tools.exe edit laguna laguna.gt2patch --out work\laguna-from-patch --mod Edit_laguna
xcopy /e /i work\laguna-from-patch\mods\Edit_laguna mods\Edit_laguna
echo Edit_laguna>> mods\load-order.txt
```

```text
./gt2-tools edit laguna laguna.gt2patch --out work/laguna-from-patch --mod Edit_laguna
cp -r work/laguna-from-patch/mods/Edit_laguna mods/
echo Edit_laguna >> mods/load-order.txt
```

The result is identical to what the author built. A patch made from a different version of the course is refused
(`--force` applies it anyway, at your own risk).

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

`--add NEWNAME` keeps the original and adds the edit as a new course (guides/11-COURSES-IN-MENUS.md gives it a menu
entry). `gt2-tools help edit` lists every option. How the edit file and the patch are laid out is in
`guides/reference/COURSE-EDIT.md`.

## For PlayStation and emulator mods

An edit that **replaces** a course can also be checked against what an unmodified PlayStation can run: add
`--target ps1` to the `gt2-tools edit` command. See guides/12-CONSOLE-SAFE.md.
