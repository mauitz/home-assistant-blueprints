# 🎙️ Smart Nodes ESP32

**Sistema de estaciones inteligentes multisensor con audio bidireccional por habitación**

---

## 📘 Descripción General

Los **Smart Nodes** son dispositivos multisensor basados en ESP32 que integran:

- 🎤 **Audio IN**: Micrófono INMP441 → comandos de voz → HA Assist
- 🔊 **Audio OUT**: Bluetooth → parlante BLE conectado al nodo
- 🌡️ **Sensores ambientales**: temperatura, humedad, luz
- 📡 **Detección de presencia**: radar mmWave LD2410C
- 📶 **WiFi**: comunicación con Home Assistant vía ESPHome

**Caso de uso:** _"Oye, enciende la luz del baño"_ → HA procesa → respuesta por el parlante Bluetooth del baño conectado al Smart Node.

---

## 🎯 Objetivos del Sistema

1. **Asistente de voz distribuido** en cada habitación sin dispositivos caros
2. **Salida de audio contextualizada** por área (parlantes BLE)
3. **Sensores ambientales centralizados** por habitación
4. **Detección de presencia avanzada** (mmWave + movimiento)
5. **Arquitectura modular y expandible**

---

## 🧩 Arquitectura Hardware

### Smart Node Completo (v2.0 - Planificado)

| Componente | Función | Estado |
|------------|---------|--------|
| **ESP32 WROOM** | Microcontrolador + WiFi + BLE | ✅ v1 |
| **DHT11** | Temperatura y humedad | ✅ v1 |
| **LDR** | Sensor de luz (luxómetro) | ✅ v1 |
| **LD2410C** | Radar mmWave (presencia) | ✅ v1 |
| **INMP441** | Micrófono digital I2S | 🔴 v2 |
| **BLE Audio Out** | Stream a parlante Bluetooth | 🔴 v2 |
| **MAX98357** | Amplificador I2S (opcional) | ⚪ Futuro |
| **Alimentación** | USB-C 5V | ✅ v1 |

### Prototipo v1 (Actual)

Ver diagrama y configuración en [`prototype/`](prototype/)

**Componentes implementados:**
- ✅ ESP32 DevKit 30 pines
- ✅ DHT11 (GPIO5)
- ✅ LDR (GPIO32 ADC)
- ✅ LD2410C (UART: TX→17, RX→16)
- ✅ Alimentación 5V + GND

**Pendientes para v2:**
- 🔴 INMP441 micrófono I2S
- 🔴 Configuración BLE audio output
- 🔴 Integration con HA Voice Assist

---

## 🔊 Sistema de Audio Bidireccional

### Audio IN (Voz → HA)

```yaml
# INMP441 configuración I2S
i2s_audio:
  - id: i2s_in
    i2s_lrclk_pin: GPIO_X
    i2s_bclk_pin: GPIO_Y
    i2s_din_pin: GPIO_Z

microphone:
  - platform: i2s_audio
    id: mic_i2s
    adc_type: external
    channel: left

voice_assistant:
  microphone: mic_i2s
  on_listening:
    - light.turn_on: led_status
  on_idle:
    - light.turn_off: led_status
```

### Audio OUT (HA → Parlante BLE)

```yaml
# Bluetooth audio streaming
esp32_ble_audio:
  name: "Smart Node [Room]"
  audio_output: true
  
# Conexión:
# Parlante BLE → emparejado con ESP32 → recibe TTS de HA
```

**Flujo completo:**
1. Usuario habla al micrófono del nodo
2. Audio → WiFi → HA Assist
3. HA procesa comando (Whisper STT + Piper TTS)
4. Respuesta TTS → WiFi → ESP32
5. ESP32 → BLE → Parlante Bluetooth del área

---

## 🌡️ Sensores por Habitación

Cada Smart Node expone en HA:

### Ambientales
- `sensor.{room}_temperature` (°C)
- `sensor.{room}_humidity` (%)
- `sensor.{room}_brightness` (%)

### Presencia
- `binary_sensor.{room}_presence` (on/off)
- `sensor.{room}_moving_distance` (cm)
- `sensor.{room}_still_distance` (cm)
- `sensor.{room}_detection_distance` (cm)

### Audio
- `assist.{room}_voice_assistant`
- `media_player.{room}_ble_speaker` (futuro)

---

## 🗺️ Roadmap del Proyecto

### ✅ FASE 1: Prototipo Básico (ACTUAL)
**Estado:** Diseñado, pendiente testing físico

- [x] Diseño hardware v1
- [x] Diagrama de conexiones
- [x] Firmware ESPHome base
- [x] Sensores ambientales (temp, humedad, luz)
- [x] Radar mmWave LD2410C
- [ ] Ensamblar prototipo físico
- [ ] Testing y validación sensores
- [ ] Flashear y conectar a HA
- [ ] Validar estabilidad 1 semana

**Tiempo estimado:** 2-3 semanas

---

### 🔴 FASE 2: Audio Bidireccional (PRÓXIMO)
**Objetivo:** Asistente de voz funcional

- [ ] Diseñar hardware v2 con INMP441
- [ ] Definir pinout I2S (verificar disponibilidad)
- [ ] Actualizar diagrama de conexiones
- [ ] Implementar voice_assistant en ESPHome
- [ ] Configurar BLE audio output
- [ ] Testing audio IN (captura voz)
- [ ] Testing audio OUT (parlante BLE)
- [ ] Integrar con HA Voice Assist pipeline
- [ ] Probar comandos de voz completos

**Tiempo estimado:** 3-4 semanas

---

### 🟡 FASE 3: Producción Multi-Nodo
**Objetivo:** Smart Nodes en 4-6 habitaciones

- [ ] Replicar hardware 3-5x
- [ ] Diseñar PCB custom (opcional)
- [ ] Crear enclosure 3D (opcional)
- [ ] Instalar nodos físicamente
- [ ] Asignar áreas en HA
- [ ] Configurar parlantes BLE por habitación
- [ ] Testing sistema completo
- [ ] Automatizaciones contextuales por área

**Tiempo estimado:** 4-6 semanas

---

### ⚪ FASE 4: Mejoras Avanzadas (FUTURO)
**Opcional:**

- [ ] MAX98357 para parlante cableado (backup)
- [ ] TP4056 + batería (UPS)
- [ ] Wake word local
- [ ] LED ring de status
- [ ] Detección BLE de dispositivos (bonus)
- [ ] Integración con escenas por área

---

## 📦 Instalación y Configuración

### 1. Hardware

Ver [`prototype/diagrama.png`](prototype/diagrama.png) para conexiones.

**Componentes necesarios (v1):**
- ESP32 DevKit 30 pines
- DHT11
- LDR + resistencia 10kΩ
- LD2410C
- Cables jumper
- Fuente USB-C 5V

### 2. Firmware

Archivo base: [`prototype/device.yaml`](prototype/device.yaml)

```bash
# Flashear con ESPHome
esphome run prototype/device.yaml
```

### 3. Home Assistant

**Configurar área:**
1. Configuración → Dispositivos
2. Seleccionar Smart Node
3. Asignar **Área** (Dormitorio, Baño, Sala, etc.)

**Verificar sensores:**
- `sensor.test1_room_temperature`
- `sensor.test1_room_humidity`
- `sensor.test1_room_brightness`
- `binary_sensor.test1_presence`

---

## 🔧 Configuración Avanzada

### Voice Assist Pipeline (v2)

1. **Configurar en HA:**
   - Configuración → Voice Assistants
   - Crear pipeline: STT (Whisper) + TTS (Piper)
   - Idioma: Español

2. **Asignar al Smart Node:**
   ```yaml
   voice_assistant:
     microphone: mic_i2s
     use_wake_word: false
     pipeline: "home_assistant"
   ```

### Automatizaciones Contextuales

```yaml
automation:
  - alias: "Comando de Voz Contextual"
    trigger:
      platform: event
      event_type: assist_action
      event_data:
        device_id: smart_node_bathroom
        intent: "turn_on_light"
    action:
      - service: light.turn_on
        target:
          area_id: bathroom
```

---

## 🚨 Troubleshooting

### Sensores no aparecen en HA
- Verificar API key en ESPHome
- Revisar logs: `esphome logs device.yaml`
- Confirmar conexión WiFi del ESP32

### DHT11 lee valores erróneos
- Verificar alimentación 5V estable
- Revisar conexión DATA pin
- Aumentar `update_interval` a 60s

### LD2410C no detecta presencia
- Verificar UART (TX/RX no invertidos)
- Ajustar sensibilidad en ESPHome
- Probar en habitación sin obstáculos metálicos

### Audio no funciona (v2)
- Verificar pinout I2S del INMP441
- Confirmar pipeline Voice Assist en HA
- Revisar logs de `voice_assistant` component

---

## 📊 Comparación con Alternativas

| Solución | Costo/Habitación | Audio | Sensores | Customizable |
|----------|------------------|-------|----------|--------------|
| **Smart Node** | ~$15-20 USD | ✅ BLE | ✅ Completo | ✅ 100% |
| HomePod Mini | ~$99 USD | ✅ | ❌ | ❌ |
| Echo Dot | ~$50 USD | ✅ | ❌ | ❌ |
| Google Nest Mini | ~$50 USD | ✅ | ❌ | ❌ |

---

## 📚 Recursos

### Documentación Técnica
- [ESPHome Voice Assist](https://esphome.io/components/voice_assistant.html)
- [LD2410 Component](https://esphome.io/components/sensor/ld2410.html)
- [I2S Audio](https://esphome.io/components/i2s_audio.html)
- [DHT Sensor](https://esphome.io/components/sensor/dht.html)

### Hardware
- [INMP441 Datasheet](https://invensense.tdk.com/products/digital/inmp441/)
- [LD2410C Manual](https://www.hlktech.net/index.php?id=988)
- [ESP32 Pinout](https://randomnerdtutorials.com/esp32-pinout-reference-gpios/)

---

## 📅 Estado Actual

**Fecha:** Diciembre 2024  
**Versión:** 1.0 (Prototipo)  
**Estado:** ⚠️ En desarrollo - Fase 1 activa

**Próximo milestone:** Ensamblar y validar prototipo v1

---

## 📝 Notas Técnicas

### Consideraciones de Diseño

1. **Pines I2S limitados**: ESP32 tiene 2 periféricos I2S. Si usamos audio IN + OUT, considerar MAX98357 vs BLE.
2. **Consumo**: ~200mA en idle, ~500mA con audio activo.
3. **Latencia BLE**: ~100-300ms (aceptable para TTS).
4. **Interferencia 2.4GHz**: WiFi + BLE pueden interferir, separar canales.

### Decisiones de Arquitectura

- **BLE audio OUT** > MAX98357: Más flexible, sin cables adicionales
- **ESP-IDF** > Arduino: Mejor soporte BLE avanzado
- **DHT11** > DHT22: Suficiente precisión para uso doméstico
- **LD2410C**: Superior a PIR, detecta presencia estática

---

**Proyecto:** Smart Nodes ESP32  
**Autor:** Nicolás Rodríguez  
**Licencia:** MIT  
**Repositorio:** [home-assistant-blueprints](../../)

