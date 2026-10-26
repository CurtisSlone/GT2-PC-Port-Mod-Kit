# GT2 modding limits

Every hard limit a course, car or archive mod runs into, with the number, the game's reason (the function in the
public byte-matched decompilation, [GT2-Decomp](https://github.com/CurtisSlone/GT2-Decomp), that sets it) and what happens past it. US Simulation disc
(SCUS-94488), played in this port. Details: [COURSE-FORMAT.md](COURSE-FORMAT.md), [TRACK-SPEC.md](TRACK-SPEC.md),
[CARS-AND-SAVES.md](CARS-AND-SAVES.md).

"The tools check" means `gt2-trackc` / `gt2-course` refuse or warn; "not checked" means nothing stops you, so stay
inside the number yourself.

## Courses

| Limit | Number | Why (the game's rule) | Past it |
|---|---|---|---|
| Vertices per section mesh | **512** | track face indices are 9 bits (face words read by the track renderers `func_80020FF8` / `func_80023484` and the collision code) | cannot be expressed. `gt2-trackc` refuses: fewer `lanes` or a longer `row_length` |
| Vertices per object model | 1,024 | model face indices are 10 bits | cannot be expressed; `gt2-trackc` splits bigger models into parts |
| Sections per course | 16,383 | visibility entries hold a 14-bit section index (2 bits are the level) | cannot be expressed; `gt2-trackc` refuses |
| Visibility list entries per section | **256** | `func_8002009C` sorts the listed sections into a 256-entry array before drawing | the array overflows. The tools check (the compiler stops at 256) |
| Draw distance | the visibility lists | a section not in the current section's list is **never drawn** (`func_8002009C`) | missing sections: holes in the scenery. Too many listed: slowdown (below) |
| Faces drawn per frame | **no known hard number** | the game's primitive buffer limit has not been measured | the game slows down. `gt2-trackc` warns when the draw load passes every course of the game, and when more than 3,000 model faces can be in view from one section. Its default visibility of 60 m stays within the game's own load |
| Scenery in one course | 4,000 model faces, 300 instances (compiler budget) | the game's own courses have at most 3,629 model faces and 168 instances | `gt2-trackc` refuses (raise `scenery_budget` at your own risk) |
| Object groups | 32 zones + 1 always drawn | 33 instance groups in the header; a section's 32-bit mask picks which are drawn (`func_8001FFB8`) | fixed by the format |
| `.tro` size (inflated) | **700,000 bytes** (same for the `.trp`) | inflated to 0x800B4724 (`func_800273C8`); the race's car models are loaded before it and sit right after it, from 0x8015F584 (`func_80028D88`). The `.trp` is inflated into the same buffer first. The largest shipped `.tro` is 696,792 bytes (highway). Same limit on a PlayStation and in this port | overwrites car models: the race goes wrong, stops on a black screen or crashes at the start (tested). `gt2-trackc` and `gt2-scenec` refuse to build it; `gt2-trackc check` reports it |
| Textures: colours | **16 per texture (4-bit)** | all course textures are 4-bit TIMs with a 16-colour CLUT (`.trp`, uploaded by `func_80027254`) | not supported by the course renderer. The tools reduce images to 16 colours |
| Textures: page and tiling | 256x256 texels per texture page; UVs inside one page | PlayStation texture pages; the GPU cannot repeat a texture inside one face | wider UVs are clamped (`gt2-trackc` counts them); split big faces instead |
| Textures: size | 256 texels a side at most (compiler `texture_size`, default 128) | one texture must sit inside one page | the compiler downscales |
| VRAM for course textures and CLUTs | the course area: x 640-1023, y 0-511 (every course of the game keeps its `.trp` there) | `.trp` and sky `.bsp` TIMs are uploaded to the rectangles in their own headers (`func_8007BBB0`); the sky is uploaded after the course; sponsor boards are painted into x 640-703, y 0-255 (`func_80027574`) | outside it you overwrite fonts, HUD or car textures: broken graphics. `gt2-trackc` places textures only in the free part of the replaced slot's own area, minus the sky and (with sponsor boards) the sponsor slots |
| Minimap frame | 96x96 pixels, about 25 m per pixel: roughly **+/-1,200 m** around the course origin | the map's scale and origin are constants in `func_80029010`, in no file | the course and car dots run off the map. `gt2-trackc` centres the course and warns past ~2,400 m |
| Course size | 20 km (compiler) | track distances are 32-bit in 1/65,536 m | `gt2-trackc` refuses past 20 km |
| Minimaps | 128 | boot `func_80011B70`'s key table (119 used) | a course with no map shows the first course's map |
| Course numbers | **125, 126, 127** for new courses | the memory card keeps one 36-byte record per course index, **128 slots** (`func_8005E674`, save +0x218); 125 are used | a 129th course's record would overwrite the licence results in the save. The course index itself is a u8 |
| New course names | must sort **after `testline`** (byte order; start with `zz_`); `gt2-trackc`: 1-17 characters, letters, digits, `_`, `-` | the course index is the file's position in the sorted `/crsobj` directory, and saved records are by index | any other name renumbers every later course: saves show and update the wrong courses' times. The tools refuse it |
| `.crsinfo` (course table) | 5,120 bytes (0x1400); 4,007 on the disc, each course adds 24 bytes plus its display name | boot `func_80011C70` loads it into a fixed buffer | overflows that buffer. Not checked by the game (three new courses are far below it) |
| Display name | 31 characters | the race set-up keeps a 32-byte copy (`func_8005E500`) | |
| Unknown course | | a course key not in `.crsinfo` gives course index 0, 2p_autumn (`func_80060DC4`) | the race runs on Autumn Ring |
| Grid slots | 16 in the file; races use up to 6 cars | header 0x58, `func_80012CD4` | |
| Sector splits | 8 | header 0x24/0x28, `func_80033330` | |
| AI line arcs | keep radii under a few km (the game's own lines stay under ~2.3 km) | the game's arc arithmetic overflows on radii of tens of km | the AI drives into the wall. `gt2-trackc` writes flat pieces (over 2.5 km radius) as straights |
| AI line order | node distances ascending from node 0 | the AI's node search (`func_80035BF4`) | the AI cars drive backwards. The validator checks it |
| GT-mode events | 248, fixed | arrays and loop bounds in the GT-mode overlay (`func_80019474`) | a new event ID needs a code change. Pointing an existing event at a new course works |
| Replays | | a replay stores the race set-up, course included | a replay made on a modded course plays only with the same mods |

## Cars

| Limit | Number | Why | Past it |
|---|---|---|---|
| Car model `.cdo` / `.cno` (inflated) | **20,480 bytes** | the race loader `func_80028D88` inflates car *i*'s model to a fixed 0x5000-byte slot; the next car's model follows. Largest original: 20,000 bytes | overwrites the next car's model. **Not checked** by the port. The garage and replay loaders use other buffers that were not measured |
| Car texture `.cdp` / `.cnp` | **exactly 45,984 bytes** | inflated to a scratch buffer whose following bytes the loader also uses (16 palettes of 16 colours + a 4-bit 256x224 bitmap) | GT2TextureEditor always writes this size; keep it |
| Colours per car | 16 | 16 palettes in the `.cdp` | fixed by the texture format |
| `carparam\usa_gtmode_data.dat` (inflated) | **819,200 bytes** (0xC8000); 772,276 on the disc, so about 46,900 bytes of room, roughly 37 cars at ~1.25 KB each | the GT-mode and title overlays load it into a buffer followed by a primitive pool | overwrites that pool. GT2DataSplitter refuses files over this size too. Keep the other `carparam` files no larger than the originals |
| New car codes | must sort **after `x2wsr`** (start with `y` or `z`, e.g. `zz01n`) | every car table is sorted by code and binary-searched, and the save keeps absolute positions in them | any other code shifts existing records: every saved car points at another car's parts. `gt2-course add-car` refuses it |
| Number of new cars | **about 10** | the boot car table (`boot/func_80011710`) has room for 1,121 cars (1,110 used), and `func_8006089C` loops to 1,120 | the table runs into the course table that follows it in RAM. Beyond ~10 cars, game-code changes are needed (not in this release) |
| Car names (`.carinfoa`) | 51,200 bytes; ~3,040 bytes (~60 entries) free | fixed buffer in the GT-mode overlay | overwrites the car database loaded after it |
| Menu name strings (`usa_unistrdb.dat`) | 24,576 bytes; ~3,058 bytes free | fixed buffer in the GT-mode overlay | overflows that buffer |
| Wheels | **192 of 192: full** | boot `func_8001194C`'s key table | a new wheel cannot be added: reuse an existing one (an unknown wheel shows the first wheel) |
| Makers | **39 of 39: full** | the used-car loop runs `< 39` (`func_800224CC`); `.usedcar` has 39 lists | use an existing maker |
| Engine sound sets | 23 free (305 of 328) | boot `func_80011A10`'s key table | reuse an existing set; an unknown set plays set 0 |
| Dealer page buttons | 8 per page | dealer page layout | new tiles with their own picture are not tooled yet; `add-car --dealer` takes over an existing button |
| Garage | 100 cars | save layout; the buy path refuses a 101st | |
| Car missing from the data | | the car lookup (`func_8005D8C0`) returns nothing and its callers read through it | **crash** (garage view, race, replay). This is why the save manifest exists |

## For an unmodified PlayStation (`--target ps1`)

What `--target ps1` enforces (guides\08-CONSOLE-SAFE.md), beyond the course limits above:

| Limit | Number | Why | Past it |
|---|---|---|---|
| Course files | `.tro` and `.trp` at most **700,000 bytes** each, inflated | inflated to 0x800B4724 (`func_800273C8`); the race's car models follow at 0x8015F584 (`func_80028D88`). The same limit applies without `--target ps1` | an error (the course is not built) |
| Coordinates | within **±2,048 m** of the course origin | the GTE's matrix apply saturates (the car start, `func_80012CD4`, folded far grid slots); only this port's fix layer changes that | an error |
| Draw load | at most **2,864** faces drawn from any section's visibility list | the busiest shipped course (test_in2); the console has no frame-time headroom | an error |
| Video memory | every image and palette inside the replaced slot's own `.trp` rectangles | fonts, HUD, cars, the sky and the sponsor slots use the rest | an error |
| Archive | each replaced file's compressed copy fits its original entry's sectors; no added files | GT2.VOL fills its extent on the disc (233,573 sectors) | an error |

## The archive (GT2.VOL) and the mods folder

| Limit | Number | Why | Past it |
|---|---|---|---|
| Added files | **about 7,000** | the boot reads the archive directory into a 0x8C000-byte buffer: 17,920 records, 10,943 used | the directory no longer fits the game's buffer: stay under it |
| Total entries | **65,535** | file ids are 16 bits | ids cannot be expressed |
| Room for added and grown files | **328 MB** past the end of the disc | served past the disc's last sector, up to the CD's address limit (99:59:74) | sectors cannot be addressed |
| New directories | **not supported** | | an added file must go in a directory the archive already has; others are listed as ignored |
| File names | 1-24 printable characters, exact case | directory records hold the name; the game looks names up with a case-sensitive compare at boot | a wrongly named file is listed as ignored |
| Adding files at all | needs 8 MB RAM mode (psx-play's default) | the extended archive index lives above the PlayStation's 2 MB | added files are listed as ignored |
| Replacing files only (no added files) | the disc's GT2.VOL extent; files that grow borrow about 175 MB from unused PAL-language menu data | the original index format | the start stops with a message |
| Whole-file tables | one winner per file | `.crsinfo`, `usa_gtmode_data.dat`, `usa_gtmode_race.dat` are replaced as whole files | of two mods carrying the same file, the later one in the load order wins: keep all new cars in one mod, all event pointers in one mod, and append all new courses to one `.crsinfo` |

## Saves

| Limit | Why | What happens |
|---|---|---|
| A save with a new car or course needs its mod | the save stores car codes and absolute part positions, and course records by number | without the mod GT2 would crash on the missing car. psx-play writes `<card>.mods.json` beside the card when you save with mods on, and **refuses the card** at the next start if a mod that adds files is missing (`--card-mods ignore` turns that into a warning). A missing mod that only replaces files is a warning |
| Old saves and new courses | the game initialises the spare course records 125-127 only at a new game | an older save shows a 0:00.000 record for a new course until you set a time |
| Other emulators | they do not read the manifest | do not take a card with modded cars to another emulator; use a separate card for mods |
