Expected result
===============
You should be presented with the RIOT shell, providing you with commands to initialize a board
as master or slave, and to send and receive data via SPI.

Background
==========
Test for the low-level SPI driver.

## Default SPI CS pin

To overwrite the optional default cs pin CFLAGS can be used:

`CFLAGS="-DDEFAULT*SPI*CS*PORT=<my*port*int> -DDEFAULT*SPI*CS*PIN=<my*pin*int>" BOARD=<my_board> make flash term`
