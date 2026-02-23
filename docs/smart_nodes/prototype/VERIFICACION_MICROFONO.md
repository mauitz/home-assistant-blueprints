# SmartNode1 - Verificación del Micrófono INMP441

**Dispositivo**: SmartNode1 @ 192.168.1.13  
**Pines**: GPIO25 (WS), GPIO26 (SCK), GPIO33 (SD), VDD → 3.3V, L/R → GND

---

## Estado verificado (2026-01-20)

- ✅ Configuración I2S correcta en ESPHome
- ✅ Dispositivo online y estable
- ✅ Sin errores de I2S en logs (indica hardware OK)
- ⚠️ Lectura directa del buffer no disponible en ESPHome (ver `SENSOR_AUDIO.md`)

---

## Verificación rápida por logs

```bash
# Reiniciar el dispositivo y capturar logs de arranque
utils/test_mic_with_reboot.sh

# O directamente:
esphome logs esphome/smartnode1.yaml --device 192.168.1.13
```

**Mensajes esperados al arrancar:**
```
[I][i2s_audio] Setting up I2S Audio...
[I][i2s_audio] I2S Audio initialized successfully
[I][microphone] Setting up Microphone 'smartnode_mic'...
```

**Mensajes de error (indica problema de hardware):**
```
[E][i2s_audio] I2S read timeout
[E][i2s_audio] Failed to initialize I2S
[W][microphone] Microphone initialization failed
```

---

## Verificación con firmware de prueba

```bash
# Flashear firmware de prueba
esphome run esphome/smartnode1_test_mic.yaml --device 192.168.1.13

# Verificar en HA: Configuración → Dispositivos → SmartNode1
# Entidad "Microphone Test": valor positivo = OK, -1 = no detectado

# Restaurar firmware principal
esphome run esphome/smartnode1.yaml --device 192.168.1.13
```

---

## Verificación física con multímetro

| Punto | Valor esperado |
|---|---|
| VDD – GND del INMP441 | 3.3V ±0.1V |
| GPIO26 (SCK) con ESP32 encendido | Señal de reloj (pulsos) |
| GPIO25 (WS) | Señal de reloj más lenta |
| GPIO33 (SD) | Actividad intermitente |

---

## Problemas comunes

| Error | Causa | Solución |
|---|---|---|
| `I2S read timeout` | Pin SD no conectado o micrófono dañado | Verificar GPIO33 → SD del INMP441 |
| `I2S driver install failed` | Conflicto de pines | Verificar que GPIO25/26/33 no están usados por otro componente |
| `Sound Level` siempre 0 | Normal — el sensor es placeholder | Usar `smartnode1_voice_assistant.yaml` o agregar MAX4466 |
