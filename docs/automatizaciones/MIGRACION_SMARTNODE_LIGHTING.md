# Migración a Blueprint SmartNode Lighting

## 📋 Resumen

Este documento explica cómo migrar de las automatizaciones manuales de presencia a un sistema basado en blueprints reutilizable para todos los SmartNodes.

---

## 🎯 Objetivo

Crear un sistema consistente y configurable para controlar luces automáticamente basándose en:
- ✅ Detección de presencia (sensor LD2410)
- ✅ Nivel de luminosidad ambiente
- ✅ Configuración personalizada por habitación
- ✅ Respuesta rápida y confiable

---

## 📝 Automatizaciones a ELIMINAR

En el archivo `HA_config_proxy/automations.yaml` hay que eliminar estas automatizaciones:

### 1. Habitación - Presencia Detectada
```yaml
ID: '1734450000001'
Líneas: 286-316
```

### 2. Habitación - Sin Presencia
```yaml
ID: '1734450000002'
Líneas: 317-350
```

### ⚠️ Cómo Eliminarlas

**Opción A - Desde Home Assistant UI (Recomendado):**
1. Ir a **Configuración** → **Automatizaciones y Escenas**
2. Buscar "Habitación - Presencia Detectada"
3. Click en los 3 puntos → **Eliminar**
4. Repetir para "Habitación - Sin Presencia"

**Opción B - Desde el archivo YAML:**
1. Abrir `HA_config_proxy/automations.yaml`
2. Eliminar las líneas 286-350 (ambas automatizaciones)
3. Guardar el archivo
4. Recargar automatizaciones desde Home Assistant

---

## 🚀 Instalación del Nuevo Sistema

### Paso 1: Verificar el Blueprint

El blueprint está en:
```
/blueprints/smartnode_presence_lighting.yaml
```

Debe estar accesible en Home Assistant en:
```
config/blueprints/automation/mauitz/smartnode_presence_lighting.yaml
```

### Paso 2: Crear la Nueva Automatización

**Desde la UI (Recomendado):**

1. Ir a **Configuración** → **Automatizaciones y Escenas**
2. Click en **+ Crear Automatización**
3. Seleccionar **Usar un Blueprint**
4. Buscar "SmartNode - Iluminación Automática por Presencia"
5. Configurar los parámetros:

   **Sensores SmartNode:**
   - Sensor de Presencia: `binary_sensor.presence`
   - Sensor de Luminosidad: `sensor.room_brightness`

   **Dispositivo de Luz:**
   - Luz o Switch: `switch.bedroom_3_switch_switch_1`

   **Configuración de Luz:**
   - Nivel de Brillo: `80%` (ajustar según preferencia)
   - Tiempo de Transición: `1s`

   **Umbrales y Delays:**
   - Umbral de Oscuridad: `30%` (enciende si luz < 30%)
   - Delay al Encender: `0s` (respuesta inmediata)
   - Delay al Apagar: `5s` (apaga 5s después de salir)

   **Opciones Avanzadas:**
   - Permitir Anulación Manual: `✅ Sí`
   - Habilitar Notificaciones: `❌ No` (activar solo para debug)

6. Guardar como: `Dormitorio - Luz Automática SmartNode`

**Desde YAML:**

Copiar el contenido de:
```
examples/automatizaciones/bedroom_smartnode_lighting.yaml
```

Y agregarlo a `automations.yaml`, o usar el blueprint desde la UI.

---

## ⚙️ Configuración por Habitación

### Dormitorio Principal
```yaml
brightness_threshold: 30%
turn_on_delay: 0s
turn_off_delay: 5s
brightness_level: 80%
```

### Baño
```yaml
brightness_threshold: 20%
turn_on_delay: 0s
turn_off_delay: 3s
brightness_level: 100%
```

### Pasillo
```yaml
brightness_threshold: 40%
turn_on_delay: 0s
turn_off_delay: 5s
brightness_level: 60%
```

### Cocina
```yaml
brightness_threshold: 25%
turn_on_delay: 1s
turn_off_delay: 10s
brightness_level: 90%
```

---

## 🧪 Pruebas y Verificación

### Test 1: Encendido Automático
1. **Condiciones iniciales:**
   - Luz del dormitorio apagada
   - Habitación oscura (< 30% luminosidad)
   - No hay presencia detectada

2. **Acción:**
   - Entrar a la habitación

3. **Resultado esperado:**
   - La luz se enciende inmediatamente al detectar presencia
   - Log en Home Assistant: "Luz encendida por presencia"

### Test 2: No Encender si Hay Luz Natural
1. **Condiciones iniciales:**
   - Luz del dormitorio apagada
   - Habitación con luz natural (> 30% luminosidad)
   - No hay presencia detectada

2. **Acción:**
   - Entrar a la habitación

3. **Resultado esperado:**
   - La luz NO se enciende (hay suficiente luz natural)
   - No hay acción registrada en el log

### Test 3: Apagado Automático
1. **Condiciones iniciales:**
   - Luz encendida automáticamente
   - Presencia detectada

2. **Acción:**
   - Salir de la habitación

3. **Resultado esperado:**
   - Después de 5 segundos sin presencia, la luz se apaga
   - Log: "Luz apagada automáticamente"

### Test 4: Anulación Manual
1. **Condiciones iniciales:**
   - Habitación oscura
   - No hay presencia

2. **Acción:**
   - Encender la luz manualmente (desde el interruptor físico o app)

3. **Resultado esperado:**
   - La luz permanece encendida
   - No se apaga automáticamente mientras esté encendida manualmente

### Test 5: No Encender si Ya Está Encendida
1. **Condiciones iniciales:**
   - Luz ya encendida (manual o automáticamente)
   - Habitación oscura

2. **Acción:**
   - Salir y volver a entrar

3. **Resultado esperado:**
   - La luz permanece encendida (no parpadea)
   - No hay acción de encendido duplicada

---

## 🐛 Troubleshooting

### Problema: La luz no enciende

**Posibles causas:**
1. El umbral de luminosidad es muy bajo
   - **Solución:** Aumentar `brightness_threshold` a 40-50%

2. Las entidades no existen o tienen nombres incorrectos
   - **Solución:** Verificar en **Herramientas de Desarrollo** → **Estados**
   - Buscar: `binary_sensor.presence` y `sensor.room_brightness`

3. La luz ya está encendida
   - **Solución:** Verificar estado actual del switch

**Debug:**
- Activar `enable_notifications: true`
- Revisar **Herramientas de Desarrollo** → **Estados** → Estado del sensor de presencia
- Revisar **Logbook** para ver eventos

### Problema: La luz parpadea constantemente

**Posibles causas:**
1. El sensor de presencia es inestable
   - **Solución:** Aumentar `turn_on_delay` a 1-2 segundos
   - Calibrar el LD2410 en ESPHome

2. Hay conflicto con otra automatización
   - **Solución:** Verificar que las automatizaciones antiguas estén eliminadas

3. El umbral de luminosidad está en el límite
   - **Solución:** Ajustar `brightness_threshold` con margen (±5%)

### Problema: Se apaga demasiado rápido

**Posibles causas:**
1. El `turn_off_delay` es muy corto
   - **Solución:** Aumentar a 10-15 segundos

2. El sensor LD2410 pierde el tracking
   - **Solución:** Ajustar sensibilidad en ESPHome:
   ```yaml
   ld2410:
     timeout: 10s
     max_move_distance: 6m
     max_still_distance: 4m
   ```

### Problema: No responde en absoluto

**Verificaciones:**
1. ✅ El SmartNode está online
   ```bash
   # Verificar en Home Assistant
   Estados → buscar "smartnode1"
   ```

2. ✅ Las entidades existen
   - `binary_sensor.presence`
   - `sensor.room_brightness`
   - `switch.bedroom_3_switch_switch_1`

3. ✅ La automatización está habilitada
   ```
   Automatizaciones → verificar que no esté deshabilitada
   ```

4. ✅ No hay errores en los logs
   ```
   Configuración → Logs → buscar "smartnode" o "automation"
   ```

---

## 📊 Monitoreo y Logs

### Ver Actividad de la Automatización

**Desde la UI:**
1. Ir a **Logbook**
2. Filtrar por: "SmartNode - Luz Automática"
3. Ver historial de activaciones

**Logs Detallados:**
```
Configuración → Logs → buscar:
- "SmartNode - Luz Automática"
- "binary_sensor.presence"
- "switch.bedroom_3_switch_switch_1"
```

### Estadísticas Útiles

Crear sensores de estadísticas para monitorear:
- Cuántas veces se activa por día
- Tiempo promedio de permanencia en la habitación
- Consumo energético optimizado

---

## 🔄 Escalabilidad a Otros SmartNodes

Cuando instales más SmartNodes en otras habitaciones, simplemente:

1. **Crear nueva automatización desde el mismo blueprint**
2. **Configurar las entidades específicas:**
   - `binary_sensor.presence_cocina`
   - `sensor.room_brightness_cocina`
   - `switch.cocina_luz_principal`
3. **Ajustar parámetros según el tipo de habitación**
4. **Guardar con nombre descriptivo:**
   - "Cocina - Luz Automática SmartNode"
   - "Baño - Luz Automática SmartNode"
   - etc.

---

## 📚 Referencias

- **Blueprint:** `/blueprints/smartnode_presence_lighting.yaml`
- **Ejemplo:** `/examples/automatizaciones/bedroom_smartnode_lighting.yaml`
- **SmartNode Config:** `/docs/smart_nodes/prototype/device.yaml`
- **Documentación LD2410:** [ESPHome LD2410](https://esphome.io/components/sensor/ld2410.html)

---

## ✅ Checklist de Migración

- [ ] Backup de `automations.yaml` actual
- [ ] Eliminar automatizaciones antiguas (IDs: 1734450000001, 1734450000002)
- [ ] Verificar que el blueprint está en la carpeta correcta
- [ ] Crear nueva automatización usando el blueprint
- [ ] Configurar parámetros del dormitorio
- [ ] Realizar Test 1: Encendido automático
- [ ] Realizar Test 2: No encender con luz natural
- [ ] Realizar Test 3: Apagado automático
- [ ] Realizar Test 4: Anulación manual
- [ ] Realizar Test 5: No parpadeo
- [ ] Verificar logs durante 24 horas
- [ ] Ajustar parámetros si es necesario
- [ ] Documentar configuración final

---

**Autor:** Blueprint SmartNode Lighting v1.0
**Fecha:** Diciembre 2025
**Compatible con:** Home Assistant 2025.x


