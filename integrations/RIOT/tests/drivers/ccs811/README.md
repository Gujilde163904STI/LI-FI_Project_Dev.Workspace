# AMS CCS811 device driver test application

## About

This is a manual test application for the CCS811 driver. It shows how the
sensor can be used for periodic polling.

## Usage

The test application demonstrates the use of the CCS811 using

- data-ready status function `ccs811*data*ready` to wait for new data and
- default configuration parameters, that is, the measurement mode
  `CCS811*MODE*1S` with one measurement per second.

Please refer `$(RIOTBASE)/tests/drivers/ccs811_full` to learn how
to use the CCS811 with interrupts.
