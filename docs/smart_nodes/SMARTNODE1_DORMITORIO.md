# SmartNode1 - Dormitorio Principal

## 📋 Información del Dispositivo

| Propiedad | Valor |
|-----------|-------|
| **Nombre** | SmartNode1 |
| **Nombre Amigable** | Smart Node 1 |
| **Ubicación** | Dormitorio Principal |
| **IP Estática** | 192.168.1.13 |
| **Alimentación** | USB 5V (conectado a corriente) |
| **Estado** | ✅ Operacional |
| **Firmware** | ESPHome (esp-idf framework) |

---

## 🔌 Alimentación

### Configuración Actual
- **Tipo:** Conectado a corriente (USB 5V)
- **Batería:** Li-Ion 2600mAh (respaldo de emergencia)
- **Consumo:** ~180mA en operación normal

### Autonomía en Batería (si se desconecta)
- **Operación normal:** ~11-13 horas
- **Modo bajo consumo:** ~15-18 horas (ver perfiles alternativos)

---

## 📡 Sensores Disponibles

### Sensores de Presencia (LD2410)

| Sensor | Entity ID | Update Rate | Uso |
|--------|-----------|-------------|-----|
| **Presencia** | `binary_sensor.smartnode1_presence` | Tiempo real | ✅ Principal |
| **Objetivo en Movimiento** | `binary_sensor.smartnode1_moving_target` | 1s | Informativo |
| **Objetivo Estático** | `binary_sensor.smartnode1_still_target` | 1s | Informativo |
| **Distancia de Detección** | `sensor.smartnode1_detection_distance` | 500ms | ✅ Para límites |
| **Distancia Movimiento** | `sensor.smartnode1_moving_distance` | Delta 10cm | Informativo |
| **Distancia Estático** | `sensor.smartnode1_still_distance` | Delta 10cm | Informativo |

### Sensores Ambientales

| Sensor | Entity ID | Update Rate | Rango |
|--------|-----------|-------------|-------|
| **Luminosidad** | `sensor.smartnode1_room_brightness` | 30s | 0-100% |
| **Temperatura** | `sensor.smartnode1_room_temperature` | 60s | 0-50°C |
| **Humedad** | `sensor.smartnode1_room_humidity` | 60s | 20-90% |

### Sensores de Sistema

| Sensor | Entity ID | Update Rate |
|--------|-----------|-------------|
| **Voltaje Batería** | `sensor.smartnode1_battery_voltage` | 60s |
| **Nivel Batería** | `sensor.smartnode1_battery_level` | 60s |
| **Señal WiFi** | `sensor.smartnode1_wifi_signal` | 60s |

---

## ⚙️ Configuración WiFi Optimizada

### Perfil Actual: **Respuesta Rápida** (Recomendado para corriente)

```yaml
wifi:
  power_save_mode: none   # Sin ahorro WiFi
  output_power: 10dB      # Potencia moderada
```

**Características:**
- ✅ Latencia: **80-120ms** (imperceptible)
- ✅ Consumo: **~180mA**
- ✅ Respuesta: Casi instantánea
- ✅ **Ideal para:** Conectado a corriente, automatizaciones de luces
- ✅ **Estado:** Activo desde Enero 2026

### Motivo de la Configuración

**Problema anterior:**
- Configuración con `power_save_mode: light` causaba delay de 200-500ms
- Experiencia de usuario frustrante al encender luces por presencia

**Solución implementada:**
- Desactivar ahorro de energía WiFi (`power_save_mode: none`)
- Latencia reducida en **70%** (de 300ms → 100ms)
- Como el dispositivo está enchufado, no hay preocupación por batería

---

## 🎛️ Configuración de Sensores

### Binary Sensors (Presencia)

```yaml
binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
      # SIN filtros - respuesta instantánea
      # ✅ Reporta cada cambio inmediatamente
```

**Sin throttle ni delays para máxima velocidad de respuesta.**

### Numeric Sensors (Optimizados)

```yaml
sensor:
  - platform: ld2410
    detection_distance:
      filters:
        - delta: 0.2      # Solo si cambia ±20cm
        - throttle: 500ms # Máximo 2 reportes/seg
```

**Reducción de tráfico WiFi en 60-80% sin afectar presencia.**

---

## 📍 Ubicación y Montaje

### Posición en Dormitorio

```
┌─────────────────────────────────────────┐
│                                         │
│  Puerta                         Ventana │
│    ↓                                    │
│    🚪                              ☀️   │
│                                         │
│                                         │
│         🛏️ Cama                        │
│                                         │
│                  📡 SmartNode1          │
│                  (mesita de noche)      │
│                                         │
│                                   Closet│
└─────────────────────────────────────────┘
```

### Características de Montaje
- **Altura:** ~70cm (sobre mesita de noche)
- **Ángulo:** Apuntando hacia puerta y área de circulación
- **Cobertura:** ~6m de radio
- **Zona óptima:** 0-4m (configurar en blueprint)

---

## 🏠 Automatizaciones Configuradas

### 1. Luces Automáticas por Presencia

**Blueprint:** `smartnode_multi_light_presence.yaml`

**Configuración:**
```yaml
Sensor de Presencia: binary_sensor.smartnode1_presence
Sensor de Luminosidad: sensor.smartnode1_room_brightness
Sensor de Distancia: sensor.smartnode1_detection_distance
Luces:
  - light.lampara_noche_dormitorio
  - light.luz_techo_dormitorio
  - light.lampara_escritorio
Brillo: 60%
Umbral Oscuridad: 30%
Distancia Máxima: 3m
Delay Apagar: 60s
```

**Comportamiento:**
- Al entrar de noche → Enciende luces al 60%
- Solo si está a ≤3m del sensor
- Apaga después de 60s sin presencia

---

## 📊 Métricas de Rendimiento

### Latencia Medida

| Métrica | Valor | Estado |
|---------|-------|--------|
| **LD2410 → ESP32** | 1-5ms | ✅ Excelente |
| **ESP32 → WiFi** | 10-50ms | ✅ Excelente |
| **WiFi → HA** | 20-50ms | ✅ Excelente |
| **Total E2E** | **80-120ms** | ✅ Imperceptible |

### Consumo Energético

| Componente | Consumo | % Total |
|------------|---------|---------|
| WiFi (sin power save) | ~80mA | 44% |
| ESP32 (activo) | ~40mA | 22% |
| LD2410 (radar) | ~30mA | 17% |
| Otros sensores | ~30mA | 17% |
| **TOTAL** | **~180mA** | **100%** |

### Tráfico de Red

| Sensor | Reportes/min (antes) | Reportes/min (ahora) | Reducción |
|--------|----------------------|----------------------|-----------|
| Presence | ~2 | ~2 | 0% (sin cambios) ✅ |
| Detection Distance | ~60 | ~12 | 80% ✅ |
| Moving Energy | ~60 | ~12 | 80% ✅ |
| **Total** | ~180 | ~40 | **78%** ✅ |

---

## 🔧 Mantenimiento

### Verificación Semanal

```bash
# Ver estado del dispositivo
curl http://192.168.1.13

# Ver logs en Home Assistant
Settings → System → Logs → Filter: smartnode1
```

### Verificar Señal WiFi

```yaml
# Sensor de señal WiFi
sensor.smartnode1_wifi_signal

# Valores aceptables:
# > -60 dBm: Excelente ✅
# -60 a -70 dBm: Bueno ✅
# -70 a -80 dBm: Aceptable ⚠️
# < -80 dBm: Débil ❌ (aumentar output_power)
```

### Actualización de Firmware

```bash
# Desde ESPHome Dashboard
1. Abrir ESPHome Dashboard
2. Buscar "smartnode1"
3. Click en "Update"
4. Esperar compilación e instalación OTA
```

---

## 🔄 Perfiles Alternativos

Si en el futuro se desconecta de la corriente, considerar estos perfiles:

### Perfil: Máximo Ahorro de Batería

```yaml
wifi:
  power_save_mode: light
  output_power: 8.5dB
```

- ⚠️ Latencia: 200-500ms
- ✅ Autonomía: 15-18 horas
- 🎯 Uso: Sensores no críticos

### Perfil: Equilibrado (Batería)

```yaml
wifi:
  power_save_mode: light
  output_power: 10dB
```

- ⚠️ Latencia: 150-300ms
- ✅ Autonomía: 13-15 horas
- 🎯 Uso: Batería con uso ocasional

### Perfil: Máxima Velocidad (Testing)

```yaml
wifi:
  power_save_mode: none
  output_power: 15dB
```

- ✅ Latencia: 50-80ms
- ⚠️ Autonomía: 9-11 horas
- 🎯 Uso: Testing, señal WiFi débil

---

## 📝 Historial de Cambios

### 2026-01-07 - Optimización de Latencia

**Cambios realizados:**
- ✅ Cambiado `power_save_mode: light` → `none`
- ✅ Aumentado `output_power: 8.5dB` → `10dB`
- ✅ Agregados filtros `delta` y `throttle` a sensores numéricos
- ✅ Reducido `api.reauth_timeout` a 5min

**Resultados:**
- Latencia reducida de 300ms → 100ms (-70%)
- Tráfico WiFi reducido en 78%
- Experiencia de usuario mejorada significativamente

**Justificación:**
- Dispositivo conectado permanentemente a corriente
- Consumo de batería no es preocupación
- Prioridad: Respuesta rápida para automatizaciones de luces

---

## 🆘 Troubleshooting

### Problema: Latencia alta nuevamente

**Verificar:**
1. Señal WiFi: `sensor.smartnode1_wifi_signal` > -70 dBm
2. Configuración WiFi en `smartnode1.yaml`
3. Router no sobrecargado

**Solución:**
- Aumentar `output_power` si señal es débil
- Verificar canal WiFi del router
- Reiniciar dispositivo: `esphome run smartnode1.yaml`

### Problema: Desconexiones frecuentes

**Verificar:**
1. IP estática correcta (192.168.1.13)
2. Router no tiene problemas DHCP
3. Firmware actualizado

**Solución:**
- Verificar router no tiene conflicto de IP
- Aumentar `reboot_timeout` si es necesario
- Revisar logs de ESPHome

### Problema: Sensores no reportan

**Verificar:**
1. Dispositivo online en HA
2. Entidades no deshabilitadas
3. Logs de ESPHome

**Solución:**
- Reiniciar integración ESPHome en HA
- Recompilar y subir firmware
- Verificar conexiones físicas de sensores

---

## 📚 Referencias

- [Configuración ESPHome](../../esphome/smartnode1.yaml)
- [Blueprint Multi-Light](../../blueprints/smartnode_multi_light_presence.yaml)
- [Análisis de Latencia](./OPTIMIZACION_LATENCIA_PRESENCIA.md)
- [Guía de Perfiles](./PERFILES_CONFIGURACION.md)

---

**Última actualización:** 2026-01-07
**Estado:** ✅ Operacional y optimizado
**Próxima revisión:** 2026-02-01

