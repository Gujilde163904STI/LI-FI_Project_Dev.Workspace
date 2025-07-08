| Supported Targets | ESP32 | ESP32-C2 | ESP32-C3 | ESP32-C5 | ESP32-C6 | ESP32-S2 | ESP32-S3 |
| ----------------- | ----- | -------- | -------- | -------- | -------- | -------- | -------- |

# WiFi NVS Config Example

(See the `README.md` file in the upper-level 'examples' directory for more information about examples.)

This example demonstrates how to configure Wi-Fi settings in NVS directly using a CSV file and utilize the Wi-Fi functionality of the ESP Wi-Fi driver.

## How to Use the Example

### 1) Configuration

Open the CSV file `nvs*station*data.csv` or `nvs*ap*data.csv`.

- Set the Wi-Fi configuration keys as explained below. These values are written into the NVS partition and read by the Wi-Fi driver during `esp*wifi*init()`.
- If needed, adjust or set other options as per your requirements. The AP and station keys along with their encoding types are listed [here](#key-configuration).

**Note 1:** To set the device in SoftAP mode, enable the `CONFIG*ESP*WIFI*SOFTAP*SUPPORT` flag in `menuconfig`.

**Note 2:** Setting these values is optional. Defaults are applied when `esp*wifi*init()` is called.

### 2) Generate the Binary File Using the NVS Partition Generator Utility

- Check the size of the NVS partition in the `partition_example.csv` file provided in this example.
- Generate a `.bin` file of the specified size using the following command:

**Usage:**

```bash
python nvs_partition_gen.py generate [-h] [--version {1,2}] [--outdir OUTDIR] input output size
```

- Sample command:

```bash
python nvs_partition_gen.py generate nvs_station_data.csv sample_nvs.bin 0x6000
```

- Please update the NVS Partition Generator to the latest version to avoid encoding type errors.
- For more information, see the [NVS Partition Generator Utility Documentation](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/storage/nvs*partition*gen.html).

### 3) Flash the NVS Binary File to the ESP Device

- Check the offset of the NVS partition in the `partition_example.csv` file.
- After flashing the build, flash the `sample_nvs.bin` file to the ESP device at the specified offset using `esptool.py`.
- Refer to the [Esptool Documentation](https://docs.espressif.com/projects/esptool/en/latest/esp32/esptool/index.html) for detailed usage.

### 4) Build and Flash

Build the project and flash it to the board, then run the monitor tool to view the serial output.

Run `idf.py -p PORT flash monitor` to build, flash and monitor the project.

(To exit the serial monitor, type ``Ctrl-]``.)

### 5) Monitor the Output

- Use `idf.py monitor` to view the console output of the example.

See the Getting Started Guide for all the steps to configure and use the ESP-IDF to build projects.

* [ESP-IDF Getting Started Guide on ESP32](https://docs.espressif.com/projects/esp-idf/en/latest/get-started/index.html)

## Key Configuration

### Station Keys


  | Key Name                 | Encoding Type | Mandatory/Optional  | Description / Meaning                              |
  |--------------------------|---------------|---------------------|----------------------------------------------------|
  | sta.ssid                 | blob*sz*fill  | Mandatory           | SSID (Service Set Identifier) for station. (Refer parameter `uint8*t ssid[32]` from `struct wifi*sta*config*t`)      |
  | sta.pswd                 | blob*fill     | Mandatory           | Password for connecting to the Wi-Fi network. (Refer parameter `uint8*t password[64]` from `struct wifi*sta*config_t`)      |
  | bssid.set                | u8            | Optional            | Whether the BSSID is set or not. (Refer parameter `bool bssid*set` from `struct wifi*sta*config*t`)                  |
  | sta.bssid                | blob          | Optional            | BSSID (Basic Service Set Identifier) of the network. (Refer parameter `uint8*t bssid[6]` from `struct wifi*sta*config*t`) |
  | sta.lis*intval           | u16           | Optional            | Listen interval (Refer parameter `uint16*t listen*interval` from `struct wifi*sta*config*t`)           |
  | sta.phym                 | u8            | Optional            | Physical mode e.g., 802.11a/b/g/n/ac/ax. (Refer `esp*err*t esp*wifi*set*protocol(wifi*interface*t ifx, uint8*t protocol_bitmap)`)            |
  | sta.phybw                | u8            | Optional            | Physical bandwidth (e.g., 20MHz, 40MHz) (Refer `esp*err*t esp*wifi*set*bandwidth(wifi*interface*t ifx, wifi*bandwidths_t* bw)`)           |
  | sta.sort*method          | u8            | Optional            | Sorting method for APs e.g. enum wifi*sort*method*t (Refer parameter `wifi*sort*method*t sort*method` from `struct wifi*sta*config_t`)|
  | sta.minrssi              | i8            | Optional            | Minimum RSSI for the station to connect. (Refer `esp*err*t esp*wifi*set*rssi*threshold()` OR `int8*t rssi` from `wifi*scan*threshold*t threshold`)       |
  | sta.minauth              | u8            | Optional            | Minimum authentication level required for APs. (Refer `wifi*auth*mode*t authmode` from `wifi*scan*threshold*t threshold`)  |
  | sta.pmf*r                | u8            | Optional            | Whether PMF is required. (Refer `wifi*pmf*config*t pmf*cfg` parameter from `struct wifi*sta*config*t`)                          |
  | sta.btm*e                | u8            | Optional            | Whether BTM is enabled. (Refer parameter `uint32*t btm*enabled` from `struct wifi*sta*config*t`)                           |
  | sta.rrm*e                | u8            | Optional            | Whether RRM is enabled. (Refer parameter `uint32*t rm*enabled` from `struct wifi*sta*config*t`)                           |
  | sta.mbo*e                | u8            | Optional            | Whether MBO (Multi-band Operation) is enabled. (Refer parameter `uint32*t mbo*enabled` from `struct wifi*sta*config*t`)     |
  | sta.phym5g               | u8            | Optional            | 5 GHz physical mode. (Only for chips supporting 5GHz bandwidth. (Refer `esp*err*t esp*wifi*set*protocol(wifi*interface*t ifx, uint8*t protocol_bitmap)`)  |
  | sta.phybw5g              | u8            | Optional            | 5 GHz bandwidth setting.(Only for chips supporting 5GHz bandwidth. (Refer `esp*err*t esp*wifi*set*bandwidths(wifi*interface*t ifx, wifi*bandwidths_t* bw)` |
  | sta.ft                   | u8            | Optional            | Whether fast transition is enabled. (Refer parameter `uint32*t ft*enabled` from `struct wifi*sta*config_t`)               |
  | sta.owe                  | u8            | Optional            | Whether OWE (Opportunistic Wireless Encryption) is enabled. (Refer parameter `uint32*t owe*enabled` from `struct wifi*sta*config_t`)  |
  | sta.trans*d              | u8            | Optional            | Transition disabled setting. (Refer parameter `uint32*t transition*disable` from `struct wifi*sta*config*t`)                    |
  | sta.sae*h2e              | u8            | Optional            | SAE PWE method (e.g. enum wifi*sae*pwe*method*t). (Refer parameter `wifi*sae*pwe*method*t sae*pwe*h2e` from `struct wifi*sta*config*t`) |
  | sta.sae*pk*mode          | u8            | Optional            | SAE-pk mode setting (e.g. enum wifi*sae*pk*mode*t) (Refer parameter `wifi*sae*pk*mode*t sae*pk*mode` from `struct wifi*sta*config_t`)         |
  | sta.bss*retry            | u8            | Optional            | BSS retry counter. (Refer parameter `uint8*t failure*retry*cnt` from `struct wifi*sta*config_t`)                               |
  | sta.sae*h2e*id           | blob          | Optional            | Password identifier for H2E. This must be a null-terminated string (Refer parameter `uint8*t sae*h2e*identifier[SAE*H2E*IDENTIFIER*LEN]` from `struct wifi*sta*config_t`)          |
  | sta.rssi*5g*adj          | u8            | Optional            | RSSI adjustment for 5 GHz. (Refer `uint8*t rssi*5g*adjustment` from `wifi*scan*threshold*t threshold`)      |


### AP Keys

  | Key Name                 | Encoding Type | Mandatory/Optional  | Description / Meaning                              |
  |--------------------------|---------------|---------------------|----------------------------------------------------|
  | ap.ssid                  | blob*sz*fill  | Mandatory           | SSID (Service Set Identifier) for the AP prefixed with the length of the SSID. (Refer parameter `uint8*t ssid[32]` from `struct wifi*ap*config*t`)        |
  | ap.passwd                | blob*fill     | Mandatory           | Password for the AP's Wi-Fi network. (Refer parameter `uint8*t password[64]` from `struct wifi*ap*config_t`)              |
  | ap.chan                  | u8            | Mandatory           | Channel number on which the AP is broadcasting. (Refer parameter `uint8*t channel` from `struct wifi*ap*config*t`)   |
  | ap.authmode              | u8            | Mandatory           | Authentication mode for the AP e.g. enum wifi*auth*mode*t. (Refer parameter `wifi*auth*mode*t authmode` from `struct wifi*ap*config_t`)  |
  | ap.hidden                | u8            | Optional            | Whether the AP is hidden (1 for hidden, 0 for visible). (Refer parameter `uint8*t ssid*hidden` from `struct wifi*ap*config_t`) |
  | ap.max.conn              | u8            | Optional            | Maximum number of connections the AP supports. It is different for different chips.(Please refer parameter `uint8*t max*connection` from `struct wifi*ap*config_t` and [AP Basic Configurations](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/wifi.html#ap-basic-configuration) for more details).    |
  | bcn.interval             | u8            | Optional            | Beacon interval time for the AP. (Refer parameter `uint16*t beacon*interval` from `struct wifi*ap*config_t`))                 |
  | ap.pmf*r                 | u8            | Optional            | Whether PMF is required on the AP. (Refer parameter `wifi*pmf*config*t pmf*cfg` from `struct wifi*ap*config*t`))               |
  | ap.p*cipher              | u8            | Optional            | Pairwise Cipher suite used by the AP e.g. enum wifi*cipher*type*t (Refer parameter `wifi*cipher*type*t pairwise*cipher` from `struct wifi*ap*config_t`)  |
  | ap.ftm*r                 | u8            | Optional            | Whether FTM (Fine Timing Measurement) responder is enabled. (Refer parameter `bool ftm*responder` from `struct wifi*ap*config_t`)  |
  | ap.sae*h2e               | u8            | Optional            | Config method for SAE e.g. enum `wifi*sae*pwe*method*t` (Refer parameter `wifi*sae*pwe*method*t sae*pwe*h2e` from `struct wifi*ap*config*t`) |
  | ap.csa*count             | u8            | Optional            | Channel Switch Announcement count for the AP. (Refer parameter `uint8*t csa*count` from `struct wifi*ap*config*t`)    |
  | ap.dtim*period           | u8            | Optional            | DTIM period for the AP. (Refer parameter `uint8*t dtim*period` from `struct wifi*ap*config*t`)                           |
  | ap.phym5g                | u8            | Optional            | 5 GHz physical mode. (Refer `esp*err*t esp*wifi*set*protocol(wifi*interface*t ifx, uint8*t protocol_bitmap)`)                               |
  | ap.phybw5g               | u8            | Optional            | 5 GHz bandwidth setting. (Refer `esp*err*t esp*wifi*set*bandwidths(wifi*interface*t ifx, wifi*bandwidth_t bw)`)                           |

### Generic Keys

  | Key Name                 | Encoding Type | Mandatory/Optional  | Description / Meaning                              |
  |--------------------------|---------------|---------------------|----------------------------------------------------|
  | opmode                   | u8            | Mandatory           | Operating mode (e.g. enum `wifi*mode*t` OR refer `esp*err*t esp*wifi*set*mode(wifi*mode_t mode)`)      |
  | country                  | blob          | Optional            | Operating country (e.g. enum `wifi*country*t` OR refer `esp*err*t esp*wifi*set*country*code(const char *country, bool ieee80211d_enabled)`)      |
  | band*mode                | u8            | Optional            | Operating band (e.g. enum `wifi*band*t` or refer [esp*err*t esp*wifi*set*band*mode(wifi*band*mode*t band*mode)](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/network/esp*wifi.html#*CPPv422esp*wifi*set*band*mode16wifi*band*mode*t))      |

These keys can be configured by setting the desired values in `nvs*station*data.csv` or `nvs*ap*data.csv`.

For more details on station and AP configurations, refer to the following:

- [Station Basic Configuration](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/wifi.html#station-basic-configuration)
- [AP Basic Configuration](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/wifi.html#ap-basic-configuration)

Also review the limitations for values of each key in the [ESP-IDF API Reference Guide](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/network/esp_wifi.html).


## Example Output
Note that the output, in particular the order of the output, may vary depending on the environment.

Console output if station connects to AP successfully:
```
I (599) wifi: wifi driver task: 3ffc08b4, prio:23, stack:3584, core=0
I (599) system_api: Base MAC address is not set, read default base MAC address from BLK0 of EFUSE
I (599) system_api: Base MAC address is not set, read default base MAC address from BLK0 of EFUSE
I (629) wifi: wifi firmware version: 2d94f02
I (629) wifi: config NVS flash: enabled
I (629) wifi: config nano formatting: disabled
I (629) wifi: Init dynamic tx buffer num: 32
I (629) wifi: Init data frame dynamic rx buffer num: 32
I (639) wifi: Init management frame dynamic rx buffer num: 32
I (639) wifi: Init management short buffer num: 32
I (649) wifi: Init static rx buffer size: 1600
I (649) wifi: Init static rx buffer num: 10
I (659) wifi: Init dynamic rx buffer num: 32
I (759) phy: phy_version: 4180, cb3948e, Sep 12 2019, 16:39:13, 0, 0
I (769) wifi: mode : sta (30:ae:a4:d9:bc:c4)
I (769) wifi station: wifi_init_sta finished.
I (889) wifi: new:<6,0>, old:<1,0>, ap:<255,255>, sta:<6,0>, prof:1
I (889) wifi: state: init -> auth (b0)
I (899) wifi: state: auth -> assoc (0)
I (909) wifi: state: assoc -> run (10)
I (939) wifi: connected with #!/bin/test, aid = 1, channel 6, BW20, bssid = ac:9e:17:7e:31:40
I (939) wifi: security type: 3, phy: bgn, rssi: -68
I (949) wifi: pm start, type: 1

I (1029) wifi: AP's beacon interval = 102400 us, DTIM period = 3
I (2089) esp_netif_handlers: sta ip: 192.168.77.89, mask: 255.255.255.0, gw: 192.168.77.1
I (2089) wifi station: got ip:192.168.77.89
I (2089) wifi station: connected to ap SSID:myssid password:mypassword
```

Console output if the station failed to connect to AP:
```
I (599) wifi: wifi driver task: 3ffc08b4, prio:23, stack:3584, core=0
I (599) system_api: Base MAC address is not set, read default base MAC address from BLK0 of EFUSE
I (599) system_api: Base MAC address is not set, read default base MAC address from BLK0 of EFUSE
I (629) wifi: wifi firmware version: 2d94f02
I (629) wifi: config NVS flash: enabled
I (629) wifi: config nano formatting: disabled
I (629) wifi: Init dynamic tx buffer num: 32
I (629) wifi: Init data frame dynamic rx buffer num: 32
I (639) wifi: Init management frame dynamic rx buffer num: 32
I (639) wifi: Init management short buffer num: 32
I (649) wifi: Init static rx buffer size: 1600
I (649) wifi: Init static rx buffer num: 10
I (659) wifi: Init dynamic rx buffer num: 32
I (759) phy: phy_version: 4180, cb3948e, Sep 12 2019, 16:39:13, 0, 0
I (759) wifi: mode : sta (30:ae:a4:d9:bc:c4)
I (769) wifi station: wifi_init_sta finished.
I (889) wifi: new:<6,0>, old:<1,0>, ap:<255,255>, sta:<6,0>, prof:1
I (889) wifi: state: init -> auth (b0)
I (1889) wifi: state: auth -> init (200)
I (1889) wifi: new:<6,0>, old:<6,0>, ap:<255,255>, sta:<6,0>, prof:1
I (1889) wifi station: retry to connect to the AP
I (1899) wifi station: connect to the AP fail
I (3949) wifi station: retry to connect to the AP
I (3949) wifi station: connect to the AP fail
I (4069) wifi: new:<6,0>, old:<6,0>, ap:<255,255>, sta:<6,0>, prof:1
I (4069) wifi: state: init -> auth (b0)
I (5069) wifi: state: auth -> init (200)
I (5069) wifi: new:<6,0>, old:<6,0>, ap:<255,255>, sta:<6,0>, prof:1
I (5069) wifi station: retry to connect to the AP
I (5069) wifi station: connect to the AP fail
I (7129) wifi station: retry to connect to the AP
I (7129) wifi station: connect to the AP fail
I (7249) wifi: new:<6,0>, old:<6,0>, ap:<255,255>, sta:<6,0>, prof:1
I (7249) wifi: state: init -> auth (b0)
I (8249) wifi: state: auth -> init (200)
I (8249) wifi: new:<6,0>, old:<6,0>, ap:<255,255>, sta:<6,0>, prof:1
I (8249) wifi station: retry to connect to the AP
I (8249) wifi station: connect to the AP fail
I (10299) wifi station: connect to the AP fail
I (10299) wifi station: Failed to connect to SSID:myssid, password:mypassword
```

## Troubleshooting

For any technical queries, please open an [issue](https://github.com/espressif/esp-idf/issues) on GitHub. We will get back to you soon.
