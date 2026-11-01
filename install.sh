#!/usr/bin/env bash
# automatt installer — harness-aware, verifying, idempotent.
# 一份公开仓装齐：driver(automatt) + 27 个上游 skill（上游随仓分发，MIT；许可声明见 THIRD-PARTY-NOTICES.md）
# Targets: ~/.agents/skills/ always + detected harness dir (never project-local unless --dir).
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/zkkk9555/automatt-skill/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --harness zcode --dry-run
#   curl -fsSL .../install.sh | bash -s -- --slim --dir /my/harness/skills
# Flags: --harness auto|claude|codex|cursor|opencode|zcode|dsh|workbuddy|all  --dir PATH  --ref GIT_REF
#        --slim (driver only)  --with-upstream (legacy alias, default is full)
#        --dry-run  --uninstall  --yes  -h|--help
# Env: AUTOMATT_SKILLS_DIR (alias: explicit --dir wins)
set -euo pipefail

PUB_URL="${AUTOMATT_PUB_URL:-https://github.com/zkkk9555/automatt-skill}"   # 可用环境变量指向镜像/本地测试包
PUB_REF="V2.055"   # 发版脚本从 VERSION 派生：钉版本 ⇒「我装的是哪一版」有答案（--ref 可覆盖）
# 27 upstream names, hardcoded manifest for count verification
UPSTREAM_NAMES="ask-matt code-review codebase-design diagnosing-bugs domain-modeling grill-me grill-with-docs grilling handoff implement implement-spec improve-codebase-architecture pr prototype research retro setup-matt-pocock-skills tdd teach to-questionnaire to-spec to-tickets triage wait-what wayfinder wizard writing-for-agents"

HARNESS="auto"; DIR=""; SLIM=0; DRY=0; UNINST=0; YES=0
while [ $# -gt 0 ]; do
  case "$1" in
    --harness) HARNESS="${2:-auto}"; shift 2;;
    --dir) DIR="${2:-}"; shift 2;;
    --ref) PUB_REF="${2:-$PUB_REF}"; shift 2;;
    --slim) SLIM=1; shift;;
    --with-upstream) shift;; # legacy alias: full install is now the default
    --dry-run) DRY=1; shift;;
    --uninstall) UNINST=1; shift;;
    --yes) YES=1; shift;;
    -h|--help) sed -n '2,12p' "$0"; echo; echo "Examples:"; echo "  bash install.sh --harness zcode --dry-run"; echo "  bash install.sh --harness zcode"; echo "  bash install.sh --slim --dir /my/harness/skills"; echo "  bash install.sh --uninstall"; exit 0;;
    *) echo "unknown flag: $1 (see --help)"; exit 1;;
  esac
done
[ -n "${AUTOMATT_SKILLS_DIR:-}" ] && [ -z "$DIR" ] && DIR="$AUTOMATT_SKILLS_DIR"

harness_dir() { # name -> dir or empty
  case "$1" in
    claude) echo "$HOME/.claude/skills";;
    codex) echo "$HOME/.codex/skills";;
    cursor) echo "$HOME/.cursor/skills";;
    opencode) echo "$HOME/.config/opencode/skills";;
    zcode) echo "$HOME/.zcode/skills";;
    dsh) echo "$HOME/.dsh/skills";;
    workbuddy) echo "$HOME/.workbuddy/skills";;
  esac
}
detect_harness() { # exactly one strong env signal -> name, else empty
  local found=""
  [ -n "${CLAUDECODE:-}${CLAUDE_CODE_ENTRYPOINT:-}" ] && found="$found claude"
  [ -n "${CODEX_HOME:-}${CODEX_THREAD_ID:-}" ] && found="$found codex"
  [ -n "${CURSOR_AGENT:-}${CURSOR_TRACE_ID:-}" ] && found="$found cursor"
  [ -n "${OPENCODE_CLIENT:-}" ] && found="$found opencode"
  # shellcheck disable=SC2154
  [ -n "${ZCODE_APP_VERSION:-}${ZCODE_SESSION_ID:-}" ] && found="$found zcode"
  [ -n "${DSH_HOME:-}${DSH_PROFILE:-}" ] && found="$found dsh"
  set -- $found
  [ $# -eq 1 ] && echo "$1" || echo ""
}

TARGETS="$HOME/.agents/skills"
ask_menu() { # interactive menu; prints chosen harness or path; silent fallback
  [ -t 0 ] && [ -r /dev/tty ] || return 1
  local det="$1" def=2 i
  [ -n "$det" ] && def=1
  {
    echo "请选择安装位置（默认装通用目录；探测命中标 ★）："
    if [ -n "$det" ]; then echo "1) ★ 检测到：$det ($(harness_dir "$det"))"; else echo "1) 自动检测（未命中）"; fi
    echo "2) 通用目录 (~/.agents/skills/)"
    echo "3) Claude Code (~/.claude/skills/)"
    echo "4) Codex (~/.codex/skills/)"
    echo "5) Cursor (~/.cursor/skills/)"
    echo "6) DeepSeek Harness (~/.dsh/skills/)"
    echo "7) 自定义路径（输入）"
    printf "请选择 [${def}]: "
  } >/dev/tty
  local ans=""; IFS= read -r ans </dev/tty 2>/dev/null || return 1
  ans="${ans:-$def}"
  case "$ans" in
    1) [ -n "$det" ] && { echo "HARNESS:$det"; return 0; }; return 1;;
    2) echo "HARNESS:generic"; return 0;;
    3) echo "HARNESS:claude"; return 0;;
    4) echo "HARNESS:codex"; return 0;;
    5) echo "HARNESS:cursor"; return 0;;
    6) echo "HARNESS:dsh"; return 0;;
    7) { printf "请输入 skills 目录完整路径: " >/dev/tty; local p=""; IFS= read -r p </dev/tty 2>/dev/null || return 1; [ -n "$p" ] && { echo "DIR:$p"; return 0; }; return 1; };;
    *) return 1;;
  esac
}
if [ -n "$DIR" ]; then
  TARGETS="$DIR" # explicit dir wins, exclusive
elif [ "$HARNESS" = "all" ]; then
  for h in claude codex cursor opencode zcode dsh workbuddy; do TARGETS="$TARGETS $(harness_dir $h)"; done
elif [ "$HARNESS" != "auto" ]; then
  d="$(harness_dir "$HARNESS")"; [ -n "$d" ] && [ "$d" != "$HOME/.agents/skills" ] && TARGETS="$TARGETS $d"
else
  det="$(detect_harness)"
  if [ -t 0 ] || [ -r /dev/tty ]; then
    pick="$(ask_menu "$det" 2>/dev/null)" || pick=""
    case "$pick" in
      HARNESS:generic) :;;
      HARNESS:*) HARNESS="${pick#HARNESS:}"; d="$(harness_dir "$HARNESS")"; [ -n "$d" ] && [ "$d" != "$HOME/.agents/skills" ] && TARGETS="$TARGETS $d";;
      DIR:*) TARGETS="${pick#DIR:}";;
      *) [ -n "$det" ] && { d="$(harness_dir "$det")"; [ "$d" != "$HOME/.agents/skills" ] && TARGETS="$TARGETS $d"; };;
    esac
  elif [ -n "$det" ]; then
    d="$(harness_dir "$det")"; [ "$d" != "$HOME/.agents/skills" ] && TARGETS="$TARGETS $d"
  fi
fi

ALL_NAMES="automatt $UPSTREAM_NAMES"
# 旧名安装目录：改名后残留 = 老版本 driver 还在目录里（会按旧规则干活）⇒ 装新名时顺手清掉
LEGACY_NAMES="autopilot"
[ "$SLIM" = 1 ] && WANT="automatt" || WANT="$ALL_NAMES"

if [ "$DRY" = 1 ]; then
  echo "plan: ref:$PUB_REF"
  echo "plan: targets:$TARGETS"
  echo "plan: skills: $WANT"
  exit 0
fi

# 只删链接、不删它指向的东西（junction/软链是别人家真身的入口 ⇒ 绝不顺着删进去）
rm_path() { # path
  if [ -L "$1" ]; then rm -f "$1"; echo "removed link $1 (its target was left alone)"; else rm -rf "$1"; fi
}

if [ "$UNINST" = 1 ]; then
  ndirs=$(echo "$TARGETS" | wc -w)
  if [ "$ndirs" -ge 2 ] && [ "$YES" != 1 ]; then echo "refusing: $ndirs targets without --yes"; exit 1; fi
  for t in $TARGETS; do
    case "$t" in /|"$HOME") echo "refusing dangerous target: $t"; exit 1;; esac
    for n in $ALL_NAMES $LEGACY_NAMES; do [ -e "$t/$n" ] || [ -L "$t/$n" ] && { rm_path "$t/$n"; echo "removed $t/$n"; }; done
  done
  exit 0
fi

fetch() { # url outfile: retry 3
  curl -fsSL --retry 3 --retry-all-errors "$1" -o "$2"
}
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
echo "==> Downloading automatt ($PUB_URL @ $PUB_REF)"
fetch "$PUB_URL/archive/refs/tags/$PUB_REF.tar.gz" "$TMP/pub.tar.gz" \
  || fetch "$PUB_URL/archive/refs/heads/$PUB_REF.tar.gz" "$TMP/pub.tar.gz" \
  || { echo "ERROR: 拉不到 $PUB_REF（tag 与 branch 都试过了）"; exit 1; }
tar -xzf "$TMP/pub.tar.gz" -C "$TMP"
PUB_ROOT="$(find "$TMP" -maxdepth 1 -type d -name 'automatt-skill*' | head -1)"
[ -n "$PUB_ROOT" ] || { echo "ERROR: 归档结构异常（找不到 automatt-skill* 目录）"; exit 1; }
[ -f "$PUB_ROOT/automatt/SKILL.md" ] || { echo "ERROR: driver payload broken"; exit 1; }
if [ "$SLIM" != 1 ]; then
  [ -d "$PUB_ROOT/skills" ] || { echo "ERROR: 上游 27 个 skill 不在归档里（skills/ 缺失）"; exit 1; }
  echo "==> Upstream workflow skills: 随仓分发（$PUB_ROOT/skills）"
fi

fail=0
for t in $TARGETS; do
  mkdir -p "$t" || { echo "ERROR: not writable: $t (set AUTOMATT_SKILLS_DIR)"; exit 1; }
  rm_path "$t/automatt"; cp -r "$PUB_ROOT/automatt" "$t/automatt"
  for n in $LEGACY_NAMES; do
    [ -e "$t/$n" ] || [ -L "$t/$n" ] && { rm_path "$t/$n"; echo "removed legacy install $t/$n (superseded by automatt)"; }
  done
  if [ "$SLIM" != 1 ]; then
    for d in "$PUB_ROOT"/skills/*/; do
      name="$(basename "$d")"; [ -f "$d/SKILL.md" ] || continue
      rm_path "$t/$name"; cp -r "$d" "$t/$name"
    done
  fi
  # verify: driver frontmatter + count
  head -n 5 "$t/automatt/SKILL.md" | grep -q "^name: automatt" || { echo "ERROR: $t/automatt/SKILL.md frontmatter wrong"; fail=1; }
  have=0; missing=""
  for n in $WANT; do
    if [ -f "$t/$n/SKILL.md" ]; then have=$((have + 1)); else missing="$missing $n"; fi
  done
  want_n=$(echo "$WANT" | wc -w)
  if [ "$have" -eq "$want_n" ]; then
    echo "OK $t: required $have/$want_n SKILL.md"
  else
    echo "WARNING $t: only $have/$want_n (missing:$missing) — rerun full install"
    [ "$SLIM" = 1 ] || fail=1
    [ -f "$t/automatt/SKILL.md" ] || fail=1
  fi
done

echo; echo "==> Done (ref $PUB_REF). Restart your agent and check the skill list shows automatt,"
echo "    then say: \"The sidebar toggle stopped working — check and fix it.\""
[ "$fail" != 0 ] && exit 1 || true
