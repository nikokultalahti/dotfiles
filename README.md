# Dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

The actual chezmoi source lives under [`dotfiles/`](dotfiles) (see `.chezmoiroot`) —
this keeps repo-level files (this README, `TODO.md`, `docs/`) separate from what
chezmoi manages. 

## Features

- **Cross-platform**: Supports macOS and Linux (Fedora Silverblue especially).
- **Conditional Configuration**: A single `work` boolean (prompted once, at
  init) drives all personal/work branching (`{{ if .work }}`); OS branching
  uses `.chezmoi.os` directly.
- **Templating**: Uses chezmoi's templating system for dynamic values.
- **Secrets Management**: Integrates with password managers (native chezmoi
  integration, no separate secrets tooling) for pulling required
  secrets and configurations for templating.
- **Tool/App Management**: All tools and apps are installed via [mise](https://mise.jdx.dev/), declared in
  [`.chezmoidata/mise.toml`](dotfiles/.chezmoidata/mise.toml) and
  [`.chezmoidata/extensions.toml`](dotfiles/.chezmoidata/extensions.toml) for VSCode extensions.

## Quick Start

To set up your dotfiles on a new machine, run:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply nikokultalahti
```

This single command installs chezmoi, then applies the dotfiles, which in turn:
1. Installs mise appropriate password manager — see
   [`run_once_before_1-install-prerequisites.sh.tmpl`](dotfiles/.chezmoiscripts/run_once_before_1-install-prerequisites.sh.tmpl).
2. Prompts for whether this is a work machine, and work email address if so.
3. Applies all dotfiles and templates.
4. Installs every remaining tool/app via mise, and for Linux: configures
   Flathub priority, GNOME background updates, the Podman socket, rpm-ostree
   automatic update staging, and a daily mise/flatpak update timer.

On Fedora Silverblue specifically, VS Code needs a manual layering step + reboot
between two `chezmoi apply` runs (chezmoi sets up the yum repo, but rpm-ostree
layering itself is manual) — see
[`docs/silverblue-install-guide.md`](docs/silverblue-install-guide.md).

## Requirements

- **Bitwarden account**, logged in (`bw login`) the first time secrets are
  needed — the prerequisites script prompts for this automatically.
- **Bitwarden secure notes** that must exist before secrets-dependent
  templates render:
  - `dotfiles-sshconfig-personal` / `dotfiles-sshconfig-work` — extra
    `~/.ssh/config` entries.
  - `dotfiles-mise-github-token` — a GitHub token, exported as
    `MISE_GITHUB_TOKEN` to avoid API rate limiting on mise's aqua/github tool
    installs.
  - `dotfiles-nextdns-conf` (Linux + personal only) — contents of
    `/etc/systemd/resolved.conf.d/nextdns.conf`.

## Usage

- **Update dotfiles**: Run `chezmoi update` to pull the latest changes and `chezmoi apply` to apply them.
- **Add new files**: Use `chezmoi add <file>` to add a new file to the dotfiles repository.
- **Edit templates**: Modify files under `~/.local/share/chezmoi/dotfiles/` and run `chezmoi apply` to update the managed files.
- **Add/remove a tool or app**: Edit
  [`.chezmoidata/mise.toml`](dotfiles/.chezmoidata/mise.toml) (or
  `extensions.toml` for VS Code extensions), then `chezmoi apply`.
- **Re-run tool/app installation only**: `mise install && mise bootstrap packages apply --yes`.