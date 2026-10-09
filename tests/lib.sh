# shellcheck shell=bash
# Minimal assertion helpers for the dotfiles bash tests.
FAILS=0

assert_eq() {
  if [[ "$1" == "$2" ]]; then
    echo "ok   - $3"
  else
    echo "FAIL - $3"
    echo "       expected: $(printf '%q' "$1")"
    echo "       actual:   $(printf '%q' "$2")"
    FAILS=$((FAILS + 1))
  fi
}

assert_contains() {
  if [[ "$1" == *"$2"* ]]; then
    echo "ok   - $3"
  else
    echo "FAIL - $3"
    echo "       $(printf '%q' "$1") does not contain $(printf '%q' "$2")"
    FAILS=$((FAILS + 1))
  fi
}

finish() {
  if ((FAILS > 0)); then
    echo "$FAILS test(s) failed"
    exit 1
  fi
  echo "all tests passed"
}
