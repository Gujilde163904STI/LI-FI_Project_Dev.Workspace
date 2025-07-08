[![Documentation Status](https://dl.espressif.com/AE/docs/docs_latest.svg)](https://docs.espressif.com/projects/esp-iot-solution/en)

<a href="https://espressif.github.io/esp-launchpad/?flashConfigURL=https://dl.espressif.com/AE/esp-iot-solution/config.toml">
    <img alt="Try it with ESP Launchpad" src="https://espressif.github.io/esp-launchpad/assets/try_with_launchpad.png" width="200" height="56">
</a>

## Espressif IoT Solution Overview

* [中文版](./README_CN.md)

ESP-IoT-Solution contains device drivers and code frameworks for the development of IoT systems, providing extra components that enhance the capabilities of ESP-IDF and greatly simplify the development process.

ESP-IoT-Solution contains the following contents:

* Device drivers for sensors, display, audio, input, actuators, etc.
* Framework and documentation for Low power, security, storage, etc.
* Guide for espressif open source solutions from practical application point.

## Documentation Center

- 中文：https://docs.espressif.com/projects/esp-iot-solution/zh_CN
- English:https://docs.espressif.com/projects/esp-iot-solution/en

## Quick Reference

### Development Board

You can choose any of the ESP series development boards to use ESP-IoT-Solution or choose one of the boards supported in [boards component](./examples/common_components/boards) for a quick start.

Powered by 40nm technology, ESP series SoC provides a robust, highly integrated platform, which helps meet the continuous demands for efficient power usage, compact design, security, high performance, and reliability.

### Setup Environment

#### Setup ESP-IDF Environment

ESP-IoT-Solution is developed based on ESP-IDF functions and tools, so ESP-IDF development environment must be set up first, you can refer [Setting up Development Environment](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html#setting-up-development-environment) for the detailed steps.

Please note that different versions of ESP-IoT-Solution may depend on different versions of ESP-IDF, please refer to the below table to select the correct version:

| ESP-IoT-Solution | Dependent ESP-IDF |                    Major Change                     |                                                  User Guide                                                  |        Support State        |
| :--------------: | :---------------: | :-------------------------------------------------: | :----------------------------------------------------------------------------------------------------------: | --------------------------- |
|      master      |      >= v5.3      |                New Chips Support                                     |                     [Docs online](https://docs.espressif.com/projects/esp-iot-solution/)                     | New features                |
|   release/v2.0   | <= v5.3, >= v4.4  |              Support component manager              |                     [Docs online](https://docs.espressif.com/projects/esp-iot-solution/en/release-v2.0/index.html)                     | Bugfix only，until v5.3 EOL |
|   release/v1.1   |      v4.0.1       | IDF version update, remove no longer supported code | [v1.1 Overview](https://github.com/espressif/esp-iot-solution/tree/release/v1.1#esp32-iot-solution-overview) | archived                    |
|   release/v1.0   |      v3.2.2       |                   legacy version                    | [v1.0 Overview](https://github.com/espressif/esp-iot-solution/tree/release/v1.0#esp32-iot-solution-overview) | archived                    |

> Since the `master` branch uses the `ESP Component Manager` to manager components, each of them is a separate package, and each package may support a different version of the ESP-IDF, which will be declared in the component's `idf_component.yml` file

#### Get Components from ESP Component Registry

If you just want to use the components in ESP-IoT-Solution, we recommend you use it from the [ESP Component Registry](https://components.espressif.com/).

The registered components in ESP-IoT-Solution are listed below:

<center>

| Component | Version |
| --- | --- |
| [adc*battery*estimation](https://components.espressif.com/components/espressif/adc*battery*estimation) | [![Component Registry](https://components.espressif.com/components/espressif/adc*battery*estimation/badge.svg)](https://components.espressif.com/components/espressif/adc*battery*estimation) |
| [adc*mic](https://components.espressif.com/components/espressif/adc*mic) | [![Component Registry](https://components.espressif.com/components/espressif/adc*mic/badge.svg)](https://components.espressif.com/components/espressif/adc*mic) |
| [adc*tp*calibration](https://components.espressif.com/components/espressif/adc*tp*calibration) | [![Component Registry](https://components.espressif.com/components/espressif/adc*tp*calibration/badge.svg)](https://components.espressif.com/components/espressif/adc*tp*calibration) |
| [aht20](https://components.espressif.com/components/espressif/aht20) | [![Component Registry](https://components.espressif.com/components/espressif/aht20/badge.svg)](https://components.espressif.com/components/espressif/aht20) |
| [apds9960](https://components.espressif.com/components/espressif/apds9960) | [![Component Registry](https://components.espressif.com/components/espressif/apds9960/badge.svg)](https://components.espressif.com/components/espressif/apds9960) |
| [at24c02](https://components.espressif.com/components/espressif/at24c02) | [![Component Registry](https://components.espressif.com/components/espressif/at24c02/badge.svg)](https://components.espressif.com/components/espressif/at24c02) |
| [at581x](https://components.espressif.com/components/espressif/at581x) | [![Component Registry](https://components.espressif.com/components/espressif/at581x/badge.svg)](https://components.espressif.com/components/espressif/at581x) |
| [avi*player](https://components.espressif.com/components/espressif/avi*player) | [![Component Registry](https://components.espressif.com/components/espressif/avi*player/badge.svg)](https://components.espressif.com/components/espressif/avi*player) |
| [ble*anp](https://components.espressif.com/components/espressif/ble*anp) | [![Component Registry](https://components.espressif.com/components/espressif/ble*anp/badge.svg)](https://components.espressif.com/components/espressif/ble*anp) |
| [ble*conn*mgr](https://components.espressif.com/components/espressif/ble*conn*mgr) | [![Component Registry](https://components.espressif.com/components/espressif/ble*conn*mgr/badge.svg)](https://components.espressif.com/components/espressif/ble*conn*mgr) |
| [ble*hci](https://components.espressif.com/components/espressif/ble*hci) | [![Component Registry](https://components.espressif.com/components/espressif/ble*hci/badge.svg)](https://components.espressif.com/components/espressif/ble*hci) |
| [ble*hrp](https://components.espressif.com/components/espressif/ble*hrp) | [![Component Registry](https://components.espressif.com/components/espressif/ble*hrp/badge.svg)](https://components.espressif.com/components/espressif/ble*hrp) |
| [ble*htp](https://components.espressif.com/components/espressif/ble*htp) | [![Component Registry](https://components.espressif.com/components/espressif/ble*htp/badge.svg)](https://components.espressif.com/components/espressif/ble*htp) |
| [ble*ota](https://components.espressif.com/components/espressif/ble*ota) | [![Component Registry](https://components.espressif.com/components/espressif/ble*ota/badge.svg)](https://components.espressif.com/components/espressif/ble*ota) |
| [ble*services](https://components.espressif.com/components/espressif/ble*services) | [![Component Registry](https://components.espressif.com/components/espressif/ble*services/badge.svg)](https://components.espressif.com/components/espressif/ble*services) |
| [bme280](https://components.espressif.com/components/espressif/bme280) | [![Component Registry](https://components.espressif.com/components/espressif/bme280/badge.svg)](https://components.espressif.com/components/espressif/bme280) |
| [bootloader*support*plus](https://components.espressif.com/components/espressif/bootloader*support*plus) | [![Component Registry](https://components.espressif.com/components/espressif/bootloader*support*plus/badge.svg)](https://components.espressif.com/components/espressif/bootloader*support*plus) |
| [button](https://components.espressif.com/components/espressif/button) | [![Component Registry](https://components.espressif.com/components/espressif/button/badge.svg)](https://components.espressif.com/components/espressif/button) |
| [cmake*utilities](https://components.espressif.com/components/espressif/cmake*utilities) | [![Component Registry](https://components.espressif.com/components/espressif/cmake*utilities/badge.svg)](https://components.espressif.com/components/espressif/cmake*utilities) |
| [drv10987](https://components.espressif.com/components/espressif/drv10987) | [![Component Registry](https://components.espressif.com/components/espressif/drv10987/badge.svg)](https://components.espressif.com/components/espressif/drv10987) |
| [elf*loader](https://components.espressif.com/components/espressif/elf*loader) | [![Component Registry](https://components.espressif.com/components/espressif/elf*loader/badge.svg)](https://components.espressif.com/components/espressif/elf*loader) |
| [esp*lcd*axs15231b](https://components.espressif.com/components/espressif/esp*lcd*axs15231b) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*axs15231b/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*axs15231b) |
| [esp*lcd*ek79007](https://components.espressif.com/components/espressif/esp*lcd*ek79007) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*ek79007/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*ek79007) |
| [esp*lcd*gc9b71](https://components.espressif.com/components/espressif/esp*lcd*gc9b71) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*gc9b71/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*gc9b71) |
| [esp*lcd*hx8399](https://components.espressif.com/components/espressif/esp*lcd*hx8399) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*hx8399/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*hx8399) |
| [esp*lcd*jd9165](https://components.espressif.com/components/espressif/esp*lcd*jd9165) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*jd9165/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*jd9165) |
| [esp*lcd*jd9365](https://components.espressif.com/components/espressif/esp*lcd*jd9365) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*jd9365/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*jd9365) |
| [esp*lcd*nv3022b](https://components.espressif.com/components/espressif/esp*lcd*nv3022b) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*nv3022b/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*nv3022b) |
| [esp*lcd*panel*io*additions](https://components.espressif.com/components/espressif/esp*lcd*panel*io*additions) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*panel*io*additions/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*panel*io*additions) |
| [esp*lcd*sh8601](https://components.espressif.com/components/espressif/esp*lcd*sh8601) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*sh8601/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*sh8601) |
| [esp*lcd*spd2010](https://components.espressif.com/components/espressif/esp*lcd*spd2010) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*spd2010/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*spd2010) |
| [esp*lcd*st7701](https://components.espressif.com/components/espressif/esp*lcd*st7701) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*st7701/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*st7701) |
| [esp*lcd*st7703](https://components.espressif.com/components/espressif/esp*lcd*st7703) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*st7703/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*st7703) |
| [esp*lcd*st77903*qspi](https://components.espressif.com/components/espressif/esp*lcd*st77903*qspi) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*st77903*qspi/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*st77903*qspi) |
| [esp*lcd*st77903*rgb](https://components.espressif.com/components/espressif/esp*lcd*st77903*rgb) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*st77903*rgb/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*st77903*rgb) |
| [esp*lcd*st77916](https://components.espressif.com/components/espressif/esp*lcd*st77916) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*st77916/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*st77916) |
| [esp*lcd*st77922](https://components.espressif.com/components/espressif/esp*lcd*st77922) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*st77922/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*st77922) |
| [esp*lcd*touch*ili2118](https://components.espressif.com/components/espressif/esp*lcd*touch*ili2118) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*touch*ili2118/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*touch*ili2118) |
| [esp*lcd*touch*spd2010](https://components.espressif.com/components/espressif/esp*lcd*touch*spd2010) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*touch*spd2010/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*touch*spd2010) |
| [esp*lcd*touch*st7123](https://components.espressif.com/components/espressif/esp*lcd*touch*st7123) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*touch*st7123/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*touch*st7123) |
| [esp*lcd*usb*display](https://components.espressif.com/components/espressif/esp*lcd*usb*display) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lcd*usb*display/badge.svg)](https://components.espressif.com/components/espressif/esp*lcd*usb*display) |
| [esp*lv*decoder](https://components.espressif.com/components/espressif/esp*lv*decoder) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lv*decoder/badge.svg)](https://components.espressif.com/components/espressif/esp*lv*decoder) |
| [esp*lv*fs](https://components.espressif.com/components/espressif/esp*lv*fs) | [![Component Registry](https://components.espressif.com/components/espressif/esp*lv*fs/badge.svg)](https://components.espressif.com/components/espressif/esp*lv*fs) |
| [esp*mmap*assets](https://components.espressif.com/components/espressif/esp*mmap*assets) | [![Component Registry](https://components.espressif.com/components/espressif/esp*mmap*assets/badge.svg)](https://components.espressif.com/components/espressif/esp*mmap*assets) |
| [esp*msc*ota](https://components.espressif.com/components/espressif/esp*msc*ota) | [![Component Registry](https://components.espressif.com/components/espressif/esp*msc*ota/badge.svg)](https://components.espressif.com/components/espressif/esp*msc*ota) |
| [esp*sensorless*bldc*control](https://components.espressif.com/components/espressif/esp*sensorless*bldc*control) | [![Component Registry](https://components.espressif.com/components/espressif/esp*sensorless*bldc*control/badge.svg)](https://components.espressif.com/components/espressif/esp*sensorless*bldc*control) |
| [esp*simplefoc](https://components.espressif.com/components/espressif/esp*simplefoc) | [![Component Registry](https://components.espressif.com/components/espressif/esp*simplefoc/badge.svg)](https://components.espressif.com/components/espressif/esp*simplefoc) |
| [esp*tinyuf2](https://components.espressif.com/components/espressif/esp*tinyuf2) | [![Component Registry](https://components.espressif.com/components/espressif/esp*tinyuf2/badge.svg)](https://components.espressif.com/components/espressif/esp*tinyuf2) |
| [extended*vfs](https://components.espressif.com/components/espressif/extended*vfs) | [![Component Registry](https://components.espressif.com/components/espressif/extended*vfs/badge.svg)](https://components.espressif.com/components/espressif/extended*vfs) |
| [gprof](https://components.espressif.com/components/espressif/gprof) | [![Component Registry](https://components.espressif.com/components/espressif/gprof/badge.svg)](https://components.espressif.com/components/espressif/gprof) |
| [hdc2010](https://components.espressif.com/components/espressif/hdc2010) | [![Component Registry](https://components.espressif.com/components/espressif/hdc2010/badge.svg)](https://components.espressif.com/components/espressif/hdc2010) |
| [i2c*bus](https://components.espressif.com/components/espressif/i2c*bus) | [![Component Registry](https://components.espressif.com/components/espressif/i2c*bus/badge.svg)](https://components.espressif.com/components/espressif/i2c*bus) |
| [ina236](https://components.espressif.com/components/espressif/ina236) | [![Component Registry](https://components.espressif.com/components/espressif/ina236/badge.svg)](https://components.espressif.com/components/espressif/ina236) |
| [iot*eth](https://components.espressif.com/components/espressif/iot*eth) | [![Component Registry](https://components.espressif.com/components/espressif/iot*eth/badge.svg)](https://components.espressif.com/components/espressif/iot*eth) |
| [iot*usbh](https://components.espressif.com/components/espressif/iot*usbh) | [![Component Registry](https://components.espressif.com/components/espressif/iot*usbh/badge.svg)](https://components.espressif.com/components/espressif/iot*usbh) |
| [iot*usbh*cdc](https://components.espressif.com/components/espressif/iot*usbh*cdc) | [![Component Registry](https://components.espressif.com/components/espressif/iot*usbh*cdc/badge.svg)](https://components.espressif.com/components/espressif/iot*usbh*cdc) |
| [iot*usbh*ecm](https://components.espressif.com/components/espressif/iot*usbh*ecm) | [![Component Registry](https://components.espressif.com/components/espressif/iot*usbh*ecm/badge.svg)](https://components.espressif.com/components/espressif/iot*usbh*ecm) |
| [iot*usbh*modem](https://components.espressif.com/components/espressif/iot*usbh*modem) | [![Component Registry](https://components.espressif.com/components/espressif/iot*usbh*modem/badge.svg)](https://components.espressif.com/components/espressif/iot*usbh*modem) |
| [iot*usbh*rndis](https://components.espressif.com/components/espressif/iot*usbh*rndis) | [![Component Registry](https://components.espressif.com/components/espressif/iot*usbh*rndis/badge.svg)](https://components.espressif.com/components/espressif/iot*usbh*rndis) |
| [ir*learn](https://components.espressif.com/components/espressif/ir*learn) | [![Component Registry](https://components.espressif.com/components/espressif/ir*learn/badge.svg)](https://components.espressif.com/components/espressif/ir*learn) |
| [keyboard*button](https://components.espressif.com/components/espressif/keyboard*button) | [![Component Registry](https://components.espressif.com/components/espressif/keyboard*button/badge.svg)](https://components.espressif.com/components/espressif/keyboard*button) |
| [knob](https://components.espressif.com/components/espressif/knob) | [![Component Registry](https://components.espressif.com/components/espressif/knob/badge.svg)](https://components.espressif.com/components/espressif/knob) |
| [led*indicator](https://components.espressif.com/components/espressif/led*indicator) | [![Component Registry](https://components.espressif.com/components/espressif/led*indicator/badge.svg)](https://components.espressif.com/components/espressif/led*indicator) |
| [lightbulb*driver](https://components.espressif.com/components/espressif/lightbulb*driver) | [![Component Registry](https://components.espressif.com/components/espressif/lightbulb*driver/badge.svg)](https://components.espressif.com/components/espressif/lightbulb*driver) |
| [lis2dh12](https://components.espressif.com/components/espressif/lis2dh12) | [![Component Registry](https://components.espressif.com/components/espressif/lis2dh12/badge.svg)](https://components.espressif.com/components/espressif/lis2dh12) |
| [max17048](https://components.espressif.com/components/espressif/max17048) | [![Component Registry](https://components.espressif.com/components/espressif/max17048/badge.svg)](https://components.espressif.com/components/espressif/max17048) |
| [mcp23017](https://components.espressif.com/components/espressif/mcp23017) | [![Component Registry](https://components.espressif.com/components/espressif/mcp23017/badge.svg)](https://components.espressif.com/components/espressif/mcp23017) |
| [mcp3201](https://components.espressif.com/components/espressif/mcp3201) | [![Component Registry](https://components.espressif.com/components/espressif/mcp3201/badge.svg)](https://components.espressif.com/components/espressif/mcp3201) |
| [mvh3004d](https://components.espressif.com/components/espressif/mvh3004d) | [![Component Registry](https://components.espressif.com/components/espressif/mvh3004d/badge.svg)](https://components.espressif.com/components/espressif/mvh3004d) |
| [ntc*driver](https://components.espressif.com/components/espressif/ntc*driver) | [![Component Registry](https://components.espressif.com/components/espressif/ntc*driver/badge.svg)](https://components.espressif.com/components/espressif/ntc*driver) |
| [openai](https://components.espressif.com/components/espressif/openai) | [![Component Registry](https://components.espressif.com/components/espressif/openai/badge.svg)](https://components.espressif.com/components/espressif/openai) |
| [power*measure](https://components.espressif.com/components/espressif/power*measure) | [![Component Registry](https://components.espressif.com/components/espressif/power*measure/badge.svg)](https://components.espressif.com/components/espressif/power*measure) |
| [pwm*audio](https://components.espressif.com/components/espressif/pwm*audio) | [![Component Registry](https://components.espressif.com/components/espressif/pwm*audio/badge.svg)](https://components.espressif.com/components/espressif/pwm*audio) |
| [sensor*hub](https://components.espressif.com/components/espressif/sensor*hub) | [![Component Registry](https://components.espressif.com/components/espressif/sensor*hub/badge.svg)](https://components.espressif.com/components/espressif/sensor*hub) |
| [servo](https://components.espressif.com/components/espressif/servo) | [![Component Registry](https://components.espressif.com/components/espressif/servo/badge.svg)](https://components.espressif.com/components/espressif/servo) |
| [sht3x](https://components.espressif.com/components/espressif/sht3x) | [![Component Registry](https://components.espressif.com/components/espressif/sht3x/badge.svg)](https://components.espressif.com/components/espressif/sht3x) |
| [spi*bus](https://components.espressif.com/components/espressif/spi*bus) | [![Component Registry](https://components.espressif.com/components/espressif/spi*bus/badge.svg)](https://components.espressif.com/components/espressif/spi*bus) |
| [touch*button](https://components.espressif.com/components/espressif/touch*button) | [![Component Registry](https://components.espressif.com/components/espressif/touch*button/badge.svg)](https://components.espressif.com/components/espressif/touch*button) |
| [touch*button*sensor](https://components.espressif.com/components/espressif/touch*button*sensor) | [![Component Registry](https://components.espressif.com/components/espressif/touch*button*sensor/badge.svg)](https://components.espressif.com/components/espressif/touch*button*sensor) |
| [touch*proximity*sensor](https://components.espressif.com/components/espressif/touch*proximity*sensor) | [![Component Registry](https://components.espressif.com/components/espressif/touch*proximity*sensor/badge.svg)](https://components.espressif.com/components/espressif/touch*proximity*sensor) |
| [touch*slider*sensor](https://components.espressif.com/components/espressif/touch*slider*sensor) | [![Component Registry](https://components.espressif.com/components/espressif/touch*slider*sensor/badge.svg)](https://components.espressif.com/components/espressif/touch*slider*sensor) |
| [usb*device*uac](https://components.espressif.com/components/espressif/usb*device*uac) | [![Component Registry](https://components.espressif.com/components/espressif/usb*device*uac/badge.svg)](https://components.espressif.com/components/espressif/usb*device*uac) |
| [usb*device*uvc](https://components.espressif.com/components/espressif/usb*device*uvc) | [![Component Registry](https://components.espressif.com/components/espressif/usb*device*uvc/badge.svg)](https://components.espressif.com/components/espressif/usb*device*uvc) |
| [usb*stream](https://components.espressif.com/components/espressif/usb*stream) | [![Component Registry](https://components.espressif.com/components/espressif/usb*stream/badge.svg)](https://components.espressif.com/components/espressif/usb*stream) |
| [veml6040](https://components.espressif.com/components/espressif/veml6040) | [![Component Registry](https://components.espressif.com/components/espressif/veml6040/badge.svg)](https://components.espressif.com/components/espressif/veml6040) |
| [veml6075](https://components.espressif.com/components/espressif/veml6075) | [![Component Registry](https://components.espressif.com/components/espressif/veml6075/badge.svg)](https://components.espressif.com/components/espressif/veml6075) |
| [xz](https://components.espressif.com/components/espressif/xz) | [![Component Registry](https://components.espressif.com/components/espressif/xz/badge.svg)](https://components.espressif.com/components/espressif/xz) |
| [zero*detection](https://components.espressif.com/components/espressif/zero*detection) | [![Component Registry](https://components.espressif.com/components/espressif/zero*detection/badge.svg)](https://components.espressif.com/components/espressif/zero*detection) |

</center>

You can directly add the components from the Component Registry to your project by using the `idf.py add-dependency` command under your project's root directory. eg run `idf.py add-dependency "espressif/usb*stream"` to add the `usb*stream`, the component will be downloaded automatically during the `CMake` step.

> Please refer to [IDF Component Manager](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/tools/idf-component-manager.html) for details.

#### Get ESP-IoT-Solution Repository

If you want to [Contribute](https://docs.espressif.com/projects/esp-iot-solution/zh_CN/latest/contribute/index.html) to the components in ESP-IoT-Solution or want to start from the examples in ESP-IoT-Solution, you can get the ESP-IoT-Solution repository by following the steps:

* If select the `master` version, open the terminal, and run the following command:

    ```
    git clone --recursive https://github.com/espressif/esp-iot-solution
    ```

* If select the `release/v2.0` version, open the terminal, and run the following command:

    ```
    git clone -b release/v2.0 --recursive https://github.com/espressif/esp-iot-solution
    ```

#### Build and Flash Examples

**We highly recommend** you [Build Your First Project](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html#build-your-first-project) to get familiar with ESP-IDF and make sure the environment is set up correctly.

There is no difference between building and flashing the examples in ESP-IoT-Solution and in ESP-IDF. In most cases, you can build and flash the examples in ESP-IoT-Solution by following the steps:

1. Change the current directory to the example directory, eg `cd examples/usb/host/usb*audio*player`.
2. Run `idf.py set-target TARGET` to set the target chip. eg `idf.py set-target esp32s3` to set the target chip to ESP32-S3.
3. Run `idf.py build` to build the example.
4. Run `idf.py -p PORT flash monitor` to flash the example, and view the serial output. eg `idf.py -p /dev/ttyUSB0 flash monitor` to flash the example and view the serial output on `/dev/ttyUSB0`.

> Some examples may need extra steps to setup the ESP-IoT-Solution environment, you can run `export IOT*SOLUTION*PATH=~/esp/esp-iot-solution` in Linux/MacOS or `set IOT*SOLUTION*PATH=C:\esp\esp-iot-solution` in Windows to setup the environment.

### Resources

- Documentation for the latest version: https://docs.espressif.com/projects/esp-iot-solution/ . This documentation is built from the [docs directory](./docs) of this repository.
- ESP-IDF Programming Guide: https://docs.espressif.com/projects/esp-idf/zh_CN . Please refer to the version ESP-IoT-Solution depends on.
- The [IDF Component Registry](https://components.espressif.com/) is where you can find the components in ESP-IoT-Solution and other registered components.
- The [esp32.com forum](https://www.esp32.com/) is a place to ask questions and find community resources.
- [Check the Issues section on GitHub](https://github.com/espressif/esp-iot-solution/issues) if you find a bug or have a feature request. Please check existing Issues before opening a new one.
- If you're interested in contributing to ESP-IDF, please check the [Contributions Guide](./CONTRIBUTING.rst).
