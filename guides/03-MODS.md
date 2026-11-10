# 3. The mods folder

UGT2R loads modded files from **`mods`**, in the port folder. **Nothing in `data` is ever changed** and no archive
is rebuilt: at start, the files in your mods take the place of the game's files of the same name, in memory.

## Layout

Each subfolder of `mods` is one mod. Inside it, files sit at the same paths as in `data/gt2vol/inflated` (or
`raw`):

```text
mods/RedMR2/carobj/t2mgn.cdp                  a car's paint (gt2-tools car import)
mods/Car_t2mgn/carobj/t2mgn.cdo               its model (gt2-tools car import, or the add-on's car panel)
mods/MyTrack/crsobj/zz_mytrack.tro.gz         a new course (gt2-tools track new, or the add-on)
mods/MyTrack/.crsinfo                         files at the archive's top level go at the top of the mod
mods/RetexLaguna/crsobj/laguna.trp            a retextured course (gt2-tools course texture replace)
mods/RetexLaguna/textures-override/...        the same pictures at full resolution for the remaster look
```

`textures-override` is special: it is not part of the game's archive. It holds replacement pictures for the
remaster look (the native scene), found by texture ID. guides/06-RETEXTURE-A-COURSE.md writes it for you.

**`mods/load-order.txt`** lists the mods to load, one folder name per line, in order (later ones win when two mods
have the same file). A line starting with `#` is off. Without `load-order.txt`, every folder loads, in alphabetical
order. The release ships a `load-order.txt` with only comments in it. Mods you make load once you add their lines.

Add a line from a command prompt in the port folder:

```bat
echo MyMod>> mods\load-order.txt
```

```text
echo MyMod >> mods/load-order.txt
```

Or open it in Notepad (Windows) or any text editor (Linux).

Plain files and `.gz` files both work. A plain file under a name the archive stores compressed is compressed at
start, and a `.gz` file you made yourself is served as it is.

At start, the console lists each mod and every file it replaces or adds, with sizes. A file with a name the game
does not know, in a folder the archive does not have, is listed as **ignored**.

## The Grand Tour 99 menus: under your mods

The Grand Tour 99 menus are part of the game, not a mod. The installer builds them into **`data/builtin`**, laid out
like a mod folder. They replace four GT Mode pages (the city map, Wheel Shop, Car Wash, Machine Test) and add one
(the Tuning Village hub, page 3382). guides/02-PLAY.md says what they change.

UGT2R loads `data/builtin` first, at every start, then your mods in their order. So:

* they stay with an empty `mods` folder, without `load-order.txt` lines and with `--mods none`;
* a mod of yours with one of those pages (for example `gtmenu/usa/gtmenudat.dat/0000.bin`, the city map) wins: your
  page is used. A mod that adds its own page 3382 replaces the Tuning Village hub.

They are not in the download: `gt2-tools` makes the pages on your PC from your own disc (the signs and words are cut
from GT2's own city map and title lettering; only our own drawings ship inside `gt2-tools`). Build them again any
time, for example after deleting `data/builtin`:

```bat
gt2-tools.exe builtin build
```

```sh
./gt2-tools builtin build
```

Run it in the port folder: it reads `data` and writes `data/builtin`. `install-gt2 verify` does not count
`data/builtin` as a difference and leaves it as it is.

**From an earlier build:** an install from before this release has the same menus as a mod, `mods/GrandTour99`, with
a line `GrandTour99` in `mods/load-order.txt`. It still works and is left as it is: it loads on top of
`data/builtin` with the same pages. You can delete the folder and the line.

**Testing only:** `--builtin off` (or `PSX_BUILTIN=off`) starts without `data/builtin`, with GT2's own city map
(guides/13-FLAGS-AND-SETTINGS.md).

## Replacing and adding

* **Replacing**: a file with the name of a game file replaces it. Limits the game sets:
  * car model `.cdo` / `.cno`: at most **20,480 bytes** unpacked (the race gives each car a slot that size);
  * car paint `.cdp` / `.cnp`: exactly **45,984 bytes** (`gt2-tools car import` always writes that);
  * `carparam/usa_gtmode_data.dat`: at most 819,200 bytes. Keep the other `carparam` files no larger than the
    originals;
  * course `.tro` and `.trp`: at most 700,000 bytes each, unpacked (the tools check this).
* **Adding**: a file with a new name, in a folder the archive has, is **added** to the game's archive: new cars,
  courses and minimaps. The new file goes into its folder in name order, and every later file's number moves up.
  That is why new car codes and course names must sort after the game's own (guides 10 and 11): then nothing that
  exists moves. The archive can grow by about 7,000 files and 328 MB. Added files run only in this port.

## Mods and the two looks

UGT2R draws races in two looks: the remaster look (the native scene, the default) and the classic look (GT2's own
drawing, F1 switches). A course or car mod changes the game's files, so it shows in both. The remaster look converts
the course or car again when a mod changes it (the first race after that is slower). A retexture mod also carries
full-resolution pictures for the remaster look in `textures-override`.

## Saves and mods

GT2 keeps your garage on the memory card. A save made with a mod that **adds** a car or a course uses something
only that mod has. Loaded without it, the game would crash looking the car up. So:

* When you save with mods on, UGT2R writes `cards/card1.mcr.mods.json` next to the card. It lists the active mods
  and which of them add files.
* When you start with that card and a mod that **adds** files is missing, UGT2R **refuses the card** and names the
  mod. Turn the mod back on, use another card (`--card1 cards/other.mcr`), or start with `--card-mods ignore`,
  which only warns, and the game may crash on that save.
* A missing mod that only **replaces** files, such as a repaint or a retexture, is a warning only. The save loads
  with the game's own files.
* Money and cars won with a modded car stay in the save after you remove the mod.

**Play mods that add things on a separate card**: start UGT2R with `--card1 cards/modded.mcr`
(guides/13-FLAGS-AND-SETTINGS.md shows how to make a shortcut). Card backups are off by default in this release:
copy your card now and then, or start with `--card-backups cards-backup`.

## Sharing mods: what is yours and what is the game's

Mods often hold files the tools made **from game files**. Those are copies of copyrighted data even after your
edits. Share only what is your own work:

| File | Made by | Contains | Share? |
|---|---|---|---|
| `crsobj/zz_*.tro.gz`, `zz_*.trp.gz`, `crsmap/zz_*.tim.gz` of a new track | `gt2-tools track new`, the add-on | your track geometry, generated textures and minimap | yes |
| a track spec `.json`, a center line `.glb` / `.csv` you drew | you | your work | yes |
| a course edit's `.gt2patch` | `gt2-tools edit`, the add-on | only your changes | yes |
| pictures you painted yourself (for `texture replace`) | you | your work | yes |
| `crsobj/<course>.trp` and `textures-override` of a retexture | `gt2-tools course texture replace` | the game's course textures with your pictures in them | **no**: share your pictures and the commands |
| `crsobj/<course>.tro` of a course edit | `gt2-tools edit` | the game's course with your changes | **no**: share the `.gt2patch` |
| `.crsinfo` | `gt2-tools track new`, `course add-course` | the game's course table with your record appended | **no** |
| `carparam/usa_gtmode_data.dat`, `usa_gtmode_race.dat`, `usa_unistrdb.dat` | `gt2-tools car add-car`, `course add-course` | the game's car, event and text tables | **no** |
| `gtmenu/...`, `.carinfo*`, `.carcolor`, `carlogo/` | `gt2-tools car add-car` | game menu pages, names, logos | **no** |
| `data/builtin` (and an older `mods/GrandTour99`) | the installer, `gt2-tools builtin build` | game menu pages with our changes | **no**: everyone builds it from their own install |
| `carobj/*.cdo/.cno/.cdp/.cnp` | `gt2-tools car import`, the add-on | the game's car with your changes, **unless** the model or paint is entirely your own | only if it is entirely your own |
| anything from `course export`, `car export`, `course catalog`, `texture list`, the starter `.blend`, a `.blend` with a GT2 course or car in it, a `textures` folder from `export --edit --textures` | gt2-tools, the add-on | the game's courses, cars, textures | **no** |

To share a track, share its spec or `.glb` and the course files marked "yes". To share a course edit, share the
`.gt2patch`. To share a retexture, share your pictures and the `texture replace` commands. The other player builds
the rest on their own PC, from their own install.
