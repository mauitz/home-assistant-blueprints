# 🔍 DIAGNÓSTICO: Problemas con Cámara C310 (Exterior)

## 📋 **PROBLEMAS REPORTADOS**

1. **❌ No funciona tan fluida como la C530WS**
2. **❌ No detecta personas cuando están paradas debajo de la cámara**

---

## 🔎 **ANÁLISIS DE LOGS**

### **Errores Encontrados en Frigate:**

```
[ERROR] entrada: Connection timed out
[ERROR] entrada: ffmpeg process crashed unexpectedly
[ERROR] entrada: Non-monotonic DTS (timestamps incorrectos)
[ERROR] entrada: CSeq errors (problemas RTSP)
[ERROR] entrada: Failed to sync surface (error de hardware decoding)
```

**⚠️ IMPORTANTE:** Los errores son de la cámara **ENTRADA** (C530WS), no de la EXTERIOR (C310).

---

## 🚨 **DIAGNÓSTICO**

### **Problema Principal: Conexión RTSP Inestable**

Los errores indican que:
1. **Red WiFi saturada o débil** → Cámara pierde conexión
2. **Stream RTSP con timestamps incorrectos** → Grabación se corta
3. **Hardware decoding fallando** → CPU sobrecargado

### **Problema Secundario: Detección de Personas Paradas**

Frigate detecta **movimiento primero**, luego aplica IA. Si una persona está **parada sin moverse**, Frigate puede:
- No detectarla inicialmente (sin motion)
- Perder tracking si estuvo inmóvil > 25 frames (~5 segundos)

---

## ✅ **SOLUCIONES**

### **1. MEJORAR CONEXIÓN RTSP (PRIORITARIO)**

#### **A. Verificar Red WiFi de las Cámaras:**

```bash
# Desde el servidor, ping a las cámaras
ping -c 10 192.168.1.20  # Entrada C530WS
ping -c 10 192.168.1.21  # Exterior C310

# Ver latencia y pérdida de paquetes
# Ideal: <5ms latencia, 0% pérdida
# Problemático: >20ms o >1% pérdida
```

**Si hay problemas de red:**
- Acercar cámaras al router
- Usar repetidor WiFi
- Considerar cable ethernet (ideal)

#### **B. Reducir Carga del Stream RTSP:**

Editar `/opt/server/containers/frigate/config/config.yml`:

```yaml
cameras:
  entrada:
    detect:
      fps: 3  # ← Reducir de 5 a 3 (menos carga de red)
      
    ffmpeg:
      inputs:
        - path: rtsp://PezAustral:R3spons3@192.168.1.20:554/stream2
          roles:
            - detect
          input_args: preset-rtsp-restream  # ← Agregar
      
      output_args:
        detect: -f rawvideo -pix_fmt yuv420p  # ← Más eficiente
        record: preset-record-generic-audio-copy  # ← Sin recodificar

  exterior:
    detect:
      fps: 3  # ← Reducir de 5 a 3
      
    ffmpeg:
      inputs:
        - path: rtsp://PezAustral:R3spons3@192.168.1.21:554/stream2
          roles:
            - detect
          input_args: preset-rtsp-restream
      
      output_args:
        detect: -f rawvideo -pix_fmt yuv420p
        record: preset-record-generic-audio-copy
```

#### **C. Deshabilitar Hardware Decoding (Si Falla):**

```yaml
ffmpeg:
  hwaccel_args: []  # ← Vacío = no usar aceleración hardware
```

---

### **2. MEJORAR DETECCIÓN DE PERSONAS PARADAS**

#### **A. Reducir `max_disappeared` (Tracking más persistente):**

```yaml
cameras:
  exterior:
    detect:
      max_disappeared: 50  # ← Aumentar de 25 a 50 frames (~10 segundos)
      
    objects:
      filters:
        person:
          min_area: 3000      # ← Reducir (detectar personas más lejos/pequeñas)
          threshold: 0.65     # ← Reducir (menos estricto)
          min_score: 0.5      # ← Reducir (aceptar scores más bajos)
          min_ratio: 0.3      # ← Agregar (detectar personas agachadas/sentadas)
          max_ratio: 5.0
```

#### **B. Agregar Zona Específica (Debajo de la Cámara):**

```yaml
cameras:
  exterior:
    zones:
      entrada_directa:
        coordinates: 200,300,440,300,440,360,200,360  # ← Ajustar según vista
        inertia: 5  # Más tolerante a pausas
        objects:
          - person
          
    objects:
      filters:
        person:
          min_area: 2000  # Más sensible en zona cercana
          threshold: 0.6
```

**Para obtener coordenadas correctas:**
1. Ir a: `http://192.168.1.100:5000/cameras/exterior/editor`
2. Dibujar zona con el mouse
3. Copiar coordenadas generadas

#### **C. Aumentar FPS de Motion Detection (Más sensible):**

```yaml
cameras:
  exterior:
    motion:
      threshold: 20        # ← Reducir (más sensible)
      contour_area: 50     # ← Reducir (detectar movimientos pequeños)
      delta_alpha: 0.1     # ← Más sensible a cambios
      frame_alpha: 0.1
```

---

### **3. VERIFICAR CONFIGURACIÓN DE CÁMARAS EN APP TAPO**

#### **C310 Exterior - Configuración Recomendada:**

```
App Tapo → C310 → Configuración:

📹 VIDEO:
- Resolución Stream Principal: 1080p
- Resolución Stream Secundario: 360p ✅
- FPS: 15 fps
- Bitrate: Auto

🔔 DETECCIÓN:
- Detección de Movimiento: ON
- Sensibilidad: Media-Alta
- Detección de Personas: ON ✅
- Zona de Detección: Toda el área

💡 ILUMINACIÓN:
- Visión Nocturna: Auto
- Floodlight: Manual/Auto según preferencia

⚙️ AVANZADO:
- Protocolo RTSP: ON ✅
- Usuario RTSP: PezAustral
- Calidad Stream: Fluida (no Ultra)
```

---

## 🧪 **TESTING PASO A PASO**

### **Test 1: Verificar Conexión RTSP**

```bash
ssh nico@192.168.1.100

# Probar stream de la C310
ffmpeg -rtsp_transport tcp \
       -i "rtsp://PezAustral:R3spons3@192.168.1.21:554/stream2" \
       -frames:v 30 \
       -f null - \
       2>&1 | grep -E "fps|bitrate|error"

# Debe mostrar:
# fps=15 (o similar)
# bitrate estable
# SIN errores de conexión
```

### **Test 2: Verificar Detección en Frigate UI**

```
1. Ir a: http://192.168.1.100:5000
2. Click en cámara "exterior"
3. Activar "Show Objects" + "Show Motion Boxes"
4. Pararte debajo de la cámara
5. Moverte lentamente
6. Verificar:
   - Motion boxes aparecen? (verde)
   - Object boxes aparecen? (azul para person)
   - Tracking ID se mantiene?
```

### **Test 3: Probar Notificación Manual**

```bash
# Desde Home Assistant → Herramientas de desarrollador → Servicios

# Forzar estado del sensor
service: input_text.set_value
target:
  entity_id: input_text.camera_alert_active
data:
  value: "exterior"
  
# Debe:
- Widget agrandarse
- NO enviar notificación (solo al detectar realmente)
```

---

## 📝 **CONFIGURACIÓN OPTIMIZADA COMPLETA**

```yaml
cameras:
  exterior:
    enabled: true
    
    ffmpeg:
      inputs:
        - path: rtsp://PezAustral:R3spons3@192.168.1.21:554/stream2
          roles:
            - detect
          input_args: preset-rtsp-restream
        - path: rtsp://PezAustral:R3spons3@192.168.1.21:554/stream1
          roles:
            - record
      output_args:
        detect: -f rawvideo -pix_fmt yuv420p
        record: preset-record-generic-audio-copy
    
    detect:
      width: 640
      height: 360
      fps: 3                    # ← Reducido para estabilidad
      enabled: true
      max_disappeared: 50       # ← Aumentado para tracking persistente
    
    motion:
      threshold: 20             # ← Más sensible
      contour_area: 50          # ← Más sensible
      delta_alpha: 0.1
      frame_alpha: 0.1
    
    zones:
      zona_cercana:
        coordinates: 200,250,440,250,440,360,200,360
        inertia: 5              # Tolera 5 frames sin movimiento
        objects:
          - person
    
    objects:
      track:
        - person
        - car
        - dog
        - cat
      
      filters:
        person:
          min_area: 3000        # ← Reducido (más sensible)
          max_area: 100000
          threshold: 0.65       # ← Reducido (menos estricto)
          min_score: 0.5        # ← Reducido
          min_ratio: 0.3        # ← Detectar personas agachadas
          max_ratio: 5.0
          # Si quieres solo alertar en zona cercana:
          # required_zones: ["zona_cercana"]
    
    snapshots:
      enabled: true
      timestamp: true
      bounding_box: true
      crop: false
      required_zones: []        # Snapshots en toda el área
    
    record:
      enabled: true
      retain:
        days: 7
        mode: motion
```

---

## 🚀 **APLICAR CAMBIOS**

```bash
# 1. SSH al servidor
ssh nico@192.168.1.100

# 2. Backup de config actual
sudo cp /opt/server/containers/frigate/config/config.yml{,.backup}

# 3. Editar config
sudo nano /opt/server/containers/frigate/config/config.yml

# 4. Aplicar cambios recomendados arriba

# 5. Reiniciar Frigate
docker restart frigate

# 6. Ver logs (buscar errores)
docker logs -f frigate | grep -E "exterior|ERROR|WARN"

# 7. Probar detección
#    - Ir a Frigate UI: http://192.168.1.100:5000
#    - Pararte debajo de cámara exterior
#    - Verificar que se detecta
```

---

## ✅ **CHECKLIST DE VERIFICACIÓN**

- [ ] Ping a cámaras < 10ms sin pérdida de paquetes
- [ ] FPS reducido a 3 en ambas cámaras
- [ ] `max_disappeared` aumentado a 50
- [ ] `threshold` reducido a 0.65 para exterior
- [ ] `min_area` reducido a 3000 para exterior
- [ ] Zona definida para área cercana
- [ ] Frigate reiniciado sin errores en logs
- [ ] Motion boxes visibles en Frigate UI
- [ ] Detección de persona parada funciona
- [ ] Notificación llega al celular correctamente

---

## 🆘 **SI SIGUE SIN FUNCIONAR**

### **Opción A: Verificar con VLC**

```bash
# En tu Mac/PC
vlc rtsp://PezAustral:R3spons3@192.168.1.21:554/stream2

# Verificar:
- Stream se ve fluido?
- Hay cortes o pixelación?
- Latencia aceptable?
```

### **Opción B: Logs Detallados**

```bash
# Activar debug en Frigate
sudo nano /opt/server/containers/frigate/config/config.yml

# Agregar:
logger:
  default: debug
  logs:
    frigate.event: debug
    frigate.object_detection: debug
    detector.cpu1: debug

# Reiniciar y ver logs
docker restart frigate
docker logs -f frigate | grep "exterior"
```

### **Opción C: Estadísticas de Detección**

```bash
# Ver stats de Frigate
curl http://192.168.1.100:5000/api/stats | jq '.cameras.exterior'

# Buscar:
# - detection_fps: Debe ser ~3
# - process_fps: Debe ser cercano a detection_fps
# - skipped_fps: Debe ser 0 o muy bajo
# - camera_fps: Debe ser estable (15-20)
```

---

**Fecha:** 2025-11-14  
**Cámara:** Tapo C310 (Exterior)  
**Problema:** Detección no fluida + No detecta personas paradas

