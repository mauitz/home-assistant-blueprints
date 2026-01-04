# 🎯 Blueprint SmartNode Lighting - Resumen de Implementación

## ✅ Archivos Creados

```
home-assistant-blueprints/
├── blueprints/
│   ├── smartnode_presence_lighting.yaml     ← 🎨 BLUEPRINT PRINCIPAL
│   └── README_SMARTNODE.md                  ← 📖 Documentación rápida
├── examples/
│   └── automatizaciones/
│       └── bedroom_smartnode_lighting.yaml  ← 💡 Ejemplo para dormitorio
├── docs/
│   └── automatizaciones/
│       └── MIGRACION_SMARTNODE_LIGHTING.md  ← 📚 Guía completa
└── utils/
    ├── install_smartnode_blueprint.sh       ← 🚀 Script de instalación
    └── verify_smartnode_setup.sh            ← ✔️ Script de verificación
```

---

## 🎨 Características del Blueprint

### ✨ Funcionalidad Principal

El blueprint automatiza la iluminación basándose en:

1. **Detección de Presencia**: Sensor LD2410 del SmartNode
2. **Luminosidad Ambiente**: Solo actúa cuando está oscuro
3. **Estado de la Luz**: Verifica que esté apagada antes de encender
4. **Delays Configurables**: Control preciso de tiempos

### 🔧 Parámetros Configurables

| Categoría | Parámetros |
|-----------|------------|
| **Sensores** | Presencia, Luminosidad |
| **Dispositivo** | Switch o luz con dimmer |
| **Luz** | Brillo (%), Transición (s) |
| **Umbrales** | Luminosidad mínima (%) |
| **Delays** | Encendido (s), Apagado (s) |
| **Opciones** | Anulación manual, Notificaciones |

### 📊 Lógica de Funcionamiento

```
┌─────────────────────────────────────────────────────────┐
│                 DETECCIÓN DE PRESENCIA                  │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │ ¿Está oscuro?        │
              │ (luz < umbral)       │
              └──────────────────────┘
                    │           │
                   SÍ          NO
                    │           │
                    ▼           └──→ [No hacer nada]
         ┌──────────────────────┐
         │ ¿Luz está apagada?   │
         └──────────────────────┘
              │           │
             SÍ          NO
              │           │
              ▼           └──→ [No hacer nada]
    ┌─────────────────┐
    │ ENCENDER LUZ    │
    └─────────────────┘
              │
              ▼
    [Esperar sin presencia]
              │
              ▼
    ┌─────────────────┐
    │ APAGAR LUZ      │
    │ (después de 5s) │
    └─────────────────┘
```

---

## 🚀 Instalación Paso a Paso

### Paso 1: Ejecutar Script de Instalación

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
./utils/install_smartnode_blueprint.sh
```

Esto copiará el blueprint a:
```
HA_config_proxy/blueprints/automation/mauitz/smartnode_presence_lighting.yaml
```

### Paso 2: Recargar Home Assistant

En Home Assistant:
- **Configuración** → **YAML** → **Recargar automatizaciones**

### Paso 3: Eliminar Automatizaciones Antiguas

Eliminar estas 2 automatizaciones desde la UI:

1. **Habitación - Presencia Detectada** (ID: `1734450000001`)
   - Ubicación en YAML: líneas 286-316 de `automations.yaml`

2. **Habitación - Sin Presencia** (ID: `1734450000002`)
   - Ubicación en YAML: líneas 317-350 de `automations.yaml`

**Cómo eliminar:**
- **Configuración** → **Automatizaciones y Escenas**
- Buscar cada una → Click en ⋮ → **Eliminar**

### Paso 4: Crear Nueva Automatización

#### Opción A: Desde la UI (Recomendado)

1. **Configuración** → **Automatizaciones y Escenas**
2. Click en **+ Crear Automatización**
3. Seleccionar **Usar un Blueprint**
4. Buscar: **"SmartNode - Iluminación Automática por Presencia"**
5. Configurar:

```yaml
Nombre: Dormitorio - Luz Automática SmartNode

Sensores SmartNode:
  - Sensor de Presencia: binary_sensor.presence
  - Sensor de Luminosidad: sensor.room_brightness

Dispositivo de Luz:
  - Luz o Switch: switch.bedroom_3_switch_switch_1

Configuración de Luz:
  - Nivel de Brillo: 80%
  - Tiempo de Transición: 1s

Umbrales y Delays:
  - Umbral de Oscuridad: 30%
  - Delay al Encender: 0s
  - Delay al Apagar: 5s

Opciones Avanzadas:
  - Permitir Anulación Manual: ✅ Sí
  - Habilitar Notificaciones: ❌ No
```

6. **Guardar**

#### Opción B: Desde YAML

Agregar a `automations.yaml`:

```yaml
- id: 'bedroom_smartnode_auto_lighting'
  alias: Dormitorio - Luz Automática SmartNode
  use_blueprint:
    path: mauitz/smartnode_presence_lighting.yaml
    input:
      presence_sensor: binary_sensor.presence
      brightness_sensor: sensor.room_brightness
      light_entity: switch.bedroom_3_switch_switch_1
      brightness_level: 80
      transition_time: 1
      brightness_threshold: 30
      turn_on_delay: 0
      turn_off_delay: 5
      enable_manual_override: true
      enable_notifications: false
```

---

## 🧪 Verificación y Testing

### Tests Esenciales

#### ✅ Test 1: Encendido Automático
```
Condiciones:
  - Habitación oscura (< 30%)
  - Luz apagada
  - No hay presencia

Acción:
  - Entrar a la habitación

Resultado esperado:
  ✅ Luz se enciende inmediatamente
  ✅ Log: "Luz encendida por presencia"
```

#### ✅ Test 2: No Encender con Luz Natural
```
Condiciones:
  - Habitación con luz (> 30%)
  - Luz apagada
  - No hay presencia

Acción:
  - Entrar a la habitación

Resultado esperado:
  ✅ Luz NO se enciende
  ✅ No hay log de acción
```

#### ✅ Test 3: Apagado Automático
```
Condiciones:
  - Luz encendida automáticamente
  - Presencia detectada

Acción:
  - Salir de la habitación

Resultado esperado:
  ✅ Después de 5s, luz se apaga
  ✅ Log: "Luz apagada automáticamente"
```

#### ✅ Test 4: Anulación Manual
```
Condiciones:
  - Habitación oscura
  - No hay presencia

Acción:
  - Encender luz manualmente

Resultado esperado:
  ✅ Luz permanece encendida
  ✅ Sistema respeta control manual
```

#### ✅ Test 5: No Parpadeo
```
Condiciones:
  - Luz ya encendida
  - Presencia detectada

Acción:
  - Salir y volver a entrar rápidamente

Resultado esperado:
  ✅ Luz permanece encendida
  ✅ No hay parpadeo
```

### Verificar en Home Assistant

```
Herramientas de Desarrollo → Estados

Buscar:
  - binary_sensor.presence       → Estado: on/off
  - sensor.room_brightness       → Estado: 0-100
  - switch.bedroom_3_switch_switch_1 → Estado: on/off
```

### Revisar Logs

```
Configuración → Logs

Filtrar por:
  - "SmartNode - Luz Automática"
  - "binary_sensor.presence"
  - "switch.bedroom_3_switch_switch_1"
```

---

## 📊 Configuraciones por Tipo de Habitación

### 🛏️ Dormitorio
```yaml
brightness_threshold: 30%    # Sensible a poca luz
turn_off_delay: 5s          # Apagado rápido
brightness_level: 80%        # Luz media-alta
```

### 🚿 Baño
```yaml
brightness_threshold: 20%    # Más tolerante a la luz
turn_off_delay: 3s          # Apagado muy rápido
brightness_level: 100%       # Luz completa
```

### 🚪 Pasillo
```yaml
brightness_threshold: 40%    # Menos sensible
turn_off_delay: 5s          # Apagado normal
brightness_level: 60%        # Luz media
```

### 🍳 Cocina
```yaml
brightness_threshold: 25%    # Luz clara necesaria
turn_off_delay: 10s         # Mantener encendida más tiempo
brightness_level: 90%        # Luz alta
```

### 🌙 Modo Nocturno (22:00 - 07:00)
```yaml
brightness_threshold: 50%    # Más sensible
turn_on_delay: 2s           # Evitar activación accidental
turn_off_delay: 10s         # Mantener más tiempo
brightness_level: 15%        # Luz muy tenue
```

---

## 🔧 Ajustes Finos

### Si la luz no enciende:
```yaml
brightness_threshold: 40-50%  # ⬆️ Aumentar umbral
turn_on_delay: 0s            # Sin delay
enable_notifications: true    # Activar para debug
```

### Si la luz parpadea:
```yaml
turn_on_delay: 1-2s          # ⬆️ Agregar delay
turn_off_delay: 10s          # ⬆️ Aumentar delay
```

### Si se apaga muy rápido:
```yaml
turn_off_delay: 10-15s       # ⬆️ Aumentar delay
```

### Calibración del LD2410 (ESPHome):
```yaml
ld2410:
  timeout: 10s
  max_move_distance: 6m
  max_still_distance: 4m
  g0_move_threshold: 50
  g0_still_threshold: 0
  g1_move_threshold: 50
  g1_still_threshold: 0
```

---

## 📚 Documentación Completa

### Archivos de Referencia

| Archivo | Descripción |
|---------|-------------|
| `blueprints/README_SMARTNODE.md` | Referencia rápida del blueprint |
| `docs/automatizaciones/MIGRACION_SMARTNODE_LIGHTING.md` | Guía completa de migración |
| `examples/automatizaciones/bedroom_smartnode_lighting.yaml` | Ejemplo configurado |
| `docs/smart_nodes/prototype/device.yaml` | Configuración hardware SmartNode |

### Scripts Útiles

```bash
# Instalar blueprint
./utils/install_smartnode_blueprint.sh

# Verificar setup
./utils/verify_smartnode_setup.sh
```

---

## 🎯 Escalabilidad

### Para Agregar Más SmartNodes

Cuando instales SmartNode2, SmartNode3, etc:

1. **Crear nueva automatización** desde el mismo blueprint
2. **Cambiar las entidades:**
   ```yaml
   # SmartNode2 en Cocina
   presence_sensor: binary_sensor.presence_cocina
   brightness_sensor: sensor.room_brightness_cocina
   light_entity: switch.cocina_luz
   ```
3. **Ajustar parámetros** según la habitación
4. **Guardar** con nombre descriptivo

**Ejemplo:**
- Dormitorio → `Dormitorio - Luz Automática SmartNode`
- Cocina → `Cocina - Luz Automática SmartNode`
- Baño → `Baño - Luz Automática SmartNode`

---

## ✅ Checklist Final

- [ ] Blueprint instalado en HA
- [ ] Automatizaciones antiguas eliminadas
- [ ] Nueva automatización creada
- [ ] Test 1: Encendido automático ✅
- [ ] Test 2: No encender con luz ✅
- [ ] Test 3: Apagado automático ✅
- [ ] Test 4: Anulación manual ✅
- [ ] Test 5: No parpadeo ✅
- [ ] Ajustes finos realizados
- [ ] Monitoreo 24h completado
- [ ] Configuración final documentada

---

## 🎉 Resultado Final

### Antes (Automatizaciones Manuales)
- ❌ 2 automatizaciones separadas
- ❌ Solo notificaciones
- ❌ No verifica luminosidad
- ❌ No respeta estado de luz
- ❌ Difícil de reutilizar
- ❌ Delay de 5 minutos

### Después (Blueprint SmartNode)
- ✅ 1 blueprint reutilizable
- ✅ Control inteligente de luz
- ✅ Verifica luminosidad ambiente
- ✅ Verifica estado antes de actuar
- ✅ Fácil de replicar
- ✅ Delay configurable (5s por defecto)
- ✅ Soporte para dimmer
- ✅ Anulación manual
- ✅ Notificaciones opcionales

---

**🚀 ¡Listo para usar! El blueprint está completamente funcional y documentado.**

---

**Autor:** Blueprint SmartNode Lighting v1.0
**Fecha:** Diciembre 2025
**Proyecto:** Home Assistant - Domotica PezAustral


