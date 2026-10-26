# Course edits: the edit file, the build, the patch

How `gt2-course.exe export --edit`, the add-on's **Edit a GT2 course** panel and `gt2-scenec.exe course` work
together (guide: guides\07-EDIT-A-COURSE.md). The rule throughout: Blender holds meshes and names only, never the
game's pictures.

## The edit file (`NAME.edit.glb`)

* **Holds** geometry and names only: no images, textures or texture links.
* **Nodes:** `gt2_track` (the high-detail section meshes: the main view and the road) and `gt2_track_low` (the
  mirror's meshes).
* **Materials:** one primitive per material name. `tex:NNNN` is a face that uses entry NNNN of the course's
  texture table (its picture, UVs and palette come from your install at build time); `untex` is an untextured face.
* **Positions:** course meters, world space, the course's axes. Exact: a vertex is 64·k + a/64 m, which a float32
  holds exactly.
* **Faces:** each face has its own vertices and is split into the triangles (0,1,2) and (0,2,3) in its stored
  corner order. Each vertex carries these float32 attributes (all values below 2^24, so exact):

| Attribute | Meaning |
|---|---|
| `_GT2_SEC` | section + 1, plus 32768 on the low mesh; 0 = a new face |
| `_GT2_FACE` | 1 + list·65536 + index (lists f3 f4 g3 g4 ft3 ft4 gt3 gt4); 0 = new |
| `_GT2_CORNER` | the stored corner, 0..3 |
| `_GT2_RGB` | the corner colour, 0xBBGGRR |
| `_GT2_CODE` | the GPU code byte (the first colour word) |
| `_GT2_SURF` `_GT2_SHADE` `_GT2_ZONE` `_GT2_SORT` `_GT2_CULL` | surface, shade class, zone; sort bias, cull |
| `_GT2_COLL` | 1 when the section's collision grid lists the face |

A few bits that have no use in editing (some flag bits, the unused fourth index of triangles, the high bytes of the
later colour words) are not exported; the build takes them from the original face, by its id.

In Blender, the add-on reads the file itself rather than through Blender's glTF importer. Vertices at the same
position are welded (across sections too), quads stay quads, and the attributes become face and corner attributes.
Two faces over the same corners (the two sides of a double-sided wall) keep separate vertices, because Blender's
exporter would delete one of them.

## The build (`gt2-scenec.exe course`)

```text
gt2-scenec.exe course --original GT2VOL --course NAME (--edited EDITED.glb | --patch-in FILE.gt2patch) --out DIR
                      [--mod NAME] [--add NEWNAME] [--patch-out FILE.gt2patch] [--force] [--target ps1|port]
```

It runs in two steps. **diff** compares the edited file with the original course and keeps only your changes;
**apply** puts those changes on the original. `--edited` runs both, `--patch-in` only the second, so both give the
same bytes.

* **Matching.** A face whose id names an original face, with the same number of corners, is that face.
* **Positions** are rounded to the section's vertex unit (1/64 m), so an untouched vertex comes back as its own
  value. When the corners sharing a vertex were moved apart, the vertex is split.
* **Deleted faces** (missing from the file) are removed and the lists renumbered. **New faces** go to the section
  that holds their centre and reuse a section vertex where one sits at the corner. A new face the cars drive on is
  wound the way the game's point test needs.
* **Unchanged sections** are written as the original bytes. **Changed sections** get their collision grid cells,
  wall normals, culling boxes and radius recomputed. Section planes, distances and visibility lists are kept: the
  road keeps its route.
* **What follows the road.** Things that are not road vertices move with the road under them (the mean of the 4
  nearest road vertices within about 32 m): the mirror mesh (unless you edited it), billboards, lamp glows,
  trackside objects. The start grid and the AI lines follow the road; an AI node's heading and arc are re-fitted to
  the moved line.
* **Check.** gt2-trackc's validator (the game's road tests) runs on the result. More errors than the original
  course has stops the build.
* **Output.** By default the mod replaces the course: `mods\MOD\crsobj\NAME.tro.gz`. With `--add NEW` the edit is
  added as a new course with a copy of the original's course record and minimap.

New faces need a material: `tex:NNNN` (from this course), `untex`, or a surface name (`tarmac`, `kerb`, `grass`,
`gravel`, `offroad`, `dirt`: the course's most used texture of that surface, and a face the cars drive on).

## The patch (`.gt2patch`)

* JSON, one change per line; `format: "gt2-course-patch"`, `version: 1`.
* `base_tro_sha256` names the original `.tro`. `--patch-in` refuses another base unless `--force` is given.
* Changes: `moved` [mesh, section, vertex, x, z, height] in vertex units; `new_vertices`; `repoint` (a face corner
  moved to another vertex); `changed` (a face id and its new values); `deleted` (face ids); `added` (a section, the
  corners, a material name, the values, and an optional `from` face whose look it copies).
* It holds no game data beyond ids: the positions are yours and the textures are names. Another player applies it
  to the course from their own install.

## Console-safe (`--target ps1`)

Checks a replacing edit against what an unmodified PlayStation can run; see guides\08-CONSOLE-SAFE.md and the
limits in LIMITS.md.

## Known limits

* Nothing re-optimises a section: new faces are appended, and a section is not split at 512 vertices (the build
  stops instead).
* A road moved across a section's boundary keeps the old boundaries. Re-routing is not supported.
* Only this course's own textures can be used on new faces.
* Trackside objects are not in the edit file; they follow the road.
