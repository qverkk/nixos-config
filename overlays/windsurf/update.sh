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
LATEST_SHA256_HEX=$(echo "$LATEST_INFO" | jq -r '.sha256hash')

ARCHIVE_NAME="${LATEST_URL##*/}"
PRODUCT_NAME="${ARCHIVE_NAME%%-linux-*}"
case "$PRODUCT_NAME" in
    Devin)
        SOURCE_ROOT="Devin"
        SOURCE_EXECUTABLE_NAME="devin-desktop"
        LONG_NAME="Devin"
        SHORT_NAME="devin-desktop"
        ;;
    Windsurf)
        SOURCE_ROOT="Windsurf"
        SOURCE_EXECUTABLE_NAME="windsurf"
        LONG_NAME="Windsurf"
        SHORT_NAME="windsurf"
        ;;
    *)
        echo "Error: Unsupported archive product: $PRODUCT_NAME" >&2
        exit 1
        ;;
esac

# Get current version from default.nix
CURRENT_VERSION=$(grep -E '^\s*version\s*=' "$DEFAULT_NIX" | sed -E "s/.*version\s*=\s*\"([^\"]+)\".*/\1/")
CURRENT_URL=$(grep -E '^\s*url\s*=' "$DEFAULT_NIX" | sed -E "s|.*url\s*=\s*\"([^\"]+)\".*|\1|")
CURRENT_SOURCE_ROOT=$(grep -E '^\s*sourceRoot\s*=' "$DEFAULT_NIX" | sed -E "s/.*sourceRoot\s*=\s*\"([^\"]+)\".*/\1/")
CURRENT_SOURCE_EXECUTABLE_NAME=$(grep -E '^\s*sourceExecutableName\s*=' "$DEFAULT_NIX" | sed -E "s/.*sourceExecutableName\s*=\s*\"([^\"]+)\".*/\1/" || true)
CURRENT_LONG_NAME=$(grep -E '^\s*longName\s*=' "$DEFAULT_NIX" | sed -E "s/.*longName\s*=\s*\"([^\"]+)\".*/\1/")
CURRENT_SHORT_NAME=$(grep -E '^\s*shortName\s*=' "$DEFAULT_NIX" | sed -E "s/.*shortName\s*=\s*\"([^\"]+)\".*/\1/")

echo "Current version: $CURRENT_VERSION"
echo "Latest version:  $LATEST_VERSION"

# Check if update is needed
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ] \
    && [ "$CURRENT_URL" = "$LATEST_URL" ] \
    && [ "$CURRENT_SOURCE_ROOT" = "$SOURCE_ROOT" ] \
    && [ "$CURRENT_SOURCE_EXECUTABLE_NAME" = "$SOURCE_EXECUTABLE_NAME" ] \
    && [ "$CURRENT_LONG_NAME" = "$LONG_NAME" ] \
    && [ "$CURRENT_SHORT_NAME" = "$SHORT_NAME" ]; then
    echo "✓ Windsurf is already up to date (version $CURRENT_VERSION)"
    exit 0
fi

# Convert API-provided hash to Nix SRI format.
echo "Computing hash for new version..."
LATEST_SHA256_SRI=$(nix hash convert --hash-algo sha256 --to sri "$LATEST_SHA256_HEX")

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

# Update product-specific archive metadata
if grep -q 'sourceExecutableName = ' "$DEFAULT_NIX"; then
    sed -i "s|sourceExecutableName = \"[^\"]*\"|sourceExecutableName = \"$SOURCE_EXECUTABLE_NAME\"|" "$DEFAULT_NIX"
else
    sed -i "/executableName = /a\\  sourceExecutableName = \"$SOURCE_EXECUTABLE_NAME\";" "$DEFAULT_NIX"
fi
sed -i "s|longName = \"[^\"]*\"|longName = \"$LONG_NAME\"|" "$DEFAULT_NIX"
sed -i "s|shortName = \"[^\"]*\"|shortName = \"$SHORT_NAME\"|" "$DEFAULT_NIX"
sed -i "s|sourceRoot = \"[^\"]*\"|sourceRoot = \"$SOURCE_ROOT\"|" "$DEFAULT_NIX"

echo "✓ Successfully updated to version $LATEST_VERSION"
echo "  URL: $LATEST_URL"
echo "  SHA256: $LATEST_SHA256_SRI"
echo "  Source root: $SOURCE_ROOT"
echo "  Source executable: $SOURCE_EXECUTABLE_NAME"
