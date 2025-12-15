# 📌 Diagrama de Conexiones ESP32 - Sistema de Riego

## 🎯 Pinout Completo ESP32 DevKit v1

```
                                ESP32 DevKit v1
                    ┌───────────────────────────────┐
                    │                               │
    Riel 3.3V  ◄────┤ 3V3                       GND ├────► Riel GND
    Riel GND   ◄────┤ GND                       D23 ├────► Relé 1 (IN1) [Z1A]
LED WiFi       ◄────┤ D15                       D22 ├────► Relé 2 (IN2) [Z1B]
LED Bomba      ◄────┤ D2                        TX0 ├──┐
LED Tanque Med ◄────┤ D4                        RX0 ├──┘  (USB Serial)
LD2410C RX     ◄────┤ RX2 (D16)                 D21 ├────► Relé 3 (IN3) [Z2A]
LD2410C TX     ◄────┤ TX2 (D17)                 GND ├────► Riel GND
Relé 6 (IN6)   ◄────┤ D5                        D19 ├────► Relé 4 (IN4) [Z2B]
Relé 5 (IN5)   ◄────┤ D18                       D18 ├────► Relé 5 (IN5) [Z3A]
Relé 4 (IN4)   ◄────┤ D19                       D5  ├────► Relé 6 (IN6) [Z3B]
(Reserva)      ◄────┤ D21                       TX2 ├────► LD2410C TX
Riel GND       ◄────┤ RX2                       RX2 ├────► LD2410C RX
Relé 2 (IN2)   ◄────┤ D22                       D22 ├────► (redundante)
Relé 1 (IN1)   ◄────┤ D23                       D23 ├────► (redundante)
                    │                               │
                    ├───────────────────────────────┤
                    │                               │
    Riel GND   ◄────┤ GND                       GND ├────► Riel GND
DHT11 DATA     ◄────┤ D27                       D13 ├────► HC-SR04 TRIG
LED Tank Full  ◄────┤ D26                       D12 ├──┐
LED Tank Low   ◄────┤ D25                       D14 ├──┼─► HC-SR04 ECHO
Hum. Suelo     ◄────┤ D34 (Input only)          D27 ├──┘  DHT11 DATA
LDR            ◄────┤ D35 (Input only)          D26 ├────► LED Tank Full
(Reserva)      ◄────┤ D32                       D25 ├────► LED Tank Low
(Reserva)      ◄────┤ D33                       D33 ├────► (Reserva)
HC-SR04 ECHO   ◄────┤ D14                       D32 ├────► (Reserva)
HC-SR04 TRIG   ◄────┤ D13                       D35 ├────► LDR
    Riel GND   ◄────┤ GND                       D34 ├────► Hum. Suelo
    Riel 5V    ◄────┤ VIN                       VIN ├────► Riel 5V
                    │          USB-C              │
                    └───────────────────────────────┘
```

---

## 🔌 Tabla de Conexiones Completa

| GPIO | Función | Conexión | Tipo | Notas |
|------|---------|----------|------|-------|
| **GPIO23** | Bomba Z1A | Relé 1 (IN1) | Output | Zona 1A |
| **GPIO22** | Bomba Z1B | Relé 2 (IN2) | Output | Zona 1B |
| **GPIO21** | Bomba Z2A | Relé 3 (IN3) | Output | Zona 2A (futuro) |
| **GPIO19** | Bomba Z2B | Relé 4 (IN4) | Output | Zona 2B (futuro) |
| **GPIO18** | Bomba Z3A | Relé 5 (IN5) | Output | Zona 3A (futuro) |
| **GPIO5** | Bomba Z3B | Relé 6 (IN6) | Output | Zona 3B (futuro) |
| **GPIO26** | LED Tanque Lleno | LED Verde + 220Ω | Output | Indicador visual |
| **GPIO25** | LED Tanque Bajo | LED Rojo + 220Ω | Output | Alerta crítica |
| **GPIO4** | LED Tanque Medio | LED Amarillo + 220Ω | Output | Estado normal |
| **GPIO2** | LED Bomba Activa | LED Azul + 220Ω | Output | Riego en curso |
| **GPIO15** | LED WiFi Status | LED Blanco + 220Ω | Output | ⚠️ Strapping pin |
| **GPIO27** | DHT11 DATA | DHT11 (en tapa) | Input/Output | Pull-up interno |
| **GPIO34** | Humedad Suelo | Sensor capacitivo | Input (ADC) | Input only |
| **GPIO35** | LDR Luz | LDR + divisor | Input (ADC) | Input only |
| **GPIO13** | HC-SR04 TRIG | Ultrasónico | Output | Sensor tanque |
| **GPIO14** | HC-SR04 ECHO | Ultrasónico | Input | Sensor tanque |
| **GPIO16** | LD2410C RX | mmWave sensor TX | Input (RX2) | UART2 |
| **GPIO17** | LD2410C TX | mmWave sensor RX | Output (TX2) | UART2 |
| **GPIO32** | (Reserva) | - | I/O | Expansión |
| **GPIO33** | (Reserva) | - | I/O | Expansión |
| **VIN** | Alimentación | +5V | Power | Desde riel 5V |
| **3V3** | Salida 3.3V | Sensores | Power | Max 600mA |
| **GND** | Tierra | Común | Ground | Múltiples pines |

---

## ⚠️ PINES ESPECIALES - Restricciones

### **Input Only (No pueden ser OUTPUT)**
- **GPIO34, GPIO35, GPIO36, GPIO39**: Solo INPUT
- En este proyecto: GPIO34 (Humedad), GPIO35 (LDR)

### **Strapping Pins (Usar con cuidado)**
- **GPIO0**: Boot mode (no usar)
- **GPIO2**: Boot mode (LED OK, pero evitar pull-down)
- **GPIO12**: MTDI, flash voltage (⚠️ usado por LD2410C)
- **GPIO15**: MTDO, boot debug (LED OK)

### **Reservados para UART0 (USB)**
- **GPIO1 (TX0)**, **GPIO3 (RX0)**: Ocupados por USB

### **Recomendados para I2C (si se usa)**
- **GPIO21 (SDA)**, **GPIO22 (SCL)**: Estándar I2C
- En este proyecto: GPIO21/22 usados para relés (OK, no usamos I2C)

---

## 🔋 Distribución de Alimentación

```
Entrada 5V DC
      │
      ├─────► Riel 5V ────┬─► ESP32 VIN
      │                   ├─► Módulo Relés VCC
      │                   ├─► HC-SR04 VCC
      │                   └─► LD2410C VCC
      │
      ├─────► Regulador AMS1117-3.3V
      │                   │
      │                   └─► Riel 3.3V ───┬─► ESP32 3V3 (ref)
      │                                    ├─► DHT11 VCC
      │                                    ├─► Sensor Humedad VCC
      │                                    └─► LDR divisor
      │
      └─────► Riel GND (común) ───┬─► Todos los GND
                                   ├─► ESP32 GND (x4)
                                   ├─► Módulo Relés GND
                                   ├─► Todos los sensores GND
                                   └─► Bombas (negativo)
```

### **Consumo Estimado**

| Dispositivo | Consumo | Alimentación |
|-------------|---------|--------------|
| ESP32 (WiFi activo) | ~200mA | 5V (VIN) |
| Módulo Relés (6ch, idle) | ~50mA | 5V |
| Módulo Relés (1 activo) | ~100mA | 5V |
| DHT11 | ~2.5mA | 3.3V |
| HC-SR04 | ~15mA | 5V |
| LD2410C | ~140mA | 5V |
| Sensor Humedad | ~5mA | 3.3V |
| LEDs (5x) | ~50mA | 3.3V (via GPIO) |
| **TOTAL (idle)** | **~460mA** | **5V** |
| **TOTAL (riego activo)** | **~560mA** | **5V** |

**Fuente recomendada:** 5V 2A (10W) mínimo

---

## 🧪 Código de Prueba de Pines

```yaml
# test_pinout.yaml - Firmware de prueba para validar todas las conexiones
esphome:
  name: test_pinout

esp32:
  board: esp32dev
  framework:
    type: arduino

wifi:
  ssid: "sunsetlabs-2.4GHz"
  password: "bienvenido"

logger:
  level: INFO

api:

ota:
  - platform: esphome

# PRUEBA: Todos los relés (salidas digitales)
switch:
  - platform: gpio
    name: "Test Relé 1 (GPIO23)"
    pin: GPIO23
  - platform: gpio
    name: "Test Relé 2 (GPIO22)"
    pin: GPIO22
  - platform: gpio
    name: "Test Relé 3 (GPIO21)"
    pin: GPIO21
  - platform: gpio
    name: "Test Relé 4 (GPIO19)"
    pin: GPIO19
  - platform: gpio
    name: "Test Relé 5 (GPIO18)"
    pin: GPIO18
  - platform: gpio
    name: "Test Relé 6 (GPIO5)"
    pin: GPIO5

# PRUEBA: Todos los LEDs
light:
  - platform: binary
    name: "Test LED Tank Full (GPIO26)"
    output: led1
  - platform: binary
    name: "Test LED Tank Low (GPIO25)"
    output: led2
  - platform: binary
    name: "Test LED Tank Med (GPIO4)"
    output: led3
  - platform: binary
    name: "Test LED Pump (GPIO2)"
    output: led4
  - platform: binary
    name: "Test LED WiFi (GPIO15)"
    output: led5

output:
  - platform: gpio
    id: led1
    pin: GPIO26
  - platform: gpio
    id: led2
    pin: GPIO25
  - platform: gpio
    id: led3
    pin: GPIO4
  - platform: gpio
    id: led4
    pin: GPIO2
  - platform: gpio
    id: led5
    pin: GPIO15

# PRUEBA: Sensores analógicos
sensor:
  - platform: adc
    pin: GPIO34
    name: "Test Humedad Suelo (GPIO34)"
    update_interval: 2s

  - platform: adc
    pin: GPIO35
    name: "Test LDR (GPIO35)"
    update_interval: 2s

  - platform: ultrasonic
    trigger_pin: GPIO13
    echo_pin: GPIO14
    name: "Test HC-SR04"
    update_interval: 5s

  - platform: dht
    pin: GPIO27
    model: DHT11
    temperature:
      name: "Test DHT11 Temp"
    humidity:
      name: "Test DHT11 Hum"
    update_interval: 30s

# PRUEBA: LD2410C
uart:
  id: uart_bus
  tx_pin: GPIO17
  rx_pin: GPIO16
  baud_rate: 256000

ld2410:
  uart_id: uart_bus

binary_sensor:
  - platform: ld2410
    has_target:
      name: "Test LD2410C Presencia"
```

---

## 📝 Notas de Diseño

### **1. Por qué estos GPIOs**

✅ **GPIO23, 22, 21, 19, 18, 5** para relés:
- Son OUTPUT seguros
- No son strapping pins críticos
- Suficiente corriente para módulos relé (logic level)

✅ **GPIO34, 35** para sensores analógicos:
- Son ADC1 (no conflicto con WiFi)
- Input only (perfecto para sensores pasivos)

✅ **GPIO13, 14** para HC-SR04:
- Output e Input seguros
- No son strapping pins

✅ **GPIO16, 17** para UART2 (LD2410C):
- UART dedicado (no interfiere con USB)
- Pueden ser reasignados si es necesario

✅ **GPIO27** para DHT11:
- Bidireccional (one-wire protocol)
- Permite pull-up interno

### **2. Alternativas si hay problemas**

Si algún pin falla:

**Reemplazar GPIO15** (strapping pin):
- Usar GPIO32 o GPIO33 en su lugar

**Reemplazar GPIO12** (si hay problemas de boot):
- No usado actualmente, pero reservado

**Expandir relés**:
- Usar GPIO32, 33 para relés 7-8 (futuro)

---

## ✅ Checklist de Conexiones

Antes de encender:

- [ ] VIN conectado a Riel 5V
- [ ] Múltiples GND del ESP32 conectados a Riel GND
- [ ] 3V3 del ESP32 NO conectado a regulador (es salida del ESP32)
- [ ] Todos los relés conectados a GPIOs correctos (23,22,21,19,18,5)
- [ ] Todos los LEDs con resistencias de 220Ω
- [ ] DHT11 DATA en GPIO27
- [ ] HC-SR04 TRIG en GPIO13, ECHO en GPIO14
- [ ] LD2410C TX → GPIO16, RX → GPIO17
- [ ] Sensor humedad en GPIO34 (ADC)
- [ ] LDR en GPIO35 (ADC)
- [ ] No hay cortocircuitos (medir con multímetro en modo continuidad)

---

**Versión**: 1.0
**Fecha**: Diciembre 2024
**Autor**: @mauitz


