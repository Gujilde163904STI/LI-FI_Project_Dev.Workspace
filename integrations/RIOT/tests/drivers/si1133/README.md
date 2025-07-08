# Si1133 driver test

Test application for the Silicon Labs Si1133 I2C device.

## Usage

This test will initialize the Si1133 device defined in the `si1133_params.h`
header, which can be override by the board or in CLFAGS by setting the following
macros:

 * `SI1133*PARAM*I2C*DEV` the I2C device to use, by default `I2C*DEV(0)`.
 * `SI1133*PARAM*ADDR` the I2C address of the Si1133, either 0x52 or 0x55.

The automated test checks that the Si1133 responds and all sensor values can be
read in blocking mode.
