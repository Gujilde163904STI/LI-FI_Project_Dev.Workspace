## Pin
In order to use system IO, such as GPIO, PWM and ADC you need to know the pin name.
The `stm32f4dis` module has pin object which is designed to find a pin name easier.

**Example**

```js

var pin = require('stm32f4dis').pin;

```

### GPIO Pin
P[port][pin]

A configured GPIO pin.

The `port` must be equal to a capital letter from 'A' to 'D'.

The `pin` must be equal to an integer from 0 to 15.

**Example**

```js

var gpio = require('gpio');
var pin = require('stm32f4dis').pin;

gpio.open(pin.PD6);

```

### PWM Pin
PWM[timer].CH[channel]_[number]

A configured PWM pin.

The `timer` must be equal to an integer from 1 to 14.

The `channel` must be equal to an integer from 1 to 4, but it also depends on the `timer`.

The `number` must be equal to an integer form 1 to 2, and 3 in case of PWM3.CH1*3, PWM3.CH2*3 and PWM2.CH1_3.

**Example**

```js

var pwm = require('pwm');
var pin = require('stm32f4dis').pin;

var pwm2 = new pwm(pin.PWM2.CH1_2);

```

The following table shows the available PWM pin names and their corresponding
 GPIO pins.

| PWM Pin Name | GPIO Name | PWM Pin Name | GPIO Name|
| :---: | :---: | :---: | :---: |
| PWM1.CH1*1 | PA8 | PWM4.CH1*1| PB6 |
| PWM1.CH1*2 | PE9 | PWM4.CH1*2| PD12 |
| PWM1.CH2*1 | PA9 | PWM4.CH2*1| PB7 |
| PWM1.CH2*2 | PE11 | PWM4.CH2*2| PD13 |
| PWM1.CH3*1 | PA10 | PWM4.CH3*1| PB8 |
| PWM1.CH3*2 | PE13 | PWM4.CH3*2| PD14 |
| PWM1.CH4*1 | PA11 | PWM4.CH4*1| PB9 |
| PWM1.CH4*2 | PE14 | PWM4.CH4*2| PD15 |
| PWM2.CH1*1| PA0 | PWM5.CH1*1| PA0 |
| PWM2.CH1*2| PA15 | PWM5.CH2*1| PA1 |
| PWM2.CH1*3| PA5 | PWM5.CH3*1| PA2 |
| PWM2.CH2*1| PA1 | PWM5.CH4*1| PA3 |
| PWM2.CH2*2| PB3 | PWM8.CH1*1| PC6 |
| PWM2.CH3*1| PA2| PWM8.CH2*1| PC7|
| PWM2.CH3*2| PB10| PWM8.CH3*1| PC8|
| PWM2.CH4*1| PA3 | PWM8.CH4*1| PC9 |
| PWM2.CH4*2| PB11 | PWM9.CH1*1 | PA2 |
| PWM3.CH1*1 | PA6 | PWM9.CH1*2 | PE5 |
| PWM3.CH1*2 | PB4 | PWM9.CH2*1 | PA3 |
| PWM3.CH1*3 | PC6 | PWM9.CH2*2 | PE6 |
| PWM3.CH2*1 | PA7 | PWM10.CH1*1 | PB8 |
| PWM3.CH2*2 | PB5 | PWM11.CH1*1 | PB9 |
| PWM3.CH2*3 | PC7 | PWM12.CH1*2 | PB14 |
| PWM3.CH3*1 | PA11 | PWM12.CH2*1 | PB15 |
| PWM3.CH3*2 | PE14 | PWM13.CH1*1 | PA6 |
| PWM3.CH4*1 | PB1 | PWM14.CH1*1 | PA7 |
| PWM3.CH4_2 | PC9 | | |

### ADC Pin
ADC[number]_[timer]

A configured ADC pin.

The `number`  must be equal to an integer from 1 to 3.

The `timer` must be equal to an integer from 0 to 15.

**Example**

```js

var adc = require('adc');
var pin = require('stm32f4dis').pin;

var adc1 = new adc(pin.ADC1_3);

```

The following table shows the available ADC pin names and their corresponding
 GPIO pins.

| ADC Pin Name | GPIO Name |
| :--- | :---: |
| ADC1*0, ADC2*0, ADC3_0 | PA0 |
| ADC1*1, ADC2*1, ADC3_1 | PA1 |
| ADC1*2, ADC2*2, ADC3_2 | PA2 |
| ADC1*3, ADC2*3, ADC3_3 | PA3 |
| ADC1*4, ADC2*4 | PA4 |
| ADC1*5, ADC2*5 | PA5 |
| ADC1*6, ADC2*6 | PA6 |
| ADC1*7, ADC2*7 | PA7 |
| ADC1*8, ADC2*8 | PB0 |
| ADC1*9, ADC2*9 | PB1 |
| ADC1*10, ADC2*10, ADC3_10 | PC0 |
| ADC1*11, ADC2*11, ADC3_11 | PC1 |
| ADC1*12, ADC2*12, ADC3_12 | PC2 |
| ADC1*13, ADC2*13, ADC3_13 | PC3 |
| ADC1*14, ADC2*14 | PC4 |
| ADC1*15, ADC2*15 | PC5 |

## UART Port Information

In order to use the UART on stm32f4-discovery board, you must use proper pins.

The stm32f4-discovery board supports 4 UART ports, such as USART2, USART3, UART5, USART6.
The UART5 port and the SDIO uses the same pin for connection. SDIO is enabled by default, so be careful when you enable the UART5 port.

The following table shows the U[S]ART pin map:

| U[S]ART Pin Name | GPIO Name |
| :--- | :---: |
| USART2_RX | PA3 |
| USART2_TX | PA2 |
| USART3_RX | PB11 |
| USART3_TX | PB10 |
| UART5_RX | PD2 |
| UART5_TX | PC12 |
| USART6_RX | PC7 |
| USART6_TX | PC6 |

Note: The name of the UART device cannot find by the `stm32f4dis.pin` module, because it can be changed in the NuttX configuration file. It should be '/dev/ttyS[0-3]'.

### Enable USART1 and UART4

The current version of the NuttX does not support the USART1 and UART4 ports for stm32f4-discovery board.

The `config/nuttx/stm32f4dis/patch` file contains the implementations of the the USART1 and UART4 ports. It maps the PB6 and PB7 gpio pins to USART1*TX and USART2*RX, PA0 and PA1 gpio pins to UART4*TX and UART4*RX respectively.

Note: You can add more ports according to the patch file.

**Apply the patch**

```bash

~/workspace/nuttx$ patch -p1 < ../iotjs/config/nuttx/stm32f4dis/patch

```

## I2C Port Information

In order to use the I2C on stm32f4-discovery board, you must use proper pins.
Currently only I2C1 is supported.

The following table shows the I2C pin map:

| I2C Pin Name | GPIO Name |
| :--- | :---: |
| I2C1_SCL | PB8 |
| I2C1_SDA | PB7 |


## SPI Bus Information

The following table shows currently supported SPI pin number list.
Currently only SPI1 is supported.

| SPI Pin Name | GPIO Name |
| :--- | :---: |
| SPI1_SCK | PA5 |
| SPI1_MISO | PA6 |
| SPI1_MOSI | PA7 |
| SPI1_NSS | PA15 |