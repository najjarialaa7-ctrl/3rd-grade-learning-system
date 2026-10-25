<#
.SYNOPSIS
  Runs the browser tests in tests/ against app/learning-system.html, in headless Microsoft Edge (or Chrome).

.DESCRIPTION
  Each test page is put in front of the app page, together with tests/_harness.js (fake speech engine,
  fake Claude runtime, assertions) and the sample snapshot. The page runs in headless Edge with virtual
  time, then the runner reads the data-result attribute the test leaves on <html>: PASS or FAIL: reasons.

.EXAMPLE
  ./scripts/run-tests.ps1
.EXAMPLE
  ./scripts/run-tests.ps1 -Browser "C:\Program Files\Google\Chrome\Application\chrome.exe"
#>
param([string]$Browser)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $Browser) {
  $Browser = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
               "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
               '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge',
               '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome') | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
}
if (-not $Browser) { throw 'No browser found. Pass -Browser with the path to msedge or chrome.' }

$enc = New-Object System.Text.UTF8Encoding $false
$tmp = Join-Path ([IO.Path]::GetTempPath()) ('lsys-tests-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory $tmp | Out-Null
$page = [IO.File]::ReadAllText((Join-Path $root 'app/learning-system.html'), $enc)
$sample = [IO.File]::ReadAllText((Join-Path $root 'data/sample/snapshot.json'), $enc)
[IO.File]::WriteAllText((Join-Path $tmp 'sample.js'), "window.__SAMPLE=$sample;", $enc)
Copy-Item (Join-Path $root 'tests/_harness.js') $tmp

# file, hash (variant), virtual-time budget in ms
$cases = @(
  @('picture-guide.test.html', '', 6000),
  @('tutor.test.html', '', 8000),
  @('times-tables.test.html', '', 200000),
  @('voice.test.html', '#ios', 6000),
  @('voice.test.html', '#win', 6000),
  @('voice.test.html', '#edge', 6000),
  @('profile.test.html', '#named', 8000),
  @('profile.test.html', '', 6000),
  @('student-copy.test.html', '', 8000),
  @('student-copy-publish.test.html', '', 6000),
  @('weekly-plan-pdf.test.html', '', 250000),
  @('older-lessons.test.html', '', 6000)
)
$failed = 0
foreach ($c in $cases) {
  $file, $hash, $budget = $c
  $test = [IO.File]::ReadAllText((Join-Path $root "tests/$file"), $enc)
  $run = Join-Path $tmp ("run-" + $file)
  # The charset comes first: a test that starts with a long ASCII block could otherwise be read in the wrong encoding.
  [IO.File]::WriteAllText($run, '<meta charset="utf-8"><script src="_harness.js"></script><script src="sample.js"></script>' + "`n" + $test + $page, $enc)
  $url = 'file:///' + ($run -replace '\\', '/') + $hash
  # The browser logs harmless messages to stderr, so both streams go to files rather than the console.
  $outFile = Join-Path $tmp 'dom.txt'; $errFile = Join-Path $tmp 'log.txt'
  $args = @('--headless=new', '--disable-gpu', '--allow-file-access-from-files', "--virtual-time-budget=$budget", "--user-data-dir=$tmp/profile", '--dump-dom', "`"$url`"")
  Start-Process -FilePath $Browser -ArgumentList $args -RedirectStandardOutput $outFile -RedirectStandardError $errFile -Wait -NoNewWindow
  $dom = [IO.File]::ReadAllText($outFile, $enc)
  $res = [Net.WebUtility]::HtmlDecode([regex]::Match($dom, 'data-result="([^"]*)"').Groups[1].Value)
  if (-not $res) { $res = 'FAIL: the test did not finish' }
  if ($res -ne 'PASS') { $failed++ }
  '{0,-40} {1}' -f ($file + $hash), $res
}
Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
if ($failed) { Write-Host "`n$failed of $($cases.Count) failed"; exit 1 }
Write-Host "`nAll $($cases.Count) passed"
