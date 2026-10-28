#!/usr/bin/env bash
# Installs project-kickstart packs into a project's .claude/ folder or into ~/.claude.
#
#   ./install.sh --all                      everything into ./.claude (run it from your project)
#   ./install.sh --pack mobile,backend      selected packs
#   ./install.sh --all --global             into ~/.claude (every project on this machine)
#   ./install.sh --all --target ~/code/app  into ~/code/app/.claude
#   ./install.sh --all --dry-run            show what would happen, change nothing
#   ./install.sh --list                     list packs and their skills
#
# Safe to re-run: identical files are skipped, changed files are kept unless you pass --force.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKS_DIR="$REPO_DIR/packs"
INIT_DIR="$REPO_DIR/init"

ALL_PACKS="init mobile backend admin-panel infrastructure website audits marketing video animation ideas-prototyping"

if [ -t 1 ]; then
  C_INFO=$'\033[0;36m'; C_OK=$'\033[0;32m'; C_WARN=$'\033[1;33m'; C_ERR=$'\033[0;31m'; C_OFF=$'\033[0m'
else
  C_INFO=""; C_OK=""; C_WARN=""; C_ERR=""; C_OFF=""
fi
info() { printf '%s%s%s\n' "$C_INFO" "$*" "$C_OFF"; }
ok()   { printf '%s%s%s\n' "$C_OK" "$*" "$C_OFF"; }
warn() { printf '%s%s%s\n' "$C_WARN" "$*" "$C_OFF" >&2; }
err()  { printf '%s%s%s\n' "$C_ERR" "$*" "$C_OFF" >&2; }

usage() {
  sed -n '2,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  cat <<'EOF'

Options:
  --all             install init + all 10 packs
  --pack a,b,c      install the listed packs (init, mobile, backend, admin-panel, infrastructure,
                    website, audits, marketing, video, animation, ideas-prototyping)
  --global          install into ~/.claude instead of ./.claude
  --target DIR      install into DIR/.claude
  --force           overwrite files that differ from the repo version
  --dry-run         print the plan, write nothing
  --list            list packs and skills, then exit
  -h, --help        this help
EOF
}

SELECTED=""
MODE_GLOBAL=false
TARGET_ROOT=""
FORCE=false
DRY_RUN=false
LIST_ONLY=false

while [ $# -gt 0 ]; do
  case "$1" in
    --all) SELECTED="$ALL_PACKS" ;;
    --pack|--packs)
      [ $# -ge 2 ] || { err "--pack needs a value, e.g. --pack mobile,backend"; exit 2; }
      SELECTED="$SELECTED $(printf '%s' "$2" | tr ',' ' ')"
      shift ;;
    --pack=*|--packs=*) SELECTED="$SELECTED $(printf '%s' "${1#*=}" | tr ',' ' ')" ;;
    --global) MODE_GLOBAL=true ;;
    --target)
      [ $# -ge 2 ] || { err "--target needs a directory"; exit 2; }
      TARGET_ROOT="$2"
      shift ;;
    --target=*) TARGET_ROOT="${1#*=}" ;;
    --force) FORCE=true ;;
    --dry-run) DRY_RUN=true ;;
    --list) LIST_ONLY=true ;;
    -h|--help) usage; exit 0 ;;
    *) err "Unknown option: $1"; usage; exit 2 ;;
  esac
  shift
done

pack_source_dir() {
  if [ "$1" = "init" ]; then printf '%s' "$INIT_DIR"; else printf '%s' "$PACKS_DIR/$1"; fi
}

is_known_pack() {
  local name="$1" known
  for known in $ALL_PACKS; do
    [ "$known" = "$name" ] && return 0
  done
  return 1
}

list_packs() {
  local pack dir skill
  for pack in $ALL_PACKS; do
    dir="$(pack_source_dir "$pack")"
    printf '%s\n' "$pack"
    if [ -d "$dir/skills" ]; then
      for skill in "$dir"/skills/*/; do
        [ -f "$skill/SKILL.md" ] && printf '  skill    %s\n' "$(basename "$skill")"
      done
    fi
    for kind in agents commands; do
      if [ -d "$dir/$kind" ]; then
        for file in "$dir/$kind"/*.md; do
          [ -f "$file" ] && printf '  %-8s %s\n' "${kind%s}" "$(basename "$file" .md)"
        done
      fi
    done
  done
}

if $LIST_ONLY; then
  list_packs
  exit 0
fi

if [ -z "${SELECTED// /}" ]; then
  err "Nothing selected. Use --all or --pack <names>."
  usage
  exit 2
fi

# Deduplicate while keeping the order of ALL_PACKS.
REQUESTED=""
for pack in $SELECTED; do
  if ! is_known_pack "$pack"; then
    err "Unknown pack: $pack"
    err "Known packs: $ALL_PACKS"
    exit 2
  fi
  REQUESTED="$REQUESTED $pack"
done
PACKS=""
for pack in $ALL_PACKS; do
  case " $REQUESTED " in *" $pack "*) PACKS="$PACKS $pack" ;; esac
done

if $MODE_GLOBAL && [ -n "$TARGET_ROOT" ]; then
  err "Use either --global or --target, not both."
  exit 2
fi
if $MODE_GLOBAL; then
  DEST="$HOME/.claude"
elif [ -n "$TARGET_ROOT" ]; then
  [ -d "$TARGET_ROOT" ] || { err "Target directory does not exist: $TARGET_ROOT"; exit 2; }
  DEST="$(cd "$TARGET_ROOT" && pwd)/.claude"
else
  if [ "$(pwd -P)" = "$(cd "$REPO_DIR" && pwd -P)" ]; then
    err "You are inside the project-kickstart repo. Run the script from your project folder,"
    err "or pass --target <project-dir> or --global."
    exit 2
  fi
  DEST="$(pwd)/.claude"
fi

# Skill folders are installed flat, so a name may exist in only one pack.
SEEN_SKILLS=""
for pack in $PACKS; do
  dir="$(pack_source_dir "$pack")"
  [ -d "$dir/skills" ] || continue
  for skill in "$dir"/skills/*/; do
    [ -d "$skill" ] || continue
    name="$(basename "$skill")"
    case " $SEEN_SKILLS " in
      *" $name "*) err "Skill name '$name' exists in more than one selected pack. Rename one of them."; exit 1 ;;
    esac
    SEEN_SKILLS="$SEEN_SKILLS $name"
  done
done

COUNT_NEW=0
COUNT_SAME=0
COUNT_UPDATED=0
COUNT_KEPT=0

install_file() {
  local src="$1" dst="$2"
  if [ ! -e "$dst" ]; then
    COUNT_NEW=$((COUNT_NEW + 1))
    if $DRY_RUN; then
      printf '  + %s\n' "${dst#"$DEST"/}"
    else
      mkdir -p "$(dirname "$dst")"
      cp "$src" "$dst"
    fi
  elif cmp -s "$src" "$dst"; then
    COUNT_SAME=$((COUNT_SAME + 1))
  elif $FORCE; then
    COUNT_UPDATED=$((COUNT_UPDATED + 1))
    if $DRY_RUN; then
      printf '  ~ %s (would overwrite, --force)\n' "${dst#"$DEST"/}"
    else
      cp "$src" "$dst"
      printf '  ~ %s (overwritten)\n' "${dst#"$DEST"/}"
    fi
  else
    COUNT_KEPT=$((COUNT_KEPT + 1))
    warn "  ! ${dst#"$DEST"/} differs from the repo version, kept yours (use --force to overwrite)"
  fi
}

install_tree() {
  local src_root="$1" dst_root="$2" file rel
  while IFS= read -r file; do
    rel="${file#"$src_root"/}"
    install_file "$file" "$dst_root/$rel"
  done < <(find "$src_root" -type f ! -name '.DS_Store' | LC_ALL=C sort)
}

if $DRY_RUN; then
  info "Dry run: nothing will be written."
fi
info "Target: $DEST"

for pack in $PACKS; do
  dir="$(pack_source_dir "$pack")"
  if [ ! -d "$dir" ]; then
    warn "Pack '$pack' is not in this checkout yet, skipped."
    continue
  fi
  info "Pack: $pack"
  found=false
  if [ -d "$dir/skills" ]; then
    for skill in "$dir"/skills/*/; do
      [ -f "$skill/SKILL.md" ] || continue
      found=true
      install_tree "${skill%/}" "$DEST/skills/$(basename "$skill")"
    done
  fi
  for kind in agents commands; do
    [ -d "$dir/$kind" ] || continue
    for file in "$dir/$kind"/*.md; do
      [ -f "$file" ] || continue
      found=true
      install_file "$file" "$DEST/$kind/$(basename "$file")"
    done
  done
  $found || warn "Pack '$pack' has no skills, agents or commands yet."
done

echo
summary="new: $COUNT_NEW, unchanged: $COUNT_SAME, overwritten: $COUNT_UPDATED, kept (differs): $COUNT_KEPT"
if $DRY_RUN; then
  ok "Dry run done. $summary"
else
  ok "Installed into $DEST. $summary"
  info "Restart Claude Code (or start a new session) so it picks up the new skills."
fi
