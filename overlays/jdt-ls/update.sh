#!/usr/bin/env sh

set -e

MILESTONES_URL="https://download.eclipse.org/jdtls/milestones/"
DEFAULT_NIX="$(dirname "$0")/default.nix"

echo "Fetching latest version information..."

# Fetch the milestones directory listing and extract all version directories
VERSIONS=$(curl -s "$MILESTONES_URL" | grep -oE "href='/jdtls/milestones/[0-9]+\.[0-9]+\.[0-9]+'" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | uniq)

if [ -z "$VERSIONS" ]; then
  echo "Error: Failed to extract versions from milestones page" >&2
  exit 1
fi

LATEST_VERSION=$(echo "$VERSIONS" | tail -1)

if [ -z "$LATEST_VERSION" ]; then
  echo "Error: Failed to determine latest version" >&2
  exit 1
fi

# Fetch the filename from latest.txt (contains the timestamp)
LATEST_TXT_URL="$MILESTONES_URL$LATEST_VERSION/latest.txt"
LATEST_FILENAME=$(curl -s "$LATEST_TXT_URL" | tr -d '[:space:]')

if [ -z "$LATEST_FILENAME" ]; then
  echo "Error: Failed to fetch latest.txt for version $LATEST_VERSION" >&2
  exit 1
fi

# Extract timestamp from filename: jdt-language-server-<version>-<timestamp>.tar.gz
LATEST_TIMESTAMP=$(echo "$LATEST_FILENAME" | sed -E "s/jdt-language-server-${LATEST_VERSION}-([0-9]+)\.tar\.gz/\1/")

if [ -z "$LATEST_TIMESTAMP" ] || [ "$LATEST_TIMESTAMP" = "$LATEST_FILENAME" ]; then
  echo "Error: Failed to extract timestamp from filename: $LATEST_FILENAME" >&2
  exit 1
fi

LATEST_URL="https://download.eclipse.org/jdtls/milestones/${LATEST_VERSION}/${LATEST_FILENAME}"

# Get current version from default.nix
CURRENT_VERSION=$(grep -E '^\s*version\s*=' "$DEFAULT_NIX" | sed -E 's/.*version\s*=\s*"([^"]+)";.*/\1/')

if [ -z "$CURRENT_VERSION" ]; then
  echo "Error: Failed to extract current version from default.nix" >&2
  exit 1
fi

echo "Current version: $CURRENT_VERSION"
echo "Latest version:  $LATEST_VERSION"
echo "Latest timestamp: $LATEST_TIMESTAMP"

# Check if we're up to date
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "Already up to date!"
  exit 0
fi

# Compute hash for the new tarball
echo "Computing hash for new version..."
HASH=$(nix-prefetch-url "$LATEST_URL" 2>/dev/null | xargs nix hash convert --hash-algo sha256)

if [ -z "$HASH" ]; then
  echo "Error: Failed to compute hash" >&2
  exit 1
fi

echo "New hash: $HASH"

# Update default.nix
echo "Updating default.nix..."

# Update version
sed -i "s/version = \"$CURRENT_VERSION\";/version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"

# Update timestamp
CURRENT_TIMESTAMP=$(grep -E '^\s*timestamp\s*=' "$DEFAULT_NIX" | sed -E 's/.*timestamp\s*=\s*"([^"]+)";.*/\1/')
sed -i "s/timestamp = \"$CURRENT_TIMESTAMP\";/timestamp = \"$LATEST_TIMESTAMP\";/" "$DEFAULT_NIX"

# Update URL
awk -v new_url="$LATEST_URL" '
  /^\s*url\s*=\s*"https:\/\/(www\.eclipse\.org|download\.eclipse\.org)/ {
    sub(/"[^"]*"/, "\"" new_url "\"")
  }
  { print }
' "$DEFAULT_NIX" > "$DEFAULT_NIX.tmp" && mv "$DEFAULT_NIX.tmp" "$DEFAULT_NIX"

# Update sha256 hash
awk -v new_hash="$HASH" '
  /^\s*sha256\s*=/ {
    sub(/"[^"]*"/, "\"" new_hash "\"")
  }
  { print }
' "$DEFAULT_NIX" > "$DEFAULT_NIX.tmp" && mv "$DEFAULT_NIX.tmp" "$DEFAULT_NIX"

echo "Successfully updated to version $LATEST_VERSION (timestamp: $LATEST_TIMESTAMP)"
