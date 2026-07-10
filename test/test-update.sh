#!/bin/bash
# cspell: disable
# Fake scripts below are intentionally emitted as literal single-quoted lines.
# shellcheck disable=SC2016

# Regression tests for the root update script.  The tests use only local Git
# repositories and replace Git's network-facing commands and Dotbot where
# those boundaries are under test.

set -u

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
update_source="$repo_root/update"
real_git="$(command -v git)"
original_path="$PATH"

export GIT_AUTHOR_NAME="update test"
export GIT_AUTHOR_EMAIL="update-test@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_ALLOW_PROTOCOL="file"

workdir="$(mktemp -d "${TMPDIR:-/tmp}/update-tests.XXXXXX")"
workdir="$(cd "$workdir" && pwd)"
trap 'rm -rf "$workdir"' EXIT HUP INT TERM

mkdir -p "$workdir/home" "$workdir/xdg-config"
export HOME="$workdir/home"
export XDG_CONFIG_HOME="$workdir/xdg-config"
export GIT_CONFIG_NOSYSTEM=1
export GIT_TERMINAL_PROMPT=0

failures=0
passes=0
case_number=0
RUN_STATUS=0
RUN_OUTPUT=
CREATED_REMOTE=
CREATED_SEED=

pass() {
  echo "GOOD: $1"
  passes=$((passes + 1))
}

fail() {
  echo "FAIL: $1"
  failures=$((failures + 1))
}

assert_eq() {
  if [ "$1" = "$2" ]; then
    pass "$3"
  else
    fail "$3"
    echo "  expected: $2"
    echo "  actual:   $1"
  fi
}

assert_contains() {
  case "$1" in
    *"$2"*) pass "$3" ;;
    *)
      fail "$3"
      echo "  missing: $2"
      echo "  output:"
      printf '%s\n' "$1" | while IFS= read -r line; do printf '    %s\n' "$line"; done
      ;;
  esac
}

assert_not_contains() {
  case "$1" in
    *"$2"*)
      fail "$3"
      echo "  unexpected: $2"
      ;;
    *) pass "$3" ;;
  esac
}

assert_file_contains() {
  if [ -f "$1" ]; then
    file_text=$(command cat "$1")
  else
    file_text=
  fi
  assert_contains "$file_text" "$2" "$3"
}

start_case() {
  case_number=$((case_number + 1))
  echo
  echo "--- $case_number. $1 ---"
}

init_repo() {
  repo=$1
  mkdir -p "$repo"
  "$real_git" init -q "$repo"
  printf 'initial\n' > "$repo/tracked.txt"
  (
    cd "$repo" || exit 1
    "$real_git" add tracked.txt
    "$real_git" commit -q -m initial
    "$real_git" branch -M main
  )
}

commit_all() {
  repo=$1
  message=$2
  (
    cd "$repo" || exit 1
    "$real_git" add -A
    "$real_git" commit -q -m "$message"
  )
}

new_sandbox() {
  label=$1
  sandbox="$workdir/${case_number}-${label}"
  mkdir -p "$sandbox"
  cp "$update_source" "$sandbox/update"
  chmod +x "$sandbox/update"
  init_repo "$sandbox"
  (
    cd "$sandbox" || exit 1
    "$real_git" add update
    "$real_git" commit -q -m update
  )
  printf '%s\n' "$sandbox"
}

new_plain_sandbox() {
  label=$1
  sandbox="$workdir/${case_number}-${label}"
  mkdir -p "$sandbox"
  cp "$update_source" "$sandbox/update"
  chmod +x "$sandbox/update"
  printf '%s\n' "$sandbox"
}

create_tracking_clone() {
  parent=$1
  key=$2
  target=$3
  CREATED_REMOTE="$parent/${key}.git"
  CREATED_SEED="$parent/${key}-seed"

  init_repo "$CREATED_SEED"
  "$real_git" init --bare -q "$CREATED_REMOTE"
  (
    cd "$CREATED_SEED" || exit 1
    "$real_git" remote add origin "$CREATED_REMOTE"
    "$real_git" push -q -u origin main
  )
  "$real_git" --git-dir="$CREATED_REMOTE" symbolic-ref HEAD refs/heads/main
  "$real_git" clone -q "$CREATED_REMOTE" "$target"
}

advance_seed() {
  seed=$1
  text=$2
  printf '%s\n' "$text" >> "$seed/tracked.txt"
  (
    cd "$seed" || exit 1
    "$real_git" add tracked.txt
    "$real_git" commit -q -m "$text"
    "$real_git" push -q origin main
  )
}

run_update() {
  target=$1
  shift
  RUN_OUTPUT=$(cd "$target" && ./update "$@" 2>&1)
  RUN_STATUS=$?
}

write_repos() {
  target=$1
  shift
  {
    printf '%s\n' 'REPOS=('
    for entry in "$@"; do
      printf '  "%s"\n' "$entry"
    done
    printf '%s\n' ')'
  } > "$target/repos.conf"
}

install_fake_dotbot() {
  target=$1
  mkdir -p "$target/dotbot/bin"
  {
    printf '%s\n' '#!/bin/bash'
    printf '%s\n' 'printf "cwd=%s" "$PWD" >> "$DOTBOT_LOG"'
    printf '%s\n' 'for arg in "$@"; do printf " <%s>" "$arg" >> "$DOTBOT_LOG"; done'
    printf '%s\n' 'printf "\\n" >> "$DOTBOT_LOG"'
    printf '%s\n' 'if [ -n "${DOTBOT_FAIL_DIR:-}" ] && [ "$PWD" = "$DOTBOT_FAIL_DIR" ]; then'
    printf '%s\n' '  exit "${DOTBOT_FAIL_STATUS:-7}"'
    printf '%s\n' 'fi'
    printf '%s\n' 'exit 0'
  } > "$target/dotbot/bin/dotbot"
  chmod +x "$target/dotbot/bin/dotbot"
}

install_fake_git() {
  bindir=$1
  mkdir -p "$bindir"
  {
    printf '%s\n' '#!/bin/bash'
    printf '%s\n' 'git_directory='
    printf '%s\n' 'if [ "${1:-}" = "-C" ]; then'
    printf '%s\n' '  git_directory=${2:-}'
    printf '%s\n' '  shift 2'
    printf '%s\n' 'fi'
    printf '%s\n' 'command_name=${1:-}'
    printf '%s\n' 'if [ "$command_name" = "ls-remote" ]; then'
    printf '%s\n' '  printf "ls-remote" >> "$FAKE_GIT_LOG"'
    printf '%s\n' '  for arg in "$@"; do printf "|%s" "$arg" >> "$FAKE_GIT_LOG"; done'
    printf '%s\n' '  printf "|\\n" >> "$FAKE_GIT_LOG"'
    printf '%s\n' '  case "$*" in *auto-public*) exit 0 ;; *) exit 1 ;; esac'
    printf '%s\n' 'fi'
    printf '%s\n' 'if [ "$command_name" = "clone" ]; then'
    printf '%s\n' '  printf "clone" >> "$FAKE_GIT_LOG"'
    printf '%s\n' '  target=' 
    printf '%s\n' '  for arg in "$@"; do printf "|%s" "$arg" >> "$FAKE_GIT_LOG"; target=$arg; done'
    printf '%s\n' '  printf "|\\n" >> "$FAKE_GIT_LOG"'
    printf '%s\n' '  mkdir -p "$target"'
    printf '%s\n' '  "$REAL_GIT" init -q "$target"'
    printf '%s\n' '  exit $?'
    printf '%s\n' 'fi'
    printf '%s\n' 'if [ "$command_name" = "remote" ] && [ "${2:-}" = "set-url" ]; then'
    printf '%s\n' '  printf "set-url" >> "$FAKE_GIT_LOG"'
    printf '%s\n' '  for arg in "$@"; do printf "|%s" "$arg" >> "$FAKE_GIT_LOG"; done'
    printf '%s\n' '  printf "|\\n" >> "$FAKE_GIT_LOG"'
    printf '%s\n' '  exit 0'
    printf '%s\n' 'fi'
    printf '%s\n' 'if [ -n "$git_directory" ]; then'
    printf '%s\n' '  exec "$REAL_GIT" -C "$git_directory" "$@"'
    printf '%s\n' 'fi'
    printf '%s\n' 'exec "$REAL_GIT" "$@"'
  } > "$bindir/git"
  chmod +x "$bindir/git"
}

# These cases pin the repository-root bug identified by AUDIT-20260710 item 1.
start_case "configured ordinary directory is rejected"
s=$(new_sandbox ordinary-target)
mkdir -p "$s/external/ordinary"
write_repos "$s" "owner/ordinary external/ordinary public shallow"
run_update "$s" --repo
if [ "$RUN_STATUS" -eq 1 ] && case "$RUN_OUTPUT" in *"target exists and is not a git repo"*) true;; *) false;; esac; then
  pass "ordinary directory is rejected as a configured repo target"
else
  fail "ordinary directory is rejected as a configured repo target (known root-detection bug)"
  echo "  exit: $RUN_STATUS"
fi

start_case "configured bare repository is rejected"
s=$(new_sandbox bare-target)
"$real_git" init --bare -q "$s/external/bare"
write_repos "$s" "owner/bare external/bare private full"
run_update "$s" --repo
if [ "$RUN_STATUS" -eq 1 ] && case "$RUN_OUTPUT" in *"target exists and is not a git repo"*) true;; *) false;; esac; then
  pass "bare repository is rejected as a configured worktree"
else
  fail "bare repository is rejected as a configured worktree (known root-detection bug)"
  echo "  exit: $RUN_STATUS"
fi

start_case "main and additional local branches do not fetch"
s=$(new_sandbox local-branches)
root_remote="$s-root.git"
"$real_git" init --bare -q "$root_remote"
(
  cd "$s" || exit 1
  "$real_git" remote add origin "$root_remote"
  "$real_git" push -q -u origin main
  "$real_git" branch --unset-upstream
)
"$real_git" --git-dir="$root_remote" symbolic-ref HEAD refs/heads/main
"$real_git" clone -q "$root_remote" "$s-root-writer"
printf 'remote change\n' >> "$s-root-writer/tracked.txt"
commit_all "$s-root-writer" remote-change
(cd "$s-root-writer" && "$real_git" push -q origin main)
root_before=$(cd "$s" && "$real_git" rev-parse refs/remotes/origin/main)
create_tracking_clone "$workdir" local-additional "$s/additional"
additional_seed=$CREATED_SEED
advance_seed "$additional_seed" remote-change
(cd "$s/additional" && "$real_git" branch --unset-upstream)
additional_before=$(cd "$s/additional" && "$real_git" rev-parse refs/remotes/origin/main)
write_repos "$s" "owner/additional additional public shallow"
run_update "$s" --repo
root_after=$(cd "$s" && "$real_git" rev-parse refs/remotes/origin/main)
additional_after=$(cd "$s/additional" && "$real_git" rev-parse refs/remotes/origin/main)
assert_eq "$RUN_STATUS" "0" "local branches are non-fatal"
assert_contains "$RUN_OUTPUT" "local branch 'main'" "local branch status is reported"
assert_eq "$root_after" "$root_before" "main local branch does not fetch"
assert_eq "$additional_after" "$additional_before" "additional local branch does not fetch"

start_case "clean tracking branches fetch and fast-forward"
s=$(new_sandbox fast-forward)
printf '%s\n' 'repos.conf' 'additional' >> "$s/.git/info/exclude"
root_remote="$s-root.git"
"$real_git" init --bare -q "$root_remote"
(
  cd "$s" || exit 1
  "$real_git" remote add origin "$root_remote"
  "$real_git" push -q -u origin main
)
"$real_git" --git-dir="$root_remote" symbolic-ref HEAD refs/heads/main
"$real_git" clone -q "$root_remote" "$s-root-writer"
printf 'upstream change\n' >> "$s-root-writer/tracked.txt"
commit_all "$s-root-writer" upstream-change
(cd "$s-root-writer" && "$real_git" push -q origin main)
root_expected=$(cd "$s-root-writer" && "$real_git" rev-parse HEAD)
create_tracking_clone "$workdir" fast-forward "$s/additional"
seed=$CREATED_SEED
advance_seed "$seed" upstream-change
additional_expected=$(cd "$seed" && "$real_git" rev-parse HEAD)
create_tracking_clone "$workdir" unrelated-remote "$workdir/unrelated-remote-clone"
unrelated_remote=$CREATED_REMOTE
unrelated_seed=$CREATED_SEED
"$real_git" -C "$s/additional" remote add secondary "$unrelated_remote"
"$real_git" -C "$s/additional" fetch -q secondary
unrelated_before=$(cd "$s/additional" && "$real_git" rev-parse refs/remotes/secondary/main)
advance_seed "$unrelated_seed" unrelated-change
write_repos "$s" "owner/additional additional public shallow"
run_update "$s" --repo
root_actual=$(cd "$s" && "$real_git" rev-parse HEAD)
additional_actual=$(cd "$s/additional" && "$real_git" rev-parse HEAD)
unrelated_after=$(cd "$s/additional" && "$real_git" rev-parse refs/remotes/secondary/main)
assert_eq "$RUN_STATUS" "0" "clean fast-forwards are non-fatal"
assert_eq "$root_actual" "$root_expected" "main tracking branch advances to upstream commit"
assert_eq "$additional_actual" "$additional_expected" "additional tracking branch advances to upstream commit"
assert_eq "$unrelated_after" "$unrelated_before" "clean tracking branch does not fetch an unrelated remote"
assert_contains "$RUN_OUTPUT" "updated branch 'main'" "updated tracking branch status is reported"

start_case "unsafe and unreachable repository states are not modified"
s=$(new_sandbox repo-states)
create_tracking_clone "$workdir" dirty "$s/dirty"
dirty_seed=$CREATED_SEED
dirty_head=$(cd "$s/dirty" && "$real_git" rev-parse HEAD)
dirty_remote_before=$(cd "$s/dirty" && "$real_git" rev-parse refs/remotes/origin/main)
printf 'dirty\n' >> "$s/dirty/tracked.txt"
advance_seed "$dirty_seed" upstream-change
create_tracking_clone "$workdir" detached "$s/detached"
detached_seed=$CREATED_SEED
(cd "$s/detached" && "$real_git" checkout -q --detach HEAD)
detached_head=$(cd "$s/detached" && "$real_git" rev-parse HEAD)
detached_sha=$(cd "$s/detached" && "$real_git" rev-parse --short HEAD)
detached_remote_before=$(cd "$s/detached" && "$real_git" rev-parse refs/remotes/origin/main)
advance_seed "$detached_seed" upstream-change
create_tracking_clone "$workdir" diverged "$s/diverged"
diverged_seed=$CREATED_SEED
printf 'local\n' >> "$s/diverged/tracked.txt"
commit_all "$s/diverged" local-change
diverged_head=$(cd "$s/diverged" && "$real_git" rev-parse HEAD)
advance_seed "$diverged_seed" upstream-change
create_tracking_clone "$workdir" unreachable "$s/unreachable"
unreachable_head=$(cd "$s/unreachable" && "$real_git" rev-parse HEAD)
(cd "$s/unreachable" && "$real_git" remote set-url origin "$workdir/does-not-exist.git")
write_repos "$s" \
  "owner/dirty dirty public shallow" \
  "owner/detached detached public shallow" \
  "owner/diverged diverged public shallow" \
  "owner/unreachable unreachable public shallow"
run_update "$s" --repo
assert_eq "$RUN_STATUS" "0" "unsafe and unreachable states remain non-fatal"
assert_contains "$RUN_OUTPUT" "dirty worktree" "dirty tracking worktree is reported"
assert_contains "$RUN_OUTPUT" "detached HEAD '$detached_sha'" "detached HEAD is reported"
assert_contains "$RUN_OUTPUT" "manual merge required" "diverged branch is reported"
assert_contains "$RUN_OUTPUT" "remote unreachable" "unreachable remote is reported"
assert_eq "$(cd "$s/dirty" && "$real_git" rev-parse HEAD)" "$dirty_head" "dirty tracking branch does not merge"
assert_eq "$(cd "$s/dirty" && "$real_git" rev-parse refs/remotes/origin/main)" "$dirty_remote_before" "dirty tracking branch does not fetch"
assert_eq "$(cd "$s/detached" && "$real_git" rev-parse HEAD)" "$detached_head" "detached HEAD does not move"
assert_eq "$(cd "$s/detached" && "$real_git" rev-parse refs/remotes/origin/main)" "$detached_remote_before" "detached repository does not fetch"
assert_eq "$(cd "$s/diverged" && "$real_git" rev-parse HEAD)" "$diverged_head" "diverged branch does not merge"
assert_eq "$(cd "$s/unreachable" && "$real_git" rev-parse HEAD)" "$unreachable_head" "unreachable branch does not move"

start_case "missing repos.conf is copied only in repo mode"
s=$(new_sandbox missing-config)
printf '%s\n' 'REPOS=()' > "$s/repos.conf.example"
run_update "$s" --repo
assert_eq "$RUN_STATUS" "0" "missing config creation is non-fatal"
assert_contains "$RUN_OUTPUT" "missing, created" "missing config creation is reported"
if [ -f "$s/repos.conf" ] && cmp -s "$s/repos.conf.example" "$s/repos.conf"; then
  pass "repos.conf is copied from the example"
else
  fail "repos.conf is copied from the example"
fi
s2=$(new_sandbox missing-config-no-example)
run_update "$s2" --repo
assert_eq "$RUN_STATUS" "0" "missing config without an example is non-fatal"
assert_contains "$RUN_OUTPUT" "missing, create failed" "missing example failure is reported"
if [ ! -e "$s2/repos.conf" ]; then
  pass "failed config creation leaves repos.conf absent"
else
  fail "failed config creation leaves repos.conf absent"
fi

start_case "malformed repos.conf files are ignored"
s=$(new_sandbox malformed-source)
printf '%s\n' 'REPOS=(' > "$s/repos.conf"
run_update "$s" --repo
assert_eq "$RUN_STATUS" "0" "source-failing config is non-fatal"
assert_contains "$RUN_OUTPUT" "source failed, ignoring" "source-failing config is reported"
s2=$(new_sandbox malformed-scalar)
printf '%s\n' 'REPOS="owner/repo target"' > "$s2/repos.conf"
run_update "$s2" --repo
assert_eq "$RUN_STATUS" "0" "non-array config is non-fatal"
assert_contains "$RUN_OUTPUT" "REPOS is not an array, ignoring" "non-array config is reported"

start_case "duplicate normalized targets skip both entries"
s=$(new_sandbox duplicate-targets)
write_repos "$s" \
  "owner/first ./external//same/ public shallow" \
  "owner/second external/same private full"
run_update "$s" --repo
assert_eq "$RUN_STATUS" "0" "duplicate targets are non-fatal"
assert_contains "$RUN_OUTPUT" "duplicate target 'external/same', skipped" "normalized duplicate is reported"
if [ ! -e "$s/external/same" ]; then
  pass "neither duplicate target entry is processed"
else
  fail "neither duplicate target entry is processed"
fi

start_case "clone access and depth combinations use the correct Git boundary"
s=$(new_sandbox clone-matrix)
fakebin="$s/fake-bin"
git_log="$s/git.log"
: > "$git_log"
install_fake_git "$fakebin"
write_repos "$s" \
  "owner/public-shallow clones/public public shallow" \
  "owner/private-full clones/private private full" \
  "owner/auto-public clones/auto-public auto" \
  "owner/auto-private clones/auto-private auto shallow"
PATH="$fakebin:$original_path"
export PATH
REAL_GIT="$real_git"
FAKE_GIT_LOG="$git_log"
export REAL_GIT FAKE_GIT_LOG
run_update "$s" --repo --dev
PATH="$original_path"
export PATH
assert_eq "$RUN_STATUS" "0" "clone matrix completes"
assert_file_contains "$git_log" "clone|clone|--quiet|--depth|1|https://github.com/owner/public-shallow.git|$s/clones/public|" "public shallow clone uses HTTPS and depth 1"
assert_file_contains "$git_log" "set-url|remote|set-url|--push|origin|git@github.com:owner/public-shallow.git|" "public clone sets an SSH push URL"
assert_file_contains "$git_log" "clone|clone|--quiet|git@github.com:owner/private-full.git|$s/clones/private|" "private full clone uses SSH without a depth option"
assert_file_contains "$git_log" "ls-remote|ls-remote|https://github.com/owner/auto-public.git|HEAD|" "auto access probes HTTPS"
assert_file_contains "$git_log" "clone|clone|--quiet|https://github.com/owner/auto-public.git|$s/clones/auto-public|" "auto public global-full clone uses HTTPS without a depth option"
assert_file_contains "$git_log" "clone|clone|--quiet|--depth|1|git@github.com:owner/auto-private.git|$s/clones/auto-private|" "failed auto probe falls back to shallow SSH clone"

start_case "full, repo-only, and link-only modes keep their boundaries"
s=$(new_sandbox modes)
printf '%s\n' '- clean: []' > "$s/install.conf.yaml"
printf '%s\n' 'REPOS=()' > "$s/repos.conf"
install_fake_dotbot "$s"
dotbot_log="$s/dotbot.log"
: > "$dotbot_log"
DOTBOT_LOG="$dotbot_log"
export DOTBOT_LOG
run_update "$s"
assert_eq "$RUN_STATUS" "0" "full mode succeeds"
assert_contains "$RUN_OUTPUT" "Updating dotfiles repos" "full mode performs repo work"
assert_file_contains "$dotbot_log" "cwd=$s" "full mode runs Dotbot"
: > "$dotbot_log"
run_update "$s" --repo -- --ignored-dotbot-arg
assert_eq "$RUN_STATUS" "0" "repo-only mode succeeds"
if [ ! -s "$dotbot_log" ]; then
  pass "repo-only mode skips Dotbot"
else
  fail "repo-only mode skips Dotbot"
fi
plain=$(new_plain_sandbox link-only)
printf '%s\n' '- clean: []' > "$plain/install.conf.yaml"
install_fake_dotbot "$plain"
dotbot_log="$plain/dotbot.log"
: > "$dotbot_log"
DOTBOT_LOG="$dotbot_log"
export DOTBOT_LOG
run_update "$plain" --link
assert_eq "$RUN_STATUS" "0" "link-only mode succeeds outside a Git repository"
assert_not_contains "$RUN_OUTPUT" "Updating dotfiles repos" "link-only mode skips repo work"
assert_file_contains "$dotbot_log" "cwd=$plain" "link-only mode runs Dotbot"
if [ ! -e "$plain/repos.conf" ]; then
  pass "link-only mode does not create repos.conf"
else
  fail "link-only mode does not create repos.conf"
fi

start_case "additional Dotbot configs are discovered in REPOS order"
s=$(new_plain_sandbox dotbot-order)
mkdir -p "$s/first" "$s/without-config" "$s/second"
printf '%s\n' '- clean: []' > "$s/install.conf.yaml"
printf '%s\n' '- clean: []' > "$s/first/install.conf.yaml"
printf '%s\n' '- clean: []' > "$s/second/install.conf.yaml"
write_repos "$s" \
  "owner/first first public shallow" \
  "owner/without-config without-config public shallow" \
  "owner/second second private full"
install_fake_dotbot "$s"
dotbot_log="$s/dotbot.log"
: > "$dotbot_log"
DOTBOT_LOG="$dotbot_log"
export DOTBOT_LOG
run_update "$s" --link -- --verbose "two words"
expected_log="cwd=$s <-d> <$s> <-c> <install.conf.yaml> <--verbose> <two words>
cwd=$s/first <-d> <$s/first> <-c> <install.conf.yaml> <--verbose> <two words>
cwd=$s/second <-d> <$s/second> <-c> <install.conf.yaml> <--verbose> <two words>"
actual_log=$(command cat "$dotbot_log")
assert_eq "$RUN_STATUS" "0" "multi-config link-only run succeeds"
assert_eq "$actual_log" "$expected_log" "readable Dotbot configs run in REPOS order with shared args"
assert_not_contains "$actual_log" "without-config" "additional repos without a config are skipped"
assert_contains "$RUN_OUTPUT" "Processing dotfiles with Dotbot" "main Dotbot heading is named"
assert_contains "$RUN_OUTPUT" "Processing first with Dotbot" "additional Dotbot heading uses repo basename"

start_case "Dotbot failure propagates and stops later configs"
s=$(new_plain_sandbox dotbot-failure)
mkdir -p "$s/first" "$s/second"
printf '%s\n' '- clean: []' > "$s/install.conf.yaml"
printf '%s\n' '- clean: []' > "$s/first/install.conf.yaml"
printf '%s\n' '- clean: []' > "$s/second/install.conf.yaml"
write_repos "$s" \
  "owner/first first public shallow" \
  "owner/second second public shallow"
install_fake_dotbot "$s"
dotbot_log="$s/dotbot.log"
: > "$dotbot_log"
DOTBOT_LOG="$dotbot_log"
DOTBOT_FAIL_DIR="$s/first"
DOTBOT_FAIL_STATUS=7
export DOTBOT_LOG DOTBOT_FAIL_DIR DOTBOT_FAIL_STATUS
run_update "$s" --link
unset DOTBOT_FAIL_DIR DOTBOT_FAIL_STATUS
assert_eq "$RUN_STATUS" "7" "Dotbot failure status is propagated"
assert_file_contains "$dotbot_log" "cwd=$s/first" "failing additional config runs"
assert_not_contains "$(command cat "$dotbot_log")" "cwd=$s/second" "configs after a Dotbot failure do not run"

printf '\n=== update regression summary: %s passed, %s failed ===\n' "$passes" "$failures"
if [ "$failures" -gt 0 ]; then
  exit 1
fi
