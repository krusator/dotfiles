#!/usr/bin/env bash
# Tests for tools/tools/claude-picker (list mode).
# The displayed paths contain a literal "~", so quoted tildes are intended.
# shellcheck disable=SC2088
set -u
cd "$(dirname "$0")/.." || exit 1
# shellcheck source=tests/lib.sh
source tests/lib.sh

PICKER="$PWD/tools/tools/claude-picker"
strip_ansi() { sed $'s/\x1b\\[[0-9;]*m//g'; }

# --- Fixture-based tests -------------------------------------------------
out="$(HOME=/Users/me \
  CLAUDE_PICKER_PANES_FILE=tests/fixtures/panes.tsv \
  CLAUDE_PICKER_PS_FILE=tests/fixtures/ps.txt \
  "$PICKER" --list)"; rc=$?
plain="$(printf '%s\n' "$out" | strip_ansi)"
line() { printf '%s\n' "$plain" | grep "^$1"$'\t'; }

assert_eq "0" "$rc" "list: exit 0"
assert_eq "%1 %2 %3 %4 %6" "$(printf '%s\n' "$plain" | cut -f1 | tr '\n' ' ' | sed 's/ $//')" \
  "list: claude panes only, sorted waiting/done/working/unknown then target"

assert_contains "$(line %1)" "󰂞" "waiting icon"
assert_contains "$(line %2)" "󰗠" "done icon"
assert_contains "$(line %3)" "󰒓" "working icon"
assert_contains "$(line %4)" "󰋗" "unknown icon"
assert_contains "$(line %6)" "󰋗" "nested claude detected, unknown icon"

assert_contains "$(line %1)" "work:1.1" "target shown"
assert_contains "$(line %1)" "~/projects/api" "home shortened"
assert_contains "$(line %3)" "my proj:2.1" "session with space"
assert_contains "$(line %3)" "~/my proj" "path with space"
assert_contains "$(line %6)" "/Users/meta/x" "home prefix not shortened for /Users/meta"

assert_contains "$(printf '%s\n' "$out" | grep '^%1')" $'\e[38;2;228;104;118m' "waiting colored red"
assert_contains "$(printf '%s\n' "$out" | grep '^%2')" $'\e[38;2;152;187;108m' "done colored green"
assert_contains "$(printf '%s\n' "$out" | grep '^%3')" $'\e[38;2;230;195;132m' "working colored yellow"
assert_contains "$(printf '%s\n' "$out" | grep '^%4')" $'\e[38;2;114;113;105m' "unknown colored gray"

# --- No instances ---------------------------------------------------------
empty_ps="$(mktemp)"; printf '    1     0 launchd\n  500     1 zsh\n' >"$empty_ps"
out="$(CLAUDE_PICKER_PANES_FILE=tests/fixtures/panes.tsv CLAUDE_PICKER_PS_FILE="$empty_ps" \
  "$PICKER" --list)"; rc=$?
assert_eq "0" "$rc" "no instances: exit 0"
assert_eq "" "$out" "no instances: no output"
rm -f "$empty_ps"

# --- Bad argument ---------------------------------------------------------
"$PICKER" --bogus >/dev/null 2>&1; rc=$?
assert_eq "2" "$rc" "bad argument: exit 2"

# --- Initial focus (origin = "<pane_id>\t<session:window.pane>") ----------
# Sorted fixture order: 1 %1 work:1.1, 2 %2 dotfiles:1.2, 3 %3 my proj:2.1,
# 4 %4 misc:1.1, 5 %6 nested:1.1
focus() {
  CLAUDE_PICKER_ORIGIN="$1" \
    CLAUDE_PICKER_PANES_FILE=tests/fixtures/panes.tsv \
    CLAUDE_PICKER_PS_FILE=tests/fixtures/ps.txt \
    "$PICKER" --focus
}
assert_eq "4" "$(focus $'%4\tmisc:1.1')" "focus: origin pane runs claude"
assert_eq "2" "$(focus $'%99\tdotfiles:1.1')" "focus: claude in same window"
assert_eq "3" "$(focus $'%99\tmy proj:1.1')" "focus: claude in same session, other window"
assert_eq "5" "$(focus $'%99\tnested:3.1')" "focus: same session, last line"
assert_eq "1" "$(focus $'%99\tother:1.1')" "focus: no claude in origin session"
assert_eq "1" "$(focus '')" "focus: no origin (outside tmux)"

# --- Integration against an isolated tmux server --------------------------
SOCK_NAME="claude-picker-test"
T() { tmux -L "$SOCK_NAME" "$@"; }
tmpdir="$(mktemp -d)"
ln -s /bin/sleep "$tmpdir/claude"   # fake claude: ps shows .../claude
T kill-server 2>/dev/null
T -f /dev/null new-session -d -s "fake claude" "$tmpdir/claude 60"
T new-session -d -s plain "/bin/sleep 60"
trap 'T kill-server 2>/dev/null; rm -rf "$tmpdir"' EXIT
SOCKET="$(T display-message -p '#{socket_path}')"
CPANE="$(T display-message -p -t 'fake claude' '#{pane_id}')"
PPANE="$(T display-message -p -t plain '#{pane_id}')"
T set-option -p -t "$CPANE" @claude_status waiting

# TMUX_PANE = the claude pane itself: it must still be listed (popup case).
out="$(TMUX="$SOCKET,0,0" TMUX_PANE="$CPANE" "$PICKER" --list | strip_ansi)"
assert_eq "$CPANE" "$(printf '%s\n' "$out" | cut -f1)" "integration: only fake claude pane listed"
assert_contains "$out" "fake claude:0.0" "integration: target with space"
assert_contains "$out" "󰂞" "integration: status from pane option"
[[ "$out" != *"$PPANE"* ]]; assert_eq "0" "$?" "integration: plain pane not listed"

# fzf starts on the claude of the session the picker was opened from.
# The zeta pane prints a marker; the fzf preview shows it only when focused.
T new-session -d -s zeta -x 160 -y 30 "sh -c 'yes ZETA-MARK | head -40; exec \"$tmpdir/claude\" 60'"
for _ in 1 2 3 4 5 6 7 8 9 10; do
  TMUX="$SOCKET,0,0" "$PICKER" --list | grep -q 'zeta:0.0' && break
  sleep 0.2
done
T new-window -t zeta "$PICKER"
ui=""
for _ in 1 2 3 4 5 6 7 8 9 10; do
  sleep 0.3
  ui="$(T capture-pane -p -t zeta:1)"
  [[ "$ui" == *"ZETA-MARK"* ]] && break
done
assert_contains "$ui" "zeta:0.0" "integration: origin session's claude listed"
assert_contains "$ui" "ZETA-MARK" "integration: fzf cursor starts on origin session's claude"
T send-keys -t zeta:1 Escape

finish
