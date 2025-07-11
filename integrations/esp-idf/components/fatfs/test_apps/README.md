| Supported Targets | ESP32 | ESP32-C2 | ESP32-C3 | ESP32-C5 | ESP32-C6 | ESP32-C61 | ESP32-H2 | ESP32-P4 | ESP32-S2 | ESP32-S3 |
| ----------------- | ----- | -------- | -------- | -------- | -------- | --------- | -------- | -------- | -------- | -------- |

# fatfs component target tests

This directory contains tests for `fatfs` component which are run on chip targets.

See also [test*fatfs*host](../test*fatfs*host) directory for the tests which run on a Linux host.

Fatfs tests can be executed with different `diskio` backends: `diskio*sdmmc` (SD cards over SD or SPI interface), `diskio*spiflash` (wear levelling in internal flash) and `diskio_rawflash` (read-only, no wear levelling, internal flash). There is one test app here for each of these backends:

- [sdcard](sdcard/) — runs fatfs tests with an SD card over SDMMC or SDSPI interface
- [flash*wl](flash*wl/) - runs fatfs test in a wear_levelling partition in SPI flash
- [flash*ro](flash*ro/) - runs fatfs test in a read-only (no wear levelling) partition in SPI flash
- [dyn*buffers](dyn*buffers/) - check if enabling dynamic buffers in FATFS has an effect

These test apps define:
- test functions
- setup/teardown routines
- build/test configurations
- pytest test runners

The actual test cases (many of which are common between the test apps) are defined in the [test*fatfs*common component](test*fatfs*common/).
