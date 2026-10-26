# 3. Export courses and textures

`gt2-course.exe` opens GT2's course files from **your** install (`data\gt2vol`) and writes them in open formats:
JSON and PNG you can edit, and glTF you can look at in Blender. Everything it writes is the game's data, so keep
it on your PC; do not share it.

Type the commands in a command prompt opened in the port folder.

## List the courses

```text
gt2-course.exe list --data data\gt2vol
```

This prints the game's 125 courses by file name, in the game's course order (`laguna`, `seattle`,
`TC_lisence`, ...). The names are what the other commands take.

## Export a course

```text
gt2-course.exe export laguna --data data\gt2vol --out work\laguna
gt2-course.exe export --all --data data\gt2vol --out work\courses        (every course: work\courses\<name>)
```

You get:

```text
course.json          the course head: grid slots, sector splits, cameras, AI lines, texture and object tables
sections\NNN.json    one track section each: meshes, walls, collision grid, visibility list
models\NNN.json      one trackside object model each
textures\trp.json    the texture file: each image's palette (CLUT) and place in video memory
textures\NNN.png     each texture as an indexed PNG (its palette is the image's 16 colours)
view\<course>.gltf   a 3D view for Blender, with <course>.bin and pages\*.png
info.json            the course's record: display name, sky, flags
```

The JSON layout, field by field, is in `guides\reference\COURSE-FORMAT.md`.

### Look at it in Blender

Use the add-on: GT2 tab > **GT2 course for reference** > pick a course > **Add** (guides\04-BUILD-A-TRACK.md). It
brings the course in **mesh only**: geometry at true size, every material keeping its name (the reference to the
game's texture), shown in flat colours. No game textures go into your Blender files; that is the kit's rule, so a
.blend never carries the game's pictures. You get six groups: `track` (road and scenery meshes), `track_low` (the
mirror's low-detail meshes), `objects` (trackside objects), `collision` (the faces the cars drive on, by surface,
walls as yellow lines), `ai_lines` and `markers` (start point and grid). Units are metres; the top view looks like
the in-game minimap.

The export's own `view\` folder is a textured preview for any glTF viewer; keep it out of your Blender projects.

## Edit a course and put it back

**The glTF view is for looking only.** Editing it in Blender does not flow back into the course. To reshape a
course's mesh in Blender and race it, use the edit export instead (`gt2-course.exe export NAME --edit`, or the
add-on's **Edit a GT2 course** panel): guides\07-EDIT-A-COURSE.md.

You can also edit the **JSON and PNG** files directly:

* move a trackside object: change its `pos` in `course.json`;
* recolour faces: change their colour words `c`;
* move a mesh's vertices in `sections\NNN.json`;
* repaint a texture: edit `textures\NNN.png`. Keep it indexed with the same 16 colours (an RGB PNG works if it
  uses only the palette's colours).

Then rebuild the course files:

```text
gt2-course.exe import work\laguna --out work\laguna-built --gzip
```

This writes `laguna.tro`, `laguna.trp` and gzipped copies. To play them, put the gzipped copies in a mod at the
game's path, `mods\MyLaguna\crsobj\laguna.tro.gz` and `laguna.trp.gz`, and turn it on in `mods\load-order.txt`.
To add the edited course as a **new** course instead of replacing the original, use `gt2-course.exe add-course
... --tro ... --trp ...` (guides\06-COURSES-IN-MENUS.md).

`gt2-course.exe roundtrip --all --data data\gt2vol --work work\rt` exports and re-imports every course and checks
that the result is identical to the original, byte for byte. All 125 courses pass.

## The texture and sprite catalogue

```text
gt2-course.exe textures --vol data\gt2vol --out work\textures
```

This takes a few seconds and catalogues every texture and sprite the game's courses use: road surfaces, kerbs,
grass, walls, buildings, trees, crowds, signs, skies and sponsor boards. Identical images used by several courses
are counted once (about 2,000 entries).

```text
index.html           open it in a browser: every image with its ID, size, the courses that use it, its real-world
                     size in metres, and its category
png\<id>.png         each image
catalogue.json       the same list as data: ID, size, category, courses, texture-page/CLUT placement
sources.json         where each entry comes from in each course
vram_union.json      which parts of video memory the courses use (shows the free space for new textures)
vram_occupancy.png   the same as a picture
```

Use it to find a texture for your own track, or to see how much video memory a course has left. The limits on
textures (4-bit, 16 colours, size and placement) are in `guides\reference\LIMITS.md`.
