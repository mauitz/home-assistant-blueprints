# 📌 Pinout ESP32 30-pin (ESP-WROOM-32) - Sistema de Riego

## 🎯 Identificación de tu Placa

**Modelo detectado:** ESP-WROOM-32 en placa de desarrollo compacta de 30 pines

**Características:**
- 30 pines totales (15 por lado)
- Conector micro USB
- Chip: ESP-WROOM-32
- Similar a "ESP32 30-pin DevKit" o "DOIT ESP32 DevKit v1"

---

## 📐 Pinout Completo ESP32 30-pin

```
                    ESP32 30-pin DevKit
        ┌───────────────────────────────┐
        │                               │
   ◄────┤ 3V3                       GND ├────►
   ◄────┤ EN (RESET)               D23 ├────► Relé 1 (IN1) [Z1A]
   ◄────┤ SVP (D36)                D22 ├────► Relé 2 (IN2) [Z1B]
   ◄────┤ SVN (D39)                TX0 ├──┐
   ◄────┤ D34                      RX0 ├──┘   (USB Serial)
   ◄────┤ D35                      D21 ├────► Relé 3 (IN3) [Z2A]
   ◄────┤ D32                      GND ├────►
   ◄────┤ D33                      D19 ├────► Relé 4 (IN4) [Z2B]
   ◄────┤ D25                      D18 ├────► Relé 5 (IN5) [Z3A]
   ◄────┤ D26                      D5  ├────► Relé 6 (IN6) [Z3B]
   ◄────┤ D27                      TX2 ├────► LD2410C TX (D17)
   ◄────┤ D14                      RX2 ├────► LD2410C RX (D16)
   ◄────┤ D12                      D4  ├────►
   ◄────┤ GND                      D2  ├────►
   ◄────┤ D13                      D15 ├────►
   ◄────┤ NC                       GND ├────►
        │          USB              │
        └───────────────────────────────┘

Nota: TX2/RX2 pueden estar en D17/D16 en esta placa
```

---

## ⚠️ DIFERENCIAS IMPORTANTES vs DevKit v1 (38 pines)

### **Pines NO disponibles en la placa de 30 pines:**
- ❌ **GPIO16, GPIO17** (pueden no estar expuestos o estar como TX2/RX2)
- ❌ Algunos pines de debug/boot pueden no estar accesibles
- ❌ Menos pines GND (pero suficientes)

### **Pines disponibles (suficientes para el proyecto):**
- ✅ GPIO23, 22, 21, 19, 18, 5 → Relés (6 disponibles)
- ✅ GPIO27 → DHT11
- ✅ GPIO34, 35 → ADC (Humedad, LDR)
- ✅ GPIO13, 14 → HC-SR04
- ✅ GPIO26, 25, 4, 2, 15 → LEDs
- ⚠️ GPIO16, 17 → Verificar si están disponibles para LD2410C

---

## 🔍 VALIDACIÓN DE PINES PARA TU PLACA

### **Pines Críticos (VERIFICAR en tu placa):**

| GPIO | Función en Proyecto | Disponible en 30-pin? | Alternativa |
|------|---------------------|----------------------|-------------|
| GPIO23 | Bomba Z1A (Relé 1) | ✅ SÍ | - |
| GPIO22 | Bomba Z1B (Relé 2) | ✅ SÍ | - |
| GPIO21 | Bomba Z2A (Relé 3) | ✅ SÍ | - |
| GPIO19 | Bomba Z2B (Relé 4) | ✅ SÍ | - |
| GPIO18 | Bomba Z3A (Relé 5) | ✅ SÍ | - |
| GPIO5 | Bomba Z3B (Relé 6) | ✅ SÍ | - |
| GPIO27 | DHT11 DATA | ✅ SÍ | - |
| GPIO34 | Humedad Suelo | ✅ SÍ (Input only) | - |
| GPIO35 | LDR | ✅ SÍ (Input only) | - |
| GPIO13 | HC-SR04 TRIG | ✅ SÍ | - |
| GPIO14 | HC-SR04 ECHO | ✅ SÍ | - |
| **GPIO16** | **LD2410C RX** | ⚠️ **VERIFICAR** | GPIO32 |
| **GPIO17** | **LD2410C TX** | ⚠️ **VERIFICAR** | GPIO33 |
| GPIO26 | LED Tank Full | ✅ SÍ | - |
| GPIO25 | LED Tank Low | ✅ SÍ | - |
| GPIO4 | LED Tank Med | ✅ SÍ | - |
| GPIO2 | LED Pump Active | ✅ SÍ | - |
| GPIO15 | LED WiFi | ✅ SÍ (strapping) | - |

---

## 🔧 AJUSTE NECESARIO: LD2410C (GPIO16/17)

### **Problema Potencial:**

Algunas placas de 30 pines **no exponen GPIO16/17** porque están internamente conectados a la flash SPI.

### **Verificación Rápida:**

Mira tu placa físicamente:
- ¿Ves pines etiquetados como **"D16"** y **"D17"**? → ✅ Usar GPIO16/17
- ¿Ves pines etiquetados como **"TX2"** y **"RX2"**? → ✅ Probablemente son GPIO17/16
- ¿NO ves ninguno de esos? → ⚠️ Usar pines alternativos

### **Solución Alternativa: Usar GPIO32/33**

Si GPIO16/17 no están disponibles, modifica el firmware:

```yaml
# En riego_z1.yaml
uart:
  id: uart_bus
  tx_pin: GPIO33  # ← Cambiar de GPIO17 a GPIO33
  rx_pin: GPIO32  # ← Cambiar de GPIO16 a GPIO32
  baud_rate: 256000
  parity: NONE
  stop_bits: 1
```

**Ventaja:** GPIO32 y GPIO33 están **100% disponibles** en tu placa de 30 pines.

---

## ✅ PINOUT AJUSTADO PARA TU PLACA (30-pin)

### **Conexiones Validadas:**

```
ALIMENTACIÓN:
VIN (o 5V)  → Riel 5V
GND         → Riel GND (hay varios pines GND)
3V3         → NO CONECTAR (es salida)

RELÉS (6 bombas):
GPIO23  → Relé IN1 (Bomba Z1A) ✅
GPIO22  → Relé IN2 (Bomba Z1B) ✅
GPIO21  → Relé IN3 (Bomba Z2A) ✅
GPIO19  → Relé IN4 (Bomba Z2B) ✅
GPIO18  → Relé IN5 (Bomba Z3A) ✅
GPIO5   → Relé IN6 (Bomba Z3B) ✅

SENSORES:
GPIO27  → DHT11 DATA ✅
GPIO34  → Sensor Humedad Suelo (ADC) ✅
GPIO35  → LDR (ADC) ✅
GPIO13  → HC-SR04 TRIG ✅
GPIO14  → HC-SR04 ECHO ✅

LD2410C (OPCIÓN 1 - Si están disponibles):
GPIO16  → LD2410C RX (UART2) ⚠️
GPIO17  → LD2410C TX (UART2) ⚠️

LD2410C (OPCIÓN 2 - Alternativa segura):
GPIO32  → LD2410C RX ✅
GPIO33  → LD2410C TX ✅

LEDs:
GPIO26  → LED Verde (Tank Full) ✅
GPIO25  → LED Rojo (Tank Low) ✅
GPIO4   → LED Amarillo (Tank Med) ✅
GPIO2   → LED Azul (Pump Active) ✅
GPIO15  → LED Blanco (WiFi Status) ✅
```

---

## 📋 CAMBIOS EN EL FIRMWARE

Si usas GPIO32/33 para LD2410C, actualiza `riego_z1.yaml`:

<function_calls>
<invoke name="read_file">
<parameter name="target_file">/Users/maui/_maui/domotica/home-assistant-blueprints/esphome/riego_z1.yaml
