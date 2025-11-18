# 🔧 Guía: Instalar Firmware Custom en Cámara Xiaomi

**Cámara:** Chuangmi Camera (chuangmi.camera.us.447604776.029a02)
**Objetivo:** Habilitar RTSP para integrar con Frigate
**Método:** Firmware Custom (Xiaomi Dafang Hacks)

---

## ⚠️ ADVERTENCIAS IMPORTANTES

### 🚨 Riesgos:
- ❌ **Puede invalidar la garantía**
- ❌ **Riesgo de "brick" (dejar la cámara inservible)**
- ❌ **Perderás acceso a app Xiaomi Home**
- ❌ **Perderás funciones cloud de Xiaomi**
- ⚠️ **Requiere conocimientos técnicos medios**
- ⚠️ **No es reversible fácilmente**

### ✅ Beneficios:
- ✅ RTSP funcional
- ✅ Control total sobre la cámara
- ✅ Sin dependencia del cloud de Xiaomi
- ✅ Más privacidad
- ✅ Integración completa con Frigate

---

## 🔍 PASO 0: Identificar Modelo Exacto

### Información de tu cámara:

```
Device ID: chuangmi_us_447604776_029a02
Friendly Name: Front door cam
Manufacturer: Xiaomi (Chuangmi)
Integration: xiaomi_home
```

### Modelo probable:

Basado en el ID `chuangmi.camera.us`, es probablemente uno de estos modelos:

1. **Chuangmi 720P Smart Camera** (CMSXJ01C)
2. **Xiaomi Mijia 1080P Smart Camera**
3. **Xiaomi Small Square Smart Camera**

---

## 📱 PASO 1: Identificar Modelo desde App Xiaomi Home

**Es CRÍTICO identificar el modelo exacto antes de continuar.**

### En la app Xiaomi Home:

1. Abrir app Xiaomi Home
2. Seleccionar "Front door cam"
3. Ir a ⚙️ Configuración (arriba derecha)
4. Buscar **"Device Information"** o **"Información del dispositivo"**
5. Anotar:
   - **Modelo exacto** (ej: CMSXJ01C, CMSXJ11A, etc.)
   - **Versión de firmware** actual
   - **Número de serie**

### Modelos compatibles con Dafang Hacks:

✅ **Compatibles:**
- Xiaomi Dafang (DF3)
- Xiaomi Xiaofang 1S (T20)
- Xiaomi XiaoFang (T10)
- Wyzecam V2 (con chip Ingenic T20)
- Wyzecam Pan

⚠️ **Parcialmente compatibles:**
- Algunos modelos Chuangmi con chip Ingenic
- Xiaomi Mijia Small Square Camera

❌ **NO compatibles:**
- Modelos con chip Hi3518e
- Modelos muy nuevos (2023+)
- Xiaomi Mi Home Security Camera 360° (algunas versiones)

---

## 🔍 PASO 2: Verificar Chip de Hardware

### Método 1: Por modelo

Busca tu modelo exacto en:
- https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks/blob/master/DEVICES.md

### Método 2: Desmontar (NO recomendado aún)

Si necesitas verificar el chip:
1. Quitar tornillos de la base
2. Identificar chip principal
3. Buscar: "Ingenic T20", "Ingenic T10", "T31", etc.

---

## 📋 PASO 3: Preparar Materiales

### Necesitarás:

#### Hardware:
- ✅ La cámara Xiaomi
- ✅ **Tarjeta microSD** (4-32 GB, clase 10)
- ✅ Lector de tarjetas SD
- ✅ Computadora (Mac, Linux o Windows)
- ⚠️ **Cable USB-TTL** (opcional, para recuperación)

#### Software:
- ✅ Firmware Dafang Hacks (descarga)
- ✅ Herramienta de formateo SD (SDFormatter)
- ✅ App para SSH (Terminal en Mac)

---

## 🚀 PASO 4: Instalación del Firmware

### A. Preparar Tarjeta SD

#### 1. Formatear SD Card (FAT32)

**En Mac:**
```bash
# Identificar la SD
diskutil list

# Reemplazar diskN con el número correcto (¡CUIDADO!)
diskutil eraseDisk FAT32 DAFANG /dev/diskN
```

**Verificar:**
```bash
diskutil list | grep DAFANG
```

#### 2. Descargar Firmware Dafang Hacks

```bash
cd ~/Downloads

# Descargar última versión
curl -L -O https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks/releases/latest/download/dafang_hacks.zip

# Descomprimir
unzip dafang_hacks.zip -d dafang_firmware
```

#### 3. Copiar archivos a SD

```bash
# Montar SD (si no está montada)
# Debería aparecer en /Volumes/DAFANG

# Copiar todo el contenido
cp -r dafang_firmware/* /Volumes/DAFANG/

# Verificar estructura
ls -la /Volumes/DAFANG/

# Debe contener:
# - factory/
# - config/
# - run.sh
# - README.md
```

#### 4. Configurar WiFi (IMPORTANTE)

Editar archivo de configuración WiFi:

```bash
nano /Volumes/DAFANG/config/wpa_supplicant.conf
```

Contenido:
```conf
network={
    ssid="TU_WIFI_SSID"
    psk="TU_WIFI_PASSWORD"
    key_mgmt=WPA-PSK
}
```

Guardar: Ctrl+X → Y → Enter

#### 5. Configurar RTSP

Editar configuración:
```bash
nano /Volumes/DAFANG/config/rtspserver.conf
```

Contenido:
```conf
RTSP_PORT=554
RTSP_USERNAME=admin
RTSP_PASSWORD=tupassword123
RTSP_STREAM_PATH=/live/ch0
```

#### 6. Expulsar SD

```bash
diskutil eject /Volumes/DAFANG
```

### B. Instalar en Cámara

#### 1. Apagar cámara
Desconectar cable de alimentación.

#### 2. Insertar SD
Insertar la SD preparada en la cámara.

#### 3. Encender cámara
Conectar cable de alimentación.

#### 4. Esperar instalación
- LED parpadeará (instalando firmware)
- Esperar **3-5 minutos**
- LED quedará fijo o empezará a parpadear regularmente
- **NO DESCONECTAR durante este proceso**

#### 5. Verificar conectividad

**Buscar IP de la cámara:**

Opción A - Escaneo de red:
```bash
# Si tienes nmap instalado
nmap -sn 192.168.1.0/24 | grep -B 2 "dafang"

# O buscar puerto 554 abierto
nmap -p 554 --open 192.168.1.0/24
```

Opción B - En tu router:
- Buscar dispositivo nuevo con nombre "dafang" o "xiaomi"

---

## 🧪 PASO 5: Verificar Instalación

### A. Acceso SSH

Una vez tengas la IP:

```bash
# SSH a la cámara
ssh root@IP_CAMARA
# Password por defecto: ismart12
```

Si funciona, verás:
```
Welcome to DAFANG HACKS
```

### B. Verificar RTSP

```bash
# Desde tu Mac
ffmpeg -rtsp_transport tcp -i "rtsp://admin:tupassword123@IP_CAMARA:554/live/ch0" -frames:v 1 test.jpg

# Si funciona, verás una imagen test.jpg
open test.jpg
```

### C. Acceder a Web UI

Abrir en navegador:
```
http://IP_CAMARA
```

**Credenciales por defecto:**
- Usuario: `admin`
- Password: `ismart12`

---

## ⚙️ PASO 6: Configuración Post-Instalación

### A. Cambiar passwords

**SSH a la cámara:**
```bash
ssh root@IP_CAMARA

# Cambiar password root
passwd

# Cambiar password web UI
/system/sdcard/config/userconfig.sh
```

### B. Configurar resolución

Editar `/system/sdcard/config/video.conf`:
```bash
# Para 1080p
VIDEO_WIDTH=1920
VIDEO_HEIGHT=1080
VIDEO_FPS=15
```

### C. Configurar RTSP permanente

Editar `/system/sdcard/config/rtspserver.conf`:
```bash
RTSP_PORT=554
RTSP_USERNAME=admin
RTSP_PASSWORD=tu_password_seguro
RTSP_STREAM_PATH=/live/ch0
RTSP_AUTHENTICATION=1
```

Reiniciar:
```bash
reboot
```

---

## 🎬 PASO 7: Integrar con Frigate

Una vez verificado que RTSP funciona:

### A. Editar configuración de Frigate

```bash
ssh nico@192.168.1.100
cd /home/nico/frigate
nano config/config.yml
```

### B. Agregar cámara

```yaml
cameras:
  # ... cámaras existentes ...

  puerta_frontal:
    enabled: true

    ffmpeg:
      inputs:
        # Stream principal (alta calidad para grabación)
        - path: rtsp://admin:tupassword123@IP_CAMARA:554/live/ch0
          roles:
            - record

        # Stream secundario (baja calidad para detección)
        # Dafang suele tener /live/ch1 para substream
        - path: rtsp://admin:tupassword123@IP_CAMARA:554/live/ch1
          roles:
            - detect

    detect:
      width: 640
      height: 360
      fps: 5
      enabled: true

    motion:
      threshold: 25
      contour_area: 100

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
          min_score: 0.65

    snapshots:
      enabled: true
      timestamp: true
      bounding_box: true
      crop: false

    record:
      enabled: true
      retain:
        days: 7
        mode: motion
      events:
        pre_capture: 5
        post_capture: 5
        retain:
          default: 14
          objects:
            person: 30

    live:
      stream_name: puerta_frontal_live
      quality: 5
      height: 720
```

### C. Reiniciar Frigate

```bash
docker-compose restart
docker logs -f frigate
```

### D. Verificar en UI

Abrir: http://192.168.1.100:5000

Deberías ver la nueva cámara "puerta_frontal" con detección funcionando.

---

## 🚨 Troubleshooting

### Problema: Cámara no arranca después de insertar SD

**Soluciones:**
1. Verificar que SD está correctamente formateada (FAT32)
2. Verificar que archivos están en raíz de SD (no en carpeta)
3. Verificar que `run.sh` tiene permisos de ejecución
4. Probar con otra tarjeta SD

### Problema: LED parpadea indefinidamente

**Causa:** Firmware incompatible o SD corrupta

**Solución:**
1. Quitar SD
2. Reiniciar cámara
3. Si vuelve a funcionar, firmware no es compatible
4. Si no arranca, necesitas USB-TTL para recuperar

### Problema: No encuentra IP de cámara

**Soluciones:**
1. Verificar configuración WiFi en SD
2. Verificar SSID y password correctos
3. Conectar cable Ethernet (si tiene)
4. Escanear red completa:
```bash
nmap -sP 192.168.1.0/24
```

### Problema: RTSP no funciona después de instalación

**Soluciones:**
1. Verificar que rtspserver está corriendo:
```bash
ssh root@IP_CAMARA
ps | grep rtsp
```

2. Verificar configuración:
```bash
cat /system/sdcard/config/rtspserver.conf
```

3. Reiniciar servicio:
```bash
/system/sdcard/controlscripts/rtsp stop
/system/sdcard/controlscripts/rtsp start
```

### Problema: Cámara "bricked"

**Recuperación con USB-TTL:**
1. Desmontar cámara
2. Conectar USB-TTL a UART pins
3. Usar minicom/screen para acceder
4. Reinstalar firmware original o Dafang

*Esto requiere conocimientos avanzados. Mejor prevenir que curar.*

---

## 📚 Recursos y Enlaces

### Documentación Oficial:
- **GitHub Dafang Hacks:** https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks
- **Wiki:** https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks/wiki
- **Dispositivos compatibles:** https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks/blob/master/DEVICES.md
- **FAQ:** https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks/wiki/FAQ

### Comunidad:
- **Reddit r/homesecurity**
- **Home Assistant Community**
- **GitHub Issues del proyecto**

### Videos tutoriales:
- YouTube: "Xiaomi Dafang Hacks installation"
- YouTube: "Xiaomi camera RTSP custom firmware"

---

## ⚖️ Alternativa Más Segura

Si tienes dudas o la cámara no es compatible, **considera reemplazar por cámara Tapo:**

### Ventajas Tapo vs Firmware Custom:
- ✅ Sin riesgo de brick
- ✅ Garantía intacta
- ✅ Instalación en 5 minutos
- ✅ RTSP nativo
- ✅ Mejor calidad de imagen
- ✅ Soporte oficial
- ✅ App funcional

### Precio:
- Tapo C310: ~$30-35 USD
- Tapo C320WS: ~$40-45 USD

### ROI:
- Tiempo de firmware custom: 3-5 horas
- Tiempo instalación Tapo: 5 minutos
- Riesgo: 0 vs medio-alto

---

## 📋 Checklist Pre-Instalación

Antes de comenzar, confirma:

- [ ] Modelo exacto de cámara identificado
- [ ] Cámara compatible con Dafang Hacks
- [ ] Tarjeta SD preparada (4-32GB, FAT32)
- [ ] Configuración WiFi lista (SSID + password)
- [ ] Backup de configuración actual (si es posible)
- [ ] Tiempo disponible (2-3 horas)
- [ ] Entiendes los riesgos
- [ ] Tienes plan B (comprar Tapo si falla)

---

## 🎯 DECISIÓN RECOMENDADA

### Opción A: Firmware Custom
**Recomendado SI:**
- ✅ La cámara es compatible
- ✅ Tienes experiencia técnica
- ✅ Tienes tiempo
- ✅ Entiendes los riesgos
- ✅ No te importa perder la garantía

### Opción B: Comprar Tapo
**Recomendado SI:**
- ✅ Quieres solución rápida
- ✅ No quieres riesgos
- ✅ Valoras tu tiempo
- ✅ Quieres garantía

**Mi recomendación personal:** Compra una Tapo C310 (~$35) y usa la Xiaomi solo para control básico o como backup. El tiempo y riesgo de firmware custom no vale la pena para el precio de una cámara nueva.

---

**¿Listo para proceder?** Primero identifica el modelo exacto en la app Xiaomi Home y verifica compatibilidad.


