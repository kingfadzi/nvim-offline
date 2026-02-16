#!/usr/bin/env bash
set -euo pipefail

# ==========================================================================
# install-nvim-offline.sh
#
# Offline installer for airgapped WSL/Linux environments.
# Extracts a prebuilt nvim tarball — no internet required.
#
# Usage:
#   bash install-nvim-offline.sh [nvim-offline-YYYYMMDD.tar.gz]
#
# If no tarball is specified, auto-detects one in the current directory.
# ==========================================================================

log() { printf '[nvim-offline] %s\n' "$*"; }
die() { printf '[nvim-offline] ERROR: %s\n' "$*" >&2; exit 1; }

TARBALL="${1:-}"

# Auto-detect tarball if not provided
if [[ -z "$TARBALL" ]]; then
  TARBALL="$(ls -1 nvim-offline-*.tar.gz 2>/dev/null | sort -V | tail -1 || true)"
  if [[ -z "$TARBALL" ]]; then
    echo "Usage: bash install-nvim-offline.sh <nvim-offline-*.tar.gz>"
    exit 1
  fi
  log "Auto-detected tarball: $TARBALL"
fi

[[ -f "$TARBALL" ]] || die "$TARBALL not found"

BIN_DIR="$HOME/.local/bin"
NVIM_BIN="$HOME/opt/nvim/squashfs-root/usr/bin/nvim"
NVIM_CONFIG="$HOME/.config/nvim"

# --- Back up existing config ---
if [[ -d "$NVIM_CONFIG" ]]; then
  BACKUP="${NVIM_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"
  log "Backing up existing config to $BACKUP"
  mv "$NVIM_CONFIG" "$BACKUP"
fi

# Back up existing nvim data if present
for d in ".local/share/nvim" ".local/state/nvim"; do
  if [[ -d "${HOME}/${d}" ]]; then
    BACKUP="${HOME}/${d}.bak.$(date +%Y%m%d%H%M%S)"
    log "Backing up ~/${d} to ${BACKUP}"
    mv "${HOME}/${d}" "$BACKUP"
  fi
done

# --- Extract ---
log "Extracting $TARBALL to $HOME ..."
tar xzf "$TARBALL" -C "$HOME"

# --- Verify binary ---
[[ -x "$NVIM_BIN" ]] || die "nvim binary not found after extraction at $NVIM_BIN"

# --- Create symlink ---
mkdir -p "$BIN_DIR"
ln -sf "$NVIM_BIN" "$BIN_DIR/nvim"
log "Linked: $BIN_DIR/nvim -> $NVIM_BIN"

# --- Ensure ~/.local/bin is on PATH ---
if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
  SHELL_RC="$HOME/.bashrc"
  # Avoid duplicate entries
  if ! grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' "$SHELL_RC" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    log "Added ~/.local/bin to PATH in $SHELL_RC"
  fi
  export PATH="$BIN_DIR:$PATH"
fi

# --- Verify ---
log "Verifying installation..."
NVIM_VER="$("$BIN_DIR/nvim" --version | head -1)"
log "$NVIM_VER"

PLUGIN_COUNT="$(ls -1d "$HOME/.local/share/nvim/lazy"/*/ 2>/dev/null | wc -l)"

# --- Done ---
log ""
log "============================================"
log " Installation complete!"
log "============================================"
log ""
log "  Neovim:  $NVIM_VER"
log "  Plugins: ${PLUGIN_COUNT} (pre-installed, no internet needed)"
log "  Binary:  $BIN_DIR/nvim"
log "  Config:  $NVIM_CONFIG"
log ""
log "FIRST LAUNCH:"
log "  source ~/.bashrc    # pick up PATH change"
log "  nvim                # everything is pre-installed, should be instant"
log ""
log "AI SETUP:"
log "  Set your Claude API key in ~/.bashrc:"
log "    export ANTHROPIC_API_KEY=\"your-key\""
log "  Then use <leader>aa in nvim to open the AI chat panel"
log ""
log "KEY SHORTCUTS (leader = Space):"
log "  <Space>       Show command palette (which-key)"
log "  <Space>ff     Find files"
log "  <Space>fg     Live grep"
log "  <Space>e      File explorer"
log "  <Space>aa     AI chat (avante)"
log "  <Space>U      Undo tree"
