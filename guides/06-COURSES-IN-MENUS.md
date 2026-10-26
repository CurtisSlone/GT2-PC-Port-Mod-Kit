# 6. A new course with its own menu entry

`play-gt2.bat --course zz_mytrack` puts **every** race on your course, which is the quickest way to try a track.
To make a course part of the game instead (a GT-mode race that runs on it, with its name on the race pages, its
replay and its records), use `gt2-course.exe add-course`.

Like everything added to the game's archive, this works **only in this port**.

## How a course gets a number

The game finds course files by name and numbers them in name order. A new course whose name sorts after the
game's last course (`testline`) becomes course **125**, then 126 and 127. The memory card keeps records for 128
courses, so **three added courses** fit. Start every new name with `zz_`: then no existing course changes number
and old saves stay valid.

## A. Point an event at a course you built (gt2-trackc / the Blender add-on)

A track from guide 04 already has its own course files and course-table record (the `MyTrack` mod). It only needs
an event pointed at it:

```text
gt2-course.exe add-course --vol data\gt2vol --out mods\MyEvents --name zz_mytrack --event GJL0002 --event-only
```

This writes `mods\MyEvents\carparam\usa_gtmode_race.dat`: the game's event table with event `GJL0002` now racing
on `zz_mytrack`. Add `MyEvents` to `mods\load-order.txt` next to `MyTrack`; the order between the two does not
matter. Then start `play-gt2.bat` (no `--course`).

`GJL0002` is the second race of **GT League > Japan Nationals**, an A-licence race for cars up to about 295 hp. Its
SINGLE RACE page then shows your course's name, and the race, its replay and its records use your course. Two
things stay as they were: the event list page still prints the old course's name (that text is not in the event
record), and an existing save shows a 0:00.000 record for the new course until you set a time.

To point more events or more courses, run the command again on the **same** `mods\MyEvents` folder; each run
starts from the file already there. Every mod that changes `usa_gtmode_race.dat` replaces the whole file, so keep
all event pointers in one mod.

## B. A copy of an existing course under a new number

```text
gt2-course.exe add-course --vol data\gt2vol --out mods\MyCourse --name zz_course1 --display "My Course" ^
    --src rev_roma_night --event GJL0002
```

| Option | What it does |
|---|---|
| `--name zz_course1` | the new course's file name (must sort after `testline`: start with `zz_`) |
| `--display "..."` | the name on the race pages |
| `--src rev_roma_night` | the course whose files and settings (sky, night, dirt) it starts from; `gt2-course.exe list --data data\gt2vol` lists them all |
| `--tro F --trp F --map F` | your own course files and minimap instead of `--src`'s, e.g. from `gt2-course import` (guide 03); plain or `.gz` |
| `--event GJL0002` | the GT-mode event that races on it (leave out and use `play-gt2.bat --course zz_course1`) |
| `--event-only` | change only the event table (part A) |

## Several added courses

The course table `.crsinfo` is replaced as a whole file by each course mod. To have more than one added course
at the same time, build them into **one** mod folder, running the tools on the same `--out` folder with names in
sort order (`zz_a...`, then `zz_b...`). They become courses 125, 126 and 127 in that order.

## Saves

A save made while an added course is in the game needs that course's mod (guides\02-MODS.md, "Saves and mods").
Use a separate memory card.

## Sharing

`.crsinfo` and `usa_gtmode_race.dat` are the game's own tables with your changes. Do not share them; share the
command line instead. The course files from `gt2-trackc` are your own work (guides\02-MODS.md).
