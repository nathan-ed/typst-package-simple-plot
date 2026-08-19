#!/usr/bin/env bash
# Copies the working tree into Typst's local and preview caches under the
# version in typst.toml, so gallery/ and docs/ — which import
# @preview/simple-plot:<version> — compile against the code being released.
set -euo pipefail
cd "$(dirname "$0")/.."
pkg=simple-plot
version=$(awk -F'"' '/^version/ {print $2; exit}' typst.toml)
for dest in "$HOME/.local/share/typst/packages/local/$pkg/$version" \
            "$HOME/.cache/typst/packages/preview/$pkg/$version"; do
  mkdir -p "$dest"
  rsync -a --delete ./ "$dest/" \
    --exclude='.git' --exclude='.claude' --exclude='docs' \
    --exclude='*.pdf' --exclude='tests' --exclude='gallery'
  echo "→ $dest"
done
