#!/usr/bin/env bash
# cspell: disable

set -u

script_dir="$(cd "$(dirname "$0")" && pwd)"

failures=0
run_test() {
  echo
  echo "$*"
  "$@" || failures=$((failures + 1))
}

echo "=== Testing in Bash ==="
run_test bash "$script_dir/test-sourceIf.sh"
run_test bash "$script_dir/test-pathIf.sh"
run_test bash "$script_dir/test-pathIfPre.sh"

if command -v zsh >/dev/null; then
  echo
  echo "=== Testing in ZSH ==="
  run_test zsh "$script_dir/test-sourceIf.sh"
  run_test zsh "$script_dir/test-pathIf.sh"
  run_test zsh "$script_dir/test-pathIfPre.sh"
  run_test zsh "$script_dir/test-zsh-autoload.sh"
else
  echo
  echo "SKIP: zsh not available"
fi

if (( failures > 0 )); then
  exit 1
fi
