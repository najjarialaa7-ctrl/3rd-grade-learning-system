<#
.SYNOPSIS
  Puts a snapshot (the lessons and activities a student sees without a Claude account) inside the app page.

.DESCRIPTION
  The app is one self-contained HTML file. Its <script type="application/json" id="snap"> block holds a
  read-only copy of the lessons, so the page still works when it is opened outside Claude (for example on
  a child's iPad, or on a static web host). This script replaces that block with the snapshot file you give it.

  A snapshot has the same shape the app itself produces with the "Update the student's version" button:
  { v, at, nexUrl, tables, student, weeks[], lessons[], items[] } - see data/README.md.

.EXAMPLE
  ./scripts/embed-snapshot.ps1 -Snapshot data/sample/snapshot.json
  Embeds the sample data into app/learning-system.html.

.EXAMPLE
  ./scripts/embed-snapshot.ps1 -Snapshot private/my-child/snapshot.json -Out private/deploy/notebook.html
  Builds a personal copy without touching the shared app file.
#>
param(
  [Parameter(Mandatory = $true)][string]$Snapshot,
  [string]$App = (Join-Path $PSScriptRoot '..\app\learning-system.html'),
  [string]$Out
)
$ErrorActionPreference = 'Stop'
if (-not $Out) { $Out = $App }
$enc = New-Object System.Text.UTF8Encoding $false
$page = [IO.File]::ReadAllText((Resolve-Path $App), $enc)
$json = [IO.File]::ReadAllText((Resolve-Path $Snapshot), $enc).Trim()
$null = $json | ConvertFrom-Json   # stops here if the snapshot is not valid JSON
# Keep the JSON safe inside a <script> tag.
$json = $json.Replace('</', '<\/').Replace([string][char]0x2028, ' ').Replace([string][char]0x2029, ' ')
$open = '<script type="application/json" id="snap">'
$i = $page.IndexOf($open)
if ($i -lt 0) { throw "No snapshot block found in $App" }
$a = $i + $open.Length
$b = $page.IndexOf('</script>', $a)
$new = $page.Substring(0, $a) + $json + $page.Substring($b)
$outDir = Split-Path -Parent $Out
if ($outDir -and -not (Test-Path $outDir)) { New-Item -ItemType Directory -Force $outDir | Out-Null }
[IO.File]::WriteAllText($Out, $new.Replace("`r`n", "`n"), $enc)
Write-Host ("Embedded {0} into {1} ({2} KB)" -f $Snapshot, $Out, [math]::Round((Get-Item $Out).Length / 1KB))
