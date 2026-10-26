#!/usr/bin/env bash
# Install or update the onboard-student skill in the current repository.
# Run from the host repo's root:
#   bash /path/to/onboard-student/install.sh            (from a local clone)
#   ONBOARD_STUDENT_REF=v1.0.0 bash install.sh          (pin a tag or branch)
# The skill is copied (vendored) into .claude/skills/onboard-student, so the
# host repo works without access to this one. Re-run to update.
set -euo pipefail

REPO_URL="${ONBOARD_STUDENT_REPO:-https://github.com/ipeirotis/onboard-student.git}"
REF="${ONBOARD_STUDENT_REF:-main}"
DEST=".claude/skills/onboard-student"
FILES=(SKILL.md VERSION CHANGELOG.md LICENSE README.md references)

git rev-parse --show-toplevel >/dev/null 2>&1 \
  || { echo "ERROR: run this from the root of a git repository."; exit 1; }
[ "$(git rev-parse --show-toplevel)" = "$(pwd -P)" ] \
  || { echo "ERROR: run this from the repository root."; exit 1; }

STAGE=$(mktemp -d) && [ -n "$STAGE" ] && [ -d "$STAGE" ] \
  || { echo "ERROR: could not create a staging directory; nothing changed."; exit 1; }
trap 'rm -rf "${STAGE:?}"' EXIT

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
if [ -f "$SRC/SKILL.md" ] && [ -z "${ONBOARD_STUDENT_REF:-}" ]; then
  # Run from a local clone: copy that clone's files
  for f in "${FILES[@]}"; do cp -R "$SRC/$f" "$STAGE/"; done
else
  git clone -q --depth 1 --branch "$REF" "$REPO_URL" "$STAGE/src"
  for f in "${FILES[@]}"; do cp -R "$STAGE/src/$f" "$STAGE/"; done
  rm -rf "${STAGE:?}/src"
fi
[ -f "$STAGE/SKILL.md" ] || { echo "ERROR: SKILL.md missing from the source; nothing changed."; exit 1; }

mkdir -p "$(dirname "$DEST")"
rm -rf "${DEST:?}.new"
mv "$STAGE" "$DEST.new"
rm -rf "${DEST:?}"
mv "$DEST.new" "$DEST"
trap - EXIT
echo "Installed onboard-student $(cat "$DEST/VERSION") in $DEST. Commit it to the host repo."
