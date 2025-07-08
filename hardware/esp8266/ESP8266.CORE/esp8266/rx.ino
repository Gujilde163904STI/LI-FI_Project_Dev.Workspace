// rx.ino
// ESP8266 Arduino code for LI-FI Receiver
// Receives data via photodiode (RX)
//
// NOTE: This is an alternate/test version. For main project operation, use rx/esp_rx.ino (115200 baud, config-matched).

void setup() {
  Serial.begin(9600);
}

void loop() {
  int sensorValue = analogRead(A0);
  if (sensorValue > 512) {
    Serial.println("1");
  } else {
    Serial.println("0");
  }
  delay(100);
}
