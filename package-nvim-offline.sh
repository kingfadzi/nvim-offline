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
# ==========================================================================

VERSION="${1:-$(date +%Y%m%d)}"
OUTFILE="nvim-offline-${VERSION}.tar.gz"

log() { printf '[package] %s\n' "$*"; }
die() { printf '[package] ERROR: %s\n' "$*" >&2; exit 1; }

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
log "============================================"
log " Package complete!"
log "============================================"
log ""
log "  File:    $OUTFILE"
log "  Size:    $SIZE"
log "  Nvim:    $NVIM_VER"
log "  Plugins: $PLUGIN_COUNT"
log ""
log "Next steps:"
log "  1. Upload $OUTFILE as a GitHub Release asset"
log "  2. On the airgapped WSL machine, download the release"
log "  3. Run: bash install-nvim-offline.sh $OUTFILE"
