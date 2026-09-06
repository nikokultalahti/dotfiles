# Bluefin Post Install Steps

## Check the system

Confirm the systemConfigure to date.

Update system
```bash
ujust update
```

Update Firmware
```bash
fwupdmgr refresh --force
fwupdmgr get-devices
fwupdmgr get-updates
fwupdmgr update
```
Or use the Firmware app.

Reboot.

Enable dev mode if not enabled yet.
```bash
ujust devmode
```

Reboot.

Add yourself to newly created groups
```bash
ujust dx-group
```

## Services

Enable and start Podman:
```bash
systemctl --user enable podman.socket 
systemctl --user start podman.socket
```

## Apps and configurations

Run the bootstap script it not ran yet:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nikokultalahti/dotfiles/main/bootstrap.sh)"
```

## Settings

Configure fingerprint setup for user.
Configure Nextcloud in Online Accounts.
Configure Firefox.
Configure flatpak apps.

Copy public SSH keys from Bitwarden to `~/.ssh`

Configure NextDNS:
    - Create a file in  `/etc/systemd/resolved.conf.d/`and set according to instructions in NextDNS Account Dashboard
    - Run `sudo systemctl reload systemd-resolved`

Configure VPN:
    - Copy Wireguard VPN configuration files from router and VPN provider, and import into Network Maanger


