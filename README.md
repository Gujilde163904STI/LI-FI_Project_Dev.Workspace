# ⚡️ LI-FI_Project_Dev.Workspace

> A modular development workspace for a **Light Fidelity (LI-FI)** embedded system powered by **Raspberry Pi 3**, **Raspberry Pi 4**, and **ESP8266**, featuring independent flashing workflows, photodiode-based TCP/IP transmission, a Firebase dashboard, and AI-assisted diagnostics.

---

## 📡 Project Overview

This project enables **data transmission via light** using photodiodes and embedded devices, simulating TCP/IP or Wi-Fi-like packet exchange between Raspberry Pi units and ESP8266 microcontrollers. Each device is programmed independently and auto-connects on boot without runtime setup.

- 🔦 **LI-FI Protocol** using light to transmit IP/data
- 🧱 **Modular build system** for RPi3, RPi4, and ESP8266
- 🌐 **Firebase-powered** real-time dashboard (logs, configs, flash jobs)
- 🤖 **AI-assisted debugging** using Gemini and Mistral (LM Studio)
- 🔒 **Offline-capable flashing** with precompiled scripts and auto-connection
- 🧪 **Simulations** using Wokwi and custom protocol testbeds

---

## 📁 Project Structure

LI-FI_Project_Dev.Workspace/
├── RPI3/                  # Raspberry Pi 3 firmware & configs
├── RPI4/                  # Raspberry Pi 4 firmware & configs
├── FLASH_8266/            # NodeMCU ESP8266 firmware & scripts
├── firebase-dashboard/    # Firebase Hosting frontend (JS/HTML)
├── tools/                 # Arduino-CLI, PlatformIO, and flash tools
├── scripts/               # Shell/CLI scripts for automation
├── simulation-workspace/  # Wokwi builds & virtual tests
├── docs/                  # Documentation, wiring, protocol guides
├── integrations/          # IOTStack, MQTT libs, esp-idf tools
├── resources/             # Markdown, config presets, JSON schemas

---

## 🚀 Features

### 🔧 Embedded System Logic
- 📦 Independently flashable modules: RPi3, RPi4, ESP8266
- 🧠 AI-based assistant (`Junie`, `Gemini`, `Cursor`, `Mistral`) for code generation
- 🔄 Serial/TCP messaging over photodiode channels
- 📂 Organized workspace for firmware, simulation, and flashing

### 📊 Firebase Integration
- 🔥 Firestore schema for device logs, flash jobs, configs, and status
- 🛠️ Firebase Hosting with dark violet console UI
- 🧪 Secure rules: Admin-only writes, public authenticated reads
- 📈 Live signal monitoring and device flash tracking

### 🧠 AI Tools
- 🎨 Diagramming: Mermaid, Excalidraw, or Tldraw
- 💡 Debugging: Gemini prompts based on historical logs
- 🤖 Model support: Mistral 22B (`LM Studio`), Gemini 1.5 Pro, GPT-4.5

---

## 🛠️ Requirements

| Tool                | Version / Note                    |
|---------------------|-----------------------------------|
| Node.js             | >= 18.x                           |
| Firebase CLI        | `npm install -g firebase-tools`   |
| Arduino-CLI / PIO   | Included in `/tools/`             |
| Python 3.x          | For RPi build scripts             |
| LM Studio (optional)| `codestral-22b-v0.1`              |

---

## 🔥 Firebase Setup

1. Connect your VSCode terminal:
   ```bash
   firebase login
   firebase use --add

2.	Initialize Hosting & Firestore:
   
   firebase init
  	
4.	Deploy:

   firebase deploy

🧪 Flash Workflow (ESP/RPi)

# Build + Flash ESP8266
cd FLASH_8266/
python3 flash_esp8266.py --target=nodeMCUv3

# Build Raspberry Pi 3 Firmware
cd RPI3/
python3 build.py --target=rpi3 --flash

# Build Raspberry Pi 4 Firmware
cd RPI4/
python3 build.py --target=rpi4 --flash

💻 Firebase Dashboard

Hosted live at:
https://studio--lifi-embedded-console.us-central1.hosted.app/dashboard

OR locally:

bash
firebase emulators:start

Features:
	•	🔍 View RPi/ESP logs, signal, and flash status
	•	📡 Configure devices from the browser
	•	🔐 Admin login with role-based Firestore rules

⸻

🎨 Style Guide

Element              Value
Primary Color        Gradient Dark & Light Violet
Background           Elegant Dark (#202A40)
Accent Color         Teal (#3EDBF0)
Fonts                Inter, Space Grotesk, Source Code Pro
Icons                Minimal vector-style, inline SVG
Theme Inspired       Prompt 3 App Icon + Firebase Studio

⸻

📌 TODO
	•	Auto-device registration on flash
	•	AI-powered log summarization in dashboard
	•	OTA update support for ESP8266
	•	Gemini + Firebase CLI helper integration

🧠 Prompt Examples (Gemini/GPT)

js
"Generate Firestore rules that allow only admins to write to /configs"
"Simulate 5 rpi3 logs with timestamps and errors"
"Connect ESP8266 to Firestore via REST"
"Deploy my Firebase app from CLI and trigger emulators"

-------------------------------------------------------
📜 License

This project is licensed under MIT License. See LICENSE for details.

⸻

🙌 Credits
	•	Developed by: Gian Carlo Gujilde
	•	Tools: Cursor, Gemini, LM Studio, Firebase, Arduino, Wokwi, ESP-IDF
	•	Core Models: codestral-22b-v0.1, Gemini Pro, GPT-4
