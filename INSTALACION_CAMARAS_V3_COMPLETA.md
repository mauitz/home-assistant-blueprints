# 🚀 Instalación Completa: Sistema de Alertas de Cámaras V3

---

## 📋 Índice de Instalación

1. [Instalar Integración Correcta](#1-instalar-integración-correcta)
2. [Configurar Helpers](#2-configurar-helpers)
3. [Configurar Automatizaciones](#3-configurar-automatizaciones)
4. [Preparar Sistema de Archivos](#4-preparar-sistema-de-archivos)
5. [Reiniciar y Verificar](#5-reiniciar-y-verificar)
6. [Probar Sistema](#6-probar-sistema)

---

## 1. Instalar Integración Correcta

### ❗ CRÍTICO: Sin esto, nada funcionará

**Sigue la guía completa:**  
📖 `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md`

### Resumen:

**A. En App Tapo (en tu móvil):**
1. Actualizar a versión 3.8.103+
2. **"Yo"** → **"Tapo Lab"** → **"Compatibilidad con terceros"** ✅
3. Para cada cámara:
   - Configuración → Avanzada → Cuenta de la cámara
   - Usuario: `homeassistant`
   - Contraseña: (guardar)

**B. En Home Assistant:**
1. **HACS** → **Integraciones** → **⊕**
2. Buscar: **"Tapo: Cameras Control"**
3. Instalar y reiniciar HA
4. **Configuración** → **Dispositivos** → **+ Integración**
5. Buscar: **"Tapo: Cameras Control"**
6. Configurar Cámara 1 (C530WS Entrada):
   - IP: `192.168.1.X`
   - Usuario: `homeassistant`
   - Contraseña: (la que creaste)
7. Repetir para Cámara 2 (C310 Exterior)

**C. Verificar Entidades Creadas:**

Debe existir:
```
✅ binary_sensor.tapo_c530ws_entrada_motion
✅ binary_sensor.tapo_c530ws_entrada_person
✅ binary_sensor.tapo_c310_exterior_motion
✅ binary_sensor.tapo_c310_exterior_person
✅ switch.tapo_c530ws_entrada_alarm
✅ switch.tapo_c310_exterior_alarm
✅ camera.tapo_c530ws_entrada_hd
✅ camera.tapo_c530ws_entrada_sd
✅ camera.tapo_c310_exterior_hd
✅ camera.tapo_c310_exterior_sd
```

---

## 2. Configurar Helpers

### A. Actualizar `configuration.yaml`

**Agregar al final de la sección `input_text`:**

```yaml
input_text:
  # ... (helpers existentes)
  
  # Helpers para sistema de alertas V3
  camera_alert_active:
    name: Cámara con Alerta Activa
    max: 50
    initial: "none"
    icon: mdi:cctv
  
  camera_alert_timestamp:
    name: Timestamp de Última Alerta
    max: 50
    initial: "0"
    icon: mdi:clock-outline
```

**Agregar nueva sección `input_select`:**

```yaml
input_select:
  camera_alert_type:
    name: Tipo de Última Alerta
    icon: mdi:alert-circle
    options:
      - "Ninguna"
      - "Movimiento"
      - "Persona"
    initial: "Ninguna"
```

**Agregar nueva sección `input_datetime`:**

```yaml
input_datetime:
  camera_alert_last_trigger:
    name: Última Detección
    has_date: true
    has_time: true
    icon: mdi:clock-alert
```

---

## 3. Configurar Automatizaciones

### Copiar Archivo Completo

**Desde tu Mac:**

```bash
# Ver contenido
cat examples/camera_alert_system_v3.yaml
```

**Copiar TODO el contenido** de `examples/camera_alert_system_v3.yaml`

**Pegarlo al final de:** `HA_config_proxy/automations.yaml`

⚠️ **Importante:** Borrar las automatizaciones V2 antiguas si las tienes:
- `Alerta Cámara Entrada - Agrandar` (ID: 1763070000001)
- `Alerta Cámara Exterior - Agrandar` (ID: 1763070000002)
- `Alerta Cámaras - Reset Manual` (ID: 1763070000003)

---

## 4. Preparar Sistema de Archivos

### A. Crear Directorio de Snapshots

**SSH al servidor:**

```bash
ssh nico@192.168.1.100

# Crear directorio
mkdir -p /config/www/snapshots

# Dar permisos
chmod 755 /config/www/snapshots

# Verificar
ls -la /config/www/

# Debe mostrar:
# drwxr-xr-x  2 root root 4096 Nov 14 snapshots

exit
```

---

### B. Subir Archivos Actualizados

**Desde tu Mac:**

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints

# Copiar configuration.yaml
scp HA_config_proxy/configuration.yaml nico@192.168.1.100:/config/

# Copiar automations.yaml
scp HA_config_proxy/automations.yaml nico@192.168.1.100:/config/
```

---

## 5. Reiniciar y Verificar

### A. Verificar Configuración

1. **Home Assistant** → **Configuración** → **Sistema** → **Reiniciar**
2. Click en **"COMPROBAR CONFIGURACIÓN"**
3. Debe decir: **"Configuración válida ✅"**

⚠️ Si hay errores, revisar logs antes de reiniciar.

---

### B. Reiniciar Home Assistant

1. **Configuración** → **Sistema** → **Reiniciar**
2. Click en **"REINICIAR"**
3. Esperar 2-3 minutos

---

### C. Verificar Helpers Creados

**Configuración** → **Dispositivos y servicios** → **Helpers**

Buscar:
```
✅ Cámara con Alerta Activa (camera_alert_active) → "none"
✅ Timestamp de Última Alerta (camera_alert_timestamp) → "0"
✅ Tipo de Última Alerta (camera_alert_type) → "Ninguna"
✅ Última Detección (camera_alert_last_trigger) → fecha/hora
```

---

### D. Verificar Automatizaciones

**Configuración** → **Automatizaciones y Escenas**

Buscar (deben estar **ACTIVADAS**):
```
✅ 📹 Entrada - Detección de Persona
✅ 📹 Entrada - Detección de Movimiento
✅ 📹 Exterior - Detección de Persona
✅ 📹 Exterior - Detección de Movimiento
✅ Reset Manual de Alertas de Cámaras
```

---

## 6. Probar Sistema

### Test 1: Binary Sensors Funcionan

**Herramientas para desarrolladores** → **Estados**

1. Buscar: `binary_sensor.tapo_c530ws_entrada_person`
2. Estado debe ser: `off`
3. **Caminar frente a la cámara de entrada**
4. Estado debe cambiar a: `on` (por unos segundos)
5. Vuelve a `off` automáticamente

✅ **Funciona:** Binary sensor detecta correctamente

---

### Test 2: Automatización Se Dispara

**Al caminar frente a cámara:**

1. Dashboard "maui" → Cámara se agranda ✅
2. Borde rojo pulsante ✅
3. Badge "🚨 DETECCIÓN ACTIVA" ✅
4. Llega notificación al móvil ✅
5. Alarma de cámara suena (si es persona) ✅
6. Luces se encienden (escena anochecer) ✅
7. Después de 30-60s vuelve a normal ✅

---

### Test 3: Snapshot Se Guarda

**SSH al servidor:**

```bash
ssh nico@192.168.1.100
ls -la /config/www/snapshots/

# Debe mostrar archivos .jpg con timestamp
# Ejemplo:
# entrada_20251114_153025.jpg
# exterior_motion_20251114_153128.jpg
```

---

### Test 4: Logs Funcionan

**Configuración** → **Logbook**

Buscar entradas:
```
🚨 Alerta Crítica
   PERSONA detectada en ENTRADA - 15:30:25

✅ Sistema de Alertas
   Alerta de ENTRADA finalizada
```

---

## 7. Personalización

### Cambiar Duración de Alerta

**En `automations.yaml`:**

```yaml
# Cambiar de 60 a 90 segundos para personas
- delay:
    seconds: 90

# Cambiar de 30 a 45 segundos para movimiento
- delay:
    seconds: 45
```

---

### Cambiar Condición de Activación

**Ejemplo: Solo alertar de noche**

```yaml
conditions:
  - condition: state
    entity_id: person.nico
    state: 'not_home'
  # AGREGAR:
  - condition: sun
    after: sunset
    before: sunrise
```

---

### Agregar Comportamiento Adicional

**Ejemplo: Enviar a Telegram**

```yaml
actions:
  # ... (acciones existentes)
  
  # AGREGAR:
  - service: notify.telegram
    data:
      title: "🚨 Alerta de Cámara"
      message: "Persona detectada en entrada"
```

---

## 8. Troubleshooting

### Problema: Binary sensors no existen

**Causa:** Integración no instalada correctamente

**Solución:**
1. Verificar que "Tapo: Cameras Control" esté instalada
2. Verificar control local habilitado en cámaras
3. Eliminar y re-agregar cámaras en integración
4. Reiniciar cámara físicamente (desenchufarla 10s)

---

### Problema: Automatización no se dispara

**Causa:** Condiciones no se cumplen

**Solución:**
1. Verificar `person.nico` existe
2. Cambiar condición temporalmente:
   ```yaml
   conditions: []  # Sin condiciones para probar
   ```
3. Ver logs de automatización

---

### Problema: Snapshot no se guarda

**Causa:** Permisos o directorio

**Solución:**
```bash
ssh nico@192.168.1.100
ls -la /config/www/
# Debe tener drwxr-xr-x para snapshots

# Si no:
chmod 755 /config/www/snapshots
chown -R root:root /config/www/snapshots
```

---

### Problema: Dashboard no agranda

**Causa:** Helper no actualiza

**Solución:**
1. Ver estado de `camera_alert_active` en Estados
2. Debe cambiar a `entrada` o `exterior`
3. Si no cambia, ver logs de automatización
4. Dashboard debe estar actualizado con V3

---

## 9. Checklist Final

Antes de dar por terminada la instalación:

- [ ] Integración "Tapo: Cameras Control" instalada
- [ ] Binary sensors existen y funcionan
- [ ] Helpers creados en HA
- [ ] Automatizaciones V3 agregadas y activadas
- [ ] Directorio `/config/www/snapshots/` creado
- [ ] Configuration y automations copiados al servidor
- [ ] HA reiniciado sin errores
- [ ] Test de binary sensor OK
- [ ] Test de automatización OK
- [ ] Test de snapshot OK
- [ ] Test de logs OK
- [ ] Dashboard funciona correctamente

---

## 10. Próximos Pasos

Una vez que el sistema V3 está funcionando:

1. **Ajustar sensibilidad** de detección en app Tapo
2. **Configurar zonas** de detección en app Tapo
3. **Personalizar comportamientos** según tus necesidades
4. **Monitorear falsos positivos** primeros días
5. **Agregar más encadenamientos** (alarma, grabación, etc.)

---

## 📚 Documentación Completa

- **Integración:** `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md`
- **Sistema V3:** `docs/CAMERA_ALERTS_V3.md`
- **Automatizaciones:** `examples/camera_alert_system_v3.yaml`

---

**¿Problemas?** Consulta `docs/CAMERA_ALERTS_V3.md` sección Troubleshooting.

