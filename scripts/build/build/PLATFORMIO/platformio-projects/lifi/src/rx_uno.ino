// rx_uno.ino
// Arduino Uno LI-FI Receiver (RX)
#define RX_PHOTODIODE_PIN A0
#define SERIAL_BAUD 115200
#define THRESHOLD 512

void setup()
{
    Serial.begin(SERIAL_BAUD);
}

void loop()
{
    uint8_t byteVal = 0;
    for (int i = 0; i < 8; ++i)
    {
        byteVal |= (readBit() << i);
        delayMicroseconds(1000);
    }
    if (byteVal != 0)
    {
        Serial.write(byteVal);
    }
    delayMicroseconds(2000);
}

uint8_t readBit()
{
    int val = analogRead(RX_PHOTODIODE_PIN);
    return (val > THRESHOLD) ? 1 : 0;
}
