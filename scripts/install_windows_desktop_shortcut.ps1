param(
  [string]$BuildDir = "build\windows\x64\runner\Release",
  [string]$InstallDir = "$env:LOCALAPPDATA\ModelCost Monitor\Windows",
  [string]$ShortcutName = "ModelCost Monitor.lnk"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")
$source = Resolve-Path -LiteralPath (Join-Path $repoRoot $BuildDir)
$exe = Join-Path $source "modelcost_monitor.exe"
if (-not (Test-Path -LiteralPath $exe)) {
  throw "Windows build not found: $exe. Run 'flutter build windows' first."
}

$installRoot = Join-Path $env:LOCALAPPDATA "ModelCost Monitor"
$resolvedInstallRoot = [System.IO.Path]::GetFullPath($installRoot)
$resolvedInstallDir = [System.IO.Path]::GetFullPath($InstallDir)
if (-not $resolvedInstallDir.StartsWith($resolvedInstallRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Refusing to install outside $resolvedInstallRoot"
}

if (Test-Path -LiteralPath $resolvedInstallDir) {
  Remove-Item -LiteralPath $resolvedInstallDir -Recurse -Force
}
New-Item -ItemType Directory -Path $resolvedInstallDir -Force | Out-Null
Copy-Item -Path (Join-Path $source "*") -Destination $resolvedInstallDir -Recurse -Force

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop $ShortcutName
$targetExe = Join-Path $resolvedInstallDir "modelcost_monitor.exe"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetExe
$shortcut.WorkingDirectory = $resolvedInstallDir
$shortcut.Description = "ModelCost Monitor"
$shortcut.IconLocation = "$targetExe,0"
$shortcut.Save()

$legacyDesktopFolder = Join-Path $desktop "ModelCost Monitor"
if (Test-Path -LiteralPath $legacyDesktopFolder) {
  $resolvedLegacyFolder = [System.IO.Path]::GetFullPath($legacyDesktopFolder)
  $resolvedDesktop = [System.IO.Path]::GetFullPath($desktop)
  if (
    $resolvedLegacyFolder.StartsWith($resolvedDesktop, [System.StringComparison]::OrdinalIgnoreCase) -and
    ([System.IO.Path]::GetFileName($resolvedLegacyFolder) -eq "ModelCost Monitor")
  ) {
    Remove-Item -LiteralPath $resolvedLegacyFolder -Recurse -Force
  }
}

Write-Host "Installed to: $resolvedInstallDir"
Write-Host "Desktop shortcut: $shortcutPath"
