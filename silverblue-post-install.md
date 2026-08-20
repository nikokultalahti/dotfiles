# Fedora Silverblue Post Install 

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

## RPM-Ostree

Remove Firefox and Gnome Tour
```bash
sudo rpm-ostree override remove firefox firefox-langpacks gnome-tour
```

Install required layered packages
```bash
sudo rpm-ostree install gcc
```

Reboot

## Repositories

Set up Flathub repository
```bash
# 1. Add Flathub
sudo flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 2. Enable and make sure it's unfiltered
sudo flatpak remote-modify --system --no-filter --enable flathub

# 3. Give Flathub priority when the same app exists in several remotes
sudo flatpak remote-modify --system --prio=10 flathub

# 4. Stop the Fedora remote from being enumerated, so it's not searched for apps, but is still used for updates
sudo flatpak remote-modify --system --no-enumerate fedora
```

Remove unused repositories
```bash
sudo sed -i 's/enabled=1/enabled=0/' \
/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo \
/etc/yum.repos.d/fedora-cisco-openh264.repo \
/etc/yum.repos.d/google-chrome.repo \
/etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo \
/etc/yum.repos.d/rpmfusion-nonfree-steam.repo
```

## Services

Enable and start Podman:
```bash
systemctl --user enable podman.socket 
systemctl --user start podman.socket
```

## Apps and configurations

Run the bootstap script:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nikokultalahti/dotfiles/main/bootstrap.sh)"
```

## Settings

Set up fingerprints.

Set ZSH as shell, either:

A.) If installed via Homebrew
Click on the Terminal settings, edit profile, select "Use Custom Command" and add `/home/linuxbrew/.linuxbrew/bin/zsh`

B.) If layered
```bash
sudo chsh -s /usr/bin/zsh <username>
```

Configure NextDNS:
Create a file in  `/etc/systemd/resolved.conf.d/`and set according to instructions in NextDNS Account Dashboard.

SSH Keys: Copy public SSH keys from Bitwarden to `~/.ssh

## Optional
Layer packages
```bash
rpm-ostree install distrobox gnome-tweak-tool adw-gtk3-theme zsh qemu qemu-kvm pam-u2f pam_yubico yubikey-manager
```

Configure NextDNS:
Create a file in  `/etc/systemd/resolved.conf.d/`and set according to instructions in NextDNS Account Dashboard.
