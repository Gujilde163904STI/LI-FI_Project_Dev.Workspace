# Bluetooth Examples for Host Controller Interface

Note: To use examples in this directory, you need to have Bluetooth enabled in configuration.

# Example Layout

This directory includes examples to demonstrate controller interactions by virtual HCI layer and UART.

## controller*hci*uart_esp32

Demonstrates interaction with controller through HCI over UART on ESP32.

See the [README.md](./controller*hci*uart*esp32/README.md) file in the example [controller*hci*uart](./controller*hci*uart*esp32).

## controller*hci*uart*esp32c3*and_esp32s3

Demonstrates interaction with controller through HCI over UART on ESP32-C3/ESP32-S3.

See the [README.md](./controller*hci*uart*esp32c3*and*esp32s3/README.md) file in the example [controller*hci*uart*esp32c3*and*esp32s3](./controller*hci*uart*esp32c3*and_esp32s3).

## controller*vhci*ble_adv

Demonstrates interaction with controller though virtual HCI layer. In this example, simple BLE advertising is done.

See the [README.md](./controller*vhci*ble*adv/README.md) file in the example [controller*vhci*ble*adv](./controller*vhci*ble_adv).

## ble*adv*scan_combined

Demonstrates interaction with controller. In this example, BLE advertising and scanning is done. Also scanned advertising reports are parsed and displayed.

See the [README.md](./ble*adv*scan*combined/README.md) file in the example [ble*adv*scan*combined](./ble*adv*scan_combined).


## hci*common*component

This is separate component adding functionalities for HCI Layer. Since this component is just used by HCI examples, it is not placed in global components.
