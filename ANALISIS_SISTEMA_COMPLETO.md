# 🔍 ANÁLISIS COMPLETO DEL SISTEMA DE PRESENCIA

## 📊 ESTADO ACTUAL (Según HA_config_proxy)

### ✅ LO QUE FUNCIONA

1. **Blueprint instalado**: `pezaustral_presence_simulation.yaml` v1.2 con logging
2. **Automatización activa**: "Presence Simulation" (id: 1762643232609)
3. **Helpers creados**: Todos los `input_boolean`, `input_number`, `input_text`, `input_datetime` existen en `configuration.yaml`
4. **Template sensors**: 4 sensores (`Runtime`, `Progress`, `Active Lights List`, `Time Remaining`)
5. **Luces se encienden/apagan**: ✅ Confirmado por logs y dashboard

### ❌ LO QUE NO FUNCIONA

**El contador de "Luces ON" no se actualiza**

**CAUSA RAÍZ**: El blueprint **NO actualiza** estos helpers:
- `input_number.presence_simulation_lights_on_count` ❌
- `input_text.presence_simulation_active_lights` ❌
- `input_text.presence_simulation_last_light_on` ❌ 
- `input_text.presence_simulation_last_light_off` ❌

**El blueprint solo actualiza**:
- `input_number.presence_simulation_loop_counter` ✅
- `input_text.presence_simulation_status` ✅

---

## 🏗️ ARQUITECTURA ACTUAL (Fragmentada)

```
┌─────────────────────────────────────────────────────────┐
│  INPUT_BOOLEAN.PRESENCE_SIMULATION                      │
│  (Switch de control)                                    │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│  BLUEPRINT: pezaustral_presence_simulation              │
│  ┌───────────────────────────────────────────────────┐  │
│  │ • Enciende/apaga switches                         │  │
│  │ • Controla max luces simultáneas                  │  │
│  │ • Maneja loops                                    │  │
│  │ • Genera logs detallados                          │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
│  ACTUALIZA:                                             │
│    ✅ input_number.loop_counter                         │
│    ✅ input_text.status                                 │
│    ❌ lights_on_count (NO actualiza)                    │
│    ❌ active_lights (NO actualiza)                      │
│    ❌ last_light_on/off (NO actualiza)                  │
└─────────────────────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│  SWITCHES (6 unidades)                                  │
│  • Cambian de estado ON/OFF                             │
│  • NO hay automatizaciones monitoreándolos              │
└─────────────────────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│  DASHBOARD / TEMPLATE SENSORS                           │
│  • Leen input_number.lights_on_count                    │
│  • Leen input_text.active_lights                        │
│  • ⚠️ NUNCA SE ACTUALIZAN                               │
└─────────────────────────────────────────────────────────┘
```

---

## 🚨 PROBLEMA: Brecha de Información

**Hay una BRECHA** entre el blueprint y el monitoreo:

1. Blueprint **controla** switches ✅
2. Blueprint **NO monitorea** cuántos están encendidos ❌
3. Dashboard **espera** que alguien actualice los helpers ⏳
4. **Nadie actualiza los helpers** 💥

---

## 💡 SOLUCIONES POSIBLES

### **SOLUCIÓN 1: Integrar Monitoreo en el Blueprint** ⭐ RECOMENDADA

**Concepto**: El blueprint actualiza TODOS los helpers directamente.

**Ventajas**:
- ✅ Todo en un solo lugar
- ✅ No requiere automatizaciones externas
- ✅ Más fácil de mantener
- ✅ Menos archivos para instalar

**Desventajas**:
- ⚠️ Blueprint más complejo
- ⚠️ Requiere actualizar blueprint en HA

**Cambios necesarios**:
```yaml
# En el blueprint, después de encender/apagar cada switch:

# Actualizar última luz encendida
- service: input_text.set_value
  target:
    entity_id: input_text.presence_simulation_last_light_on
  data:
    value: "{{ nombre_del_switch }}"

# Contar luces encendidas
- service: input_number.set_value
  target:
    entity_id: input_number.presence_simulation_lights_on_count
  data:
    value: "{{ lights_currently_on | length }}"

# Actualizar lista
- service: input_text.set_value
  target:
    entity_id: input_text.presence_simulation_active_lights
  data:
    value: "{{ lights_currently_on | join(', ') }}"
```

---

### **SOLUCIÓN 2: Automatizaciones de Monitoreo Externas** (Estado Actual)

**Concepto**: 2 automatizaciones escuchan cambios en switches.

**Ventajas**:
- ✅ Blueprint no se modifica
- ✅ Fácil de instalar/desinstalar

**Desventajas**:
- ❌ Requiere instalar 2 automatizaciones adicionales
- ❌ Más archivos para mantener
- ❌ Puede haber retrasos (10 segundos)

**Estado**: Ya está en `examples/presence_simulation_monitoring.yaml` pero NO instalado en HA.

---

### **SOLUCIÓN 3: API de Home Assistant** ⭐ PARA GESTIÓN

**Concepto**: Usar REST API para instalar/configurar todo programáticamente.

**Uso**: No para monitoreo, sino para:
- Ver qué está instalado
- Instalar automatizaciones automáticamente
- Verificar estado del sistema

**API Endpoint**: `http://192.168.1.100:8123/api/`

**Necesita**: Token de acceso de larga duración

---

## 🎯 RECOMENDACIÓN FINAL

### **Plan de Acción:**

1. **CORTO PLAZO (10 minutos)**: Instalar las 2 automatizaciones de monitoreo
   - Soluciona el problema inmediatamente
   - No requiere modificar blueprint
   
2. **MEDIANO PLAZO (1 hora)**: Refactorizar blueprint con monitoreo integrado
   - Eliminar dependencia de automatizaciones externas
   - Simplificar arquitectura

3. **LARGO PLAZO**: Herramienta de gestión con API
   - Script de instalación automática
   - Verificación de estado del sistema

---

## 🔧 PARA ACCEDER A HOME ASSISTANT

### **Opción 1: REST API** (Recomendada)

```bash
# 1. Crear token de acceso
# Settings → Profile → Long-Lived Access Tokens

# 2. Usar curl para consultar
curl -H "Authorization: Bearer YOUR_TOKEN" \
     -H "Content-Type: application/json" \
     http://192.168.1.100:8123/api/states
```

### **Opción 2: SSH**

```bash
ssh user@192.168.1.100
cd /config
nano automations.yaml
```

### **Opción 3: File Editor en HA**

Settings → Add-ons → File Editor

---

## ❓ PREGUNTA PARA TI

**¿Qué prefieres?**

**A)** Instalar las 2 automatizaciones ahora (rápido, pero más archivos)

**B)** Refactorizar el blueprint con monitoreo integrado (más limpio, toma más tiempo)

**C)** Configurar acceso API para gestión automática (más profesional)

**D)** Combinación: (A) ahora + (B) después + (C) para mantenimiento


