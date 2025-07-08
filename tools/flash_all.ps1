# flash_all.ps1
# Flash all supported devices (ESP8266, RPi3, RPi4) in one go (Windows)
#
# Usage: .\flash_all.ps1 [--check-services]
#
# NOTE: Update device paths and flashing commands as needed for your setup.

function Check-Services {
    $required = @('coder.service', 'wayvnc.service', 'skaffold.service')
    $missing = @()
    foreach ($svc in $required) {
        $active = & wsl systemctl --user is-active $svc 2>$null
        if ($LASTEXITCODE -ne 0) {
            $missing += $svc
        }
    }
    if ($missing.Count -gt 0) {
        Write-Host "[WARN] The following required services are not active: $($missing -join ', ')"
        $yn = Read-Host "Start them now? [Y/n]"
        if ($yn -eq '' -or $yn -match '^[Yy]$') {
            foreach ($svc in $missing) {
                & wsl systemctl --user start $svc
                Write-Host "Started $svc."
            }
        } else {
            Write-Host "Aborting. Please start required services with: wsl systemctl --user start $($missing -join ' ')"
            exit 1
        }
    }
}

if ($args.Count -gt 0 -and $args[0] -eq '--check-services') {
    Check-Services
}

Check-Services

# Flash ESP8266
if (Test-Path "../ESP8266/") {
    Write-Host "Flashing ESP8266..."
    # TODO: Replace with actual flashing command (e.g., using esptool or PlatformIO)
    # Example: platformio run --target upload -d ../ESP8266/
}

# Flash RPi3
if (Test-Path "../RPI3/") {
    Write-Host "Flashing RPi3..."
    # TODO: Replace with actual flashing command (e.g., using custom script or imaging tool)
}

# Flash RPi4
if (Test-Path "../RPI4/") {
    Write-Host "Flashing RPi4..."
    # TODO: Replace with actual flashing command (e.g., using custom script or imaging tool)
}

Write-Host "All devices flashed (if connected)." 