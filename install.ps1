# automatt installer (Windows PowerShell) — harness-aware, verifying, idempotent.
param(
  [ValidateSet('auto','claude','codex','cursor','opencode','zcode','dsh','workbuddy','all')][string]$Harness = 'auto',
  [string]$Dir = '',
  [string]$Ref = '',
  [switch]$Slim,
  [switch]$WithUpstream,  # legacy alias: full install is the default
  [switch]$DryRun,
  [switch]$Uninstall,
  [switch]$Yes
)
# param 块必须是脚本的**第一条语句**（前面只能有注释）——TLS 设置必须放在 param 之后，
# 否则整份脚本解析失败（V2.054：公开仓里的 install.ps1 一直带着这个语法错，Windows 用户根本跑不起来）。
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Stop'
# Usage:
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/automatt-skill/main/install.ps1)))
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/automatt-skill/main/install.ps1))) -Harness zcode -DryRun

$PubUrl = 'https://github.com/zkkk9555/automatt-skill'
$PubRef = if ($Ref) { $Ref } else { '2.0.59' }   # 发版脚本每次从 VERSION 重写这一行：钉版本 ⇒「我装的是哪一版」有答案
$UpstreamNames = @('ask-matt','code-review','codebase-design','diagnosing-bugs','domain-modeling','grill-me','grill-with-docs','grilling','handoff','implement','implement-spec','improve-codebase-architecture','pr','prototype','research','retro','setup-matt-pocock-skills','tdd','teach','to-questionnaire','to-spec','to-tickets','triage','wait-what','wayfinder','wizard','writing-for-agents')

function Harness-Dir($h) {
  switch ($h) {
    'claude' { return (Join-Path $HOME '.claude\skills') }
    'codex' { return (Join-Path $HOME '.codex\skills') }
    'cursor' { return (Join-Path $HOME '.cursor\skills') }
    'opencode' { return (Join-Path $HOME '.config\opencode\skills') }
    'zcode' { return (Join-Path $HOME '.zcode\skills') }
    'dsh' { return (Join-Path $HOME '.dsh\skills') }
    'workbuddy' { return (Join-Path $HOME '.workbuddy\skills') }
  }
  return ''
}
function Detect-Harness {
  $f = @()
  if ($env:CLAUDECODE -or $env:CLAUDE_CODE_ENTRYPOINT) { $f += 'claude' }
  if ($env:CODEX_HOME -or $env:CODEX_THREAD_ID) { $f += 'codex' }
  if ($env:CURSOR_AGENT -or $env:CURSOR_TRACE_ID) { $f += 'cursor' }
  if ($env:OPENCODE_CLIENT) { $f += 'opencode' }
  if ($env:ZCODE_APP_VERSION -or $env:ZCODE_SESSION_ID) { $f += 'zcode' }
  if ($env:DSH_HOME -or $env:DSH_PROFILE) { $f += 'dsh' }
  if ($f.Count -eq 1) { return $f[0] } else { return '' }
}
# 只删链接、不删它指向的东西（junction/软链是别人家真身的入口 ⇒ 绝不顺着删进去）
function Remove-InstalledPath($p) {
  $item = Get-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue
  if (-not $item) { return }
  if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
    & cmd /c rmdir "$p" | Out-Null   # rmdir 不带 /s ⇒ 只删链接，不递归进目标
    Write-Host "removed link $p (its target was left alone)"
    return
  }
  Remove-Item -LiteralPath $p -Recurse -Force
}

$Targets = @((Join-Path $HOME '.agents\skills'))
if ($env:AUTOMATT_SKILLS_DIR -and -not $Dir) { $Dir = $env:AUTOMATT_SKILLS_DIR }
if ($Dir) { $Targets = @($Dir) }
elseif ($Harness -eq 'all') { $Targets += @('claude','codex','cursor','opencode','zcode','dsh','workbuddy' | ForEach-Object { Harness-Dir $_ }) }
elseif ($Harness -ne 'auto') { $d = Harness-Dir $Harness; if ($d -and ($Targets -notcontains $d)) { $Targets += $d } }
else {
  $det = Detect-Harness
  try {
    $isTty = (-not [Console]::IsInputRedirected)
  } catch { $isTty = $false }
  if ($isTty -and -not $env:AUTOMATT_NO_MENU) {
    $def = 2; if ($det) { $def = 1 }
    Write-Host '请选择安装位置（默认装通用目录；探测命中标 ★）：'
    if ($det) { Write-Host "1) ★ 检测到：$det ($(Harness-Dir $det))" } else { Write-Host '1) 自动检测（未命中）' }
    Write-Host '2) 通用目录 (~/.agents/skills/)'
    Write-Host '3) Claude Code (~/.claude/skills/)'
    Write-Host '4) Codex (~/.codex/skills/)'
    Write-Host '5) Cursor (~/.cursor/skills/)'
    Write-Host '6) DeepSeek Harness (~/.dsh/skills/)'
    Write-Host "7) 自定义路径（输入）"
    $ans = Read-Host "请选择 [$def]"
    if (-not $ans) { $ans = "$def" }
    switch ($ans) {
      '1' { if ($det) { $d = Harness-Dir $det; if ($Targets -notcontains $d) { $Targets += $d } } }
      '2' { }
      '3' { $d = Harness-Dir 'claude'; if ($Targets -notcontains $d) { $Targets += $d } }
      '4' { $d = Harness-Dir 'codex'; if ($Targets -notcontains $d) { $Targets += $d } }
      '5' { $d = Harness-Dir 'cursor'; if ($Targets -notcontains $d) { $Targets += $d } }
      '6' { $d = Harness-Dir 'dsh'; if ($Targets -notcontains $d) { $Targets += $d } }
      '7' { $p = Read-Host '请输入 skills 目录完整路径'; if ($p) { $Targets = @($p) } }
    }
  } elseif ($det) { $d = Harness-Dir $det; if ($Targets -notcontains $d) { $Targets += $d } }
}

$Want = @('automatt'); if (-not $Slim) { $Want += $UpstreamNames }

if ($DryRun) {
  Write-Host "plan: ref: $PubRef"; Write-Host "plan: targets: $($Targets -join ', ')"; Write-Host "plan: skills: $($Want -join ' ')"
  return
}
if ($Uninstall) {
  if ($Targets.Count -ge 2 -and -not $Yes) { Write-Host 'refusing: 2+ targets without -Yes'; return }
  foreach ($t in $Targets) {
    if ($t -in @('/', $HOME, 'C:\')) { Write-Host "refusing dangerous target: $t"; return }
    foreach ($n in (@('automatt','autopilot') + $UpstreamNames)) { $p = Join-Path $t $n; if (Test-Path $p) { Remove-InstalledPath $p; Write-Host "removed $p" } }
  }
  return
}

$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('automatt-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $Tmp | Out-Null
try {
  Write-Host "==> Downloading automatt ($PubUrl @ $PubRef)"
  $tarball = "$Tmp\pub.tar.gz"
  $got = $false
  foreach ($url in @("$PubUrl/archive/refs/tags/$PubRef.tar.gz", "$PubUrl/archive/refs/heads/$PubRef.tar.gz")) {
    $retry = 0; $ok = $false
    while (-not $ok -and $retry -lt 3) { try { Invoke-WebRequest $url -OutFile $tarball; $ok = $true } catch { $retry++ } }
    if ($ok) { $got = $true; break }
  }
  if (-not $got) { throw "拉不到 $PubRef（tag 与 branch 都试过了）" }
  tar -xzf $tarball -C $Tmp
  $PubRoot = (Get-ChildItem $Tmp -Directory | Where-Object { $_.Name -like 'automatt-skill*' } | Select-Object -First 1).FullName
  if (-not $PubRoot) { throw '归档结构异常（找不到 automatt-skill* 目录）' }
  if (-not (Test-Path (Join-Path $PubRoot 'automatt\SKILL.md'))) { throw 'driver payload broken' }
  if (-not $Slim) {
    if (-not (Test-Path (Join-Path $PubRoot 'skills'))) { throw '上游 27 个 skill 不在归档里（skills\ 缺失）' }
    Write-Host '==> Upstream workflow skills: 随仓分发'
  }
  $fail = $false
  foreach ($t in $Targets) {
    New-Item -ItemType Directory -Force -Path $t | Out-Null
    Remove-InstalledPath (Join-Path $t 'automatt')
    Copy-Item -Recurse -Force (Join-Path $PubRoot 'automatt') (Join-Path $t 'automatt')
    # 旧名安装目录：改名后残留 = 老版本 driver 还在目录里（会按旧规则干活）⇒ 装新名时顺手清掉
    $legacy = Join-Path $t 'autopilot'
    if (Test-Path $legacy) { Remove-InstalledPath $legacy; Write-Host "removed legacy install $legacy (superseded by automatt)" }
    if (-not $Slim) {
      Get-ChildItem (Join-Path $PubRoot 'skills') -Directory | ForEach-Object {
        if (Test-Path (Join-Path $_.FullName 'SKILL.md')) {
          $target = Join-Path $t $_.Name
          Remove-InstalledPath $target
          Copy-Item -Recurse -Force $_.FullName $target
        }
      }
    }
    $head = Get-Content (Join-Path $t 'automatt\SKILL.md') -TotalCount 5 -Raw
    if ($head -notmatch '(?m)^name: automatt') { Write-Host "ERROR: $t\automatt\SKILL.md frontmatter wrong"; $fail = $true }
    $have = 0; $miss = @()
    foreach ($n in $Want) { if (Test-Path (Join-Path $t "$n\SKILL.md")) { $have++ } else { $miss += $n } }
    if ($have -eq $Want.Count) { Write-Host "OK ${t}: required $have/$($Want.Count) SKILL.md" }
    else { Write-Host "WARNING ${t}: only $have/$($Want.Count) (missing: $($miss -join ',')) — rerun full install"; if (-not $Slim) { $fail = $true } }
  }
  Write-Host ''; Write-Host "==> Done (ref $PubRef). Restart your agent and check the skill list shows automatt,"
  Write-Host '    then say: "The sidebar toggle stopped working - check and fix it."'
  if ($fail) { throw 'verification failed' }
} finally {
  Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
