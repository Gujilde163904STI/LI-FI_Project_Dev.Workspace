/*
rx/rx_esp8266.ino
ESP8266 LI-FI receiver: Reads photodiode (A0), decodes light pulses, sends binary data over serial.
# HARDWARE_VERIFY: Test with real hardware.
*/

#define RX_PHOTODIODE_PIN A0
#define SERIAL_BAUD 115200
#define THRESHOLD 512 // Adjust based on ambient light and photodiode

void setup()
{
    Serial.begin(SERIAL_BAUD);
    while (!Serial)
    {
        delay(10);
    }
}

void loop()
{
    uint8_t byteVal = 0;
    for (int i = 0; i < 8; ++i)
    {
        byteVal |= (readBit() << i);
        delayMicroseconds(1000); // Match TX timing
    }
    if (byteVal != 0)
    {
        Serial.write(byteVal);
    }
    // Wait for inter-byte gap
    delayMicroseconds(2000);
}

uint8_t readBit()
{
    int val = analogRead(RX_PHOTODIODE_PIN);
    return (val > THRESHOLD) ? 1 : 0;
}
