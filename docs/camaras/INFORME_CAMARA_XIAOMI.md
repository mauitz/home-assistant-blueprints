# 🔍 Informe de Investigación - Cámara Xiaomi y Sistema de Cámaras

**Fecha:** 14 de Noviembre, 2025
**Estado del Sistema:** ✅ Operativo con Frigate

---

## 📊 Resumen Ejecutivo

Se realizó una investigación completa del sistema de cámaras en Home Assistant. A continuación se detallan los hallazgos:

### ✅ Estado General:
- **Frigate:** ✅ Instalado y funcionando
- **Cámaras Tapo:** ✅ 2 cámaras integradas con Frigate (Entrada + Exterior)
- **Cámara Xiaomi:** ⚠️ Integrada pero sin detección inteligente
- **Automatizaciones:** ✅ 8 automatizaciones activas con Frigate

---

## 🏠 Cámara Xiaomi - Hallazgos Principales

### 📹 Identificación:
- **Modelo:** Chuangmi Camera (Xiaomi Mijia)
- **ID Dispositivo:** `chuangmi_camera_029a02`
- **Nombre Amigable:** "Front door cam"
- **Integración:** `xiaomi_home` (custom component)
- **Estado:** Conectada y operativa

### 📡 Entidades Disponibles:

#### 1. Device Tracker
```
Entity: device_tracker.chuangmi_camera_029a02
Estado: home
```

#### 2. Sensor de Estado de Grabación
```
Entity: sensor.chuangmi_us_447604776_029a02_status_p_4_1
Estado actual: Idle
Valores posibles: Idle, None, Full, Broken, Formating, Ejected, Ejecting, Format
```
⚠️ **Este sensor solo indica si está grabando (Idle/Recording), NO detecta personas u objetos**

#### 3. Sensores de Almacenamiento
- `sensor.chuangmi_us_447604776_029a02_storage_total_space_p_4_2`: 243,936 MB (238 GB)
- `sensor.chuangmi_us_447604776_029a02_storage_free_space_p_4_3`: 32 MB
- `sensor.chuangmi_us_447604776_029a02_storage_used_space_p_4_4`: 243,904 MB (99% usado)

#### 4. Sensores de Stream
- Stream Google Home: Available
- Stream Amazon Alexa: Available

### ❌ Entidades NO Disponibles:
- **Binary Sensor de Movimiento:** ❌ No existe
- **Binary Sensor de Persona:** ❌ No existe
- **Camera Entity:** ❌ No se puede visualizar stream en HA
- **Detección de Objetos:** ❌ No disponible

### 🔴 PROBLEMA IDENTIFICADO:

La integración `xiaomi_home` **NO proporciona:**
1. ❌ Stream de video visible en Home Assistant
2. ❌ Binary sensors de detección de movimiento
3. ❌ Binary sensors de detección de personas
4. ❌ Eventos de detección para automatizaciones

**Solo proporciona:**
- ✅ Estado básico (Idle/Recording)
- ✅ Información de almacenamiento
- ✅ Estado de conectividad

---

## 📷 Sistema de Cámaras Actual

### ✅ Cámaras Tapo con Frigate

#### 1. Cámara Tapo C530WS - Entrada
```
Frigate Entity: camera.entrada
Estado: recording
Integración: Frigate
```
**Características:**
- ✅ Detección con IA (personas, vehículos, animales)
- ✅ Binary sensors activos
- ✅ Stream visible en HA
- ✅ Grabación continua
- ✅ Snapshots con bounding boxes

**Binary Sensors Disponibles:**
- `binary_sensor.entrada_person_occupancy`
- `binary_sensor.entrada_car_occupancy`
- `binary_sensor.entrada_dog_occupancy`
- `binary_sensor.entrada_cat_occupancy`
- Y más...

#### 2. Cámara Tapo C310 - Exterior
```
Frigate Entity: camera.exterior
Estado: recording
Integración: Frigate
```
**Características:**
- ✅ Detección con IA (personas, vehículos, animales)
- ✅ Binary sensors activos
- ✅ Stream visible en HA
- ✅ Grabación continua
- ✅ Snapshots con bounding boxes

**Binary Sensors Disponibles:**
- `binary_sensor.exterior_person_occupancy`
- `binary_sensor.exterior_car_occupancy`
- Y más...

### 📊 Estadísticas:
- **Total de cámaras en HA:** 8 entidades
- **Cámaras funcionales con Frigate:** 2 (Entrada + Exterior)
- **Cámaras Xiaomi:** 1 (sin detección IA)

---

## 🤖 Automatizaciones Activas

### ✅ Automatizaciones de Frigate (V3.3):

1. **🚨 Frigate - Entrada - PERSONA**
   - Trigger: `binary_sensor.entrada_person_occupancy`
   - Estado: ✅ Activa
   - Último trigger: Ninguno

2. **🚗 Frigate - Entrada - VEHÍCULO**
   - Trigger: `binary_sensor.entrada_car_occupancy`
   - Estado: ✅ Activa
   - Último trigger: Ninguno

3. **🚨 Frigate - Exterior - PERSONA**
   - Trigger: `binary_sensor.exterior_person_occupancy`
   - Estado: ✅ Activa
   - Último trigger: Ninguno

4. **🚗 Frigate - Exterior - VEHÍCULO**
   - Trigger: `binary_sensor.exterior_car_occupancy`
   - Estado: ✅ Activa
   - **Último trigger: 14 Nov 2025, 16:43:46** ✅

5. **🐕 Frigate - Entrada - ANIMAL**
   - Trigger: `binary_sensor.entrada_dog_occupancy` / `entrada_cat_occupancy`
   - Estado: ✅ Activa
   - Último trigger: Ninguno

### 🟡 Automatización Antigua de Cámara Xiaomi:

```yaml
- id: '1759933195350'
  alias: Cámara - Grabación con snapshot
  triggers:
  - entity_id: sensor.chuangmi_us_447604776_029a02_status_p_4_1
    from: Idle
    to: Recording
```

**Estado:** ❌ No funcional (cámara no genera entidad `camera.front_door_cam`)

---

## 💡 Soluciones Propuestas

### ✅ Opción 1: Integrar Cámara Xiaomi con Frigate (RECOMENDADO)

**Si la cámara Xiaomi soporta RTSP, podemos integrarla con Frigate para:**
- ✅ Ver stream en Home Assistant
- ✅ Detección de personas con IA
- ✅ Detección de vehículos
- ✅ Snapshots con bounding boxes
- ✅ Grabación inteligente
- ✅ Binary sensors para automatizaciones

#### Pasos necesarios:

1. **Verificar soporte RTSP de la cámara Xiaomi:**
   - Modelo: Chuangmi Camera
   - Buscar en documentación o app si tiene RTSP
   - Obtener URL RTSP

2. **Agregar a configuración de Frigate:**
   ```yaml
   cameras:
     puerta_frontal:
       enabled: true
       ffmpeg:
         inputs:
           - path: rtsp://usuario:password@IP_CAMARA:554/stream1
             roles:
               - detect
               - record
       detect:
         width: 1920
         height: 1080
         fps: 5
       objects:
         track:
           - person
           - car
   ```

3. **Reiniciar Frigate**

4. **Verificar detección en UI de Frigate:** `http://192.168.1.100:5000`

5. **Usar binary sensors en automatizaciones**

---

### 🔍 Opción 2: Verificar Integración Alternativa

Si la cámara NO soporta RTSP, buscar integraciones alternativas:
- **Xiaomi Miio:** Integración para dispositivos Xiaomi
- **Hack de firmware:** Algunos modelos permiten habilitar RTSP
- **Xiaomi Cloud:** Acceso a través de cloud (no recomendado)

---

## 📋 Modelo de la Cámara Xiaomi

Basado en los datos recopilados:

- **Fabricante:** Xiaomi (Chuangmi)
- **ID del Dispositivo:** `chuangmi_us_447604776_029a02`
- **Tipo:** Cámara IP con almacenamiento local (256 GB SD)
- **Conectividad:** WiFi (conectada a red local)
- **Streams:** Compatible con Google Home y Amazon Alexa

**Modelo probable:**
- Chuangmi 360 Smart Camera 2K Pro
- O variante similar de la serie Chuangmi

---

## 🎯 Recomendación Final

### ✅ INTEGRAR CON FRIGATE

**Razones:**
1. Ya tienes Frigate instalado y funcionando
2. Frigate proporciona detección IA superior
3. Binary sensors para automatizaciones avanzadas
4. Grabación inteligente (solo eventos importantes)
5. Mejor integración con Home Assistant
6. Notificaciones con snapshots procesados

**Ventajas adicionales:**
- Todas las cámaras en un solo sistema
- UI unificada en Frigate
- Timeline de eventos
- Búsqueda de eventos por objeto
- Menor uso de ancho de banda (detección local)

---

## 📞 Próximos Pasos

### 1. Verificar RTSP en Cámara Xiaomi:

```bash
# Conectar al servidor
ssh nico@192.168.1.100

# Intentar acceder a stream RTSP (necesitas IP de la cámara)
ffmpeg -i rtsp://admin:password@IP_CAMARA:554/stream1 -frames:v 1 test.jpg

# Si funciona, verás una imagen test.jpg
```

### 2. Obtener IP de la Cámara:

Desde HA Developer Tools → States, buscar:
```
device_tracker.chuangmi_camera_029a02
```
Y revisar atributos para encontrar IP.

### 3. Una vez confirmado RTSP:

1. Modificar `/home/nico/frigate/config/config.yml`
2. Agregar configuración de cámara Xiaomi
3. Reiniciar Frigate: `docker restart frigate`
4. Verificar en UI: `http://192.168.1.100:5000`
5. Crear automatizaciones con nuevos binary sensors

---

## 📊 Comparativa: Antes vs Después

| Característica | SIN Frigate | CON Frigate |
|----------------|-------------|-------------|
| Stream en HA | ❌ No visible | ✅ Visible |
| Detección IA | ❌ No | ✅ Personas, autos, animales |
| Binary Sensors | ❌ No | ✅ Sí |
| Snapshots | ❌ No | ✅ Con bounding boxes |
| Grabación | ⚠️ Solo en SD | ✅ Servidor + SD |
| Automatizaciones | ⚠️ Limitadas | ✅ Avanzadas |
| Falsos positivos | ⚠️ Muchos | ✅ Mínimos (IA) |

---

## 📝 Notas Técnicas

### Integración xiaomi_home:
- Es una integración custom (no oficial)
- Usa protocolo MIoT (Xiaomi IoT)
- Problemas conocidos de desconexión (ver logs)
- No está diseñada para streaming de video
- Principalmente para control de dispositivos IoT

### Logs de desconexión detectados:
```
ERROR [custom_components.xiaomi_home.miot.miot_client]
ha.1f7fcb24b1b719704dbda521f9094561, mips disconnect, 7, None
ha.1f7fcb24b1b719704dbda521f9094561, mips try reconnect after 10s
```
Estas desconexiones son normales con esta integración.

---

**Elaborado por:** Sistema de Investigación Automatizado
**Para:** Maui - Home Assistant Blueprints
**Contacto:** Ejecutar `python3 investigate_cameras.py` para actualizar este informe

