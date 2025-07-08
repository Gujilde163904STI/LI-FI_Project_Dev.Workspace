#!/bin/bash
set -e
echo "===[ LI-FI PROJECT RESTRUCTURE: START ]==="

# 1. Create new structure
mkdir -p core/{src,scripts,config,docs,tests}
mkdir -p build/{BUILDS,LIFI_FIRMWARE_BUILD,target,PLATFORMIO}
mkdir -p hardware
mkdir -p resources
mkdir -p network
mkdir -p iot
mkdir -p tools

echo "[✓] Base folders created."

# 2. Move core files (suppress errors if missing)
mv src core/ 2>/dev/null || true
mv requirements.txt core/ 2>/dev/null || true
mv platform_config_*.json core/config/ 2>/dev/null || true
mv workspace_config.json core/config/ 2>/dev/null || true

for s in setup_environment.py dev_setup_macos.py dev_setup_windows.py build.py windows_flash_esp.py windows_detect_pi.py windows_setup.bat test_serial_devices.py detect_rpi.py detect_specific_pi.py identify_pi_devices.py ; do
  mv "$s" core/scripts/ 2>/dev/null || true
done

# Docs
for md in README_OPTIMIZED.md README_MACOS.md README_WINDOWS.md README.md LIFI_DEV_QUICKSTART.md CROSS_PLATFORM_DEPLOYMENT.md SWEEP.md WINDOWS_USAGE.md GOOGLE_CLOUD_STORAGE_SETUP.md ; do
  mv "$md" core/docs/ 2>/dev/null || true
done

# 3. Build outputs
for b in BUILDS LIFI_FIRMWARE_BUILD target PLATFORMIO ; do
  mv "$b" build/ 2>/dev/null || true
done

# 4. Hardware/board design/firmware
for h in HARDWARES ESP8266.CORE RASPBERRY_PI.CORE LIFI-CORE WIRING-CORE.DIAGRAM ; do
  mv "$h" hardware/ 2>/dev/null || true
done

# 5. Resources
for r in legacy-docs LANGUAGES LIFI_Build_References arduino-cli arduino-core ; do
  mv "$r" resources/ 2>/dev/null || true
done

# 6. Networking/protocols
for n in BINARY-LIBRARY DATABASE DNS-SEC DTLS-TLS FRAMEWORKS PROTOCOL ; do
  mv "$n" network/ 2>/dev/null || true
done

# 7. IoT
for i in IOT INTEGRATIONS ; do
  mv "$i" iot/ 2>/dev/null || true
done

# 8. Tools
for t in TOOLS DOTNET-CORE.RESOURCES ESP8266-WIKI ; do
  mv "$t" tools/ 2>/dev/null || true
done

echo "[✓] All folders/files moved where applicable."

# 9. .gitignore – rewrite build rules
echo "[!] Updating .gitignore for new structure..."
sed -i.bak '/^BUILDS\//d; /^LIFI_FIRMWARE_BUILD\//d; /^target\//d; /^PLATFORMIO\//d' .gitignore
if ! grep -qx 'build/' .gitignore; then
  echo 'build/' >> .gitignore
fi

echo "[✓] .gitignore updated."

# 10. Update .gitlab-ci.yml (build/readme paths) - only show a warning
echo "[!!] Please MANUALLY update all script, source, or requirements.txt references in .gitlab-ci.yml to new locations (core/scripts, core/, etc)."
echo "    Search for 'build.py', 'requirements.txt', etc, and correct paths."

# 11. Find-and-replace old script paths in README/docs (inform user)
echo "[!!] Please run a global search/replace:"
echo "    Change: python setup_environment.py ⇒ python core/scripts/setup_environment.py"
echo "    Adjust other script usages in documentation as needed."

echo "===[ LI-FI PROJECT RESTRUCTURE: DONE! ]==="
echo "Verify everything is present in the correct location, and test your builds."
