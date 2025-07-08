// ESP8266 TX: Receives data via serial and modulates LED light pulses
// MAIN TX FIRMWARE: Use this for production. Baudrate and pinout match config/settings.json.
// Hardware: NodeMCU ESP8266 V3, LED on pin 2
//
const int LED_PIN = 2; // See config/settings.json: tx_led_pin

void setup() {
  Serial.begin(115200); // See config/settings.json: baudrate
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  if (Serial.available()) {
    String msg = Serial.readStringUntil('\n');
    Serial.println("TX Received: " + msg);
    for (char c : msg) {
      digitalWrite(LED_PIN, HIGH);
      delay(1); // See config/settings.json: pulse_delay_ms
      digitalWrite(LED_PIN, LOW);
      delay(1);
    }
  }
}