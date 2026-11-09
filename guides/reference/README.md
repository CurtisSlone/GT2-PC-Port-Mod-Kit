# Reference

Background for modders: the formats and the game's rules behind the guides. Function names (`func_XXXXXXXX`) are
addresses in the public byte-matched GT2 decompilation ([GT2-Decomp](https://github.com/CurtisSlone/GT2-Decomp)), so every claim can be checked.

* [COURSE-FORMAT.md](COURSE-FORMAT.md): the `.tro` / `.trp` / `.crsinfo` course files field by field, and the JSON export of `gt2-tools course export`.
* [TRACK-SPEC.md](TRACK-SPEC.md): every field of the track spec that `gt2-tools track new` builds, scenery pieces, open courses, and the compiler's checks and messages.
* [COURSE-EDIT.md](COURSE-EDIT.md): the edit export's attributes, what `gt2-tools edit` recomputes and keeps, and the `.gt2patch` format.
* [LIMITS.md](LIMITS.md): one page of every hard limit for courses, cars, the archive and saves, with the reason and what happens past it.
* [CARS-AND-SAVES.md](CARS-AND-SAVES.md): why a new car's code must sort last, what a car is made of, and what the memory card stores.
