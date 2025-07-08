/*
 * LI-FI Project ESP8266 Main Sketch
 *
 * This sketch implements the transmitter/receiver functionality for the LI-FI
 * project. It can operate in both transmitter and receiver modes based on
 * configuration.
 */

#include <Arduino.h>
#include <ArduinoJson.h>
#include <ESP8266HTTPClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <WiFiManager.h>

// Configuration
#define LED_PIN 2         // Built-in LED on NodeMCU
#define PHOTODIODE_PIN A0 // Analog input for photodiode
#define BUTTON_PIN 0      // Flash button for mode switching
#define SERIAL_BAUD 115200

// LI-FI Communication settings
#define LIFI_FREQUENCY 1000 // Hz
#define LIFI_DUTY_CYCLE 50  // %
#define LIFI_TIMEOUT 5000   // ms

// WiFi and MQTT settings
const char *mqtt_server = "192.168.1.100";
const int mqtt_port = 1883;
const char *mqtt_client_id = "lifi_esp8266";
const char *mqtt_topic_tx = "lifi/transmit";
const char *mqtt_topic_rx = "lifi/receive";

// Global objects
WiFiClient espClient;
PubSubClient mqtt_client(espClient);
ESP8266WebServer web_server(80);
WiFiManager wifi_manager;

// State variables
bool is_transmitter = true;
bool wifi_connected = false;
bool mqtt_connected = false;
unsigned long last_transmission = 0;
unsigned long last_reception = 0;

// Function prototypes
void setupWiFi();
void setupMQTT();
void setupWebServer();
void handleTransmission();
void handleReception();
void sendData(const String &data);
String receiveData();
void toggleMode();
void handleRoot();
void handleConfig();
void mqttCallback(char *topic, byte *payload, unsigned int length);

void setup() {
  // Initialize serial communication
  Serial.begin(SERIAL_BAUD);
  Serial.println();
  Serial.println("=== LI-FI Project ESP8266 ===");
  Serial.println("Initializing...");

  // Initialize GPIO pins
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(PHOTODIODE_PIN, INPUT);

  // Set initial LED state
  digitalWrite(LED_PIN, LOW);

  // Setup WiFi
  setupWiFi();

  // Setup MQTT
  setupMQTT();

  // Setup web server
  setupWebServer();

  Serial.println("Initialization complete!");
  Serial.print("Mode: ");
  Serial.println(is_transmitter ? "Transmitter" : "Receiver");
}

void loop() {
  // Handle WiFi manager if not connected
  if (!wifi_connected) {
    wifi_manager.process();
    return;
  }

  // Handle MQTT
  if (mqtt_connected) {
    mqtt_client.loop();
  }

  // Handle web server
  web_server.handleClient();

  // Check for mode toggle button
  if (digitalRead(BUTTON_PIN) == LOW) {
    delay(50); // Debounce
    if (digitalRead(BUTTON_PIN) == LOW) {
      toggleMode();
      delay(1000); // Prevent multiple toggles
    }
  }

  // Main operation loop
  if (is_transmitter) {
    handleTransmission();
  } else {
    handleReception();
  }

  // Small delay to prevent watchdog reset
  delay(10);
}

void setupWiFi() {
  Serial.println("Setting up WiFi...");

  // Configure WiFi manager
  wifi_manager.setAPCallback([](WiFiManager *myWiFiManager) {
    Serial.println("Entered config mode");
    Serial.println(WiFi.softAPIP());
    Serial.println(myWiFiManager->getConfigPortalSSID());
  });

  // Try to connect to saved WiFi
  if (wifi_manager.autoConnect("LI-FI_ESP8266")) {
    Serial.println("WiFi connected!");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
    wifi_connected = true;
  } else {
    Serial.println("Failed to connect to WiFi");
    wifi_connected = false;
  }
}

void setupMQTT() {
  if (!wifi_connected)
    return;

  Serial.println("Setting up MQTT...");
  mqtt_client.setServer(mqtt_server, mqtt_port);
  mqtt_client.setCallback(mqttCallback);

  // Try to connect to MQTT broker
  if (mqtt_client.connect(mqtt_client_id)) {
    Serial.println("MQTT connected!");
    mqtt_client.subscribe(mqtt_topic_rx);
    mqtt_connected = true;
  } else {
    Serial.println("Failed to connect to MQTT broker");
    mqtt_connected = false;
  }
}

void setupWebServer() {
  Serial.println("Setting up web server...");

  web_server.on("/", handleRoot);
  web_server.on("/config", handleConfig);
  web_server.on("/toggle", []() {
    toggleMode();
    web_server.send(200, "text/plain", "Mode toggled");
  });

  web_server.begin();
  Serial.println("Web server started on port 80");
}

void handleTransmission() {
  // Check if it's time to transmit
  if (millis() - last_transmission > LIFI_TIMEOUT) {
    // Create sample data to transmit
    String data = "Hello from LI-FI transmitter!";
    sendData(data);
    last_transmission = millis();
  }
}

void handleReception() {
  // Read photodiode value
  int light_value = analogRead(PHOTODIODE_PIN);

  // Simple threshold-based detection
  if (light_value > 512) {                 // Adjust threshold as needed
    if (millis() - last_reception > 100) { // Debounce
      String received_data = receiveData();
      Serial.print("Received: ");
      Serial.println(received_data);
      last_reception = millis();
    }
  }
}

void sendData(const String &data) {
  Serial.print("Transmitting: ");
  Serial.println(data);

  // LI-FI transmission using LED
  // This is a simple implementation - in practice, you'd use more sophisticated
  // modulation

  // Turn LED on to start transmission
  digitalWrite(LED_PIN, HIGH);
  delay(100);

  // Send data as Morse-like code (simplified)
  for (char c : data) {
    for (int i = 0; i < 8; i++) {
      bool bit = (c >> i) & 1;
      if (bit) {
        digitalWrite(LED_PIN, HIGH);
        delay(50);
        digitalWrite(LED_PIN, LOW);
        delay(50);
      } else {
        digitalWrite(LED_PIN, LOW);
        delay(100);
      }
    }
    delay(200); // Character spacing
  }

  // Turn LED off to end transmission
  digitalWrite(LED_PIN, LOW);

  // Send via MQTT if available
  if (mqtt_connected) {
    mqtt_client.publish(mqtt_topic_tx, data.c_str());
  }
}

String receiveData() {
  // Simple LI-FI reception implementation
  // In practice, you'd use more sophisticated demodulation

  String received = "";
  unsigned long start_time = millis();

  // Wait for start of transmission (LED on)
  while (analogRead(PHOTODIODE_PIN) < 512 && millis() - start_time < 1000) {
    delay(10);
  }

  if (millis() - start_time >= 1000) {
    return "TIMEOUT";
  }

  // Read data (simplified)
  for (int i = 0; i < 10; i++) { // Read 10 characters max
    char c = 0;
    for (int bit = 0; bit < 8; bit++) {
      delay(50);
      if (analogRead(PHOTODIODE_PIN) > 512) {
        c |= (1 << bit);
      }
    }
    received += c;
    delay(200);
  }

  return received;
}

void toggleMode() {
  is_transmitter = !is_transmitter;
  Serial.print("Mode switched to: ");
  Serial.println(is_transmitter ? "Transmitter" : "Receiver");

  // Visual feedback
  for (int i = 0; i < 3; i++) {
    digitalWrite(LED_PIN, HIGH);
    delay(100);
    digitalWrite(LED_PIN, LOW);
    delay(100);
  }
}

void handleRoot() {
    String html = R"(
<!DOCTYPE html>
<html>
<head>
    <title>LI-FI ESP8266 Control</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        .status { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .online { background-color: #d4edda; color: #155724; }
        .offline { background-color: #f8d7da; color: #721c24; }
        button { padding: 10px 20px; margin: 5px; border: none; border-radius: 5px; cursor: pointer; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-success { background-color: #28a745; color: white; }
        .btn-warning { background-color: #ffc107; color: black; }
    </style>
</head>
<body>
    <div class="container">
        <h1>LI-FI ESP8266 Control Panel</h1>
        
        <div class="status )" + (wifi_connected ? "online" : "offline") + R"(">
            WiFi: )" + (wifi_connected ? "Connected" : "Disconnected") + R"(
        </div>
        
        <div class="status )" + (mqtt_connected ? "online" : "offline") + R"(">
            MQTT: )" + (mqtt_connected ? "Connected" : "Disconnected") + R"(
        </div>
        
        <div class="status )" + (is_transmitter ? "online" : "offline") + R"(">
            Mode: )" + (is_transmitter ? "Transmitter" : "Receiver") + R"(
        </div>
        
        <div>
            <button class="btn-warning" onclick="toggleMode()">Toggle Mode</button>
            <button class="btn-primary" onclick="location.reload()">Refresh</button>
        </div>
        
        <div>
            <h3>System Information</h3>
            <p>Free Heap: )" + String(ESP.getFreeHeap()) + R"( bytes</p>
            <p>Uptime: )" + String(millis() / 1000) + R"( seconds</p>
        </div>
    </div>
    
    <script>
        function toggleMode() {
    fetch('/toggle').then(response = > response.text()).then(data = > {
      console.log(data);
      setTimeout(() = > location.reload(), 1000);
    });
        }
    </script>
</body>
</html>
    )";
    
    web_server.send(200, "text/html", html);
}

void handleConfig() {
  String config = "{";
  config += "\"mode\":\"" +
            String(is_transmitter ? "transmitter" : "receiver") + "\",";
  config +=
      "\"wifi_connected\":" + String(wifi_connected ? "true" : "false") + ",";
  config +=
      "\"mqtt_connected\":" + String(mqtt_connected ? "true" : "false") + ",";
  config += "\"free_heap\":" + String(ESP.getFreeHeap()) + ",";
  config += "\"uptime\":" + String(millis() / 1000);
  config += "}";

  web_server.send(200, "application/json", config);
}

void mqttCallback(char *topic, byte *payload, unsigned int length) {
  Serial.print("MQTT message received on topic: ");
  Serial.println(topic);

  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  Serial.print("Message: ");
  Serial.println(message);

  // Handle received MQTT message
  if (String(topic) == mqtt_topic_rx) {
    if (is_transmitter) {
      // If we're in transmitter mode, send the received data via LI-FI
      sendData(message);
    }
  }
}