# About
This is a manual test application for the PULSE_COUNTER driver.

# Usage
This test application will initialize the PULSE_COUNTER sensor with the configuration
as specified in the default `pulse*counter*params.h` file.

If you want to use this test application with different parameters, you can
simply override the default PULSE*COUNTER*PARAMS.

After initialization, the sensor reads the pulse counter values every second and
prints them to STDOUT.
