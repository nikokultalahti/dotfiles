# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Cross-platform**: Supports macOS and Linux (including Fedora Silverblue).
- **Conditional Configuration**: Dynamically configures files based on OS and machine type (work/personal).
- **Templating**: Uses chezmoi's templating system for dynamic values.
- **Secrets Management**: Integrates with Bitwarden for secure secrets management.
- **Bootstrap Script**: Automates the setup process with a single command.

## Quick Start

To set up your dotfiles on a new machine, run:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nikokultalahti/dotfiles/main/bootstrap.sh)"
```

The bootstrap script will:
1. Request sudo access for Homebrew installation.
2. Install Homebrew (if not already installed).
3. Install chezmoi and bitwarden-cli.
4. Unlock your Bitwarden vault.
5. Initialize and apply the dotfiles.

## Requirements

- **sudo access**: Required for Homebrew installation.
- **Bitwarden CLI**: Must be logged in (`bw login`) if not already configured.

## Manual Setup

If you prefer to set up manually:

1. Install Homebrew:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install chezmoi and bitwarden-cli:
   ```bash
   brew install chezmoi bitwarden-cli
   ```

3. Initialize dotfiles:
   ```bash
   chezmoi init https://github.com/nikokultalahti/dotfiles.git
   ```

4. Apply dotfiles:
   ```bash
   chezmoi apply
   ```

## Usage

- **Update dotfiles**: Run `chezmoi update` to pull the latest changes and `chezmoi apply` to apply them.
- **Add new files**: Use `chezmoi add <file>` to add a new file to the dotfiles repository.
- **Edit templates**: Modify files in `~/.local/share/chezmoi/` and run `chezmoi apply` to update the managed files.

## TODO
- Opencode Config
- Script for macOS settings
- Fedora Silverblue / GNOME settings
