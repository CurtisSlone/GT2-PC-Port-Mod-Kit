# 7. Edit an existing course in Blender

Open one of GT2's own courses in Blender, reshape it, and race the result: widen a corner, add a crest, move a wall,
delete or add faces. The course comes in as a bare mesh. When you build, the parts you did not touch keep the
game's own data byte for byte, and only what you changed is recomputed.

**What this does and does not do (read first):**

* You can **move vertices, delete faces, add faces**, and change a face's material or surface. The road stays on
  its original route: the course's sections, its lap distance, the replay cameras and the AI cars' line are
  kept, and things near the road (the mirror's mesh, trackside objects, the start grid, the AI line) follow your
  changes.
* You cannot **re-route** the road yet. A road moved far from its original line, for example across into the next
  section, keeps the old section boundaries, and the game will place the car oddly there. Small and medium
  reshapes are fine; a new layout is a new track (guides\04-BUILD-A-TRACK.md).
* New faces can use **this course's own textures** (by number) or a surface name. Textures from other courses and
  your own new art are not supported in edits yet.
* Trackside objects (trees, grandstands, gantries) are not in the edit file. They follow the road, but you cannot
  move them one by one.

## 0. Set up (once)

The same as guides\04-BUILD-A-TRACK.md, step 0: Blender 4.2 or newer, `kit\setup-kit.bat`, and the add-on's
**Port folder** set to this port folder.

## 1. Bring a course in

1. In Blender, save a new empty file first (**Ctrl+S**), for example `Documents\GT2 edits\laguna-edit.blend`.
   The build files are written next to it.
2. Press **N**, open the **GT2** tab, and open the panel **Edit a GT2 course**.
3. Pick a course in the list (the game's file names: `laguna`, `seattle`, `TC_lisence`, ...) and click **Edit**.

After a few seconds the course is in the scene as two objects: `gt2_track` (the road and scenery you see when
driving) and `gt2_track_low` (the mirror's simpler copy; you can leave it alone, it follows the main mesh). It is
**mesh only**: no game pictures go into Blender. Faces show flat colours by their material name; the name is the
reference to the game's texture, for example `tex:0042`.

This .blend contains the game's course geometry. Keep it for yourself; do not share it (step 4 shares the safe
way).

## 2. Edit

Select `gt2_track`, press **Tab** for Edit Mode, and work as usual: **G** to move, **X** to delete, **E** to
extrude, **F** to fill a face. Some rules:

* **Moving vertices** is the common edit. Use proportional editing (**O**) for smooth changes: a corner widened by
  a few meters, a crest of a meter or two.
* **New faces need a material.** Give each new face one of the course's existing material slots (`tex:NNNN`,
  copied from a nearby face of the same kind), `untex` (a plain coloured face), or one of these surface names, which
  also make it a face the cars drive on: `tarmac`, `kerb`, `grass`, `gravel`, `offroad`, `dirt`. A new face without
  a material is an error at build time, with its position.
* **Extrude and duplicate** copy the original face's look and settings, so the new faces need nothing more.
* **Keep each part of the course light.** A section of track may hold at most 512 vertices (the PlayStation's
  limit, which GT2's code relies on). Adding a lot of detail in one place fails the build with the section's
  number.
* Edit `gt2_track_low` only if you want the mirror to differ; otherwise it follows `gt2_track`.

## 3. Build and race

1. Save (**Ctrl+S**).
2. In the panel, click **Build edited course**.
3. The status bar says *Built ...* or tells you what to change; the full report is `build-log.txt` next to your
   .blend.

The build writes, next to your .blend: `out\<course>-edit\` and `<course>.gt2patch`. It installs the mod
`Edit_<course>` into `mods\` and turns it on in `mods\load-order.txt`. The edited course **replaces** the
original, so race it as usual: any race, licence test or Machine Test on that course. To race the original again,
put `#` in front of `Edit_<course>` in `mods\load-order.txt`.

Before it writes anything, the build runs the game's own road tests on the result. If your edit leaves the road
in a state the original course did not have (a car could fall through, a section loses its road), it stops and
says where.

## 4. Share an edit

Share the **`.gt2patch`** file, never the .blend. The patch holds only your changes: moved positions, new faces with
their material names, and the faces you deleted. It contains no game data, so it is safe to post. It names the
original course file it was made from, by checksum.

To use someone's patch (the command-line tools are in the port folder):

```text
gt2-scenec.exe course --original data\gt2vol --course laguna --patch-in laguna.gt2patch --out work\laguna-edit --mod Edit_laguna
xcopy /e /i work\laguna-edit\mods\Edit_laguna mods\Edit_laguna
    then add the line Edit_laguna to mods\load-order.txt
```

The result is identical to what the author built. A patch made from a different version of the course is refused
(`--force` applies it anyway, at your own risk).

## Without Blender

The same steps from the command line:

```text
gt2-course.exe export laguna --edit --data data\gt2vol --out work\laguna      (writes work\laguna\laguna.edit.glb)
    edit laguna.edit.glb in any tool that keeps its vertex attributes (_GT2_SEC, _GT2_FACE, _GT2_CORNER, ...)
gt2-scenec.exe course --original data\gt2vol --course laguna --edited laguna.edit.glb --out work\laguna-edit --mod Edit_laguna --patch-out laguna.gt2patch
```

`gt2-scenec.exe --help` lists every option, including `--add NEWNAME` (keep the original and add the edit
as a new course; see guides\06-COURSES-IN-MENUS.md for giving it a menu entry). How the edit file and the patch are
laid out is in `guides\reference\COURSE-EDIT.md`.

## For PlayStation and emulator mods

An edit that **replaces** a course can also be checked against what an unmodified PlayStation can run: add
`--target ps1` to the `gt2-scenec.exe course` command. See guides\08-CONSOLE-SAFE.md.
