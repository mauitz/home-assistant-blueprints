# 🛠️ Comandos Útiles - Investigación de Cámaras

## 📋 Scripts de Investigación

### 1. Investigar todas las cámaras y automatizaciones
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
python3 investigate_cameras.py
```

### 2. Obtener información específica de cámara Xiaomi
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
python3 get_xiaomi_camera_info.py
```

### 3. Ver reporte JSON completo
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
cat camera_investigation_report.json | jq
```

---

## 🔍 Buscar IP de la Cámara Xiaomi

### En el Router (vía SSH al servidor)
```bash
ssh nico@192.168.1.100

# Si tienes nmap instalado
sudo nmap -sn 192.168.1.0/24 | grep -B 2 -i xiaomi

# O buscar en logs de Home Assistant
cat /home/nico/docker-config/homeassistant/home-assistant.log | grep -i chuangmi
```

### Desde Home Assistant API
```bash
# Usando curl (necesitas HA_TOKEN)
curl -X GET \
  -H "Authorization: Bearer TU_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  http://192.168.1.100:8123/api/states/device_tracker.chuangmi_camera_029a02
```

---

## 🎥 Probar RTSP de la Cámara

**Una vez tengas la IP de la cámara**, prueba estos comandos:

### Con ffmpeg (capturar frame)
```bash
# Prueba 1: URL estándar Xiaomi
ffmpeg -i "rtsp://admin:admin@IP_CAMARA:554/live/ch0" -frames:v 1 test1.jpg

# Prueba 2: Stream alternativo
ffmpeg -i "rtsp://admin:admin@IP_CAMARA:554/stream1" -frames:v 1 test2.jpg

# Prueba 3: Puerto alternativo
ffmpeg -i "rtsp://admin:admin@IP_CAMARA:8554/live" -frames:v 1 test3.jpg

# Prueba 4: Sin password
ffmpeg -i "rtsp://root:@IP_CAMARA:554/live/ch0" -frames:v 1 test4.jpg

# Prueba 5: Admin sin password
ffmpeg -i "rtsp://admin:@IP_CAMARA:554/stream1" -frames:v 1 test5.jpg
```

### Con VLC (visualizar stream en vivo)
```bash
# Abrir VLC
open -a VLC

# Luego: Archivo → Abrir Red → Pegar URL RTSP
# Ejemplo: rtsp://admin:admin@192.168.1.XXX:554/live/ch0
```

### Con curl (verificar puerto abierto)
```bash
# Verificar si puerto RTSP responde
curl -v telnet://IP_CAMARA:554

# Verificar puerto alternativo
curl -v telnet://IP_CAMARA:8554
```

---

## 🐳 Comandos de Frigate

### Ver estado de Frigate
```bash
ssh nico@192.168.1.100
docker ps | grep frigate
docker logs frigate --tail 100
```

### Reiniciar Frigate
```bash
ssh nico@192.168.1.100
cd /home/nico/frigate
docker-compose restart
```

### Ver configuración actual
```bash
ssh nico@192.168.1.100
cat /home/nico/frigate/config/config.yml
```

### Editar configuración
```bash
ssh nico@192.168.1.100
nano /home/nico/frigate/config/config.yml
# Ctrl+X para guardar
docker-compose restart
```

### Ver logs en tiempo real
```bash
ssh nico@192.168.1.100
docker logs -f frigate
```

---

## 📊 Monitoreo de Sistema

### Ver uso de recursos
```bash
ssh nico@192.168.1.100

# CPU y RAM
htop

# Espacio en disco
df -h

# Uso de Docker containers
docker stats
```

### Ver cámaras activas en Frigate
```bash
# Abrir en navegador
open http://192.168.1.100:5000
```

---

## 🔧 Home Assistant

### Ver estados de entidades
```bash
# API directa
curl -X GET \
  -H "Authorization: Bearer TU_TOKEN" \
  http://192.168.1.100:8123/api/states | jq '.[] | select(.entity_id | contains("camera"))'
```

### Ver automatizaciones
```bash
curl -X GET \
  -H "Authorization: Bearer TU_TOKEN" \
  http://192.168.1.100:8123/api/states | jq '.[] | select(.entity_id | contains("automation"))'
```

### Triggear automatización manualmente
```bash
curl -X POST \
  -H "Authorization: Bearer TU_TOKEN" \
  -H "Content-Type: application/json" \
  http://192.168.1.100:8123/api/services/automation/trigger \
  -d '{"entity_id": "automation.test_manual_v3_3"}'
```

---

## 🧪 Tests Rápidos

### Test 1: Verificar conectividad con cámara
```bash
# Reemplazar IP_CAMARA con la IP real
ping IP_CAMARA

# Verificar puertos abiertos
nmap -p 554,8554,80,443 IP_CAMARA
```

### Test 2: Verificar binary sensors de Frigate
```bash
curl -X GET \
  -H "Authorization: Bearer TU_TOKEN" \
  http://192.168.1.100:8123/api/states/binary_sensor.entrada_person_occupancy
```

### Test 3: Capturar snapshot de cámara existente
```bash
curl -X POST \
  -H "Authorization: Bearer TU_TOKEN" \
  -H "Content-Type: application/json" \
  http://192.168.1.100:8123/api/services/camera/snapshot \
  -d '{
    "entity_id": "camera.entrada",
    "filename": "/config/www/test_snapshot.jpg"
  }'
```

---

## 📁 Ubicaciones de Archivos

### Configuración de Home Assistant
```
/home/nico/docker-config/homeassistant/configuration.yaml
/home/nico/docker-config/homeassistant/automations.yaml
```

### Configuración de Frigate
```
/home/nico/frigate/config/config.yml
/home/nico/frigate/media/
```

### Logs
```
/home/nico/docker-config/homeassistant/home-assistant.log
docker logs frigate
```

---

## 🚨 Troubleshooting

### Problema: Cámara no responde
```bash
# 1. Verificar conectividad
ping IP_CAMARA

# 2. Verificar en router si está conectada
# (acceder a 192.168.1.1 desde navegador)

# 3. Reiniciar cámara desde HA
curl -X POST \
  -H "Authorization: Bearer TU_TOKEN" \
  http://192.168.1.100:8123/api/services/switch/turn_off \
  -d '{"entity_id": "switch.chuangmi_us_447604776_029a02_on_p_2_1"}'

# Esperar 10 segundos

curl -X POST \
  -H "Authorization: Bearer TU_TOKEN" \
  http://192.168.1.100:8123/api/services/switch/turn_on \
  -d '{"entity_id": "switch.chuangmi_us_447604776_029a02_on_p_2_1"}'
```

### Problema: Frigate no detecta
```bash
# Ver logs de Frigate
ssh nico@192.168.1.100
docker logs frigate | grep -i error

# Verificar CPU usage
docker stats frigate
```

### Problema: SD Card llena
```bash
# Formatear SD desde HA
curl -X POST \
  -H "Authorization: Bearer TU_TOKEN" \
  http://192.168.1.100:8123/api/services/button/press \
  -d '{"entity_id": "button.chuangmi_us_447604776_029a02_format_a_4_1"}'
```

---

## 📝 Crear archivo .env

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints

# Crear .env
cat > .env << 'EOF'
HA_URL=http://192.168.1.100:8123
HA_TOKEN=tu_token_de_long_lived_access_aqui
EOF

# Verificar
cat .env
```

### Crear token de acceso:
1. Ir a http://192.168.1.100:8123/profile
2. Scroll hasta "Long-Lived Access Tokens"
3. Click "CREATE TOKEN"
4. Copiar y pegar en .env

---

## 🎯 Flujo Completo de Integración

```bash
# 1. Investigar sistema
python3 investigate_cameras.py

# 2. Obtener info de cámara Xiaomi
python3 get_xiaomi_camera_info.py

# 3. Anotar IP de la cámara
# (desde app Xiaomi Home o router)

# 4. Probar RTSP
ffmpeg -i "rtsp://admin:admin@IP:554/live/ch0" -frames:v 1 test.jpg

# 5. Si funciona, SSH al servidor
ssh nico@192.168.1.100

# 6. Editar config de Frigate
cd /home/nico/frigate
nano config/config.yml

# 7. Agregar cámara (ver ejemplo en RESUMEN_INVESTIGACION.md)

# 8. Reiniciar Frigate
docker-compose restart

# 9. Ver logs
docker logs -f frigate

# 10. Verificar en UI
# Abrir: http://192.168.1.100:5000

# 11. Crear automatizaciones en HA
```

---

## 📚 Documentación de Referencia

### Scripts en este repo:
- `investigate_cameras.py` - Investigación completa
- `get_xiaomi_camera_info.py` - Info de cámara Xiaomi
- `ha_manager.py` - Gestor general de HA

### Documentos:
- `RESUMEN_INVESTIGACION.md` - Resumen de hallazgos
- `docs/INFORME_CAMARA_XIAOMI.md` - Informe detallado
- `docs/FRIGATE_INSTALACION_COMPLETA.md` - Guía de Frigate
- `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md` - Guía de Tapo

---

**Última actualización:** 14 de Noviembre, 2025

