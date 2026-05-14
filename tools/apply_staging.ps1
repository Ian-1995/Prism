<#
.SYNOPSIS
  Move _pending_claude/ contents into .claude/.

.DESCRIPTION
  Cowork desktop session blocks writes under .claude/ at mount level
  (fuse client filter + Write tool path filter). Workaround: Claude writes
  to prism/_pending_claude/ (mirroring .claude/ layout), and the user runs
  this script to robocopy /MOVE the staged files into .claude/.

  Default is dry-run; pass -Apply to actually move. Empty source dirs are
  cleaned up after a successful move.

.PARAMETER Apply
  Actually perform the move. Without this flag the script does a dry-run.

.EXAMPLE
  .\tools\apply_staging.ps1
  # dry-run: list files that would be moved

.EXAMPLE
  .\tools\apply_staging.ps1 -Apply
  # actually move; staging gets cleaned after move

.NOTES
  robocopy exit codes 0..7 are success. 8+ is real failure.
  Script encoding: ASCII-only on purpose, so PowerShell 5.x parses
  it regardless of system codepage.
#>

[CmdletBinding()]
param(
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Staging  = Join-Path $RepoRoot '_pending_claude'
$Target   = Join-Path $RepoRoot '.claude'

function Write-Header($text) {
    Write-Host ''
    Write-Host ('=' * 60) -ForegroundColor DarkGray
    Write-Host $text -ForegroundColor Cyan
    Write-Host ('=' * 60) -ForegroundColor DarkGray
}

Write-Header 'apply_staging.ps1 -- prism staging -> .claude/'

if (-not (Test-Path $Staging)) {
    Write-Host "Staging dir not found: $Staging" -ForegroundColor Yellow
    Write-Host 'Nothing to do.' -ForegroundColor Green
    exit 0
}

$StagingFiles = Get-ChildItem -Path $Staging -Recurse -File -ErrorAction SilentlyContinue
if ($StagingFiles.Count -eq 0) {
    Write-Host "Staging dir is empty: $Staging" -ForegroundColor Yellow
    Write-Host 'Nothing to do.' -ForegroundColor Green
    exit 0
}

if (-not (Test-Path $Target)) {
    Write-Host ".claude dir not found: $Target" -ForegroundColor Red
    Write-Host 'This is unexpected. Aborting.' -ForegroundColor Red
    exit 1
}

Write-Header "Plan: $Staging -> $Target"

$Plan = foreach ($f in $StagingFiles) {
    $rel = $f.FullName.Substring($Staging.Length).TrimStart('\','/')
    $dst = Join-Path $Target $rel
    $exists = Test-Path $dst
    [pscustomobject]@{
        Relative = $rel
        SizeKB   = [math]::Round($f.Length / 1KB, 2)
        Action   = if ($exists) { 'OVERWRITE' } else { 'NEW' }
        DstPath  = $dst
    }
}

$Plan | Format-Table Relative, SizeKB, Action -AutoSize

$NewCount       = ($Plan | Where-Object Action -EQ 'NEW').Count
$OverwriteCount = ($Plan | Where-Object Action -EQ 'OVERWRITE').Count
Write-Host ("Total: {0} files -- {1} new / {2} overwrite" -f $Plan.Count, $NewCount, $OverwriteCount) -ForegroundColor Cyan

if (-not $Apply) {
    Write-Header 'DRY-RUN -- no -Apply flag, nothing written.'
    Write-Host 'To actually move:' -ForegroundColor Green
    Write-Host '    .\tools\apply_staging.ps1 -Apply' -ForegroundColor Green
    exit 0
}

Write-Header 'Applying...'

# /E recurse incl. empty dirs; /MOVE delete source after copy
# /NFL /NDL suppress per-file/dir logs; /NJH /NJS suppress header/summary
$null = & robocopy $Staging $Target /E /MOVE /NFL /NDL /NJH /NJS
$rcExit = $LASTEXITCODE

Write-Host ''
if ($rcExit -lt 8) {
    Write-Host ("robocopy exit={0} -- move succeeded" -f $rcExit) -ForegroundColor Green

    if (Test-Path $Staging) {
        $remaining = Get-ChildItem $Staging -Recurse -File -ErrorAction SilentlyContinue
        if ($remaining.Count -eq 0) {
            Remove-Item $Staging -Recurse -Force
            Write-Host "Staging cleaned: $Staging" -ForegroundColor DarkGray
        }
    }

    Write-Header 'Done. Suggested check:'
    Write-Host '    git status' -ForegroundColor DarkCyan
    exit 0
} else {
    Write-Host ("robocopy exit={0} -- FAILED" -f $rcExit) -ForegroundColor Red
    Write-Host 'Staging not cleaned. Check errors.' -ForegroundColor Yellow
    exit $rcExit
}
