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
#   - Initializes and applies dotfiles from https://github.com/nikokultalahti/dotfiles.git
#
# Requirements:
#   - sudo access (for Homebrew installation)
#   - Bitwarden CLI must be logged in (bw login) if not already configured

set -euo pipefail

# Request sudo upfront (for Homebrew installation on both Linux and macOS)
echo "Requesting sudo access for Homebrew installation..."
sudo -v || { echo "sudo access required for Homebrew installation."; exit 1; }

# Keep sudo alive for the duration of the script
while true; do
  sudo -n true 2>/dev/null || break
  sleep 60
  kill -0 $$ || exit
  done &

# Install Homebrew (macOS + Linux)
install_homebrew() {
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    local shell_config=""
    if [[ "$(uname -s)" == "Linux" ]]; then
      shell_config="$HOME/.bashrc"
    else
      shell_config="$HOME/.zshrc"
    fi
    
    # Append eval line to shell config
    if [[ "$(uname -s)" == "Linux" ]]; then
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$shell_config"
      source "$shell_config"
    else
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$shell_config"
      source "$shell_config"
    fi
    
    # Verify Homebrew is in PATH
    if ! command -v brew &> /dev/null; then
      echo "Homebrew installation failed: brew not found in PATH."
      exit 1
    fi
  fi
}

# Install chezmoi and bitwarden
install_chezmoi() {
  brew install chezmoi bitwarden-cli
  
  # Verify chezmoi is installed
  if ! command -v chezmoi &> /dev/null; then
    echo "chezmoi installation failed."
    exit 1
  fi
  
  # Verify bitwarden-cli is installed
  if ! command -v bw &> /dev/null; then
    echo "bitwarden-cli installation failed."
    exit 1
  fi
}

# Unlock Bitwarden vault
unlock_bitwarden() {
  if ! bw status 2>/dev/null | grep -q '"status":"unlocked"'; then
    echo "Bitwarden vault is locked. Unlocking..."
    BW_SESSION=$(bw unlock --raw)
    export BW_SESSION
    if ! bw status 2>/dev/null | grep -q '"status":"unlocked"'; then
      echo "Failed to unlock Bitwarden vault."
      exit 1
    fi
  else
    echo "Bitwarden vault is already unlocked."
  fi
}

# Initialize dotfiles
init_dotfiles() {
  chezmoi init https://github.com/nikokultalahti/dotfiles.git
  
  # Validate chezmoi init succeeded
  if [[ ! -d "$HOME/.local/share/chezmoi" ]]; then
    echo "chezmoi init failed: dotfiles repository not found."
    exit 1
  fi
  
  chezmoi apply
}

# Execute
install_homebrew
install_chezmoi
unlock_bitwarden
init_dotfiles

echo "Bootstrap complete! Run 'chezmoi apply' to update dotfiles in the future."
