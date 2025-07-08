# mpu*noexec*ram

Tests for the `mpu*noexec*ram` pseudomodule. As this module is currently
only supported on Cortex M devices, the test case is a bit ARM specific.

## Output

With `USEMODULE += mpu*noexec*ram` in `Makefile` this application should
execute a kernel panic from the `MEM MANAGE HANDLER`. Without this
pseudomodule activated, it will run into a hard fault.
