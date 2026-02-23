# Perfiles de Configuración para SmartNodes

## 📋 Guía de Selección de Perfil

Esta guía te ayudará a elegir la configuración óptima para cada SmartNode según su uso y alimentación.

---

## 🎯 Árbol de Decisión

```
¿Tu SmartNode está enchufado a corriente?
│
├─ SÍ → Perfil 1: RESPUESTA RÁPIDA ⭐ (Recomendado)
│        Latencia: 80-120ms
│        Consumo: No es problema
│
└─ NO (a batería)
   │
   ├─ ¿Es crítico que responda rápido? (<200ms)
   │  │
   │  ├─ SÍ → Perfil 2: EQUILIBRADO
   │  │        Latencia: 100-150ms
   │  │        Autonomía: 11-13h
   │  │
   │  └─ NO → ¿Necesitas máxima duración de batería?
   │         │
   │         ├─ SÍ → Perfil 3: MÁXIMO AHORRO
   │         │        Latencia: 200-500ms
   │         │        Autonomía: 15-18h
   │         │
   │         └─ NO → Perfil 2: EQUILIBRADO
   │                  Latencia: 100-150ms
   │                  Autonomía: 11-13h
```

---

## 📊 Comparativa de Perfiles

| Perfil | Latencia | Consumo | Autonomía | Uso Recomendado |
|--------|----------|---------|-----------|-----------------|
| **1. Respuesta Rápida** | 80-120ms | 180mA | ∞ (corriente) | Enchufado, luces automáticas |
| **2. Equilibrado** | 100-150ms | 160mA | 11-13h | Batería, detección presencia |
| **3. Máximo Ahorro** | 200-500ms | 140mA | 15-18h | Batería, sensores ambientales |
| **4. Máxima Velocidad** | 50-80ms | 240mA | 9-11h | Testing, crítico |

---

## 🔧 Configuraciones Detalladas

### Perfil 1: Respuesta Rápida ⭐

**Mejor para:** SmartNodes conectados a corriente, automatizaciones de luces

```yaml
esphome:
  name: smartnodeX
  friendly_name: Smart Node X

esp32:
  board: esp32dev
  framework:
    type: esp-idf

logger:

api:
  encryption:
    key: "TU_KEY_AQUI"
  reauth_timeout: 5min  # Reconexión rápida

ota:
  - platform: esphome
    password: "TU_PASSWORD"

wifi:
  ssid: "TU_SSID"
  password: "TU_PASSWORD"

  manual_ip:
    static_ip: 192.168.1.XX  # Cambiar XX
    gateway: 192.168.1.1
    subnet: 255.255.255.0
    dns1: 192.168.1.1

  fast_connect: true
  reboot_timeout: 15min

  # ═══════════════════════════════════════
  # PERFIL: RESPUESTA RÁPIDA
  # ═══════════════════════════════════════
  power_save_mode: none   # Sin ahorro WiFi
  output_power: 10dB      # Potencia moderada

  ap:
    ssid: "SmartNodeX Fallback"
    password: "12345678"

captive_portal:

# UART para LD2410
uart:
  tx_pin: 17
  rx_pin: 16
  baud_rate: 256000
  parity: NONE
  stop_bits: 1

ld2410:

sensor:
  # Sensores LD2410 con filtros optimizados
  - platform: ld2410
    detection_distance:
      name: Detection Distance
      filters:
        - delta: 0.2
        - throttle: 500ms
    moving_distance:
      name: Moving Distance
      filters:
        - delta: 0.1
    still_distance:
      name: Still Distance
      filters:
        - delta: 0.1

binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      # SIN filtros - respuesta instantánea
```

**Métricas:**
- ✅ Latencia E2E: **80-120ms**
- ✅ Consumo: **~180mA**
- ✅ Ideal para: Conectado a corriente
- ✅ Respuesta: Casi instantánea

---

### Perfil 2: Equilibrado

**Mejor para:** Batería con necesidad de respuesta razonable

```yaml
wifi:
  # ... (misma configuración base)

  # ═══════════════════════════════════════
  # PERFIL: EQUILIBRADO
  # ═══════════════════════════════════════
  power_save_mode: light  # Ahorro moderado
  output_power: 10dB      # Potencia moderada

sensor:
  - platform: ld2410
    detection_distance:
      name: Detection Distance
      filters:
        - delta: 0.3        # Menos sensible
        - throttle: 1s      # Menos frecuente

binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      filters:
        - delayed_on: 100ms   # Anti-rebote
        - delayed_off: 200ms
```

**Métricas:**
- ⚠️ Latencia E2E: **100-200ms**
- ✅ Consumo: **~160mA**
- ✅ Autonomía: **11-13 horas**
- ✅ Balance óptimo para batería

---

### Perfil 3: Máximo Ahorro

**Mejor para:** Sensores ambientales, máxima duración de batería

```yaml
wifi:
  # ... (misma configuración base)

  # ═══════════════════════════════════════
  # PERFIL: MÁXIMO AHORRO
  # ═══════════════════════════════════════
  power_save_mode: light  # Ahorro máximo
  output_power: 8.5dB     # Mínimo permitido

sensor:
  # Sensores ambientales con update_interval largo
  - platform: adc
    pin: 32
    name: "Room Brightness"
    update_interval: 60s  # Era 30s

  - platform: dht
    pin: 4
    model: DHT11
    temperature:
      name: "Room Temperature"
    humidity:
      name: "Room Humidity"
    update_interval: 120s  # Era 60s

  - platform: ld2410
    detection_distance:
      name: Detection Distance
      filters:
        - delta: 0.5
        - throttle: 5s

binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      filters:
        - delayed_on: 200ms
        - delayed_off: 500ms
        - throttle: 1s  # Máximo 1 reporte/seg
```

**Métricas:**
- ⚠️ Latencia E2E: **200-500ms**
- ✅ Consumo: **~140mA**
- ✅ Autonomía: **15-18 horas**
- ⚠️ Solo para sensores no críticos

---

### Perfil 4: Máxima Velocidad

**Mejor para:** Testing, detección crítica, señal WiFi débil

```yaml
wifi:
  # ... (misma configuración base)

  # ═══════════════════════════════════════
  # PERFIL: MÁXIMA VELOCIDAD
  # ═══════════════════════════════════════
  power_save_mode: none   # Sin ahorro
  output_power: 15dB      # Alta potencia (o 20dB si muy lejos)

api:
  reauth_timeout: 3min    # Reconexión muy rápida

sensor:
  - platform: ld2410
    detection_distance:
      name: Detection Distance
      filters:
        - delta: 0.1      # Muy sensible
        - throttle: 100ms # Muy frecuente

binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      # SIN FILTROS - máxima velocidad
```

**Métricas:**
- ✅ Latencia E2E: **50-80ms**
- ⚠️ Consumo: **~240mA**
- ⚠️ Autonomía: **9-11 horas**
- 🔬 Solo testing o crítico

---

## 🎨 Personalización Avanzada

### Ajustar Output Power según Distancia al Router

```yaml
# Medir señal WiFi primero:
sensor:
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

# Luego ajustar output_power:
```

| Señal WiFi (dBm) | Distancia Aprox | output_power Recomendado |
|------------------|-----------------|--------------------------|
| > -50 dBm | < 3m | 8.5dB (mínimo) |
| -50 a -60 dBm | 3-7m | 10dB (moderado) |
| -60 a -70 dBm | 7-12m | 12-15dB (alto) |
| < -70 dBm | > 12m | 20dB (máximo) |

### Ajustar Filtros según Tipo de Sensor

**Sensores de movimiento rápido:**
```yaml
detection_distance:
  filters:
    - delta: 0.1      # Muy sensible
    - throttle: 100ms # Muy frecuente
```

**Sensores estáticos:**
```yaml
still_distance:
  filters:
    - delta: 0.5      # Menos sensible
    - throttle: 5s    # Menos frecuente
```

**Sensores informativos:**
```yaml
moving_energy:
  filters:
    - throttle: 10s   # Solo para estadísticas
```

---

## 📍 Ejemplos por Ubicación

### SmartNode en Dormitorio (enchufado)

**Perfil:** Respuesta Rápida
```yaml
wifi:
  power_save_mode: none
  output_power: 10dB
```

**Razón:** Conectado a corriente, necesita respuesta rápida para luces automáticas.

---

### SmartNode en Baño (a batería)

**Perfil:** Equilibrado
```yaml
wifi:
  power_save_mode: light
  output_power: 10dB

binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      filters:
        - delayed_on: 100ms
        - delayed_off: 200ms
```

**Razón:** Batería, pero necesita respuesta razonable. Autonomía de ~12h es suficiente.

---

### SmartNode en Pasillo (a batería)

**Perfil:** Equilibrado
```yaml
wifi:
  power_save_mode: light
  output_power: 12dB  # Mayor distancia al router

binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      filters:
        - delayed_off: 500ms  # Evita apagados al pasar rápido
```

**Razón:** Pasillo = tránsito rápido, necesita delay al apagar pero no al encender.

---

### SmartNode en Garaje (a batería, solo temperatura)

**Perfil:** Máximo Ahorro
```yaml
wifi:
  power_save_mode: light
  output_power: 8.5dB

sensor:
  - platform: dht
    update_interval: 300s  # Solo cada 5 minutos

# Deshabilitar LD2410 si no se necesita presencia
# ld2410:  # Comentar esta sección
```

**Razón:** Solo monitoreo de temperatura, no necesita respuesta rápida. Autonomía > 20h.

---

### SmartNode en Oficina (enchufado, testing)

**Perfil:** Máxima Velocidad
```yaml
wifi:
  power_save_mode: none
  output_power: 15dB

logger:
  level: DEBUG  # Logs detallados
```

**Razón:** Testing de automatizaciones, necesita respuesta instantánea y logs.

---

## 🔄 Migración entre Perfiles

### Cambiar de Máximo Ahorro → Respuesta Rápida

```yaml
# Cambiar:
wifi:
  power_save_mode: light → none
  output_power: 8.5dB → 10dB

# Quitar filtros innecesarios:
binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      # filters:  # ← Comentar o eliminar
      #   - throttle: 1s
```

**Pasos:**
1. Editar `smartnodeX.yaml`
2. Compilar: `esphome run smartnodeX.yaml`
3. Verificar mejora en latencia
4. Monitorear consumo (si está a batería)

---

### Cambiar de Respuesta Rápida → Máximo Ahorro

```yaml
# Cambiar:
wifi:
  power_save_mode: none → light
  output_power: 10dB → 8.5dB

# Agregar filtros:
binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      filters:
        - delayed_on: 200ms
        - delayed_off: 500ms
        - throttle: 1s
```

**Cuando hacerlo:**
- SmartNode se desconecta de corriente
- Autonomía de batería insuficiente
- Señal WiFi muy fuerte (sobra potencia)

---

## 📊 Tabla de Referencia Rápida

### Configuración WiFi

| Parámetro | Mínimo | Equilibrado | Máximo |
|-----------|--------|-------------|--------|
| `power_save_mode` | `light` | `light` | `none` |
| `output_power` | 8.5dB | 10-12dB | 15-20dB |
| `reauth_timeout` | 15min | 10min | 3-5min |

### Filtros de Sensores

| Sensor | Crítico | Normal | Ahorro |
|--------|---------|--------|--------|
| `detection_distance` | delta: 0.1<br>throttle: 100ms | delta: 0.2<br>throttle: 500ms | delta: 0.5<br>throttle: 5s |
| `binary_sensor.presence` | Sin filtros | delayed: 100ms | delayed: 200ms<br>throttle: 1s |

### Update Intervals

| Sensor | Crítico | Normal | Ahorro |
|--------|---------|--------|--------|
| Room Brightness | 10s | 30s | 60s |
| Temperature | 30s | 60s | 120-300s |
| Battery | 30s | 60s | 120s |

---

## 🆘 Problemas Comunes

### "Configuré respuesta rápida pero sigue lento"

**Verificar:**
1. ¿Compilaste y subiste el nuevo firmware?
2. ¿El dispositivo se reinició correctamente?
3. ¿La señal WiFi es buena? (> -70 dBm)

**Solución:**
```bash
# Forzar recompilación limpia
esphome clean smartnodeX.yaml
esphome run smartnodeX.yaml
```

---

### "La batería se agota muy rápido"

**Verificar:**
1. ¿Estás usando `power_save_mode: none`?
2. ¿El `output_power` es muy alto (>15dB)?
3. ¿Hay muchos sensores activos?

**Solución:**
- Cambiar a perfil Equilibrado
- Reducir `output_power` si señal WiFi es buena
- Aumentar `update_interval` de sensores no críticos

---

### "Muchos falsos positivos de presencia"

**Solución:**
```yaml
binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      filters:
        - delayed_on: 200ms   # Esperar antes de activar
        - delayed_off: 500ms  # Esperar antes de desactivar
```

---

## 📚 Referencias

- [SmartNode1 Dormitorio](./SMARTNODE1_DORMITORIO.md) - Configuración de referencia
- [Optimización de Latencia](./OPTIMIZACION_LATENCIA_PRESENCIA.md) - Análisis técnico detallado
- [ESPHome WiFi Component](https://esphome.io/components/wifi.html) - Documentación oficial
- [LD2410 Component](https://esphome.io/components/sensor/ld2410.html) - Documentación oficial

---

**Última actualización:** 2026-01-07
**Versión:** 1.0

