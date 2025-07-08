// ESP8266 RX: Reads photodiode and transmits data to RPi via serial
// MAIN RX FIRMWARE: Use this for production. Baudrate and pinout match config/settings.json.
// Hardware: NodeMCU ESP8266 V3, photodiode on pin A0
//
const int PHOTODIODE_PIN = A0; // See config/settings.json: rx_photodiode_pin
const int THRESHOLD = 500;     // Adjust as needed for your photodiode

void setup() {
  Serial.begin(115200); // See config/settings.json: baudrate
}

void loop() {
  int val = analogRead(PHOTODIODE_PIN);
  Serial.println(val > THRESHOLD ? "1" : "0");
  delay(1); // See config/settings.json: pulse_delay_ms
}