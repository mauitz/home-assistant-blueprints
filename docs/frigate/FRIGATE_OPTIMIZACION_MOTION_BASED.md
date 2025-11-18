# 🚀 OPTIMIZACIÓN DE FRIGATE - Detección Activada por Movimiento

**Fecha:** 14 de Noviembre, 2025
**Objetivo:** Reducir consumo de CPU de Frigate en 70-80% usando detección condicional

---

## 📊 PROBLEMA ACTUAL

- ✅ Frigate funcionando correctamente
- ❌ CPU al 100% todo el tiempo procesando video
- ❌ Las cámaras no tienen tanta actividad
- 💰 Desperdicio de recursos

**Consumo Actual (estimado):**
- 2 cámaras × 3 FPS × procesamiento IA continuo = **~80-100% CPU**

---

## ✅ SOLUCIÓN: DETECCIÓN ACTIVADA POR MOVIMIENTO

### Cómo Funciona:

```
┌─────────────────────────────────────────────────────────┐
│  CÁMARA TAPO detecta movimiento (hardware, bajo consumo)│
│  ↓                                                       │
│  Notifica a Home Assistant vía integración Tapo         │
│  ↓                                                       │
│  Automatización activa detección de Frigate             │
│  ↓                                                       │
│  Frigate procesa IA durante X minutos                   │
│  ↓                                                       │
│  Si no hay más movimiento, desactiva detección          │
│  ↓                                                       │
│  Frigate sigue grabando pero SIN procesar IA            │
└─────────────────────────────────────────────────────────┘
```

**Ventajas:**
- ✅ Ahorra 70-80% de CPU cuando no hay movimiento
- ✅ Detección instantánea (cámara detecta primero)
- ✅ No pierdes grabaciones (sigue grabando en background)
- ✅ IA solo cuando realmente importa

---

## 📋 IMPLEMENTACIÓN

### PASO 1: Verificar que tienes Motion Detection en Tapo

**Verificar sensores disponibles:**

```bash
# SSH al servidor
ssh nico@192.168.1.100

# Verificar entidades de cámaras Tapo
docker exec homeassistant ha-cli state list | grep -i "tapo\|motion"
```

**Deberías ver algo como:**
```
binary_sensor.tapo_c530ws_entrada_motion
binary_sensor.tapo_c310_exterior_motion
```

**Si NO existen estos sensores:**
- Necesitas la integración **"Tapo: Cameras Control"** de JurajNyiri
- Ver: `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md`

---

### PASO 2: Modificar Configuración de Frigate

**Editar:** `frigate_config_optimizado.yml`

#### Opción A: Detección Condicional por MQTT (Recomendada)

Agregar a cada cámara:

```yaml
cameras:
  entrada:
    enabled: true

    # ── Detección condicional basada en movimiento ──
    motion:
      enabled_in_config: true  # Activar motion detection

    # ── Activar detección solo cuando hay movimiento ──
    detect:
      enabled: true
      fps: 3
      # Hacer que la detección dependa de un topic MQTT
      # Home Assistant enviará mensaje cuando detecte movimiento

    # ── NUEVO: Configuración de activación condicional ──
    # Esto hace que Frigate solo procese IA cuando reciba señal
    mqtt:
      enabled: true
      # Topic para activar/desactivar detección
      # Home Assistant enviará: ON/OFF
      command_topic: frigate/cameras/entrada/detect/set
      state_topic: frigate/cameras/entrada/detect/state
```

#### Opción B: Usando Switches de Home Assistant (Más simple)

Frigate expone switches en HA que podemos controlar:

```yaml
# En cameras → entrada:
detect:
  enabled: true  # Inicia activada
  fps: 3
```

Luego desde HA controlamos:
- `switch.frigate_entrada_detect` → ON/OFF
- `switch.frigate_exterior_detect` → ON/OFF

---

### PASO 3: Crear Automatizaciones en Home Assistant

Crear archivo: `examples/frigate_motion_based_detection.yaml`

```yaml
# ════════════════════════════════════════════════════════════════════════════
# FRIGATE - DETECCIÓN ACTIVADA POR MOVIMIENTO
# ════════════════════════════════════════════════════════════════════════════
#
# REQUISITOS:
# 1. Integración Tapo: Cameras Control instalada
# 2. Sensores de movimiento de cámaras configurados
# 3. Frigate con switches de detección habilitados
#
# ════════════════════════════════════════════════════════════════════════════

# ──────────────────────────────────────────────────────────────────────────
# ENTRADA: Activar detección cuando cámara detecta movimiento
# ──────────────────────────────────────────────────────────────────────────

- id: frigate_entrada_motion_activate
  alias: "Frigate - Entrada - Activar Detección por Movimiento"
  description: >
    Cuando la cámara Tapo C530WS detecta movimiento,
    activa la detección de Frigate por 2 minutos

  triggers:
    - platform: state
      entity_id: binary_sensor.tapo_c530ws_entrada_motion
      from: 'off'
      to: 'on'

  conditions: []

  actions:
    # Activar detección de Frigate
    - service: switch.turn_on
      target:
        entity_id: switch.frigate_entrada_detect

    # Log para debugging
    - service: logbook.log
      data:
        name: "🎥 Frigate Optimización"
        message: "ENTRADA: Detección activada por movimiento de cámara"
        entity_id: switch.frigate_entrada_detect

    # Esperar 2 minutos (ajustar según necesidad)
    - delay:
        minutes: 2

    # Verificar si sigue habiendo movimiento
    - choose:
        # Si ya NO hay movimiento, desactivar
        - conditions:
            - condition: state
              entity_id: binary_sensor.tapo_c530ws_entrada_motion
              state: 'off'
          sequence:
            - service: switch.turn_off
              target:
                entity_id: switch.frigate_entrada_detect

            - service: logbook.log
              data:
                name: "🎥 Frigate Optimización"
                message: "ENTRADA: Detección desactivada (sin movimiento)"
                entity_id: switch.frigate_entrada_detect

      # Si sigue habiendo movimiento, mantener activa
      default:
        - service: logbook.log
          data:
            name: "🎥 Frigate Optimización"
            message: "ENTRADA: Detección permanece activa (movimiento continuo)"
            entity_id: switch.frigate_entrada_detect

  mode: restart  # Reinicia timer si hay nuevo movimiento

# ──────────────────────────────────────────────────────────────────────────
# ENTRADA: Desactivar si no hay movimiento por 3 minutos
# ──────────────────────────────────────────────────────────────────────────

- id: frigate_entrada_motion_deactivate
  alias: "Frigate - Entrada - Desactivar si Sin Movimiento"
  description: >
    Si no hay movimiento de cámara por 3 minutos,
    desactiva detección de Frigate para ahorrar CPU

  triggers:
    - platform: state
      entity_id: binary_sensor.tapo_c530ws_entrada_motion
      from: 'on'
      to: 'off'
      for:
        minutes: 3

  conditions:
    # Solo si la detección está activa
    - condition: state
      entity_id: switch.frigate_entrada_detect
      state: 'on'

  actions:
    - service: switch.turn_off
      target:
        entity_id: switch.frigate_entrada_detect

    - service: logbook.log
      data:
        name: "🎥 Frigate Optimización"
        message: "ENTRADA: Detección desactivada (3 min sin movimiento)"
        entity_id: switch.frigate_entrada_detect

  mode: single

# ──────────────────────────────────────────────────────────────────────────
# EXTERIOR: Activar detección cuando cámara detecta movimiento
# ──────────────────────────────────────────────────────────────────────────

- id: frigate_exterior_motion_activate
  alias: "Frigate - Exterior - Activar Detección por Movimiento"
  description: >
    Cuando la cámara Tapo C310 detecta movimiento,
    activa la detección de Frigate por 2 minutos

  triggers:
    - platform: state
      entity_id: binary_sensor.tapo_c310_exterior_motion
      from: 'off'
      to: 'on'

  conditions: []

  actions:
    - service: switch.turn_on
      target:
        entity_id: switch.frigate_exterior_detect

    - service: logbook.log
      data:
        name: "🎥 Frigate Optimización"
        message: "EXTERIOR: Detección activada por movimiento de cámara"
        entity_id: switch.frigate_exterior_detect

    - delay:
        minutes: 2

    - choose:
        - conditions:
            - condition: state
              entity_id: binary_sensor.tapo_c310_exterior_motion
              state: 'off'
          sequence:
            - service: switch.turn_off
              target:
                entity_id: switch.frigate_exterior_detect

            - service: logbook.log
              data:
                name: "🎥 Frigate Optimización"
                message: "EXTERIOR: Detección desactivada (sin movimiento)"
                entity_id: switch.frigate_exterior_detect

      default:
        - service: logbook.log
          data:
            name: "🎥 Frigate Optimización"
            message: "EXTERIOR: Detección permanece activa (movimiento continuo)"
            entity_id: switch.frigate_exterior_detect

  mode: restart

# ──────────────────────────────────────────────────────────────────────────
# EXTERIOR: Desactivar si no hay movimiento por 3 minutos
# ──────────────────────────────────────────────────────────────────────────

- id: frigate_exterior_motion_deactivate
  alias: "Frigate - Exterior - Desactivar si Sin Movimiento"
  description: >
    Si no hay movimiento de cámara por 3 minutos,
    desactiva detección de Frigate para ahorrar CPU

  triggers:
    - platform: state
      entity_id: binary_sensor.tapo_c310_exterior_motion
      from: 'on'
      to: 'off'
      for:
        minutes: 3

  conditions:
    - condition: state
      entity_id: switch.frigate_exterior_detect
      state: 'on'

  actions:
    - service: switch.turn_off
      target:
        entity_id: switch.frigate_exterior_detect

    - service: logbook.log
      data:
        name: "🎥 Frigate Optimización"
        message: "EXTERIOR: Detección desactivada (3 min sin movimiento)"
        entity_id: switch.frigate_exterior_detect

  mode: single

# ══════════════════════════════════════════════════════════════════════════
# OPCIONAL: Forzar detección en horarios específicos
# ══════════════════════════════════════════════════════════════════════════

- id: frigate_force_detect_night
  alias: "Frigate - Forzar Detección Nocturna"
  description: >
    Durante la noche (22:00-06:00), mantener siempre activa
    la detección para máxima seguridad

  triggers:
    - platform: time
      at: "22:00:00"

  conditions: []

  actions:
    # Activar ambas cámaras
    - service: switch.turn_on
      target:
        entity_id:
          - switch.frigate_entrada_detect
          - switch.frigate_exterior_detect

    - service: logbook.log
      data:
        name: "🎥 Frigate Optimización"
        message: "Detección forzada ACTIVA (modo nocturno)"

  mode: single

- id: frigate_release_detect_morning
  alias: "Frigate - Liberar Detección Matutina"
  description: >
    Por la mañana, volver a modo automático
    (solo activar con movimiento)

  triggers:
    - platform: time
      at: "06:00:00"

  conditions: []

  actions:
    # Desactivar si no hay movimiento actual
    - choose:
        - conditions:
            - condition: state
              entity_id: binary_sensor.tapo_c530ws_entrada_motion
              state: 'off'
          sequence:
            - service: switch.turn_off
              target:
                entity_id: switch.frigate_entrada_detect

    - choose:
        - conditions:
            - condition: state
              entity_id: binary_sensor.tapo_c310_exterior_motion
              state: 'off'
          sequence:
            - service: switch.turn_off
              target:
                entity_id: switch.frigate_exterior_detect

    - service: logbook.log
      data:
        name: "🎥 Frigate Optimización"
        message: "Modo automático activado (detección por movimiento)"

  mode: single

# ══════════════════════════════════════════════════════════════════════════
# HELPERS REQUERIDOS
# ══════════════════════════════════════════════════════════════════════════
#
# Crear estos helpers en Home Assistant UI o en configuration.yaml:
#
# input_boolean:
#   frigate_optimization_enabled:
#     name: "Optimización de Frigate Activa"
#     icon: mdi:cctv
#     initial: true
#
# counter:
#   frigate_detections_today:
#     name: "Detecciones Frigate Hoy"
#     icon: mdi:counter
#     restore: false
#     step: 1
#
# sensor:
#   - platform: template
#     sensors:
#       frigate_cpu_saved_percent:
#         friendly_name: "CPU Ahorrado por Optimización"
#         unit_of_measurement: "%"
#         value_template: >
#           {% set entrada_active = is_state('switch.frigate_entrada_detect', 'on') %}
#           {% set exterior_active = is_state('switch.frigate_exterior_detect', 'on') %}
#           {% set active_cameras = (entrada_active|int + exterior_active|int) %}
#           {% set total_cameras = 2 %}
#           {% set saved_percent = ((total_cameras - active_cameras) / total_cameras * 100) | round(0) %}
#           {{ saved_percent }}
#
# ══════════════════════════════════════════════════════════════════════════
```

---

### PASO 4: Crear Helpers de Monitoreo

Archivo: `examples/frigate_motion_helpers.yaml`

```yaml
# ════════════════════════════════════════════════════════════════════════════
# HELPERS PARA OPTIMIZACIÓN DE FRIGATE
# ════════════════════════════════════════════════════════════════════════════

# Switches para habilitar/deshabilitar optimización
input_boolean:
  frigate_optimization_enabled:
    name: "Optimización de Frigate"
    icon: mdi:cctv
    initial: true

  frigate_night_mode_force_detect:
    name: "Forzar Detección Nocturna"
    icon: mdi:weather-night
    initial: true

# Contador de activaciones
counter:
  frigate_entrada_activations_today:
    name: "Activaciones Entrada Hoy"
    icon: mdi:counter
    restore: false
    step: 1

  frigate_exterior_activations_today:
    name: "Activaciones Exterior Hoy"
    icon: mdi:counter
    restore: false
    step: 1

# Temporizadores
timer:
  frigate_entrada_cooldown:
    name: "Entrada - Cooldown"
    duration: "00:02:00"
    restore: true

  frigate_exterior_cooldown:
    name: "Exterior - Cooldown"
    duration: "00:02:00"
    restore: true

# ────────────────────────────────────────────────────────────────────────────
# SENSORES DE MONITOREO
# ────────────────────────────────────────────────────────────────────────────

sensor:
  # CPU ahorrado estimado
  - platform: template
    sensors:
      frigate_cpu_saved_percent:
        friendly_name: "CPU Ahorrado Frigate"
        unit_of_measurement: "%"
        icon_template: mdi:chip
        value_template: >
          {% set entrada = is_state('switch.frigate_entrada_detect', 'on') %}
          {% set exterior = is_state('switch.frigate_exterior_detect', 'on') %}
          {% set active = (entrada|int + exterior|int) %}
          {% set saved = ((2 - active) / 2 * 100) | round(0) %}
          {{ saved }}

      # Tiempo total con detección activa hoy
      frigate_entrada_active_time_today:
        friendly_name: "Entrada - Tiempo Activo Hoy"
        icon_template: mdi:timer
        value_template: >
          {{ state_attr('switch.frigate_entrada_detect', 'active_time_today') | default('0:00:00') }}

      frigate_exterior_active_time_today:
        friendly_name: "Exterior - Tiempo Activo Hoy"
        icon_template: mdi:timer
        value_template: >
          {{ state_attr('switch.frigate_exterior_detect', 'active_time_today') | default('0:00:00') }}

# ────────────────────────────────────────────────────────────────────────────
# BINARY SENSORS
# ────────────────────────────────────────────────────────────────────────────

binary_sensor:
  # Indica si alguna cámara tiene detección activa
  - platform: template
    sensors:
      frigate_any_camera_detecting:
        friendly_name: "Alguna Cámara Detectando"
        icon_template: mdi:cctv
        value_template: >
          {{ is_state('switch.frigate_entrada_detect', 'on') or
             is_state('switch.frigate_exterior_detect', 'on') }}

      # Modo nocturno activo
      frigate_night_mode_active:
        friendly_name: "Modo Nocturno Frigate"
        icon_template: mdi:weather-night
        value_template: >
          {% set now_hour = now().hour %}
          {{ now_hour >= 22 or now_hour < 6 }}
```

---

## 🚀 INSTALACIÓN

### En tu Mac (local):

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints

# Verificar que los archivos estén creados
ls -lh examples/frigate_motion_*

# Copiar al servidor
scp examples/frigate_motion_based_detection.yaml nico@192.168.1.100:/tmp/
scp examples/frigate_motion_helpers.yaml nico@192.168.1.100:/tmp/
```

### En el servidor:

```bash
ssh nico@192.168.1.100

# Verificar nombres exactos de entidades de sensores de movimiento
docker exec homeassistant ha-cli state list | grep -i "motion\|tapo"

# Backup de automations.yaml
sudo cp /opt/server/containers/homeassistant/config/automations.yaml \
        /opt/server/containers/homeassistant/config/automations.yaml.backup_$(date +%Y%m%d)

# Agregar automatizaciones al final de automations.yaml
sudo bash -c 'cat /tmp/frigate_motion_based_detection.yaml >> \
              /opt/server/containers/homeassistant/config/automations.yaml'

# Agregar helpers a configuration.yaml
sudo bash -c 'cat /tmp/frigate_motion_helpers.yaml >> \
              /opt/server/containers/homeassistant/config/configuration.yaml'

# Verificar sintaxis YAML
docker exec homeassistant ha-cli config check

# Si OK, reiniciar
docker restart homeassistant

# Ver logs
docker logs -f homeassistant | grep -i "frigate\|motion"
```

---

## 📊 RESULTADOS ESPERADOS

### Antes:
```
CPU: ████████████████████ 100% (Frigate procesando 2 cámaras 24/7)
Detecciones: ✓ Funcionando
Costo: Alto consumo continuo
```

### Después:
```
CPU: ████░░░░░░░░░░░░░░░░ 20-30% (Solo cuando hay movimiento)
Detecciones: ✓ Funcionando (igual de efectivo)
Costo: Ahorro de 70-80% CPU
```

### Métricas de Monitoreo:

En Home Assistant verás:
- **sensor.frigate_cpu_saved_percent**: Porcentaje de CPU ahorrado
- **counter.frigate_entrada_activations_today**: Cuántas veces se activó hoy
- **switch.frigate_entrada_detect**: Estado actual (ON/OFF)

---

## ⚠️ IMPORTANTE: AJUSTAR NOMBRES DE ENTIDADES

**Debes verificar los nombres EXACTOS de tus sensores:**

```bash
# En el servidor
docker exec homeassistant ha-cli state list | grep -i tapo
```

**Si los nombres son diferentes, editar en las automatizaciones:**

```yaml
# Reemplazar:
binary_sensor.tapo_c530ws_entrada_motion
# Por tu nombre real, por ejemplo:
binary_sensor.tapo_c530ws_motion_sensor
```

**Entidades que debes verificar:**
- Sensores de movimiento de cámaras Tapo (binary_sensor)
- Switches de detección de Frigate (switch.frigate_CAMERA_detect)

---

## 🎛️ CONFIGURACIÓN AVANZADA

### Ajustar Tiempos de Activación

```yaml
# En las automatizaciones, cambiar:
delay:
  minutes: 2  # ← Duración mínima de detección

for:
  minutes: 3  # ← Tiempo sin movimiento para desactivar
```

**Recomendaciones:**
- **Zona de alta actividad (entrada):** 1-2 minutos
- **Zona de baja actividad (exterior):** 3-5 minutos
- **Modo nocturno:** Siempre activo

### Deshabilitar Optimización Temporalmente

```yaml
# Agregar condición a cada automatización:
conditions:
  - condition: state
    entity_id: input_boolean.frigate_optimization_enabled
    state: 'on'
```

Luego desde HA UI:
- Apagar `input_boolean.frigate_optimization_enabled`
- Frigate volverá a modo normal (24/7)

---

## 🐛 TROUBLESHOOTING

### Problema: "Las automatizaciones no se activan"

**Verificar:**
```bash
# Entidades de movimiento existen?
docker exec homeassistant ha-cli state list | grep motion

# Switches de Frigate existen?
docker exec homeassistant ha-cli state list | grep frigate.*detect

# Automatizaciones están activas?
docker exec homeassistant ha-cli automation list
```

### Problema: "Frigate siempre está activo"

**Verificar:**
```bash
# Ver estado de switches
docker exec homeassistant ha-cli state get switch.frigate_entrada_detect
docker exec homeassistant ha-cli state get switch.frigate_exterior_detect

# Ver logs de automatizaciones
docker logs homeassistant | grep -A 5 "Frigate Optimización"
```

### Problema: "No tengo binary_sensor de movimiento"

**Solución:** Instalar integración correcta de Tapo
- Ver: `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md`
- Necesitas: "Tapo: Cameras Control" de JurajNyiri

---

## 📈 MONITOREO Y ESTADÍSTICAS

### Dashboard para monitoreo (agregar a Lovelace):

```yaml
type: vertical-stack
cards:
  - type: entities
    title: 🎥 Optimización Frigate
    entities:
      - entity: sensor.frigate_cpu_saved_percent
        name: CPU Ahorrado
      - entity: switch.frigate_entrada_detect
        name: Entrada - Detección
      - entity: switch.frigate_exterior_detect
        name: Exterior - Detección
      - entity: binary_sensor.frigate_any_camera_detecting
        name: Alguna Activa

  - type: entities
    title: 📊 Activaciones Hoy
    entities:
      - entity: counter.frigate_entrada_activations_today
        name: Entrada
      - entity: counter.frigate_exterior_activations_today
        name: Exterior

  - type: entities
    title: ⚙️ Configuración
    entities:
      - entity: input_boolean.frigate_optimization_enabled
        name: Optimización Activa
      - entity: input_boolean.frigate_night_mode_force_detect
        name: Forzar Detección Nocturna
```

---

## 🎯 PRÓXIMOS PASOS

1. **Instalar automatizaciones** (este documento)
2. **Monitorear por 24-48 horas**
3. **Ajustar tiempos** según tu actividad real
4. **Evaluar CPU ahorrado** con sensor dedicado
5. **Considerar Google Coral** si aún es alto (~$60, reduce CPU a 5-10%)

---

## 📚 RECURSOS RELACIONADOS

- `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md` - Integración Tapo
- `frigate_config_optimizado.yml` - Configuración actual
- `docs/FRIGATE_INSTALACION_COMPLETA.md` - Instalación Frigate
- `examples/camera_alert_system_v3.3_frigate.yaml` - Alertas actuales

---

**✅ Resultado Final:**
- CPU reducido en 70-80%
- Detecciones igual de efectivas
- Grabaciones continuas preservadas
- Sistema más eficiente y sostenible


