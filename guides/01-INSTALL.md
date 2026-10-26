# 1. Install and play

## The disc

Only one disc works: **Gran Turismo 2 (USA), Simulation Mode disc, version 1.0, serial SCUS-94488.** GT2 came on
two discs. You need the **Simulation** disc, not the Arcade disc.

Make an image of your own disc as `.cue` + `.bin`, a "raw" 2352-byte image (BIN/CUE). Single-track images
(one `.bin`) and multi-track images (one `.bin` per track) both work. The installer identifies the disc by the
SHA-256 of its data track:

```text
serial            SCUS-94488
data track SHA-256 0cc97dbd958f48d5f3a9bc69a68e528115a03d8dccce0f0424a811ded766550c   (289,327 sectors)
```

This is the hash of a correct dump of the US v1.0 disc. If your image gives a different hash, it is another revision or region, a patched or modified image, or a bad read. Dump the
disc again, preferably with a drive and tool that read raw sectors.

## Install

`install-gt2.bat` (double-click it and pick the `.cue`, or drag the `.cue` onto it). It runs
`psx-play.exe "<your.cue>" --install-only`, which:

1. identifies the disc (serial + data-track hash) and **refuses any other disc**;
2. extracts every file of the disc into `data\files\`, the sectors the game reads raw into `data\sectors.raw`,
   and writes `data\manifest.json` with every file's SHA-256;
3. unpacks the game's archive `GT2.VOL` into `data\gt2vol\` (about a minute for both steps): `raw\` holds the stored members the
   game reads, `inflated\` holds unpacked copies for you and the mod tools to look at (the game never reads them);
4. copies `cards\blank.mcd` to `cards\card1.mcr` if you have no card yet.

The disc image is not used again after this. You can delete it, move it or keep it.

## Every start: the disc lock

Each time `psx-play.exe` starts it checks `data\`:

* the manifest must describe the known disc: serial and data-track hash, compared with the table built into the
  program;
* the boot files (`SYSTEM.CNF`, `SCUS_944.88`, `GT2.OVL`) are hashed and compared with the known disc's;
* `GT2.VOL` and its unpack must be the known disc's: the recorded hashes are compared, and the 478 MB file is not
  re-hashed at every start;
* every file must have its recorded size.

If anything does not match, the game does not start. It tells you to reinstall from your disc. Your mods are not
part of this check: they live in `mods\` and never change `data\`.

## Checking or repairing an install

```text
install-gt2.bat "D:\path\to\Gran Turismo 2 (USA) (Simulation Mode) (v1.0).cue" verify
```

This re-reads the disc and compares every file in `data\`, then repairs any difference. Running `install-gt2.bat`
again also works: files that are already correct are kept, and missing or damaged ones are written again.

## Play

`play-gt2.bat`. It runs `psx-play.exe --hle --data data --modules modules --card1 cards\card1.mcr --shots shots`.
Add options after the file name, for example `play-gt2.bat --widescreen off`.

Useful options:

| Option | Default | What it does |
|---|---|---|
| `--widescreen off` | 16:9 | 4:3 picture (F3 cycles while playing) |
| `--draw-distance 1.5` / `off` | 2x | how far the game draws scenery |
| `--gpu soft` | GPU | the software renderer, the console's exact picture (F8 switches) |
| `--gpu-subpixel off` / `--gpu-perspective off` | on | the console's wobbly vertices / affine textures (F5 / F4) |
| `--pace console` | your display | run at the console's exact refresh instead of your monitor's |
| `--mods none` | mods on | play without any mods |
| `--card1 cards\other.mcr` | card1.mcr | another memory card (created formatted if missing) |
| `--no-audio` | sound on | no sound |

`psx-play.exe --help` lists everything.

## Troubleshooting

| Message | Fix |
|---|---|
| *unknown disc* / *the serial is known but the data track's hash is not* | not the US v1.0 Simulation disc, or a modified/bad image: see "The disc" |
| *this data folder is not an install of Gran Turismo 2 (USA) v1.0* | `data\` was changed or comes from elsewhere: run install-gt2.bat with your disc |
| *no data folder* | run install-gt2.bat first |
| *the card ... needs the mod ...* | the card was saved with a mod that adds cars or courses, and that mod is off: turn it back on, or use another card (guides\02-MODS.md) |
| black window / no picture | update your graphics driver, or try `play-gt2.bat --gpu soft` |
| controller not working | plug it in before starting; `play-gt2.bat --pad-debug` prints what the system reports |

A console window opens next to the game. It prints what the game is doing, including which mods are active. If
something goes wrong, the last lines there say why.
