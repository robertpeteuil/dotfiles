#!/usr/bin/env bash
# cspell: disable

set -u

repo_root="$(cd "$(dirname "$0")/.." && pwd)"

if [[ -n ${BASH_VERSION:-} ]]; then
  BASH_RC_LOADED=1 source "$repo_root/shell/bash_profile"
elif [[ -n ${ZSH_VERSION:-} ]]; then
  source "$repo_root/zsh/functions/pathIf"
fi

failures=0
assert_eq() {
  if [[ "$1" == "$2" ]]; then
    echo "GOOD: $3"
  else
    echo "FAIL: $3"
    echo "  expected: $2"
    echo "  actual:   $1"
    failures=$((failures + 1))
  fi
}

workdir="$(mktemp -d "${TMPDIR:-/tmp}/pathIf.XXXXXX")"
trap 'rm -rf "$workdir"' EXIT

original_path="$PATH"
pathIf "$workdir/missing"
assert_eq "$PATH" "$original_path" "non-existent directory leaves PATH unchanged"

pathIf ""
assert_eq "$PATH" "$original_path" "empty argument leaves PATH unchanged"

mkdir -p "$workdir/bin" "$workdir/bin-extra"
PATH="$workdir/bin-extra:$original_path"
pathIf "$workdir/bin"
case ":$PATH:" in
  *":$workdir/bin:"*) echo "GOOD: partial substring match does not block insertion" ;;
  *) echo "FAIL: partial substring match blocked insertion"; failures=$((failures + 1)) ;;
esac

path_before_duplicate="$PATH"
pathIf "$workdir/bin"
assert_eq "$PATH" "$path_before_duplicate" "exact duplicate is not added twice"

if (( failures > 0 )); then
  exit 1
fi
