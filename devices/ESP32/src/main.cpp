#include <Arduino.h>
#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>

// LI-FI ESP32 Configuration
#define LED_PIN 2
#define LIGHT_SENSOR_PIN 36
#define SERIAL_BAUD 115200

// WiFi Configuration
const char* ssid = "LI-FI_Network";
const char* password = "lifi_password";

// Web Server
WebServer server(80);

// LI-FI Data Structure
struct LifiData {
  int lightLevel;
  bool ledState;
  unsigned long timestamp;
  float temperature;
};

LifiData currentData;

void setup() {
  Serial.begin(SERIAL_BAUD);
  
  // Initialize pins
  pinMode(LED_PIN, OUTPUT);
  pinMode(LIGHT_SENSOR_PIN, INPUT);
  
  Serial.println("LI-FI ESP32 Development Environment");
  Serial.println("===================================");
  
  // Connect to WiFi
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  
  Serial.println();
  Serial.print("Connected! IP address: ");
  Serial.println(WiFi.localIP());
  
  // Setup web server routes
  server.on("/", handleRoot);
  server.on("/api/data", handleData);
  server.on("/api/led", handleLED);
  server.on("/api/status", handleStatus);
  
  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  // Update sensor data
  updateSensorData();
  
  // Handle web server
  server.handleClient();
  
  // LI-FI demo: blink LED based on light level
  if (currentData.lightLevel > 2000) {
    digitalWrite(LED_PIN, HIGH);
    currentData.ledState = true;
  } else {
    digitalWrite(LED_PIN, LOW);
    currentData.ledState = false;
  }
  
  // Print status every 5 seconds
  static unsigned long lastPrint = 0;
  if (millis() - lastPrint > 5000) {
    printStatus();
    lastPrint = millis();
  }
  
  delay(100);
}

void updateSensorData() {
  currentData.lightLevel = analogRead(LIGHT_SENSOR_PIN);
  currentData.timestamp = millis();
  currentData.temperature = random(20, 30); // Simulated temperature
}

void printStatus() {
  Serial.println("=== LI-FI Status ===");
  Serial.printf("Light Level: %d\n", currentData.lightLevel);
  Serial.printf("LED State: %s\n", currentData.ledState ? "ON" : "OFF");
  Serial.printf("Temperature: %.1f°C\n", currentData.temperature);
  Serial.printf("WiFi RSSI: %d dBm\n", WiFi.RSSI());
  Serial.println("==================");
}

void handleRoot() {
  String html = R"(
<!DOCTYPE html>
<html>
<head>
    <title>LI-FI ESP32 Dashboard</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #1a1a1a; color: #fff; }
        .container { max-width: 800px; margin: 0 auto; }
        .card { background: #2d2d2d; padding: 20px; margin: 10px 0; border-radius: 8px; }
        .status { display: flex; justify-content: space-between; }
        .led { width: 20px; height: 20px; border-radius: 50%; }
        .led.on { background: #00ff00; }
        .led.off { background: #ff0000; }
        button { background: #007acc; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
        button:hover { background: #005a9e; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 LI-FI ESP32 Dashboard</h1>
        
        <div class="card">
            <h2>📊 Sensor Data</h2>
            <div class="status">
                <span>Light Level: <span id="lightLevel">--</span></span>
                <span>LED: <div class="led" id="ledStatus"></div></span>
            </div>
            <div class="status">
                <span>Temperature: <span id="temperature">--</span>°C</span>
                <span>WiFi RSSI: <span id="rssi">--</span> dBm</span>
            </div>
        </div>
        
        <div class="card">
            <h2>🎛️ Controls</h2>
            <button onclick="toggleLED()">Toggle LED</button>
            <button onclick="refreshData()">Refresh Data</button>
        </div>
        
        <div class="card">
            <h2>📈 Real-time Updates</h2>
            <div id="updates"></div>
        </div>
    </div>
    
    <script>
        function updateData() {
            fetch('/api/data')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('lightLevel').textContent = data.lightLevel;
                    document.getElementById('temperature').textContent = data.temperature;
                    document.getElementById('rssi').textContent = data.rssi;
                    
                    const ledStatus = document.getElementById('ledStatus');
                    ledStatus.className = 'led ' + (data.ledState ? 'on' : 'off');
                    
                    const updates = document.getElementById('updates');
                    const time = new Date().toLocaleTimeString();
                    updates.innerHTML = `<div>[${time}] Light: ${data.lightLevel}, LED: ${data.ledState ? 'ON' : 'OFF'}</div>` + updates.innerHTML;
                    
                    if (updates.children.length > 10) {
                        updates.removeChild(updates.lastChild);
                    }
                });
        }
        
        function toggleLED() {
            fetch('/api/led', {method: 'POST'})
                .then(() => updateData());
        }
        
        function refreshData() {
            updateData();
        }
        
        // Update every 2 seconds
        setInterval(updateData, 2000);
        updateData();
    </script>
</body>
</html>
  )";
  
  server.send(200, "text/html", html);
}

void handleData() {
  StaticJsonDocument<200> doc;
  doc["lightLevel"] = currentData.lightLevel;
  doc["ledState"] = currentData.ledState;
  doc["temperature"] = currentData.temperature;
  doc["rssi"] = WiFi.RSSI();
  doc["timestamp"] = currentData.timestamp;
  
  String response;
  serializeJson(doc, response);
  server.send(200, "application/json", response);
}

void handleLED() {
  if (server.method() == HTTP_POST) {
    currentData.ledState = !currentData.ledState;
    digitalWrite(LED_PIN, currentData.ledState ? HIGH : LOW);
    server.send(200, "text/plain", "LED toggled");
  } else {
    server.send(405, "text/plain", "Method not allowed");
  }
}

void handleStatus() {
  StaticJsonDocument<200> doc;
  doc["status"] = "running";
  doc["uptime"] = millis();
  doc["freeHeap"] = ESP.getFreeHeap();
  doc["wifiConnected"] = WiFi.status() == WL_CONNECTED;
  doc["ipAddress"] = WiFi.localIP().toString();
  
  String response;
  serializeJson(doc, response);
  server.send(200, "application/json", response);
} 