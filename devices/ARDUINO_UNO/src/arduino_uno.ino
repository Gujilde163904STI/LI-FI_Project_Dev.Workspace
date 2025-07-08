/*
 * LI-FI Arduino Uno Development Environment
 * Basic LED and sensor control for LI-FI project
 */

// Pin definitions
const int LED_PIN = 13;        // Built-in LED
const int LIGHT_SENSOR_PIN = A0; // Analog light sensor
const int TEMP_SENSOR_PIN = A1;  // Analog temperature sensor
const int BUTTON_PIN = 2;      // Digital button input

// Variables
int lightLevel = 0;
int temperature = 0;
bool ledState = false;
bool buttonPressed = false;
unsigned long lastBlink = 0;
const unsigned long BLINK_INTERVAL = 1000; // 1 second

// Serial communication
const long SERIAL_BAUD = 9600;

void setup() {
  // Initialize pins
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  
  // Initialize serial communication
  Serial.begin(SERIAL_BAUD);
  
  // Wait for serial to be ready
  while (!Serial) {
    delay(10);
  }
  
  Serial.println("LI-FI Arduino Uno Development Environment");
  Serial.println("========================================");
  Serial.println("Commands:");
  Serial.println("  'led on'  - Turn LED on");
  Serial.println("  'led off' - Turn LED off");
  Serial.println("  'status'  - Show sensor status");
  Serial.println("  'help'    - Show this help");
  Serial.println();
  
  // Initial LED state
  digitalWrite(LED_PIN, LOW);
}

void loop() {
  // Read sensors
  readSensors();
  
  // Handle serial commands
  handleSerialCommands();
  
  // Handle button press
  handleButtonPress();
  
  // LI-FI demo: blink LED based on light level
  if (lightLevel > 500) {
    // High light level - fast blink
    if (millis() - lastBlink > 200) {
      ledState = !ledState;
      digitalWrite(LED_PIN, ledState ? HIGH : LOW);
      lastBlink = millis();
    }
  } else if (lightLevel > 200) {
    // Medium light level - slow blink
    if (millis() - lastBlink > 1000) {
      ledState = !ledState;
      digitalWrite(LED_PIN, ledState ? HIGH : LOW);
      lastBlink = millis();
    }
  } else {
    // Low light level - LED off
    digitalWrite(LED_PIN, LOW);
    ledState = false;
  }
  
  // Print status every 5 seconds
  static unsigned long lastStatus = 0;
  if (millis() - lastStatus > 5000) {
    printStatus();
    lastStatus = millis();
  }
  
  delay(50); // Small delay for stability
}

void readSensors() {
  // Read light sensor (0-1023)
  lightLevel = analogRead(LIGHT_SENSOR_PIN);
  
  // Read temperature sensor (simulated)
  temperature = analogRead(TEMP_SENSOR_PIN);
  // Convert to Celsius (simplified)
  temperature = map(temperature, 0, 1023, 0, 50);
}

void handleSerialCommands() {
  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n');
    command.trim();
    command.toLowerCase();
    
    if (command == "led on") {
      digitalWrite(LED_PIN, HIGH);
      ledState = true;
      Serial.println("✅ LED turned ON");
    }
    else if (command == "led off") {
      digitalWrite(LED_PIN, LOW);
      ledState = false;
      Serial.println("✅ LED turned OFF");
    }
    else if (command == "status") {
      printStatus();
    }
    else if (command == "help") {
      printHelp();
    }
    else if (command == "sensors") {
      printSensorData();
    }
    else if (command == "blink") {
      blinkLED(5);
    }
    else {
      Serial.print("❌ Unknown command: ");
      Serial.println(command);
      Serial.println("Type 'help' for available commands");
    }
  }
}

void handleButtonPress() {
  static bool lastButtonState = HIGH;
  bool currentButtonState = digitalRead(BUTTON_PIN);
  
  // Button pressed (LOW due to pull-up)
  if (lastButtonState == HIGH && currentButtonState == LOW) {
    buttonPressed = true;
    Serial.println("🔘 Button pressed!");
    
    // Toggle LED on button press
    ledState = !ledState;
    digitalWrite(LED_PIN, ledState ? HIGH : LOW);
    
    delay(50); // Debounce
  }
  
  lastButtonState = currentButtonState;
}

void printStatus() {
  Serial.println("=== LI-FI Status ===");
  Serial.printf("Light Level: %d (0-1023)\n", lightLevel);
  Serial.printf("Temperature: %d°C\n", temperature);
  Serial.printf("LED State: %s\n", ledState ? "ON" : "OFF");
  Serial.printf("Button Pressed: %s\n", buttonPressed ? "Yes" : "No");
  Serial.printf("Uptime: %lu ms\n", millis());
  Serial.println("==================");
}

void printSensorData() {
  Serial.println("📊 Sensor Data:");
  Serial.printf("  Light Sensor (A0): %d\n", lightLevel);
  Serial.printf("  Temperature (A1): %d\n", temperature);
  Serial.printf("  Button (D2): %s\n", digitalRead(BUTTON_PIN) == LOW ? "Pressed" : "Released");
}

void printHelp() {
  Serial.println("LI-FI Arduino Uno Commands:");
  Serial.println("  led on     - Turn LED on");
  Serial.println("  led off    - Turn LED off");
  Serial.println("  status     - Show system status");
  Serial.println("  sensors    - Show sensor data");
  Serial.println("  blink      - Blink LED 5 times");
  Serial.println("  help       - Show this help");
  Serial.println();
}

void blinkLED(int times) {
  Serial.printf("🔆 Blinking LED %d times...\n", times);
  for (int i = 0; i < times; i++) {
    digitalWrite(LED_PIN, HIGH);
    delay(200);
    digitalWrite(LED_PIN, LOW);
    delay(200);
  }
  Serial.println("✅ Blink complete!");
} 