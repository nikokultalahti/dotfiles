#!/bin/bash
# Bootstrap script for dotfiles managed with chezmoi.
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/nikokultalahti/dotfiles/main/bootstrap.sh)
#
# Features:
#   - Installs Homebrew (macOS and Linux)
#   - Installs chezmoi and bitwarden-cli
#   - Unlocks Bitwarden vault for secrets management
#   - Initializes and applies dotfiles from the repository
#
# Requirements:
#   - sudo access (for Homebrew installation)
#   - Bitwarden CLI must be logged in (bw login) if not already configured

set -euo pipefail

# Configuration
REPO="https://github.com/nikokultalahti/dotfiles.git"

# Logging functions
log() { printf '\033[1;34m[bootstrap]\033[0m %s\n' "$*"; }
error() { printf '\033[1;31m[bootstrap error]\033[0m %s\n' "$*" >&2; exit 1; }

# Request sudo upfront (for Homebrew installation on both Linux and macOS)
log "Requesting sudo access for Homebrew installation..."
sudo -v || error "sudo access required for Homebrew installation."

# Keep sudo alive and gracefully terminate background job on exit
while true; do
  sudo -n true 2>/dev/null || break
  sleep 60
  kill -0 $$ 2>/dev/null || exit
done &
SUDO_PID=$!
trap 'kill "$SUDO_PID" 2>/dev/null || true' EXIT

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    if [[ "$(uname -s)" == "Linux" ]]; then
      local brew_eval='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
      grep -qxF "$brew_eval" "$HOME/.bashrc" 2>/dev/null || echo "$brew_eval" >> "$HOME/.bashrc"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
      local brew_eval='eval "$(/opt/homebrew/bin/brew shellenv)"'
      grep -qxF "$brew_eval" "$HOME/.zshrc" 2>/dev/null || echo "$brew_eval" >> "$HOME/.zshrc"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    if ! command -v brew &> /dev/null; then
      error "Homebrew installation failed: brew not found in PATH."
    fi
    log "Homebrew installed successfully."
  else
    log "Homebrew is already installed."
  fi
}

install_chezmoi() {
  log "Installing chezmoi and bitwarden-cli..."
  brew install chezmoi bitwarden-cli
  
  if ! command -v chezmoi &> /dev/null; then
    error "chezmoi installation failed."
  fi
  
  if ! command -v bw &> /dev/null; then
    error "bitwarden-cli installation failed."
  fi
  
  log "chezmoi and bitwarden-cli installed successfully."
}

unlock_bitwarden() {
  log "Checking Bitwarden status..."
  bw_status=$(bw status 2>/dev/null || echo '{"status":"unauthenticated"}')

  case "$bw_status" in
    *'"status":"unauthenticated"'*)
      log "You are not logged in to Bitwarden. Logging in (interactive)..."
      bw login || error "Bitwarden login failed."
      ;;
    *'"status":"locked"'*)
      log "Bitwarden vault is locked."
      ;;
    *'"status":"unlocked"'*)
      log "Bitwarden vault is already unlocked."
      return 0
      ;;
  esac

  if ! bw status 2>/dev/null | grep -q '"status":"unlocked"'; then
    log "Unlocking Bitwarden vault..."
    BW_SESSION=$(bw unlock --raw) || error "Failed to unlock Bitwarden vault."
    export BW_SESSION
  fi
  
  log "Bitwarden vault is unlocked."
}

init_dotfiles() {
  log "Initializing dotfiles from $REPO..."
  chezmoi init "$REPO"
  
  if [[ ! -d "$HOME/.local/share/chezmoi" ]]; then
    error "chezmoi init failed: dotfiles repository not found."
  fi
  
  log "Applying dotfiles..."
  chezmoi apply
  log "Dotfiles applied successfully."
}

install_homebrew
install_chezmoi
unlock_bitwarden
init_dotfiles

log "Bootstrap complete! Run 'chezmoi apply' to update dotfiles in the future."