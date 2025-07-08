# bldc*fan*rainmaker

The `bldc*fan*rainmaker` example connects a brushless motor-driven fan to the ESP Rainmaker cloud, achieving the following functionalities:

* Stepless fan speed control
* Oscillation
* Natural wind mode
* Remote start and stop
* OTA updates
* BLE provisioning

![rainmaker*fan](https://dl.espressif.com/AE/esp-iot-solution/esp*bldc_rainmaker.gif)

## Component Overview

* [esp*sensorless*bldc*control](https://components.espressif.com/components/espressif/esp*sensorless*bldc*control) is a sensorless BLDC square wave control library based on the ESP32 series chips. It supports the following features:
    * Zero-crossing detection based on ADC sampling
    * Zero-crossing detection based on a comparator
    * Initial rotor position detection using pulse method
    * Stall protection
    * Overcurrent, over/under-voltage protection [feature]
    * Phase loss protection [feature]

* [esp*rainmaker](https://components.espressif.com/components/espressif/esp*rainmaker) is a complete and lightweight AIoT solution that enables private cloud deployment for your business in a simple, cost-effective, and efficient manner.