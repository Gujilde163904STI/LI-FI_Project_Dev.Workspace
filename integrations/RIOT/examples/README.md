# Examples

RIOT provides a wide range of examples to demonstrate the capabilities of the OS and its modules.

Each example contains a `README.md` that provides information and instructions how to run it.

Here is a quick overview of the examples available in the RIOT:

## The Essentials

| Example | Description |
|---------|-------------|
| [default](./basic/default/README.md) | This application is a showcase for RIOT's hardware support. Using it for your board, you should be able to interactively use any hardware that is supported. |
| [hello-world](./basic/hello-world/README.md) | A simple "Hello World" that shows the basic structure of a RIOT application. |
| [blinky](./basic/blinky/README.md) | The classic "Hello World" example for embedded systems: blinking an LED (or printing "Blink!" via stdio when none are available). |
| [leds*shell](./basic/leds*shell/README.md) | The application `leds_shell` is a basic example, which allows easy, interactive control of internal board LEDs, and basic GPIO for externally connected simple devices (for e.g. additional LEDs, relay, motors - via dedicated drivers, etc.) via the shell. |
| [saul](./basic/saul/README.md) | This example demonstrates the usage of the SAUL (Sensor Actuator Uber Layer) module. |
| [timer*periodic*wakeup](./basic/timer*periodic*wakeup/README.md) | How to set up a periodic wakeup timer using the RIOT operating system. |
| [ipc*pingpong](./basic/ipc*pingpong/README.md) | This example is to illustrate the usage of RIOTs IPC messaging system. |
| [filesystem](./basic/filesystem/README.md) | This example showcases ways to interact/manage the filesystem in RIOT. |
| [subfolders](./basic/subfolders/README.md) | This example demonstrates how to use subfolders in RIOT applications. |

## RIOT Language Bindings

#### Officially Supported/Targeted

##### *Rust*

| Example | Description |
|---------|-------------|
| [rust-hello-world](./lang_support/official/rust-hello-world/README.md) | This example demonstrates how to write a simple RIOT application in Rust. |
| [rust-gcoap](./lang_support/official/rust-gcoap/README.md) | This example demonstrates how to write a coap server application in Rust using the RIOTs gcoap module. |
| [rust-async](./lang_support/official/rust-async/README.md) | This example demonstrates how to use Rusts async/await syntax in a RIOT application. |

##### *C++*

| Example | Description |
|---------|-------------|
| [riot*and*cpp](./lang*support/official/riot*and_cpp/README.md) | Example of using C++ in RIOT applications. |

#### Community Supported

| Example | Description |
|---------|-------------|
| [javascript](./lang_support/community/javascript/README.md) | How to write IoT applications using javascript using JerryScript. |
| [lua*basic](./lang*support/community/lua_basic/README.md) | How to write IoT applications using Lua. |
| [lua*REPL](./lang*support/community/lua_REPL/README.md) | This example demonstrates how to use the Lua Read-Eval-Print Loop (REPL) in RIOT. |
| [micropython](./lang_support/community/micropython/README.md) | How to use the MicroPython port for RIOT. |
| [wasm](./lang_support/community/wasm/README.md) | How to use WebAssembly in RIOT. |
| [arduino*hello-world](./lang*support/community/arduino_hello-world/README.md) | This application demonstrates the usage of Arduino sketches in RIOT. |

## Networking

### Constraint Application Protocol (CoAP)

| Example | Description |
|---------|-------------|
| [gcoap](./networking/coap/gcoap/README.md) | This example demonstrates the usage of the `gcoap` module, a high-level API for CoAP (Constrained Application Protocol) messaging. |
| [gcoap*block*server](./networking/coap/gcoap*block*server/README.md) | CoAP server handling for Block requests, build with gcoap using nanocoap block handling functions. |
| [gcoap*fileserver](./networking/coap/gcoap*fileserver/README.md) | This example demonstrates the usage of the `gcoap` module to serve files over CoAP. |
| [gcoap*dtls](./networking/coap/gcoap*dtls/README.md) | This example demonstrates the usage of the `gcoap` module with DTLS. |
| [nanocoap*server](./networking/coap/nanocoap*server/README.md) | This example demonstrates the usage of the `nanocoap` module, a high-level API for CoAP (Constrained Application Protocol) messaging. |

### Bluetooth Low Energy (BLE)

#### NimBLE

| Example | Description |
|---------|-------------|
| [nimble*scanner](./networking/ble/nimble/nimble*scanner/README.md) | This example showcases the usage of the `NimBLE` BLE stack as a scanner. |
| [nimble*gatt](./networking/ble/nimble/nimble*gatt/README.md) | This example application configures and runs the NimBLE BLE stack as simple GATT server. |
| [nimble*heart*rate*sensor](./networking/ble/nimble/nimble*heart*rate*sensor/README.md) | This example demonstrates how to implement asynchronous data transfer using GATT notifications by implementing a mock-up BLE heart rate sensor. |

#### Misc BLE Examples

| Example | Description |
|---------|-------------|
| [skald*eddystone](./networking/ble/misc/skald*eddystone/README.md) | This example demonstrates the usage of `Skald` for creating an Google `Eddystone` beacon. |
| [skald*ibeacon](./networking/ble/misc/skald*ibeacon/README.md) | This example demonstrates the usage of `Skald` for creating an Apple `iBeacon`. |

### MQTT

| Example | Description |
|---------|-------------|
| [asymcute*mqttsn](./networking/mqtt/asymcute*mqttsn/README.md) | This application demonstrates the usage of the Asymcute (MQTT-SN) module in RIOT. |
| [emcute*mqttsn](./networking/mqtt/emcute*mqttsn/README.md) | This application demonstrates the usage of the emCute (MQTT-SN) module in RIOT. |
| [paho-mqtt](./networking/mqtt/paho-mqtt/README.md) | This example demonstrates the usage of the Paho MQTT client library in RIOT. |

### CoRE Resource Directory

| Example | Description |
|---------|-------------|
| [cord*ep](./networking/cord/cord*ep/README.md) | Example of RIOT's Resource Directory (RD) endpoint module, called `cord_ep` |
| [cord*lc](./networking/cord/cord*lc/README.md) | Example of RIOT's Resource Directory (RD) lookup module, called `cord_lc` |
| [cord*epsim](./networking/cord/cord*epsim/README.md) | This example shows how a node can register with a CoRE resource directory |

### GNRC Networking

| Example | Description |
|---------|-------------|
| [gnrc*minimal](./networking/gnrc/gnrc*minimal/README.md) | This is a minimalistic example for RIOT's gnrc network stack. |
| [gnrc*networking](./networking/gnrc/gnrc*networking/README.md) | This example demonstrates the usage of the GNRC network stack in RIOT. |
| [gnrc*networking*subnets](./networking/gnrc/gnrc*networking*subnets/README.md) | This example demonstrates IPv6 subnet auto-configuration for networks on a tree topology. |
| [gnrc*border*router](./networking/gnrc/gnrc*border*router/README.md) | Example of `gnrc*border*router` using automatic configuration |
| [gnrc*lorawan](./networking/gnrc/gnrc*lorawan/README.md) | Send and receive LoRaWAN packets and perform basic LoRaWAN commands |
| [gnrc*networking*mac](./networking/gnrc/gnrc*networking*mac/README.md) | This example shows you how to try out communications between RIOT instances with duty-cycled MAC layer protocols |

### DTLS

| Example | Description |
|---------|-------------|
| [dtls-sock](./networking/dtls/dtls-sock/README.md) | This example shows how to use DTLS sock `sock*dtls*t` |
| [dtls-echo](./networking/dtls/dtls-echo/README.md) | This example shows how to use TinyDTLS with sock_udp. |
| [dtls-wolfssl](./networking/dtls/dtls-wolfssl/README.md) | This example demonstrates the usage of the DTLS module with the wolfSSL library. |

### Misc

| Example | Description |
|---------|-------------|
| [lorawan](./networking/misc/lorawan/README.md) | This application shows a basic LoRaWAN use-case with RIOT. |
| [openthread](./networking/misc/openthread/README.md) | This example demonstrates the usage of the OpenThread stack in RIOT. |
| [lwm2m](./networking/misc/lwm2m/README.md) | Example of a LWM2M client on RIOT |
| [ccn-lite-relay](./networking/misc/ccn-lite-relay/README.md) | This application demonstrates how to use the Content-Centric Networking stack from [CCN-Lite](http://www.ccn-lite.net/) on RIOT |
| [telnet*server](./networking/misc/telnet*server/README.md) | Simple telnet server that listens on port 23 over IPv6. |
| [posix*sockets](./networking/misc/posix*sockets/README.md) | Showcase for RIOT's POSIX socket support |
| [spectrum-scanner](./networking/misc/spectrum-scanner/README.md) | This example demonstrates how to monitor energy levels on all available wireless channels |
| [sniffer](./networking/misc/sniffer/README.md) | This application is built to run together with the script `./tools/sniffer.py` as a sniffer for (wireless) data traffic. |
| [benckmark*udp](./networking/misc/benchmark*udp/README.md) | This example uses the `benchmark_udp` module to create a stress-test for the RIOT network stack. |
| [sock*tcp*echo](./networking/misc/sock*tcp*echo/README.md) | This is a simple TCP echo server / client that uses the SOCK API. |

## Advanced Examples

| Example | Description |
|---------|-------------|
| [bindist](./advanced/bindist/README.md) | RIOT allows for creating a "binary distribution", which can be used to ship proprietary, compiled objects in a way that makes it possible to re-link them against a freshly compiled RIOT. This application serves as a simple example. |
| [usbus*minimal](./advanced/usbus*minimal/README.md) | This is a minimalistic example for RIOT's USB stack. |
| [suit*update](./advanced/advanced/suit*update/README.md) | This example shows how to integrate SUIT-compliant firmware updates into a RIOT application. |
| [thread*duel](./advanced/thread*duel/README.md) | This is a thread duel application to show RIOTs abilities to run multiple-threads concurrently, even if they are neither cooperative nor dividable into different scheduler priorities, by using the optional round-robin scheduler module. |
| [posix*select](./advanced/posix*select/README.md) | This example is a showcase for RIOT's POSIX select support |
| [psa*crypto](./advanced/psa*crypto/README.md) | Basic functions of the PSA Crypto API |
| [pio*blink](./advanced/pio*blink/README.md) | How to use the PIO peripheral on the RaspberryPi Pico to blink an LED. |
| [twr*aloha](./advanced/twr*aloha/README.md) | This example allows testing different two-way ranging algorithms between two boards supporting a dw1000 device. This makes use of the uwb-core pkg. |
| [senml*saul](./advanced/senml*saul/README.md) | This example demonstrates the usage of the SAUL (Sensor Actuator Uber Layer) module with the SenML (Sensor Measurement Lists) format. |
| [opendsme](./advanced/opendsme/README.md) | This example demonstrates the usage of the OpenDSME module in RIOT. |

## Examples from Guides

[Our guides](https://guide.riot-os.org/) walk you through small tutorials to get started. The following examples are the resulting code from completing their respective guide.

| Example | Description |
|---------|-------------|
| [creating*project](./guides/creating*project/README.md) | Teaches you the very first steps. How to setup a RIOT project, build and run a Hello World in it. [Create Project](https://guide.riot-os.org/c*tutorials/create*project/) tutorial |
| [shell](./guides/shell/README.md) | Teaches you how to use the interactive RIOT shell for your application. [Shell](https://guide.riot-os.org/c_tutorials/shell/) tutorial |
| [gpio](./guides/gpio/README.md) | Teaches you how to configure and use GPIO pins for external hardware interaction. [GPIO](https://guide.riot-os.org/c_tutorials/gpio/) tutorial |
| [saul](./guides/saul/README.md) | Teaches you how to interact with sensors and actuators through the SAUL interface. [SAUL](https://guide.riot-os.org/c_tutorials/saul/) tutorial |
| [threads](./guides/threads/README.md) | Teaches you how to create and manage multiple execution threads in your RIOT application. [Threads](https://guide.riot-os.org/c_tutorials/threads/) tutorial |
| [timers](./guides/timers/README.md) | Teaches you how to use timers for periodic tasks and time measurement in RIOT. [Timers](https://guide.riot-os.org/c_tutorials/timers/) tutorial |
