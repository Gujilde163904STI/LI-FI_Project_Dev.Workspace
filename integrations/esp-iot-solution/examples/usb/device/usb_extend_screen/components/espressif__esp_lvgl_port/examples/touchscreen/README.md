# ESP LVGL Touch Screen Example

Very simple example for demonstration of initialization and usage of the `esp*lvgl*port` component. This example contains four main parts:

## 1. LCD HW initialization - `app*lcd*init()`

Standard HW initialization of the LCD using [`esp*lcd`](https://github.com/espressif/esp-idf/tree/master/components/esp*lcd) component. Settings of this example are fully compatible with [ESP-BOX](https://github.com/espressif/esp-bsp/tree/master/esp-box) board.

## 2. Touch HW initialization - `app*touch*init()`

Standard HW initialization of the LCD touch using [`esp*lcd*touch`](https://github.com/espressif/esp-bsp/tree/master/components/lcd*touch/esp*lcd_touch) component. Settings of this example are fully compatible with [ESP-BOX](https://github.com/espressif/esp-bsp/tree/master/esp-box) board.

## 3. LVGL port initialization - `app*lvgl*init()`

Initialization of the LVGL port.

## 4. LVGL objects example usage - `app*main*display()`

Very simple demonstration code of using LVGL objects after LVGL port initialization.
