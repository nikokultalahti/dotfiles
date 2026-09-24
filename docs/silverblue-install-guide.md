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
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply -k nikokultalahti
```

The `-k`/`--keep-going` flag is required, not optional: chezmoi stops the
*entire* apply as soon as any script fails, and the VS Code extensions script
(see below) is expected to fail until `code` is actually installed. Without
`-k`, that one failure would silently skip every script that sorts after it —
including the ones that configure rpm-ostree, GNOME updates, and the Podman
socket.

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
extensions. `-k` is no longer strictly necessary once VS Code is installed,
but harmless to keep:
```bash
chezmoi apply -k
```

## Configure
- Set up Gnome Settings, incl. Ptyxis
- Set up Gnome Extensions
- Set up Firefox
- Set up Flatpaks
    - Enable Bitwarden SSH Agent
