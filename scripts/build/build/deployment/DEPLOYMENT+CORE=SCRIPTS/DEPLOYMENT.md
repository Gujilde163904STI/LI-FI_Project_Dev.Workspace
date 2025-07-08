# scripts/DEPLOYMENT.md

## Deployment Scripts for LI-FI System

- `deploy_tx.sh`: Flash transmitter firmware (`tx_esp8266.ino`) to NodeMCU ESP8266 (TX)
- `deploy_rx.sh`: Flash receiver firmware (`rx_esp8266.ino`) to NodeMCU ESP8266 (RX)
- `deploy_pi.sh`: Deploy Python scripts to Raspberry Pi (TX and RX)

### Usage

```sh
# Flash ESP8266 TX
bash scripts/deploy_tx.sh

# Flash ESP8266 RX
bash scripts/deploy_rx.sh

# Deploy Python scripts to Raspberry Pi
bash scripts/deploy_pi.sh
```

---

# HARDWARE_VERIFY: Always confirm correct ports and hostnames before running deployment scripts.
