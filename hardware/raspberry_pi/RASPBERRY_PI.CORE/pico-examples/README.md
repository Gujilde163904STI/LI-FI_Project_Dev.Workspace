# Raspberry Pi Pico SDK Examples

## Getting started

See [Getting Started with the Raspberry Pi Pico](https://rptl.io/pico-get-started) and the README in the [pico-sdk](https://github.com/raspberrypi/pico-sdk) for information
on getting up and running.

##### Notes on different boards and platforms (RP2040 / RP2350) 

The majority of examples are applicable to both RP2040 and RP2350 based boards,
however certain examples that use chip-specific functionality will only build on that platform.
Similarly, Wi-Fi and Bluetooth examples will only build on a board that includes Wi-Fi and Bluetooth support.

Platform and board information are passed to the CMake build via the `PICO*PLATFORM` and `PICO*BOARD` variables.

By default, the Pico SDK targets builds for RP2040 (`PICO_PLATFORM=rp2040`). To build for RP2350 instead, pass
`-DPICO*PLATFORM=rp2350` to CMake (or `-DPICO*PLATFORM=rp2350-riscv` for RISC-V). Alternatively, in many cases, you can rely
on the board configuration to set the platform for you. For example, passing `-DPICO*BOARD=pico2` will automatically select `PICO*PLATFORM=rp2350`.

For more information see the "Platform and Board Configuration" chapter of 
the [Raspberry Pi Pico-series C/C++ SDK](https://rptl.io/pico-c-sdk) book.

Information on which examples are not being built is displayed during the CMake configuration step.

### First Examples

App| Description                                                                | Link to prebuilt UF2
---|----------------------------------------------------------------------------|---
[hello*serial](hello*world/serial) | The obligatory Hello World program for Pico (Output over serial version)   |
[hello*usb](hello*world/usb) | The obligatory Hello World program for Pico (Output over USB version)      | https://rptl.io/pico-hello-usb
[blink](blink) | Blink a LED on and off. Works on both boards with regular LEDs and boards like Pico W where the led is connected via the Wi-Fi chip | https://rptl.io/pico-blink
[blink*simple](blink*simple) | Blink a LED on and off. Does not work on boards like Pico W where the led is connected via the Wi-Fi chip. | https://rptl.io/pico-blink
[picow*blink](pico*w/wifi/blink) | Blinks the on-board LED on boards like Pico W where the led is connected via the Wi-Fi chip. | http://rptl.io/pico-w-blink

### ADC

App|Description
---|---
[hello*adc](adc/hello*adc) | Display the voltage from an ADC input.
[joystick*display](adc/joystick*display) | Display a Joystick X/Y input based on two ADC inputs.
[adc*console](adc/adc*console) | An interactive shell for playing with the ADC. Includes example of free-running capture mode.
[onboard*temperature](adc/onboard*temperature) | Display the value of the onboard temperature sensor.
[microphone*adc](adc/microphone*adc) | Read analog values from a microphone and plot the measured sound amplitude.
[dma*capture](adc/dma*capture) | Use the DMA to capture many samples from the ADC.
[read*vsys](adc/read*vsys) | Demonstrates how to read VSYS to get the voltage of the power supply.

### Binary Info

App|Description
---|---
[blink*any](binary*info/blink*any) | Uses `bi*ptr` variables to create a configurable blink binary - see the separate [README](binary_info/README.md) for more details
[hello*anything](binary*info/hello*anything) | Uses `bi*ptr` variables to create a configurable hello*world binary - see the separate [README](binary*info/README.md) for more details

### Bootloaders (RP235x Only)
App|Description
---|---
[enc_bootloader](bootloaders/encrypted) | A bootloader which decrypts binaries from flash into SRAM. See the separate [README](bootloaders/encrypted/README.md) for more information

### Clocks

App|Description
---|---
[hello*48MHz](clocks/hello*48MHz) | Change the system clock frequency to 48 MHz while running.
[hello*gpout](clocks/hello*gpout) | Use the general purpose clock outputs (GPOUT) to drive divisions of internal clocks onto GPIO outputs.
[hello*resus](clocks/hello*resus) | Enable the clock resuscitate feature, "accidentally" stop the system clock, and show how we recover.
[detached*clk*peri](clocks/detached*clk*peri) | Detach peripheral clock and vary system clock.

### CMake

App|Description
---|---
[build*variants](cmake/build*variants) | Builds two version of the same app with different configurations

### DCP (RP235x Only)

App|Description
---|---
[hello*dcp](dcp/hello*dcp) | Use the double-precision coprocessor directly in assembler.

### DMA

App|Description
---|---
[hello*dma](dma/hello*dma) | Use the DMA to copy data in memory.
[control*blocks](dma/control*blocks) | Build a control block list, to program a longer sequence of DMA transfers to the UART.
[channel*irq](dma/channel*irq) | Use an IRQ handler to reconfigure a DMA channel, in order to continuously drive data through a PIO state machine.
[sniff*crc](dma/sniff*crc) | Use the DMA engine's 'sniff' capability to calculate a CRC32 on a data buffer.

### HSTX (RP235x Only)

App|Description
---|---
[dvi*out*hstx*encoder](hstx/dvi*out*hstx*encoder) | Use the HSTX to output a DVI signal with 3:3:2 RGB

### Flash

App|Description
---|---
[cache*perfctr](flash/cache*perfctr) | Read and clear the cache performance counters. Show how they are affected by different types of flash reads.
[nuke](flash/nuke) | Obliterate the contents of flash. An example of a NO_FLASH binary (UF2 loaded directly into SRAM and runs in-place there). A useful utility to drag and drop onto your Pico if the need arises.
[program](flash/program) | Erase a flash sector, program one flash page, and read back the data.
[xip*stream](flash/xip*stream) | Stream data using the XIP stream hardware, which allows data to be DMA'd in the background whilst executing code from flash.
[ssi*dma](flash/ssi*dma) | DMA directly from the flash interface (continuous SCK clocking) for maximum bulk read performance.
[runtime*flash*permissions](flash/runtime*flash*permissions) | Demonstrates adding partitions at runtime to change the flash permissions

### FreeRTOS

These examples require you to set the `FREERTOS*KERNEL*PATH` to point to the FreeRTOS Kernel. See https://github.com/FreeRTOS/FreeRTOS-Kernel

App|Description
---|---
[hello*freertos](freertos/hello*freertos) | Examples that demonstrate how run FreeRTOS and tasks on 1 or 2 cores.

### GPIO

App|Description
---|---
[hello*7segment](gpio/hello*7segment) | Use the GPIOs to drive a seven segment LED display.
[hello*gpio*irq](gpio/hello*gpio*irq) | Register an interrupt handler to run when a GPIO is toggled.
[dht*sensor](gpio/dht*sensor) | Use GPIO to bitbang the serial protocol for a DHT temperature/humidity sensor.

See also: [blink](blink), blinking an LED attached to a GPIO.

### HW divider

App|Description
---|---
[hello_divider](divider) | Show how to directly access the hardware integer dividers, in case AEABI injection is disabled.

### I2C

App|Description
---|---
[bus*scan](i2c/bus*scan) | Scan the I2C bus for devices and display results.
[bmp280*i2c](i2c/bmp280*i2c) | Read and convert temperature and pressure data from a BMP280 sensor, attached to an I2C bus.
[lcd*1602*i2c](i2c/lcd*1602*i2c) | Display some text on a generic 16x2 character LCD display, via I2C.
[lis3dh*i2c](i2c/lis3dh*i2c) | Read acceleration and temperature value from a LIS3DH sensor via I2C
[mcp9808*i2c](i2c/mcp9808*i2c) | Read temperature, set limits and raise alerts when limits are surpassed.
[mma8451*i2c](i2c/mma8451*i2c) | Read acceleration from a MMA8451 accelerometer and set range and precision for the data.
[mpl3115a2*i2c](i2c/mpl3115a2*i2c) | Interface with an MPL3115A2 altimeter, exploring interrupts and advanced board features, via I2C.
[mpu6050*i2c](i2c/mpu6050*i2c) | Read acceleration and angular rate values from a MPU6050 accelerometer/gyro, attached to an I2C bus.
[ssd1306*i2c](i2c/ssd1306*i2c) | Convert and display a bitmap on a 128x32 or 128x64 SSD1306-driven OLED display
[pa1010d*i2c](i2c/pa1010d*i2c) | Read GPS location data, parse and display data via I2C.
[pcf8523*i2c](i2c/pcf8523*i2c) | Read time and date values from a real time clock. Set current time and alarms on it.
[ht16k33*i2c](i2c/ht16k33*i2c) | Drive a 4 digit 14 segment LED with an HT16K33.
[slave*mem*i2c](i2c/slave*mem*i2c) | i2c slave example where the slave implements a 256 byte memory
[slave*mem*i2c*burst](i2c/slave*mem_i2c) | i2c slave example where the slave implements a 256 byte memory. This version inefficiently writes each byte in a separate call to demonstrate read and write burst mode.

### Interpolator

App|Description
---|---
[hello*interp](interp/hello*interp) | A bundle of small examples, showing how to access the core-local interpolator hardware, and use most of its features.

### Multicore

App|Description
---|---
[hello*multicore](multicore/hello*multicore) | Launch a function on the second core, printf some messages on each core, and pass data back and forth through the mailbox FIFOs.
[multicore*fifo*irqs](multicore/multicore*fifo*irqs) | On each core, register and interrupt handler for the mailbox FIFOs. Show how the interrupt fires when that core receives a message.
[multicore*runner](multicore/multicore*runner) | Set up the second core to accept, and run, any function pointer pushed into its mailbox FIFO. Push in a few pieces of code and get answers back.
[multicore*doorbell](multicore/multicore*doorbell) | Claims two doorbells for signaling between the cores. Counts how many doorbell IRQs occur on the second core and uses doorbells to coordinate exit.

### OTP (RP235x Only)

App|Description
---|---
[hello*otp](otp/hello*otp) | Demonstrate reading and writing from the OTP on RP235x, along with some of the features of OTP (error correction and page locking).

### Pico Board

App|Description
---|---
[blinky](picoboard/blinky) | Blink "hello, world" in Morse code on Pico's LED
[button](picoboard/button) | Use Pico's BOOTSEL button as a regular button input, by temporarily suspending flash access.

### Pico Networking

These networking examples are only available if Wi-Fi is supported by the board.

App|Description
---|---
[picow*access*point](pico*w/wifi/access*point) | Starts a WiFi access point, and fields DHCP requests.
[picow*blink](pico*w/wifi/blink) | Blinks the on-board LED (which is connected via the WiFi chip).
[picow*blink*slow*clock](pico*w/wifi/blink) | Blinks the on-board LED (which is connected via the WiFi chip) with a slower system clock to show how to reconfigure communication with the WiFi chip at run time under those circumstances
[picow*blink*fast*clock](pico*w/wifi/blink) | Blinks the on-board LED (which is connected via the WiFi chip) with a faster system clock to show how to reconfigure communication with the WiFi chip at build time under those circumstances
[picow*iperf*server](pico_w/wifi/iperf) | Runs an "iperf" server for WiFi speed testing.
[picow*ntp*client](pico*w/wifi/ntp*client) | Connects to an NTP server to fetch and display the current time.
[picow*tcp*client](pico*w/wifi/tcp*client) | A simple TCP client. You can run [python*test*tcp*server.py](pico*w/wifi/python*test*tcp/python*test*tcp_server.py) for it to connect to.
[picow*tcp*server](pico*w/wifi/tcp*server) | A simple TCP server. You can use [python*test*tcp*client.py](pico*w//wifi/python*test*tcp/python*test*tcp_client.py) to connect to it.
[picow*tls*client](pico*w/wifi/tls*client) | Demonstrates how to make a HTTPS request using TLS.
[picow*tls*verify](pico*w/wifi/tls*client) | Demonstrates how to make a HTTPS request using TLS with certificate verification.
[picow*wifi*scan](pico*w/wifi/wifi*scan) | Scans for WiFi networks and prints the results.
[picow*udp*beacon](pico*w/wifi/udp*beacon) | A simple UDP transmitter.
[picow*httpd](pico*w/wifi/httpd) | Runs a LWIP HTTP server test app
[picow*http*client](pico*w/wifi/http*client) | Demonstrates how to make http and https requests
[picow*http*client*verify](pico*w/wifi/http_client) | Demonstrates how to make a https request with server authentication
[picow*mqtt*client](pico_w/wifi/mqtt) | Demonstrates how to implement a MQTT client application

#### FreeRTOS examples

These are examples of integrating Wi-Fi networking under FreeRTOS, and require you to set the `FREERTOS*KERNEL*PATH`
to point to the FreeRTOS Kernel. See https://github.com/FreeRTOS/FreeRTOS-Kernel

App|Description
---|---
[picow*freertos*iperf*server*nosys](pico*w/wifi/freertos/iperf) | Runs an "iperf" server for WiFi speed testing under FreeRTOS in NO*SYS=1 mode. The LED is blinked in another task
[picow*freertos*iperf*server*sys](pico*w/wifi/freertos/iperf) | Runs an "iperf" server for WiFi speed testing under FreeRTOS in NO*SYS=0 (i.e. full FreeRTOS integration) mode. The LED is blinked in another task
[picow*freertos*ping*nosys](pico*w/wifi/freertos/ping) | Runs the lwip-contrib/apps/ping test app under FreeRTOS in NO_SYS=1 mode.
[picow*freertos*ping*sys](pico*w/wifi/freertos/ping) | Runs the lwip-contrib/apps/ping test app under FreeRTOS in NO*SYS=0 (i.e. full FreeRTOS integration) mode. The test app uses the lwIP *socket_ API in this case.
[picow*freertos*ntp*client*socket](pico*w/wifi/freertos/ntp*client*socket) | Connects to an NTP server using the LwIP Socket API with FreeRTOS in NO*SYS=0 (i.e. full FreeRTOS integration) mode.
[pico*freertos*httpd*nosys](pico*w/wifi/freertos/httpd) | Runs a LWIP HTTP server test app under FreeRTOS in NO_SYS=1 mode.
[pico*freertos*httpd*sys](pico*w/wifi/freertos/httpd) | Runs a LWIP HTTP server test app under FreeRTOS in NO_SYS=0 (i.e. full FreeRTOS integration) mode.
[picow*freertos*http*client*sys](pico*w/wifi/freertos/http*client) | Demonstrates how to make a https request in NO_SYS=0 (i.e. full FreeRTOS integration)

### Pico Bluetooth

These Bluetooth examples are only available for boards that support Bluetooth.
They are examples from the Blue Kitchen Bluetooth stack, see [here](https://bluekitchen-gmbh.com/btstack/#examples/examples/index.html) for a full description.

By default, the Bluetooth examples are only built in one "mode" only (*background*, *poll*, or *freertos*), with the 
default being *background*. This can be changed by passing `-DBTSTACK*EXAMPLE*TYPE=poll` etc. to `CMake`, or all 
examples can be built (which may be slow) by passing `-DBTSTACK*EXAMPLE*TYPE=all`
Freertos versions can only be built if `FREERTOS*KERNEL*PATH` is defined.

The Bluetooth examples that use audio require code in [pico-extras](https://github.com/raspberrypi/pico-extras). Pass `-DPICO*EXTRAS*PATH=${HOME}/pico-extras` on the cmake command line or define `PICO*EXTRAS*PATH=${HOME}/pico-extras` in your environment and re-run cmake to include them in the build.

App|Description
---|---
[picow*bt*example*a2dp*sink*demo](https://github.com/bluekitchen/btstack/tree/master/example/a2dp*sink_demo.c) | A2DP Sink - Receive Audio Stream and Control Playback.
[picow*bt*example*a2dp*source*demo](https://github.com/bluekitchen/btstack/tree/master/example/a2dp*source_demo.c) | A2DP Source - Stream Audio and Control Volume.
[picow*bt*example*ancs*client*demo](https://github.com/bluekitchen/btstack/tree/master/example/ancs*client_demo.c) | LE ANCS Client - Apple Notification Service.
[picow*bt*example*att*delayed*response](https://github.com/bluekitchen/btstack/tree/master/example/att*delayed_response.c) | LE Peripheral - Delayed Response.
[picow*bt*example*audio*duplex](https://github.com/bluekitchen/btstack/tree/master/example/audio_duplex.c) | Audio Driver - Forward Audio from Source to Sink.
[picow*bt*example*avrcp*browsing*client](https://github.com/bluekitchen/btstack/tree/master/example/avrcp*browsing_client.c) | AVRCP Browsing - Browse Media Players and Media Information.
[picow*bt*example*dut*mode*classic](https://github.com/bluekitchen/btstack/tree/master/example/dut*mode_classic.c) | Testing - Enable Device Under Test (DUT.c) Mode for Classic.
[picow*bt*example*gap*dedicated*bonding](https://github.com/bluekitchen/btstack/tree/master/example/gap*dedicated_bonding.c) | GAP bonding
[picow*bt*example*gap*inquiry](https://github.com/bluekitchen/btstack/tree/master/example/gap_inquiry.c) | GAP Classic Inquiry.
[picow*bt*example*gap*le*advertisements](https://github.com/bluekitchen/btstack/tree/master/example/gap*le_advertisements.c) | GAP LE Advertisements Scanner.
[picow*bt*example*gap*link*keys](https://github.com/bluekitchen/btstack/tree/master/example/gap*link_keys.c) | GAP Link Key Management (Classic.c).
[picow*bt*example*gatt*battery*query](https://github.com/bluekitchen/btstack/tree/master/example/gatt*battery_query.c) | GATT Battery Service Client.
[picow*bt*example*gatt*browser](https://github.com/bluekitchen/btstack/tree/master/example/gatt_browser.c) | GATT Client - Discover Primary Services.
[picow*bt*example*gatt*counter](https://github.com/bluekitchen/btstack/tree/master/example/gatt_counter.c) | GATT Server - Heartbeat Counter over GATT.
[picow*bt*example*gatt*device*information*query](https://github.com/bluekitchen/btstack/tree/master/example/gatt*device*information_query.c) | GATT Device Information Service Client.
[picow*bt*example*gatt*heart*rate*client](https://github.com/bluekitchen/btstack/tree/master/example/gatt*heart*rate_client.c) | GATT Heart Rate Sensor Client.
[picow*bt*example*gatt*streamer*server](https://github.com/bluekitchen/btstack/tree/master/example/gatt*streamer_server.c) | Performance - Stream Data over GATT (Server.c).
[picow*bt*example*hfp*ag*demo](https://github.com/bluekitchen/btstack/tree/master/example/hfp*ag_demo.c) | HFP AG - Audio Gateway.
[picow*bt*example*hfp*hf*demo](https://github.com/bluekitchen/btstack/tree/master/example/hfp*hf_demo.c) | HFP HF - Hands-Free.
[picow*bt*example*hid*host*demo](https://github.com/bluekitchen/btstack/tree/master/example/hid*host_demo.c) | HID Host Classic.
[picow*bt*example*hid*keyboard*demo](https://github.com/bluekitchen/btstack/tree/master/example/hid*keyboard_demo.c) | HID Keyboard Classic.
[picow*bt*example*hid*mouse*demo](https://github.com/bluekitchen/btstack/tree/master/example/hid*mouse_demo.c) | HID Mouse Classic.
[picow*bt*example*hog*boot*host*demo](https://github.com/bluekitchen/btstack/tree/master/example/hog*boot*host_demo.c) | HID Boot Host LE.
[picow*bt*example*hog*host*demo](https://github.com/bluekitchen/btstack/tree/master/example/hog*host_demo.c) | HID Host LE.
[picow*bt*example*hog*keyboard*demo](https://github.com/bluekitchen/btstack/tree/master/example/hog*keyboard_demo.c) | HID Keyboard LE.
[picow*bt*example*hog*mouse*demo](https://github.com/bluekitchen/btstack/tree/master/example/hog*mouse_demo.c) | HID Mouse LE.
[picow*bt*example*hsp*ag*demo](https://github.com/bluekitchen/btstack/tree/master/example/hsp*ag_demo.c) | HSP AG - Audio Gateway.
[picow*bt*example*hsp*hs*demo](https://github.com/bluekitchen/btstack/tree/master/example/hsp*hs_demo.c) | HSP HS - Headset.
[picow*bt*example*le*credit*based*flow*control*mode*client](https://github.com/bluekitchen/btstack/tree/master/example/le*credit*based*flow*control*mode_client.c) | LE Credit-Based Flow-Control Mode Client - Send Data over L2CAP.
[picow*bt*example*le*credit*based*flow*control*mode*server](https://github.com/bluekitchen/btstack/tree/master/example/le*credit*based*flow*control*mode_server.c) | LE Credit-Based Flow-Control Mode Server - Receive data over L2CAP.
[picow*bt*example*led*counter](https://github.com/bluekitchen/btstack/tree/master/example/led_counter.c) | Hello World - Blinking a LED without Bluetooth.
[picow*bt*example*le*mitm](https://github.com/bluekitchen/btstack/tree/master/example/le_mitm.c) | LE Man-in-the-Middle Tool.
[picow*bt*example*le*streamer*client](https://github.com/bluekitchen/btstack/tree/master/example/le*streamer_client.c) | Performance - Stream Data over GATT (Client.c).
[picow*bt*example*mod*player](https://github.com/bluekitchen/btstack/tree/master/example/mod_player.c) | Audio Driver - Play 80's MOD Song.
[picow*bt*example*nordic*spp*le*counter](https://github.com/bluekitchen/btstack/tree/master/example/nordic*spp*le_counter.c) | LE Nordic SPP-like Heartbeat Server.
[picow*bt*example*nordic*spp*le*streamer](https://github.com/bluekitchen/btstack/tree/master/example/nordic*spp*le_streamer.c) | LE Nordic SPP-like Streamer Server.
[picow*bt*example*sdp*general*query](https://github.com/bluekitchen/btstack/tree/master/example/sdp*general_query.c) | SDP Client - Query Remote SDP Records.
[picow*bt*example*sdp*rfcomm*query](https://github.com/bluekitchen/btstack/tree/master/example/sdp*rfcomm_query.c) | SDP Client - Query RFCOMM SDP record.
[picow*bt*example*sine*player](https://github.com/bluekitchen/btstack/tree/master/example/sine_player.c) | Audio Driver - Play Sine.
[picow*bt*example*sm*pairing*central](https://github.com/bluekitchen/btstack/tree/master/example/sm*pairing_central.c) | LE Central - Test Pairing Methods.
[picow*bt*example*sm*pairing*peripheral](https://github.com/bluekitchen/btstack/tree/master/example/sm*pairing_peripheral.c) | LE Peripheral - Test Pairing Methods.
[picow*bt*example*spp*and*gatt*counter](https://github.com/bluekitchen/btstack/tree/master/example/spp*and*gatt_counter.c) | Dual Mode - SPP and LE Counter.
[picow*bt*example*spp*and*gatt*streamer](https://github.com/bluekitchen/btstack/tree/master/example/spp*and*gatt_streamer.c) | Dual Mode - SPP and LE streamer.
[picow*bt*example*spp*counter](https://github.com/bluekitchen/btstack/tree/master/example/spp_counter.c) | SPP Server - Heartbeat Counter over RFCOMM.
[picow*bt*example*spp*flowcontrol](https://github.com/bluekitchen/btstack/tree/master/example/spp_flowcontrol.c) | SPP Server - RFCOMM Flow Control.
[picow*bt*example*spp*streamer*client](https://github.com/bluekitchen/btstack/tree/master/example/spp*streamer_client.c) | Performance - Stream Data over SPP (Client.c).
[picow*bt*example*spp*streamer](https://github.com/bluekitchen/btstack/tree/master/example/spp_streamer.c) | Performance - Stream Data over SPP (Server.c).
[picow*bt*example*ublox*spp*le*counter](https://github.com/bluekitchen/btstack/blob/master/example/ublox*spp*le_counter.c) | LE u-blox SPP-like Heartbeat Server.

Some Standalone Bluetooth examples (without all the common example build infrastructure) are also available:

App|Description
---|---
[picow*ble*temp*sensor](pico*w/bt/standalone) | Reads from the on board temperature sensor and sends notifications via BLE
[picow*ble*temp*sensor*with*wifi](pico*w/bt/standalone) | Same as above but also connects to Wi-Fi and starts an "iperf" server
[picow*ble*temp*reader](pico*w/bt/standalone) | Connects to one of the above "sensors" and reads the temperature

### PIO

App|Description
---|---
[hello*pio](pio/hello*pio) | Absolutely minimal example showing how to control an LED by pushing values into a PIO FIFO.
[apa102](pio/apa102) | Rainbow pattern on on a string of APA102 addressable RGB LEDs.
[clocked*input](pio/clocked*input) | Shift in serial data, sampling with an external clock.
[differential*manchester](pio/differential*manchester) | Send and receive differential Manchester-encoded serial (BMC).
[hub75](pio/hub75) | Display an image on a 128x64 HUB75 RGB LED matrix.
[i2c](pio/i2c) | Scan an I2C bus.
[ir*nec](pio/ir*nec) | Sending and receiving IR (infra-red) codes using the PIO.
[logic*analyser](pio/logic*analyser) | Use PIO and DMA to capture a logic trace of some GPIOs, whilst a PWM unit is driving them.
[manchester*encoding](pio/manchester*encoding) | Send and receive Manchester-encoded serial.
[onewire](pio/onewire)| A library for interfacing to 1-Wire devices, with an example for the DS18B20 temperature sensor.
[pio*blink](pio/pio*blink) | Set up some PIO state machines to blink LEDs at different frequencies, according to delay counts pushed into their FIFOs.
[pwm](pio/pwm) | Pulse width modulation on PIO. Use it to gradually fade the brightness of an LED.
[spi](pio/spi) | Use PIO to erase, program and read an external SPI flash chip. A second example runs a loopback test with all four CPHA/CPOL combinations.
[squarewave](pio/squarewave) | Drive a fast square wave onto a GPIO. This example accesses low-level PIO registers directly, instead of using the SDK functions.
[squarewave*div*sync](pio/squarewave) | Generates a square wave on three GPIOs and synchronises the divider on all the state machines
[st7789*lcd](pio/st7789*lcd) | Set up PIO for 62.5 Mbps serial output, and use this to display a spinning image on a ST7789 serial LCD.
[quadrature*encoder](pio/quadrature*encoder) | A quadrature encoder using PIO to maintain counts independent of the CPU. 
[quadrature*encoder*substep](pio/quadrature*encoder*substep) | High resolution speed measurement using a standard quadrature encoder
[uart*rx](pio/uart*rx) | Implement the receive component of a UART serial port. Attach it to the spare Arm UART to see it receive characters.
[uart*tx](pio/uart*tx) | Implement the transmit component of a UART serial port, and print hello world.
[ws2812](pio/ws2812) | Examples of driving WS2812 addressable RGB LEDs.
[addition](pio/addition) | Add two integers together using PIO. Only around 8 billion times slower than Cortex-M0+.
[uart*pio*dma](pio/uart*pio*dma) | Send and receive data from a UART implemented using the PIO and DMA

### PWM

App|Description
---|---
[hello*pwm](pwm/hello*pwm) | Minimal example of driving PWM output on GPIOs.
[led*fade](pwm/led*fade) | Fade an LED between low and high brightness. An interrupt handler updates the PWM slice's output level each time the counter wraps.
[measure*duty*cycle](pwm/measure*duty*cycle) | Drives a PWM output at a range of duty cycles, and uses another PWM slice in input mode to measure the duty cycle.

### Reset

App|Description
---|---
[hello*reset](reset/hello*reset) | Perform a hard reset on some peripherals, then bring them back up.

### RTC

App|Description
---|---
[hello*rtc](rtc/hello*rtc) | Set a date/time on the RTC, then repeatedly print the current time, 10 times per second, to show it updating.
[rtc*alarm](rtc/rtc*alarm) | Set an alarm on the RTC to trigger an interrupt at a date/time 5 seconds into the future.
[rtc*alarm*repeat](rtc/rtc*alarm*repeat) | Trigger an RTC interrupt once per minute.

### SHA-256 (RP235x Only)

App|Description
---|---
[hello*sha256](sha/sha256) | Demonstrates how to use the pico*sha256 library to calculate a checksum using the hardware in rp2350
[mbedtls*sha256](sha/mbedtls*sha256) | Demonstrates using the SHA-256 hardware acceleration in mbedtls

### SPI

App|Description
---|---
[bme280*spi](spi/bme280*spi) | Attach a BME280 temperature/humidity/pressure sensor via SPI.
[mpu9250*spi](spi/mpu9250*spi) | Attach a MPU9250 accelerometer/gyoscope via SPI.
[spi*dma](spi/spi*dma) | Use DMA to transfer data both to and from the SPI simultaneously. The SPI is configured for loopback.
[spi*flash](spi/spi*flash) | Erase, program and read a serial flash device attached to one of the SPI controllers.
[spi*master*slave](spi/spi*master*slave) | Demonstrate SPI communication as master and slave.
[max7219*8x7seg*spi](spi/max7219*8x7seg*spi) | Attaching a Max7219 driving an 8 digit 7 segment display via SPI
[max7219*32x8*spi](spi/max7219*32x8*spi) | Attaching a Max7219 driving an 32x8 LED display via SPI

### System

App|Description
---|---
[boot*info](system/boot*info) | Demonstrate how to read and interpret sys info boot info.
[hello*double*tap](system/hello*double*tap) | An LED blink with the `pico*bootsel*via*double*reset` library linked. This enters the USB bootloader when it detects the system being reset twice in quick succession, which is useful for boards with a reset button but no BOOTSEL button.
[rand](system/rand) | Demonstrate how to use the pico random number functions.
[narrow*io*write](system/narrow*io*write) | Demonstrate the effects of 8-bit and 16-bit writes on a 32-bit IO register.
[unique*board*id](system/unique*board*id) | Read the 64 bit unique ID from external flash, which serves as a unique identifier for the board.

### Timer

App|Description
---|---
[hello*timer](timer/hello*timer) | Set callbacks on the system timer, which repeat at regular intervals. Cancel the timer when we're done.
[periodic*sampler](timer/periodic*sampler) | Sample GPIOs in a timer callback, and push the samples into a concurrency-safe queue. Pop data from the queue in code running in the foreground.
[timer*lowlevel](timer/timer*lowlevel) | Example of direct access to the timer hardware. Not generally recommended, as the SDK may use the timer for IO timeouts.

### UART

App|Description
---|---
[hello*uart](uart/hello*uart) | Print some text from one of the UART serial ports, without going through `stdio`.
[lcd*uart](uart/lcd*uart) | Display text and symbols on a 16x02 RGB LCD display via UART
[uart*advanced](uart/uart*advanced) | Use some other UART features like RX interrupts, hardware control flow, and data formats other than 8n1.

### Universal

These are examples of how to build universal binaries which run on RP2040, and RP2350 Arm & RISC-V.
These require you to set `PICO*ARM*TOOLCHAIN*PATH` and `PICO*RISCV*TOOLCHAIN*PATH` to appropriate paths, to ensure you have compilers for both architectures.

App|Description
---|---
[blink](universal/CMakeLists.txt#L126) | Same as the [blink](blink) example, but universal.
[hello*universal](universal/hello*universal) | The obligatory Hello World program for Pico (USB and serial output). On RP2350 it will reboot to the other architecture after every 10 prints.
[nuke_universal](universal/CMakeLists.txt#L132) | Same as the [nuke](flash/nuke) example, but universal. On RP2350 runs as a packaged SRAM binary, so is written to flash and copied to SRAM by the bootloader

### USB Device

#### TinyUSB Examples 

Most of the USB device examples come directly from the TinyUSB device examples directory [here](https://github.com/hathach/tinyusb/tree/master/examples/device).
Those that are supported on RP2040 devices are automatically included as part of the pico-examples
build as targets named `tinyusb*dev*<example*name>`, e.g. https://github.com/hathach/tinyusb/tree/master/examples/device/hid*composite
is built as `tinyusb*dev*hid_composite`.

At the time of writing, these examples are available:

- tinyusb*dev*audio*4*channel_mic
- tinyusb*dev*audio_test
- tinyusb*dev*board_test
- tinyusb*dev*cdc*dual*ports
- tinyusb*dev*cdc_msc
- tinyusb*dev*dfu
- tinyusb*dev*dfu_runtime
- tinyusb*dev*dynamic_configuration
- tinyusb*dev*hid_composite
- tinyusb*dev*hid*generic*inout
- tinyusb*dev*hid*multiple*interface
- tinyusb*dev*midi_test
- tinyusb*dev*msc*dual*lun
- tinyusb*dev*net*lwip*webserver
- tinyusb*dev*uac2_headset
- tinyusb*dev*usbtmc
- tinyusb*dev*video_capture
- tinyusb*dev*webusb_serial

Whilst these examples ably demonstrate how to use TinyUSB in device mode, their `CMakeLists.txt` is set up in a way
tailored to how TinyUSB builds their examples within their source tree.

For a better example of how to configure `CMakeLists.txt` for using TinyUSB in device mode with the Raspberry Pi SDK
see below:

#### SDK build example 
App|Description
---|---
[dev*hid*composite](usb/device/dev*hid*composite) | A copy of the TinyUSB device example with the same name, but with a CMakeLists.txt which demonstrates how to add a dependency on the TinyUSB device libraries with the Raspberry Pi Pico SDK

#### Low Level example
App|Description
---|---
[dev*lowlevel](usb/device/dev*lowlevel) | A USB Bulk loopback implemented with direct access to the USB hardware (no TinyUSB)

#### Custom CDC with SDK stdio

This example demonstrates how to use the TinyUSB CDC device library to create two USB serial ports, and assign one of them to the SDK for stdio.

App|Description
---|---
[dev*multi*cdc](usb/device/dev*multi*cdc) | A USB CDC device example with two serial ports, one of which is used for stdio. The example exposes two serial ports over USB to the host. The first port is used for stdio, and the second port is used for a simple echo loopback. You can connect to the second port and send some characters, and they will be echoed back on the first port while you will receive a "OK\r\n" message on the second port indicating that the data was received.

### USB Host

All the USB host examples come directly from the TinyUSB host examples directory [here](https://github.com/hathach/tinyusb/tree/master/examples/host).
Those that are supported on RP2040 devices are automatically included as part of the pico-examples
build as targets named `tinyusb*host*<example*name>`, e.g. https://github.com/hathach/tinyusb/tree/master/examples/host/cdc*msc_hid
is built as `tinyusb*host*cdc*msc*hid`.

At the time of writing, there is only one host example available:

- tinyusb*host*cdc*msc*hid

### USB Dual Mode

USB Dual Mode uses PIO as a USB host controller and the RP2040 USB device controller as a device controller. All the USB dual examples come directly from the TinyUSB dual examples directory [here](https://github.com/hathach/tinyusb/tree/master/examples/dual).
Those that are supported on RP2040 devices are automatically included as part of the pico-examples
build as targets named `tinyusb*dual*<example*name>`, e.g. https://github.com/hathach/tinyusb/tree/master/examples/dual/host*hid*to*device_cdc
is built as `tinyusb*dual*host*hid*to*device*cdc`.

At the time of writing, there is only one dual example available:

- tinyusb*dual*host*hid*to*device*cdc

### Watchdog

App|Description
---|---
[hello*watchdog](watchdog/hello*watchdog) | Set the watchdog timer, and let it expire. Detect the reboot, and halt.
