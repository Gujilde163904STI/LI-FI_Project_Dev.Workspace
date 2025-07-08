# ESP-BLE-MESH Examples

[ESP-BLE-MESH](../../../components/bt/esp*ble*mesh/) is the official Bluetooth® Mesh stack of Espressif Systems. We will provide long-term support for new features, performance optimization, etc.

Please help note that breaking changes may be introduced into ESP-BLE-MESH on [minor IDF versions](https://docs.espressif.com/projects/esp-idf/en/latest/versions.html).

Note: To use examples in this directory, you need to have Bluetooth enabled in configuration, and either Bluedroid or NimBLE can be selected as the host stack.

# Example Layout

This directory includes some examples to demonstrate ESP-BLE-MESH functionality based on [Zephyr Bluetooth Mesh stack](https://github.com/zephyrproject-rtos/zephyr/tree/master/subsys/bluetooth/mesh).

## fast_provisioning

This example illustrates the solution of ESP-BLE-MESH Fast Provisioning.

#### fast*prov*client

This example shows how ESP32, acting as a BLE Mesh Fast Provisioning Client, provisions other unprovisioned devices and then controls the nodes.

See [fast*prov*client](fast*provisioning/fast*prov_client) folder for more details.

#### fast*prov*server

This example illustrates the process that:
1. ESP32 as a BLE Mesh Fast Provisioning Server is provisioned into a node;
2. ESP32 as a Temporary Provisioner provisions other unprovisioned devices.

See [fast*prov*server](fast*provisioning/fast*prov_server) folder for more details.

## onoff_models

This example demonstrates how ESP32 acts as a BLE Mesh node with Generic OnOff Server model or Generic OnOff Client model on board.

#### onoff_client

This example shows how ESP32 acts as a BLE Mesh Node with Generic OnOff Client model in the Primary Element.

See [onoff*client](onoff*models/onoff_client) folder for more details.

#### onoff_server

This example shows how ESP32 acts as a BLE Mesh Node with only Generic OnOff Server model in the Primary Element.

See [onoff*server](onoff*models/onoff_server) folder for more details.

## provisioner

This example shows how ESP32 acts as a BLE Mesh Provisioner and provisions other unprovisioned devices.

See [provisioner](provisioner) folder for more details.

## vendor_models

This example demonstrates how ESP32 acts as a BLE Mesh Provisioner with vendor client model or as a BLE Mesh node with vendor server model.

#### vendor_client

This example shows how ESP32 acts as a BLE Mesh Provisioner with a vendor client model in the Primary Element.

See [vendor*client](vendor*models/vendor_client) folder for more details.

#### vendor_server

This example shows how ESP32 acts as a BLE Mesh Node with a vendor server model in the Primary Element.

See [vendor*server](vendor*models/vendor_server) folder for more details.

## wifi_coexist

This example shows how ESP32 acts as a BLE Mesh Fast Provisioning Server and coexists with Wi-Fi iperf functionality.

See [wifi*coexist](wifi*coexist) folder for more details.

## directed_forwarding (v1.1)

This example shows how the ESP32 acts as a Directed Forwarding node to establish paths and directed forwarding messages.

### df_client

This example shows how ESP32 acts as a BLE Mesh Provisioner with a Directed Forwarding Client model in the Primary Element.

See [df*client](directed*forwarding/df_client) folder for more details.

### df_server

This example shows how ESP32 acts as a BLE Mesh Node with a Directed Forwarding Server model in the Primary Element.

See [df*server](directed*forwarding/df_server) folder for more details.

## remote_provisioning (v1.1)

This example shows how the ESP32 acts as an Remote Provisioning Server assistant provisioner to provisioning devices out of single-hop.

### rpr_client

This example shows how ESP32 acts as a BLE Mesh Provisioner with a Remote Provisioning Client model in the Primary Element.

See [rpr*client](remote*provisioning/rpr_client) folder for more details.

### rpr_server

This example shows how ESP32 acts as a BLE Mesh Node with a Remote Provisioning Server model in the Primary Element.

See [rpr*server](remote*provisioning/rpr_server) folder for more details.

### unprov_dev

This example shows how ESP32 acts as an unprovisioning device.

See [unprov*dev](remote*provisioning/unprov_dev) folder for more details.

# More

See the [README.md](../../README.md) file in the upper level [examples](../../) directory for more information about examples.

