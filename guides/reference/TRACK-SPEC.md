# gt2-trackc spec reference

`gt2-trackc.exe` compiles a short JSON description of a track (a center line plus a few profiles) into a complete
GT2 course: the `.tro` and `.trp` files, the minimap, the course's `.crsinfo` record, as a mods folder. Then it runs
a validator that replays the game's own road tests on what it wrote. The output is data only; nothing in the game
code changes. No game art is used: textures and the minimap are generated.

This page lists every input field, its default, the scenery pieces, open (point-to-point) courses and the checks
with their messages. The Blender steps (drawing the center line, the add-on, export settings, installing the mod)
are in [04-BUILD-A-TRACK.md](../04-BUILD-A-TRACK.md) and are not repeated here. The file format the compiler writes
is [COURSE-FORMAT.md](COURSE-FORMAT.md); the limits are summarised in [LIMITS.md](LIMITS.md).

Tracks added under their own name run **only in this port** (they need its archive extension and 8 MB of RAM).

## Commands

```text
gt2-trackc.exe compile INPUT --out DIR [--data DIR] [--mod NAME] [--add NAME] [--name "Display"] [--gltf] [--force]
                    INPUT: SPEC.json, or a .glb/.gltf/.csv center line compiled with the defaults
gt2-trackc.exe import INPUT --out SPEC.json [--name "Display"]     the center-line file as an explicit spec
gt2-trackc.exe splice A B --out NEW.json [--cut-a 0.5] [--cut-b 0.5] [--mirror auto|yes|no] [--name "Display"] [--add NAME] [--data DIR]
                    a new circuit: the first half of A and the second half of B, joined (guides\09-EXAMPLE-SPLICE.md)
gt2-trackc.exe check <course>... --data DIR                        validate courses of the game
gt2-trackc.exe check DIR --slot STEM                               validate DIR\STEM.tro + .trp
gt2-trackc.exe decompose <course> --data DIR --out SPEC.json [--section-length M]
gt2-trackc.exe selftest <course>... --data DIR --work DIR          decompose, recompile, compare
```

* `--data data\gt2vol`: the unpacked archive. The compiler reads the game's `.crsinfo`, the replaced slot's original
  files (sizes, gzip headers, which VRAM its `.trp` uses) and the sky's `.bsp`. Without `--data` only
  `<course>.tro` and `<course>.trp` are written, and scenery textures may use the whole course VRAM region.
* `--mod NAME`: the mods folder's name (`DIR\mods\NAME\`).
* `--add NAME`: add a new course (same as the spec's `add`). `--name`: the display name.
* `--gltf`: also write `DIR\export\` (the `gt2-course` JSON + glTF view of the compiled course, to look at in
  Blender: road, walls, AI line).
* `--force`: compile even when the checks refuse (to look at a half-made track; the validator may then report real
  errors).

`compile` writes `DIR\<course>.tro`, `DIR\<course>.trp`, `DIR\report.txt` (everything it printed) and, with
`--data`, the mods folder:

| Mode | Files in `DIR\mods\NAME\` |
|---|---|
| **add** (`"add": "zz_mytrack"`) | `crsobj\zz_mytrack.tro.gz`, `.trp.gz`; `crsmap\zz_mytrack.tim.gz` (the minimap); `.crsinfo` = the game's table with your record **appended** (index = the old count, 125 on the disc) |
| **replace** (no `add`; `"slot"`, default `laguna2`) | `crsobj\<slot>.tro.gz`, `.trp.gz` kept within the original members' sizes when they fit (so the disc layout stays the same), else written plain; `crsmap\<slot>.tim.gz`; `.crsinfo` with the slot's record changed |

In add mode an existing `.crsinfo` already in the mods folder is extended, so several courses can share one folder
(compile them with the same `--out` and `--mod`; each new name must sort after the previous one). A course already
in it is updated in place.

## Naming a new course (`add`)

* The name must sort **after `testline`** (the game's last course) in plain byte order, and after any course already
  added in the folder: start it with `u`-`z` in lower case, e.g. `zz_mytrack`. Upper-case letters sort before
  lower case, so `Mytrack` is refused.
* 1-17 characters: letters, digits, `_`, `-`.
* The course becomes number 125, then 126, 127. The memory card keeps records for 128 courses in all.
* Run it with `psx-play.exe --course zz_mytrack`, or point a GT-mode event at it (guides 04 and 02).

## The input

Units are meters and degrees. The **map frame** is the course seen from above, as on the minimap: x east, y north.
Headings are counter-clockwise from east; a positive arc angle turns left. A spec written by hand:

```json
{
  "name": "Test Oval",
  "add": "zz_oval",
  "start": {"x": 0, "y": 0, "heading": 0},
  "path": [
    {"straight": 125},
    {"arc": {"radius": 90, "angle": 180}},
    {"straight": 250},
    {"arc": {"radius": 90, "angle": 180}},
    {"straight": 125}
  ],
  "width": 14,
  "kerb": {"width": 1.0, "surface": "kerb"},
  "verge": {"width": 5.0, "surface": "grass"},
  "wall": {"height": 1.2},
  "grid": {"slots": 8, "first": 10, "spacing": 9, "stagger": 3},
  "course_info": {"display_name": "Test Oval"}
}
```

A spec for a center line drawn in Blender is shorter: `"import": "track.glb"` replaces `start` and `path`.

### Fields

| Field | Default | Meaning |
|---|---|---|
| `name` | | the course's name (the display name unless `course_info.display_name` is given) |
| `add` | | add the course as a **new** course of this name (above). Leave it out to replace `slot` |
| `slot` | `laguna2` | in replace mode, the course whose files are replaced. `laguna2` is used by no event of the game |
| `import` | | the center line from a file, relative to the spec: `"track.glb"` (Blender glTF export of a line; `.gltf` too) or `"track.csv"` (`x,y,z[,width[,bank]]` per line, a header line allowed, x east, y north, z up; the last line joins the first). Long form: `{"file", "object", "reverse", "start_near": [x, y], "flat", "width_attr", "bank_attr", "scale"}`. Fills `points`, `elevation` (the points' heights, unless `flat`), and `width` / `banking` from the vertex attributes `_width` (meters) and `_bank` (degrees) when present; an Empty named `Start` marks the start line |
| `open` | | `true`, or `{"runup": m, "runoff": m}`: a point-to-point course (section "Open courses") |
| `start` | (0, 0), 0 | the start/finish line: where `path` begins, and its heading |
| `path` | | the center line as `{"straight": L}` and `{"arc": {"radius": R, "angle": A}}` steps. It must close on the start; a gap up to 5 m / 5 degrees is spread along the lap and reported |
| `points` | | instead of `path`: control points `[x, y]` of a closed smooth spline (centripetal Catmull-Rom) |
| `recenter` | `true` | move the course so its center line's bounds are centered on the origin (the minimap's frame is fixed there) |
| `width` | 12 | road width between the kerbs, meters (3-60). A number; or keys `[[s, value], ...]` (s = meters along the lap from the start line) eased between keys; or `{"cubic": [[s, value], ...]}` (a smooth curve through dense keys, no overshoot; what `import` writes). `elevation` and `banking` take the same forms |
| `elevation` | 0 | road height, meters |
| `banking` | 0 | roll in degrees; positive raises the right edge (bank a left turn with positive values) |
| `auto_bank` | 0 | extra banking into every turn: degrees at the tightest turn, proportional to the curvature (smoothed over +/-20 m) |
| `lanes` | 3 | road strips across (one texture tile each) |
| `kerb` | 1 m, `kerb` | `{"width", "surface"}`: strip outside each road edge |
| `verge` | 6 m, `grass` | `{"width", "surface"}`: run-off between kerb and wall |
| `wall` | 1.2 m, both sides | `{"height", "left", "right"}`: barriers at the verges' outer edges |
| `apron` | 40 m | `{"width"}`: ground beyond the walls, drawn only (no collision). Use 0 where the track crosses itself |
| `section_length` | 16 | track section length, meters (the unit of collision, drawing and visibility) |
| `row_length` | 4 | meters between cross-sections inside a section |
| `grid` | 8 slots, 8 m, 8 m, 2.5 m | `{"slots", "first", "spacing", "stagger"}`: start grid behind the line (first slot `first` m back, then every `spacing` m), alternating right/left by +/-`stagger` m |
| `racing_line` | center, 2, 24, 3 | `{"mode", "margin", "knot", "passing"}`: `mode` `center` (the center line) or `smooth` (an elastic band pulled tight inside the road edges less `margin` m); `knot` m between fitted pieces for spline input; `passing` m to each side for the two passing lines |
| `visibility` | 60 m | `{"distance"}`: sections whose bounds come within this distance of each other see each other (are drawn). 60 m stays within the draw load of the game's own courses; the validator warns when the load is above every shipped course (the game slows down) |
| `cameras` | 150, 6, 6 | `{"spacing", "offset", "height"}`: replay cameras every `spacing` m, `offset` m outside the turn, `height` m up |
| `course_info` | flags 0x40 | `{"flags", "sky", "sky_from", "lighting_from", "display_name"}` for the `.crsinfo` record. `sky` is a sky index; `sky_from` / `lighting_from` name a course to copy the sky / car lighting from (default `laguna2`). `display_name`: the name on the race pages (up to 31 characters). Default flags: 0x40 (no sponsor boards); 0x00 when a `sponsor_board` piece is placed; 0x60 for open courses |
| `scenery` | none | trackside objects (section "Scenery") |
| `scenery_budget` | 4000, 300, 128, 32 | `{"faces", "instances", "texture_size", "zones"}`: total model faces and instances over which the compiler refuses, the largest texture side after downscaling (at most 256), and the number of visibility zones along the lap |

**Surfaces** (for `kerb.surface`, `verge.surface`): `tarmac` (0), `kerb` (1), `grass` (2), `gravel` or `sand` (3),
`offroad` (4), `dirt` (5). These are the game's surface codes, read per wheel by the physics (COURSE-FORMAT.md 2.6).

**Cross-section**, left to right: apron edge, wall top, wall base, verge, kerb, lanes, kerb, verge, wall base, wall
top, apron edge. Banking tilts the whole cross-section. On the inside of a turn tighter than the cross-section, the
inside parts are squeezed toward the center line so faces never fold.

## What the compiler builds

| Structure | How |
|---|---|
| Sections | the lap cut into `round(length / section_length)` equal sections (at most 16,383), each with rows of quads every `row_length` m. Vertices on the game's 1/64 m grid; neighbouring sections share their boundary points exactly (no cracks). At most 512 vertices per section |
| Faces | textured quads, back-face culled |
| Collision | the ground faces (road, kerb, verge) in each section's 4x4 collision grid; the wall bases as wall segments |
| Visibility | every section within `visibility.distance`, nearest first, at most 256 per section. No occlusion |
| Racing line | kind 6, fitted as straights and arcs (exact for `path` input); pieces flatter than 2.5 km radius written as straights. Passing lines = the racing line +/-`passing` m, kept 1 m inside the road |
| Start grid | `grid.slots` points behind the line, 0.25 m above the road (the game drops the car onto it) |
| Sector splits | 3, at 1/4, 1/2, 3/4 of the lap |
| Replay cameras | fixed tracking cameras outside the turns, one set for lap 0 and one for later laps |
| Textures | 8 generated 64x64 4-bit tiles (asphalt, kerb, grass, wall, start line, gravel, dirt, marking), placed inside the VRAM area the replaced slot's own `.trp` uses |
| Minimap | 96x96 4-bit, the center line as a white line in the game's fixed map frame (about 25 m a pixel, origin at the center) |
| `.crsinfo` record | flags, sky, car lighting, display name as given |

Not generated yet: pit lane and pit lines (AI kinds 3 and 4), the side-selector line (5), occlusion in the
visibility lists, half-size texture levels (level 1 = level 0), several LOD levels per model, a ground under the
whole course (the apron is per section).

## Scenery

`scenery` is a list of items. Each item is either a **glTF model** (`"gltf": "models\\tower.glb"`) or a **library
piece** generated by the compiler (`"piece": "tree"`), plus a placement.

```json
"scenery": [
  {"piece": "grandstand", "name": "main stand", "length": 80, "rows": 10, "along": {"s": 60, "side": "right", "offset": 4}},
  {"piece": "gantry", "along": {"s": 30, "lateral": 0}, "facing": "none", "heading": 90},
  {"piece": "sponsor_board", "set": 0, "width": 6, "repeat": {"from": 150, "to": 400, "every": 30, "side": "right", "offset": 2}},
  {"piece": "barrier", "length": 10, "repeat": {"from": 0, "every": 10, "side": "both", "offset": 0.6}},
  {"piece": "lamp", "height": 9, "repeat": {"from": 5, "every": 45, "side": "both", "offset": 1.5}},
  {"piece": "tree", "variants": 3, "height": 10, "repeat": {"every": 14, "side": "both", "offset": 10, "jitter": 5}},
  {"gltf": "models/tower.glb", "at": {"x": 120, "y": -40, "height": 0}, "heading": 45, "lod": 600, "always": true}
]
```

### glTF models

glTF 2.0 / GLB, relative to the spec, meters, PNG textures. Read: node hierarchies, triangle strips and fans, vertex
colours (`COLOR_0`), `baseColorFactor` / `baseColorTexture`, `doubleSided`, `alphaMode` and
`KHR_texture_transform`. Refused: sparse accessors, Draco compression, JPEG textures. Models take no lighting in the
game (the game's own models are pre-shaded), so put the shading in vertex colours or the base colour.

### Library pieces

| Piece | Parameters (meters) and defaults | What |
|---|---|---|
| `tree` | `height` 9, `width`, `variants` 3, `variant` | billboard sprites the game turns to the camera, three leaf colours |
| `grandstand` | `length` 40, `depth` 12, `rows` 8, `height` | stepped seating with a crowd texture, risers, sides, back wall, roof on columns |
| `barrier` | `length` 10, `height` 1, `variant` 0 tyres / 1 armco | a low wall in 2.5 m (tyres) or 5 m (armco) segments. Drawn only: the collision walls are the track's |
| `billboard` | `width` 8, `height`, `depth` 2 (height of the lower edge), `image` (a PNG) | a sign on two posts; without `image` a red and white pattern |
| `sponsor_board` | `set` 0-4, `slot`, `width` 6, `height` | a board showing one of the game's own sponsor-board slots: the game paints a random sponsor into it every race |
| `lamp` | `height` 8, `colour` `"0xBBGGRR"` (default 0x89E7FF, warm white), `glow` 140 | a post with an arm and head, and a glow the game draws as an additive flare, also from far away |
| `gantry` | `width` (the road's), `height` 7 | two pillars and a beam across the road; place it with `along` + `"lateral": 0`, `"facing": "none"`, `"heading": 90` |
| `box` | `width` 4, `depth` 4, `height` 3, `colour` | a textured block (buildings, test objects) |

### Item fields

| Field | Default | Meaning |
|---|---|---|
| `name` | | a label for the report |
| `at` | | `{"x", "y", "height"}`: a fixed place in map meters (x east, y north, height above the start) |
| `along` | | `{"s", "side", "offset", "up"}`: `s` m from the start line, `side` left/right, `offset` m outward from the wall line (follows the road's width), `up` m. Or `lateral`: signed meters from the center line (negative = left) |
| `repeat` | | `{"from", "to", "every", "side", "offset", "up", "jitter"}`: one every `every` m from `from` to `to` (default a whole lap), `side` left/right/both (default both); `jitter` moves each randomly along and outward by up to that many meters. A repeat cycles through the piece's variants |
| `seed` | | changes the `jitter` pattern |
| `heading` | 0 | degrees. With `at`: counter-clockwise from east (0 = unrotated, front facing north). With `along` / `repeat`: relative to the direction of travel |
| `facing` | `track` for pieces, `none` for glTF | `track` turns the front (-z of the model) toward the center line, `away` away from it, `none` uses `heading` as given |
| `scale` | 1 | scales the model |
| `cull` | true | `false` draws both sides of every face |
| `lod` | 450 | meters beyond which the object is not drawn (one LOD level per model) |
| `always` | false | `true` draws the instance from everywhere (the game's always-drawn group) instead of by zone |
| `max_faces` | 800 | an item with more triangles is simplified (vertex clustering) until it fits |
| `decimate` | | meters: simplify on a grid of this size outright |

**Model axes** are the course's: x east, y up, z south (glTF's y-up frame; Blender's glTF export writes this). The
front of a piece is -z.

### How scenery fits the game

* **Faces and instances.** Over `scenery_budget.faces` (4,000 model faces in all) or `instances` (300) the compiler
  refuses; the game's own courses have at most 3,629 model faces and 168 instances. A model over 1,024 vertices or
  1,000 faces is split into parts (the game's model indices are 10 bits). The report warns when the model faces
  that can be in view from one section exceed 3,000.
* **Zones.** The lap is cut into `zones` (32) stretches; each instance is drawn while a section of its zone is in
  view. The game has 32 such groups, plus one always drawn (`always`).
* **Textures.** Every image is downscaled to `texture_size` texels a side (128 by default, at most 256) and reduced
  to 16 colours (all course textures in GT2 are 4-bit); alpha below one half becomes transparent. Identical images
  are stored once. A face's UVs must stay within one repeat of its image: the PlayStation cannot tile a texture
  inside a face, so wider UVs are clamped and counted in the report.
* **VRAM.** Textures go into the VRAM the replaced slot's `.trp` occupies (most of x 640-1023, y 0-511), less the
  rectangles the sky overwrites, the road tiles and, when a `sponsor_board` is placed, the sponsor slots
  (x 640-703, y 0-255). The report gives the cells and CLUTs used of those free.
* **Sponsor boards.** The game draws its own boards at race start into five sets of VRAM slots; a `sponsor_board`
  piece points a face at one slot. Placing one clears `.crsinfo` flag 0x40 and keeps the slots free.
* The draw-load warning is a heuristic (the game's primitive buffer limit is not known): keep repeats sparse on long
  sight lines.

## Open courses (point-to-point)

`"open": true` (or `{"runup": m, "runoff": m}`): draw the line from the start line to the finish line, not as a
loop. A closed line given with `"open": true` is cut at its first point. A CSV whose last point is far from the
first is open.

* The compiler adds a straight **run-up** before the first point (default: the grid's length + 20 m) and a straight
  **run-off** after the last (default 150 m), each closed by a wall across the road.
* The game models every course as a loop (a cyclic chain of sections with distances ascending from the start
  line), as on its own point-to-point courses. So the compiler closes the loop with an invisible **return path**
  (sections with no mesh, faces or walls, along a smooth curve of 60 m radius) from the run-off back to the run-up.
  Nothing is drawn or driven there, and the minimap shows only your road.
* Profile keys (`width`, `elevation`, `banking`) are clamped at the ends instead of wrapping.
* The finish line (the drawn line's last point) is the third sector split; flags default to 0x60
  (point-to-point, no sponsor boards).
* In the game: one run ("Lap 1/1"), a Finish banner at your last point, then the Results page.

## The checks before the build

`compile` checks the center line and profiles first and refuses with exit code 1 (`--force` overrides). Each
message says where (meters along the lap, map position in the spec's frame, and between which two input points) and
what to change.

| Message (shortened) | Kind | Meaning | Fix |
|---|---|---|---|
| *the turn at ... is too tight for the road: radius 6 m, but the road is 14 m wide* | error | radius under 1.5 x the half width: the inside of the road reaches the turn's center and the game's road probe misses faces | a rounder corner (2 x the half width or more), or a narrower road there |
| *the turn at ... is tight for the cross-section* | warning | radius under half the cross-section (road + kerb + verge): the inside kerb, verge and wall are squeezed | fine to ignore; wider corners or a narrower `verge` look better |
| *the track crosses itself at ... with only 0.0 m between the two levels* | error | a crossing with less than 6 m between the levels | raise one stretch 6 m or more (a bridge), or move the path |
| *the apron ... hangs through the lower road at the crossing* | warning | a bridged crossing with the apron on | `"apron": {"width": 0}` |
| *two stretches of track run 10 m apart ... they need 28 m* | warning | parallel stretches at the same level whose verges and walls overlap | move them apart, or a narrower `verge` |
| *a gradient of 40% at ...* | warning over 15%, error over 30% | too steep | spread the climb over more track |
| course larger than the minimap | warning | bigger than the minimap's ~2,400 m frame: the map and its dots are clipped | smaller course, or accept it |
| course too large | error | past 20 km (the game's distance units) | smaller course |
| road width out of range | error | the road width must be 3-60 m | |
| *a point's width is 0 m* | error | a `_width` attribute left at 0 | set every point's width |
| *the centerline does not close: its ends are 112 m apart* | error | an open line without `"open": true` | join the ends, or set `"open": true` |
| *the file has meshes but no line in them* | error | exported without Loose Edges | export again with Loose Edges on |
| *the file has only face meshes* | error | the curve had a bevel or extrusion, or the road model was exported | export the bare center line |
| *no line object named ...* / *the file has 3 line objects* | error | several lines in the file | name the center line `Track`, or `"import": {"file": ..., "object": "Name"}` |
| *the new course name "Mytrack" sorts before testline* | error | the name would renumber the game's courses | start it with `zz_` |
| too many sections | error | more than 16,383 sections | a longer `section_length` |
| *N vertices per section: at most 512* | error | too much detail per section | fewer `lanes`, or a longer `row_length` |

Near-miss hairpins, measured on a 14 m road: radius 14 m compiles clean, 12 m leaves a few probe misses, 10 m and
under fails the validator.

## The validator

`compile` validates the bytes it wrote; `check` validates any course, the game's own included. It replays the
game's tests where they are simple enough:

* **Structure:** one `next` cycle through all sections; distances inside the lap, wrapping once; plane normals of
  length 4096; every visibility list holds its own section and at most 256 entries; at most 512 vertices per
  section; wall normals = rot90(b - a); collision faces wound the way the game's edge test needs.
* **Road probe:** 5 points on every collision face are located by the game's start-plane walk, probed through the
  grid with its edge test, and their heights compared.
* **AI lines:** arcs end on the next node; points sampled as the game's loader samples them lie on the road; node
  distances ascend from node 0; the main line's distance never steps back.
* **The rest:** grid slots on the road; camera records for every lap 0-3 and distance; texture entries inside the
  `.trp`'s images and CLUTs; the `.tro` and `.trp` within the game's 700,000-byte course buffer (`compile` refuses a larger course and writes no files).
* **Scenery:** instances name existing objects and models; model vertex counts (at most 1,024), indices, bounding
  boxes, vertex shifts (16-26); textured UVs and CLUTs inside the `.trp`; LOD distances ascending; a warning for
  instances in a group no section names (never drawn).

"0 errors" is the goal. On the game's own circuits it reports 0 errors; its warnings there are real oddities of the
data.

## decompose and selftest

`decompose` turns a course of the game into compiler input: section start points become spline points, their
heights elevation keys, and the tarmac faces near each start plane give the road width and banking. Kerbs, verges,
walls, textures and scenery are the compiler's defaults (it is a test of the compiler, not a way to copy a course).
`selftest` recompiles that and compares track length (within 2%), the center line (within 3 m) and the validator.
Of the 125 courses, 106 pass, 16 are skipped as open courses, and 3 test courses fail where their hairpins are
tighter than their decomposed width.

## Tested in the game

Compiled tracks were raced in the port end to end: a 2-lap race with 5 AI cars to the Results page on an oval, a
banked oval, a figure-of-eight over a bridge, a road course, the sample track added as course 125 and the same
tracks with full scenery; a point-to-point hill climb ran to its Finish banner and Results page. The game's own
`laguna2` still loaded unchanged beside an added course. The compiler is deterministic: the same spec gives the same
bytes.
