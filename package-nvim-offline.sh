#!/usr/bin/env bash
set -euo pipefail

# ==========================================================================
# package-nvim-offline.sh
#
# Run this on the AlmaLinux 9 build machine AFTER:
#   1. Running ./install_nvim  (full online installer)
#   2. Launching nvim and waiting for all plugins to install
#   3. Quitting nvim, then running nvim again to confirm everything is clean
#
# Produces a single tarball containing:
#   - Neovim binary (extracted AppImage)
#   - LazyVim config + custom plugin specs
#   - All lazy.nvim plugins (pre-downloaded)
#   - Mason-installed LSPs, formatters, linters
#   - Treesitter parsers (compiled .so files)
#   - Lazy state/lockfile
#
# Usage:
#   bash package-nvim-offline.sh [version-tag]
#   e.g. bash package-nvim-offline.sh v1.0.0
#
# Requires:
#   - GITHUB_API_TOKEN env var (GitHub PAT with repo scope)
#   - curl
# ==========================================================================

GITHUB_REPO="kingfadzi/nvim-offline"
VERSION="${1:-$(date +%Y%m%d)}"
OUTFILE="nvim-offline-${VERSION}.tar.gz"

log() { printf '[package] %s\n' "$*"; }
die() { printf '[package] ERROR: %s\n' "$*" >&2; exit 1; }

[[ -n "${GITHUB_API_TOKEN:-}" ]] || die "GITHUB_API_TOKEN env var not set"

# Directories to bundle (relative to $HOME)
DIRS=(
  "opt/nvim/squashfs-root"
  ".config/nvim"
  ".local/share/nvim"
  ".local/state/nvim"
)

# --- Preflight checks ---

log "Verifying build artifacts exist..."

for d in "${DIRS[@]}"; do
  if [[ ! -d "${HOME}/${d}" ]]; then
    die "${HOME}/${d} not found. Run the full installer and launch nvim first."
  fi
  log "  OK: ~/${d}"
done

NVIM_BIN="${HOME}/opt/nvim/squashfs-root/usr/bin/nvim"
[[ -x "$NVIM_BIN" ]] || die "nvim binary not executable at $NVIM_BIN"

# Quick sanity checks on plugin state
LAZY_DIR="${HOME}/.local/share/nvim/lazy"
[[ -d "$LAZY_DIR" ]] || die "No lazy plugin directory found. Launch nvim first to install plugins."

PLUGIN_COUNT="$(ls -1d "${LAZY_DIR}"/*/ 2>/dev/null | wc -l)"
log "  Found ${PLUGIN_COUNT} lazy plugins"
[[ "$PLUGIN_COUNT" -gt 5 ]] || die "Only ${PLUGIN_COUNT} plugins found — expected more. Did you launch nvim and let it finish?"

if [[ -d "${HOME}/.local/share/nvim/mason" ]]; then
  MASON_COUNT="$(ls -1d "${HOME}/.local/share/nvim/mason/packages"/*/ 2>/dev/null | wc -l)"
  log "  Found ${MASON_COUNT} mason packages"
else
  log "  WARNING: No mason directory found. Mason tools won't be included."
fi

# Show nvim version being packaged
NVIM_VER="$("$NVIM_BIN" --version | head -1)"
log "  Neovim version: $NVIM_VER"

# --- Build tarball ---

log "Creating tarball: $OUTFILE"
log "This may take a minute..."

tar czf "$OUTFILE" \
  -C "$HOME" \
  "${DIRS[@]}"

SIZE="$(du -h "$OUTFILE" | cut -f1)"

log ""
log "  File:    $OUTFILE"
log "  Size:    $SIZE"
log "  Nvim:    $NVIM_VER"
log "  Plugins: $PLUGIN_COUNT"

# --- Create GitHub Release ---

log ""
log "Creating GitHub release ${VERSION}..."

# Build JSON payload safely with python3 to avoid escaping issues
RELEASE_JSON="$(python3 -c "
import json, sys
print(json.dumps({
    'tag_name': sys.argv[1],
    'name': f'Neovim Offline Bundle {sys.argv[1]}',
    'body': (
        f'Prebuilt Neovim + LazyVim offline bundle.\n\n'
        f'- {sys.argv[2]}\n'
        f'- {sys.argv[3]} plugins (pre-installed)\n'
        f'- Mason LSPs/formatters included\n'
        f'- Treesitter parsers compiled\n\n'
        f'**Install on airgapped WSL/Linux:**\n'
        f'\`\`\`bash\n'
        f'bash install-nvim-offline.sh {sys.argv[4]}\n'
        f'\`\`\`'
    ),
    'draft': False,
    'prerelease': False
}))
" "$VERSION" "$NVIM_VER" "$PLUGIN_COUNT" "$OUTFILE")"

# Create the release
RELEASE_RESPONSE="$(curl -s -X POST \
  -H "Authorization: token ${GITHUB_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$RELEASE_JSON" \
  "https://api.github.com/repos/${GITHUB_REPO}/releases")"

UPLOAD_URL="$(echo "$RELEASE_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('upload_url','').split('{')[0])" 2>/dev/null || true)"

if [[ -z "$UPLOAD_URL" ]]; then
  log "ERROR creating release. Response:"
  echo "$RELEASE_RESPONSE"
  die "Failed to create GitHub release. Check your token permissions."
fi

log "Release created. Uploading tarball..."

# Upload the tarball as a release asset
UPLOAD_RESPONSE="$(curl -s -X POST \
  -H "Authorization: token ${GITHUB_API_TOKEN}" \
  -H "Content-Type: application/gzip" \
  --data-binary "@${OUTFILE}" \
  "${UPLOAD_URL}?name=${OUTFILE}")"

DOWNLOAD_URL="$(echo "$UPLOAD_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('browser_download_url',''))" 2>/dev/null || true)"

if [[ -z "$DOWNLOAD_URL" ]]; then
  log "ERROR uploading asset. Response:"
  echo "$UPLOAD_RESPONSE"
  die "Failed to upload tarball to release."
fi

log ""
log "============================================"
log " Release published!"
log "============================================"
log ""
log "  Release: https://github.com/${GITHUB_REPO}/releases/tag/${VERSION}"
log "  Download: $DOWNLOAD_URL"
log ""
log "On the airgapped WSL machine:"
log "  1. Download ${OUTFILE} from the release page"
log "  2. Run: bash install-nvim-offline.sh ${OUTFILE}"
