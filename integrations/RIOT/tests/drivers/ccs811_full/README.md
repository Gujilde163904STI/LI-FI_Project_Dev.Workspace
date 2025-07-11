# AMS CCS811 device driver test application

## About

This is a manual test application for the CCS811 driver. It shows how the
sensor can be used with interrupts.

**Please note:** The interrupt pin has to be defined for this test application.

## Usage

The test application demonstrates the use of the CCS811 and pseudomodule
`ccs811_full` using

- data-ready interrupt `CCS811*INT*DATA_READY` and
- default configuration parameters, that is, the measurement mode
  `CCS811*MODE*1S` with one measurement per second.

The default configuration parameter for the interrupt pin has to be
overridden according to the hardware configuration by defining
`CCS811*PARAM*INT*PIN` before `ccs811*params.h` is included, e.g.,
```
#define CCS811_PARAM_INT_PIN     (GPIO_PIN(0, 7))
```
or via the `CFLAGS` variable in the make command.
```
CFLAGS="-DCCS811_PARAM_INT_PIN=GPIO_PIN\(0,7\)" make -C tests/drivers/ccs811_full BOARD=...
```
