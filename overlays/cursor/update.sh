#!/usr/bin/env sh

set -e

VERSION_HISTORY_URL="https://raw.githubusercontent.com/oslook/cursor-ai-downloads/main/version-history.json"
DEFAULT_NIX="$(dirname "$0")/default.nix"

# Fetch version history
echo "Fetching latest version information..."
VERSION_JSON=$(curl -s "$VERSION_HISTORY_URL")

# Extract latest version and URL
LATEST_VERSION=$(echo "$VERSION_JSON" | grep -o '"version": "[^"]*"' | head -1 | cut -d'"' -f4)
LATEST_URL=$(echo "$VERSION_JSON" | grep -o '"linux-x64": "[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$LATEST_VERSION" ] || [ -z "$LATEST_URL" ]; then
  echo "Error: Failed to extract version or URL from version history" >&2
  exit 1
fi

# Get current version from default.nix
CURRENT_VERSION=$(grep -E '^\s*version\s*=' "$DEFAULT_NIX" | sed -E 's/.*version\s*=\s*"([^"]+)";.*/\1/')

if [ -z "$CURRENT_VERSION" ]; then
  echo "Error: Failed to extract current version from default.nix" >&2
  exit 1
fi

echo "Current version: $CURRENT_VERSION"
echo "Latest version:  $LATEST_VERSION"

# Check if we're up to date
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "Already up to date!"
  exit 0
fi

# Compute hash for the new URL
echo "Computing hash for new version..."
HASH=$(nix-prefetch-url "$LATEST_URL" 2>/dev/null | xargs nix-hash --to-sri --type sha256)

if [ -z "$HASH" ]; then
  echo "Error: Failed to compute hash" >&2
  exit 1
fi

echo "New hash: $HASH"

# Update default.nix
echo "Updating default.nix..."

# Update version
sed -i "s/version = \"$CURRENT_VERSION\";/version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"

# Update URL - find the line and replace the URL between quotes
# Using awk for more reliable string handling
awk -v new_url="$LATEST_URL" '
  /^[[:space:]]*url[[:space:]]*=/ {
    sub(/"[^"]*"/, "\"" new_url "\"")
  }
  { print }
' "$DEFAULT_NIX" > "$DEFAULT_NIX.tmp" && mv "$DEFAULT_NIX.tmp" "$DEFAULT_NIX"

# Update hash - find the line and replace the hash between quotes
awk -v new_hash="$HASH" '
  /^[[:space:]]*hash[[:space:]]*=/ {
    sub(/"[^"]*"/, "\"" new_hash "\"")
  }
  { print }
' "$DEFAULT_NIX" > "$DEFAULT_NIX.tmp" && mv "$DEFAULT_NIX.tmp" "$DEFAULT_NIX"

echo "Successfully updated to version $LATEST_VERSION"
