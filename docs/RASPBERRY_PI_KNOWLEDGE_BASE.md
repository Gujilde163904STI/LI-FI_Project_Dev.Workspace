# Raspberry Pi Knowledge Base

This document serves as an intelligent index for Raspberry Pi documentation, datasheets, and hardware diagrams to enable context-aware coding, validation, and design assistance.

## 📚 Documentation Structure

### Datasheets (`docs/datasheets/`)

Critical specifications for hardware design and firmware development:

#### **Raspberry Pi 4**

- `raspberry-pi-4-datasheet.pdf` - Complete hardware specifications
- **Key Information**: GPIO pin functions, power requirements, memory interfaces
- **Use Cases**: Firmware development, power management, peripheral interfacing

#### **Raspberry Pi Pico**

- `pico-w-datasheet.pdf` - Pico W wireless specifications
- `rp2040-datasheet.pdf` - RP2040 microcontroller specifications
- **Key Information**: Dual-core ARM Cortex-M0+, programmable I/O, wireless capabilities
- **Use Cases**: Microcontroller programming, wireless communication, custom peripherals

### Manuals (`docs/manuals/`)

Programming guides and protocol specifications:

#### **Hardware Specifications**

- `bcm2711-peripherals.pdf` - BCM2711 peripheral specifications
- `debug-connector-specification.pdf` - Debug interface specifications
- **Key Information**: Peripheral interfaces, debug protocols, hardware registers
- **Use Cases**: Low-level programming, debugging, hardware interfacing

#### **Product Briefs**

- `raspberry-pi-4-product-brief.pdf` - Pi 4 product overview
- `raspberry-pi-3-b-plus-product-brief.pdf` - Pi 3B+ specifications
- **Key Information**: Product features, specifications, use cases
- **Use Cases**: Product selection, feature planning, compatibility assessment

#### **Development Kits**

- `build-hat-python-library.pdf` - Build HAT Python library
- `build-hat-serial-protocol.pdf` - Build HAT serial protocol
- **Key Information**: Educational robotics, serial communication, Python APIs
- **Use Cases**: Educational projects, robotics, serial communication

#### **SDK Documentation**

- `raspberry-pi-pico-c-sdk.pdf` - Pico C SDK
- `raspberry-pi-pico-python-sdk.pdf` - Pico Python SDK
- **Key Information**: C and Python APIs, examples, best practices
- **Use Cases**: Pico development, embedded programming, Python integration

## 🔧 Hardware Diagrams (`hardware/diagrams/`)

### Mechanical Drawings (`hardware/diagrams/mechanical/`)

- **Purpose**: Physical layout, mounting, mechanical constraints
- **File Types**: SVG, PDF
- **Use Cases**: Enclosure design, mounting solutions, mechanical integration

### Circuit Schematics (`hardware/diagrams/schematics/`)

- **Purpose**: Electrical connections, power distribution, signal routing
- **File Types**: SVG, PDF
- **Use Cases**: Circuit design, power analysis, signal integrity

## 🎛️ KiCAD Design Assets (`hardware/kicad/`)

### USB Tester (`hardware/kicad/USB-tester-KiCAD/`)

- **Purpose**: USB testing and validation circuits
- **Components**: USB connectors, test points, measurement circuits
- **Use Cases**: USB device testing, signal validation, debugging

### CM4 IO Board (`hardware/kicad/CM4IO-KiCAD/`)

- **Purpose**: Compute Module 4 carrier board design
- **Components**: CM4 connector, power management, peripheral interfaces
- **Use Cases**: Custom carrier board design, CM4 integration, peripheral expansion

## 🧠 Intelligent Coding Guidelines

### GPIO Pin Validation

When working with GPIO pins:

1. **Reference**: `docs/datasheets/raspberry-pi-4-datasheet.pdf`
2. **Cross-check**: `hardware/diagrams/schematics/` for pin assignments
3. **Validate**: Power requirements and current limits
4. **Consider**: Alternative functions and multiplexing

### Power Management

When designing power systems:

1. **Reference**: Datasheets for voltage requirements
2. **Check**: Current draw specifications
3. **Validate**: Thermal considerations
4. **Consider**: Power sequencing requirements

### Peripheral Interfacing

When connecting peripherals:

1. **Reference**: `docs/manuals/bcm2711-peripherals.pdf`
2. **Check**: Protocol specifications (I2C, SPI, UART)
3. **Validate**: Timing requirements
4. **Consider**: Signal integrity and noise

### Wireless Communication

When implementing wireless features:

1. **Reference**: `docs/datasheets/pico-w-datasheet.pdf`
2. **Check**: Antenna requirements and placement
3. **Validate**: Regulatory compliance
4. **Consider**: Power consumption and range

## 🔍 Validation Workflow

### 1. Hardware Design Validation

```
1. Check datasheet specifications
2. Validate against mechanical drawings
3. Review circuit schematics
4. Cross-reference KiCAD designs
5. Verify power requirements
```

### 2. Firmware Development Validation

```
1. Reference peripheral specifications
2. Check GPIO pin functions
3. Validate protocol implementations
4. Review SDK documentation
5. Test with hardware diagrams
```

### 3. Integration Testing

```
1. Verify mechanical compatibility
2. Check electrical connections
3. Validate power requirements
4. Test communication protocols
5. Document any deviations
```

## 📋 Quick Reference

### Common GPIO Functions

- **I2C**: SDA, SCL pins with pull-up resistors
- **SPI**: MOSI, MISO, SCLK, CS pins
- **UART**: TX, RX pins for serial communication
- **PWM**: Configurable PWM outputs
- **ADC**: Analog input capabilities (Pico)

### Power Specifications

- **Raspberry Pi 4**: 5V/3A minimum, 5V/5A recommended
- **Raspberry Pi Pico**: 5V/1A typical, 5V/2A maximum
- **Voltage Levels**: 3.3V logic, 5V tolerant inputs

### Communication Protocols

- **I2C**: Up to 400kHz (standard), 1MHz (fast)
- **SPI**: Up to 125MHz (depends on implementation)
- **UART**: Configurable baud rates
- **USB**: USB 2.0/3.0 depending on model

## 🚀 Best Practices

### Documentation References

- Always cross-reference multiple sources
- Validate specifications against actual hardware
- Keep documentation up to date
- Document any deviations or workarounds

### Design Validation

- Use mechanical drawings for physical constraints
- Reference schematics for electrical connections
- Validate power requirements early
- Test with actual hardware when possible

### Code Quality

- Reference SDK documentation for APIs
- Follow established coding patterns
- Include proper error handling
- Document hardware dependencies

---

**Note**: This knowledge base is designed to work with Cursor's intelligent coding features. The documentation and diagrams are indexed to provide context-aware suggestions and validation during development.
