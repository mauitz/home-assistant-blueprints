# 📊 RESUMEN DE INVESTIGACIÓN - Sistema de Cámaras

**Fecha:** 14 de Noviembre, 2025
**Investigación solicitada por:** Maui

---

## 🎯 Lo que Pediste Investigar

1. ✅ Automatizaciones corriendo en el servidor
2. ✅ Cámara Xiaomi configurada que no se ve en HA
3. ✅ Modelo de cámara y cómo está integrada
4. ✅ Si se puede integrar con Frigate para detección

---

## 📋 HALLAZGOS PRINCIPALES

### 1️⃣ AUTOMATIZACIONES EN EL SERVIDOR

**Total de automatizaciones:** 41
**Automatizaciones activas:** 12
**Automatizaciones deshabilitadas/unavailable:** 29

#### ✅ Automatizaciones Activas de Cámaras:

| Nombre | Trigger | Último Uso |
|--------|---------|------------|
| 🚨 Frigate - Entrada - PERSONA | `binary_sensor.entrada_person_occupancy` | Nunca |
| 🚗 Frigate - Entrada - VEHÍCULO | `binary_sensor.entrada_car_occupancy` | Nunca |
| 🚨 Frigate - Exterior - PERSONA | `binary_sensor.exterior_person_occupancy` | Nunca |
| 🚗 Frigate - Exterior - VEHÍCULO | `binary_sensor.exterior_car_occupancy` | **✅ 14 Nov, 16:43** |
| 🐕 Frigate - Entrada - ANIMAL | `binary_sensor.entrada_dog/cat_occupancy` | Nunca |
| Reset Manual V3.3 | Manual trigger | Nunca |
| Test Manual V3.3 | Manual trigger | Nunca |

**Estado:** ✅ Las automatizaciones de Frigate están funcionando correctamente.
**Evidencia:** La detección de vehículo en exterior se activó hoy a las 16:43.

#### ❌ Automatización Antigua de Cámara Xiaomi:

```yaml
- id: '1759933195350'
  alias: Cámara - Grabación con snapshot
  triggers:
  - entity_id: sensor.chuangmi_us_447604776_029a02_status_p_4_1
    from: Idle
    to: Recording
```

**Estado:** ❌ Activa pero no funcional
**Problema:** Intenta capturar snapshot de `camera.front_door_cam` que NO EXISTE

---

### 2️⃣ CÁMARA XIAOMI - INFORMACIÓN COMPLETA

#### 📹 Identificación:

- **Modelo:** Chuangmi Camera (Xiaomi Mijia)
- **Nombre en HA:** "Front door cam"
- **Device ID:** `chuangmi_camera_029a02`
- **Device ID MIoT:** `chuangmi.camera.us.447604776.029a02`
- **Integración:** `xiaomi_home` (custom component vía HACS)
- **Estado de conectividad:** ✅ Conectada (`home`)

#### 📡 Entidades Disponibles (35 entidades):

**Device Tracker:**
```
device_tracker.chuangmi_camera_029a02
```

**Sensores (6):**
- `sensor.chuangmi_us_447604776_029a02_status_p_4_1` → Estado: "Idle" ⚠️
- `sensor.chuangmi_us_447604776_029a02_storage_total_space_p_4_2` → 238 GB
- `sensor.chuangmi_us_447604776_029a02_storage_free_space_p_4_3` → 32 MB (99% lleno!)
- `sensor.chuangmi_us_447604776_029a02_storage_used_space_p_4_4` → 238 GB
- `sensor.chuangmi_us_447604776_029a02_stream_status_p_7_9` → Google Home: Available
- `sensor.chuangmi_us_447604776_029a02_stream_status_p_8_9` → Alexa: Available

**Switches (6):**
- `switch.chuangmi_us_447604776_029a02_on_p_2_1` → Encendido: ON ✅
- `switch.chuangmi_us_447604776_029a02_motion_detection_p_5_1` → Detección: ON ✅
- `switch.chuangmi_us_447604776_029a02_motion_tracking_p_2_8` → Tracking: ON ✅
- `switch.chuangmi_us_447604776_029a02_wdr_mode_p_2_5` → WDR: OFF
- `switch.chuangmi_us_447604776_029a02_glimmer_full_color_p_2_6` → Full Color: ON
- `switch.chuangmi_us_447604776_029a02_time_watermark_p_2_9` → Watermark: OFF

**Selects (3):**
- `select.chuangmi_us_447604776_029a02_night_shot_p_2_3` → Auto
- `select.chuangmi_us_447604776_029a02_recording_mode_p_2_7` → **Not Recording** ⚠️
- `select.chuangmi_us_447604776_029a02_detection_sensitivity_p_5_3` → Low

**Numbers (3):**
- `number.chuangmi_us_447604776_029a02_image_rollover_p_2_2` → 0°
- `number.chuangmi_us_447604776_029a02_alarm_interval_p_5_2` → 10 seg
- `number.chuangmi_us_447604776_029a02_volume_p_9_1` → 100%

**Buttons (9):**
- Botones de formato de SD
- Botones de inicio/stop de streaming P2P
- Botones de configuración de streams

**Light (1):**
- `light.chuangmi_us_447604776_029a02_s_3_indicator_light` → OFF

**Text (2):**
- Horarios de detección de movimiento: 00:00:00 - 23:59:00

#### ❌ Entidades que NO EXISTEN:

- **Camera entity** (`camera.front_door_cam`) → ❌
- **Binary sensor de movimiento** → ❌
- **Binary sensor de persona** → ❌
- **Binary sensor de detección IA** → ❌

---

### 3️⃣ PROBLEMA IDENTIFICADO

**La integración `xiaomi_home` NO proporciona:**

1. ❌ **Stream de video visible en Home Assistant**
2. ❌ **Entidad de cámara (`camera.*`)**
3. ❌ **Binary sensors de detección**
4. ❌ **Eventos de detección inteligente**

**Lo que SÍ proporciona:**

1. ✅ Control on/off de la cámara
2. ✅ Estado de grabación (Idle/Recording)
3. ✅ Información de almacenamiento
4. ✅ Configuración de sensibilidad y modos
5. ✅ Control de tracking y movimiento

**Conclusión:** La integración `xiaomi_home` es para **CONTROL** de la cámara, NO para **VISUALIZACIÓN** ni **DETECCIÓN INTELIGENTE**.

---

### 4️⃣ FRIGATE - ESTADO ACTUAL

**✅ Frigate está INSTALADO y FUNCIONANDO**

#### Cámaras integradas con Frigate:

1. **Cámara Entrada (Tapo C530WS)**
   - Entity: `camera.entrada`
   - Estado: `recording` ✅
   - Detección IA: ✅ Activa
   - Binary sensors: ✅ Funcionando

2. **Cámara Exterior (Tapo C310)**
   - Entity: `camera.exterior`
   - Estado: `recording` ✅
   - Detección IA: ✅ Activa
   - Binary sensors: ✅ Funcionando

#### Binary Sensors disponibles de Frigate:

**Entrada:**
- `binary_sensor.entrada_person_occupancy`
- `binary_sensor.entrada_car_occupancy`
- `binary_sensor.entrada_dog_occupancy`
- `binary_sensor.entrada_cat_occupancy`

**Exterior:**
- `binary_sensor.exterior_person_occupancy`
- `binary_sensor.exterior_car_occupancy`
- Y más...

**Estado:** ✅ Sistema Frigate completamente funcional

---

## 💡 RESPUESTA A TU PREGUNTA

### "¿Puedo integrar la cámara Xiaomi con Frigate para detección y video?"

**Respuesta: ✅ SÍ, PERO...**

Necesitas que la cámara exponga un **stream RTSP**.

### Pasos para verificar:

#### 1️⃣ Obtener IP de la Cámara

**Opción A:** En la app Xiaomi Home
- Abrir app → Front door cam → Configuración → Info del dispositivo → IP

**Opción B:** En tu router
- Buscar dispositivo "chuangmi_camera_029a02"
- O buscar por MAC address

**Opción C:** Escanear red
- Usar "Angry IP Scanner" o similar
- Buscar dispositivos Xiaomi

#### 2️⃣ Probar acceso RTSP

Una vez tengas la IP, probar estas URLs RTSP comunes:

```bash
# En tu Mac o servidor (necesitas ffmpeg)
ffmpeg -i "rtsp://admin:admin@IP_CAMARA:554/live/ch0" -frames:v 1 test.jpg
ffmpeg -i "rtsp://admin:admin@IP_CAMARA:554/stream1" -frames:v 1 test.jpg
ffmpeg -i "rtsp://admin:admin@IP_CAMARA:8554/live" -frames:v 1 test.jpg
ffmpeg -i "rtsp://root:@IP_CAMARA:554/live/ch0" -frames:v 1 test.jpg
```

**Credenciales comunes:**
- admin / admin
- root / (sin password)
- admin / (sin password)
- O tus credenciales de Xiaomi

#### 3️⃣ Si RTSP funciona → Integrar con Frigate

Editar `/home/nico/frigate/config/config.yml`:

```yaml
cameras:
  # ... cámaras existentes ...

  puerta_frontal:
    enabled: true

    ffmpeg:
      inputs:
        # Stream para grabación (alta calidad)
        - path: rtsp://admin:password@IP_CAMARA:554/stream1
          roles:
            - record

        # Stream para detección (baja calidad, ahorra CPU)
        - path: rtsp://admin:password@IP_CAMARA:554/stream2
          roles:
            - detect

    detect:
      width: 1920
      height: 1080
      fps: 5

    objects:
      track:
        - person
        - car
        - dog
        - cat
      filters:
        person:
          min_area: 5000
          threshold: 0.75

    snapshots:
      enabled: true
      timestamp: true
      bounding_box: true

    record:
      enabled: true
      retain:
        days: 7
```

Reiniciar Frigate:
```bash
ssh nico@192.168.1.100
docker restart frigate
```

#### 4️⃣ Si RTSP NO funciona → Alternativas

**Opción A:** Instalar firmware custom
- Xiaomi Dafang Hacks: https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks
- ⚠️ Requiere conocimientos técnicos
- ⚠️ Puede invalidar garantía

**Opción B:** Reemplazar cámara
- Tapo C310/C320WS (~$30-50 USD)
- Reolink E1 Pro
- Cualquier cámara con RTSP

---

## 📊 COMPARATIVA: Estado Actual vs Con Frigate

### Cámara Xiaomi ACTUAL (sin Frigate):

| Característica | Estado |
|----------------|--------|
| Stream visible en HA | ❌ No |
| Detección de personas | ❌ No (solo motion básico) |
| Detección de vehículos | ❌ No |
| Binary sensors | ❌ No |
| Snapshots | ❌ No |
| Automatizaciones avanzadas | ❌ Limitadas |
| Grabación | ⚠️ Solo en SD (99% llena) |

### Cámara Xiaomi CON FRIGATE (si tiene RTSP):

| Característica | Estado |
|----------------|--------|
| Stream visible en HA | ✅ Sí |
| Detección de personas | ✅ Sí (IA YOLO) |
| Detección de vehículos | ✅ Sí (IA YOLO) |
| Binary sensors | ✅ Sí (`binary_sensor.puerta_frontal_person_occupancy`) |
| Snapshots | ✅ Sí (con bounding boxes) |
| Automatizaciones avanzadas | ✅ Ilimitadas |
| Grabación | ✅ Servidor + SD |

---

## 🎯 PLAN DE ACCIÓN RECOMENDADO

### Paso 1: Obtener IP de la cámara
Revisar en app Xiaomi Home o router

### Paso 2: Probar RTSP
```bash
# Ejecutar desde tu Mac o desde el servidor
python3 get_xiaomi_camera_info.py
# El script te dará comandos específicos con la IP
```

### Paso 3A: Si RTSP funciona
1. Agregar configuración a Frigate
2. Reiniciar Frigate
3. Crear automatizaciones con binary sensors
4. ¡Disfrutar de detección IA! 🎉

### Paso 3B: Si RTSP NO funciona
1. Evaluar instalar firmware custom (riesgoso)
2. O considerar reemplazar por cámara Tapo (~$35)
3. Mantener cámara Xiaomi como está (solo control)

---

## 📝 ARCHIVOS GENERADOS

1. **`investigate_cameras.py`** → Script de investigación completo
2. **`get_xiaomi_camera_info.py`** → Script para info de cámara Xiaomi
3. **`camera_investigation_report.json`** → Reporte JSON completo
4. **`docs/INFORME_CAMARA_XIAOMI.md`** → Informe detallado
5. **`RESUMEN_INVESTIGACION.md`** → Este resumen (lo estás leyendo)

---

## ⚠️ OBSERVACIONES ADICIONALES

### 1. Tarjeta SD llena (99%)
```
Storage: 238 GB total, 32 MB libres
```
**Acción recomendada:** Formatear o limpiar grabaciones antiguas

### 2. Modo de grabación en "Not Recording"
```
select.chuangmi_us_447604776_029a02_recording_mode_p_2_7: Not Recording
```
**Posible problema:** Cámara no está grabando por SD llena

### 3. Logs de desconexión MIoT
La integración `xiaomi_home` tiene desconexiones frecuentes del protocolo MIoT.
**Esto es normal** con esta integración.

---

## 🔗 RECURSOS ÚTILES

- **Frigate Docs:** https://docs.frigate.video
- **Xiaomi Camera Hacks:** https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks
- **Integración Tapo (HACS):** https://github.com/JurajNyiri/HomeAssistant-Tapo-Control
- **Cámaras compatibles con Frigate:** https://docs.frigate.video/frigate/camera_setup

---

## 📞 CONTACTO Y SIGUIENTE PASO

**Para continuar:**
1. Obtén la IP de la cámara Xiaomi
2. Ejecuta: `python3 get_xiaomi_camera_info.py`
3. Prueba los comandos RTSP que te sugiera el script
4. Avísame si RTSP funciona o no

**Si RTSP funciona:** Te ayudo a configurar Frigate
**Si RTSP no funciona:** Evaluamos alternativas

---

**Investigación completada:** 14 de Noviembre, 2025
**Scripts listos para usar:** ✅
**Próximo paso:** Verificar RTSP de la cámara Xiaomi

