# REGULATORY

## Introduction
`esp*wifi*regulatory.txt` and `esp*wifi*regulatory.c` defines wireless communication regulations for different countries and regions to ensure that the device operates in compliance with local regulations.

`esp*wifi*regulatory.c` is generated from `esp*wifi*regulatory.txt` by using the `reg2fw.py` script.

The num of all suppported countries in `esp*wifi*regulatory.txt` is `WIFI*MAX*SUPPORT*COUNTRY*NUM` that is defined in `esp*wifi*types_generic.h`

- Generate `esp*wifi*regulatory.c`
  - `cd ~/esp-idf/components/esp_wifi/regulatory`
  - `python reg2fw.py`