// tx_esp8266.ino
// ESP8266 LI-FI Transmitter (TX)
#define TX_LED_PIN 2 // GPIO2 (D4)
#define SERIAL_BAUD 115200

void setup()
{
    pinMode(TX_LED_PIN, OUTPUT);
    digitalWrite(TX_LED_PIN, LOW);
    Serial.begin(SERIAL_BAUD);
    while (!Serial)
    {
        delay(10);
    }
}

void loop()
{
    if (Serial.available())
    {
        String data = Serial.readStringUntil('\n');
        for (size_t i = 0; i < data.length(); ++i)
        {
            sendByte(data[i]);
        }
        sendByte('\n');
    }
}

void sendByte(uint8_t b)
{
    for (int i = 0; i < 8; ++i)
    {
        bool bit = (b >> i) & 0x01;
        digitalWrite(TX_LED_PIN, bit ? HIGH : LOW);
        delayMicroseconds(1000); // Adjust for your hardware
    }
    digitalWrite(TX_LED_PIN, LOW);
    delayMicroseconds(2000); // Inter-byte gap
}
