/*
 * LI-FI ESP8266 NodeMCU V3 Firmware
 * Compatible with CH340G USB-to-Serial, for use with Raspberry Pi 3/4 controllers
 * Purpose: Transmit and receive LI-FI data using a photodiode and LED
 *
 * Pin Mapping:
 *   - LED (TX): D1 (GPIO5)
 *   - Photodiode (RX): A0 (ADC)
 *   - Serial: 115200 baud (USB CH340G)
 *
 * This firmware listens for serial commands from the Pi ("on", "off", "read")
 * and controls the LED or reads the photodiode accordingly.
 */

#include <Arduino.h>

#define LED_PIN D1
#define PHOTODIODE_PIN A0

void setup()
{
    Serial.begin(115200);
    pinMode(LED_PIN, OUTPUT);
    digitalWrite(LED_PIN, LOW);
}

void loop()
{
    // Handle serial commands from Pi
    if (Serial.available())
    {
        String cmd = Serial.readStringUntil('\n');
        cmd.trim();
        if (cmd.equalsIgnoreCase("on"))
        {
            digitalWrite(LED_PIN, HIGH);
            Serial.println("LED ON");
        }
        else if (cmd.equalsIgnoreCase("off"))
        {
            digitalWrite(LED_PIN, LOW);
            Serial.println("LED OFF");
        }
        else if (cmd.equalsIgnoreCase("read"))
        {
            int value = analogRead(PHOTODIODE_PIN);
            Serial.print("Photodiode: ");
            Serial.println(value);
        }
        else
        {
            Serial.print("Unknown command: ");
            Serial.println(cmd);
        }
    }
    delay(10);
}
