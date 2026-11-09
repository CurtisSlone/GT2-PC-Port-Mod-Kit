# 6. Retexture a course

Put your own pictures on a GT2 course: a sponsor board, a road surface, a wall, a building. You paint over the
game's texture (or start from scratch), and `gt2-tools course texture replace` builds a mod that shows your picture
**in both looks**:

* **classic** (GT2's own drawing, the PlayStation look): your picture reduced to the texture's size and 16 colors,
  as the console would show it;
* **remaster** (the native scene, UGT2R's default): your picture at full resolution.

One mod, both looks. F1 in a race switches between them.

**Limits, up front:**

* A whole texture is replaced. Some textures are used in several places (Laguna's main road texture is also on
  77 object faces): the list shows what else changes.
* In the classic look a texture has 16 colors. When other textures share its palette, your picture can use only the
  colors the course already has there (the command says which textures share it).
* Skies and the shared sprites are not course textures and are not listed here.
* On courses whose sponsor boards GT2 paints at every race start, a texture under a board slot shows the board in
  the classic look (`replace` says so). Laguna Seca's boards are its own textures, so they can be replaced.
* The retexture mod holds the game's course texture file with your pictures in it: share your pictures and the
  commands, not the mod (guides/03-MODS.md).

## 1. See the textures

```bat
gt2-tools.exe course texture list laguna --out work\laguna-textures
```

```sh
./gt2-tools course texture list laguna --out work/laguna-textures
```

You get:

```text
laguna.textures.png    a contact sheet: every texture with its ID under it (t000, t001, ...) and its size
laguna.textures.json   per texture: ID, size, where it is used (road, kerb, grass, gravel, dirt, ground, wall,
                       sign, building, object, tree) and how many faces, its far copy
laguna/t004.png        each texture at its own size, to paint over
```

Open the contact sheet and find the texture you want. On Laguna Seca, `t004` is a BOSCH board (96x32) and `t013`
the main road (128x32). Gray IDs are "far copies": the half-size version GT2 draws far away. You never replace those
yourself; they follow their texture.

## 2. Paint

Make your picture: PNG, JPEG or SVG, any size. Keep the texture's shape (a 96x32 board: 3 to 1). Paint at a large
size, for example 960x320: the remaster look shows it at full resolution, and the classic look reduces it.
Transparent pixels (PNG alpha under half) stay transparent in the game. A good start is the texture's own
`laguna/t004.png` scaled up in your image editor.

The guides use a folder `my-pictures` in the port folder for your pictures.

## 3. Replace

```bat
gt2-tools.exe course texture replace laguna t004 my-pictures\board.png --mod RetexLaguna
gt2-tools.exe course texture replace laguna t013 my-pictures\road.png --mod RetexLaguna --dither
echo RetexLaguna>> mods\load-order.txt
```

```sh
./gt2-tools course texture replace laguna t004 my-pictures/board.png --mod RetexLaguna
./gt2-tools course texture replace laguna t013 my-pictures/road.png --mod RetexLaguna --dither
echo RetexLaguna >> mods/load-order.txt
```

Each command takes about 10 seconds. It writes straight into the mod `mods/RetexLaguna`:

* `crsobj/laguna.trp`: the course's textures with yours in them, at 16 colors (the classic look). The far copy is
  redrawn from the same picture. `--dither` adds a fine ordered dither, which can help gradients in 16 colors.
* `textures-override/`: your picture at full resolution for the remaster look, plus a copy of your picture and a
  list of what the mod holds (`textures-override/retexture/laguna.json`).

The IDs can be written `t004`, `T4`, `4` or `004`. Replacing the same ID again replaces the picture. The result does
not depend on the order of the commands: every run rebuilds the mod's course file from your install.

Start UGT2R and race on Laguna Seca. Press F1 to compare the remaster look and the classic look.

## 4. Undo one picture

```bat
gt2-tools.exe course texture restore laguna t013 --mod RetexLaguna
```

```sh
./gt2-tools course texture restore laguna t013 --mod RetexLaguna
```

The game's texture comes back in that mod. With no picture left, the mod's course files are removed too.

## Several courses, several mods

Run `replace` with other courses into the same mod, or into separate mods. A retexture mod only holds the `.trp`,
so it combines with a course edit of the same course (guides/08-EDIT-A-COURSE.md), which only holds the `.tro`. Put
the edit first and the retexture after it in `mods/load-order.txt`.

## Sharing

Share your pictures and the list of commands (`course`, `ID`, picture name). Another player runs the same commands
on their own install and gets the same mod, byte for byte. Do not share the mod folder itself: its `laguna.trp` is
the game's file.

## More for the remaster look

`gt2-tools help course` also lists `course tile-texture` (any picture as a tiling remaster texture), `course grass`
(new grass art for the remaster look) and `course backdrop` (the sky's backdrop as one panorama to paint). They
write remaster pictures only, into a mod's `textures-override` folder. They are in this release as they are and are
not covered by these guides yet.
