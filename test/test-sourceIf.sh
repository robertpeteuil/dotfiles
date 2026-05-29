#!/usr/bin/env bash
# cspell: disable

set -u

repo_root="$(cd "$(dirname "$0")/.." && pwd)"

if [[ -n ${BASH_VERSION:-} ]]; then
  BASH_RC_LOADED=1 source "$repo_root/shell/bash_profile"
elif [[ -n ${ZSH_VERSION:-} ]]; then
  source "$repo_root/zsh/functions/sourceIf"
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

workdir="$(mktemp -d "${TMPDIR:-/tmp}/sourceIf.XXXXXX")"
trap 'rm -rf "$workdir"' EXIT

TEST_VAR="unset"
sourceIf "$workdir/missing"
assert_eq "$TEST_VAR" "unset" "non-existent file is ignored"

sourceIf "$workdir"
assert_eq "$TEST_VAR" "unset" "directory is ignored"

printf '%s\n' 'TEST_VAR="test successful"' > "$workdir/test_file"
sourceIf "$workdir/test_file"
assert_eq "$TEST_VAR" "test successful" "readable regular file is sourced"

if (( failures > 0 )); then
  exit 1
fi
