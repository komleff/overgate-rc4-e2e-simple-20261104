#!/usr/bin/env bash
# Проверки проекта overgate-rc4-e2e-simple-20261104: README непустой; install-state привязан к точному source SHA, режиму auto и beads=true.
set -euo pipefail
cd "$(dirname "$0")/../.."
py -3 - <<'PY'
import json, os, sys
EXPECTED_SHA = "2343df83a3a26ae83bc66d4009dd67a913eeea4e"
failures = []
readme = "README.md"
if not os.path.isfile(readme):
    failures.append("README.md missing")
elif os.path.getsize(readme) == 0:
    failures.append("README.md empty")
state_path = os.path.join(".overgate", "install-state.json")
try:
    with open(state_path, "r", encoding="utf-8") as fh:
        state = json.load(fh)
except (OSError, ValueError) as exc:
    failures.append(f"{state_path} unreadable: {exc}")
    state = {}
sha = state.get("source_sha")
mode = state.get("mode")
beads = state.get("beads")
if sha != EXPECTED_SHA:
    failures.append(f"source_sha {sha!r} != {EXPECTED_SHA}")
if mode != "auto":
    failures.append(f"mode {mode!r} != auto")
# Строгая проверка типа: допустим только bool True, а не 1 или строка
if beads is not True:
    failures.append(f"beads {beads!r} is not bool True")
if failures:
    for f in failures:
        print("FAIL: " + f, file=sys.stderr)
    sys.exit(1)
print("OK: README.md non-empty; install-state source_sha=" + EXPECTED_SHA + " mode=auto beads=True")
PY
