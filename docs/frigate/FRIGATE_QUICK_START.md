# 🚀 Frigate Quick Start - Instalación Rápida

Esta guía te lleva paso a paso para tener Frigate funcionando en **15-20 minutos**.

---

## ✅ **Checklist Rápido**

- [ ] 1. Verificar recursos del sistema (5 min)
- [ ] 2. Obtener credenciales RTSP de cámaras (5 min)
- [ ] 3. Instalar Frigate con Docker (5 min)
- [ ] 4. Configurar cámaras (5 min)
- [ ] 5. Integrar con Home Assistant (2 min)
- [ ] 6. Instalar automatizaciones V3.3 (3 min)
- [ ] 7. Probar (5 min)

**Tiempo total:** ~30 minutos

---

## 📋 **PASO 1: Verificar Recursos del Sistema (5 min)**

```bash
ssh nico@192.168.1.100

# Ver RAM disponible
free -h
# NECESITAS: Al menos 2 GB libres

# Ver espacio en disco
df -h
# NECESITAS: Al menos 20 GB libres

# Ver CPU
htop  # (Ctrl+C para salir)
# NECESITAS: CPU con menos de 70% uso promedio
```

**¿Todo OK?** → Siguiente paso

---

## 🔐 **PASO 2: Obtener Credenciales RTSP (5 min)**

### **Opción A: Crear usuario RTSP en App Tapo**

1. Abrir **App Tapo** en el celular
2. Seleccionar cámara **"Entrada"** (C530WS)
3. **⚙️ → Advanced Settings → Camera Account**
4. **"Add a Camera Account"**
5. Usuario: `frigate`
6. Password: `mipassword123` (cambiar por uno seguro)
7. **Guardar**
8. **Repetir para cámara "Exterior"** (C310)

### **Opción B: Usar usuario existente**

Si ya tienes usuario configurado, úsalo.

### **Anotar:**
```
Usuario RTSP: _____________
Password RTSP: _____________

IP Cámara Entrada: _____________  (ej: 192.168.1.150)
IP Cámara Exterior: _____________ (ej: 192.168.1.151)
```

---

## 🐳 **PASO 3: Instalar Frigate (5 min)**

```bash
ssh nico@192.168.1.100

# Crear estructura de directorios
cd /home/nico
mkdir -p frigate/config
mkdir -p frigate/media

cd frigate
```

**Copiar archivos desde este repo:**

```bash
# Descargar docker-compose.yml
curl -o docker-compose.yml https://raw.githubusercontent.com/mauitz/home-assistant-blueprints/main/examples/frigate_docker_compose.yml

# Descargar config.yml
curl -o config/config.yml https://raw.githubusercontent.com/mauitz/home-assistant-blueprints/main/examples/frigate_config.yml
```

**O copiar manualmente:**
- Copiar `examples/frigate_docker_compose.yml` → `/home/nico/frigate/docker-compose.yml`
- Copiar `examples/frigate_config.yml` → `/home/nico/frigate/config/config.yml`

---

## 📝 **PASO 4: Configurar Cámaras (5 min)**

Editar el archivo de configuración:

```bash
nano config/config.yml
```

**Cambiar estas líneas (buscar con Ctrl+W):**

### **1. MQTT Password (línea ~15):**
```yaml
mqtt:
  password: "CAMBIAR_PASSWORD_MQTT"  # ← CAMBIAR
```

Si no tienes MQTT configurado, usar: `homeassistant`

### **2. Credenciales Cámara Entrada (línea ~165):**
```yaml
path: rtsp://USUARIO:PASSWORD@192.168.1.XXX:554/stream1
```

Cambiar a:
```yaml
path: rtsp://frigate:mipassword123@192.168.1.150:554/stream1
```
(Usar TUS credenciales e IP real)

### **3. Credenciales Cámara Exterior (línea ~250):**
```yaml
path: rtsp://USUARIO:PASSWORD@192.168.1.XXX:554/stream1
```

Cambiar a:
```yaml
path: rtsp://frigate:mipassword123@192.168.1.151:554/stream1
```

**Buscar y reemplazar TODAS las ocurrencias de:**
- `USUARIO` → `frigate`
- `PASSWORD` → `mipassword123`
- `192.168.1.XXX` → IP real de cada cámara

**Guardar:** Ctrl+O → Enter → Ctrl+X

---

## 🚀 **PASO 5: Levantar Frigate (2 min)**

```bash
cd /home/nico/frigate

# Levantar contenedor
docker-compose up -d

# Ver logs
docker logs -f frigate

# Esperar a ver:
# "Frigate is running..."
# "Starting detector process..."
# "Camera entrada: ffmpeg sent a broken frame"  ← Esto es normal al inicio
```

**Después de ~30 segundos, presionar Ctrl+C**

---

## 🌐 **PASO 6: Verificar UI de Frigate (2 min)**

Abrir en navegador:
```
http://192.168.1.100:5000
```

**Deberías ver:**
- ✅ Dashboard con 2 cámaras
- ✅ Video en vivo de ambas cámaras
- ✅ FPS y estadísticas

**Si NO funciona:**
```bash
# Ver logs detallados
docker logs frigate | grep -i error

# Verificar que las cámaras sean accesibles
ping 192.168.1.150  # IP cámara Entrada
ping 192.168.1.151  # IP cámara Exterior

# Probar RTSP manualmente
ffmpeg -i "rtsp://frigate:mipassword123@192.168.1.150:554/stream1" -frames:v 1 test.jpg
```

---

## 🏠 **PASO 7: Integrar con Home Assistant (3 min)**

### **7.1. Agregar Integración**

1. En Home Assistant: **Configuración → Dispositivos y servicios**
2. Click **"+ AGREGAR INTEGRACIÓN"**
3. Buscar: **"Frigate"**
4. URL: `http://192.168.1.100:5000`
5. Click **"ENVIAR"**
6. Esperar ~10 segundos

### **7.2. Verificar Binary Sensors**

**Herramientas de desarrollador → Estados**

Buscar (debe existir):
```
binary_sensor.entrada_person_occupancy
binary_sensor.entrada_car_occupancy
binary_sensor.exterior_person_occupancy
binary_sensor.exterior_car_occupancy
```

**Estado esperado:** `off` (cuando no hay detección)

---

## 🎯 **PASO 8: Instalar Automatizaciones V3.3 (3 min)**

```bash
# En tu máquina local (desde el repo)
cd /Users/maui/_maui/domotica/home-assistant-blueprints

# Reemplazar automatizaciones V3.2 por V3.3 en el proxy
cat examples/camera_alert_system_v3.3_frigate.yaml >> HA_config_proxy/automations.yaml

# Copiar al servidor
scp HA_config_proxy/automations.yaml nico@192.168.1.100:/home/nico/docker-config/homeassistant/
```

**Luego en Home Assistant:**

**Configuración → Sistema → Reiniciar**

---

## 🧪 **PASO 9: Probar (5 min)**

### **Test 1: Detección de Persona**

1. Ir a UI de Frigate: `http://192.168.1.100:5000`
2. Click en **"Events"**
3. **Pasar frente a cámara Entrada**
4. En ~2 segundos debería aparecer evento con bounding box
5. En HA → Estados → Verificar `binary_sensor.entrada_person_occupancy` = `on`
6. Esperar notificación en celular: **"🚨 PERSONA en Entrada"**
7. Verificar widget agrandado en dashboard Maui

### **Test 2: Detección de Vehículo**

1. Pasar un auto frente a la cámara (o poner una imagen de auto)
2. Verificar evento en Frigate UI
3. Verificar `binary_sensor.entrada_car_occupancy` = `on`
4. Notificación: **"🚗 Vehículo en Entrada"** (sin sirena)

### **Test 3: Manual**

En HA → Herramientas de desarrollador → Servicios:

```yaml
service: input_text.set_value
target:
  entity_id: input_text.camera_alert_active
data:
  value: "test"
```

Ejecutar → Debería llegar notificación de prueba

---

## ✅ **Resultado Final**

Ahora tienes:

- ✅ **Frigate** analizando video 24/7
- ✅ **Detección de personas** con IA (modelo YOLO)
- ✅ **Detección de vehículos** (autos, camiones, motos)
- ✅ **Detección de animales** (perros, gatos)
- ✅ **Binary sensors** en Home Assistant
- ✅ **Automatizaciones V3.3** activas
- ✅ **Notificaciones** con snapshots de Frigate
- ✅ **Grabación inteligente** (solo cuando detecta algo)
- ✅ **Timeline de eventos** en UI de Frigate
- ✅ **Widget agrandado** en dashboard Maui

---

## 📊 **Monitorear Rendimiento**

```bash
# Ver uso de CPU/RAM
docker stats frigate

# Ver logs en tiempo real
docker logs -f frigate

# Ver eventos recientes
curl http://192.168.1.100:5000/api/events | jq
```

**Uso esperado (SIN Coral TPU):**
- CPU: 50-100% por cámara (100-200% total con 2 cámaras)
- RAM: ~1-1.5 GB
- Disco: ~1-2 GB por cámara por día

**Si CPU es muy alto (>150%):**
- Opción 1: Reducir FPS en `config.yml` (de 5 a 3)
- Opción 2: Comprar Google Coral TPU (~$60) → CPU bajará a 5-10%

---

## 🎓 **Próximos Pasos (Opcional)**

1. **Configurar zonas** en Frigate (detectar solo en áreas específicas)
2. **Ajustar sensibilidad** por cámara
3. **Agregar más objetos** (truck, bus, bicycle, etc.)
4. **Configurar retención** de grabaciones
5. **Comprar Coral TPU** si CPU es muy alto

---

## ⚠️ **Troubleshooting Común**

### **"Unable to connect to RTSP stream"**
```bash
# Probar conexión manualmente
ffmpeg -i "rtsp://USER:PASS@IP:554/stream1" -frames:v 1 test.jpg

# Si falla, verificar:
# 1. Credenciales en App Tapo
# 2. IP de la cámara (ping)
# 3. Puerto 554 abierto
```

### **"Binary sensors no aparecen en HA"**
```bash
# 1. Verificar que Frigate esté detectando
curl http://192.168.1.100:5000/api/config

# 2. Recargar integración en HA
Configuración → Integraciones → Frigate → "RECARGAR"

# 3. Reiniciar HA
Configuración → Sistema → Reiniciar
```

### **"High CPU usage (>200%)"**
```bash
# Editar config.yml, reducir FPS:
nano /home/nico/frigate/config/config.yml

# Cambiar (en cada cámara):
detect:
  fps: 3  # Reducir de 5 a 3

# Reiniciar
cd /home/nico/frigate
docker-compose restart
```

---

## 🎉 **¡Listo!**

Ahora tienes un sistema de detección inteligente con IA funcionando.

**Siguiente:** Disfrutar de las notificaciones precisas sin falsos positivos 🚀

---

**Documentación completa:** `docs/FRIGATE_INSTALACION_COMPLETA.md`
**Configuración:** `examples/frigate_config.yml`
**Automatizaciones:** `examples/camera_alert_system_v3.3_frigate.yaml`


