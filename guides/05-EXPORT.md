# 5. Export courses and textures

`gt2-tools course export` opens GT2's course files from **your** install and writes them in open formats: JSON and
PNG you can edit, and glTF you can look at in Blender or any glTF viewer. Everything it writes is the game's data,
so keep it on your PC; do not share it.

Type the commands in a command window in the port folder (guides/04-TOOLS-SETUP.md).

## List the courses

```bat
gt2-tools.exe course list
```

```sh
./gt2-tools course list
```

This prints the game's 125 courses with their numbers, by file name (`2p_autumn`, ..., `laguna`, ...). The names
are what the other commands take.

## Export a course

```bat
gt2-tools.exe course export laguna --out work\laguna
```

```sh
./gt2-tools course export laguna --out work/laguna
```

Every course at once (each into `work/courses/<name>`; a few minutes):

```bat
gt2-tools.exe course export --all --out work\courses
```

```sh
./gt2-tools course export --all --out work/courses
```

You get:

```text
course.json          the course head: grid slots, sector splits, cameras, AI lines, texture and object tables
sections/NNN.json    one track section each: meshes, walls, collision grid, visibility list
models/NNN.json      one trackside object model each
textures/trp.json    the texture file: each image's palette (CLUT) and place in video memory
textures/NNN.png     each texture as an indexed PNG (its palette is the image's 16 colors)
info.json            the course's record: display name, sky, flags
view/<course>.gltf   a 3D view for Blender or a glTF viewer, with <course>.bin and pages/*.png
scene/               the sky, the parallax layers and the sprites as glTF views, with scene.json
```

Options: `--detail original|curves|dense` (the view's mesh: the game's polygons, or the remaster's smoothed or
densified ones), `--textures original|upscaled` (the view's pictures: the game's texels or the remaster's upscale),
`--no-gltf` (JSON and PNG only). The JSON layout, field by field, is in `guides/reference/COURSE-FORMAT.md`.

### Look at it in Blender

* The quickest look: the add-on's **GT2 course for reference** (GT2 Track panel, guides/07-BUILD-A-TRACK.md). It
  brings the course in mesh only, at true size, in its own collection.
* With textures: the add-on's **Edit a GT2 course** with **Show textures** (guides/08-EDIT-A-COURSE.md).
* The export's own `view` folder opens in Blender with File > Import > glTF 2.0, or in any glTF viewer. Keep it out
  of Blender projects you share.

## Edit the JSON and PNG, and put it back

**The glTF view is for looking only.** Editing it does not flow back into the course. To reshape a course in
Blender and race it, use guides/08-EDIT-A-COURSE.md. To repaint a texture, guides/06-RETEXTURE-A-COURSE.md is the
easy way.

You can also edit the **JSON and PNG** files directly:

* move a trackside object: change its `pos` in `course.json`;
* recolor faces: change their color words `c`;
* move a mesh's vertices in `sections/NNN.json`;
* repaint a texture: edit `textures/NNN.png`. Keep it indexed with the same 16 colors (an RGB PNG works if it uses
  only the palette's colors).

Then rebuild the course files:

```bat
gt2-tools.exe course import work\laguna --out work\laguna-built --gzip
```

```sh
./gt2-tools course import work/laguna --out work/laguna-built --gzip
```

This writes `laguna.tro`, `laguna.trp` and gzipped copies. To play them, put the gzipped copies in a mod at the
game's path and turn the mod on:

```bat
mkdir mods\MyLaguna\crsobj
copy work\laguna-built\laguna.tro.gz mods\MyLaguna\crsobj\
copy work\laguna-built\laguna.trp.gz mods\MyLaguna\crsobj\
echo MyLaguna>> mods\load-order.txt
```

```sh
mkdir -p mods/MyLaguna/crsobj
cp work/laguna-built/laguna.tro.gz work/laguna-built/laguna.trp.gz mods/MyLaguna/crsobj/
echo MyLaguna >> mods/load-order.txt
```

Unchanged, the rebuilt files are identical to the game's, byte for byte (we check all 125 courses). To add the
edited course as a **new** course instead of replacing the original, use `course add-course ... --tro ... --trp ...`
(guides/11-COURSES-IN-MENUS.md).

## The texture and sprite catalog

```bat
gt2-tools.exe course catalog --out work\catalog
```

```sh
./gt2-tools course catalog --out work/catalog
```

This takes a few seconds and catalogs every texture and sprite the game's courses use: road surfaces, kerbs,
grass, walls, buildings, trees, crowds, signs, skies and sponsor boards. Identical images used by several courses
are counted once (about 2,000 entries). `--courses laguna,seattle` limits it to some courses.

```text
index.html           open it in a browser: every image with its ID, size, the courses that use it, and its category
png/<id>.png         each image
catalogue.json       the same list as data: ID, size, category, courses, texture-page and CLUT placement
sources.json         where each entry comes from in each course
vram_union.json      which parts of video memory the courses use (shows the free space for new textures)
vram_occupancy.png   the same as a picture
```

Use it to find a texture for your own track, or to see how much video memory a course has left. The limits on
textures (4-bit, 16 colors, size and placement) are in `guides/reference/LIMITS.md`.
