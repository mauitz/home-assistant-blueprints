# Blueprint: SmartNode Presence Lighting

## 📝 Descripción

Blueprint para automatizar la iluminación basándose en presencia detectada por SmartNodes (con sensor LD2410) y luminosidad ambiente.

## ✨ Características

- ✅ **Respuesta rápida**: Enciende la luz inmediatamente al detectar presencia
- ✅ **Inteligente**: Solo actúa cuando está oscuro (configurable)
- ✅ **Configurable**: Ajusta delays, umbrales y niveles de brillo
- ✅ **Reutilizable**: Mismo blueprint para todas las habitaciones
- ✅ **Soporte dimmer**: Compatible con switches simples y luces con dimmer
- ✅ **Anulación manual**: Respeta encendido/apagado manual

## 🎯 Requisitos

- **SmartNode** con sensor LD2410 configurado
- **Sensor de presencia** (binary_sensor)
- **Sensor de luminosidad** (sensor en %)
- **Switch o luz** a controlar

## 🚀 Instalación Rápida

### Opción 1: Script Automático
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
./utils/install_smartnode_blueprint.sh
```

### Opción 2: Manual
1. Copiar `blueprints/smartnode_presence_lighting.yaml` a:
   ```
   HA_config_proxy/blueprints/automation/mauitz/
   ```

2. En Home Assistant:
   - **Configuración** → **YAML** → **Recargar automatizaciones**

3. Crear automatización desde el blueprint

## ⚙️ Configuración Básica

### Parámetros Esenciales

| Parámetro | Descripción | Ejemplo |
|-----------|-------------|---------|
| **Sensor de Presencia** | Binary sensor del SmartNode | `binary_sensor.presence` |
| **Sensor de Luminosidad** | Sensor de luz ambiente (%) | `sensor.room_brightness` |
| **Luz o Switch** | Dispositivo a controlar | `switch.bedroom_3_switch_switch_1` |
| **Umbral de Oscuridad** | % por debajo se considera oscuro | `30%` |
| **Delay al Apagar** | Segundos sin presencia para apagar | `5s` |

### Configuraciones Recomendadas por Habitación

#### 🛏️ Dormitorio
```yaml
brightness_threshold: 30%
turn_on_delay: 0s
turn_off_delay: 5s
brightness_level: 80%
```

#### 🚿 Baño
```yaml
brightness_threshold: 20%
turn_on_delay: 0s
turn_off_delay: 3s
brightness_level: 100%
```

#### 🚪 Pasillo
```yaml
brightness_threshold: 40%
turn_on_delay: 0s
turn_off_delay: 5s
brightness_level: 60%
```

#### 🍳 Cocina
```yaml
brightness_threshold: 25%
turn_on_delay: 1s
turn_off_delay: 10s
brightness_level: 90%
```

## 📋 Ejemplo de Uso

```yaml
- id: 'bedroom_auto_light'
  alias: Dormitorio - Luz Automática
  use_blueprint:
    path: mauitz/smartnode_presence_lighting.yaml
    input:
      presence_sensor: binary_sensor.presence
      brightness_sensor: sensor.room_brightness
      light_entity: switch.bedroom_3_switch_switch_1
      brightness_threshold: 30
      turn_off_delay: 5
      brightness_level: 80
```

## 🔧 Parámetros Avanzados

### Delays
- **turn_on_delay**: Espera antes de encender (evita falsos positivos)
- **turn_off_delay**: Espera después de perder presencia para apagar

### Opciones
- **enable_manual_override**: Respeta control manual del usuario
- **enable_notifications**: Notificaciones para debug
- **transition_time**: Tiempo de transición suave (segundos)

## 🧪 Testing

### Test 1: Encendido Automático ✅
1. Habitación oscura (< 30%)
2. Luz apagada
3. Entrar → **Luz se enciende**

### Test 2: No Encender con Luz Natural ✅
1. Habitación con luz (> 30%)
2. Luz apagada
3. Entrar → **Luz NO se enciende**

### Test 3: Apagado Automático ✅
1. Luz encendida
2. Salir de habitación
3. Después de 5s → **Luz se apaga**

### Test 4: Anulación Manual ✅
1. Encender luz manualmente
2. Sistema respeta estado manual
3. No interfiere

## 🐛 Troubleshooting

### La luz no enciende
- ✅ Verificar que `brightness_threshold` no sea muy bajo
- ✅ Confirmar nombres de entidades correctos
- ✅ Activar notificaciones para debug

### La luz parpadea
- ✅ Aumentar `turn_on_delay` a 1-2 segundos
- ✅ Verificar que no haya automatizaciones conflictivas
- ✅ Calibrar sensibilidad del LD2410

### Se apaga demasiado rápido
- ✅ Aumentar `turn_off_delay`
- ✅ Ajustar timeout del LD2410 en ESPHome

## 📚 Documentación

- **Guía completa de migración**: `docs/automatizaciones/MIGRACION_SMARTNODE_LIGHTING.md`
- **Ejemplo configurado**: `examples/automatizaciones/bedroom_smartnode_lighting.yaml`
- **SmartNode hardware**: `docs/smart_nodes/prototype/device.yaml`

## 🔗 Referencias

- [ESPHome LD2410](https://esphome.io/components/sensor/ld2410.html)
- [Home Assistant Blueprints](https://www.home-assistant.io/docs/automation/using_blueprints/)

## 📝 Changelog

### v1.0 (Diciembre 2025)
- ✨ Versión inicial
- ✅ Soporte para switches y dimmers
- ✅ Detección de luminosidad
- ✅ Delays configurables
- ✅ Anulación manual
- ✅ Notificaciones opcionales

---

**Autor**: mauitz
**Licencia**: MIT
**Compatible con**: Home Assistant 2025.x



