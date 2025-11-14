# 📡 Implementación de Widget de Área Inteligente con BLE Beacons

## 📋 Estado: PENDIENTE - Esperando información de beacons

---

## 🎯 Objetivo

Implementar detección automática de área usando BLE Beacons para mostrar dinámicamente los switches de la habitación donde te encuentras.

---

## 📦 Hardware Necesario

### Beacons por Habitación

**Información a recopilar por cada beacon:**

```yaml
# Plantilla a completar:
beacon_dormitorio_3:
  uuid: "PENDIENTE"           # UUID del beacon
  major: "PENDIENTE"          # Major ID
  minor: "PENDIENTE"          # Minor ID
  rssi_threshold: -70         # Umbral de señal (ajustar después)
  area_name: "Dormitorio 3"
  area_id: "bedroom_3"

beacon_sala:
  uuid: "PENDIENTE"
  major: "PENDIENTE"
  minor: "PENDIENTE"
  rssi_threshold: -70
  area_name: "Sala"
  area_id: "living_room"

beacon_cocina:
  uuid: "PENDIENTE"
  major: "PENDIENTE"
  minor: "PENDIENTE"
  rssi_threshold: -70
  area_name: "Cocina"
  area_id: "kitchen"

beacon_bano_3:
  uuid: "PENDIENTE"
  major: "PENDIENTE"
  minor: "PENDIENTE"
  rssi_threshold: -70
  area_name: "Baño 3"
  area_id: "bathroom_3"

beacon_hall:
  uuid: "PENDIENTE"
  major: "PENDIENTE"
  minor: "PENDIENTE"
  rssi_threshold: -70
  area_name: "Hall"
  area_id: "hall"

beacon_exterior:
  uuid: "PENDIENTE"
  major: "PENDIENTE"
  minor: "PENDIENTE"
  rssi_threshold: -70
  area_name: "Exterior"
  area_id: "exterior"
```

---

## 🔧 Paso 1: Configuración de Home Assistant Companion App

### En el celular (Blacky):

1. **Instalar/Actualizar Home Assistant Companion App**
   - iOS: App Store
   - Android: Play Store

2. **Activar Bluetooth Tracking**
   - Abrir Companion App
   - Menú → Configuración → Companion App
   - Sensores → Bluetooth
   - Activar "BLE Transmitters"
   - Otorgar permisos de Bluetooth

3. **Configurar Beacons**
   - Una vez colocados los beacons físicos
   - La app detectará automáticamente los UUIDs
   - Configurar cada beacon con su área correspondiente

---

## 🏠 Paso 2: Colocación Física de Beacons

### Ubicaciones Recomendadas:

```
Dormitorio 3:
  • Cerca de la cama (mesa de noche)
  • Altura: 1-1.5m
  • Lejos de paredes metálicas

Sala:
  • Centro de la habitación
  • Altura: 1.5-2m
  • Cerca del área principal de uso

Cocina:
  • Área de trabajo principal
  • Altura: 1.5m
  • Alejado de electrodomésticos grandes

Baño 3:
  • Junto al espejo/lavabo
  • Altura: 1.5m
  • Protegido de humedad

Hall:
  • Centro del pasillo
  • Altura: 2m

Exterior:
  • Protegido de clima
  • Entrada principal
```

### Consejos:
- **Evitar** superficies metálicas (interfieren con Bluetooth)
- **Evitar** microondas y otros dispositivos de 2.4GHz cercanos
- **Usar** adhesivos o soportes discretos
- **Probar** ubicaciones antes de fijar permanentemente

---

## 🔌 Paso 3: Configuración en Home Assistant

### 3.1. Crear Sensores de Proximidad

```yaml
# configuration.yaml

# Sensor que detecta el área actual basado en beacons
template:
  - sensor:
      - name: "Blacky Area Actual"
        unique_id: blacky_current_area
        icon: mdi:map-marker-radius
        state: >
          {# Obtener RSSI más fuerte de todos los beacons #}
          {% set beacons = {
            'bedroom_3': states('sensor.blacky_ble_beacon_bedroom_3_rssi') | int(-999),
            'living_room': states('sensor.blacky_ble_beacon_living_room_rssi') | int(-999),
            'kitchen': states('sensor.blacky_ble_beacon_kitchen_rssi') | int(-999),
            'bathroom_3': states('sensor.blacky_ble_beacon_bathroom_3_rssi') | int(-999),
            'hall': states('sensor.blacky_ble_beacon_hall_rssi') | int(-999),
            'exterior': states('sensor.blacky_ble_beacon_exterior_rssi') | int(-999)
          } %}

          {# Filtrar solo beacons con señal válida (> -80) #}
          {% set valid_beacons = dict(beacons.items() | selectattr('1', '>', -80) | list) %}

          {# Retornar el área con la señal más fuerte #}
          {% if valid_beacons | length > 0 %}
            {% set strongest = valid_beacons | dictsort(false, 'value') | last %}
            {{ strongest[0] }}
          {% else %}
            unknown
          {% endif %}
        attributes:
          friendly_name_es: >
            {% set areas = {
              'bedroom_3': 'Dormitorio 3',
              'living_room': 'Sala',
              'kitchen': 'Cocina',
              'bathroom_3': 'Baño 3',
              'hall': 'Hall',
              'exterior': 'Exterior',
              'unknown': 'Desconocida'
            } %}
            {{ areas.get(this.state, 'Desconocida') }}
          beacon_count: >
            {{ states.sensor | selectattr('entity_id', 'search', 'blacky_ble_beacon_.*_rssi')
               | selectattr('state', '>', '-80') | list | count }}
          strongest_rssi: >
            {% set rssi_values = [
              states('sensor.blacky_ble_beacon_bedroom_3_rssi') | int(-999),
              states('sensor.blacky_ble_beacon_living_room_rssi') | int(-999),
              states('sensor.blacky_ble_beacon_kitchen_rssi') | int(-999),
              states('sensor.blacky_ble_beacon_bathroom_3_rssi') | int(-999),
              states('sensor.blacky_ble_beacon_hall_rssi') | int(-999),
              states('sensor.blacky_ble_beacon_exterior_rssi') | int(-999)
            ] %}
            {{ rssi_values | max }}
```

### 3.2. Mapeo de Áreas a Switches

```yaml
# configuration.yaml

# Mapa de switches por área
input_text:
  area_switches_map:
    name: "Mapa de Switches por Área"
    initial: |
      {
        "bedroom_3": [
          "switch.bedroom_3_switch_switch_1",
          "switch.bedroom_3_switch_switch_2",
          "switch.bedroom_3_switch_switch_3",
          "switch.sonoff_10025ffc47_1"
        ],
        "living_room": [
          "switch.4gang_switch_switch_1",
          "switch.4gang_switch_switch_2"
        ],
        "kitchen": [
          "switch.3gang_switch_switch_1",
          "switch.3gang_switch_switch_2"
        ],
        "bathroom_3": [
          "switch.3gang_switch_switch_3"
        ],
        "hall": [
          "switch.4gang_switch_2_switch_1",
          "switch.4gang_switch_2_switch_2"
        ],
        "exterior": [
          "switch.tapo_c310_exterior"
        ]
      }
```

---

## 🎨 Paso 4: Widget en Dashboard

```yaml
# dashboards/maui_dashboard.yaml

# SECCIÓN: ÁREA ACTUAL (INTELIGENTE)
- type: vertical-stack
  cards:
    # Header
    - type: markdown
      content: |
        # Área Actual
      card_mod:
        style: |
          ha-card {
            background: none;
            box-shadow: none;
            margin-bottom: -12px;
            margin-top: 24px;
          }
          h1 {
            font-size: 18px;
            font-weight: 400;
            margin: 0;
            color: #A0A0A0;
            letter-spacing: 0.5px;
          }

    # Indicador de área detectada
    - type: custom:mushroom-template-card
      primary: "{{ state_attr('sensor.blacky_current_area', 'friendly_name_es') }}"
      secondary: >
        {% if states('sensor.blacky_current_area') != 'unknown' %}
          Beacons: {{ state_attr('sensor.blacky_current_area', 'beacon_count') }}
          • Señal: {{ state_attr('sensor.blacky_current_area', 'strongest_rssi') }} dBm
        {% else %}
          Área no detectada
        {% endif %}
      icon: mdi:map-marker-radius
      icon_color: >
        {% if states('sensor.blacky_current_area') != 'unknown' %}
          blue
        {% else %}
          grey
        {% endif %}
      card_mod:
        style: |
          ha-card {
            background: #121212;
            border: 1px solid #2A2A2A;
            border-radius: 8px;
          }

    # Switches del área actual (Dormitorio 3)
    - type: conditional
      conditions:
        - entity: sensor.blacky_current_area
          state: "bedroom_3"
      card:
        type: entities
        title: Dormitorio 3
        entities:
          - switch.bedroom_3_switch_switch_1
          - switch.bedroom_3_switch_switch_2
          - switch.bedroom_3_switch_switch_3
          - switch.sonoff_10025ffc47_1
        card_mod:
          style: |
            ha-card {
              background: #121212;
              border: 1px solid #2A2A2A;
            }

    # Switches del área actual (Sala)
    - type: conditional
      conditions:
        - entity: sensor.blacky_current_area
          state: "living_room"
      card:
        type: entities
        title: Sala
        entities:
          - switch.4gang_switch_switch_1
          - switch.4gang_switch_switch_2
        card_mod:
          style: |
            ha-card {
              background: #121212;
              border: 1px solid #2A2A2A;
            }

    # (Repetir para cada área: kitchen, bathroom_3, hall, exterior)

    # Mensaje cuando no detecta área
    - type: conditional
      conditions:
        - entity: sensor.blacky_current_area
          state: "unknown"
      card:
        type: markdown
        content: |
          No se detecta ningún área cercana.
          Acércate a una habitación con beacon.
        card_mod:
          style: |
            ha-card {
              background: #121212;
              border: 1px solid #2A2A2A;
              padding: 16px;
            }
            p {
              font-size: 13px;
              color: #707070;
              text-align: center;
              margin: 0;
            }
```

---

## 🧪 Paso 5: Testing y Calibración

### 5.1. Verificar Detección de Beacons

```yaml
# Crear dashboard de debug temporal
# Ver en Herramientas de Desarrollo → Estados

sensor.blacky_ble_beacon_bedroom_3_rssi
sensor.blacky_ble_beacon_living_room_rssi
sensor.blacky_ble_beacon_kitchen_rssi
# ... etc
```

### 5.2. Ajustar Umbrales RSSI

Los valores típicos de RSSI:
- **-50 a -60 dBm**: Muy cerca (< 1m)
- **-60 a -70 dBm**: Cerca (1-3m)
- **-70 a -80 dBm**: Media distancia (3-5m)
- **-80 a -90 dBm**: Lejos (5-10m)
- **< -90 dBm**: Muy lejos / sin señal

**Ajustar el threshold en el template según tu casa:**
```yaml
# Cambiar -80 por el valor que funcione mejor
{% set valid_beacons = dict(beacons.items() | selectattr('1', '>', -80) | list) %}
```

### 5.3. Testing Manual

1. Caminar por cada habitación con beacons
2. Observar `sensor.blacky_current_area`
3. Verificar que cambia correctamente
4. Ajustar ubicación de beacons si es necesario
5. Probar cambios entre habitaciones contiguas

---

## 📊 Paso 6: Logging y Debug

### Activar logs de bluetooth:

```yaml
# configuration.yaml
logger:
  default: warning
  logs:
    homeassistant.components.mobile_app: debug
    homeassistant.components.bluetooth: debug
```

### Automation de notificación (opcional):

```yaml
# Para saber cuándo cambias de área
automation:
  - id: notify_area_change
    alias: "Debug - Notificar Cambio de Área"
    trigger:
      - platform: state
        entity_id: sensor.blacky_current_area
    condition:
      - condition: template
        value_template: "{{ trigger.from_state.state != trigger.to_state.state }}"
    action:
      - service: notify.mobile_app_blacky
        data:
          title: "Área Detectada"
          message: "Cambiaste de {{ trigger.from_state.attributes.friendly_name_es }} a {{ trigger.to_state.attributes.friendly_name_es }}"
    mode: single
```

---

## 🔄 Paso 7: Optimización Avanzada

### 7.1. Hysteresis (Evitar cambios rápidos)

```yaml
template:
  - sensor:
      - name: "Blacky Area Actual Estable"
        state: >
          {# Solo cambiar si la nueva área tiene 3dBm más de señal #}
          {% set current = states('sensor.blacky_current_area_raw') %}
          {% set last = states('sensor.blacky_current_area_estable') %}
          {% set current_rssi = state_attr('sensor.blacky_current_area_raw', 'strongest_rssi') | int(0) %}
          {% set last_rssi = state_attr('sensor.blacky_current_area_estable', 'strongest_rssi') | int(0) %}

          {% if (current_rssi - last_rssi) > 3 %}
            {{ current }}
          {% else %}
            {{ last }}
          {% endif %}
```

### 7.2. Time-based smoothing

Agregar delay para evitar cambios instantáneos:

```yaml
automation:
  - id: update_stable_area
    alias: "Actualizar Área Estable"
    trigger:
      - platform: state
        entity_id: sensor.blacky_current_area_raw
        for:
          seconds: 5  # Debe estar 5 segundos para confirmar
    action:
      - service: input_text.set_value
        target:
          entity_id: input_text.current_area_stable
        data:
          value: "{{ trigger.to_state.state }}"
```

---

## 📝 Checklist de Implementación

### Antes de empezar:
- [ ] Beacons físicos adquiridos
- [ ] UUIDs de cada beacon anotados
- [ ] Home Assistant Companion App instalada
- [ ] Permisos de Bluetooth otorgados

### Durante la instalación:
- [ ] Beacons colocados en cada habitación
- [ ] Beacons detectados en Companion App
- [ ] Sensores RSSI apareciendo en HA
- [ ] Template sensor `blacky_current_area` creado
- [ ] Widget agregado al dashboard

### Testing:
- [ ] Detección funciona en cada habitación
- [ ] Cambios entre habitaciones son correctos
- [ ] No hay cambios erráticos
- [ ] Umbrales RSSI ajustados
- [ ] Logging activado para debug

### Optimización:
- [ ] Hysteresis configurado (si es necesario)
- [ ] Time delays ajustados
- [ ] Automation de notificación probada
- [ ] Dashboard de debug eliminado

---

## 🚨 Troubleshooting

### Problema: Beacons no detectados
**Solución:**
- Verificar permisos de Bluetooth en Companion App
- Verificar que beacons tengan batería
- Acercarse más al beacon
- Reiniciar Companion App

### Problema: Área cambia constantemente
**Solución:**
- Implementar hysteresis (ver Paso 7.1)
- Aumentar threshold RSSI
- Alejar beacons entre sí
- Agregar delay (ver Paso 7.2)

### Problema: No detecta cambios de habitación
**Solución:**
- Reducir threshold RSSI
- Verificar ubicación de beacons
- Verificar obstáculos (paredes gruesas, metal)
- Probar reubicando beacons

### Problema: Batería del celular se descarga rápido
**Solución:**
- Aumentar intervalo de escaneo en Companion App
- Usar menos beacons
- Configurar "power saving mode" en Companion App

---

## 📚 Recursos Adicionales

- **Companion App Docs**: https://companion.home-assistant.io/
- **Bluetooth Tracking**: https://companion.home-assistant.io/docs/core/sensors#bluetooth-sensors
- **BLE Beacons Guide**: https://www.home-assistant.io/integrations/bluetooth_le_tracker/
- **Template Sensors**: https://www.home-assistant.io/integrations/template/

---

## 📅 Estado Actual

**FECHA**: $(date)
**ESTADO**: Documentación completa - Esperando información de beacons
**PRÓXIMO PASO**: Usuario proporcionará UUIDs y detalles de beacons instalados

---

**NOTA**: Este documento se actualizará con la configuración específica una vez que se reciban los datos de los beacons físicos.


