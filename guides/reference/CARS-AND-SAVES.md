# Cars and saves: the rules behind adding a car

Why a new car's code must sort last, which tables a car lives in, and what the memory card stores. For the steps
(`gt2-course.exe add-car`, pez2k's tools) see [05-CARS.md](../05-CARS.md); for the numbers, [LIMITS.md](LIMITS.md).
Functions are addresses in the public byte-matched decompilation ([GT2-Decomp](https://github.com/CurtisSlone/GT2-Decomp)). US Simulation disc (SCUS-94488).

## The short version

* **One new car with its own code needs no game-code change.** Every table it touches has room for about 10 more
  cars, the save stores car codes as full 32-bit words, and every lookup is a binary search over data the game
  sorts itself or loads from the disc.
* **The code must sort after `x2wsr`**, the highest code on the disc: start it with `y` or `z`, e.g. `zz01n`. Then
  the car's records go at the end of every table and no saved position moves.
* **A save that holds a new car must not be loaded without its mod.** The port keeps a manifest next to the card to
  stop that.

## The car code

A car is a **5-character code** such as `t2mgn`, from the characters `-0123456789abcdefghijklmnopqrstuvwxyz` (6 bits
each), packed into a 32-bit number: resident `func_80060834` computes `c0<<24 | c1<<18 | c2<<12 | c3<<6 | c4` and
`func_800607F8` turns it back into text (pez2k's `CarNameConversion` is the same encoding). The last character is
the variant (`n` stock, `r` race-modified and others).

Because the character set is in ASCII order, the numeric order of codes is the alphabetical order of the file
names, which is the archive directory's order. That is why the tables the game builds at boot come out sorted.
There are 1,110 codes on the disc; 618 of them are GT-mode cars with a Car record.

## Why the code must sort last

The car database `carparam\usa_gtmode_data.dat` holds a Car record per car (72 bytes: the code, 26 part numbers,
wheel, maker, two name-string numbers, year, price) and **part blocks** (brakes, engine, gears, LSD, tyres and the
rest) with one record per car per upgrade stage, each starting with the car code. **All 24 car-keyed blocks are
sorted by code**, because the game finds records by binary search:

* `func_80077E64(block, code)` finds a Car record; a missing car gets the **first car's** record.
* Part upgrades (`func_80076480` -> `func_80076658` -> `func_80076728`) binary-search the part block for the code,
  step back to the car's first record, then scan forward for the stage; a car with none gets the generic car
  `00000`'s parts.
* A car's set-up copies the Car record's **part numbers as they are**: absolute positions in the part blocks.

Those absolute part numbers are what the memory card stores for every garage car (and what the race database's
opponent records hold). Inserting a car's records anywhere but the end of a block moves every later record up by
one, so **every car already saved would point at another car's parts**. The blocks must stay sorted, so the only
way to add records without moving anything is a code that sorts after every existing one. GT2DataSplitter rebuilds
the blocks in code order, so a car named `zz01n` stays last with that tool too; a car named `b0000` would silently
break existing saves.

The same holds for the other sorted tables a car is in: the boot car table built from the `/carobj` file names
(`boot/func_80011710`, looked up by `func_8005D8C0`), the names and colours table `.carinfoa` (`func_80060934`, a
missing car gets entry 0), and the dealer picture index `solodata.dat` (`func_80020F40`, missing = 0).

## What a new car is made of

| Where | What | Notes |
|---|---|---|
| `carobj\<code>.cdo`, `.cno`, `.cdp`, `.cnp` | day/night model, day/night paint | added files; model at most 20,480 bytes, paint exactly 45,984 bytes |
| `carlogo\<code>l--.tim`, `<code>m--.tim` | logos | optional; a car without one shows the first logo |
| `carparam\usa_gtmode_data.dat` | the Car record and one record per part block and stage, appended | at most 819,200 bytes inflated |
| `carparam\usa_unistrdb.dat` | the two name lines in the menus | ~3,058 bytes free |
| `.carinfoa` (+ `.carinfoe`, `.carinfoj`), `.carcolor` | full name, colour list, region flags, colour names | ~3,040 bytes free in `.carinfoa`; at most 16 colours |
| `gtmenu\usa\solodata.dat`, dealer pages | the dealer picture lookup and a dealer button | a button keeps its picture; new tiles are not tooled yet |

Engine sound, wheels and maker are references to existing ones: the wheel table (192) and the maker list (39) are
full, so a new car reuses the donor's. `gt2-course.exe add-car` writes all of this from a donor car.

**Keep all new cars in one mod.** `usa_gtmode_data.dat` and the other tables are whole files: two car mods would
each carry their own copy and the later one would win. Run `add-car` again on the same folder with a later code
(`zz02n` after `zz01n`).

## What the memory card stores

The game file `BASCUS-94455GAME` is 4 blocks: a 0x200 header, the save area `D_801C9340[0 .. 0x7C9C]`, and a CRC
(resident `func_8006A124`).

**Garage** (save +0x3C74): a car count, then **100 records of 164 bytes**, then the money (capped at 99,999,999) and
the current car. The buy path refuses a 101st car. Each garage record holds:

| Offset | Field |
|---|---|
| +0x00 | car code (u32) |
| +0x04 | colour (an index into the car's `.carinfoa` colour list) |
| +0x08 | the 0x84-byte set-up: **16-bit part numbers into `usa_gtmode_data.dat` (absolute)**, maker, flags |
| +0x8C | car code again (the model shown) |
| +0x90 | value (price paid plus parts) |
| +0x94..+0xA1 | tyre/stage state and owned-parts bits |

**Course records** (save +0x218): one 36-byte record per course number, 128 slots, then the licence results. New
courses use slots 125-127; older saves hold zeros there (the game initialises them only at a new game), so a new
course shows a 0:00.000 record until a time is set.

**Replays** (`BASCUS-94455REPLAY`) store the race set-up, car codes and course included.

**What the card does not store:** a car's model, paint or specs. A garage car's horsepower figure follows the data
in use, so removing a stats mod returns the car to stock. But a mod that changes a car's colour list, parts or
prices can leave saved cars pointing at things that are no longer there, and money or cars won with a modded car
stay in the save after the mod is gone.

**Nothing overflows with a new car** as long as its records were appended: the code is 32 bits, the part numbers
stay below 65,536, the colour index below 16. The 100-car garage and the 4-block file are the only fixed sizes.

## Saves without their mod, and the manifest

Loaded without the mod that added its car, a save breaks: the garage view and the race look the car up
(`func_8005D8C0`), get nothing and **crash**; the Car lookup falls back to the first car; and the set-up's part
numbers point past the end of the blocks.

So the port keeps a **manifest** next to the card, while the card itself stays a standard card:

* When the card's contents change in a session with mods on (you save), psx-play writes `<card>.mods.json` beside
  it (e.g. `cards\card1.mcr.mods.json`): the active mods, whether each adds files, their file count and a hash.
* At the next start with that card, if a mod that **adds** files (new cars or courses) is missing, psx-play
  **refuses the card** and names the mod. Put the mod back, use another card (`--card1 cards\other.mcr`), or start
  with `--card-mods ignore` (a warning only; the game may crash on that save).
* A missing mod that only **replaces** files (a repaint, changed stats) is a warning: the save loads with the
  disc's files. A mod whose files changed since the save is a warning too.
* No mods, no manifest: nothing is written or checked. Saving later without mods leaves an existing manifest in
  place; delete it yourself once the card no longer needs the mod.
* Other emulators do not read the manifest: do not take a card with modded cars to one.

Play mods on a separate card (`psx-play.exe --card1 cards\modded.mcr`), keep card backups on (the default), and do
not share a card saved with mods as a stock save.

## Tested

A new car `zz01n` (donor `t2mgn`) was bought at the dealer, saved, reloaded after a restart and raced; the game's
car table showed 1,111 cars with `zz01n` last, and every existing record kept its position (checked block by block).
A copy of a real save loaded with the mod and every garage car kept its parts. With the mod
removed, the port refused the card as described above.
