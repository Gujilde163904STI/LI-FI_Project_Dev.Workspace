/*
 * LI-FI Photodiode Sensor - ESP8266
 * Reads photodiode input and transmits light-based signals
 */

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <WiFiClient.h>

// Configuration
#define PHOTODIODE_PIN A0
#define LED_PIN 2
#define STATUS_LED_PIN 16
#define BUTTON_PIN 0

// WiFi settings
const char* ssid = "LI-FI_Network";
const char* password = "lifi_secure_2024";

// Server settings
const char* serverHost = "192.168.1.100";
const int serverPort = 8080;

// Light communication settings
const int LIGHT_FREQUENCY = 1000;  // Hz
const int LIGHT_BRIGHTNESS = 50;   // Percentage
const int BIT_DURATION = 1;        // ms per bit

// Global variables
WiFiClient client;
bool isConnected = false;
unsigned long lastDataSent = 0;
unsigned long lastStatusCheck = 0;
const unsigned long STATUS_INTERVAL = 30000;  // 30 seconds

// Device configuration
struct DeviceConfig {
  String deviceId = "ESP8266_PHOTODIODE_SENSOR";
  String role = "sensor";
  int samplingRate = 100;  // Hz
  int threshold = 512;     // ADC threshold
  bool debugMode = true;
} config;

void setup() {
  Serial.begin(115200);
  delay(1000);
  
  Serial.println("LI-FI ESP8266 Photodiode Sensor Starting...");
  
  // Initialize pins
  pinMode(LED_PIN, OUTPUT);
  pinMode(STATUS_LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(PHOTODIODE_PIN, INPUT);
  
  // Set initial LED states
  digitalWrite(LED_PIN, LOW);
  digitalWrite(STATUS_LED_PIN, LOW);
  
  // Load configuration
  loadConfig();
  
  // Connect to WiFi
  connectToWiFi();
  
  // Connect to server
  connectToServer();
  
  Serial.println("Setup complete!");
}

void loop() {
  // Handle WiFi connection
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi disconnected, reconnecting...");
    connectToWiFi();
  }
  
  // Handle server connection
  if (!isConnected) {
    connectToServer();
  }
  
  // Read photodiode data
  int photodiodeValue = analogRead(PHOTODIODE_PIN);
  
  // Process light signals
  if (photodiodeValue > config.threshold) {
    processLightSignal(photodiodeValue);
  }
  
  // Send status updates
  if (millis() - lastStatusCheck > STATUS_INTERVAL) {
    sendStatusUpdate();
    lastStatusCheck = millis();
  }
  
  // Handle button press
  if (digitalRead(BUTTON_PIN) == LOW) {
    handleButtonPress();
    delay(200);  // Debounce
  }
  
  // Update status LED
  updateStatusLED();
  
  delay(1000 / config.samplingRate);  // Sampling rate delay
}

void loadConfig() {
  // In a real implementation, this would load from EEPROM or SPIFFS
  Serial.println("Loading configuration...");
  
  // For now, use default values
  config.deviceId = "ESP8266_PHOTODIODE_SENSOR";
  config.role = "sensor";
  config.samplingRate = 100;
  config.threshold = 512;
  config.debugMode = true;
  
  Serial.println("Configuration loaded");
}

void connectToWiFi() {
  Serial.print("Connecting to WiFi: ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println();
    Serial.print("WiFi connected! IP: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println();
    Serial.println("WiFi connection failed!");
  }
}

void connectToServer() {
  Serial.print("Connecting to server: ");
  Serial.print(serverHost);
  Serial.print(":");
  Serial.println(serverPort);
  
  if (client.connect(serverHost, serverPort)) {
    Serial.println("Connected to server!");
    isConnected = true;
    
    // Send device identification
    sendDeviceInfo();
  } else {
    Serial.println("Failed to connect to server");
    isConnected = false;
  }
}

void sendDeviceInfo() {
  if (!isConnected) return;
  
  StaticJsonDocument<200> doc;
  doc["device_id"] = config.deviceId;
  doc["role"] = config.role;
  doc["capabilities"] = "photodiode_sensor,light_transmission";
  doc["ip"] = WiFi.localIP().toString();
  
  String jsonString;
  serializeJson(doc, jsonString);
  
  client.println("POST /device/register HTTP/1.1");
  client.println("Host: " + String(serverHost));
  client.println("Content-Type: application/json");
  client.println("Content-Length: " + String(jsonString.length()));
  client.println();
  client.println(jsonString);
  
  Serial.println("Device info sent to server");
}

void processLightSignal(int value) {
  Serial.print("Light signal detected: ");
  Serial.println(value);
  
  // Create data packet
  StaticJsonDocument<200> doc;
  doc["device_id"] = config.deviceId;
  doc["type"] = "light_signal";
  doc["value"] = value;
  doc["timestamp"] = millis();
  
  String jsonString;
  serializeJson(doc, jsonString);
  
  // Send to server
  sendToServer(jsonString);
  
  // Transmit light response (if needed)
  transmitLightResponse();
}

void transmitLightResponse() {
  Serial.println("Transmitting light response...");
  
  // Simple binary pattern for light transmission
  byte response[] = {0xAA, 0x55, 0xAA, 0x55};  // Alternating pattern
  
  for (int i = 0; i < sizeof(response); i++) {
    transmitByte(response[i]);
  }
  
  Serial.println("Light response transmitted");
}

void transmitByte(byte data) {
  for (int bit = 7; bit >= 0; bit--) {
    bool bitValue = (data >> bit) & 1;
    
    if (bitValue) {
      analogWrite(LED_PIN, (LIGHT_BRIGHTNESS * 1023) / 100);
    } else {
      digitalWrite(LED_PIN, LOW);
    }
    
    delay(BIT_DURATION);
  }
}

void sendToServer(String data) {
  if (!isConnected) return;
  
  client.println("POST /data HTTP/1.1");
  client.println("Host: " + String(serverHost));
  client.println("Content-Type: application/json");
  client.println("Content-Length: " + String(data.length()));
  client.println();
  client.println(data);
  
  Serial.println("Data sent to server");
}

void sendStatusUpdate() {
  if (!isConnected) return;
  
  StaticJsonDocument<200> doc;
  doc["device_id"] = config.deviceId;
  doc["type"] = "status_update";
  doc["uptime"] = millis();
  doc["free_heap"] = ESP.getFreeHeap();
  doc["wifi_rssi"] = WiFi.RSSI();
  doc["photodiode_value"] = analogRead(PHOTODIODE_PIN);
  
  String jsonString;
  serializeJson(doc, jsonString);
  
  sendToServer(jsonString);
}

void handleButtonPress() {
  Serial.println("Button pressed!");
  
  // Toggle debug mode
  config.debugMode = !config.debugMode;
  
  // Send button event to server
  StaticJsonDocument<200> doc;
  doc["device_id"] = config.deviceId;
  doc["type"] = "button_event";
  doc["debug_mode"] = config.debugMode;
  doc["timestamp"] = millis();
  
  String jsonString;
  serializeJson(doc, jsonString);
  
  sendToServer(jsonString);
}

void updateStatusLED() {
  // Blink status LED based on connection state
  static unsigned long lastBlink = 0;
  static bool ledState = false;
  
  if (millis() - lastBlink > 1000) {
    ledState = !ledState;
    digitalWrite(STATUS_LED_PIN, ledState ? HIGH : LOW);
    lastBlink = millis();
  }
}

// Utility functions
void printWiFiStatus() {
  Serial.print("WiFi Status: ");
  Serial.println(WiFi.status());
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
  Serial.print("Signal Strength: ");
  Serial.println(WiFi.RSSI());
}

void printSystemInfo() {
  Serial.print("Free Heap: ");
  Serial.println(ESP.getFreeHeap());
  Serial.print("Chip ID: ");
  Serial.println(ESP.getChipId());
  Serial.print("Flash Size: ");
  Serial.println(ESP.getFlashChipSize());
} 