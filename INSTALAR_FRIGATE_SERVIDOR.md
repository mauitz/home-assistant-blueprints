# 🚀 INSTALAR FRIGATE EN /opt/server/

## 📋 RESUMEN

Este documento explica cómo migrar Frigate de `~/frigate/` a `/opt/server/` e integrarlo en tu stack principal de Docker Compose.

---

## ⚙️ **PASO 1: Detener Frigate Actual (2 min)**

```bash
ssh nico@192.168.1.100

# Detener contenedor actual
cd ~/frigate
docker-compose down

# Verificar que se detuvo
docker ps | grep frigate
# (no debe mostrar nada)
```

---

## 📁 **PASO 2: Crear Estructura de Directorios (1 min)**

```bash
# Crear directorios para Frigate
sudo mkdir -p /opt/server/containers/frigate/config
sudo mkdir -p /opt/server/containers/frigate/media

# Copiar configuración actual
sudo cp -r ~/frigate/config/* /opt/server/containers/frigate/config/

# Ajustar permisos
sudo chown -R ${USER}:${USER} /opt/server/containers/frigate

# Verificar
ls -la /opt/server/containers/frigate/config/
# Debe mostrar config.yml
```

---

## 🔧 **PASO 3: Configurar Mosquitto (5 min)**

**IMPORTANTE:** Frigate necesita autenticación MQTT.

```bash
# 1. Crear usuario mqtt-user en Mosquitto
docker exec mosquitto mosquitto_passwd -b /mosquitto/config/password.txt mqtt-user Nicomaui1

# 2. Verificar usuario
docker exec mosquitto cat /mosquitto/config/password.txt | grep mqtt-user

# 3. Crear/verificar mosquitto.conf
docker exec mosquitto sh -c 'cat > /mosquitto/config/mosquitto.conf << EOF
listener 1883
allow_anonymous false
password_file /mosquitto/config/password.txt
persistence true
persistence_location /mosquitto/data/
log_dest stdout
EOF'

# 4. Reiniciar Mosquitto
docker restart mosquitto

# 5. Ver logs (debe mostrar que arrancó OK)
docker logs mosquitto --tail=20
```

**Credenciales MQTT (deben coincidir con `config.yml`):**
- Usuario: `mqtt-user`
- Password: `Nicomaui1`

---

## 📄 **PASO 4: Actualizar docker-compose.yml y .env (2 min)**

### **A. Actualizar docker-compose.yml:**

```bash
cd /opt/server

# Backup del archivo actual
sudo cp docker-compose.yml docker-compose.yml.backup

# Editar docker-compose.yml
sudo nano docker-compose.yml
```

**Agregar al final (antes de `networks:`):**

```yaml
  # ════════════════════════════════════════════════════════════════
  # FRIGATE NVR - AI Object Detection
  # ════════════════════════════════════════════════════════════════
  frigate:
    container_name: frigate
    image: ghcr.io/blakeblackshear/frigate:stable
    restart: unless-stopped
    privileged: true
    shm_size: "256mb"
    networks:
      - home
    ports:
      - "5000:5000/tcp"   # WebUI
      - "8554:8554/tcp"   # RTSP feeds
      - "8555:8555/tcp"   # WebRTC
      - "8555:8555/udp"   # WebRTC
      - "1984:1984/tcp"   # go2rtc
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ${FRIGATE_CONFIG_DIR}:/config
      - ${FRIGATE_MEDIA_DIR}:/media/frigate
      - type: tmpfs
        target: /tmp/cache
        tmpfs:
          size: 1000000000  # 1GB
    environment:
      - TZ=${TZ}
      - FRIGATE_RTSP_USER=${FRIGATE_RTSP_USER}
      - FRIGATE_RTSP_PASSWORD=${FRIGATE_RTSP_PASSWORD}
    labels:
      nginx.port: "5000"
      nginx.server_name: "frigate"
    # Límites de recursos (ajustar según tu hardware)
    deploy:
      resources:
        limits:
          cpus: '3'
          memory: 2G
        reservations:
          memory: 512M
```

**Guardar y salir:** `Ctrl+O`, `Enter`, `Ctrl+X`

### **B. Actualizar .env:**

```bash
# Editar .env
sudo nano .env
```

**Agregar al final:**

```bash
##################################
#### Frigate NVR              ####
##################################
FRIGATE_CONFIG_DIR=/opt/server/containers/frigate/config
FRIGATE_MEDIA_DIR=/opt/server/containers/frigate/media
FRIGATE_RTSP_USER=PezAustral
FRIGATE_RTSP_PASSWORD=R3spons3
```

**Guardar y salir:** `Ctrl+O`, `Enter`, `Ctrl+X`

---

## 🚀 **PASO 5: Levantar Frigate (2 min)**

```bash
cd /opt/server

# Validar sintaxis
docker-compose config

# Levantar solo Frigate (sin afectar otros servicios)
docker-compose up -d frigate

# Ver logs en tiempo real
docker logs -f frigate
```

### **✅ Verificar que conectó a MQTT:**

Buscar en logs:
```
[INFO] Connected to MQTT server
```

**Si muestra `MQTT Not authorized`:**
- Verificar usuario en Mosquitto (Paso 3)
- Verificar credenciales en `config.yml`

---

## 🏠 **PASO 6: Verificar Integración en Home Assistant (3 min)**

### **A. Recargar Integración Frigate:**

1. **Configuración → Dispositivos y servicios**
2. Buscar **"Frigate"**
3. Click en **⋮ → RECARGAR**
4. Esperar 10 segundos

### **B. Verificar Sensores:**

**Herramientas de desarrollador → Estados:**

Buscar:
```
binary_sensor.entrada_person_occupancy
binary_sensor.entrada_car_occupancy
binary_sensor.exterior_person_occupancy
binary_sensor.exterior_car_occupancy
```

**Estado debe ser:**
- `off` (verde) ✅ → Frigate está funcionando
- `unavailable` (gris) ❌ → Frigate NO está conectado a MQTT

---

## 🧪 **PASO 7: Probar Detección (5 min)**

### **A. Verificar WebUI:**

Abrir navegador: `http://192.168.1.100:5000`

Debe mostrar:
- Cámaras "entrada" y "exterior"
- Live feed funcionando

### **B. Probar Detección de Persona:**

1. Pasar frente a cámara Entrada
2. En Frigate UI → **Events** → Debe aparecer evento con bounding box
3. En Home Assistant → Estado del sensor `binary_sensor.entrada_person_occupancy` → Debe cambiar a `on`
4. Dashboard Maui → Widget Frigate → Debe ponerse ROJO con "🚨 DETECCIÓN ACTIVA"
5. Celular → Notificación: "🚨 PERSONA en Entrada"

---

## 📊 **VERIFICACIÓN COMPLETA**

```bash
# 1. Verificar que Frigate está corriendo
docker ps | grep frigate
# Debe mostrar: frigate (healthy)

# 2. Ver logs de Frigate (buscar errores)
docker logs frigate --tail=50 | grep -E "ERROR|WARN|Connected"

# 3. Verificar conexión MQTT
docker logs frigate --tail=50 | grep MQTT

# 4. Verificar recursos del contenedor
docker stats frigate --no-stream

# 5. Verificar archivos de configuración
ls -lh /opt/server/containers/frigate/config/
# Debe mostrar: config.yml

# 6. Verificar espacio en disco para grabaciones
df -h /opt/server/containers/frigate/media/
```

---

## 🗑️ **PASO 8: Limpiar Instalación Antigua (OPCIONAL)**

**Solo después de verificar que todo funciona correctamente:**

```bash
# Eliminar carpeta antigua de Frigate
cd ~
rm -rf frigate/

# Verificar que se eliminó
ls -la ~/ | grep frigate
# (no debe mostrar nada)
```

---

## 🔧 **TROUBLESHOOTING**

### **❌ Error: "MQTT Not authorized"**

**Solución:**
```bash
# Recrear usuario
docker exec mosquitto mosquitto_passwd -b /mosquitto/config/password.txt mqtt-user Nicomaui1

# Reiniciar Mosquitto y Frigate
docker restart mosquitto
sleep 5
docker restart frigate

# Ver logs
docker logs frigate --tail=30 | grep MQTT
```

### **❌ Error: "Connection timed out" (RTSP)**

**Solución:**
- Verificar IPs de las cámaras en `config.yml`
- Verificar credenciales RTSP (usuario/password)
- Ping a las cámaras: `ping 192.168.1.20`

### **❌ Sensores en "unavailable"**

**Solución:**
1. Verificar que Frigate está conectado a MQTT (logs)
2. Recargar integración en Home Assistant
3. Reiniciar Home Assistant si es necesario

### **❌ No detecta objetos**

**Solución:**
- Verificar que las cámaras están grabando en Frigate UI
- Verificar `config.yml` → `objects.track` incluye `person`, `car`, etc.
- Ajustar `threshold` y `min_area` en `config.yml`

---

## 📁 **ESTRUCTURA FINAL**

```
/opt/server/
├── docker-compose.yml       ← Con servicio Frigate
├── .env                     ← Con variables de Frigate
└── containers/
    └── frigate/
        ├── config/
        │   └── config.yml   ← Configuración de Frigate
        └── media/           ← Grabaciones y snapshots
            ├── clips/
            ├── recordings/
            └── snapshots/
```

---

## ✅ **CHECKLIST FINAL**

- [ ] Frigate detened o (~/frigate)
- [ ] Directorios creados (/opt/server/containers/frigate/)
- [ ] Configuración copiada (config.yml)
- [ ] Usuario MQTT creado (mqtt-user)
- [ ] Mosquitto configurado (mosquitto.conf)
- [ ] docker-compose.yml actualizado
- [ ] .env actualizado
- [ ] Frigate levantado (`docker-compose up -d frigate`)
- [ ] Logs muestran "Connected to MQTT"
- [ ] Integración Frigate recargada en HA
- [ ] Sensores en estado `off` (no `unavailable`)
- [ ] WebUI accesible (http://192.168.1.100:5000)
- [ ] Detección de persona probada y funcionando
- [ ] Notificación recibida en celular
- [ ] Widget del dashboard actualizado correctamente

---

## 🎯 **RESUMEN**

**Archivos modificados:**
1. `/opt/server/docker-compose.yml` → Agregado servicio `frigate`
2. `/opt/server/.env` → Agregadas variables de Frigate
3. `/opt/server/containers/mosquitto/config/mosquitto.conf` → Configurada autenticación
4. `/opt/server/containers/mosquitto/config/password.txt` → Usuario `mqtt-user`

**Comandos clave:**
```bash
# Levantar Frigate
docker-compose up -d frigate

# Ver logs
docker logs -f frigate

# Reiniciar Frigate
docker restart frigate

# Reiniciar stack completo (cuidado)
docker-compose restart
```

---

**Fecha de creación:** 2025-11-14
**Versión:** 1.0
