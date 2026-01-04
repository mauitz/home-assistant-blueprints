# 🚀 Inicio Rápido - Blueprint SmartNode Lighting

## ¿Qué hace este blueprint?

Automatiza la **luz del dormitorio** (o cualquier habitación) basándose en:

- ✅ **Presencia detectada** por el SmartNode (sensor LD2410)
- ✅ **Luminosidad ambiente** (solo enciende si está oscuro)
- ✅ **Estado de la luz** (verifica que esté apagada antes de encender)
- ✅ **Delays configurables** (apaga 5 segundos después de salir)

---

## 🎯 Comportamiento

### Cuando entras a la habitación:
```
SI está oscuro (< 30% luz)
  Y la luz está apagada
  Y detecta presencia
→ ENCIENDE la luz INMEDIATAMENTE
```

### Cuando sales de la habitación:
```
Si no hay presencia por 5 segundos
  Y la luz está encendida
→ APAGA la luz automáticamente
```

### Si hay luz natural:
```
NO hace nada (la luz natural es suficiente)
```

---

## ⚡ Instalación en 3 Pasos

### Paso 1: Instalar el Blueprint

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
./utils/install_smartnode_blueprint.sh
```

Esto copiará el blueprint a Home Assistant.

### Paso 2: Eliminar Automatizaciones Antiguas

En Home Assistant UI:

1. Ve a **Configuración** → **Automatizaciones y Escenas**
2. Busca y elimina estas 2 automatizaciones:
   - ❌ "Habitación - Presencia Detectada"
   - ❌ "Habitación - Sin Presencia"

**Importante:** Estas automatizaciones solo enviaban notificaciones, no controlaban la luz. El nuevo blueprint sí controla la luz inteligentemente.

### Paso 3: Crear Nueva Automatización

En Home Assistant UI:

1. Ve a **Configuración** → **Automatizaciones y Escenas**
2. Click en **➕ Crear Automatización**
3. Selecciona **Usar un Blueprint**
4. Busca: **"SmartNode - Iluminación Automática por Presencia"**
5. Completa estos campos:

```
┌─────────────────────────────────────────────────────┐
│ 📋 CONFIGURACIÓN PARA EL DORMITORIO                 │
├─────────────────────────────────────────────────────┤
│                                                     │
│ Sensores SmartNode:                                 │
│   • Sensor de Presencia:    binary_sensor.presence  │
│   • Sensor de Luminosidad:  sensor.room_brightness  │
│                                                     │
│ Dispositivo de Luz:                                 │
│   • Luz o Switch:  switch.bedroom_3_switch_switch_1 │
│                                                     │
│ Configuración de Luz:                               │
│   • Nivel de Brillo:        80%                     │
│   • Tiempo de Transición:   1 segundo               │
│                                                     │
│ Umbrales y Delays:                                  │
│   • Umbral de Oscuridad:    30%                     │
│   • Delay al Encender:      0 segundos              │
│   • Delay al Apagar:        5 segundos              │
│                                                     │
│ Opciones Avanzadas:                                 │
│   • Anulación Manual:       ✅ Activado             │
│   • Notificaciones:         ❌ Desactivado          │
│                                                     │
└─────────────────────────────────────────────────────┘
```

6. Dale un nombre: **"Dormitorio - Luz Automática SmartNode"**
7. Click en **Guardar**

---

## ✅ Verificación Rápida

### Test 1: Enciende cuando está oscuro
1. Apaga la luz del dormitorio
2. Asegúrate de que esté oscuro (o cierra las cortinas)
3. Entra a la habitación
4. **Resultado:** La luz debe encenderse inmediatamente ✅

### Test 2: NO enciende si hay luz natural
1. Apaga la luz del dormitorio
2. Abre las cortinas (debe haber luz natural)
3. Entra a la habitación
4. **Resultado:** La luz NO debe encenderse ✅

### Test 3: Apaga automáticamente
1. Con la luz encendida automáticamente
2. Sale de la habitación
3. **Resultado:** Después de 5 segundos, la luz se apaga ✅

---

## 🔧 Ajustes Comunes

### Si la luz no enciende:

**Problema:** El umbral de oscuridad es muy bajo.

**Solución:** Aumenta el **Umbral de Oscuridad** a `40%` o `50%`

```
Editar automatización → Umbral de Oscuridad: 40%
```

### Si la luz parpadea:

**Problema:** El sensor detecta presencia intermitente.

**Solución:** Aumenta el **Delay al Encender** a `1` o `2` segundos

```
Editar automatización → Delay al Encender: 2 segundos
```

### Si se apaga demasiado rápido:

**Problema:** El delay de apagado es muy corto.

**Solución:** Aumenta el **Delay al Apagar** a `10` segundos

```
Editar automatización → Delay al Apagar: 10 segundos
```

---

## 📊 Verificar Sensores

Para confirmar que los sensores funcionan:

1. Ve a **Herramientas de Desarrollo** → **Estados**
2. Busca estas entidades:

```
binary_sensor.presence           → debe estar "on" cuando detecta presencia
sensor.room_brightness           → debe mostrar 0-100 (% de luz)
switch.bedroom_3_switch_switch_1 → debe estar "on" o "off"
```

Si alguna entidad no aparece, verifica que el SmartNode esté online.

---

## 🎨 Para Otras Habitaciones

Cuando instales más SmartNodes (cocina, baño, pasillo):

1. **Crea una nueva automatización** desde el mismo blueprint
2. **Cambia las entidades** según la habitación:
   ```
   Cocina:
     - binary_sensor.presence_cocina
     - sensor.room_brightness_cocina
     - switch.cocina_luz

   Baño:
     - binary_sensor.presence_bano
     - sensor.room_brightness_bano
     - switch.bano_luz
   ```
3. **Ajusta los parámetros** según el tipo de habitación:
   - Baño: delay 3s, brillo 100%
   - Pasillo: delay 5s, brillo 60%
   - Cocina: delay 10s, brillo 90%

---

## 📚 Documentación Completa

Si necesitas más detalles, consulta:

- **Resumen completo:** `SMARTNODE_LIGHTING_RESUMEN.md`
- **Guía de migración:** `docs/automatizaciones/MIGRACION_SMARTNODE_LIGHTING.md`
- **README del blueprint:** `blueprints/README_SMARTNODE.md`

---

## 🆘 Soporte

### Verificar instalación:
```bash
./utils/verify_smartnode_setup.sh
```

### Ver logs en Home Assistant:
1. **Configuración** → **Logs**
2. Buscar: `"SmartNode - Luz Automática"`

### Activar notificaciones para debug:
```
Editar automatización → Habilitar Notificaciones: ✅
```

---

## ✅ Checklist

- [ ] Ejecuté el script de instalación
- [ ] Eliminé las 2 automatizaciones antiguas
- [ ] Creé la nueva automatización desde el blueprint
- [ ] Configuré los sensores correctos
- [ ] Probé el encendido automático
- [ ] Probé que NO enciende con luz natural
- [ ] Probé el apagado automático
- [ ] Ajusté parámetros si fue necesario

---

**¡Listo! Ya tienes automatización inteligente de luces con tu SmartNode.** 🎉

---

**Versión:** 1.0
**Fecha:** Diciembre 2025
**Compatible con:** Home Assistant 2025.x


