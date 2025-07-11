| Supported Targets | ESP32-P4 | ESP32-S2 | ESP32-S3 |
| ----------------- | -------- | -------- | -------- |

# USB CDC-ACM Virtual COM Port example

(See the README.md file in the upper level 'examples' directory for more information about examples.)

This example shows how to extend CDC-ACM driver for Virtual Communication Port (VCP) devices, such as CP210x, FTDI FT23x or CH34x devices.

The drivers are fetched from [ESP Component Registry](https://components.espressif.com/) together with VCP service that automatically loads correct driver for plugged-in device.

## How to use example

1. Connect your USB<->UART converter to ESP board, the device will be automatically enumerated and correct driver will be loaded
2. Change baudrate and other line coding parameters in [cdc*acm*vcp*example*main.cpp](main/cdc*acm*vcp*example*main.cpp) to match your needs
3. Now you can use the usual CDC-ACM API to control the device and send data. Data are received in `handle_rx` callback
4. Try disconnecting and then reconnecting of the USB device to experiment with USB hotplugging

### Hardware Required

* Development board with USB-OTG support
* A USB cable for Power supply and programming
* Silicon Labs CP210x, FTDI FT23x or CP34x USB to UART converter

#### Pin Assignment

Follow instruction in [examples/usb/README.md](../../../README.md) for specific hardware setup.

### Build and Flash

Build this project and flash it to the USB host board, then run monitor tool to view serial output:

```bash
idf.py -p PORT flash monitor
```

(Replace PORT with the name of the serial port to use.)

(To exit the serial monitor, type ``Ctrl-]``.)

See the Getting Started Guide for full steps to configure and use ESP-IDF to build projects.
