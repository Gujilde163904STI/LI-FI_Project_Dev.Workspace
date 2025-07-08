# mpu*noexec*ram

Tests for the `pmp*noexec*ram` pseudomodule.
Only supported on RISC-V devices with PMP.

## Output

With `USEMODULE += pmp*noexec*ram` in `Makefile` this application should
execute a kernel panic, stating `Instruction access fault` (0x01) in the
`mcause` register. Without this pseudomodule activated, the hard fault
will be triggered by `Illegal instruction` (0x02) instead.
