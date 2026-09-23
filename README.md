# Dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Cross-platform**: Supports macOS and Linux (Fedora Silverblue / Bluefin).
- **Conditional Configuration**: Dynamically configures files based on OS (Linux, MacOS) and whether this is a work machine.
- **Templating**: Uses chezmoi's templating system for dynamic values.
- **Secrets Management**: Integrates with Bitwarden (and, on work machines, Dashlane) for secure secrets management.
- **Tool/App Management**: All tools and apps (including brew/cask packages) are installed via [mise](https://mise.jdx.dev/), itself installed automatically on first apply — no separate bootstrap script.

## Quick Start

To set up your dotfiles on a new machine, run:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply nikokultalahti
```

This single command installs chezmoi, then applies the dotfiles, which in turn:
1. Installs mise, then the Bitwarden CLI (and, on work machines, the Dashlane CLI) —
   see [`run_once_before_1-install-prerequisites.sh.tmpl`](dotfiles/.chezmoiscripts/run_once_before_1-install-prerequisites.sh.tmpl).
2. Prompts for whether this is a work machine, and your git email if so.
3. Applies all dotfiles and templates.
4. Installs every remaining tool/app via mise.

## Requirements

- **Bitwarden account**: Must be able to log in (`bw login`) the first time secrets are needed.

## Usage

- **Update dotfiles**: Run `chezmoi update` to pull the latest changes and `chezmoi apply` to apply them.
- **Add new files**: Use `chezmoi add <file>` to add a new file to the dotfiles repository.
- **Edit templates**: Modify files in `~/.local/share/chezmoi/` and run `chezmoi apply` to update the managed files.

## Additional setup

There are several smaller tasks that are expected to be performed after a fresh install and it does not make sense to have those in here.

The steps to follow for a fresh OS install can be found at:
- [Bluefin Post Install Steps](bluefin-post-install.md)