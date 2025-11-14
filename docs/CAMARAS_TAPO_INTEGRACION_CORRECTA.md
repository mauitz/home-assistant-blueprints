# 📹 Integración Correcta de Cámaras Tapo para Alertas

## ❌ Problema Identificado

Tu integración actual **NO genera binary sensors de movimiento**, por lo que las automatizaciones no pueden detectar eventos reales de las cámaras.

**Estado Actual:**
- ✅ Cámaras visibles en HA
- ❌ No hay `binary_sensor` de movimiento
- ❌ No hay eventos de detección
- ❌ Solo switches de configuración (on/off motion detection)

---

## ✅ Solución: Instalar Integración Correcta

### Integración Requerida:
**"Tapo: Cameras Control"** por JurajNyiri
- Repository: https://github.com/JurajNyiri/HomeAssistant-Tapo-Control
- Vía HACS
- Crea binary sensors reales de movimiento y persona

---

## 📋 Pasos de Instalación

### **PASO 1:** Habilitar Control Local en Cámaras

**En la App Tapo (en tu móvil):**

1. Actualizar app Tapo a versión **3.8.103** o superior
2. Ir a **"Yo"** (perfil) → **"Tapo Lab"**
3. Activar **"Compatibilidad con terceros"** (Third-Party Compatibility)
4. Reiniciar cada cámara desde la app

> **⚠️ Importante:** Sin esto, la integración no funcionará correctamente.

---

### **PASO 2:** Crear Usuario de Cámara

**Para cada cámara en la App Tapo:**

1. Abrir cámara
2. **Configuración** (⚙️) → **Configuración avanzada**
3. **Cuenta de la cámara** (Camera Account)
4. Crear usuario y contraseña:
   - Usuario: `homeassistant`
   - Contraseña: (algo seguro, guárdala)
5. Repetir para ambas cámaras

---

### **PASO 3:** Instalar Integración en HACS

**En Home Assistant:**

1. Ir a **HACS** → **Integraciones**
2. Click en **⊕** (Explorar y descargar repositorios)
3. Buscar: **"Tapo: Cameras Control"**
4. Seleccionar e instalar
5. **Reiniciar** Home Assistant

---

### **PASO 4:** Configurar Integración

**En Home Assistant:**

1. **Configuración** → **Dispositivos y servicios**
2. Click en **+ AGREGAR INTEGRACIÓN**
3. Buscar: **"Tapo: Cameras Control"**
4. Configurar **primera cámara (C530WS Entrada)**:
   - Host: `192.168.1.X` (IP de tu cámara)
   - Usuario: `homeassistant`
   - Contraseña: (la que creaste)
5. Repetir para **segunda cámara (C310 Exterior)**

---

### **PASO 5:** Verificar Entidades Creadas

**Deberían aparecer estas entidades nuevas:**

#### Cámara C530WS Entrada:
- `binary_sensor.tapo_c530ws_entrada_motion` ⭐ **DETECCIÓN DE MOVIMIENTO**
- `binary_sensor.tapo_c530ws_entrada_person` ⭐ **DETECCIÓN DE PERSONA**
- `camera.tapo_c530ws_entrada_hd`
- `camera.tapo_c530ws_entrada_sd`
- `switch.tapo_c530ws_entrada_privacy_mode`
- `switch.tapo_c530ws_entrada_alarm`
- Y más...

#### Cámara C310 Exterior:
- `binary_sensor.tapo_c310_exterior_motion` ⭐ **DETECCIÓN DE MOVIMIENTO**
- `binary_sensor.tapo_c310_exterior_person` ⭐ **DETECCIÓN DE PERSONA**
- `camera.tapo_c310_exterior_hd`
- `camera.tapo_c310_exterior_sd`
- `switch.tapo_c310_exterior_privacy_mode`
- `switch.tapo_c310_exterior_alarm`
- Y más...

---

## 🧪 Prueba Rápida

**En Herramientas para desarrolladores → Estados:**

1. Buscar: `binary_sensor.tapo_c530ws_entrada_motion`
2. Estado debe ser: `off` (cuando no hay movimiento)
3. Hacer movimiento frente a la cámara
4. Estado debe cambiar a: `on` 🎉

---

## ⚠️ Notas Importantes

1. **IPs estáticas:** Asegúrate de que las cámaras tengan IPs fijas en tu router
2. **Red local:** Cámaras y HA deben estar en la misma red
3. **Firmware actualizado:** Actualiza firmware de cámaras desde la app Tapo
4. **Credenciales:** Usa las de "Camera Account", no las de tu cuenta Tapo

---

## 🔍 Troubleshooting

### No aparecen binary sensors

**Solución:**
1. Verificar que "Compatibilidad con terceros" esté activa
2. Verificar que usaste las credenciales de "Camera Account"
3. Eliminar integración y volver a configurar
4. Reiniciar cámara físicamente (desenchufarla 10s)

### Binary sensor siempre en "unavailable"

**Solución:**
1. Verificar conectividad de red
2. Ping a la IP de la cámara desde HA
3. Verificar que el puerto 2020 esté abierto (usado por Tapo)
4. Revisar logs de HA para errores específicos

### Binary sensor no detecta movimiento

**Solución:**
1. Verificar en la app Tapo que motion detection esté ON
2. Ajustar sensibilidad desde la app
3. Definir zonas de detección en la app
4. Verificar que la cámara tenga buena iluminación

---

## 📊 Entidades Útiles para Automatizaciones

| Entidad | Descripción | Uso |
|---------|-------------|-----|
| `binary_sensor.*_motion` | Detección de movimiento | Trigger principal |
| `binary_sensor.*_person` | Detección de persona | Trigger más específico |
| `switch.*_alarm` | Alarma de cámara | Activar sirena/luz |
| `camera.*_hd` | Stream HD | Captura de snapshot |
| `camera.*_sd` | Stream SD (más rápido) | Captura rápida |

---

## 🎯 Ventajas de esta Integración

✅ **Binary sensors** reales de detección  
✅ **Eventos** en tiempo real (< 2 segundos de latency)  
✅ **Control local** (no depende de cloud)  
✅ **Múltiples streams** (HD/SD)  
✅ **Control de PTZ** (Pan/Tilt en C530WS)  
✅ **Alarmas** integrables  
✅ **Privacidad** (privacy mode switch)  

---

## 🚀 Próximo Paso

Una vez que tengas los binary sensors funcionando, procederemos con:
- **Automatizaciones V3** basadas en binary sensors reales
- **Dashboard mejorado** con estados reales
- **Encadenamiento** de comportamientos complejos

---

**¿Dudas?** Consulta el repositorio oficial:
https://github.com/JurajNyiri/HomeAssistant-Tapo-Control

