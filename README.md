# CraftToExile2

This repository includes a one-click installer that copies the modpack folder into your Minecraft versions directory.

## What The Installer Does

Running `OneClickDownloadModpack.bat` copies:

- Source: `CraftToExile2` (folder in this repository)
- Destination: `%APPDATA%\.minecraft\versions\CraftToExile2`

If a previous install exists at the destination, it is removed first and then replaced with a fresh copy.

## Quick Install (Windows)

1. Download or clone this repository.
2. Keep this structure intact:
	- `OneClickDownloadModpack.bat`
	- `CraftToExile2` (folder)
3. Close Minecraft and SKLauncher.
4. Right-click `OneClickDownloadModpack.bat` and choose **Run as administrator** (recommended).
5. Wait for `[SUCCESS] Installation complete.`
6. Open SKLauncher and select the version/profile named `CraftToExile2`.

## Reinstall / Update

Run the same `OneClickDownloadModpack.bat` again any time you want to reinstall or update files from this repo.

## Troubleshooting

- `APPDATA is not available`: run from a normal Windows user session.
- `Source modpack folder not found`: ensure the BAT file is in the repo root and the `CraftToExile2` folder is next to it.
- `Could not remove existing target folder`: close Minecraft/SKLauncher and try again.
- `Copy failed with robocopy exit code ...`: retry with admin permissions and verify file access.
