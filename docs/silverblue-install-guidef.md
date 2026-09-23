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

## Initialize dotfiles and bootstrap

Run:
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply nikokultalahti
```

## Configure
- Set up Gnome Settings, incl. Ptyxis
- Set up Gnome Extensions
- Set up Firefox
- Set up Flatpaks
    - Enable Bitwarden SSH Agent
