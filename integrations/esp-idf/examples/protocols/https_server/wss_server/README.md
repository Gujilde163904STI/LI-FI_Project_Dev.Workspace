| Supported Targets | ESP32 | ESP32-C2 | ESP32-C3 | ESP32-C5 | ESP32-C6 | ESP32-C61 | ESP32-H2 | ESP32-P4 | ESP32-S2 | ESP32-S3 |
| ----------------- | ----- | -------- | -------- | -------- | -------- | --------- | -------- | -------- | -------- | -------- |

# HTTPS Websocket server

This example creates an HTTPS server with SSL/TLS support using ESP-TLS and employs a simple Websocket request handler. It demonstrates handling multiple clients from the server including:
* PING-PONG mechanism
* Sending asynchronous messages to all clients

For more information, refer to the [esp*https*server component documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/protocols/esp*https*server.html).


### Websocket support in `http_server`

Please refer to the documentation of [Websocket server](https://docs.espressif.com/projects/esp-idf/en/latest/api-reference/protocols/esp*http*server.html#websocket-server) feature in the documentation,
or to the description of using websocket handlers in httpd in the [simple ws echo](../../http*server/ws*echo_server/README.md#how-to-use-example) example.

## How to use example
Before project configuration and build, be sure to set the correct chip target using `idf.py set-target <chip_name>`.

### Hardware Required

* A development board with ESP32/ESP32-S2/ESP32-C3 SoC (e.g., ESP32-DevKitC, ESP-WROVER-KIT, etc.)
* A USB cable for power supply and programming

### Configure the project

```
idf.py menuconfig
```
Open the project configuration menu (`idf.py menuconfig`) to configure Wi-Fi or Ethernet. See "Establishing Wi-Fi or Ethernet Connection" section in [examples/protocols/README.md](../../README.md) for more details.

### Build and Flash

Build the project and flash it to the board, then run monitor tool to view serial output:

```
idf.py -p PORT flash monitor
```

(Replace PORT with the name of the serial port to use.)

(To exit the serial monitor, type ``Ctrl-]``.)

See the Getting Started Guide for full steps to configure and use ESP-IDF to build projects.

## Certificates

You will need to approve a security exception in your browser. This is because of a self signed
certificate; this will be always the case, unless you preload the CA root into your browser/system
as trusted.

You can generate a new certificate using the OpenSSL command line tool:

```
openssl req -newkey rsa:2048 -nodes -keyout prvtkey.pem -x509 -days 3650 -out servercert.pem -subj "/CN=ESP32 HTTPS server example" -addext "keyUsage=critical,digitalSignature,keyCertSign"
```

Expiry time and metadata fields can be adjusted in the invocation.

Please see the openssl man pages (man openssl-req) for more details.

It is **strongly recommended** to not reuse the example certificate in your application;
it is included only for demonstration.
