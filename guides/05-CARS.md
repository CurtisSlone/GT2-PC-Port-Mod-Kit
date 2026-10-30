# 5. Cars: edit one, or add a new one with its own ID

Two jobs, two kinds of tools:

* **Our tool** `gt2-course.exe add-car` makes the *slot*. It writes a new car with its own code, next to the
  1,110 on the disc, as a mods folder. The car starts as a copy of a donor car.

Work in a folder of your own, for example `C:\Games\gt2-pc-port\work`. Never edit files inside `data\`. The
commands below are typed in a command prompt opened in the port folder.

Car files are named after the car's 5-character code (e.g. `t2mgn` = Toyota MR2 G-Limited '98). Each car has four
files in `carobj`: `.cdo` (model, day), `.cno` (model, night), `.cdp` (paint, day), `.cnp` (paint, night). Unpacked
copies of all of them are in `data\gt2vol\inflated\carobj\`.

## A. Edit an existing car (a repaint, a new model, other specs)

### Paint and colours (GT2TextureEditor)

```text
mkdir work & copy data\gt2vol\inflated\carobj\t2mgn.cdp work\
kit\tools\GT2TextureEditor\GT2TextureEditor.exe work\t2mgn.cdp
```

This writes a folder `work\t2mgn\` with the bitmap and palettes. Edit them with an editor that keeps indexed
colour, such as GIMP or Paint.NET: keep the size and the 16-colour palettes. Then rebuild:

```text
kit\tools\GT2TextureEditor\GT2TextureEditor.exe work\t2mgn
mkdir mods\GreenMR2\carobj & copy work\t2mgn.cdp mods\GreenMR2\carobj\
```

The paint must be exactly 45,984 bytes; the tool always writes that size. `.cnp` (night) works the same.

### Model (GT2ModelTool)

```text
copy data\gt2vol\inflated\carobj\t2mgn.cdo work\
kit\tools\GT2ModelTool\GT2ModelTool.exe -oe work\t2mgn.cdo        (-> t2mgn.json, .obj, .mtl)
    edit the .obj in Blender (File > Import > Wavefront OBJ; export the same way), keep the .json beside it
kit\tools\GT2ModelTool\GT2ModelTool.exe -o2 work\t2mgn.json       (-> t2mgn.cdo)
copy work\t2mgn.cdo mods\MyMR2\carobj\
```

The game gives each car's model **at most 20,480 bytes**. GT2ModelTool's readme.txt explains the model format and
its rules: overlapping faces, wheels, LODs and shadows. Read it before editing; the format is demanding.

### Specs (GT2DataSplitter)

GT2DataSplitter works on the three gzipped US data files in its current folder:

```text
mkdir work\specs & copy data\gt2vol\raw\carparam\usa_gtmode_data.dat.gz work\specs\
copy data\gt2vol\raw\carparam\usa_gtmode_race.dat.gz work\specs\
copy data\gt2vol\raw\carparam\usa_unistrdb.dat.gz work\specs\
cd work\specs
..\..\kit\tools\GT2DataSplitter.bat usa_gtmode_data.dat.gz     (-> CSV folders: Engine, Brakes, ... one row per car)
    edit the CSV rows of your car (e.g. Engine\t2mgn.csv, PowerMultiplier)
..\..\kit\tools\GT2DataSplitter.bat                            (no arguments: rebuilds the .dat.gz files)
cd ..\..
```

Put the rebuilt `usa_gtmode_data.dat.gz` at `mods\PowerMR2\carparam\usa_gtmode_data.dat.gz`. The tool's
readme.txt says where it writes the rebuilt files. It writes tens of thousands of small CSV files, which can take
a while. The data file may grow to at most 819,200 bytes unpacked; GT2DataSplitter refuses anything bigger, and
so would the game.

### Names and colour names (GT2CarInfoEditorCSV)

Copy `.carinfoa`, `.carinfoe`, `.carinfoj`, `.carcolor`, `.ccjapanese` and `.cclatain` from
`data\gt2vol\raw\` into the tool's folder (`kit\tools\GT2CarInfoEditorCSV\`), drag one onto `GT2CarInfoEditorCSV.exe` (CSV files appear), edit,
then drag a CSV back onto it. Put the changed files at the top of a mod: `mods\MyNames\.carinfoa`.

Turn the mod on in `mods\load-order.txt` and start the game. The console lists the replaced files.

## B. A new car with its own ID

A new car never touches an existing car or save. `gt2-course add-car` writes it as a mods folder, starting from a
copy of a donor you pick:

```text
gt2-course.exe add-car --vol data\gt2vol --out mods\MyCar --donor t2mgn --code zz01n ^
    --grade "X3 Custom '24" --price 19999 --dealer t2mgn
```

**The one rule: the code must sort after `x2wsr`**, the highest code on the disc. Start it with `y` or `z`, e.g.
`zz01n`. Allowed characters: `-0123456789abcdefghijklmnopqrstuvwxyz`. The last character is the variant; `n` means
stock. Every table the car is in is sorted by code, and saves keep positions in those tables. Only a code that
sorts last appends at the end of every table, so every saved car keeps pointing at its own parts. The tool refuses
any other code.

| Option | What it does |
|---|---|
| `--donor t2mgn` | the car copied. It must be a car sold in GT mode. Its engine sound, wheels, maker, colours, logo and every part and upgrade come with it |
| `--code zz01n` | the new code |
| `--grade "..."` / `--model "..."` | the two lines of the car's name in the menus (default: the donor's) |
| `--full-name "..."` | the name in race and replay captions (default: the donor's maker + model + grade) |
| `--price N` | the new-car price (default: the donor's) |
| `--dealer t2mgn` | the dealer button that sells this car now sells the new one. The button keeps its picture, so give the donor's own button |
| `--cdo F --cno F --cdp F --cnp F` | your own model/paint files instead of the donor's (from part A) |

Run it again on the **same** `--out` folder with a later code (`zz02n`) to add a second car. Keep all new cars in
one mod: each car mod carries the whole `usa_gtmode_data.dat`, and the later mod would win.

Then make the car your own with part A's tools, working on the files **in `mods\MyCar`**:

* model and paint: run add-car again with `--cdo/--cno/--cdp/--cnp`, or copy your plain file over
  `mods\MyCar\carobj\zz01n.cdo.gz`. A plain file under a `.gz` name is compressed at start;
* specs: GT2DataSplitter on `mods\MyCar\carparam\usa_gtmode_data.dat`. The new car's rows are named `zz01n` and
  come last; edit those, not the donor's;
* names: GT2CarInfoEditorCSV on `mods\MyCar\.carinfoa` / `.carcolor` (the new car is the last entry).

**Play it**: add `MyCar` to `mods\load-order.txt` and start the game. For the example above: East City, then
Toyota, NEW, LINEUP 2. The "MR2 G-Limited" tile now shows your price and sells your car. Use a separate memory
card (guides\02-MODS.md).

What stays the donor's for now: the dealer tile's photo and the name logo on the car page, the maker, the wheels
(the wheel table is full) and the engine sound set. About 10 new cars fit before the game's boot table of car
files is full.

**Sharing**: `usa_gtmode_data.dat`, `usa_unistrdb.dat`, the menu pages, `.carinfo*`, `.carcolor` and the logos in
the mod are edited game files. Do not share them. Share your own model/paint files and the add-car command line,
and the other player runs it on their own install (guides\02-MODS.md, "Sharing mods").
