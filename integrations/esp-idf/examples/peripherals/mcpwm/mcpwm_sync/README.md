| Supported Targets | ESP32 | ESP32-C5 | ESP32-C6 | ESP32-H2 | ESP32-P4 | ESP32-S3 |
| ----------------- | ----- | -------- | -------- | -------- | -------- | -------- |

# MCPWM Sync Example

(See the README.md file in the upper level 'examples' directory for more information about examples.)

MCPWM timers can't be started together because you have to call **mcpwm*timer*start_stop** function timer by timer, so the generators driven by them are not in sync with each other. But there're several ways to force these timers jump to the same point by setting sync phase for timers and then wait for a proper sync event to happen.

This example illustrates how to generate three PWMs that are in perfect synchronization.

## How to Use Example

### Hardware Required

* A development board with any Espressif SoC which features MCPWM peripheral (e.g., ESP32-DevKitC, ESP-WROVER-KIT, etc.)
* A USB cable for Power supply and programming

It is recommended to have an oscilloscope or logic analyzer to view the generated PWM waveforms.

Connection :

```
          ESP Board                           oscilloscope / logic analyzer
+--------------------------+                 +----------------------------+
|                          |                 |                            |
|        EXAMPLE_GEN_GPIO0 +-----------------+ channelA                   |
|                          |                 |                            |
|        EXAMPLE_GEN_GPIO1 +-----------------+ channelB                   |
|                          |                 |                            |
|        EXAMPLE_GEN_GPIO2 +-----------------+ channelC                   |
|                          |                 |                            |
|                     GND  +-----------------+ GND                        |
|                          |                 |                            |
+--------------------------+                 +----------------------------+
```

Above used GPIO numbers (e.g. `EXAMPLE*GEN*GPIO0`) can be changed in [the source file](main/mcpwm*sync*example_main.c).

### Configure the project

```
idf.py menuconfig
```

You can select the way to synchronize the MCPWM timers in the menu: `Example Configuration` -> `Where the sync event is generated from`.

* GPIO
    * This approach will consume a GPIO, where a configurable pulse on the GPIO is treated as the sync event. And the sync event is routed to each MCPWM timers.
* Timer TEZ
    * This approach won't consume any GPIO, the sync even is generated by a main timer, and then routed to other MCPWM timers. The drawback of this approach is, the main timer will have a tiny phase shift to other two timers.
* Software (optional)
    * This approach won't consume any GPIO as well and also doesn't have the drawback in the `Timer TEZ` approach. The main timer is sync by software, and it will propagate the sync event to other timers.

### Build and Flash

Run `idf.py -p PORT flash monitor` to build, flash and monitor the project.

(To exit the serial monitor, type ``Ctrl-]``.)

See the [Getting Started Guide](https://docs.espressif.com/projects/esp-idf/en/latest/get-started/index.html) for full steps to configure and use ESP-IDF to build projects.

## Example Output

```
I (0) cpu_start: Starting scheduler on APP CPU.
I (305) example: Create timers
I (305) example: Create operators
I (305) example: Connect timers and operators with each other
I (315) example: Create comparators
I (315) example: Create generators
I (325) gpio: GPIO[0]| InputEn: 0| OutputEn: 1| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0
I (335) gpio: GPIO[2]| InputEn: 0| OutputEn: 1| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0
I (345) gpio: GPIO[4]| InputEn: 0| OutputEn: 1| OpenDrain: 0| Pullup: 1| Pulldown: 0| Intr:0
I (355) example: Set generator actions on timer and compare event
I (355) example: Start timers one by one, so they are not synced
I (495) example: Force the output level to low, timer still running
I (495) example: Setup sync strategy
I (495) example: Create GPIO sync source
I (495) gpio: GPIO[5]| InputEn: 1| OutputEn: 1| OpenDrain: 0| Pullup: 0| Pulldown: 1| Intr:0
I (505) example: Set timers to sync on the GPIO
I (505) example: Trigger a pulse on the GPIO as a sync event
I (515) example: Now the output PWMs should in sync
```

## Troubleshooting

For any technical queries, please open an [issue] (https://github.com/espressif/esp-idf/issues) on GitHub. We will get back to you soon.
