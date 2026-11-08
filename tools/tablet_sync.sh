#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

REPO_URL="https://github.com/BleakNarratives/RepoSherpa.git"
TARGET="${1:-"$HOME/RepoSherpa"}"

case "$TARGET" in
  /*) ;;
  *) TARGET="$PWD/$TARGET" ;;
esac

say() { printf '\n[RepoSherpa] %s\n' "$*"; }
fail() { printf '\n[RepoSherpa] STOP: %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || fail "Git is not installed. In Termux run: pkg install git"
command -v bash >/dev/null 2>&1 || fail "Bash is not available."

if [ -e "$TARGET" ]; then
  [ -d "$TARGET" ] || fail "Target exists but is not a directory: $TARGET"

  if [ ! -d "$TARGET/.git" ]; then
    [ -z "$(ls -A "$TARGET" 2>/dev/null)" ] || fail "Target exists and contains files but is not a Git checkout. Nothing was changed."
    rmdir "$TARGET"
  fi
fi

if [ ! -d "$TARGET/.git" ]; then
  mkdir -p "$(dirname "$TARGET")"
  say "Creating a complete clone at $TARGET"
  git clone --recurse-submodules "$REPO_URL" "$TARGET"
fi

cd "$TARGET"

ACTUAL_REMOTE="$(git remote get-url origin 2>/dev/null || true)"
case "$ACTUAL_REMOTE" in
  "$REPO_URL"|"https://github.com/BleakNarratives/RepoSherpa"|"git@github.com:BleakNarratives/RepoSherpa.git") ;;
  *) fail "This folder's origin is '$ACTUAL_REMOTE', not the RepoSherpa repository. Nothing was changed." ;;
esac

if [ -n "$(git status --porcelain)" ]; then
  fail "Local changes or untracked files exist. They were preserved. Review/commit/stash them before syncing."
fi

say "Fetching current repository state"
git fetch --prune origin

git show-ref --verify --quiet refs/remotes/origin/main || fail "origin/main was not found."

if git show-ref --verify --quiet refs/heads/main; then
  git switch main
  git merge --ff-only origin/main || fail "Local main cannot be fast-forwarded safely. No local work was discarded."
else
  git switch --track -c main origin/main
fi

say "Synchronizing any declared submodules"
git submodule sync --recursive
git submodule update --init --recursive

LOCAL_SHA="$(git rev-parse HEAD)"
REMOTE_SHA="$(git rev-parse origin/main)"
[ "$LOCAL_SHA" = "$REMOTE_SHA" ] || fail "Local and remote main commits do not match."

[ -z "$(git status --porcelain)" ] || fail "Working tree is not clean after sync; inspect it before proceeding."

say "SYNC VERIFIED"
printf 'Repository: %s\nBranch:     %s\nCommit:     %s\nFiles:      %s\nLocation:   %s\n' \
  "$REPO_URL" "$(git branch --show-current)" "$LOCAL_SHA" "$(git ls-files | wc -l | tr -d ' ')" "$TARGET"
printf '\nThis is the latest complete tracked main-branch checkout. No local changes were overwritten.\n'
