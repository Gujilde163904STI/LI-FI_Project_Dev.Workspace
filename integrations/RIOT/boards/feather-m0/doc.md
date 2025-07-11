@defgroup    boards_feather-m0 Adafruit Feather M0
@ingroup     boards
@brief       Support for the Adafruit Feather M0.

### General information

Feather M0 boards are development boards shipped by
[Adafruit](https://learn.adafruit.com/adafruit-feather-m0-basic-proto/).

All the feather M0 boards are built based on the same Atmel SAMD21G18A
microcontroller. See @ref cpu_samd21.

Several types of Feather M0 boards exist:
- [Feather M0 WiFi](https://learn.adafruit.com/adafruit-feather-m0-wifi-atwinc1500/)
- [Feather M0 BLE](https://learn.adafruit.com/adafruit-feather-m0-bluefruit-le/overview)
- [Feather M0 Adalogger](https://learn.adafruit.com/adafruit-feather-m0-adalogger/)
- [Feather M0 LoRa](https://learn.adafruit.com/adafruit-feather-m0-radio-with-lora-radio-module)

The different modules used to differentiate the boards (ATWINC1500 WiFi,
Bluefruit LE, SD card, LoRa) are connected via SPI (SPI_DEV(0)) to the
SAMD21 mcu.

### Pinout

<img src="https://cdn-learn.adafruit.com/assets/assets/000/030/921/original/adafruit*products*2772*pinout*v1_0.png"
     alt="Adafruit Feather M0 proto pinout" style="width:800px;"/><br/>

`AIN7` can be used to [measure the voltage of a connected Lipoly battery][battery].
It is mapped to ADC_LINE(6) in RIOT.

~~~~~~~~~~~~~~~~ {.c}
int vbat = adc*sample(ADC*LINE(6), ADC*RES*10BIT);
vbat *= 2;      /* voltage was divided by 2, so multiply it back */
vbat *= 33;     /* reference voltage 3.3V * 10 */
vbat /= 10240;  /* resolution * 10 (because we multiplied 3.3V by 10) */
printf("Bat: %dV\n", vbat);
~~~~~~~~~~~~~~~~

[battery]: https://learn.adafruit.com/adafruit-feather-m0-basic-proto/power-management#measuring-battery-4-9

### Flash the board

Use `BOARD=feather-m0` with the `make` command.<br/>
Example with `hello-world` application:
```
     make BOARD=feather-m0 -C examples/basic/hello-world flash
```

@note     If the application crashes, automatic reflashing via USB, as explained
          above won't be possible. In this case, the board must be set in
          bootloader mode by double tapping the reset button before running the
          flash command.

@note     Adafruit changed the bootloader from the old BOSSA bootloader to the
          more modern UF2 bootloader around 2018. If you have a very old board,
          it is recommended to upgrade the bootloader to the new UF2
          bootloader. Otherwise the bootloader has to be enabled by double
          tapping the reset button.<br/>
          Upgrade instructions can be found at Adafruit:
          https://learn.adafruit.com/installing-circuitpython-on-samd21-boards/installing-the-uf2-bootloader

### Using the WiFi interface

To enable the WiFi interface of the Feather M0 WiFi variant of the board
automatically for networking applications, use `feather-m0-wifi` as board
and define the required WiFi parameters, for example:
```
     CFLAGS='-DWIFI_SSID=\"<ssid>\" -DWIFI_PASS=\"<pass>\"' \
     make BOARD=feather-m0-wifi -C examples/networking/gnrc/gnrc_networking
```

For detailed information about the parameters, see section
@ref drivers_atwinc15x0.

### Using with LoRa module

To enable the LoRa module available on the
[Feather M0 LoRa](https://learn.adafruit.com/adafruit-feather-m0-radio-with-lora-radio-module)
variant of the board automatically for LoRa applications,
use `feather-m0-lora` as board:

```
make BOARD=feather-m0-lora -C examples/networking/gnrc/gnrc_lorawan
```

For detailed information about the parameters, see section
@ref drivers_sx127x.

### Accessing STDIO via UART

STDIO of RIOT is directly available over the USB port.

The `TERM_DELAY` environment variable can be used to add a delay (in second)
before opening the serial terminal. The default value is 2s which should be
enough in most of the situation.
