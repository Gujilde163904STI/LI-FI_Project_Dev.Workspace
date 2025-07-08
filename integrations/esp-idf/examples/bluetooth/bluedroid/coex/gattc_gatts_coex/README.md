| Supported Targets | ESP32 | ESP32-C2 | ESP32-C3 | ESP32-C5 | ESP32-C6 | ESP32-C61 | ESP32-H2 | ESP32-S3 |
| ----------------- | ----- | -------- | -------- | -------- | -------- | --------- | -------- | -------- |

ESP-IDF Gattc and Gatts Coexistence example
==============================================

This example demonstrates the coexistence of gattc and gatts.

This example creates a GATT service and starts ADV. The ADV name is `ESP*GATTS*DEMO`, then waits to be connected. At the same time, a gatt client is created, the ADV name is `ESP*GATTS*DEMO`, the device is connected, and the data is exchanged. If the device is not found within 120 seconds, the example will stop scanning.

ESP-IDF also allows users to create a GATT service via an attribute table, rather than add attributes one by one. And it is recommended for users to use. For more information about this method, please refer to [gatt*server*service*table*demo](../../ble/gatt*server*service_table).

To test this example, you can run the [gatt*client*demo](../../ble/gatt*client), which can scan for and connect to this example automatically, and run [gatt*server*demo](../../ble/gatt*server), Waiting to be connected. They will start exchanging data once the GATT client has enabled the notification function of the GATT server.

Please check the [tutorial](../../ble/gatt*server/tutorial/Gatt*Server*Example*Walkthrough.md) for more information about the gatts part of this example.
Please check the [tutorial](../../ble/gatt*client/tutorial/Gatt*Client*Example*Walkthrough.md) for more information about the gattc part of this example.

