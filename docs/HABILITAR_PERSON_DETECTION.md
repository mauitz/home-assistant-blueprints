# 👤 Cómo Habilitar Person Detection en Cámaras Tapo

## ⚠️ **Problema Actual:**

Los binary sensors de detección de personas están en estado `unavailable`:
- `binary_sensor.tapo_c530ws_entrada_person_detection` → unavailable
- `binary_sensor.tapo_c310_exterior_person_detection` → unavailable

Esto significa que la **detección de personas NO está habilitada** en las cámaras.

---

## ✅ **Solución: Habilitar en la App Tapo**

### **Método 1: App Tapo (Recomendado)**

#### **Para C530WS Entrada:**

1. Abrir **App Tapo** en el celular
2. Seleccionar cámara **"Entrada"**
3. Ir a **Configuración** (⚙️ arriba a la derecha)
4. Ir a **"Detección"** o **"Detection & Alerts"**
5. Buscar **"Person Detection"** o **"Detección de Personas"**
6. **ACTIVAR** el switch
7. Ajustar sensibilidad (recomendado: **Media** o **Alta**)
8. Guardar cambios

#### **Para C310 Exterior:**

1. Seleccionar cámara **"Exterior"**
2. Seguir los mismos pasos anteriores
3. Activar **Person Detection**
4. Sensibilidad: **Media** o **Alta**

---

### **Método 2: Verificar en Home Assistant**

Después de habilitar en la app Tapo:

1. **Herramientas de desarrollador → Estados**
2. Buscar: `binary_sensor.tapo_c530ws_entrada_person_detection`
3. **Debería cambiar de** `unavailable` **a** `off` (cuando no hay persona) o `on` (cuando detecta)

Si sigue en `unavailable`:
1. **Configuración → Integraciones**
2. Buscar **"Tapo: Cameras Control"**
3. Click en **"Recargar"**
4. Esperar 10 segundos
5. Verificar estados nuevamente

---

## 🔧 **Configuración Recomendada en Tapo App:**

### **Detección de Personas:**
- ✅ **Activada**
- **Sensibilidad:** Media-Alta
- **Zona de detección:** Completa (o personalizada)

### **Notificaciones en Tapo App:**
- ⚠️ **Puedes desactivarlas** si quieres solo notificaciones de HA
- O mantenerlas como respaldo

### **Otras Configuraciones:**
- **Motion Detection:** Puede quedar activada (no afecta)
- **Vehicle Detection:** No disponible en estos modelos
- **Pet Detection:** Disponible en C530WS si quieres detectar mascotas

---

## 🧪 **Cómo Probar que Funciona:**

### **Test 1: En Home Assistant**

1. **Herramientas de desarrollador → Estados**
2. Buscar: `binary_sensor.tapo_c530ws_entrada_person_detection`
3. El estado debe ser: **`off`** (listo para detectar)
4. **Pasar frente a la cámara**
5. El estado debe cambiar a: **`on`**
6. Después de unos segundos: vuelve a **`off`**

### **Test 2: Con las Automatizaciones**

1. Asegurarte de que estén cargadas las automatizaciones V3.2
2. Pasar frente a C530WS Entrada
3. **Resultado esperado:**
   - ✅ Notificación: "🚨 PERSONA en Entrada"
   - ✅ Sirena 5 segundos
   - ✅ Floodlight encendido
   - ✅ Widget agrandado en dashboard
   - ✅ Snapshot guardado
   - ✅ Reset automático en 10s

---

## 📊 **Diferencias: Motion vs Person Detection**

| Aspecto | Motion Detection | Person Detection |
|---------|------------------|------------------|
| Detecta | Cualquier movimiento | Solo personas |
| Falsos positivos | Muchos (sombras, animales, viento) | Pocos (IA filtrada) |
| Sensibilidad | Alta | Media-Alta |
| Procesamiento | Hardware básico | IA en cámara |
| Recomendado para | Monitoreo general | Seguridad/Alertas |

---

## ⚠️ **Limitaciones Conocidas:**

### **NO disponible:**
- ❌ **Vehicle Detection** (Detección de vehículos) - No soportado por C530WS ni C310
- ❌ **Animal Detection** (genérico) - Solo "Pet Detection" en C530WS

### **Sí disponible:**
- ✅ **Person Detection** en ambas cámaras
- ✅ **Pet Detection** solo en C530WS
- ✅ **Motion Detection** en ambas

---

## 🎯 **Recomendación Final:**

Para **seguridad y alertas importantes**:
- ✅ Usar **Person Detection** (menos falsos positivos)
- ✅ Sensibilidad: **Media-Alta**
- ✅ Notificaciones de HA (más control)

Para **monitoreo general** (cualquier movimiento):
- ⚠️ Usar **Motion Detection**
- ⚠️ Más falsos positivos
- ⚠️ Útil para vigilancia 24/7

---

## 🚀 **Próximos Pasos:**

1. **Habilitar Person Detection** en App Tapo (ambas cámaras)
2. **Recargar integración** en HA
3. **Verificar** que binary sensors cambien a `off` (no `unavailable`)
4. **Actualizar automatizaciones** a V3.2
5. **Probar** pasando frente a las cámaras
6. **Disfrutar** de alertas precisas sin falsos positivos 🎉

---

**Nota:** Si después de habilitar en la app Tapo los sensores siguen en `unavailable`, puede ser necesario:
1. Reiniciar Home Assistant
2. O esperar hasta 5 minutos para que la integración detecte los cambios

