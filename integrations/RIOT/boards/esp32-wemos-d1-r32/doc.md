@defgroup    boards*esp32*wemos*d1*r32 Wemos D1 R32 (ESPDuino-32)
@ingroup     boards_esp32
@brief       Support for the Wemos D1 R32 (ESPDuino-32) board
@author      Gunar Schorcht <gunar@schorcht.net>

\section esp32*wemos*d1_r32 Wemos D1 R32 board (ESPDuino-32)

## Table of Contents {#esp32*wemos*d1*r32*toc}

-# [Overview](#esp32*wemos*d1*r32*overview)
-# [Hardware](#esp32*wemos*d1*r32*hardware)
    -# [MCU](#esp32_wemos_d1_r32_mcu)
    -# [Board Configuration](#esp32_wemos_d1_r32_board_configuration)
    -# [Board Pinout](#esp32_wemos_d1_r32_pinout)
-# [Flashing the Device](#esp32*wemos*d1*r32*flashing)

## Overview {#esp32*wemos*d1*r32*overview}

The Wemos D1 R32 board is an ESP32 board in the Arduino Uno format that uses the
ESP32-WROOM-32 module. It is exactly the same board that is also known as
ESPDuino-32 on the market. The board is pin compatible with the Arduino Uno
board. The peripheral configuration corresponds to the Arduino Uno pinout and
guaranties the compatibility with Arduino Uno Shields.

\image html "https://makerselectronics.com/wp-content/uploads/2022/09/wemos-d1-r32-w-esp32-uno-r3-pinout-1-800x800.jpg.webp" "WeMos D1 R32 ESPDuino32" width=400px

[Back to table of contents](#esp32*wemos*d1*r32*toc)

## Hardware {#esp32*wemos*d1*r32*hardware}

This section describes

- the [MCU](#esp32*wemos*d1*r32*mcu),
- the [board configuration](#esp32*wemos*d1*r32*board_configuration),
- the [board pinout](#esp32*wemos*d1*r32*pinout).

[Back to table of contents](#esp32*wemos*d1*r32*toc)

### MCU {#esp32*wemos*d1*r32*mcu}

Most features of the board are provided by the ESP32 SoC. For detailed
information about the ESP32, see section \ref esp32*mcu*esp32 "MCU ESP32".

[Back to table of contents](#esp32*wemos*d1*r32*toc)

### Board Configuration {#esp32*wemos*d1*r32*board_configuration}

The board configuration guarantees that the board is compatible with Arduino
Uno Shield. The board configuration provides:

- 6 x ADC channels
- 2 x DAC channels
- 2 x PWM devices with a total of 7 channels
- 1 x SPI device
- 1 x I2C device
- 2 x UART devices

The following table shows the default board configuration, which is sorted
according to the defined functionality of GPIOs.

<center>
Function        | GPIOs  | Arduino Pin |Configuration
:---------------|:-------|:------------|:----------------------------------
ADC*LINE(0)     | GPIO2  | A0          | \ref esp32*adc_channels "ADC Channels"
ADC*LINE(1)     | GPIO4  | A1          | \ref esp32*adc_channels "ADC Channels"
ADC*LINE(2)     | GPIO35 | A2          | \ref esp32*adc_channels "ADC Channels"
ADC*LINE(3)     | GPIO34 | A3          | \ref esp32*adc_channels "ADC Channels"
ADC*LINE(4)     | GPIO36 | A4          | \ref esp32*adc_channels "ADC Channels"
ADC*LINE(5)     | GPIO39 | A5          | \ref esp32*adc_channels "ADC Channels"
DAC*LINE(0)     | GPIO25 | D3          | \ref esp32*pwm_channels "DAC Channels"
DAC*LINE(1)     | GPIO26 | D2          | \ref esp32*pwm_channels "DAC Channels"
I2C*DEV(0):SDA  | GPIO21 | SDA         | \ref esp32*i2c_interfaces "I2C Interfaces"
I2C*DEV(0):SCL  | GPIO22 | SCL         | \ref esp32*i2c_interfaces "I2C Interfaces"
LED             | GPIO2  | A0          | -
PWM*DEV(0):0    | GPIO25 | D3          | \ref esp32*pwm_channels "PWM Channels"
PWM*DEV(0):1    | GPIO16 | D5          | \ref esp32*pwm_channels "PWM Channels"
PWM*DEV(0):2    | GPIO27 | D6          | \ref esp32*pwm_channels "PWM Channels"
PWM*DEV(0):3    | GPIO13 | D9          | \ref esp32*pwm_channels "PWM Channels"
PWM*DEV(0):4    | GPIO2  | A0          | \ref esp32*pwm_channels "PWM Channels"
PWM*DEV(1):0    | GPIO5  | D10         | \ref esp32*pwm_channels "PWM Channels"
PWM*DEV(1):1    | GPIO23 | D11         | \ref esp32*pwm_channels "PWM Channels"
SPI*DEV(0):CLK  | GPIO18 | D13         | \ref esp32*spi_interfaces "SPI Interfaces"
SPI*DEV(0):MISO | GPIO19 | D12         | \ref esp32*spi_interfaces "SPI Interfaces"
SPI*DEV(0):MOSI | GPIO23 | D11         | \ref esp32*spi_interfaces "SPI Interfaces"
SPI*DEV(0):CS0  | GPIO5  | D10         | \ref esp32*spi_interfaces "SPI Interfaces"
UART*DEV(0):TxD | GPIO1  | D1          | \ref esp32*uart_interfaces "UART interfaces"
UART*DEV(0):RxD | GPIO3  | D0          | \ref esp32*uart_interfaces "UART interfaces"
UART*DEV(1):TxD | GPIO10 | D4          | \ref esp32*uart_interfaces "UART interfaces"
UART*DEV(1):RxD | GPIO9  | D5          | \ref esp32*uart_interfaces "UART interfaces"
</center>
\n

For detailed information about the configuration of ESP32 boards, see
section \ref esp32_peripherals "Common Peripherals".

[Back to table of contents](#esp32*wemos*d1*r32*toc)

### Board Pinout {#esp32*wemos*d1*r32*pinout}

The following figure shows the pinout of the Wemos D1 R32 board. It is exactly
the same as for the ESPDuino-32 board. The corresponding board schematics can
be found
[here](https://gitlab.com/gschorcht/RIOT.wiki-Images/raw/master/esp32/Wemos-D1-R32_Schematic.pdf).

@image html "https://makerselectronics.com/wp-content/uploads/2022/09/2*Pinout*D1_R32.png.webp" "Wemos D1 R32 ESPDuino Pinout"

@warning The pinout contains the following errors.
         Analog Arduino pin A2 with white label `IO36` is actually ADC1 Channel7
         that is connected to GPIO35 and analog Arduino pin A4 with white label
         `IO38` is actually ADC1 Channel0 that is connected to GPIO36. That is
         the colored labels are correct in the pinout.

[Back to table of contents](#esp32*wemos*d1*r32*toc)

## Flashing the Device {#esp32*wemos*d1*r32*flashing}

Flashing RIOT is quite easy. The board has a Micro-USB connector with
reset/boot/flash logic. Just connect the board to your host computer
and type using the programming port:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
make flash BOARD=esp32-wemos-d1-r32 ...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
For detailed information about ESP32 as well as configuring and compiling
RIOT for ESP32 boards, see \ref esp32_riot.

[Back to table of contents](#esp32*wemos*d1*r32*toc)
