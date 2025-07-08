# BME280_math module
| Since  | Origin / Contributor  | Maintainer  | Source  |
| :----- | :-------------------- | :---------- | :------ |
| 2016-02-21 | [vsky279](https://github.com/vsky279) | [vsky279](https://github.com/vsky279) | [bme280*math.c](../../app/modules/bme280*math.c)|

This module provides calculation routines for [BME280/BMP280 temperature/air presssure/humidity sensors](http://www.bosch-sensortec.com/bst/products/all_products/bme280) (Bosch Sensortec). Communication with the sensor is ensured by Lua code through I2C or SPI interface. Read registers are passed to the module to calculate measured values.

See [bme280](../lua-modules/bme280.md) Lua module for examples.

## bme280_math.altitude()

For given air pressure (called QFE in aviation - see [wiki QNH article](https://en.wikipedia.org/wiki/QNH)) and sea level air pressure returns the altitude in meters, i.e. altimeter function.

#### Syntax
`bme280_math.altitude([self], P, QNH)`

#### Parameters
- (optional) `self` userdata or table structure so that the function can be directly called as object method, parameter is ignored in the calculation
- `P` measured pressure
- `QNH` current sea level pressure

#### Returns
altitude in meters of measurement point

## bme280_math.dewpoint()

For given temperature and relative humidity returns the dew point in celsius.

#### Syntax
`bme280_math.dewpoint([self], H, T)`

#### Parameters
- (optional) `self` userdata or table structure so that the function can be directly called as object method, parameter is ignored in the calculation
- `H` relative humidity in percent (100 means 100%)
- `T` temperate in celsius

#### Returns
dew point in celsisus

## bme280_math.qfe2qnh()

For given altitude converts the air pressure to sea level air pressure ([QNH](https://en.wikipedia.org/wiki/QNH)).

#### Syntax
`bme280_math.qfe2qnh([self], P, altitude)`

#### Parameters
- (optional) `self` userdata or table structure so that the function can be directly called as object method, parameter is ignored in the calculation
- `P` measured pressure
- `altitude` altitude in meters of measurement point

#### Returns
sea level pressure


## bme280_math.read()

Reads the sensor and returns the temperature, the air pressure, the air relative humidity and see level air pressure when `altitude` is specified.

#### Syntax
`bme280_math.read(bme280sensor, registers, [altitude])`

#### Parameters
- `bme280sensor` - BME280 sensor user data returned by `bme280_math.setup()`
- `registers` - string of 8 bytes (chars) registers read from `BME280*REGISTER*PRESS`
- (optional) `altitude`- altitude in meters of measurement point. If provided also the air pressure converted to sea level air pressure is returned.

#### Returns
- `T` temperature in celsius
- `P` air pressure in hectopascals
- `H` relative humidity in percent
- (optional) `QNH` air pressure in hectopascals

Returns `nil` if the conversion is not successful.

## bme280_math.setup()

Initializes module. Initialization is mandatory before read values.

#### Syntax

`bme280*math.setup(registers, [temp*oss, press*oss, humi*oss, power*mode, inactive*duration, IIR_filter])`

#### Parameters
- registers - String of configuration registers read from the BME280 sensor. It consists of 6 bytes (chars) of `BME280*REGISTER*DIG*T`, 18 bytes (chars) `BME280*REGISTER*DIG*P` and optional (not present for BMP280 sensor) 8 bytes (chars) of `BME280*REGISTER*DIG*H1` (1 byte) and `BME280*REGISTER*DIG*H2` (7 bytes) 
- (optional) `temp_oss` - Controls oversampling of temperature data. Default oversampling is 16x.
- (optional) `press_oss` - Controls oversampling of pressure data. Default oversampling is 16x.
- (optional) `humi_oss` - Controls oversampling of humidity data. Default oversampling is 16x
- (optional) `sensor_mode` - Controls the sensor mode of the device. Default sensor more is normal.
- (optional) `inactive_duration` - Controls inactive duration in normal mode. Default inactive duration is 20ms.
- (optional) `IIR_filter` - Controls the time constant of the IIR filter. Default filter coefficient is 16.

|`temp*oss`, `press*oss`, `humi_oss`|Data oversampling|
|-----|-----------------|
|0|Skipped (output set to 0x80000)|
|1|oversampling ×1|
|2|oversampling ×2|
|3|oversampling ×4|
|4|oversampling ×8|
|**5**|**oversampling ×16**|

|`sensor_mode`|Sensor mode|
|-----|-----------------|
|0|Sleep mode|
|1 and 2|Forced mode|
|**3**|**Normal mode**|

Using forced mode is recommended for applications which require low sampling rate or hostbased synchronization. The sensor enters into sleep mode after a forced readout. Please refer to BME280 Final Datasheet for more details.

|`inactive_duration`|t standby (ms)|
|-----|-----------------|
|0|0.5|
|1|62.5|
|2|125|
|3|250|
|4|500|
|5|1000|
|6|10|
|**7**|**20**|

|`IIR_filter`|Filter coefficient |
|-----|-----------------|
|0|Filter off|
|1|2|
|2|4|
|3|8|
|**4**|**16**|

#### Returns
- `bme280sensor` user data (`nil` if initialization has failed)
- `config` 3 (2 for BME280) field table with configuration parameters to be written to registers `BME280*REGISTER*CONFIG`, `BME280*REGISTER*CONTROL*HUM`, `BME280*REGISTER_CONTROL` consecutively

#### Example
See [bme280](../lua-modules/bme280.md) Lua module documentation.


## BME280 (selected) registers
| name | address |
|-------|----------|
| BME280*REGISTER*CONTROL | 0xF4 |
| BME280*REGISTER*CONTROL_HUM | 0xF2 |
| BME280*REGISTER*CONFIG| 0xF5 |
| BME280*REGISTER*CHIPID | 0xD0 |
| BME280*REGISTER*DIG_T | 0x88  (0x88-0x8D (6)) |
| BME280*REGISTER*DIG_P | 0x8E  (0x8E-0x9F (18)) |
| BME280*REGISTER*DIG_H1 | 0xA1 |
| BME280*REGISTER*DIG_H2 | 0xE1  (0xE1-0xE7 (7))  |
| BME280*REGISTER*PRESS | 0xF7	 (0xF7-0xF9 (8)) |

