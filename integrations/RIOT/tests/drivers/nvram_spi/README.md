# About
This is a manual test application for the SPI NVRAM driver.

# Usage
This test application will initialize the SPI bus and NVRAM device with the
following parameters:

 - Baudrate: 10 MHz (overridable by setting TEST*NVRAM*SPI_SPEED)
 - SPI config: SPI*CONF*FIRST*RISING (overridable by setting TEST*NVRAM*SPI*CONF)

The memory will be overwritten by the test application. The original contents
will not be restored after the test.
