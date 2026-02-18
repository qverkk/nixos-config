#!/usr/bin/env bash
set -euo pipefail

API_URL="https://windsurf-stable.codeium.com/api/update/linux-x64/stable/latest"
DEFAULT_NIX="$(dirname "$0")/default.nix"

# Fetch latest version info
echo "Fetching latest version from API..."
LATEST_INFO=$(curl -s "$API_URL")

# Extract fields from JSON response
LATEST_VERSION=$(echo "$LATEST_INFO" | jq -r '.windsurfVersion')
LATEST_URL=$(echo "$LATEST_INFO" | jq -r '.url')

# Get current version from default.nix
CURRENT_VERSION=$(grep -E '^\s*version\s*=' "$DEFAULT_NIX" | sed -E "s/.*version\s*=\s*\"([^\"]+)\".*/\1/")

echo "Current version: $CURRENT_VERSION"
echo "Latest version:  $LATEST_VERSION"

# Check if update is needed
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "✓ Windsurf is already up to date (version $CURRENT_VERSION)"
    exit 0
fi

# Compute hash for the new URL
echo "Computing hash for new version..."
LATEST_SHA256_SRI=$(nix-prefetch-url "$LATEST_URL" 2>/dev/null | xargs nix hash convert --hash-algo sha256)

if [ -z "$LATEST_SHA256_SRI" ]; then
    echo "Error: Failed to compute hash" >&2
    exit 1
fi

echo "New hash: $LATEST_SHA256_SRI"
echo "Updating to version $LATEST_VERSION..."

# Update version
sed -i "s/version = \"[^\"]*\"/version = \"$LATEST_VERSION\"/" "$DEFAULT_NIX"

# Update URL
sed -i "s|url = \"https://[^\"]*\"|url = \"$LATEST_URL\"|" "$DEFAULT_NIX"

# Update sha256
sed -i "s|sha256 = \"sha256-[^\"]*\"|sha256 = \"$LATEST_SHA256_SRI\"|" "$DEFAULT_NIX"

echo "✓ Successfully updated to version $LATEST_VERSION"
echo "  URL: $LATEST_URL"
echo "  SHA256: $LATEST_SHA256_SRI"

