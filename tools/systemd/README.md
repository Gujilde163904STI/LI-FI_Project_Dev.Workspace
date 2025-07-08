# Systemd Service Integration

This folder contains systemd unit files for Coder, WayVNC, and (optionally) Skaffold dev workflows.

## Services

- `coder.service`: Launches Coder server on boot (hardened)
- `wayvnc.service`: Launches WayVNC server with TLS/SSH fallback (hardened)
- `skaffold.service`: (Optional) Runs `skaffold dev` for live sync/build

## Installation

To install and enable all services (user mode):

```
bash install_all_services.sh
```

To install in system mode (requires sudo):

```
bash install_all_services.sh --system
```

## Enable/Disable/Status

- Enable (user):
  `systemctl --user enable coder.service`
- Start (user):
  `systemctl --user start coder.service`
- Status (user):
  `systemctl --user status coder.service`
- Logs:
  `journalctl --user -u coder.service -f`

(Replace `coder.service` with `wayvnc.service` or `skaffold.service` as needed)

## Debugging Tips

- Check logs with `journalctl` as above
- Ensure you have the required binaries (`coder`, `wayvnc`, `skaffold`) in your PATH
- For graphical services, ensure your session supports the required environment variables (DISPLAY, XDG_SESSION_TYPE)
- For system mode, use `sudo systemctl ...` instead of `systemctl --user ...`
