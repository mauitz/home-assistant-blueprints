# 📡 Plantilla de Información de Beacons

## 📋 Instrucciones

Para cada beacon que instales, completa la siguiente información. Puedes obtenerla desde la Home Assistant Companion App.

---

## 🏠 BEACON 1 - Dormitorio 3

```yaml
nombre_habitacion: "Dormitorio 3"
area_id: "bedroom_3"

# Información del Beacon (obtener de Companion App)
uuid: ""                    # UUID del beacon (formato: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX)
major: ""                   # Major ID (número)
minor: ""                   # Minor ID (número)

# Información de instalación
ubicacion_fisica: ""        # Ej: "Mesa de noche derecha"
altura_instalacion: ""      # Ej: "1.2m"
fecha_instalacion: ""       # Ej: "2024-11-14"

# Switches asociados a esta área
switches:
  - switch.bedroom_3_switch_switch_1
  - switch.bedroom_3_switch_switch_2
  - switch.bedroom_3_switch_switch_3
  - switch.sonoff_10025ffc47_1

# Notas
notas: ""                   # Observaciones especiales
```

---

## 🛋️ BEACON 2 - Sala

```yaml
nombre_habitacion: "Sala"
area_id: "living_room"

uuid: ""
major: ""
minor: ""

ubicacion_fisica: ""
altura_instalacion: ""
fecha_instalacion: ""

switches:
  - switch.4gang_switch_switch_1
  - switch.4gang_switch_switch_2

notas: ""
```

---

## 🍳 BEACON 3 - Cocina

```yaml
nombre_habitacion: "Cocina"
area_id: "kitchen"

uuid: ""
major: ""
minor: ""

ubicacion_fisica: ""
altura_instalacion: ""
fecha_instalacion: ""

switches:
  - switch.3gang_switch_switch_1
  - switch.3gang_switch_switch_2

notas: ""
```

---

## 🚿 BEACON 4 - Baño 3

```yaml
nombre_habitacion: "Baño 3"
area_id: "bathroom_3"

uuid: ""
major: ""
minor: ""

ubicacion_fisica: ""
altura_instalacion: ""
fecha_instalacion: ""

switches:
  - switch.3gang_switch_switch_3

notas: ""
```

---

## 🚪 BEACON 5 - Hall

```yaml
nombre_habitacion: "Hall"
area_id: "hall"

uuid: ""
major: ""
minor: ""

ubicacion_fisica: ""
altura_instalacion: ""
fecha_instalacion: ""

switches:
  - switch.4gang_switch_2_switch_1
  - switch.4gang_switch_2_switch_2

notas: ""
```

---

## 🌳 BEACON 6 - Exterior

```yaml
nombre_habitacion: "Exterior"
area_id: "exterior"

uuid: ""
major: ""
minor: ""

ubicacion_fisica: ""
altura_instalacion: ""
fecha_instalacion: ""

switches:
  - switch.tapo_c310_exterior

notas: ""
```

---

## 📱 Cómo Obtener la Información del Beacon

### Desde Home Assistant Companion App:

1. Abrir **Home Assistant Companion App**
2. Ir a **Configuración** → **Companion App**
3. Ir a **Sensores**
4. Buscar **"BLE Transmitters"** o **"iBeacons"**
5. Verás la lista de beacons detectados con su información:
   - UUID
   - Major
   - Minor
   - RSSI (intensidad de señal)

### Ejemplo de cómo se ve:

```
iBeacon Detected:
  UUID: FDA50693-A4E2-4FB1-AFCF-C6EB07647825
  Major: 10001
  Minor: 20001
  RSSI: -65 dBm
```

---

## 🔧 Testing de Señal

Para cada beacon, anota la intensidad de señal (RSSI) en diferentes puntos:

### Beacon Dormitorio 3:
- Centro de la habitación: ______ dBm
- Entrada de la habitación: ______ dBm
- Desde pasillo: ______ dBm
- Desde habitación contigua: ______ dBm

### Beacon Sala:
- Centro de la habitación: ______ dBm
- Entrada de la habitación: ______ dBm
- Desde pasillo: ______ dBm
- Desde habitación contigua: ______ dBm

*(Repetir para cada beacon)*

---

## ✅ Checklist de Instalación

### Por cada beacon:
- [ ] Beacon físicamente instalado
- [ ] UUID anotado
- [ ] Major ID anotado
- [ ] Minor ID anotado
- [ ] Ubicación física documentada
- [ ] Altura de instalación medida
- [ ] Switches del área identificados
- [ ] Testing de señal completado
- [ ] Detectado en Companion App

---

## 📤 Envío de Información

Una vez completes esta información, envíala completa para proceder con la configuración en Home Assistant.

**Formato sugerido de envío:**
```
Beacon 1 - Dormitorio 3
UUID: FDA50693-A4E2-4FB1-AFCF-C6EB07647825
Major: 10001
Minor: 20001
Ubicación: Mesa de noche derecha, 1.2m altura

Beacon 2 - Sala
UUID: ...
...
```


