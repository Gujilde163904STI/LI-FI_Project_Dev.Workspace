// main.cpp
// PlatformIO LI-FI Project: Unified entry for TX and RX firmware
// This file delegates to board-specific code for ESP8266 TX/RX and Uno TX/RX

#if defined(ESP8266)
  #if defined(TX_BUILD)
    #include "tx_esp8266.ino"
  #elif defined(RX_BUILD)
    #include "rx_esp8266.ino"
  #else
    #error "Define TX_BUILD or RX_BUILD for ESP8266 build."
  #endif
#elif defined(ARDUINO_AVR_UNO)
  #if defined(TX_BUILD)
    #include "tx_uno.ino"
  #elif defined(RX_BUILD)
    #include "rx_uno.ino"
  #else
    #error "Define TX_BUILD or RX_BUILD for Uno build."
  #endif
#else
  #error "Unsupported board."
#endif
