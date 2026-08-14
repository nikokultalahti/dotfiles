#!/bin/bash
# Bootstrap script for dotfiles managed with chezmoi.

set -euo pipefail

# Request sudo upfront
echo "Requesting sudo access for Homebrew installation..."
sudo -v || { echo "sudo access required for Homebrew installation."; exit 1; }

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
      echo "Homebrew installation failed: brew not found in PATH."
      exit 1
    fi
  fi
}

install_chezmoi() {
  brew install chezmoi bitwarden-cli

  if ! command -v chezmoi &> /dev/null; then
    echo "chezmoi installation failed."
    exit 1
  fi

  if ! command -v bw &> /dev/null; then
    echo "bitwarden-cli installation failed."
    exit 1
  fi
}

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

init_dotfiles() {
  chezmoi init https://github.com/nikokultalahti/dotfiles.git

  if [[ ! -d "$HOME/.local/share/chezmoi" ]]; then
    echo "chezmoi init failed: dotfiles repository not found."
    exit 1
  fi

  chezmoi apply
}

install_homebrew
install_chezmoi
unlock_bitwarden
init_dotfiles

echo "Bootstrap complete! Run 'chezmoi apply' to update dotfiles in the future."