#!/usr/bin/env bash
# install.sh — Install Big Top into a beads-tracking repository.
#
# Downloads the latest Big Top release tarball and copies example
# workflows into the target repo's .github/workflows/ directory.
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/nicholasspencer/big-top/main/scripts/install.sh | bash
#   # or, from a local clone:
#   ./scripts/install.sh /path/to/beads-tracking-repo
set -euo pipefail

BIG_TOP_REPO="nicholasspencer/big-top"
RAW_BASE="https://raw.githubusercontent.com/${BIG_TOP_REPO}/main"

# Target repo is the first argument, or current directory
TARGET="${1:-.}"

if [ ! -d "$TARGET/.git" ]; then
  echo "Error: $TARGET is not a git repository." >&2
  exit 1
fi

echo "Installing Big Top into: $TARGET"

# --- 1. Copy example workflows ---
mkdir -p "$TARGET/.github/workflows"

EXAMPLES=(
  "deploy-gh-pages.yml"
  "beads-export.yml"
  "beads-write.yml"
)

for file in "${EXAMPLES[@]}"; do
  echo "  Copying $file ..."
  if [ -f "examples/$file" ]; then
    # Local clone — copy directly
    cp "examples/$file" "$TARGET/.github/workflows/$file"
  else
    # Remote — download from GitHub
    curl -sL "${RAW_BASE}/examples/$file" -o "$TARGET/.github/workflows/$file"
  fi
done

# --- 2. Set up data/ directory ---
mkdir -p "$TARGET/data"

if [ ! -f "$TARGET/data/.gitkeep" ]; then
  touch "$TARGET/data/.gitkeep"
  echo "  Created data/ directory with .gitkeep"
fi

# --- 3. Download latest release tarball (optional, for local preview) ---
echo ""
echo "Checking for latest Big Top release..."

TARBALL_URL=$(gh api "repos/${BIG_TOP_REPO}/releases/latest" \
  --jq '.assets[] | select(.name | startswith("big-top-web-")) | .browser_download_url' \
  2>/dev/null) || true

if [ -n "$TARBALL_URL" ]; then
  mkdir -p "$TARGET/_site"
  curl -sL "$TARBALL_URL" | tar -xzf - -C "$TARGET/_site"
  echo "  Downloaded latest release to $TARGET/_site/"
  echo "  Serve locally: cd $TARGET/_site && python3 -m http.server 8080"
else
  echo "  No release found (the deploy workflow will build from source on first run)."
fi

echo ""
echo "Done! Next steps:"
echo "  1. Edit .github/workflows/deploy-gh-pages.yml — set REPO_NAME to your repo name"
echo "  2. Enable GitHub Pages (Settings > Pages > Source: GitHub Actions)"
echo "  3. Push to main to trigger the first deploy"
