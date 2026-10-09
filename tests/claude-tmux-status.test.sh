#!/usr/bin/env bash
# Tests for tools/tools/claude-tmux-status against an isolated tmux server.
set -u
cd "$(dirname "$0")/.." || exit 1
# shellcheck source=tests/lib.sh
source tests/lib.sh

HOOK="$PWD/tools/tools/claude-tmux-status"
SOCK_NAME="claude-picker-test"
T() { tmux -L "$SOCK_NAME" "$@"; }

T kill-server 2>/dev/null
T -f /dev/null new-session -d -s hooktest
trap 'T kill-server 2>/dev/null' EXIT
SOCKET="$(T display-message -p '#{socket_path}')"
PANE="$(T display-message -p -t hooktest '#{pane_id}')"
status() { T show-options -p -v -t "$PANE" @claude_status 2>/dev/null; }
run_hook() { TMUX="$SOCKET,0,0" TMUX_PANE="$PANE" "$HOOK" "$@" </dev/null; }

out="$(run_hook working)"; rc=$?
assert_eq "0" "$rc" "working: exit 0"
assert_eq "" "$out" "working: no output"
assert_eq "working" "$(status)" "working: option set"

run_hook waiting
assert_eq "waiting" "$(status)" "waiting: option set"

run_hook "done"
assert_eq "done" "$(status)" "done: option set"

run_hook bogus; rc=$?
assert_eq "0" "$rc" "unknown state: exit 0"
assert_eq "done" "$(status)" "unknown state: option unchanged"

run_hook clear
assert_eq "" "$(status)" "clear: option removed"

out="$(echo '{"hook_event_name":"Stop"}' | TMUX="$SOCKET,0,0" TMUX_PANE="$PANE" "$HOOK" "done")"; rc=$?
assert_eq "0" "$rc" "stdin json: exit 0"
assert_eq "" "$out" "stdin json: no output"
assert_eq "done" "$(status)" "stdin json: option set"

out="$(env -u TMUX -u TMUX_PANE "$HOOK" working </dev/null)"; rc=$?
assert_eq "0" "$rc" "outside tmux: exit 0"
assert_eq "" "$out" "outside tmux: no output"

out="$(TMUX="$SOCKET,0,0" TMUX_PANE="%999" "$HOOK" working </dev/null 2>&1)"; rc=$?
assert_eq "0" "$rc" "dead pane: exit 0"
assert_eq "" "$out" "dead pane: no output"

finish
