# Floorplan - Referencia Rápida

## Estructura base

```yaml
type: picture-elements
image: /local/floorplan/casa.png
elements:
  - type: state-icon
    entity: light.sala
    tap_action:
      action: toggle
    style:
      top: 30%
      left: 25%
```

---

## Tipos de elementos

```yaml
# Icono con estado
- type: state-icon
  entity: light.sala
  tap_action:
    action: toggle
  style:
    top: 30%
    left: 25%

# Etiqueta con valor
- type: state-label
  entity: sensor.temperatura
  prefix: "🌡️ "
  suffix: "°C"
  style:
    top: 35%
    left: 25%

# Badge
- type: state-badge
  entity: binary_sensor.puerta
  style:
    top: 50%
    left: 50%

# Zona interactiva (button-card)
- type: custom:button-card
  entity: light.sala
  show_icon: false
  show_name: false
  tap_action:
    action: toggle
  style:
    top: 30%
    left: 25%
    width: 300px
    height: 200px
    background: |
      {% if is_state('light.sala', 'on') %}
        rgba(255, 235, 59, 0.3)
      {% else %}
        rgba(0, 0, 0, 0.05)
      {% endif %}
    border-radius: 15px
```

---

## Acciones

```yaml
tap_action:
  action: toggle           # Alternar on/off
  action: more-info        # Más información
  action: navigate
  navigation_path: /lovelace/sala
  action: call-service
  service: light.turn_on
  service_data:
    entity_id: light.sala
```

---

## Estilos

```yaml
style:
  top: 30%                                  # Posición vertical
  left: 25%                                 # Posición horizontal
  transform: scale(1.5)                     # Tamaño
  color: "#ff5252"
  background: rgba(255, 235, 59, 0.3)       # Fondo semi-transparente
  border-radius: 15px
  filter: drop-shadow(0 0 10px rgba(255,193,7,0.8))

# Condicional
color: |
  {% if is_state('light.sala', 'on') %}
    #FFD700
  {% else %}
    #9E9E9E
  {% endif %}
```

---

## Paleta de colores

```
Luz encendida:  rgba(255, 235, 59, 0.3)   # Amarillo
Alerta/movim.:  rgba(255, 82, 82, 0.4)    # Rojo
OK/cerrado:     rgba(76, 175, 80, 0.4)    # Verde
Temperatura:    rgba(33, 150, 243, 0.9)   # Azul
Cocina:         rgba(255, 152, 0, 0.9)    # Naranja
Apagado:        rgba(100, 100, 100, 0.3)  # Gris
```

---

## Cuadrícula de posicionamiento

```
     0%     25%     50%     75%    100%
  0% +-------+-------+-------+-------+
 25% +-------+-------+-------+-------+
 50% +-------+-------+-------+-------+
 75% +-------+-------+-------+-------+
100% +-------+-------+-------+-------+

Centro:          top: 50%, left: 50%
Esquina sup-izq: top: 5%,  left: 5%
Esquina sup-der: top: 5%,  right: 5%
```

---

## Templates útiles

```yaml
# Contar luces encendidas
{{ states.light | selectattr('state', 'eq', 'on') | list | count }}

# Color según temperatura
{% set temp = states('sensor.temperatura') | float %}
{% if temp > 25 %}#FF5252{% elif temp > 20 %}#FFD700{% else %}#2196F3{% endif %}
```

---

## Iconos MDI frecuentes

```
Luces:      mdi:lightbulb, mdi:lightbulb-on, mdi:lightbulb-group
Sensores:   mdi:thermometer, mdi:motion-sensor, mdi:walk
Puertas:    mdi:door, mdi:door-open, mdi:door-closed
Cámaras:    mdi:cctv, mdi:camera
Clima:      mdi:fan, mdi:air-conditioner, mdi:weather-sunny
```

Referencia completa: https://materialdesignicons.com/
