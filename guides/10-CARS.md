# 10. Cars

`gt2-tools car` opens GT2's car files from **your** install: export a car to JSON and PNG, change it, build it back,
preview it, edit its model in Blender, and add a **new** car with its own code next to the 1,110 on the disc.

Type the commands in a command window in the port folder (guides/04-TOOLS-SETUP.md). Never edit files inside
`data`; work in a folder of your own (the guides use `work`).

Car files are named after the car's 5-character code (for example `t2mgn` = Toyota MR2 G-Limited '98). Each car has
four files in `carobj`: `.cdo` (model, day), `.cno` (model, night), `.cdp` (paint, day), `.cnp` (paint, night).

**Limits, up front:**

* The model and the paint can be changed. **Specs (power, weight, gearing) and the car's name tables have no tool
  in this kit yet.** A new car takes its donor's specs; `add-car` sets its name lines and price.
* A model may be at most **20,480 bytes** (the race gives each car a slot that size). The tools check it.
* In Blender, cars are **mesh only**: the paint is the game's own and is not shown.
* About **10 new cars** fit before the game's boot table of car files is full.
* A new car's dealer tile keeps the donor's photo; the maker, the wheels and the engine sound are the donor's.

## Find a car

```bat
gt2-tools.exe car list
```

```sh
./gt2-tools car list
```

Every car code with the files it has. `data/gt2vol/inflated/carobj` has unpacked copies of all the car files.

## Export, change, build back

```bat
gt2-tools.exe car export t2mgn --out work\t2mgn
gt2-tools.exe car import work\t2mgn --out work\t2mgn-built --gzip
```

```sh
./gt2-tools car export t2mgn --out work/t2mgn
./gt2-tools car import work/t2mgn --out work/t2mgn-built --gzip
```

`car export` writes:

```text
car.json            the car code, and per file its size and checksum
day/model.json      the .cdo: 3 levels of detail (LODs), the shadow, the wheel positions
day/paints.json     the .cdp's paints: per paint 16 sub-palettes of 16 colors
day/texture.png     the 256x224 bitmap as an indexed PNG on a gray ramp (index k = gray 17k)
night/...           the same for .cno / .cnp
view/<car>.gltf     a 3D view for Blender or a glTF viewer, with every paint
```

What you can change:

* **Paint colors**: the `colours` in `day/paints.json` (and `night/paints.json`), 15-bit BGR words, 16 per
  sub-palette.
* **The bitmap**: `day/texture.png`. Keep it 256x224 and on the 16-step gray ramp (each pixel picks a color of its
  face's sub-palette). The 48x48 top-left corner is overwritten by the wheel hub when the game loads the car: do not
  use it for the body.
* **The model**: vertices and faces in `day/model.json`. Easier in Blender (below).

`car import` builds the four files back. Unchanged, they are identical to the game's. It checks every limit with a
message that names the place, for example `day/model.json: the model is 26808 bytes, the race slot holds 20480`.

To play the changed car, put its files in a mod and turn the mod on:

```bat
mkdir mods\RedMR2\carobj
copy work\t2mgn-built\t2mgn.cdp.gz mods\RedMR2\carobj\
copy work\t2mgn-built\t2mgn.cnp.gz mods\RedMR2\carobj\
echo RedMR2>> mods\load-order.txt
```

```sh
mkdir -p mods/RedMR2/carobj
cp work/t2mgn-built/t2mgn.cdp.gz work/t2mgn-built/t2mgn.cnp.gz mods/RedMR2/carobj/
echo RedMR2 >> mods/load-order.txt
```

Copy only the files you changed (here the paints). The console lists the replaced files at start.

## Preview

```bat
gt2-tools.exe car preview t2mgn --out work\t2mgn-preview.png
```

```sh
./gt2-tools car preview t2mgn --out work/t2mgn-preview.png
```

Side, top, front and back pictures of the car's near model in one paint (`--paint N` picks another, `--night` the
night model). A quick check of the shape without Blender; it is not the game's renderer.

## Edit a car's model in Blender

Set up the add-on first (guides/04-TOOLS-SETUP.md). In the **GT2** tab, panel **GT2 Car**:

1. Save your .blend first. Type the car's code in **Car** (a search field: start typing, for example `t2mgn`).
2. **Export car for editing**: the car opens as `lod0` (the near model), `lod1`, `lod2`, `shadow` and the wheel
   centers `wheel_0` to `wheel_3`. With **Night model too** the night model opens as well (in its own collection,
   hidden).
3. Edit: move vertices, delete faces, add faces (give them a `pal:NN` or `untex` material). **Keep the object
   names.** Moving a wheel empty moves that wheel's center.
4. **Build edited car**: rebuilds the model with `gt2-tools car import` and installs the mod `Car_<car>` (its model
   files in `carobj`) into the port's `mods` folder.
5. **Preview**: side, top, front and back pictures of the built car (or the original before a build), shown in the
   panel.

The .blend holds the game's car model: keep it for yourself.

Without the add-on: `car export --edit` writes the editable `.glb` files, and `car import --glb` merges an edited
one back:

```bat
gt2-tools.exe car export t2mgn --edit --out work\t2mgn-edit
gt2-tools.exe car import work\t2mgn --glb work\t2mgn-edit\t2mgn.edit.glb --out work\t2mgn-built --gzip
```

```sh
./gt2-tools car export t2mgn --edit --out work/t2mgn-edit
./gt2-tools car import work/t2mgn --glb work/t2mgn-edit/t2mgn.edit.glb --out work/t2mgn-built --gzip
```

Import `t2mgn.edit.glb` in Blender (File > Import > glTF 2.0), edit, and export it again as `.glb` with **Include >
Custom attributes** on and **+Y up**. The `_GT2_*` vertex attributes are the ids: leave them. Details:
`guides/reference/CARS-AND-SAVES.md`.

## A new car with its own code

A new car never touches an existing car or save. `car add-car` writes it as a mod folder, starting from a copy of a
donor you pick:

```bat
gt2-tools.exe car add-car --out mods\MyCar --donor t2mgn --code zz01n --grade "X3 Custom '24" --price 19999 --dealer t2mgn
echo MyCar>> mods\load-order.txt
```

```sh
./gt2-tools car add-car --out mods/MyCar --donor t2mgn --code zz01n --grade "X3 Custom '24" --price 19999 --dealer t2mgn
echo MyCar >> mods/load-order.txt
```

**The one rule: the code must sort after `x2wsr`**, the highest code on the disc. Start it with `y` or `z`, for
example `zz01n`. Allowed characters: `-0123456789abcdefghijklmnopqrstuvwxyz`. The last character is the variant;
`n` means stock. Every table the car is in is sorted by code, and saves keep positions in those tables. Only a code
that sorts last appends at the end of every table, so every saved car keeps pointing at its own parts. The tool
refuses any other code.

| Option | What it does |
|---|---|
| `--donor t2mgn` | the car copied. It must be a car sold in GT Mode. Its specs, engine sound, wheels, maker, colors, logo and every part and upgrade come with it |
| `--code zz01n` | the new code |
| `--grade "..."` / `--model "..."` | the two lines of the car's name in the menus (default: the donor's) |
| `--full-name "..."` | the name in race and replay captions (default: the donor's maker + model + grade) |
| `--price N` | the new-car price (default: the donor's) |
| `--dealer t2mgn` | the dealer button that sells this car now sells the new one. The button keeps its picture, so give the donor's own button |
| `--cdo F --cno F --cdp F --cnp F` | your own model and paint files instead of the donor's (from `car import`) |

A new car with your own paint, built above:

```bat
gt2-tools.exe car add-car --out mods\MyCar --donor t2mgn --code zz02n --grade "Red Custom" --cdp work\t2mgn-built\t2mgn.cdp --cnp work\t2mgn-built\t2mgn.cnp
```

```sh
./gt2-tools car add-car --out mods/MyCar --donor t2mgn --code zz02n --grade "Red Custom" --cdp work/t2mgn-built/t2mgn.cdp --cnp work/t2mgn-built/t2mgn.cnp
```

Running it again on the **same** `--out` folder with a later code (`zz02n` after `zz01n`) adds a second car. Keep
all new cars in one mod: each car mod carries the whole car table, and the later mod would win.

**Play it**: with `MyCar` in `mods/load-order.txt`, start UGT2R. For the first example: East City, then Toyota,
NEW, LINEUP 2. The "MR2 G-Limited" tile now shows your price and sells your car. Use a separate memory card
(guides/03-MODS.md).

**Sharing**: the car tables, the menu pages, `.carinfo*`, `.carcolor` and the logos in the mod are edited game
files. Do not share them. Share the `add-car` command line (and your own model or paint, if it is entirely yours);
the other player runs it on their own install (guides/03-MODS.md, "Sharing mods").
