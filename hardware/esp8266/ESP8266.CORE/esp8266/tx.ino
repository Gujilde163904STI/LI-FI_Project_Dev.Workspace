// tx.ino
// ESP8266 Arduino code for LI-FI Transmitter
// Sends data via LED (TX)
//
// NOTE: This is an alternate/test version. For main project operation, use tx/esp_tx.ino (115200 baud, config-matched).

void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  if (Serial.available()) {
    char c = Serial.read();
    digitalWrite(LED_BUILTIN, c == '1' ? HIGH : LOW);
    Serial.print("TX: ");
    Serial.println(c);
  }
  delay(10);
}
