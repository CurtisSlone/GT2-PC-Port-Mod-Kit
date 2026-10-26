# GT2 course format: `.tro`, `.trp`, `.crsinfo` and the files around them

This is Gran Turismo 2's course format (US Simulation disc, SCUS-94488) as the game's own code reads it. Every
claim names the function that reads the field, as `func_XXXXXXXX` addresses of the public byte-matched
decompilation ([GT2-Decomp](https://github.com/CurtisSlone/GT2-Decomp)), so you can check it. "ovl0" is the race overlay; "resident" and "boot"
are the main executable's parts. Function names are not used: only addresses are reliable.

> **What you can edit today, and what not yet.**
>
> * **Supported:** exporting any course with `gt2-course.exe export`, editing it **through its JSON and PNG files**
>   (move objects, recolour faces, move vertices, repaint textures, change AI lines, cameras, grid slots) and
>   rebuilding it with `gt2-course.exe import`; building **new** tracks from a centre line with `gt2-trackc.exe`
>   ([TRACK-SPEC.md](TRACK-SPEC.md), [04-BUILD-A-TRACK.md](../04-BUILD-A-TRACK.md)).
> * **Not supported yet:** editing an existing course's **mesh in Blender** and compiling it back. The glTF that
>   `export` writes is a view for looking at; changes made to it in Blender do not flow back. Section 7 lists what
>   such a path has to rebuild.

**How complete this is.** Every byte of all 125 `.tro` files and all 125 `.trp` files is parsed into named fields
and written back: all 250 files export and import back byte-identical. The only bytes kept as an opaque blob are 4
trailing bytes in `maxspeed.tro`. A few fields have no known reader; they are kept as numbers and listed under
"Unknowns" (section 6).

**How this was decoded.** Not from hex dumps: from the game's own code. With the decompilation, the functions
that read a course could be followed one by one. The race loader (`func_80027908`) inflates the `.trp` to
0x800B4724, uploads its textures, then inflates the `.tro` over the same address and relocates its pointers in place
(`func_8002714C`); every function that reads that buffer is a reader of the course, and each field here comes from
one of them. The test for "understood" was rebuilding: `gt2-course.exe import` recomputes every pointer, count and
offset from the exported JSON and PNG, and all 250 files come back byte-identical. An edit made only in the JSON
(a gantry moved 200 m and the road tinted red on the licence-test course) was rebuilt and showed up in the game. The
glTF view followed from there as a translation, which is why it is a view and not an editing path yet.

**Prior art.** SUBMANIAC's *Gran_Turismo_2_files_full_documentation.pdf* and the Nenkai GT modding hub
(<https://nenkai.github.io/gt-modding-hub/ps1/gt2/>, which also links Nenkai's 010 Editor template
`GTPS_tro_GTTrackObject.bt`) were checked; nothing was copied from them. The PDF agrees with the code on the
`.crsinfo` flags, the three lighting colour/factor pairs, the six images of `crstim.arc`, the sponsor-board set
names, the 96x96 4-bit minimaps and `.bsp` having `.trp`'s format. It differs on: the sky is an **index** into the
sorted `/bgsobj` names, not a file name; the stored order of the lighting rows is +0xC, +0x14, +0x10. Where any
source disagrees with the code, this page follows the code.

Contents: 1 loading, 2 the `.tro`, 3 the `.trp`, 4 the files around a course, 5 the JSON export, 6 unknowns,
7 what a new course needs.

## 1. How a course is chosen and loaded

* **The course key.** A race names its course by a hash of the course's file stem: resident `func_80082F14`,
  `h = rotl32(h, 6) + c` over each byte of e.g. `"laguna"`. The race set-up block (`D_801C9340 + 0xBF7C`) holds it
  at `+0x40`, written by resident `func_8005E4A0` / `func_8005E500`.
* **Key to course index.** ovl0 `func_800272B8` turns the key into the course index (a u8 at `D_800A91F0 + 0x5D30`)
  by a linear search of `.crsinfo` entry `+4` (resident `func_80060DC4`). **An unknown key gives index 0**
  (2p_autumn).
* **Course index to files.** The index is the stem's position in `/crsobj` sorted by byte order (the archive's
  directory order). `gt2-course.exe list` prints it. Course *i*'s files are the *i*-th `.tro`/`.trp` pair.
* **Loading.** ovl0 `func_80027908`, once per race, calls `func_800273C8(G = D_800A91F0, index)`, then
  `func_80027460` and `func_80027574`:

| Step | Function | File | Where it goes |
|---|---|---|---|
| 1 | `func_80027364` | `/crsmap/<stem>.tim` (found by key, resident `func_80060EC0`; key table built by boot `func_80011B70`) | inflated to scratch and uploaded to VRAM: CLUT (368, 508), pixels (576, 144) |
| 2 | `func_8005D89C(slot 89 + 2*index + 1)` | `<stem>.trp` | inflated to **0x800B4724**; `func_80027254` uploads every TIM to VRAM |
| 3 | `func_8005D89C(slot 89 + 2*index)` | `<stem>.tro` | inflated to **0x800B4724**, over the `.trp`. It stays resident for the race. Both files must end by **0x8015F584** (at most 700,000 bytes): the race's car models, loaded before the course, sit there (`func_80028D88`) |
| 4 | `func_8002714C` | | relocates the `.tro` in place (adds the base to every pointer) and fills the computed fields |
| 5 | `func_800272F8(G, .crsinfo[index] + 0xA)` | `/bgsobj` pair n | the sky: `.bsp` (TIMs) uploaded, `.bso` kept resident |
| 6 | `func_80027460` | `crstim.arc` elements 0 and 3/4/5 | the lamp flare texture and the car reflection map chosen by the `.crsinfo` flags |
| 7 | `func_80027574` | `.crstims.tsd` | sponsor boards drawn at random into VRAM slots (skipped with `.crsinfo` flag 0x40) |

In the decompiled C the course appears as `D_800A91F0 + 0xB534 + offset` (`base + 46388`), or through the
relocated header pointers.

## 2. The `.tro`

Little-endian. Every pointer is a **file offset**; `func_8002714C` adds 0x800B4724 at load. The layout is strictly
sequential, with no gaps except the 4-byte padding after each visibility list:

```text
header (0x19C)
33 instance groups                      (header 0x118[i], in index order)
section table                           (header 0x10)
sections 0..n-1                         (each: 0xA4 struct, inline high mesh, low mesh, walls, grid, visibility list, pad)
texture table                           (section table +8)
object LOD table, then its level lists  (header 0x14)
model list, then the models             (header 0x18)
camera table, then its records          (header 0x1C)
AI lines, to the end of the file        (header 0x20)
```

Empty lists still have pointers: a pointer always holds the running offset. `gt2-course` writes exactly this layout
and recomputes every pointer.

### 2.1 Header (0x19C bytes)

| Off | Type | Meaning | Reader |
|---|---|---|---|
| 0x00 | char[12] | `"@(#)GT-PS"` and zeros | never read |
| 0x0C | u32 | 0x001F0000 in all files | never read |
| 0x10 | ptr | section table | `func_8002714C`; `func_8002009C` |
| 0x14 | ptr | object LOD table | `func_80027000`; `func_8001F784` |
| 0x18 | ptr | model list | `func_80027088` |
| 0x1C | ptr | camera table | `func_80027110`; `func_800109FC` |
| 0x20 | ptr | AI lines | `func_80038D4C` |
| 0x24 | s32 | number of sector splits in use (0..8: 3 on most circuits, 1 on licence courses, 0 on test courses) | `func_80033330`, `func_8003CF40` |
| 0x28 | s32[8] | split track distances, ascending, below the track length; unused entries 0. On point-to-point courses (`.crsinfo` flag 0x20) the last used split is the finish | `func_80033330`, `func_8003C6B8`, `func_80038FEC` |
| 0x48 | s32[3] | start/finish line point (x, y, z), at track distance about 0 | no reader found |
| 0x54 | s32 | grid heading (4096 = a full turn) | `func_80012CD4`, rotation by `func_8007B05C` |
| 0x58 | s32[16][3] | 16 grid slots (x, y, z); (0, 0, 0) = unused. The slot is the entrant's byte +0x8D | `func_80012CD4`; the car is placed at (x>>4, -z>>4), then `func_80032AB8` drops the wheels onto the road |
| 0x118 | ptr[33] | the instance groups | `func_8002714C`, `func_8001FFB8` |

A rolling start (last argument of `func_80033330` non-zero) ignores the slots: `func_80038FEC` puts the car on the
main AI line at an offset.

### 2.2 Instance groups (trackside objects)

Each group is `u32 n`, then n x 28-byte instances:

| Off | Type | Meaning |
|---|---|---|
| +0 | s16[3] | rx, ry, rz (4096 = a turn) |
| +6 | s16 | object kind: an index into the object LOD table |
| +8 | s16[4] | sx, sy, sz, sc (4096 = 1). sc also divides the LOD distance. Almost every shipped instance uses 4096 |
| +16 | s32[3] | world position |

* **Which groups are drawn.** Groups 0-31 are drawn when bit i of the OR of the visible sections' masks (section
  +0xC) is set; group 32 is always drawn. Only the main view draws objects, not the mirror (`func_8002009C` returns
  the mask; `func_8001FFB8`, `func_800298E8`).
* **Placement** (ovl0 `func_8001F784`): `world = pos + M * v * 2^(shift-12)`, with
  M = Rot * diag(sx, sy, -sz) / 4096, Rot = resident `func_80081284` with a = -ry, b = rx, c = rz, and the model's
  shift at +0x54 of its header. With shift 22, model units equal track vertex units (1,024 course units).
* **LOD.** Squared distance `d = sum((offset >> 14)^2) * z/4096 * z/4096`, with `z = (view+0x78 << 12) / sc`
  (resident `func_8007AD48`). The first level whose limit is above d is drawn; past the last limit the object is
  not drawn (resident `func_8007AE04`).

### 2.3 Section table

| Off | Type | Meaning |
|---|---|---|
| +0 | s32 | track length: distances wrap at it (used everywhere, e.g. `func_80038D4C`) |
| +4 | u16 | n sections |
| +6 | u16 | n texture-table entries (no driving reader) |
| +8 | ptr | texture table |
| +0xC | ptr[n] | the sections |

### 2.4 Section (0xA4-byte struct, then its data)

A section is a short stretch of track: the unit of drawing, collision and visibility.

| Off | Type | Meaning | Reader |
|---|---|---|---|
| +0x00 | u16 | previous section | `func_80026E9C` |
| +0x02 | u16 | next section. The links form one cycle; reverse courses run backwards, and 13 courses are not in file order | `func_80026E9C`, `func_80028320` |
| +0x04, +0x08 | u32 | 0 in the file; at load, pointers to the previous and next sections | `func_80026E9C` |
| +0x0C | u32 | instance-group mask | `func_8002009C` |
| +0x10 | s32 | track distance at the start plane | `func_80028514` |
| +0x14, +0x16 | s16 | fa, fb: 4.12 weights of the along-track interpolation (mostly 4095/4096) | `func_80028514` |
| +0x18 | s32[3] | start-plane point | `func_80027B48` |
| +0x24 | s16[3] | start-plane normal (4.12) | `func_80027B48` |
| +0x2A | s16 | 0 | |
| +0x2C | s32 | bounding radius of the render vertices about the centre | `func_80026B40` |
| +0x30 | s32[3] | centre. Its high bits (`& 0xFFC00000`) are the origin of the section's vertices | `func_80028214`, `func_80026B40`, `func_80020F64` |
| +0x3C | s16[4] | (x, 0, z, 0): a horizontal unit vector across the track | no reader found |
| +0x44 | s32[10] | culling box of the high mesh: 4 corners (x, z) start-left, start-right, end-left, end-right, then y min, y max | `func_80020E50` (mode 0) |
| +0x6C | s32[10] | the same for the low mesh | `func_80020E50` (mode 1) |
| +0x94 | ptr | low-detail mesh (drawn in the rear-view mirror) | `func_8002009C` |
| +0x98 | ptr | walls | `func_80027F50` |
| +0x9C | ptr | collision grid | `func_80027974` (hand-written asm in the original) |
| +0xA0 | ptr | visibility list | `func_8002009C` |
| +0xA4 | mesh header (0x44) | the high-detail mesh, inline (the main view) | `func_8002009C`, `func_80020FF8` / `func_80023484` |

The data follows in this order: the high mesh's data, the low mesh (header and data), the walls, the grid, the
visibility list padded with zeros to 4 bytes.

* **Locating a point** (`func_80028320`, via `func_80028768` / `func_800287BC`): a point p is past section s's start
  plane when `dot(p - s.point, s.normal) >= 0` (`func_80027B48`). From a hint section the search walks back while
  the point is not past the plane, then forward while the next section's plane is passed. `func_80028214` finds the
  nearest section by the norm `max + mid/2 + min/4` of the centre offset.
* **Track distance** (`func_80028514`): `a = dot(p - s.point, s.normal)*fb >> 12`,
  `b = dot(next.point - p, next.normal)*fa >> 12`,
  `dist = wrap(s.dist + wrap(next.dist - s.dist) * ((a << 12)/(a+b)) >> 12)`. The lap line is distance 0
  (`func_8003C6B8`: a crossing is `new < old - len/2`). There is no lateral coordinate.

### 2.5 Meshes (section meshes: 0x44-byte header; object models: 0x58)

| Off | Type | Meaning |
|---|---|---|
| +0x00 | ptr | vertices (= header + header size) |
| +0x04..+0x20 | ptr[8] | face lists in the order F3, F4, G3, G4, FT3, FT4, GT3, GT4 (F flat, G gouraud, T textured; 3 triangle, 4 quad) |
| +0x24 | ptr | billboards |
| +0x28 | ptr | glows |
| +0x2C | u32 | n vertices |
| +0x30 | u16[8] | face counts |
| +0x40 | u16 | n billboards |
| +0x42 | u16 | n glows |
| +0x44 | s16[4] x2 | models only: bounding box min (x, y, z, 0) and max, tested by resident `func_8007B808` |
| +0x54 | s16 | models only: vertex shift (16..26) |
| +0x56 | s16 | models only: 0 |

The data follows with no padding: vertices (n x 8), the 8 face lists, the billboards, the glows. Relocation is
`func_80026D3C` / `func_80020048`.

* **Renderers.** Track: `func_80020FF8` (section inside the view) and `func_80023484` (crossing its edge, clipped),
  chosen by the box test `func_80020E50` (0 inside, 1 crossing, 2 outside = skipped). Models: `func_80019AE4` /
  `func_8001C108`.
* **Vertex** (8 bytes): s16 a, b, c, then u16 0.
  * Track: course x = hi(centre.x) + a*1024; height = hi(centre.y) + **c***1024; course z = hi(centre.z) +
    **b***1024, with hi(v) = v & 0xFFC00000 (`func_80020DC4` swaps the matrix columns 1 and 2). Consecutive
    sections share their boundary vertices exactly.
  * Models: (x, y, z) in model space.
* **Face indices** are 9 bits on the track (**at most 512 vertices per section mesh**) and 10 bits on models (at
  most 1,024).

| List | Track record | Model record |
|---|---|---|
| F3, F4 | 12 B: w0, w1, colour | 12 B: w0, w1, colour |
| G3 | 20 B: w0, w1, c0, c1, c2 | same |
| G4 | 24 B: w0, w1, c0..c3 | same |
| FT3, FT4 | 12 B: w0, w1, colour (UVs through the texture table) | 24 B: w0, w1, colour, uv0\|clut<<16, uv1\|tpage<<16, uv2\|uv3<<16 |
| GT3 | 20 B: w0, w1, c0, c1, c2 | 32 B: w0, w1, c0, uvA, uvB, uvC, c1, c2 |
| GT4 | 24 B: w0, w1, c0..c3 | 36 B: w0, w1, c0, uvA, uvB, uvC, c1, c2, c3 |

* **Track w0:** bits 0-8 i0, 9-17 i1, 18-26 i2; 27-28 ordering-table bias (+16 slots per step); 29 unknown;
  30 quad (the collision code reads it); 31 back faces culled (clear = double-sided).
* **Track w1:** bits 0-8 i3 (quads); 9-22 texture-table index; 23-24 shade class; 25-26 zone flags (bit 1 = pit
  lane); 27 unknown; 28-31 **surface** (2.6).
* **Model w0:** bits 0-9, 10-19, 20-29 the indices; 30 sort by the farthest vertex; 31 cull. **Model w1:** bits 0-9
  i3; the rest unread (bit 10 an old fog flag).
* **Colour words** are `0xCCBBGGRR`; the GPU code byte CC is taken from the first word only. Codes 0x20/0x28/0x30/0x38
  untextured; 0x24/0x2C/0x34/0x3C textured; 0x25/0x2D raw texture, no modulation. Textured faces modulate the
  texel, 0x80 = 1.0. No course face is semi-transparent.
* **Quad corners** are in cycle order 0-1-2-3; the GPU strip order is 0, 1, 3, 2. Colours and UVs follow the corners.
* **Texture table entry** (32 bytes; section table +8): `[0] uv0 | clut<<16`, `[1] uv1 | tpage<<16`,
  `[2] uv2 | uv3<<16`, `[3] area threshold (u16)`; `[4..6]` the same three words for level 1, a half-size copy in
  VRAM; `[7] 0`. Level 0 is used when the face's screen area (NCLIP) is above the threshold.
  * All course textures are **4-bit** (16 colours), blend mode 0.
  * Texel address: VRAM x = (tpage & 15)*64 + u/4, y = ((tpage >> 4) & 1)*256 + v. CLUT at ((clut & 63)*16, clut >> 6).
  * Colour 0x0000 is transparent.
* **Billboards** (trees): vertical quads turned to the camera's yaw (`func_8002009C`; models `func_8001F784`).
  * Track (16 B): s16 x, y, z; u16 texture index; s16 width, height; colour (0x2C). The quad spans
    (x, y) +/- width/2 * (cos, sin)(view yaw), from z to z + height. UV0/UV1 are on the top edge.
  * Models (28 B): s16 x, y, z, u16 (0, or 1 on a few); s16 width, height; colour; three UV words as FT4. The
    vertical axis is model y.
  * Drawn at visibility levels 0-2, or always in replays.
* **Glows** (20 B, lamps): s16 x, y, z, size (screen size = size*H/SZ); two words no renderer reads; colour
  0x00BBGGRR. Each is drawn as 4 additive GT4 quads with `crstim.arc` element 0 (clut 0x7F57, tpage 0x29), corner
  colours colour/2, /8 and /64. At visibility level 3 the main view draws only the glows (except in replays): the
  lights you see from far away.
* **Subdivision.** Large textured faces are split at draw time (area limits 0x480/0x800 in the main view,
  0x120/0x200 in the mirror). Nothing in the data marks it.

### 2.6 Road surface, collision, walls

The physics reads **the same face records the renderer draws**: the road you drive on is faces of the section's
high mesh, and the surface is in their w1.

* **Collision grid** (+0x9C): s16 x0, z0 (vertex units from the section origin); s16 shift x, shift z; u16
  count[16]; ptr list[16]; then the lists.
  * Each list holds `count` pointers to faces of the section's high mesh (mostly FT4/GT3/GT4). A face can be in
    several cells. The lists are contiguous.
  * Lookup (`func_80027974`): `gx = (x - x0) >> shx`, `gz = (z - z0) >> shz`; outside 0..3 means no face;
    cell = gz*4 + gx.
  * A point is inside a face when every GTE NCLIP edge test passes; the quad bit of w0 selects 3 or 4 edges.
  * (x0, z0) is the minimum over the cells' face vertices. The shifts follow no simple formula, so they are stored.
* **Height** (`func_80027BFC`): a triangle is interpolated over its plane. A quad is split into 4 triangles around
  its vertex average; the triangle is chosen by sign bits: 1/3/7 -> (d, a), 4/12/13 -> (b, c), 8/9/11 -> (c, d),
  otherwise (a, b).
* **Probe** (`func_800283FC`): the located section first, then up to 8 sections each way. Result: a 24-byte struct
  {u8 surface, u8 shade, u8 flags, pad; u16 section; pad; s32 x, y, z; s32 height}. A miss gives surface 7, shade 4
  and height 0x7FFFFFFF.
* **Surfaces** (w1 >> 28, read per wheel by `func_80043498`; bump and rolling-resistance tables at `D_80046EA8`,
  `D_80046EB8`, `D_80046D20`). The names are inferred from where each code is used:

| Code | Meaning |
|---|---|
| 0 | tarmac |
| 1 | kerb / rumble strip |
| 2 | grass |
| 3 | gravel / sand |
| 4 | off-road |
| 5 | dirt (rally courses are almost all 5) |
| 6 | out of bounds (counted as no ground) |
| 7 | no face found (a probe miss) |

  * Per-car grip per surface comes from the car's parameters (car+0x348, s16[8]).
  * Two or more wheels on surfaces >= 2 count as off-road (`func_8003D404`).
  * The shade class (w1 bits 23-24) picks the car-model lighting row by majority over the wheels (`func_800140A4`).
  * Zone bit 1 marks the pit lane (`func_80041A64`).
* **Road normal.** Not stored: pitch and roll come from the four wheel heights. AI nodes probe +/-2048 around the
  node (`func_8003898C`).
* **Walls** (+0x98): `u32 n`, then n x {u16 vertex a, u16 vertex b (high-mesh vertices), s16 nx, s16 nz}. The
  normal is always rot90(b - a) normalised to 4096 (redundant, but stored). Collision: `func_80041C78` builds the
  car's 4 corner segments (last frame -> this frame), and `func_800288F4` / `func_80027F50` intersect them with the
  walls of the current section and up to 8 sections each way.

### 2.7 Visibility list (+0xA0)

`u16 n`, then n x u16: bits 0-13 a section index, bits 14-15 a level. Levels 0-2 are drawn in full; level 3 draws
only the glows, except in replays. Zero padding to 4 bytes follows.

`func_8002009C` (main view and mirror) box-tests every listed section, sorts them by `func_80020F64`'s key into a
**256-entry array**, and draws them. **A section that is not listed is never drawn: the lists are the draw
distance.** Each section's list covers the sections visible from anywhere inside it.

### 2.8 Object LOD table and models

* **LOD table.** `u32 n`, ptr[n]. Each entry is `u32 k` then k x {u32 dist, ptr model}. dist is stored raw; at load
  `func_8007ACD8` replaces it with `(dist >> 14)^2`. The low 14 bits are not always 0, and 7 shipped tables are not
  sorted.
* **Model list.** `u32 n`, ptr[n]: the distinct models in order of first use. The models follow, each a mesh with
  the 0x58 header.

### 2.9 Cameras (header 0x1C): replay and TV views

* **Table.** u16 n, u16 lap modulus, ptr[n]. The records are contiguous up to the AI lines.
* **Selection.** `func_800109FC` -> `func_800117C4` picks the record whose lap range [+2, +4] (folded by the
  modulus) and distance range [+8, +0xC) contain the car.
* **Common header:** u16 type (low nibble = kind; flag 0x2000 has no known reader), u16 lap first, u16 lap last,
  u16 section hint, s32 start distance, s32 end distance.

| Kind | Reader | Body |
|---|---|---|
| 0 follow | `func_800111A8` | u16 zoom0, u16 zoom1 (blended by progress), u32 (0 or 25), then a path |
| 1 fixed | `func_800112C4` | s32 zoom, s32[3] position, s16[3] angles, pad |
| 2 on-board | `func_80011378` | u16 view (table `D_8002F324`), u16 zoom |
| 3 tracking | `func_80011568` | u16 zoom min, max, scale, 0, u32 0, then a path |

**Path:** u16 kind, u16 n. Kind 0: n x {s32 length, x, y, z}, linear (`func_800118F8`). Kind 1: n x 56 bytes
{s32 length, p[3], u32 scale, c[3][3]}, cubic (`func_80011A58`).

### 2.10 AI lines (header 0x20; `func_80038D4C`)

* **Block header** (0x28 bytes): s32 size (bytes to the end of the file; negated after load as a "done" mark),
  s32 7 (6 on maxspeed), s32 off[7] (relative to this block; 0 = no line of that kind), s32 0.
* **Lines** follow in ascending kind order. Each is `s32 n`, then n x 0x28-byte nodes:

| Off | Type | Meaning |
|---|---|---|
| +0x00 | s32 | 0 = straight to the next node, 1 = arc |
| +0x04, +0x08 | s32 | x, z in physics units (course / 16), z = -course z |
| +0x0C | s32 | computed at load: road height |
| +0x10 | s16 | computed: section |
| +0x12, +0x13 | u8 | computed: surface, shade |
| +0x14 | s32 | computed: track distance (kind 4: unwrapped past the line) |
| +0x18 | s32 | signed arc radius (0 on straights); arc centre = P - r*(cos a, sin a); r > 0 turns left |
| +0x1C, +0x20 | s32 | computed: pitch, bank |
| +0x24 | s32 | heading a (4096 = a turn, not masked); direction of travel (-sin a, cos a) |

* **Loader order:** table `D_80046D18` = {6, 0, 1, 2, 5, 3, 4}.
* **Kinds:** 6 the main racing line (0 replaces it on 2 test files); 1 and 2 the passing lines (`func_800367B4` /
  `func_80036778`); 5 a side selector (`func_80036074`); 3 pit entry (`func_800368BC`); 4 the pit lane
  (`func_800368F4`; car i's pit box is node 8 - i, `func_80039258`; pit state machine `func_80036C50`).
* **Speed** (`func_800362EC`, `func_800358F4`): a corner speed from the radius, grip and bank, through the difficulty
  table `D_801C80F0`, clamped to the car's maximum.
* **Node distances must ascend from node 0** (`func_80035BF4`, the AI's node search). Arc nodes end exactly on the
  next node; very large radii (tens of km) overflow the game's arc arithmetic (the shipped lines stay under about
  2.3 km).
* There is no other spacing table: the grid slots and the passing lines set it.

### 2.11 Units and axes

* **Course units:** 65,536 = 1 m (the licence 0-400 m / 0-1000 m constants 0x1900000 / 0x3E80000 in
  `func_8003C6B8`). Track vertices sit on a 1,024-unit grid (1/64 m).
* **Physics units:** course / 16, with z negated (`func_80028768`, `func_800288F4`).
* **Angles:** 4096 to a turn (sine table `D_80092E48`).
* **Vertical axis:** height is course y.
* **Handedness:** course (x, y, z) read as a right-handed, y-up frame is the game's world, not a mirror image (checked
  against in-game pictures: signs read correctly, and the top view matches the minimap).
* **In Blender:** the glTF importer turns y-up into Blender's z-up, so course z becomes Blender -y. The top view then
  looks like the minimap.

### 2.12 Minimap

* **Load.** `func_80027364` loads `/crsmap/<stem>.tim`: a 4-bit 96x96 TIM.
* **Draw.** ovl0 `func_80029010` draws it at screen (16, 144). A car dot is at
  `(16 + 48 + (163*X >> 12), 144 + 48 + (163*Z >> 12))`, X and Z being the high halves of the car position
  (car+0x830 / +0x838).
* **The scale and origin are constants in the code, not in any file:** the world origin is the map centre and one
  pixel is about 25 m, so the map shows about +/-1,200 m around the origin. A new course must be drawn into this
  frame (and centred on the origin to use it fully).
* **Fallback.** A course with no map gets the first map's (2p_autumn). At most 128 maps (boot `func_80011B70`'s key
  table).

## 3. The `.trp` (and `.bsp`)

* **Layout.** `u32 count`, then count TIMs, each padded to 4 bytes with zeros (`func_80027254`).
* **TIMs.** All are 4 bits per pixel with a 16-colour CLUT (TIM flag 8).
* **Upload.** Each TIM goes to the VRAM rectangle in its own header, in file order (resident `func_8007BBB0`); a
  later TIM can overwrite an earlier one.
* **Coverage.** Every texture-table entry (both levels) and every model UV of all 125 courses lies inside a `.trp`
  image, with its CLUT inside a `.trp` CLUT. Every shipped `.trp` lies in VRAM x 640-1023, y 0-511.
* The glow texture comes from `crstim.arc` instead.

## 4. The files around a course

### 4.1 `/.crsinfo`: the course table (archive slot 6, stored uncompressed; loaded by boot `func_80011C70`)

* **Header.** `"CRS\0"`, u16 2 (version), u16 count (125); then count x 24-byte entries; then the display names
  (unique, sorted, NUL-terminated, packed). Only entry +0 is relocated.
* **Size limit.** The game's buffer holds **0x1400 bytes** (5,120); the disc's file is 4,007.
* **Entry *i* is course *i*.** Every key is the hash of the course's `/crsobj` stem.

| Off | Type | Meaning | Reader |
|---|---|---|---|
| +0x00 | u32 | display-name offset (a pointer after load) | boot `func_80011C70` |
| +0x04 | u32 | key: hash of the stem (section 1) | resident `func_80060DC4`; `func_80027364` (minimap) |
| +0x08 | u16 | flags: 0x01 night, 0x02 evening, 0x04 dirt, 0x08 2-player variant, 0x10 reverse variant, 0x20 point-to-point, 0x40 no sponsor boards | `func_80028D88`, `func_80027460`, `func_8001503C`, `func_80027574`, `func_80012CD4` |
| +0x0A | u16 | the sky: `/bgsobj` pair index (position in the sorted names) | `func_800273C8` -> `func_800272F8` |
| +0x0C | u16, u16 | car lighting row 0: BGR555 colour, 4.12 factor | `func_80028D88` -> resident `func_80067870` |
| +0x10 | u16, u16 | row 2 | same |
| +0x14 | u16, u16 | row 1 | same |

* **Lighting rows.** `func_80067870` blends each car's CLUT toward the colour by factor/4096 (GTE INTPL) and
  uploads 4 rows (row 3 is zero). A road face's shade class (w1 bits 23-24) chooses the row a car uses.
* The only other course-dependent colours are the sky's backdrop colours and the reflection-map choice. The race
  sets the GTE far colour to 0 (`func_80020E10`): there is no depth fog.

### 4.2 Sky: `/bgsobj/<name>.bso` + `.bsp` (`func_800272F8`; drawn by ovl0 `func_80018CA8`)

* **`.bsp`.** Same format as `.trp`. Its rectangles are absolute, so a sky can overwrite other VRAM (including
  parts of a course's `.trp` area: it is uploaded after it).
* **`.bso` header** (0x20 bytes): `"BG\0\0"`, u32 backdrop colour A, u32 colour B (GPU words, code 0x28), u32 n
  vertices, u16[8] face counts (F3 ... GT4). Vertices: n x {s16 x, y, z, 0}.
* **Face records:** `u32 w0, u32 w1`, then the GPU packet **twice** (double-buffered; packet sizes 5, 6, 7, 9, 8,
  10, 10, 13 words for F3 ... GT4). The packet holds tag, colour, UVs, CLUT and tpage; its XY words are written at
  draw time. Indices: v0 = w0 & 0xFFF, v1 = (w0 >> 12) & 0xFFF, v2 = (w1 >> 12) & 0xFFF, v3 = w1 & 0xFFF. w0 bit 31
  selects the front or back ordering table.
* **Drawing.** Camera-relative (view rotation x RotY(180), no translation). The two backdrop colours fill above and
  below the horizon (`func_80019648`).

### 4.3 Shared textures

* **`crstim.arc`** (slot 90): `"@(#)GT-ARC"`, u16 1, u16 6, then 6 x {offset, size, size}, then 6 TIMs: 0 lamp flare
  (glows); 1 and 2 smoke and dust (`func_8002EAB4` / `func_8002EB0C`); 3, 4, 5 day, dusk and night car reflection
  maps, chosen by `.crsinfo` flags 0x02 / 0x01.
* **`.crstims.tsd`** (slot 7): the sponsor-board sets (10 named sets, per-board probabilities, default TIMs).
  `func_80027574` draws boards at random into fixed VRAM slots (table `D_8002F550`) in x 640-703, y 0-255, seeded
  from the race set-up. The event record names the set.

### 4.4 Arcade course previews (not used by the Simulation disc's menus)

* **`/arcade/course_mapinfo`:** `u32 count`, then count x {u32 variant flags, u32 packed size, u32 sector, u32 name
  offset}, then the names.
* **`/arcade/course_map`:** per entry, 2048-aligned: `"@(#)GT-ZIP"`, u32 unpacked size, then LZ data (resident
  `func_80083C1C`: a flag byte per 8 items, LSB first; literal, or copy of `len = b + 3`, `dist = b + 1`, two bytes
  when bit 7 of b is set). The output is a 188x200 4-bit TIM, read by ovl2 `func_80017B60` / `func_80017CFC`.

## 5. The JSON export (`gt2-course.exe`)

```text
gt2-course.exe list --data data\gt2vol                                   the course stems in course-index order
gt2-course.exe export laguna --data data\gt2vol --out work\laguna [--no-gltf]
gt2-course.exe export laguna seattle --data data\gt2vol --out work\courses   (several, or --all: one folder each)
gt2-course.exe import work\laguna --out work\laguna-built [--gzip]
gt2-course.exe roundtrip --all --data data\gt2vol --work work\rt          export, import and compare
```

* `--data` is the unpacked archive (`data\gt2vol`, read from `raw\crsobj\*.tro.gz`), a `crsobj` folder, or a folder
  holding the files. Courses are named by file stem (`laguna`, `TC_lisence`).
* `import` writes `<course>.tro` and `.trp`; with `--gzip` also `.tro.gz` / `.trp.gz` behind the original member
  headers (the compressed bytes differ from the disc's but inflate to the same payload).
* `roundtrip` exits non-zero if any course does not come back byte-identical.
* The tool is deterministic: the same input gives the same bytes.

### The export folder

```text
course.json          format tag and version, the source files' sizes, SHA-256 and gzip headers, and the course head:
                     grid slots and heading, sector splits, instance groups, track length, texture table, object
                     LOD table, cameras, AI lines
sections\NNN.json    one track section each: links, planes, distances, culling boxes, the high and low meshes,
                     walls, collision grid, visibility list
models\NNN.json      one object model each
textures\trp.json    the .trp: per TIM its id and flags, CLUT rectangle and words, image rectangle and PNG name
textures\NNN.png     TIM NNN's pixels as an indexed PNG (palette = its first CLUT row)
view\<course>.gltf   the glTF view, with <course>.bin and pages\*.png (one texture per texture page + CLUT pair)
info.json            the course's .crsinfo entry (display name, flags, sky, lighting). Informational: import ignores it
```

**JSON conventions.**

* Field names follow this page.
* 32-bit colour and raw words are strings `"0xCCBBGGRR"`; opaque bytes are hex strings.
* Fields that are zero in the file are left out, and default to zero on import.
* Faces list their vertex indices `v` (quads in cycle order) and colour words `c`. Track faces add the texture-table
  index `tex`, `surf` (surface, 2.6), `shade`, `zone`, `sort` and `cull`.
* Collision grid cells list faces as `[list, index]`, lists 0-7 = f3, f4, g3, g4, ft3, ft4, gt3, gt4.
* Visibility entries are `[section, level]`.

**What import computes.** Every pointer, count and offset (the layout of section 2). So lists can grow or shrink,
and sections and models can be added as further `NNN.json` files (the files present set the counts). The importer
checks indices: face vertices, wall vertices, grid faces and LOD models.

**Textures.** Edit `textures\NNN.png`. The importer reads the PNG's palette indices. An RGB(A) PNG, as many editors
save, is mapped back through the TIM's first CLUT row and must use only its colours (the CLUT colours are the
`words` in `trp.json`). Colour mapping: 5-bit components expanded to 8 bits; alpha 0 = 0x0000 (transparent),
alpha 128 = the STP bit set, alpha 255 = opaque. The mapping is lossless.

**What an edit looks like.** Shown in the game: moving one trackside gantry 200 m along the start straight (an
instance `pos` in `course.json`) and tinting the start straight's road faces red (their `c` words in the section
files), rebuilt with `import --gzip`: the game drew both, with unchanged lap times. The rear-view mirror stayed
untinted, because it draws the low-detail mesh, which was not edited: edit both meshes.

### The glTF view in Blender

File > Import > glTF 2.0, pick `view\<course>.gltf` (keep the folder together: the `.bin` and `pages\` are
referenced relatively). Six top-level empties:

| Empty | Contents |
|---|---|
| `track` | the high-detail section meshes, with billboard trees as crossed quads |
| `track_low` | the mirror's low-detail meshes |
| `objects` | the trackside instances at LOD level 0 |
| `collision` | the faces the collision grids list, one material per surface, and the walls as yellow lines |
| `ai_lines` | line strips per line kind |
| `markers` | the start point and the grid slots |

Units are meters, axes are the course's, and the top view looks like the minimap. For the PlayStation colours use
Material Preview, or Solid with *Color: Attribute*. Each section mesh sits at its section origin
(`centre & 0xFFC00000`), so vertices stay exact.

## 6. Unknowns (kept as numbers)

* Header: 0x00-0x0F tag (never read); the 0x48 start point (no reader found).
* Section: +0x3C lateral axis (no reader); +0x2A (always 0); section table +6 (equals the texture count; no driving
  reader).
* Faces: track w0 bit 29 and w1 bit 27; model w1 bits 10-31; the unread high half of model textured triangles' third
  UV word.
* Model billboards: the z word's high half (0 or 1). Glows: words 2 and 3.
* Cameras: kind 0 +0x14 (0 or 25); the type flag 0x2000.
* AI block: the sentinel 7; maxspeed's 4 trailing bytes.

## 7. What a new course needs

`gt2-trackc.exe` builds all of this from a centre line ([TRACK-SPEC.md](TRACK-SPEC.md)). For anyone building
courses another way (or working on a Blender-to-course path), the game needs:

1. **`<stem>.tro`** with: at least one section, a cyclic prev/next chain, start planes, distances and the track
   length; high and low meshes (the low one may be a copy); a collision grid listing the road faces; walls; a
   visibility list per section that includes the section itself; the texture table; grid slots, heading and split
   distances; a main AI line (kind 6); a camera table (one record per lap and distance range is enough). Instance
   groups, LOD table and models may be empty.
2. **`<stem>.trp`**: the TIMs the texture table points into, at VRAM rectangles that do not collide with the game's
   own (fonts, HUD, cars, the sky's `.bsp`, `crstim.arc`, sponsor slots). The replaced course's own rectangles are
   the safe choice.
3. **Optional:** `/crsmap/<stem>.tim` (96x96 4-bit, in the fixed frame of 2.12); a sky (any existing sky index).
4. **A new stem** (not a replaced one) also needs a `.crsinfo` entry appended, a stem that sorts after `testline`,
   and an event that names it to appear in the menus. See [LIMITS.md](LIMITS.md).

The hard parts, in order:

* **Collision.** The road must be faces of each section's high mesh. Each section's 4x4 grid must list every face
  under each cell, from its minimum corner, with power-of-two cell sizes. Every point of road must fall within some
  section's planes and grid, or the car finds no ground (surface 7). Walls are 2D segments per section. 512
  vertices per section mesh bounds the detail.
* **Section planes and distances.** Start planes, `fa/fb`, distances and the track length must agree, or lap
  counting, splits, AI and cameras break. The lap line is distance 0, and section 0 normally starts there.
* **Visibility.** Every section needs a list of all sections visible from anywhere inside it (at most 256; nothing
  unlisted is drawn). This must be computed offline.
* **AI lines.** Straights and constant-radius arcs with headings, in physics units, distances ascending from node 0.
  Passing lines (1, 2), pit entry (3) and pit lane (4) are needed for the full race logic; single-car events need
  only line 6.
* **Cameras.** Replays need records covering every lap and distance range.
* **Textures.** 4-bit TIMs in the course's VRAM area, two levels per texture entry, 64-halfword-wide texture pages.
