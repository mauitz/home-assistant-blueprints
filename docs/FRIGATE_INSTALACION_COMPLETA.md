# 🎥 Instalación Completa de Frigate - Detección Inteligente

## 📋 **¿Qué es Frigate?**

Frigate es un **sistema de análisis de video con IA** que:
- ✅ Detecta **personas, vehículos, animales, etc.**
- ✅ Genera **binary sensors** para Home Assistant
- ✅ Grabación inteligente (solo cuando detecta algo)
- ✅ Timeline visual de eventos
- ✅ Snapshots automáticos con bounding boxes
- ✅ Notificaciones con imágenes procesadas
- ✅ Usa **modelos YOLO** (estado del arte en detección de objetos)

---

## 🖥️ **Requisitos del Sistema**

### **Mínimos:**
- CPU: 4 cores (recomendado)
- RAM: 2-4 GB dedicados a Frigate
- Disco: 10-20 GB para grabaciones (depende de retención)
- Docker instalado ✅ (ya lo tienes)

### **Recomendados:**
- **Coral USB Accelerator** (Google Coral TPU) → ~$60 USD
  - Sin Coral: ~100-150% CPU por cámara
  - Con Coral: ~5-10% CPU total (hasta 8 cámaras)
- SSD para grabaciones (opcional)

### **Tu Setup Actual:**
- ✅ Docker corriendo
- ✅ Home Assistant en Docker
- ✅ 2 cámaras Tapo (C530WS + C310)
- ⚠️ Verificar CPU/RAM disponible

---

## 📊 **Paso 0: Verificar Recursos del Sistema**

Conecta por SSH y ejecuta:

```bash
# Ver CPU y RAM
ssh nico@192.168.1.100
free -h
htop  # (Ctrl+C para salir)

# Ver espacio en disco
df -h

# Ver contenedores Docker corriendo
docker ps
```

**Necesitamos:**
- Al menos 2 GB RAM libres
- 20 GB espacio en disco libre
- CPU con menos de 70% uso promedio

---

## 🚀 **Paso 1: Crear Estructura de Archivos**

```bash
ssh nico@192.168.1.100

# Crear directorio para Frigate
cd /home/nico
mkdir -p frigate/config
mkdir -p frigate/media
mkdir -p frigate/clips
mkdir -p frigate/recordings

cd frigate
```

---

## 📝 **Paso 2: Crear Configuración de Frigate**

Crear archivo `config/config.yml`:

```yaml
# ════════════════════════════════════════════════════════════════
# FRIGATE CONFIGURATION - Cámaras Tapo C530WS + C310
# ════════════════════════════════════════════════════════════════

# MQTT para comunicación con Home Assistant
mqtt:
  enabled: true
  host: 192.168.1.100  # IP de tu servidor HA
  port: 1883
  user: homeassistant  # Usuario MQTT (crear si no existe)
  password: "TU_PASSWORD_MQTT"  # ← CAMBIAR

# Detector (CPU por defecto, cambiar a coral si tienes)
detectors:
  cpu1:
    type: cpu
    # Si tienes Coral TPU descomentar esto:
    # coral1:
    #   type: edgetpu
    #   device: usb

# Modelo de detección (YOLO es el mejor)
model:
  width: 320
  height: 320

# Objetos a detectar
objects:
  track:
    - person
    - car
    - truck
    - bus
    - motorcycle
    - bicycle
    - cat
    - dog
  filters:
    person:
      min_area: 5000      # Área mínima en píxeles
      max_area: 100000
      threshold: 0.7      # Confianza mínima (70%)
    car:
      min_area: 10000
      max_area: 100000
      threshold: 0.7
    truck:
      min_area: 15000
      threshold: 0.7

# Grabación y clips
record:
  enabled: true
  retain:
    days: 7              # Retener 7 días de grabaciones
    mode: motion         # Solo grabar cuando hay movimiento
  events:
    retain:
      default: 14        # Retener eventos 14 días
      mode: motion

snapshots:
  enabled: true
  timestamp: true
  bounding_box: true     # Dibujar cuadros de detección
  retain:
    default: 14

# ════════════════════════════════════════════════════════════════
# CÁMARAS
# ════════════════════════════════════════════════════════════════

cameras:
  # ──────────────────────────────────────────────────────────────
  # CÁMARA 1: C530WS ENTRADA
  # ──────────────────────────────────────────────────────────────
  entrada:
    enabled: true

    # Stream RTSP de la cámara
    ffmpeg:
      inputs:
        - path: rtsp://USUARIO:PASSWORD@192.168.1.XXX:554/stream1
          roles:
            - detect
            - record

    # Resolución nativa de C530WS
    detect:
      width: 1920
      height: 1080
      fps: 5              # FPS para detección (5 es suficiente)

    # Zonas de detección (opcional)
    motion:
      mask:
        # - 0,0,0,200,200,200,200,0  # Ejemplo: ignorar esquina superior izquierda

    # Objetos específicos para esta cámara
    objects:
      track:
        - person
        - car
        - truck
        - bicycle
      filters:
        person:
          min_area: 5000
          threshold: 0.75  # Más estricto para entrada

    # Snapshots
    snapshots:
      enabled: true
      timestamp: true
      bounding_box: true
      crop: false
      required_zones: []

    # Grabación
    record:
      enabled: true
      retain:
        days: 7
        mode: motion
      events:
        retain:
          default: 14


  # ──────────────────────────────────────────────────────────────
  # CÁMARA 2: C310 EXTERIOR
  # ──────────────────────────────────────────────────────────────
  exterior:
    enabled: true

    ffmpeg:
      inputs:
        - path: rtsp://USUARIO:PASSWORD@192.168.1.XXX:554/stream1
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
        - truck
        - motorcycle
        - bicycle
        - cat
        - dog
      filters:
        person:
          min_area: 5000
          threshold: 0.7
        car:
          min_area: 10000
          threshold: 0.7

    snapshots:
      enabled: true
      timestamp: true
      bounding_box: true

    record:
      enabled: true
      retain:
        days: 7

# ════════════════════════════════════════════════════════════════
# CONFIGURACIÓN AVANZADA
# ════════════════════════════════════════════════════════════════

# Telemetry (estadísticas)
telemetry:
  version_check: true

# UI de Frigate
ui:
  live_mode: mse        # Modo de streaming (mse es el mejor)
  timezone: America/Santiago  # ← Ajustar tu zona horaria

# Logging
logger:
  default: info
  logs:
    frigate.event: debug
```

---

## 🔧 **Paso 3: Obtener Credenciales RTSP de Cámaras Tapo**

Las cámaras Tapo exponen stream RTSP. Necesitas:

### **Opción A: Usar credenciales de cámara**

1. Abrir App Tapo
2. Seleccionar cámara → ⚙️
3. "Advanced Settings" → "Camera Account"
4. Crear usuario específico para RTSP (ej: `frigate` / `password123`)

### **Opción B: Obtener desde Home Assistant**

```bash
# En el servidor HA, ver configuración de integración
cat /home/nico/docker-config/homeassistant/.storage/core.config_entries | grep -A 20 tapo
```

### **URL RTSP Format:**
```
rtsp://username:password@IP_CAMARA:554/stream1  # High quality
rtsp://username:password@IP_CAMARA:554/stream2  # Low quality (para detección)
```

**Ejemplo:**
```
rtsp://frigate:mipassword@192.168.1.150:554/stream1  # Entrada
rtsp://frigate:mipassword@192.168.1.151:554/stream1  # Exterior
```

---

## 🐳 **Paso 4: Crear docker-compose.yml para Frigate**

Crear `/home/nico/frigate/docker-compose.yml`:

```yaml
version: "3.9"

services:
  frigate:
    container_name: frigate
    image: ghcr.io/blakeblackshear/frigate:stable
    restart: unless-stopped

    # Privilegios necesarios
    privileged: true

    # Compartir dispositivos (si tienes Coral USB)
    # devices:
    #   - /dev/bus/usb:/dev/bus/usb

    # Volúmenes
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./config:/config
      - ./media:/media/frigate
      - type: tmpfs
        target: /tmp/cache
        tmpfs:
          size: 1000000000  # 1GB de RAM para cache

    # Puertos
    ports:
      - "5000:5000"  # UI Web de Frigate
      - "8554:8554"  # RTSP restream
      - "8555:8555/tcp"  # WebRTC
      - "8555:8555/udp"

    # Variables de entorno
    environment:
      - FRIGATE_RTSP_PASSWORD=mipassword123  # Password para streams de Frigate
      - TZ=America/Santiago  # Tu zona horaria

    # Recursos (limitar uso de CPU/RAM)
    deploy:
      resources:
        limits:
          cpus: '2.0'      # Máximo 2 cores
          memory: 2G       # Máximo 2GB RAM

    # Healthcheck
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/api/version"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
```

---

## 🚀 **Paso 5: Levantar Frigate**

```bash
ssh nico@192.168.1.100
cd /home/nico/frigate

# Antes de levantar, editar config.yml con las IPs y credenciales correctas
nano config/config.yml

# Levantar Frigate
docker-compose up -d

# Ver logs para verificar que arrancó bien
docker logs -f frigate

# Esperar a ver:
# "Frigate is running..."
# "Starting detector process..."
```

---

## 🌐 **Paso 6: Acceder a la UI de Frigate**

Abrir en navegador:
```
http://192.168.1.100:5000
```

**Deberías ver:**
- Dashboard con tus 2 cámaras
- Streams de video en vivo
- Estadísticas de detección
- Timeline de eventos

**Si no funciona:**
- Verificar logs: `docker logs frigate`
- Revisar credenciales RTSP en `config.yml`
- Verificar que las cámaras sean accesibles: `ping IP_CAMARA`

---

## 🏠 **Paso 7: Integrar con Home Assistant**

### **7.1. Agregar Integración**

1. En HA: **Configuración → Dispositivos y servicios**
2. Click **"+ AGREGAR INTEGRACIÓN"**
3. Buscar: **"Frigate"**
4. Ingresar:
   - URL: `http://192.168.1.100:5000`
5. Click **"ENVIAR"**
6. Esperar a que detecte las cámaras

### **7.2. Verificar Binary Sensors Creados**

Ir a: **Herramientas de desarrollador → Estados**

Buscar:
- `binary_sensor.entrada_person_occupancy` ✅
- `binary_sensor.entrada_car_occupancy` ✅
- `binary_sensor.exterior_person_occupancy` ✅
- `binary_sensor.exterior_car_occupancy` ✅

Y muchos más (dog, cat, motorcycle, truck, etc.)

---

## 🎯 **Resultado Final:**

Frigate crea **binary sensors** para cada objeto en cada cámara:

**Formato:** `binary_sensor.{camera}_{object}_occupancy`

**Ejemplos:**
- `binary_sensor.entrada_person_occupancy` → Persona en entrada
- `binary_sensor.entrada_car_occupancy` → Vehículo en entrada
- `binary_sensor.exterior_person_occupancy` → Persona en exterior
- `binary_sensor.exterior_truck_occupancy` → Camión en exterior
- `binary_sensor.exterior_dog_occupancy` → Perro en exterior

**Estados:**
- `on` → Objeto detectado AHORA
- `off` → No detectado

---

## 🧪 **Paso 8: Probar la Detección**

1. Abrir UI de Frigate: `http://192.168.1.100:5000`
2. Ir a "Events"
3. Pasar frente a una cámara
4. Verificar que aparezca evento con bounding box
5. En HA → Estados → Verificar que binary sensor cambie a `on`

---

## 📊 **Paso 9: Monitorear Rendimiento**

```bash
# Ver uso de CPU/RAM de Frigate
docker stats frigate

# Ver logs en tiempo real
docker logs -f frigate

# Detener si necesitas
docker-compose down
```

**Métricas esperadas (SIN Coral TPU):**
- CPU: 50-100% por cámara
- RAM: 500MB-1GB
- FPS: 3-5 para detección

**Con Coral TPU:**
- CPU: 5-10% total
- Inference speed: <10ms
- FPS: Hasta 10

---

## ⚠️ **Troubleshooting**

### **Problema: "Unable to connect to RTSP stream"**

**Solución:**
```bash
# Verificar que RTSP funcione manualmente
ffmpeg -i "rtsp://usuario:password@IP:554/stream1" -frames:v 1 test.jpg

# Si funciona, revisar config.yml
# Si no, verificar credenciales en App Tapo
```

### **Problema: "Detector process crashed"**

**Solución:**
- Reducir FPS en config.yml (de 5 a 3)
- Reducir resolución de detección (de 320 a 256)
- Agregar más RAM al contenedor

### **Problema: "High CPU usage"**

**Soluciones:**
1. Usar stream2 (baja calidad) para detección
2. Reducir FPS a 3
3. Considerar comprar Coral TPU ($60)
4. Deshabilitar grabación continua

---

## 💰 **Opcional: Coral TPU Accelerator**

Si el CPU es muy alto, el **Google Coral USB Accelerator** es una inversión excelente:

**Beneficios:**
- CPU baja de 100% a 5-10%
- Soporta hasta 8 cámaras sin esfuerzo
- Inference <10ms (vs 100-200ms con CPU)
- ~$60 USD en Amazon/MercadoLibre

**Instalación:**
1. Conectar Coral USB al servidor
2. En `docker-compose.yml` descomentar `devices`
3. En `config.yml` cambiar detector a `edgetpu`
4. Reiniciar Frigate

---

## 📝 **Próximos Pasos:**

Una vez Frigate esté funcionando:

1. ✅ Verificar binary sensors en HA
2. ✅ Crear automatizaciones V3.3 (personas + vehículos)
3. ✅ Configurar notificaciones con snapshots de Frigate
4. ✅ Optimizar zonas de detección
5. ✅ Ajustar retención de grabaciones

---

**¿Listo para instalar?** 🚀

Avísame cuando tengas:
1. IP de las cámaras
2. Credenciales RTSP
3. Frigate corriendo

Y crearemos las automatizaciones V3.3 con detección de personas + vehículos.

