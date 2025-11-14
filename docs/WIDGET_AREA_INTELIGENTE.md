# 📍 Widget de Área Inteligente - Análisis y Diseño

## 🎯 Objetivo

Crear un widget que:
1. Detecte automáticamente en qué área del hogar está el dispositivo (celular/tablet)
2. Muestre el nombre del área actual
3. Despliegue automáticamente los switches/luces de esa área
4. Se actualice en tiempo real cuando cambias de habitación

---

## 🔍 Investigación: Métodos de Detección de Área

### **MÉTODO 1: Home Assistant Companion App + BLE Beacons** ⭐⭐⭐⭐⭐

#### Cómo funciona:
- Usas la **Home Assistant Companion App** en tu celular
- Colocas **BLE Beacons** (pequeños dispositivos Bluetooth) en cada habitación
- El celular detecta qué beacon está más cerca
- Reporta automáticamente el área a Home Assistant
- El dashboard lee el sensor del celular y muestra el área correspondiente

#### Ventajas:
✅ Precisión excelente (nivel de habitación)
✅ Actualización automática en tiempo real
✅ No requiere intervención manual
✅ Funciona incluso con pantalla apagada
✅ Beacons baratos ($5-15 cada uno)

#### Desventajas:
❌ Requiere hardware adicional (beacons)
❌ Configuración inicial más compleja
❌ Necesita Companion App con permisos de Bluetooth

#### Implementación:
```yaml
# En Home Assistant, el sensor se vería así:
sensor.blacky_ble_id
  state: "bedroom_3"  # Área detectada automáticamente

# El dashboard lee este sensor:
- type: conditional
  conditions:
    - entity: sensor.blacky_ble_id
      state: "bedroom_3"
  card:
    # Mostrar switches del dormitorio 3
```

#### Hardware necesario:
- **iBeacons / Bluetooth Beacons**: $5-15 c/u
  - Ejemplos: Tile, Estimote, Nut Mini
  - O DIY con ESP32 ($3-5 c/u)
- **Uno por cada área** que quieras detectar

---

### **MÉTODO 2: WiFi SSID / Router Detection** ⭐⭐⭐

#### Cómo funciona:
- Si tienes **múltiples Access Points** (uno por habitación)
- El celular reporta a qué AP está conectado
- Home Assistant mapea AP → Área

#### Ventajas:
✅ No requiere hardware adicional (si ya tienes APs múltiples)
✅ Automático

#### Desventajas:
❌ Requiere infraestructura WiFi compleja
❌ Precisión menor (depende de ubicación de APs)
❌ Roaming puede causar cambios tardíos
❌ Probablemente no lo tienes configurado

#### Implementación:
```yaml
# Requiere configurar en Companion App
sensor.blacky_wifi_connection
  attributes:
    ssid: "Casa_Dormitorio3"
    bssid: "AA:BB:CC:DD:EE:FF"
```

---

### **MÉTODO 3: Manual con Botones** ⭐⭐⭐⭐

#### Cómo funciona:
- Botones en el dashboard para seleccionar área manualmente
- Se guarda en un `input_select.current_area`
- El widget lee ese helper y muestra switches del área seleccionada

#### Ventajas:
✅ Sin hardware adicional
✅ Implementación inmediata
✅ Control total del usuario
✅ Funciona en cualquier dispositivo

#### Desventajas:
❌ Requiere acción manual
❌ Puedes olvidarte de cambiarlo
❌ No es "inteligente"

#### Implementación:
```yaml
# Helper
input_select:
  current_area:
    name: Área Actual
    options:
      - Dormitorio 3
      - Sala
      - Cocina
      - Baño
    icon: mdi:home-map-marker

# Dashboard muestra switches según selección
```

---

### **MÉTODO 4: Hybrid - Browser Mod + Location Services** ⭐⭐⭐⭐

#### Cómo funciona:
- **Browser Mod** puede leer información del dispositivo
- Companion App reporta ubicación GPS
- Se crea una "zona" pequeña por cada habitación
- Cuando entras en la zona, se detecta el área

#### Ventajas:
✅ No requiere beacons físicos
✅ Usa GPS del celular
✅ Relativamente automático

#### Desventajas:
❌ GPS indoor no es preciso
❌ Consume más batería
❌ Solo funciona bien en casas grandes

---

## 🎯 Recomendación para tu Caso

### **SOLUCIÓN INMEDIATA: Método 3 (Manual con Botones)**

Implementar ahora para tener funcionalidad inmediata:
- Selector de área en la parte superior del dashboard
- Muestra switches del área seleccionada dinámicamente
- Se puede mejorar después con beacons

### **SOLUCIÓN A MEDIANO PLAZO: Método 1 (BLE Beacons)**

Una vez probado el concepto, invertir en beacons:
- 1 beacon por habitación principal (≈$30-50 total)
- Configurar Companion App con BLE tracking
- Detección automática y precisa

---

## 📋 Plan de Implementación

### **FASE 1: MVP - Manual** (Ahora)

1. Crear `input_select.current_area` con tus áreas
2. Agregar selector en el dashboard
3. Usar `conditional` cards para mostrar switches según área
4. Usar `auto-entities` para cargar switches dinámicamente

**Tiempo**: 1-2 horas
**Costo**: $0
**Complejidad**: Media

### **FASE 2: BLE Beacons** (Futuro)

1. Comprar beacons (1 por habitación)
2. Configurar en Companion App
3. Crear sensores de proximidad en HA
4. Reemplazar `input_select` manual por sensor automático

**Tiempo**: 3-4 horas setup
**Costo**: $30-80 (según cantidad de beacons)
**Complejidad**: Media-Alta

---

## 💻 Diseño del Widget

### Estructura Visual:

```
┌─────────────────────────────────────────┐
│  📍 Área Actual                         │
├─────────────────────────────────────────┤
│                                         │
│  [Dormitorio 3 ▼]  <-- Selector        │
│                                         │
├─────────────────────────────────────────┤
│  Dispositivos                           │
├─────────────────────────────────────────┤
│                                         │
│  💡 Switch 1           [●────] ON       │
│  💡 Switch 2           [────○] OFF      │
│  💡 Switch 3           [●────] ON       │
│  💡 Relay Cama         [────○] OFF      │
│                                         │
└─────────────────────────────────────────┘
```

### Features:
- Selector de área (dropdown minimalista)
- Lista dinámica de switches del área seleccionada
- Estados en tiempo real
- Controles directos (toggle)
- Animaciones sutiles

---

## 🔧 Implementación Técnica - FASE 1

### 1. Crear Helper (vía UI o YAML)

```yaml
# configuration.yaml
input_select:
  dashboard_current_area:
    name: Área Actual
    options:
      - "Ninguna"
      - "Dormitorio 3"
      - "Sala"
      - "Cocina"
      - "Baño 3"
      - "Hall"
      - "Exterior"
    initial: "Ninguna"
    icon: mdi:home-map-marker
```

### 2. Widget en Dashboard

```yaml
# dashboards/maui_dashboard.yaml

# Selector de área
- type: custom:mushroom-select-card
  entity: input_select.dashboard_current_area
  name: Área Actual
  icon: mdi:map-marker-radius
  card_mod:
    style: |
      ha-card {
        background: #121212;
        border: 1px solid #2A2A2A;
      }

# Switches del área (usando auto-entities)
- type: custom:auto-entities
  card:
    type: entities
    title: Dispositivos
  filter:
    include:
      # Filtrar por área usando template
      - domain: switch
        attributes:
          area_id: >
            {% set area_map = {
              "Dormitorio 3": "bedroom_3",
              "Sala": "living_room",
              "Cocina": "kitchen"
            } %}
            {{ area_map.get(states('input_select.dashboard_current_area'), '') }}
  show_empty: true
  card_mod:
    style: |
      ha-card {
        background: #121212;
        border: 1px solid #2A2A2A;
      }
```

### 3. Si los switches NO tienen area_id

Usar listas hardcoded por área:

```yaml
# Para cada área, definir los switches
- type: conditional
  conditions:
    - entity: input_select.dashboard_current_area
      state: "Dormitorio 3"
  card:
    type: entities
    title: Dormitorio 3
    entities:
      - switch.bedroom_3_switch_switch_1
      - switch.bedroom_3_switch_switch_2
      - switch.bedroom_3_switch_switch_3
      - switch.sonoff_10025ffc47_1
```

---

## 📊 Requisitos Técnicos

### Para FASE 1 (Manual):
- ✅ Mushroom Cards (ya instalado)
- ✅ Auto-Entities (ya instalado)
- ✅ Card-Mod (ya instalado)
- ⚠️ Helper `input_select` (crear)

### Para FASE 2 (BLE Beacons):
- ⏳ Home Assistant Companion App
- ⏳ BLE Beacons físicos
- ⏳ Configuración de Bluetooth Tracking
- ⏳ ESPHome (opcional, para beacons DIY)

---

## 🎨 Integración con Tema Actual

El widget seguirá el tema Maui Dark:
- Fondo #121212
- Bordes #2A2A2A
- Texto #E5E5E5 / #A0A0A0
- Acentos #1E40AF (azul oscuro sutil)
- Minimalista y profesional

---

## 🚀 Decisión Final

### ¿Qué implementamos AHORA?

**OPCIÓN A**: MVP Manual (Fase 1)
- Selector de área manual
- Switches dinámicos por área
- Funciona inmediatamente
- Se puede mejorar después

**OPCIÓN B**: Investigar más sobre BLE primero
- Ver si ya tienes Companion App
- Evaluar inversión en beacons
- Implementar directamente la solución final

---

**¿Qué prefieres? ¿Empezamos con la OPCIÓN A (manual, funcional inmediato) o quieres invertir en beacons para hacerlo automático desde el principio?** 🎯


