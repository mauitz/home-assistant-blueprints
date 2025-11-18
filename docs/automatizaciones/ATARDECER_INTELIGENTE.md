# 🌅 Automatización de Atardecer Inteligente

## 📋 Descripción

Sistema de 2 automatizaciones que gestionan inteligentemente la casa al atardecer y cuando regresas a casa.

---

## 🎯 Funcionalidad

### **1. Atardecer Inteligente** (`atardecer_inteligente.yaml`)

**Trigger**: 30 minutos después del ocaso

**Comportamiento**:
1. ✅ Activa escena `scene.anochecer`
2. 🔍 Verifica si Nico está en casa (>100m = fuera)
3. **Si NO está en casa**:
   - ✅ Activa `input_boolean.presence_simulation`
   - 📱 Notifica: "Simulación activada"
   - 📊 Log en Logbook
4. **Si está en casa**:
   - 📊 Solo log (sin notificación)

---

### **2. Regreso a Casa** (`regreso_casa_desactivar_simulacion.yaml`)

**Trigger**: Nico entra en `zone.home`

**Comportamiento**:
1. ✅ Solo si `input_boolean.presence_simulation` está ON
2. 🛑 Desactiva simulación de presencia
3. 🏠 Activa escena `scene.bedtime`
4. 📱 Notifica: "Bienvenido a casa"
5. 📊 Log en Logbook

---

## 📥 Instalación

### **Paso 1: Copiar Automatizaciones**

1. Abre `examples/atardecer_inteligente.yaml`
2. Copia el contenido completo
3. En Home Assistant:
   - Configuración → Automatizaciones
   - Crear Automatización → ⋮ → Editar en YAML
   - Pegar contenido
   - Guardar

4. Repite con `examples/regreso_casa_desactivar_simulacion.yaml`

---

### **Paso 2: Verificar Entidades**

Asegúrate de que existen:
- ✅ `device_tracker.blacky` - Tu tracker
- ✅ `zone.home` - Zona de casa
- ✅ `scene.anochecer` - Escena de atardecer
- ✅ `scene.bedtime` - Escena de salida
- ✅ `input_boolean.presence_simulation` - Control de simulación
- ✅ `notify.mobile_app_blacky` - Servicio de notificación

---

## ⚙️ Personalización

### **Cambiar Tiempo de Offset**:
```yaml
# En atardecer_inteligente.yaml
offset: "00:30:00"  # 30 minutos después
# Cambiar a:
offset: "01:00:00"  # 60 minutos después
```

### **Cambiar Distancia Mínima**:
```yaml
# Por defecto: >100m = fuera de casa
value_template: >-
  {{ (distance('device_tracker.blacky', 'zone.home') | float(0)) > 0.1 }}

# Cambiar a 500m:
  {{ (distance('device_tracker.blacky', 'zone.home') | float(0)) > 0.5 }}
```

### **Cambiar Escena de Salida**:
```yaml
# En regreso_casa_desactivar_simulacion.yaml
entity_id: scene.bedtime  # Cambiar por tu escena preferida
```

---

## 🔍 Monitoreo

### **Ver Logs**:
- Settings → System → Logs
- Buscar: "Atardecer Inteligente" o "Regreso a Casa"

### **Ver Historial**:
- History → Buscar automatizaciones
- Developer Tools → Logbook

---

## 🐛 Troubleshooting

### **La simulación no se activa**

**Causa**: Nico está en casa (o tracker no funciona)

**Solución**:
```bash
# Verificar distancia actual
Developer Tools → Template:
{{ distance('device_tracker.blacky', 'zone.home') }}
# Debe ser > 0.1 (100m) para activar
```

---

### **Notificaciones no llegan**

**Causa**: Servicio de notificación incorrecto

**Solución**:
1. Developer Tools → Services
2. Buscar: `notify.`
3. Verificar que `notify.mobile_app_blacky` existe
4. Si es otro nombre, actualizar en las automatizaciones

---

### **No desactiva al volver**

**Causa**: Trigger de zona no detecta entrada

**Solución**:
1. Verificar que `device_tracker.blacky` funciona
2. Verificar que `zone.home` está bien configurada
3. History → Ver si hay eventos de entrada

---

## 📊 Archivos

```
/examples/
  atardecer_inteligente.yaml                 # Automatización 1
  regreso_casa_desactivar_simulacion.yaml    # Automatización 2

/docs/
  ATARDECER_INTELIGENTE.md                   # Esta documentación
```

---

## 🎯 Comportamiento Completo

```
17:30 (Sunset) → +30 min → 18:00
  ↓
¿Nico en casa?
  ↓
NO → Escena anochecer + Presence Simulation ON + Notificación
SÍ → Solo escena anochecer

---

Nico entra en zone.home
  ↓
¿Presence Simulation ON?
  ↓
SÍ → Presence Simulation OFF + Escena bedtime + Notificación
NO → No hace nada
```

---

**Sistema listo para usar** ✨

