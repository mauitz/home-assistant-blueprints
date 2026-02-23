# 🚶 Automatizaciones de Presencia - Habitación SmartNode1

## 📋 Descripción General

Este sistema de automatización utiliza el sensor de presencia LD2410 del **SmartNode1** para detectar presencia en la habitación y ejecutar acciones automáticas cuando alguien entra o sale.

## 🎯 Características

- ✅ Detección de presencia en tiempo real con sensor radar LD2410
- ✅ Acciones personalizables al detectar presencia
- ✅ Acciones al no detectar presencia (con delay configurable)
- ✅ Notificaciones móviles
- ✅ Registro en logbook para seguimiento
- ✅ Ejemplos avanzados incluidos

## 📡 Sensores Disponibles

El SmartNode1 expone los siguientes sensores:

### Sensores Binarios (Presencia)
- `binary_sensor.presence` - **Presencia general (RECOMENDADO)**
- `binary_sensor.moving_target` - Solo detecta movimiento
- `binary_sensor.still_target` - Solo detecta presencia estática

### Sensores Ambientales
- `sensor.room_temperature` - Temperatura ambiente (°C)
- `sensor.room_humidity` - Humedad relativa (%)
- `sensor.room_brightness` - Luminosidad ambiente (%)
- `sensor.detection_distance` - Distancia de detección (m)

## 🔧 Automatizaciones Implementadas

### 1. Presencia Detectada
**ID:** `1734450000001`
**Trigger:** Cuando `binary_sensor.presence` cambia de `off` a `on`

**Acciones predeterminadas:**
- ✉️ Notificación móvil
- 📝 Registro en logbook

**Acciones opcionales (comentadas):**
- 💡 Encender luces
- 🎬 Activar escena
- 🌡️ Ajustar temperatura

### 2. Sin Presencia
**ID:** `1734450000002`
**Trigger:** Cuando `binary_sensor.presence` está en `off` por 5 minutos

**Acciones predeterminadas:**
- ✉️ Notificación móvil
- 📝 Registro en logbook

**Acciones opcionales (comentadas):**
- 💡 Apagar luces
- 🎬 Activar escena de ahorro
- 🌡️ Ajustar temperatura a modo eco

## 📝 Personalización

### Cambiar el Tiempo de Espera

Para ajustar cuánto tiempo esperar antes de considerar que no hay presencia:

```yaml
triggers:
- trigger: state
  entity_id: binary_sensor.presence
  from: 'on'
  to: 'off'
  for:
    minutes: 10  # Cambia este valor
    # También puedes usar: hours, seconds
```

**Tiempos recomendados por tipo de habitación:**
- 🚿 Baño: 3-5 minutos
- 🛏️ Habitación: 5-10 minutos
- 🛋️ Sala: 10-15 minutos
- 🍳 Cocina: 5-10 minutos

### Activar Acciones de Luz

Para encender/apagar luces automáticamente, descomenta las secciones correspondientes en cada automatización:

**En Presencia Detectada:**
```yaml
- action: light.turn_on
  target:
    entity_id: light.habitacion
  data:
    brightness_pct: 80
    transition: 1
```

**En Sin Presencia:**
```yaml
- action: light.turn_off
  target:
    entity_id: light.habitacion
  data:
    transition: 3
```

### Activar Escenas

**En Presencia:**
```yaml
- action: scene.turn_on
  target:
    entity_id: scene.habitacion_activa
```

**Sin Presencia:**
```yaml
- action: scene.turn_on
  target:
    entity_id: scene.habitacion_vacia
```

## 🌙 Ejemplos Avanzados

### Luz Nocturna Automática

Enciende luces tenues solo de noche (incluido en archivo de ejemplos):

```yaml
conditions:
- condition: time
  after: '22:00:00'
  before: '07:00:00'
actions:
- action: light.turn_on
  target:
    entity_id: light.habitacion
  data:
    brightness_pct: 15
    kelvin: 2200  # Luz cálida
```

### Alerta de Presencia Inesperada

Notifica si hay presencia cuando estás fuera de casa:

```yaml
conditions:
- condition: template
  value_template: '{{ (distance("device_tracker.blacky", "zone.home") | float(0)) > 0.1 }}'
- condition: state
  entity_id: input_boolean.presence_simulation
  state: 'off'
```

### Control de Clima Inteligente

Ajusta la temperatura según presencia:

**Con Presencia:**
```yaml
- action: climate.set_temperature
  target:
    entity_id: climate.habitacion
  data:
    temperature: 22
    hvac_mode: cool
```

**Sin Presencia:**
```yaml
- action: climate.set_temperature
  target:
    entity_id: climate.habitacion
  data:
    temperature: 26  # Modo eco
    hvac_mode: cool
```

## 🔄 Modos de Ejecución

### `mode: single`
- La automatización no se ejecuta nuevamente hasta que termine
- Ideal para: Presencia detectada

### `mode: restart`
- Se reinicia si se activa nuevamente durante la ejecución
- Ideal para: Sin presencia (resetea el timer si vuelve a haber movimiento)

### `mode: queued`
- Las ejecuciones se ponen en cola
- Ideal para: Registro de eventos

### `mode: parallel`
- Permite múltiples ejecuciones simultáneas
- Ideal para: Notificaciones independientes

## 📊 Monitoreo y Estadísticas

Puedes crear sensores de plantilla para monitorear el uso:

```yaml
template:
  - sensor:
      - name: "Habitación - Tiempo de Uso Hoy"
        state: >
          {{ state_attr('history_stats.habitacion_uso_hoy', 'value') }}
        unit_of_measurement: 'h'

sensor:
  - platform: history_stats
    name: Habitación Uso Hoy
    entity_id: binary_sensor.presence
    state: 'on'
    type: time
    start: '{{ now().replace(hour=0, minute=0, second=0) }}'
    end: '{{ now() }}'
```

## 🐛 Troubleshooting

### La presencia no se detecta
1. Verifica que el SmartNode1 esté online: `sensor.presence`
2. Revisa la distancia de detección: `sensor.detection_distance`
3. Ajusta la sensibilidad del LD2410 en ESPHome

### Las luces no se encienden/apagan
1. Verifica el `entity_id` de tu luz en Developer Tools
2. Comprueba que la luz esté disponible
3. Revisa el logbook para ver si la automatización se ejecutó

### Demasiadas notificaciones
1. Aumenta el tiempo de `for:` en el trigger
2. Agrega condiciones adicionales
3. Cambia el `interruption-level` a `passive`

### La automatización no se reinicia correctamente
- Cambia `mode: single` por `mode: restart`

## 📁 Archivos Relacionados

- `HA_config_proxy/automations.yaml` - Automatizaciones activas
- `examples/automatizaciones/presencia_habitacion_smartnode.yaml` - Ejemplos completos
- `docs/smart_nodes/prototype/device.yaml` - Configuración del SmartNode1

## 🔗 Referencias

- [Documentación LD2410](https://esphome.io/components/sensor/ld2410.html)
- [Home Assistant Automation](https://www.home-assistant.io/docs/automation/)
- [Conditions](https://www.home-assistant.io/docs/scripts/conditions/)
- [Actions](https://www.home-assistant.io/docs/scripts/service-calls/)

## 📝 Notas Adicionales

- El sensor LD2410 es muy sensible y puede detectar movimientos pequeños
- Ajusta los valores de `for:` según tus necesidades
- Puedes combinar múltiples sensores del SmartNode1 para automatizaciones más complejas
- El sensor de luminosidad puede ayudar a decidir si encender luces

## 💡 Ideas para Futuras Automatizaciones

- 🎵 Reproducir música al entrar
- 📺 Encender TV si es hora de entretenimiento
- 🌡️ Control inteligente de ventilador según temperatura
- 🔊 Ajustar volumen de notificaciones según hora
- 📱 Registro de patrones de uso para optimización
- 🎨 Cambio de color de luces según hora del día

