# Dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

The actual chezmoi source lives under [`dotfiles/`](dotfiles) (see `.chezmoiroot`),
which keeps repo-level files (this README) separate from what chezmoi manages.

They are meant for two machines:

- **Personal:** [NikOS](https://github.com/nikokultalahti/nikos) on Linux. chezmoi and
  Homebrew come with the image.
- **Work:** macOS.

## Features

- **Cross-platform:** Linux and macOS. A single `work` boolean, asked once at
  init, drives all personal/work branching (`{{ if .work }}`); OS branching uses
  `.chezmoi.os`.
- **Homebrew everywhere:** CLI tools, and casks on macOS, are installed with
  Homebrew from [`.chezmoidata/packages.yaml`](dotfiles/.chezmoidata/packages.yaml).
- **Flatpaks on Linux:** apps the NikOS image doesn't already provide are
  installed per user from the same file.
- **Secrets from Bitwarden:** read through chezmoi's native Bitwarden support.
  Nothing secret is stored in this repository, and SSH keys stay in Bitwarden's
  SSH agent.
- **Data in YAML:** package lists and VS Code extensions live in
  [`.chezmoidata/`](dotfiles/.chezmoidata) as YAML.

## Quick start

### NikOS

chezmoi is already installed:

```bash
chezmoi init --apply nikokultalahti
```

### macOS

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply nikokultalahti
```

### What happens

1. chezmoi asks whether this is a work machine, and for the git email if so.
2. The prerequisites script
   ([`run_once_before_1-install-prerequisites.sh.tmpl`](dotfiles/.chezmoiscripts/run_once_before_1-install-prerequisites.sh.tmpl))
   makes sure Homebrew is installed, installs the Bitwarden CLI with it,
   points it at the EU server and asks you to log in.
   On NikOS it first waits for the image's first-boot Homebrew setup to finish.
3. chezmoi applies all dotfiles and templates.
4. Homebrew installs the packages (and the casks on macOS), and the per-user
   Flatpaks are installed on Linux.
5. VS Code extensions are installed if `code` exists. Otherwise that step is
   skipped, and picks up on a later `chezmoi apply`.

## Requirements

- A **Bitwarden account** on the EU server (`vault.bitwarden.eu`).
- **Bitwarden secure notes** that must exist before the SSH config renders:
  - `dotfiles-sshconfig-personal` and `dotfiles-sshconfig-work`: extra
    `~/.ssh/config` entries.
- The **Bitwarden SSH agent** enabled, for git signing and SSH. On Linux that is
  the Bitwarden desktop Flatpak (installed here); on macOS the cask.

## Usage

- **Update:** `chezmoi update`.
- **Add files:** `chezmoi add <file>`.
- **Edit templates:** change files under `~/.local/share/chezmoi/dotfiles/` and
  run `chezmoi apply`.
- **Add or remove a package, app or extension:** edit
  [`packages.yaml`](dotfiles/.chezmoidata/packages.yaml) or
  [`extensions.yaml`](dotfiles/.chezmoidata/extensions.yaml), then
  `chezmoi apply`. The install scripts re-run when their content changes.

## Notes

- **zsh on Linux** comes from Homebrew, so it isn't a registered login shell. Set
  Ptyxis to start a terminal with a custom command pointing at
  `/home/linuxbrew/.linuxbrew/bin/zsh`.
- **Updates on Linux:** the NikOS image already updates the OS, Flatpaks and
  Homebrew on timers, so there is nothing for chezmoi to schedule.
- **litra-autotoggle** is started as a Homebrew service by the package script.
- **Migrating an existing machine:** the chezmoi config template is now YAML
  (`.chezmoi.yaml.tmpl`). Delete the old `~/.config/chezmoi/chezmoi.toml`, then run
  `chezmoi init` again so the new config is generated.
