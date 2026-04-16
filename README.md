# CraftToExile2

This repository includes a one-click installer that copies the modpack folder into your Minecraft versions directory.

## What The Installer Does

Running `OneClickDownloadModpack.bat` copies:

- Source: `CraftToExile2` (folder in this repository)
- Destination: `%APPDATA%\.minecraft\versions\CraftToExile2`

If a previous install exists at the destination, it is removed first and then replaced with a fresh copy.

## Quick Install (Windows)

1. Download the GitHub Release asset for CraftToExile2. Do not use the source ZIP or a raw clone unless the mod JARs have already been hydrated.
2. Keep this structure intact:
	- `OneClickDownloadModpack.bat`
	- `CraftToExile2` (folder)
3. Close Minecraft and SKLauncher.
4. Right-click `OneClickDownloadModpack.bat` and choose **Run as administrator** (recommended).
5. Wait for `[SUCCESS] Installation complete.`
6. Open SKLauncher and select the version/profile named `CraftToExile2`.

## Reinstall / Update

Run the same `OneClickDownloadModpack.bat` again any time you want to reinstall or update files from this repo.

## Create A Release Asset

1. Open PowerShell in the repository root and run:

	```powershell
	.\CreateReleasePackage.bat
	```

	Or double-click `CreateReleasePackage.bat` in File Explorer.
2. Wait for the script to finish and confirm it created `release\CraftToExile2-Release.zip`.
3. Open the GitHub repository in your browser.
4. Click `Releases`. If you do not see it, click the `Code` tab first and then find `Releases` in the right-side panel or repository header.
5. Click `Draft a new release`.
6. Choose or create the tag you want to ship, then give the release a title.
7. Drag `release\CraftToExile2-Release.zip` into the `Attach binaries by dropping them here or selecting them.` box.
8. Click `Publish release`.
9. Use that Release page as the only download link you share with players.
10. Do not click `Publish your first package`; that is for GitHub Packages, not Releases.

## Shipping Checklist

Use this exact flow when you want the pack to feel like a simple download-and-run install:

1. Put the hydrated modpack files in `CraftToExile2`.
2. Run `CreateReleasePackage.bat`.
3. In GitHub, click `Releases` then `Draft a new release`.
4. Attach `release\CraftToExile2-Release.zip`.
5. Click `Publish release`.
6. Tell players to download the release ZIP, unzip it, and run `OneClickDownloadModpack.bat`.

If you skip the release step and point people at the source ZIP or raw repo, Git LFS pointers can leak through and the install will fail.

## What To Tell Players

Use this wording verbatim if you want the install instructions to stay simple:

1. Download the CraftToExile2 GitHub Release ZIP.
2. Unzip it anywhere on Windows.
3. Open the extracted folder and run `OneClickDownloadModpack.bat`.
4. Wait for the success message, then launch SKLauncher and pick `CraftToExile2`.

## Troubleshooting

- `APPDATA is not available`: run from a normal Windows user session.
- `Source modpack folder not found`: ensure the BAT file is in the repo root and the `CraftToExile2` folder is next to it.
- `Release packaging stopped because Git LFS pointer files were found`: hydrate the files first, then rebuild the release archive.
- If mods are tiny files (for example ~1 KB) or you get `zip END header not found`: you are probably looking at a source checkout with Git LFS pointer files. Use the GitHub Release asset that contains the actual mod JARs.
- `Could not remove existing target folder`: close Minecraft/SKLauncher and try again.
- `Copy failed with robocopy exit code ...`: retry with admin permissions and verify file access.
- If TLauncher downloads `preview_OptiFine...jar` or `tl_skin_cape...jar`, disable those add-ons or use the pack without TLauncher injected extras. They can break Forge startup for this modpack.
