#!/usr/bin/env zsh
# cspell: disable

set -u

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
ZDOTDIR="$repo_root/zsh"

source "$repo_root/zsh/rc.d/04-envpath.zsh"
source "$repo_root/zsh/rc.d/13-functions.zsh"

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

workdir="$(mktemp -d "${TMPDIR:-/tmp}/zsh-autoload.XXXXXX")"
trap 'rm -rf "$workdir"' EXIT

mkdir -p "$workdir/bin" "$workdir/pre"
PATH="/usr/bin:/bin"
pathIf "$workdir/bin"
assert_eq "$PATH" "/usr/bin:/bin:$workdir/bin" "autoloaded pathIf appends on first call"

pathIfPre "$workdir/pre"
assert_eq "$PATH" "$workdir/pre:/usr/bin:/bin:$workdir/bin" "autoloaded pathIfPre prepends on first call"

TEST_VAR="unset"
printf '%s\n' 'TEST_VAR="autoload successful"' > "$workdir/source-file"
sourceIf "$workdir/source-file"
assert_eq "$TEST_VAR" "autoload successful" "autoloaded sourceIf sources on first call"

if (( failures > 0 )); then
  exit 1
fi
