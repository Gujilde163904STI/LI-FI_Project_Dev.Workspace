# Touch Button Example

**Note:** This example is for developers testing only. It is not intended for production use.

This article demonstrates how to use `iot_button` to detect touch interactions. The example showcases how to differentiate between light and firm presses on the same touch channel.

## Hardware Required

* An ESP development board with touch sensor capability
* Touch pads or electrodes connected to touch-enabled GPIO pins
* A USB cable for power supply and programming

## How to Use Example

### Hardware Connection

Connect touch pads/electrodes to the touch-enabled GPIO pins on your ESP board. Check your board's documentation for which pins support touch sensing.

### Configuration

The example can be configured through menuconfig:

```
idf.py menuconfig
```

Under "Touch Button Sensor Configuration" you can adjust numerous parameters:

- `TOUCH*BUTTON*SENSOR_DEBUG`: Enable debug mode for detailed logging
- `TOUCH*BUTTON*SENSOR*CALIBRATION*TIMES`: Number of readings for initial calibration
- `TOUCH*BUTTON*SENSOR*DEBOUNCE*INACTIVE`: Debounce count for inactive state detection
- `TOUCH*BUTTON*SENSOR*POLLING*INTERVAL`: Interval between polling touch readings (ESP32 only)
- `TOUCH*BUTTON*SENSOR*SMOOTH*COEF_X1000`: Smoothing coefficient for readings stability
- `TOUCH*BUTTON*SENSOR*BASELINE*COEF_X1000`: Baseline adaptation coefficient for drift compensation
- `TOUCH*BUTTON*SENSOR*MAX*P_X1000`: Maximum positive change ratio threshold
- `TOUCH*BUTTON*SENSOR*MIN*N_X1000`: Minimum negative change ratio threshold
- `TOUCH*BUTTON*SENSOR*NEGATIVE*LOGIC`: Enable negative logic for touch detection
- `TOUCH*BUTTON*SENSOR*NOISE*P_SNR`: Signal-to-noise ratio for positive noise filtering
- `TOUCH*BUTTON*SENSOR*NOISE*N_SNR`: Signal-to-noise ratio for negative noise filtering
- `TOUCH*BUTTON*SENSOR*RESET*COVER`: Reset count threshold for cover detection
- `TOUCH*BUTTON*SENSOR*RESET*CALIBRATION`: Reset count for calibration error recovery
- `TOUCH*BUTTON*SENSOR*RAW*BUF_SIZE`: Size of raw data buffer for processing
- `TOUCH*BUTTON*SENSOR*SCALE*FACTOR`: Scale factor for threshold calculations

### Build and Flash

Build the project and flash it to the board:

```bash
idf.py build
idf.py -p PORT flash
```

Replace PORT with your serial port name.

### Example Output

The example will output touch sensor readings to the serial monitor:

```
I (358) touch_lowlevel: Touch sensor lowlevel started
I (428) touch_fsm: Channel 1: Baseline found: 21851
I (428) touch_fsm: Channel 1: Baseline found: 21851
I (5028) touch_button: Light Button: BUTTON_PRESS_DOWN
I (5068) touch_button: Heavy Button: BUTTON_PRESS_DOWN
I (5358) touch_button: Heavy Button: BUTTON_PRESS_UP
I (5388) touch_button: Light Button: BUTTON_PRESS_UP
...
```
