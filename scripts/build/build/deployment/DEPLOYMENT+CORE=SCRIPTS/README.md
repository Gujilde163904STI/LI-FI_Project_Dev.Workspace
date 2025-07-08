# scripts/README.md

## LI-FI System Scripts

- `check_serial_perms.sh`: Ensures your user is in the `dialout` group for serial port access on Raspberry Pi/Linux.

## Usage

```sh
bash scripts/check_serial_perms.sh
```

- If you are not in the `dialout` group, the script will add you (requires sudo). Log out and back in for changes to take effect.

---

# HARDWARE_VERIFY: All scripts and code must be tested with real hardware for production deployment.

# SCRIPTS

This folder contains all setup, deployment, and automation scripts for the LI-FI project. Place all shell scripts, Python setup scripts, and related automation here.
