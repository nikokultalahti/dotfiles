# Fedora Silverblue Install 

## System update

Update system
```bash
rpm-ostree upgrade
```

Update flatpaks
```bash
flatpak update
```

Update Firmware
```bash
fwupdmgr refresh --force
fwupdmgr get-devices
fwupdmgr get-updates
fwupdmgr update
```
Reboot
```bash
systemctl reboot
```

## Initialize dotfiles and bootstrap

Run:
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply nikokultalahti
```

This also sets up the VS Code yum repo (`/etc/yum.repos.d/vscode.repo`), which
the RPM-Ostree step below needs. VS Code extension installation will fail and
retry on every future `chezmoi apply` until `code` is actually on PATH —
expected until you've completed the next two steps.

## RPM-Ostree

Remove and install layered packages
```bash
sudo rpm-ostree override remove firefox firefox-langpacks gnome-tour \
  --install=distrobox \
  --install=tmux \
  --install=code \
  --install=zsh \
  --install=zsh-autosuggestions \
  --install=zsh-syntax-highlighting \
```
Reboot
```bash
systemctl reboot
```

## Finish bootstrap

Run `chezmoi apply` again — `code` now exists, so this installs the VS Code
extensions:
```bash
chezmoi apply
```

## Configure
- Set up Gnome Settings, incl. Ptyxis
- Set up Gnome Extensions
- Set up Firefox
- Set up Flatpaks
    - Enable Bitwarden SSH Agent
