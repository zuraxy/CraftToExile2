param(
	[string]$OutputName = 'CraftToExile2-Release'
)

$ErrorActionPreference = 'Stop'

function Write-Section {
	param([string]$Text)
	Write-Host ''
	Write-Host $Text
	Write-Host ('=' * $Text.Length)
}

function Assert-PathExists {
	param(
		[string]$Path,
		[string]$Message
	)

	if (-not (Test-Path -LiteralPath $Path)) {
		throw $Message
	}
}

function Get-LfsPointerFiles {
	param([string]$Root)

	$suspiciousFiles = Get-ChildItem -LiteralPath $Root -Recurse -File |
		Where-Object { $_.Extension -in @('.jar', '.zip', '.fma') -and $_.Length -lt 2048 }

	$pointerFiles = New-Object System.Collections.Generic.List[string]

	foreach ($file in $suspiciousFiles) {
		$firstLine = Get-Content -LiteralPath $file.FullName -TotalCount 1 -ErrorAction SilentlyContinue
		if ($firstLine -eq 'version https://git-lfs.github.com/spec/v1') {
			$pointerFiles.Add($file.FullName)
		}
	}

	return $pointerFiles
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceRoot = Join-Path $scriptRoot 'CraftToExile2'
$stagingRoot = Join-Path $scriptRoot '_release_staging'
$releaseRoot = Join-Path $scriptRoot 'release'
$outputZip = Join-Path $releaseRoot ($OutputName + '.zip')

Write-Section 'CraftToExile2 Release Packager'

Assert-PathExists -Path $sourceRoot -Message "Source folder not found: $sourceRoot"

if (Test-Path -LiteralPath $stagingRoot) {
	Remove-Item -LiteralPath $stagingRoot -Recurse -Force
}

if (Test-Path -LiteralPath $outputZip) {
	Remove-Item -LiteralPath $outputZip -Force
}

New-Item -ItemType Directory -Path $stagingRoot | Out-Null
New-Item -ItemType Directory -Path $releaseRoot | Out-Null

Write-Host 'Copying installer and modpack files into a release staging folder...'
Copy-Item -LiteralPath (Join-Path $scriptRoot 'OneClickDownloadModpack.bat') -Destination $stagingRoot
Copy-Item -LiteralPath (Join-Path $scriptRoot 'README.md') -Destination $stagingRoot
Copy-Item -LiteralPath $sourceRoot -Destination (Join-Path $stagingRoot 'CraftToExile2') -Recurse

$cleanupPaths = @(
	'CraftToExile2\cache',
	'CraftToExile2\cachedImages',
	'CraftToExile2\crash-reports',
	'CraftToExile2\logs',
	'CraftToExile2\local',
	'CraftToExile2\saves',
	'CraftToExile2\simplebackups'
)

foreach ($relativePath in $cleanupPaths) {
	$fullPath = Join-Path $stagingRoot $relativePath
	if (Test-Path -LiteralPath $fullPath) {
		Remove-Item -LiteralPath $fullPath -Recurse -Force
	}
}

$cleanupFiles = @(
	'CraftToExile2\usercache.json',
	'CraftToExile2\usernamecache.json'
)

foreach ($relativeFile in $cleanupFiles) {
	$fullPath = Join-Path $stagingRoot $relativeFile
	if (Test-Path -LiteralPath $fullPath) {
		Remove-Item -LiteralPath $fullPath -Force
	}
}

$pointerFiles = Get-LfsPointerFiles -Root (Join-Path $stagingRoot 'CraftToExile2')
if ($pointerFiles.Count -gt 0) {
	Write-Host ''
	Write-Host '[ERROR] Release packaging stopped because Git LFS pointer files were found:'
	$pointerFiles | ForEach-Object { Write-Host ("        " + $_) }
	Write-Host ''
	Write-Host '[ERROR] Rebuild the release from a hydrated checkout or replace the pointer files with real assets.'
	throw 'Release packaging failed.'
}

Write-Host "Creating release archive: $outputZip"
Compress-Archive -Path (Join-Path $stagingRoot '*') -DestinationPath $outputZip -Force

Remove-Item -LiteralPath $stagingRoot -Recurse -Force

Write-Host ''
Write-Host '[SUCCESS] Release archive created successfully.'
Write-Host "[SUCCESS] Output: $outputZip"
