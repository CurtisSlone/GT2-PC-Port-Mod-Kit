# 2. The mods folder

The game loads modded files from `mods\`, next to `psx-play.exe`. **Nothing in `data\` is ever changed** and no
archive is rebuilt: at start, the files in your mods take the place of the game's files of the same name, in
memory.

## Layout

Each subfolder of `mods\` is one mod. Inside it, files sit at the same paths as in `data\gt2vol\inflated\` (or
`raw\`):

```text
mods\GreenCar\carobj\t2mgn.cdp                 a car's paint (from GT2TextureEditor)
mods\GreenCar\carobj\t2mgn.cdo                 its model (from GT2ModelTool)
mods\FastCar\carparam\usa_gtmode_data.dat      car specs (from GT2DataSplitter)
mods\MyTrack\crsobj\zz_mytrack.tro.gz          a new course (from gt2-trackc)
mods\MyTrack\.crsinfo                          files at the archive's top level go at the top of the mod
```

`mods\load-order.txt` lists the mods to load, one per line, in order (later ones win when two mods have the same
file). A line starting with `#` is off. Without `load-order.txt`, every folder loads, in alphabetical order.

Plain files and `.gz` files both work. A plain file under a name the archive stores compressed is compressed at
start, and a `.gz` file you made yourself is served as it is. pez2k's tools write files that load as they are.

At start, the console window lists each mod and every file it replaces or adds, with sizes. A file with a name
the game does not know, in a folder the archive does not have, is listed as **ignored**.

## Replacing and adding

* **Replacing**: a file with the name of a game file replaces it. Limits the game sets:
  * car model `.cdo` / `.cno`: at most **20,480 bytes** unpacked (the race gives each car a slot that size);
  * car paint `.cdp` / `.cnp`: exactly **45,984 bytes** (GT2TextureEditor always writes that);
  * `carparam\usa_gtmode_data.dat`: at most 819,200 bytes. Keep the other `carparam` files no larger than the
    originals.
* **Adding**: a file with a new name, in a folder the archive has, is **added** to the game's archive: new cars,
  courses and minimaps. The new file goes into its folder in name order, and every later file's number moves up.
  That is why new car codes and course names must sort after the game's own (guides 05 and 06): then nothing
  that exists moves. The archive can grow by about 7,000 files and 328 MB.

## Saves and mods

GT2 keeps your garage on the memory card. A save made with a mod that **adds** a car or a course uses something
only that mod has. Loaded without it, the game would crash looking the car up. So:

* When you save with mods on, psx-play writes `cards\card1.mcr.mods.json` next to the card. It lists the
  active mods and which of them add files.
* When you start with that card and a mod that **adds** files is missing, psx-play **refuses the card** and names
  the mod. Turn the mod back on, use another card (`play-gt2.bat --card1 cards\other.mcr`), or start with
  `--card-mods ignore`, which only warns, and the game may crash on that save.
* A missing mod that only **replaces** files, such as a repaint or changed specs, is a warning only. The save
  loads with the game's own files.
* Money and cars won with a modded car stay in the save after you remove the mod.

**Play mods on a separate card**: `play-gt2.bat --card1 cards\modded.mcr`. Keep the backups on (the default);
they go into `cards-backup\` before each session's first save.

## Sharing mods: what is yours and what is the game's

Mods often hold files the tools made **from game files**. Those are copies of copyrighted data even after your
edits. Share only what is your own work:

| File | Made by | Contains | Share? |
|---|---|---|---|
| `crsobj\zz_*.tro.gz`, `zz_*.trp.gz`, `crsmap\zz_*.tim.gz` | gt2-trackc | your track geometry, generated textures and minimap | yes |
| your own `.glb` models, `.json` specs, Blender files without imported game data | you | your work | yes |
| `.crsinfo` | gt2-trackc, gt2-course add-course | the game's course table with your record appended | **no** |
| `carparam\usa_gtmode_data.dat`, `usa_gtmode_race.dat`, `usa_unistrdb.dat` | gt2-course add-car / add-course, GT2DataSplitter | the game's car, event and text tables | **no** |
| `gtmenu\...`, `.carinfo*`, `.carcolor`, `carlogo\` | gt2-course add-car | game menu pages, names, logos | **no** |
| `carobj\*.cdo/.cno/.cdp/.cnp` | GT2ModelTool / GT2TextureEditor | your model or paint, **unless** it is still the game's car | only if it is your own model/paint |
| anything exported with `gt2-course export` or `textures`, the starter `.blend` | gt2-course, the add-on | the game's courses, textures, models | **no** |

To share a track, share its spec, `.glb` and the files marked "yes". The other player then builds the
`.crsinfo` and menu files on their own PC with the same commands, from their own install.
