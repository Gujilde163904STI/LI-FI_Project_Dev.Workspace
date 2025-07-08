# Camera  Examples

This directory contains a range of example [esp32-camera](https://github.com/espressif/esp32-camera) projects.   
See the [README.md](../../README.md) file in the upper level directory for more information about examples.

## Camera driver workflow
![](../../docs/_static/camera-workflow.png)

The camera sensor transmits data to ESP32 device through DVP(parallel digital video port) interface. When initializing the camera, some `frame*buffer` will be allocated to store the data transmitted by the camera sensor. Once the camera is initialized, it starts working immediately, and the application can call `esp*camera*fb*get()` to get image data. After the application has applied the image data, the `frame*buffer` can be reused by calling `esp*camera*fb*return()`.

## Example Layout
* `basic` demonstrates basic usage of `ESP32-camera driver`.
* `pic_server` introduces how to control the action of taking pictures, and view the pictures immediately on the web page.
* `test_framerate` introduces how to evaluate the speed of the camera sensor and how to improve the speed of the camera sensor.
* `video*stream*server` demonstrates how to implement a video stream HTTP server on ESP32.
* `video_recorder` demonstrates how to implement a video recorder on ESP32.

### More 
* [ESP-WHO](https://github.com/espressif/esp-who) is an image processing development platform based on Espressif chips. It contains development examples that may be applied in practical applications.
* [USB*camera*examples](https://github.com/espressif/esp-iot-solution/tree/master/examples/usb/host) Contains some examples of using USB cameras.

## API Reference

The APIs included in the [esp32-camera](https://github.com/espressif/esp32-camera) are described below.  
### Header File
- [esp32-camera/driver/include/esp*camera.h](https://github.com/espressif/esp32-camera/blob/master/driver/include/esp*camera.h)
#### Functions
- `esp*err*t esp*camera*init(const camera*config*t* config)`  
  Initialize the camera driver.

- `esp*err*t esp*camera*deinit()`  
  Deinitialize the camera driver.

- `camera*fb*t* esp*camera*fb_get()`  
  Obtain pointer to a frame buffer.

- `void esp*camera*fb*return(camera*fb_t * fb)`  
  Return the frame buffer to be reused again.

- `sensor*t * esp*camera*sensor*get()`  
  Get a pointer to the image sensor control structure.

- `esp*err*t esp*camera*save*to*nvs(const char *key)`  
  Save camera settings to non-volatile-storage (NVS).

- `esp*err*t esp*camera*load*from*nvs(const char *key)`  
  Load camera settings from non-volatile-storage (NVS).
### Header File
- [esp32-camera/driver/include/sensor.h](https://github.com/espressif/esp32-camera/blob/master/driver/include/sensor.h)
#### Functions
- `camera*sensor*info*t *esp*camera*sensor*get*info(sensor*id_t *id)`  
  Get the camera sensor information.
### Header File
- [esp32-camera/conversions/include/img*converters.h](https://github.com/espressif/esp32-camera/blob/master/conversions/include/img*converters.h)
#### Functions
- `bool fmt2jpg*cb(uint8*t *src, size*t src*len, uint16*t width, uint16*t height, pixformat*t format, uint8*t quality, jpg*out*cb cb, void * arg)`  
  Convert image buffer to JPEG.

- `bool frame2jpg*cb(camera*fb*t * fb, uint8*t quality, jpg*out*cb cb, void * arg)`  
  Convert camera frame buffer to JPEG.

- `bool fmt2jpg(uint8*t *src, size*t src*len, uint16*t width, uint16*t height, pixformat*t format, uint8*t quality, uint8*t ** out, size*t * out*len)`  
  Convert image buffer to JPEG buffer.

- `bool fmt2bmp(uint8*t *src, size*t src*len, uint16*t width, uint16*t height, pixformat*t format, uint8*t ** out, size*t * out_len)`  
  Convert image buffer to BMP buffer.

- `bool frame2bmp(camera*fb*t * fb, uint8*t ** out, size*t * out_len)`  
  Convert camera frame buffer to BMP buffer.

- `bool frame2bmp(camera*fb*t * fb, uint8*t ** out, size*t * out_len)`  
  Convert camera frame buffer to BMP buffer.

- `bool fmt2rgb888(const uint8*t *src*buf, size*t src*len, pixformat*t format, uint8*t * rgb_buf)`  
  Convert image buffer to RGB888 buffer.
  
- `bool jpg2rgb565(const uint8*t *src, size*t src*len, uint8*t * out, jpg*scale*t scale)`  
Convert image buffer to RGB565 buffer.

### Header File
- [esp32-camera/conversions/include/esp*jpg*decode.h](https://github.com/espressif/esp32-camera/blob/master/conversions/include/esp*jpg*decode.h)
#### Functions
- `esp*err*t esp*jpg*decode(size*t len, jpg*scale*t scale, jpg*reader*cb reader, jpg*writer_cb writer, void * arg)`  
JPEG scaling function.
