# 📋 CHANGELOG - v1.3 Monitoreo Integrado

## 🎯 VERSIÓN 1.3 - Monitoreo Integrado

**Fecha**: 13 de Noviembre, 2025

### ✨ NUEVA CARACTERÍSTICA PRINCIPAL

**MONITOREO INTEGRADO** - El blueprint ahora actualiza automáticamente todos los helpers de monitoreo sin necesidad de automatizaciones externas.

---

## 🔧 CAMBIOS TÉCNICOS

### **1. Nuevo Parámetro de Configuración**

```yaml
monitoring_config:
  enable_monitoring: true  # Habilitar/deshabilitar monitoreo integrado
```

Si tienes los helpers configurados (`input_boolean.presence_simulation_running`, etc.), déjalo en `true`.
Si no los tienes, ponlo en `false` y el blueprint funcionará igual.

---

### **2. Helpers Actualizados Automáticamente**

El blueprint ahora actualiza estos helpers en tiempo real:

#### **Al Iniciar:**
- `input_boolean.presence_simulation_running` → `on`
- `input_datetime.presence_simulation_start_time` → Timestamp actual
- `input_number.presence_simulation_loop_total` → Total de loops configurados
- `input_number.presence_simulation_loop_counter` → 0 (reseteo)
- `input_text.presence_simulation_status` → "Iniciando"

#### **Durante la Ejecución:**
- `input_number.presence_simulation_loop_counter` → Loop actual
- `input_text.presence_simulation_status` → "En ejecución - Loop N"
- `input_number.presence_simulation_lights_on_count` → **Número de luces encendidas**
- `input_text.presence_simulation_active_lights` → **Lista de nombres de luces activas**
- `input_text.presence_simulation_last_light_on` → **Última luz encendida**
- `input_text.presence_simulation_last_light_off` → **Última luz apagada**

#### **Al Finalizar:**
- `input_boolean.presence_simulation_running` → `off`
- `input_text.presence_simulation_status` → "Finalizada"
- `input_number.presence_simulation_lights_on_count` → 0
- `input_text.presence_simulation_active_lights` → "Ninguna"

---

### **3. Actualizaciones en Tiempo Real**

El blueprint actualiza los contadores en **3 momentos clave**:

#### **a) Al encender una luz:**
```yaml
# 1. Actualiza última luz encendida
input_text.presence_simulation_last_light_on

# 2. Agrega a la lista interna
lights_currently_on += [luz_actual]

# 3. Actualiza contador y lista de nombres
input_number.presence_simulation_lights_on_count = len(lights_currently_on)
input_text.presence_simulation_active_lights = "Luz 1, Luz 2, ..."
```

#### **b) Al apagar una luz:**
```yaml
# 1. Actualiza última luz apagada
input_text.presence_simulation_last_light_off

# 2. Remueve de la lista interna
lights_currently_on -= [luz_actual]

# 3. Actualiza contador y lista
input_number.presence_simulation_lights_on_count = len(lights_currently_on)
input_text.presence_simulation_active_lights = "Luz 1, ..." (o "Ninguna")
```

#### **c) Al hacer cleanup:**
```yaml
# Después de apagar todas las luces al final del loop
input_number.presence_simulation_lights_on_count = 0
input_text.presence_simulation_active_lights = "Ninguna"
```

---

## 🚀 MEJORAS

### **1. Sin Automatizaciones Externas**

**ANTES (v1.2):**
```
Blueprint v1.2
   ↓
Enciende/apaga luces ✓
   ↓
❌ No actualiza contadores
   ↓
Necesitas 2 automatizaciones externas
   ↓
Automatizaciones monitorean switches
   ↓
Actualizan contadores (con delay de hasta 10s)
```

**AHORA (v1.3):**
```
Blueprint v1.3
   ↓
Enciende/apaga luces ✓
   ↓
✅ Actualiza contadores INMEDIATAMENTE
   ↓
Dashboard muestra datos en tiempo real
```

---

### **2. Sincronización Perfecta**

- **Sin retrasos**: Los contadores se actualizan en el mismo momento que se enciende/apaga la luz
- **Sin discrepancias**: El contador siempre refleja el estado real
- **Sin automatizaciones externas**: Un archivo menos para mantener

---

### **3. Retrocompatibilidad**

El blueprint v1.3 es **100% compatible** con configuraciones existentes:

```yaml
# Si NO tienes los helpers de monitoreo
use_blueprint:
  path: mauitz/pezaustral_presence_simulation_v1.3.yaml
  input:
    enable_monitoring: false  # ← Desactiva el monitoreo
    # ... resto de la configuración igual
```

```yaml
# Si SÍ tienes los helpers de monitoreo (recomendado)
use_blueprint:
  path: mauitz/pezaustral_presence_simulation_v1.3.yaml
  input:
    enable_monitoring: true   # ← Activa el monitoreo (default)
    # ... resto de la configuración igual
```

---

## 📦 ARCHIVOS MODIFICADOS

| Archivo | Cambio |
|---------|--------|
| `blueprints/pezaustral_presence_simulation_v1.3.yaml` | **NUEVO** - Blueprint con monitoreo integrado |
| `blueprints/pezaustral_presence_simulation.yaml` | Sin cambios (v1.2 sigue disponible) |
| `examples/presence_simulation_monitoring.yaml` | **OBSOLETO** - Ya no se necesita |

---

## 🔄 MIGRACIÓN DESDE v1.2

### **Opción 1: Actualización Simple (Recomendada)**

1. Ve a Home Assistant → Configuración → Automatizaciones
2. Edita tu automatización "Presence Simulation"
3. Cambia el blueprint:
   ```yaml
   # ANTES:
   use_blueprint:
     path: mauitz/pezaustral_presence_simulation.yaml  # v1.2
   
   # DESPUÉS:
   use_blueprint:
     path: mauitz/pezaustral_presence_simulation_v1.3.yaml  # v1.3
   ```
4. Agrega (opcional, pero recomendado):
   ```yaml
   input:
     enable_monitoring: true
     # ... resto de inputs igual
   ```
5. Guarda

### **Opción 2: Limpieza Completa**

Si tenías las automatizaciones de monitoreo externas instaladas:

1. **ELIMINA** las automatizaciones:
   - "Presence Sim - Monitorear Switches"
   - "Presence Sim - Actualizar Contador"
   
2. Actualiza el blueprint como en Opción 1

3. Verifica que `enable_monitoring: true`

---

## ✅ VERIFICACIÓN POST-MIGRACIÓN

Después de actualizar a v1.3, verifica:

1. **Inicia la simulación** (activa `input_boolean.presence_simulation`)

2. **Verifica en Developer Tools → States**:
   ```
   input_boolean.presence_simulation_running → on
   input_number.presence_simulation_lights_on_count → 1, 2, etc (se actualiza)
   input_text.presence_simulation_active_lights → "Luz 1, Luz 2, ..." (se actualiza)
   input_text.presence_simulation_last_light_on → Nombre de la última luz
   ```

3. **Verifica el dashboard**: El contador de "Luces ON" debe actualizarse en tiempo real

---

## 🐛 TROUBLESHOOTING

### **Problema: Los contadores no se actualizan**

**Causa**: `enable_monitoring` está en `false` o los helpers no existen

**Solución**:
1. Verifica que `enable_monitoring: true` en la configuración del blueprint
2. Verifica que los helpers existen en `configuration.yaml`
3. Recarga Home Assistant: Developer Tools → YAML → Reload Template Entities

---

### **Problema: Error "entity not found"**

**Causa**: Faltan helpers en `configuration.yaml`

**Solución**:
1. Agrega los helpers faltantes (ver `examples/presence_simulation_helpers.yaml`)
2. Recarga Home Assistant
3. O desactiva el monitoreo: `enable_monitoring: false`

---

## 📊 COMPARACIÓN DE VERSIONES

| Característica | v1.2 | v1.3 |
|----------------|------|------|
| Enciende/apaga luces | ✅ | ✅ |
| Control de max luces simultáneas | ✅ | ✅ |
| Loops configurables | ✅ | ✅ |
| Logging detallado | ✅ | ✅ |
| Escena de salida | ✅ | ✅ |
| **Monitoreo integrado** | ❌ | ✅ |
| **Actualización en tiempo real** | ❌ | ✅ |
| **Sin automatizaciones externas** | ❌ | ✅ |
| Requiere automatizaciones de monitoreo | ✅ (2) | ❌ (0) |

---

## 🎯 CONCLUSIÓN

La versión 1.3 **elimina la necesidad de automatizaciones externas** y proporciona **monitoreo en tiempo real** integrado directamente en el blueprint.

**Resultado**: Sistema más limpio, más rápido, más fácil de mantener.

---

## 🔗 REFERENCIAS

- Blueprint v1.3: `blueprints/pezaustral_presence_simulation_v1.3.yaml`
- Blueprint v1.2: `blueprints/pezaustral_presence_simulation.yaml`
- Helpers: `examples/presence_simulation_helpers.yaml`
- Documentación: `docs/pezaustral_presence_simulation/README.md`

