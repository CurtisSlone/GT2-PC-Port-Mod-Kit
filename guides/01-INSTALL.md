# 1. Install

## The disc

Only one disc works: **Gran Turismo 2 (USA), Simulation Mode disc, version 1.0, serial SCUS-94488.** GT2 came on
two discs. You need the **Simulation** disc, not the Arcade disc. (The Arcade Mode inside the Simulation disc's title
menu works.)

Make an image of your own disc as `.cue` + `.bin`, a "raw" 2352-byte image (BIN/CUE). Single-track images
(one `.bin`) and multi-track images (one `.bin` per track) both work. The installer identifies the disc by the
SHA-256 of its data track:

```text
serial            SCUS-94488
data track SHA-256 0cc97dbd958f48d5f3a9bc69a68e528115a03d8dccce0f0424a811ded766550c   (289,327 sectors)
```

This is the hash of a correct dump of the US v1.0 disc. If your image gives a different hash, it is another
revision or region, a patched or modified image, or a bad read. Dump the disc again, preferably with a drive and
tool that read raw sectors.

## Unpack the release

| Windows | Linux |
|---|---|
| Unzip `gt2-pc-port-v0.4.0-debug-windows.zip` into a folder you can write to, for example `C:\Games\gt2-pc-port`. Avoid `Program Files`: the game writes its data, cards and screenshots beside itself. | Unpack with `tar xf gt2-pc-port-v0.4.0-debug-linux.tar.gz` into a folder you own, for example `~/Games`. `tar` keeps the programs executable (some archive managers do not; then run `chmod +x UGT2R-x86_64.AppImage gt2-tools install-gt2.sh`). |

The guides call this folder **the port folder**.

## Install from your disc

Windows: double-click **`install-gt2.bat`** and pick your `.cue` file, or drag the `.cue` onto `install-gt2.bat`.
From a command prompt:

```bat
install-gt2.bat "D:\path\to\Gran Turismo 2 (USA) (Simulation Mode) (v1.0).cue"
```

Linux: run **`./install-gt2.sh`** in a terminal in the port folder. A file picker opens (zenity or kdialog); without
one it asks for the path. Or give the path:

```text
./install-gt2.sh "/path/to/Gran Turismo 2 (USA) (Simulation Mode) (v1.0).cue"
```

The installer runs `UGT2R "<your.cue>" --install-only`, which:

1. identifies the disc (serial and data-track hash) and **refuses any other disc**;
2. extracts every file of the disc into `data/files`, the sectors the game reads raw into `data/sectors.raw`, and
   writes `data/manifest.json` with every file's SHA-256;
3. unpacks the game's archive `GT2.VOL` into `data/gt2vol` (about a minute for both steps): `raw` holds the stored
   members the game reads, `inflated` holds unpacked copies for you and the mod tools to look at (the game never
   reads them);
4. copies `cards/blank.mcd` to `cards/card1.mcr` if you have no card yet.

Then it **prepares the tracks and cars** for the remaster look (`UGT2R --warmup-all`). It prints
"Preparing your tracks and cars... N of M". This runs once, takes a while and writes several GB into
`data/scene-cache`. You can close the window (Linux: Ctrl+C) and play right away: whatever is not ready is
prepared when a race needs it, and running the installer again later finishes the job.

The disc image is not used again after the install. You can delete it, move it or keep it.

Linux without FUSE (some minimal systems and containers): the installer notices and runs the AppImage with
`APPIMAGE_EXTRACT_AND_RUN=1`, which unpacks it to a temporary folder at each start instead.

## Every start: the disc lock

Each time UGT2R starts it checks `data`:

* the manifest must describe the known disc: serial and data-track hash, compared with the table built into the
  program;
* the boot files (`SYSTEM.CNF`, `SCUS_944.88`, `GT2.OVL`) are hashed and compared with the known disc's;
* `GT2.VOL` and its unpack must be the known disc's: the recorded hashes are compared (the 478 MB file is not
  re-hashed at every start);
* every file must have its recorded size.

If anything does not match, the game does not start. It tells you to reinstall from your disc. Your mods are not
part of this check: they live in `mods` and never change `data`.

## Checking or repairing an install

```bat
install-gt2.bat "D:\path\to\Gran Turismo 2 (USA) (Simulation Mode) (v1.0).cue" verify
```

```text
./install-gt2.sh "/path/to/Gran Turismo 2 (USA) (Simulation Mode) (v1.0).cue" verify
```

This re-reads the disc, compares every file in `data` and repairs any difference. Running the installer again
without `verify` also works: files that are already correct are kept, missing or damaged ones are written again.

## Troubleshooting

| Message | Fix |
|---|---|
| *unknown disc* / *the serial is known but the data track's hash is not* | not the US v1.0 Simulation disc, or a modified or bad image: see "The disc" |
| *this data folder is not an install of Gran Turismo 2 (USA) v1.0* | `data` was changed or comes from elsewhere: run the installer with your disc |
| *no data folder* | run the installer first |
| *the card ... needs the mod ...* | the card was saved with a mod that adds cars or courses, and that mod is off: turn it back on, or use another card (guides/03-MODS.md) |
| black window or no picture | update your graphics driver, or try the software renderer: `UGT2R.exe --gpu soft` (guides/13-FLAGS-AND-SETTINGS.md) |
| controller not working | plug it in before starting; `--pad-debug` prints what the system reports (guide 13). Linux: your user must be able to read `/dev/input/event*` |
| Linux: the AppImage does not start by double-click | make it executable (`chmod +x UGT2R-x86_64.AppImage`); without FUSE use `./UGT2R-x86_64.AppImage --appimage-extract-and-run` |
| Linux: it stops at start in a shell with a memory limit | the GPU path reserves a large address range at start (about 4 GB, not memory in use); raise `ulimit -v` or use `--gpu soft` |
| no sound on Linux | the sound goes through ALSA; on PipeWire or PulseAudio systems the ALSA plugin for them must be installed (usually it is) |

UGT2R prints what it is doing in its console window (Windows) or terminal (Linux), including which mods are active.
If something goes wrong, the last lines there say why.
