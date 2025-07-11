# Decawave uwb-dw1000 RIOT Port

The distribution https://github.com/decawave/uwb-core contains the
device driver implementation for the Decawave Impulse Radio-Ultra
Wideband (IR-UWB) transceiver(s). The driver includes hardware abstraction
layers (HAL), media access control (MAC) layer, Ranging Services (RNG).

## Abstraction details

uwb-dw1000 is meant as a hardware and architecture agnostic driver. It
was developed with MyNewt as its default OS, but its abstractions are
well defined which makes it easy to use with another OS.

A porting layer DPL (Decawave Porting Layer) has been implemented that
wraps around OS functionalities and modules: mutex, semaphores, threads,
etc.. In most cases the mapping is direct although some specific
functionalities might not be supported. This layer is found in the uwb-core
pkg.

A hardware abstraction layer is defined under `hal` which wraps around
modules such as: periph*gpio, periph*spi, etc.

Since the library was used on top of mynewt most configuration values
are prefixed with `MYNEWT*VAL*%`, all configurations can be found under
`pkg/uwb-dw1000/include/syscfg`.

## Todos

The uwb-dw1000 can be used to provide a netdev driver for the dw1000
module.

uwb-dw1000 repository uses fixed length arrays to keep track of the
devices that are present. This port uses linked list but some of the
upstream code is not compatible with this.
