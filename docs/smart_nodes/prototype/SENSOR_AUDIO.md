# SmartNode1 - Sensor de Audio (INMP441)

**Hardware**: Micrófono INMP441 conectado vía I2S — GPIO25 (WS), GPIO26 (SCK), GPIO33 (SD).

---

## Limitación importante

ESPHome reserva el componente `microphone` **exclusivamente** para `voice_assistant`. No es posible leer el buffer de audio directamente desde sensores template o lambdas. Intentarlo devuelve solo el estado (running/stopped).

---

## Opciones disponibles

### Opción A — Voice Assistant (usa el INMP441 existente)

Configuración lista en `esphome/smartnode1_voice_assistant.yaml`.

**Ventajas**: sin hardware adicional, crea sensor de nivel de audio automático, permite control por voz de HA.  
**Requiere**: configurar Home Assistant Assist, mayor uso de CPU.

```yaml
voice_assistant:
  microphone: smartnode_mic
  noise_suppression_level: 2
  auto_gain: 31dBFS
  volume_multiplier: 2.0
```

### Opción B — Módulo analógico MAX4466 (recomendado para detección de sonido)

Agrega un módulo externo (~$2 USD) conectado a un pin ADC libre.

**Ventajas**: lectura directa y simple, muy bajo consumo de CPU, compatible en paralelo con el INMP441.

```
MAX4466 VCC → 3.3V
MAX4466 GND → GND
MAX4466 OUT → GPIO34
```

Configuración lista en `esphome/smartnode1_sound_detector.yaml`.

```yaml
sensor:
  - platform: adc
    pin: GPIO34
    name: "Sound Level"
    update_interval: 0.5s
    attenuation: 11db
    filters:
      - sliding_window_moving_average:
          window_size: 10
          send_every: 5
      - calibrate_linear:
          - 0.1 -> 0.0
          - 2.5 -> 100.0
      - clamp:
          min_value: 0
          max_value: 100

binary_sensor:
  - platform: template
    name: "Loud Noise Detected"
    lambda: return id(sound_level).state > 70.0;
```

---

## Comparación

| | Voice Assistant | MAX4466 |
|---|---|---|
| Hardware adicional | No | Sí (~$2) |
| Nivel de sonido | ✅ | ✅ |
| Comandos de voz | ✅ | ❌ |
| Consumo CPU | Alto | Muy bajo |
| Complejidad | Media | Baja |

---

## Archivos de referencia

| Archivo | Descripción |
|---|---|
| `esphome/smartnode1_voice_assistant.yaml` | Firmware con voice assistant |
| `esphome/smartnode1_sound_detector.yaml` | Firmware con MAX4466 analógico |
| `esphome/smartnode1_with_audio_sensor.yaml` | Variante con sensor de audio combinado |
| `esphome/smartnode1_test_mic.yaml` | Firmware de prueba del INMP441 |
| `docs/smart_nodes/prototype/VERIFICACION_MICROFONO.md` | Guía de verificación de hardware |
| `examples/automatizaciones/sound_detection_examples.yaml` | Ejemplos de automatizaciones |
