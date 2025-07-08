# About
This is a manual test application for the INA3221 current and power
monitor driver.

# Usage
This test application will initialize the sensor with the following parameters:
- INA3221*PARAM*I2C:                I2C_DEV(0)
- INA3221*PARAM*ADDR:               INA3221*ADDR*00
- INA3221*PARAM*PIN*WRN:            GPIO*UNDEF, or given WRN input pin
- INA3221*PARAM*PIN*CRT:            GPIO*UNDEF, or given CRT input pin
- INA3221*PARAM*PIN*TC:             GPIO*UNDEF, or given TC input pin
- INA3221*PARAM*PIN*PV:             GPIO*UNDEF, or given PV input pin
- INA3221*PARAM*CONFIG:             (
                                        INA3221_ENABLE_CH1 | INA3221_ENABLE_CH2 | INA3221_ENABLE_CH3,
                                        INA3221_NUM_SAMPLES_4 |
                                        INA3221_CONV_TIME_BADC_4156US |
                                        INA3221_CONV_TIME_SADC_4156US |
                                        INA3221_MODE_CONTINUOUS_SHUNT_BUS
                                    )
- INA3221*PARAM*RSHUNT*MOHM*CH1:    100
- INA3221*PARAM*RSHUNT*MOHM*CH2:    100
- INA3221*PARAM*RSHUNT*MOHM*CH3:    100

After initialization, the application will perform basic read/write
functionality tests. If the preceding static tests succeed, the program
will enter an endless loop and check if a full conversion cycle has
completed. If new values for shunt voltage and bus voltage are available,
current and power are calculated and each value for every channel is
printed to stdio in a neat table, with available status flags.
