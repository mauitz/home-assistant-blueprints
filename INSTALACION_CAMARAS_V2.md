# 🚀 Instalación: Sistema de Alertas de Cámaras V2

---

## ✅ Archivos Modificados

### 1. `HA_config_proxy/configuration.yaml`
**Cambios:** Agregados 2 helpers nuevos en la sección `input_text`:
- `camera_alert_active` → Tracking de cámara con alerta
- `camera_alert_timestamp` → Timestamp de última detección

### 2. `HA_config_proxy/automations.yaml`
**Cambios:** Agregadas 3 automatizaciones nuevas al final:
- `Alerta Cámara Entrada - Agrandar` (ID: 1763070000001)
- `Alerta Cámara Exterior - Agrandar` (ID: 1763070000002)
- `Alerta Cámaras - Reset Manual` (ID: 1763070000003)

---

## 📋 Pasos de Instalación

### **PASO 1:** Actualizar Archivos en el Servidor

Desde tu Mac, ejecuta:

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints

scp HA_config_proxy/configuration.yaml nico@192.168.1.100:/config/
scp HA_config_proxy/automations.yaml nico@192.168.1.100:/config/
```

---

### **PASO 2:** Verificar Configuración

En Home Assistant Web UI:

1. **Configuración** → **Sistema** → **Reiniciar**
2. Click en **"Comprobar configuración"** (CHECK CONFIGURATION)
3. Esperar validación → Debe decir **"Configuración válida ✅"**

⚠️ **Si hay errores:** Revisa el log antes de reiniciar.

---

### **PASO 3:** Reiniciar Home Assistant

1. **Configuración** → **Sistema** → **Reiniciar**
2. Click en **"REINICIAR"** (Quick Reload para YAML)
3. Esperar **1-2 minutos**

---

### **PASO 4:** Verificar Helpers Creados

1. **Configuración** → **Dispositivos y Servicios** → **Helpers**
2. Buscar y verificar:
   - ✅ **Cámara con Alerta Activa** (`camera_alert_active`)
     - Estado inicial: `none`
   - ✅ **Timestamp de Última Alerta** (`camera_alert_timestamp`)
     - Estado inicial: `0`

---

### **PASO 5:** Verificar Automatizaciones

1. **Configuración** → **Automatizaciones y Escenas**
2. Buscar y verificar que estén **ACTIVADAS** (toggle ON):
   - ✅ Alerta Cámara Entrada - Agrandar
   - ✅ Alerta Cámara Exterior - Agrandar
   - ✅ Alerta Cámaras - Reset Manual

---

### **PASO 6:** Actualizar Dashboard

1. Ir al dashboard **"maui"**
2. Click en **⋮** (3 puntos arriba derecha) → **Editar dashboard**
3. Click en **✏️** (lápiz) → **Editar en YAML**
4. **Copiar TODO** el contenido de: `dashboards/maui_dashboard.yaml`
5. **Pegar y reemplazar** todo el contenido
6. Click en **💾 Guardar**
7. Cerrar editor

---

### **PASO 7:** 🧪 Probar Sistema Manualmente

#### Test 1: Alerta de Entrada

1. **Herramientas para desarrolladores** → **Servicios**
2. Seleccionar servicio: `input_text.set_value`
3. Copiar este YAML:
   ```yaml
   entity_id: input_text.camera_alert_active
   value: entrada
   ```
4. Click en **LLAMAR AL SERVICIO**
5. **Verificar en dashboard "maui":**
   - ✅ Cámara de entrada se agranda (16:9 → 21:9)
   - ✅ Borde rojo pulsante
   - ✅ Badge "🚨 DETECCIÓN ACTIVA"
6. **Esperar 30 segundos**
   - ✅ Debe volver a tamaño normal automáticamente

#### Test 2: Alerta de Exterior

1. Mismo proceso pero con:
   ```yaml
   entity_id: input_text.camera_alert_active
   value: exterior
   ```

#### Test 3: Reset Manual

1. Para resetear inmediatamente:
   ```yaml
   entity_id: input_text.camera_alert_active
   value: none
   ```

---

### **PASO 8 (OPCIONAL):** Configurar Triggers Reales

Las automatizaciones vienen con 2 tipos de triggers:

#### **Opción A: Webhooks** (Recomendado si tus cámaras lo soportan)

Configurar en app Tapo:
- URL Entrada: `http://192.168.1.100:8123/api/webhook/tapo_c530ws_entrada_motion`
- URL Exterior: `http://192.168.1.100:8123/api/webhook/tapo_c310_exterior_motion`

#### **Opción B: Estado de Cámara** (Ya configurado)

Las automatizaciones escuchan:
- `camera.tapo_c530ws_entrada_live_view`: `idle` → `recording`
- `camera.tapo_c310_exterior_live_view`: `idle` → `recording`

#### **Opción C: Personalizado**

Si ninguno funciona, podemos agregar otro trigger según tu integración.

---

## ✅ Checklist de Instalación Completa

- [ ] Archivos copiados al servidor
- [ ] Configuración verificada sin errores
- [ ] Home Assistant reiniciado
- [ ] Helpers creados y visibles
- [ ] Automatizaciones activas
- [ ] Dashboard actualizado
- [ ] Test manual de entrada funciona
- [ ] Test manual de exterior funciona
- [ ] Auto-reset a 30s funciona

---

## 🔍 Troubleshooting

### Problema: "Configuración inválida"

**Solución:**
1. Ver logs: **Configuración** → **Logs**
2. Buscar error específico
3. Revisar sintaxis YAML (espacios, indentación)

### Problema: Helpers no aparecen

**Solución:**
1. Verificar que `configuration.yaml` tenga la sección `input_text`
2. Reiniciar HA completamente (no Quick Reload)
3. Verificar logs

### Problema: Cámara no se agranda

**Solución:**
1. Verificar que el helper existe: `input_text.camera_alert_active`
2. Ver estado en **Herramientas para desarrolladores** → **Estados**
3. Probar cambio manual del helper

### Problema: No vuelve a normal después de 30s

**Solución:**
1. Verificar que la automatización esté en modo `restart`
2. Ver logs de la automatización
3. Reset manual: establecer helper a `none`

---

## 📚 Documentación Adicional

- **Completa:** `docs/CAMERA_ALERTS_V2.md`
- **Ejemplos:** `examples/camera_alert_helpers.yaml`
- **Automatizaciones:** `examples/camera_alert_automations.yaml`

---

## 🎯 Resultado Esperado

**Estado Normal:**
- Ambas cámaras visibles en formato 16:9
- Bordes grises sutiles

**Cuando hay Alerta:**
- Solo se muestra cámara detectada
- Formato agrandado 21:9
- Borde rojo pulsante con animación
- Badge "🚨 DETECCIÓN ACTIVA" animado
- Auto-reset después de 30 segundos

---

**¿Problemas?** Revisa `docs/CAMERA_ALERTS_V2.md` para troubleshooting detallado.

