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

# Convert hex hash to Nix SRI format
# The API returns hex, we need to convert to base64 for Nix SRI format
# Method: hex -> binary -> base64 -> SRI format (replace + with -, / with _, remove padding)
if command -v python3 &> /dev/null; then
    LATEST_SHA256_SRI=$(python3 -c "import base64; h=bytes.fromhex('$LATEST_SHA256_HEX'); b64=base64.b64encode(h).decode('ascii'); print('sha256-' + b64.replace('+', '-').replace('/', '_').rstrip('='))")
elif command -v nix &> /dev/null && nix hash to-sri --type sha256 --help &>/dev/null; then
    # Use nix hash to-sri (most reliable on NixOS)
    # Convert hex string to binary, pipe to nix hash to-sri
    HEX_ESCAPED=$(printf "%s" "$LATEST_SHA256_HEX" | sed 's/\(..\)/\\x\1/g')
    LATEST_SHA256_SRI=$(printf "%b" "$HEX_ESCAPED" | nix hash to-sri --type sha256 2>/dev/null || echo "")
fi

if [ -z "$LATEST_SHA256_SRI" ]; then
    # Fallback: pure bash solution - convert hex to binary using printf, then base64
    # Convert each pair of hex digits to \x escape sequence, then use printf %b to interpret
    if command -v base64 &> /dev/null; then
        HEX_ESCAPED=$(printf "%s" "$LATEST_SHA256_HEX" | sed 's/\(..\)/\\x\1/g')
        LATEST_SHA256_B64=$(printf "%b" "$HEX_ESCAPED" | base64 -w 0 2>/dev/null | sed 's/+/-/g; s/\//_/g; s/=//g' || echo "")
        LATEST_SHA256_SRI="sha256-$LATEST_SHA256_B64"
    else
        echo "Error: Need python3, nix, or base64 to convert hash format" >&2
        exit 1
    fi
fi

# Get current version from default.nix
CURRENT_VERSION=$(grep -E '^\s*version\s*=' "$DEFAULT_NIX" | sed -E "s/.*version\s*=\s*\"([^\"]+)\".*/\1/")

echo "Current version: $CURRENT_VERSION"
echo "Latest version:  $LATEST_VERSION"

# Check if update is needed
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "✓ Windsurf is already up to date (version $CURRENT_VERSION)"
    exit 0
fi

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

