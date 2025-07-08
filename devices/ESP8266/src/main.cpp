#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <WiFiUdp.h>

#define LED_TX_PIN D4  // GPIO2 (TX)
#define STATUS_LED D2  // GPIO4 (status)
#define TCP_PORT 9000
#define UDP_PORT 9001
#define HANDSHAKE_MSG "HELLO"
#define ACK_MSG "ACK"
#define RETRY_LIMIT 3
#define HANDSHAKE_TIMEOUT 2000  // ms
#define BIT_DURATION 100        // ms per Manchester bit

const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";
const char* rpi_ip = "192.168.4.2"; // Set to RPi IP or use broadcast for UDP

WiFiUDP udp;

void blinkStatus(int times, bool fast = true) {
  for (int i = 0; i < times; i++) {
    digitalWrite(STATUS_LED, HIGH);
    delay(fast ? 100 : 500);
    digitalWrite(STATUS_LED, LOW);
    delay(100);
  }
}

void manchester_send_byte(uint8_t b) {
  for (int i = 7; i >= 0; i--) {
    int bit = (b >> i) & 1;
    if (bit == 1) {
      digitalWrite(LED_TX_PIN, HIGH);
      delay(BIT_DURATION);
      digitalWrite(LED_TX_PIN, LOW);
      delay(BIT_DURATION);
    } else {
      digitalWrite(LED_TX_PIN, LOW);
      delay(BIT_DURATION);
      digitalWrite(LED_TX_PIN, HIGH);
      delay(BIT_DURATION);
    }
    blinkStatus(1, true); // Blink status for each bit sent
  }
}

void send_handshake() {
  const char* msg = HANDSHAKE_MSG;
  for (int i = 0; msg[i]; i++) {
    manchester_send_byte(msg[i]);
  }
}

void send_test_message() {
  const char* msg = "Hello from ESP8266";
  for (int i = 0; msg[i]; i++) {
    manchester_send_byte(msg[i]);
  }
}

void setup_wifi_sta() {
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.print("[INFO] Connecting to Wi-Fi");
  int tries = 0;
  while (WiFi.status() != WL_CONNECTED && tries < 20) {
    delay(500);
    Serial.print(".");
    tries++;
  }
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[INFO] Wi-Fi connected");
    Serial.print("[INFO] IP address: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("\n[WARN] Wi-Fi connect failed, fallback to AP mode");
    WiFi.softAP("LIFI-ESP8266", "lifi1234");
  }
}

bool tcp_handshake() {
  WiFiClient client;
  if (!client.connect(rpi_ip, TCP_PORT)) {
    Serial.println("[WARN] TCP connect failed");
    return false;
  }
  client.write(HANDSHAKE_MSG, strlen(HANDSHAKE_MSG));
  unsigned long start = millis();
  while (millis() - start < HANDSHAKE_TIMEOUT) {
    if (client.available()) {
      String resp = client.readStringUntil('\n');
      if (resp.indexOf(ACK_MSG) >= 0) {
        Serial.println("[INFO] TCP handshake ACK received");
        blinkStatus(1, false);
        return true;
      }
    }
  }
  client.stop();
  return false;
}

void setup() {
  pinMode(LED_TX_PIN, OUTPUT);
  pinMode(STATUS_LED, OUTPUT);
  digitalWrite(STATUS_LED, LOW);
  Serial.begin(115200);
  delay(1000);
  Serial.println("[INFO] ESP8266 LI-FI firmware starting...");
  setup_wifi_sta();
  int retries = 0;
  bool handshake_ok = false;
  while (retries < RETRY_LIMIT && !handshake_ok) {
    Serial.printf("[INFO] Sending handshake via light (try %d/%d)...\n", retries+1, RETRY_LIMIT);
    send_handshake();
    // TODO: Wait for ACK via network or light
    delay(HANDSHAKE_TIMEOUT);
    // Simulate no ACK for now
    blinkStatus(1, true);
    retries++;
  }
  if (!handshake_ok) {
    Serial.println("[ERROR] Handshake failed after retries. Entering fallback mode.");
    blinkStatus(5, true);
    // TODO: Remain in AP mode, wait for manual intervention
  } else {
    Serial.println("[INFO] Handshake complete. Sending test message...");
    send_test_message();
  }
}

void loop() {
  // TODO: Main data transfer logic (light encoding, etc.)
  delay(1000);
} 