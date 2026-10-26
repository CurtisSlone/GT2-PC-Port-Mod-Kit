# GT2 PC Port mod kit setup (run by setup-kit.bat). Every outside tool is listed in THIRD-PARTY.md.
param([string]$Blender = "")
$ErrorActionPreference = "Stop"
$Kit = $PSScriptRoot
$Root = Split-Path $Kit -Parent
$Tools = Join-Path $Kit "tools"
$Problems = @()

# --- 1. pez2k's GT2 tools: the author's release archives, pinned and checked (THIRD-PARTY.md section 1) ---------
$Pinned = @(
    @{ Name = "GT2ModelTool";        Url = "https://github.com/pez2k/gt2tools/releases/download/GT2ModelTool210/GT2ModelTool_v210.7z";               Sha = "f7eaee7173264bc7b0bc1515c0327e010213bf23149fe1c0152d12254ec592ec" },
    @{ Name = "GT2TextureEditor";    Url = "https://github.com/pez2k/gt2tools/releases/download/GT2TextureEditor04/GT2TextureEditor_v04.7z";         Sha = "9db55360082255787e3bb283b3e6d8f828edc540504f979a386c31f22eacba0c" },
    @{ Name = "GT2DataSplitter";     Url = "https://github.com/pez2k/gt2tools/releases/download/GT2DataSplitter08/GT2DataSplitter_v08.7z";           Sha = "fa8156a848479528cf720b0e10a8940f5418acc9907fc3ab6934f333580c489c" },
    @{ Name = "GT2CarInfoEditorCSV"; Url = "https://github.com/pez2k/gt2tools/releases/download/GT2CarInfoEditorCSV01/GT2CarInfoEditorCSV_v01.7z"; Sha = "044a8fd4baabab873c0b974dbb7774d681c2816564950a3379ac83deb97044fb" }
)
Write-Host "== pez2k's GT2 tools (https://github.com/pez2k/gt2tools, by pez2k; not part of this release)"
New-Item -ItemType Directory -Force -Path (Join-Path $Tools "downloads") | Out-Null
foreach ($t in $Pinned) {
    $dir = Join-Path $Tools $t.Name
    $exe = Join-Path $dir ($t.Name + ".exe")
    $archive = Join-Path (Join-Path $Tools "downloads") (Split-Path $t.Url -Leaf)
    if ((Test-Path $exe) -and (Test-Path $archive) -and ((Get-FileHash $archive -Algorithm SHA256).Hash.ToLower() -eq $t.Sha)) {
        Write-Host ("   {0}: already set up" -f $t.Name); continue
    }
    Write-Host ("   {0}: downloading {1}" -f $t.Name, $t.Url)
    & curl.exe -fsSL -o $archive $t.Url
    if ($LASTEXITCODE -ne 0) { $Problems += "$($t.Name): download failed (no internet, or GitHub unreachable). Download it yourself from the link in THIRD-PARTY.md into kit\tools\downloads and run setup again."; continue }
    $sha = (Get-FileHash $archive -Algorithm SHA256).Hash.ToLower()
    if ($sha -ne $t.Sha) {
        Remove-Item $archive -Force
        $Problems += "$($t.Name): the download's SHA-256 is $sha, expected $($t.Sha). It was deleted and NOT used. (The release may have been replaced; check THIRD-PARTY.md for a newer kit.)"
        continue
    }
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    & tar.exe -xf $archive -C $dir
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $exe)) { $Problems += "$($t.Name): could not unpack $archive (Windows' tar needs Windows 10 1803 or newer; or unpack it with 7-Zip into kit\tools\$($t.Name))."; continue }
    Write-Host ("   {0}: ok (SHA-256 checked) -> kit\tools\{0}" -f $t.Name)
}
# GT2DataSplitter 0.8 targets .NET 6 (out of support): run it on .NET 8 without changing the tool.
Set-Content -Encoding ASCII -Path (Join-Path $Tools "GT2DataSplitter.bat") -Value @(
    "@echo off",
    "rem Runs pez2k's GT2DataSplitter 0.8 (built for .NET 6) on the .NET 8 Runtime. The tool itself is unchanged.",
    "set DOTNET_ROLL_FORWARD=Major",
    "`"%~dp0GT2DataSplitter\GT2DataSplitter.exe`" %*"
)

# --- 2. .NET 8 Runtime (GT2ModelTool, GT2DataSplitter) ----------------------------------------------------------
Write-Host "== .NET 8 Runtime (for GT2ModelTool and GT2DataSplitter)"
$net8 = $false
try { $net8 = [bool]((& dotnet --list-runtimes 2>$null) -match "^Microsoft\.NETCore\.App (8|9|1\d)\.") } catch { }
if ($net8) { Write-Host "   found" } else {
    $Problems += ".NET 8 Runtime not found: GT2ModelTool and GT2DataSplitter will not start. Install 'Run console apps' from https://dotnet.microsoft.com/download/dotnet/8.0 (free, Microsoft)."
}

# --- 3. Blender 4.2+ and the GT2 Track Tools add-on -------------------------------------------------------------
Write-Host "== Blender (required for the track tools; 4.2 LTS or newer)"
$candidates = @()
if ($Blender) { $candidates += $Blender }
$candidates += Get-ChildItem -ErrorAction SilentlyContinue -Path "$env:ProgramFiles\Blender Foundation\*\blender.exe" | Sort-Object FullName -Descending | ForEach-Object FullName
$candidates += "${env:ProgramFiles(x86)}\Steam\steamapps\common\Blender\blender.exe"
$candidates += Get-ChildItem -ErrorAction SilentlyContinue -Path "$env:ProgramFiles\WindowsApps\BlenderFoundation.Blender*\Blender\blender.exe" | ForEach-Object FullName
$onPath = Get-Command blender.exe -ErrorAction SilentlyContinue
if ($onPath) { $candidates += $onPath.Source }
$found = $null
foreach ($c in $candidates) {
    if (-not $c -or -not (Test-Path $c)) { continue }
    $line = (& $c --version 2>$null | Select-Object -First 1)
    if ($line -match "Blender (\d+)\.(\d+)") {
        $maj = [int]$Matches[1]; $min = [int]$Matches[2]
        if ($maj -gt 4 -or ($maj -eq 4 -and $min -ge 2)) { $found = $c; Write-Host "   $line at $c"; break }
        Write-Host "   $line at $c is older than 4.2: skipped"
    }
}
$addon = Get-ChildItem -Path $Kit -Filter "gt2_track_tools-*.zip" | Sort-Object Name -Descending | Select-Object -First 1
if (-not $found) {
    $Problems += "Blender 4.2 or newer not found. Install it from https://www.blender.org/download/ (free), then run setup-kit.bat again, or run: setup-kit.bat `"D:\path\to\blender.exe`""
} elseif (-not $addon) {
    $Problems += "The add-on zip kit\gt2_track_tools-*.zip is missing from this folder (re-download the release)."
} else {
    Write-Host ("   installing the add-on {0}" -f $addon.Name)
    & $found --command extension install-file --repo user_default --enable $addon.FullName
    if ($LASTEXITCODE -ne 0) {
        $Problems += "Installing the add-on into Blender failed. Install it by hand: Blender > Edit > Preferences > Get Extensions > (arrow menu) Install from Disk > kit\$($addon.Name)."
    } else {
        Write-Host "   add-on installed and enabled. In Blender: press N in the 3D view, tab GT2, and set the port folder to:"
        Write-Host "   $Root"
    }
}

Write-Host ""
if ($Problems.Count -eq 0) {
    Write-Host "Mod kit ready. Next: guides\03-EXPORT.md and guides\04-BUILD-A-TRACK.md"
} else {
    Write-Host "Setup finished with $($Problems.Count) thing(s) to fix:"
    foreach ($p in $Problems) { Write-Host " - $p" }
}
