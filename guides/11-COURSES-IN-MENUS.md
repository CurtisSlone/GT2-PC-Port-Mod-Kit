# 11. A new course with its own menu entry

`--course zz_mytrack` puts **every** race on your course, which is the quickest way to try a track (guide 07). To
make a course part of the game instead (a GT Mode race that runs on it, with its name on the race pages, its replay
and its records), use `gt2-tools course add-course`.

Like everything added to the game's archive, this works **only in this port**.

## How a course gets a number

The game finds course files by name and numbers them in name order. A new course whose name sorts after the game's
last course (`testline`) becomes course **125**, then 126 and 127. The memory card keeps records for 128 courses,
so **three added courses** fit. Start every new name with `zz_`: then no existing course changes number and old
saves stay valid.

## A. Point an event at a course you built

A track from guide 07 already has its own course files and course-table record (the `MyTrack` mod from the add-on,
or `SampleTrack` from the command line). It only needs an event pointed at it:

```bat
gt2-tools.exe course add-course --out mods\MyEvents --name zz_sample --event GJL0002 --event-only
echo MyEvents>> mods\load-order.txt
```

```sh
./gt2-tools course add-course --out mods/MyEvents --name zz_sample --event GJL0002 --event-only
echo MyEvents >> mods/load-order.txt
```

This writes `mods/MyEvents/carparam/usa_gtmode_race.dat`: the game's event table with event `GJL0002` now racing on
`zz_sample` (use `zz_mytrack` for the add-on's track). Keep the track's own mod on too; the order between the two
does not matter. Then start UGT2R without `--course`.

`GJL0002` is the second race of **GT League > Japan Nationals**, an A-license race for cars up to about 295 hp. Its
SINGLE RACE page then shows your course's name, and the race, its replay and its records use your course. Two
things stay as they were: the event list page still prints the old course's name (that text is not in the event
record), and an existing save shows a 0:00.000 record for the new course until you set a time.

To point more events or more courses, run the command again on the **same** `mods/MyEvents` folder; each run starts
from the file already there. Every mod that changes `usa_gtmode_race.dat` replaces the whole file, so keep all event
pointers in one mod.

## B. A copy of an existing course under a new number

```bat
gt2-tools.exe course add-course --out mods\MyCourse --name zz_course1 --display "My Course" --src rev_roma_night --event GJL0002
```

```sh
./gt2-tools course add-course --out mods/MyCourse --name zz_course1 --display "My Course" --src rev_roma_night --event GJL0002
```

| Option | What it does |
|---|---|
| `--name zz_course1` | the new course's file name (must sort after `testline`: start with `zz_`) |
| `--display "..."` | the name on the race pages |
| `--src rev_roma_night` | the course whose files and settings (sky, night, dirt) it starts from; `gt2-tools course list` lists them all |
| `--tro F --trp F --map F` | your own course files and minimap instead of `--src`'s, for example from `course import` (guide 05) or a course edit (guide 08); plain or `.gz` |
| `--event GJL0002` | the GT Mode event that races on it (leave it out and use `--course zz_course1`) |
| `--event-only` | change only the event table (part A) |

A course you edited in guide 08, as a new course next to the original:

```bat
gt2-tools.exe course add-course --out mods\MyCourse --name zz_course2 --display "Laguna Edit" --src laguna --tro work\laguna-edit-built\laguna.tro --trp work\laguna-edit-built\laguna.trp
```

```sh
./gt2-tools course add-course --out mods/MyCourse --name zz_course2 --display "Laguna Edit" --src laguna --tro work/laguna-edit-built/laguna.tro --trp work/laguna-edit-built/laguna.trp
```

## Several added courses

The course table `.crsinfo` is replaced as a whole file by each course mod. To have more than one added course at
the same time, build them into **one** mod folder, running the tools on the same `--out` folder with names in sort
order (`zz_course1`, then `zz_course2`). They become courses 125, 126 and 127 in that order.

## Saves

A save made while an added course is in the game needs that course's mod (guides/03-MODS.md, "Saves and mods"). Use
a separate memory card.

## Sharing

`.crsinfo` and `usa_gtmode_race.dat` are the game's own tables with your changes. Do not share them; share the
command line instead. The course files of a new track from guide 07 are your own work (guides/03-MODS.md).
