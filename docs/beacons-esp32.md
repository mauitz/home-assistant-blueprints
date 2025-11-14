# **Beacons ESP32 — Documentación Oficial del Proyecto Home Assistant**  
**Versión 1.0 — Nicolás Rodríguez / Proyecto HA**

## 📘 **Descripción General**

Los **Beacons ESP32** son dispositivos multisensor desarrollados para integrarse con Home Assistant, proporcionando:

- **Detección de presencia por Bluetooth Low Energy (BLE)**  
- **Vinculación automática a Áreas en HA**  
- **Sensores ambientales** (temperatura, humedad, luz, presencia por radar, micrófono)  
- **Activación de voz** usando INMP441 + Assist de Home Assistant  
- **Comunicación WiFi** hacia el servidor de HA  
- **Expansibilidad futura** (audio, baterías, cajas 3D, etc.)

Los Beacons sirven para que la **aplicación móvil de Home Assistant** conozca *en qué habitación se encuentra el usuario*, gracias al **BLE Room Presence** combinando:

- RSSI del BLE Proxy del Beacon  
- Datos de movimiento del LD2410  
- Micrófono para activación de voz por área  
- Criterios inteligentes (último contacto, señal, movimiento, evento de puerta)

---

## 🎯 **Objetivos del Sistema**

1. Proveer **ubicación precisa por habitación** para la app HA.  
2. Permitir activar el asistente de voz en cada habitación.  
3. Evitar dispositivos caros como HomePods o Echos por habitación.  
4. Centralizar sensores por habitación en un único hardware.  
5. Servir como base modular para expandir capacidades locales.

---

## 🧩 **Arquitectura del Beacon**

Cada Beacon está compuesto por:

| Módulo | Función |
|--------|---------|
| **ESP32 WROOM** | Microcontrolador + WiFi + BLE |
| **INMP441** | Micrófono digital I2S para comandos de voz |
| **DHT11** | Temperatura y humedad |
| **LDR + resistencia** | Nivel de luz (lux aproximado) |
| **LD2410C mmWave Radar** | Presencia humana, distancia, movimiento |
| **Alimentación USB-C** | Energía continua |
| _(Opcional)_ TP4056 | UPS/batería (no usado en la versión 1) |
| _(Reservado)_ MAX98357 | Audio out (no usado en la versión 1) |

---

## 🛰️ **Bluetooth — Room Presence**

Cada Beacon funciona como **Bluetooth Proxy** en ESPHome, permitiendo que el teléfono del usuario publique:

- `ble_rssi`
- identificación por MAC
- cercanía estimada

El Beacon más cercano determina "estado de habitación" para cada usuario del sistema.

### Cómo funciona:

1. El ESP32 recibe señales BLE de los dispositivos móviles.  
2. Home Assistant calcula el **RSSI más fuerte**.  
3. Marca al usuario como **presente en el Área del Beacon**.  
4. Autodispara automatizaciones según habitación.

---

## 🗣 **Asistente de Voz por Habitación**

Cada Beacon incluye un **INMP441** configurado como micrófono digital:

- Envia audio a HA via ESPHome.  
- El pipeline de voz se define en Home Assistant:  
  - Whisper / Piper / Nabu Casa STT  
  - TTS por los parlantes principales  
  - O en futuras versiones por un ampli local.

Automáticamente:

- Si el usuario está en un Área → comandos de voz se procesan *para esa área*.  
- Ejemplo: “encendé la luz” ejecuta la luz **de la habitación actual del usuario**.

---

## 🌡️ **Sensores Disponibles**

Cada Beacon expone las siguientes entidades:

### 🔹 Ambientales  
- `sensor.{{room}}_temperature`  
- `sensor.{{room}}_humidity`  
- `sensor.{{room}}_light_level`

### 🔹 Presencia / Radar  
- `binary_sensor.{{room}}_presence`  
- `sensor.{{room}}_distance`  
- `sensor.{{room}}_radar_energy`

### 🔹 Voz  
- `sensor.{{room}}_microphone_energy`  
- `event.{{room}}_voice_command`  
- `assist.{{room}}_assistant`

### 🔹 BLE  
- `sensor.{{room}}_ble_devices_count`  
- `sensor.{{room}}_ble_rssi_phone_nicolas`  
- `sensor.{{room}}_ble_rssi_phone_familia`

---

## 🏡 **Asignación a Áreas**

Cada Beacon debe asignarse a un área en Home Assistant:

1. Configuración → Dispositivos  
2. Seleccionar el Beacon  
3. **Área → Dormitorio / Oficina / Living / Cocina**  
4. Guardar

Esto permite:

- Ubicación BLE por habitación  
- Control de automatizaciones locales  
- Voz contextualizada

---

## ⚡ **Funciones Principales Disponibles**

1. **Room Presence**  
2. **Voice Assistant por habitación**  
3. **Detección de movimiento + presencia prolongada**  
4. **Sensores ambientales completos**  
5. **Escenarios automáticos por habitación**

---

## 🧬 **YAML Base del Beacon (ESPHome 2025)**

```yaml
esphome:
  name: beacon_room_x
  friendly_name: Beacon Room X

esp32:
  board: esp32dev
  framework:
    type: arduino

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_pass

api:
  encryption:
    key: !secret api_key

ota:

logger:

bluetooth_proxy:
  active: true

voice_assistant:
  microphone: mic_i2s

i2s_audio:
  - id: i2s_in
    i2s_lrclk_pin: 15
    i2s_bclk_pin: 14
    i2s_din_pin: 32

microphone:
  - platform: i2s_audio
    id: mic_i2s
    adc_type: external
    channel: left

sensor:
  - platform: dht
    model: DHT11
    pin: 27
    temperature:
      name: "Room Temp"
    humidity:
      name: "Room Humidity"
    update_interval: 15s

  - platform: adc
    pin: 34
    name: "Room Light Level"
    update_interval: 3s

uart:
  rx_pin: 16
  baud_rate: 256000

ld2410:
  presence:
    name: "Room Presence"
  moving_distance:
    name: "Presence Distance"
  still_distance:
    name: "Still Distance"
```

---

## 🔧 **Guía de Instalación de Cada Beacon**

1. Flashear ESPHome  
2. Encender el Beacon  
3. Asignarlo a un Área  
4. Confirmar sensores y BLE  
5. Probar un comando de voz  

---

## 📄 **Licencia & Créditos**

Proyecto Domótico — Nicolás Rodríguez

---

