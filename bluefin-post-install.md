# Bluefin Post Install 

## Set the system

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

Enable dev mode
```bash
ujust devmode
```
Optionally, install recommended CLI tools and development Flatpaks.

Reboot.

Enable dev mode
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

Run the bootstap script:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nikokultalahti/dotfiles/main/bootstrap.sh)"
```

## Settings

Set up fingerprints.
Set up Online Accounts.
Set up Firefox.
Set up apps.

Copy public SSH keys from Bitwarden to `~/.ssh`
Configure NextDNS:
    - Create a file in  `/etc/systemd/resolved.conf.d/`and set according to instructions in NextDNS Account Dashboard.




