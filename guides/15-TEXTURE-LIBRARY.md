# 15. A course's texture library

Give a course's faces pictures it does not have yet: your own (a sign, a kerb, a wall pattern) or a texture pulled
from another of GT2's courses. A course you edit (guide 08) or open as a new track (guide 16) gets a **texture
library**: every picture its faces may use, each with a stable ID. When you build, the **packer** turns the pictures
the faces use into the course's texture file, inside the part of video memory the course may use, and tells you by
how much a set does not fit.

This is different from retexturing (guides/06-RETEXTURE-A-COURSE.md): a retexture paints over a texture the course
already has, everywhere it is used. The library adds pictures, and you choose which faces show them.

**Limits, up front:**

* **Classic pictures only.** Each picture becomes a 4-bit texture: 16 colors, at a small size (64 texels on the
  longest side unless you say otherwise; at most 256). That is all GT2's course renderer and the PlayStation draw.
  The full-size picture is kept beside it, but **the port's remaster look still draws new pictures from their 16-color
  copy** for now (not yet wired to the full size).
* **Room is tight.** Shipped courses are packed close to full. On Laguna Seca the largest free piece is 136 x 64
  texels and a few small pictures fit; a 128 x 128 picture does not fit in one piece. When pictures do not fit, the
  packer can drop textures nothing uses and the far copies (then far faces show the near texels), and slide the
  rest together. Past that the build stops with the fit report.
* **Few new palettes.** When the free palette cells run out, the smaller new pictures take the closest 16 colors
  already in video memory (the report says which).
* **Never share pictures that came from a disc.** The library holds the course's own textures and pulled ones
  (marked as game pictures). Only the pictures you made are yours to share.

## Where it lives

In the course's export folder, beside the texture pages:

```text
textures/library.json        the library: IDs, where each picture came from, tags, sizes, uses
textures/source/<ID>.png     the picture as given (any size): the full-size copy
textures/classic/<ID>.png    16 colors at the classic size, made by the tool: what the game draws
```

In Blender that is `gt2-edit/<course>/textures` beside your .blend (a course edit) or the new track's scene folder
`gt2-newtrack/<course>/textures`. The IDs:

| ID | What it is | Share? |
|---|---|---|
| `laguna-t042` | texture t042 of the course itself (made by `init`) | **no** |
| `roma-t053` | a texture pulled from another course | **no** |
| `sign` (from the file name, or `--id`) | your own picture | yes |

A face uses a library picture by its material name **`lib:<ID>`** (beside the course's own `tex:NNNN` materials).

## In Blender

Open a course first (**Edit a GT2 course**, guide 08, or **GT2 new track**, guide 16). Then the panel
**GT2 texture library**:

1. **Make library** (once per course): the course's own textures from your install.
2. **Add picture**: a PNG or JPG of yours. Options: **Tags** (road, kerb, wall, sign, ...), **Like** (a library ID
   whose size and UV layout it copies, for example `laguna-t004` for a 96 x 32 board), **Size** (`WxH` texels, the
   width a multiple of 4), **Dither** (a fine pattern for gradients in 16 colors). With **Drop pictures here** on,
   PNG and JPG files dropped into the 3D view are added.
3. **Pull from course**: a texture of another course (**Course**, **Texture** `tNNN`; the IDs are on
   `gt2-tools course texture list`, guide 06).
4. Pick a picture in the grid (**Show the course's own** adds the course's textures to it). The box shows the
   **Classic** copy beside the **Full size** one, its size and where it came from.
5. In Edit Mode select faces, then **Use on selected faces**: they get the material `lib:<ID>`.
6. **Check fit**: the fill bar shows how much of the course's video memory the pictures in use take, and when they
   do not fit, by how many texels and the largest free piece.
7. Build:
   * a course edit: **Build (port)** (installs the mod `Edit_<course>`, as guide 08) or **Build (PS1)** (the stock
     game's limits, guide 12). The edit panel's **Build edited course** does not take library pictures;
   * a new track: the **GT2 new track** panel's build buttons, for the port, PS1 or A-Spec (guide 16).

**Remove** drops the picked picture; **Remove unused** drops every added or pulled picture no face uses.

## Without Blender

The library of a course export folder (`--lib` takes the folder, its `textures` folder or `library.json`):

```bat
gt2-tools.exe course export laguna --edit --textures --out work\laguna-edit
gt2-tools.exe texture library init laguna --out work\laguna-edit
gt2-tools.exe texture library add my-pictures\sign.png --lib work\laguna-edit --tags sign --like laguna-t004
gt2-tools.exe texture library add my-pictures\kerb.jpg --lib work\laguna-edit --tags kerb --size 32x32 --id my-kerb
gt2-tools.exe texture library pull roma t053 --lib work\laguna-edit --tags kerb
gt2-tools.exe texture library list --lib work\laguna-edit
gt2-tools.exe texture library report --lib work\laguna-edit --slot laguna
```

```sh
./gt2-tools course export laguna --edit --textures --out work/laguna-edit
./gt2-tools texture library init laguna --out work/laguna-edit
./gt2-tools texture library add my-pictures/sign.png --lib work/laguna-edit --tags sign --like laguna-t004
./gt2-tools texture library add my-pictures/kerb.jpg --lib work/laguna-edit --tags kerb --size 32x32 --id my-kerb
./gt2-tools texture library pull roma t053 --lib work/laguna-edit --tags kerb
./gt2-tools texture library list --lib work/laguna-edit
./gt2-tools texture library report --lib work/laguna-edit --slot laguna
```

Then give faces of the edit file `lib:<ID>` materials (`lib:sign`, `lib:my-kerb`, `lib:roma-t053`) and build with
`--library`:

```sh
./gt2-tools edit laguna work/laguna-edit/laguna.edit.glb --out work/laguna-lib --mod Edit_laguna --library work/laguna-edit
```

Add `--target ps1` or `--target aspec` (guides 12 and 14) the same way. A new track's scene folder needs no switch:
`track build` packs the `lib:` pictures its faces name (guide 16). `texture library remove ID --lib ...` drops a
picture; `texture library pack --lib ... --slot laguna --uses EDITED.glb --out DIR` writes the packed `.trp` and
`.tro` for the pictures that file's faces name, and the fit report, to look at (it does not apply the edit itself).
`report --uses EDITED.glb` does the same for the report alone.

### The fit report

```text
laguna: room step: none
laguna: kept: 215 of 215 base TIMs, 136950 halfwords; free 20038 halfwords, 32 CLUT cells
laguna: largest free rectangle: 136x64 texels (a bigger picture cannot fit in one piece)
laguna: new pictures: 3 (0 merged duplicates), 1280 halfwords = 5120 texels, 3 CLUTs
laguna: VRAM fill: 88.1% of the region
laguna: fits
laguna: close GT2 textures for sign (96x32): autumn t062 96x32 (color 26), cart t030 64x64 (color 15), ...
```

* **room step**: how far the packer had to go: `none`, then `unused` (textures nothing reads dropped), `far` (far
  copies dropped: far faces show the near texels), `compact` (textures slid together). `--room STEP` caps it.
* **largest free rectangle**: no picture bigger than this fits.
* When it does not fit: **over by N texels**, the pictures with no place and the biggest ones. Use smaller sizes
  (`--size`), fewer pictures, or a close GT2 texture the report suggests (`pull` it, or `--like` it).
* The same picture twice is packed once (merged duplicates).

## Sharing

Share your own pictures (`textures/source/<your ID>.png`) and the commands, or the result as an A-Spec patch
(guide 14). Never share `library.json` with the course's or pulled pictures, the `source` and `classic` folders as
they are, or the export folder: they hold GT2's textures. Every picture made from a disc is marked
`"share": false` in `library.json`.
