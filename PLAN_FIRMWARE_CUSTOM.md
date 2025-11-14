# 🔧 Plan de Acción: Firmware Custom para Cámara Xiaomi

**Estado:** Cámara no tiene RTSP nativo
**Solución elegida:** Instalar firmware custom (Dafang Hacks)
**Objetivo:** Habilitar RTSP para integrar con Frigate

---

## ⚠️ ADVERTENCIAS CRÍTICAS

### 🚨 ANTES DE EMPEZAR:

```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│  ⚠️  ESTO PUEDE DEJAR TU CÁMARA INSERVIBLE             │
│                                                          │
│  Riesgos:                                               │
│  • Invalidar garantía                                   │
│  • "Brick" permanente (cámara muerta)                   │
│  • Perder acceso a app Xiaomi Home                      │
│  • Perder funciones cloud                               │
│  • Proceso no reversible fácilmente                     │
│                                                          │
│  ⚠️  SOLO PROCEDE SI ACEPTAS ESTOS RIESGOS             │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### 🤔 ¿Vale la pena?

**Costo/beneficio:**
- Tiempo: 2-4 horas
- Riesgo: Medio-Alto
- Cámara nueva Tapo: $30-35 USD
- Tiempo Tapo: 5 minutos
- Riesgo Tapo: 0

**Mi recomendación honesta:**
Comprar una Tapo C310 es más sensato que arriesgar la cámara actual.

---

## 📋 ANTES DE EMPEZAR - CHECKLIST

### Paso 0: Identificar Modelo

Primero, **DEBES identificar el modelo exacto** de tu cámara.

**En la app Xiaomi Home:**
1. Abrir app
2. Seleccionar "Front door cam"
3. Ir a ⚙️ Configuración
4. Buscar "Device Information" / "Información del dispositivo"
5. Anotar:
   - [ ] Modelo exacto (ej: CMSXJ01C, CMSXJ11A)
   - [ ] Versión de firmware
   - [ ] Número de serie

**Verificar compatibilidad:**
1. Ir a: https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks/blob/master/DEVICES.md
2. Buscar tu modelo
3. Si NO está en la lista → **DETENTE AQUÍ**

### Paso 1: Materiales Necesarios

- [ ] Cámara Xiaomi (modelo compatible)
- [ ] **Tarjeta microSD** (4-32 GB, Clase 10)
- [ ] Lector de tarjetas SD
- [ ] Mac/PC con acceso a terminal
- [ ] Tiempo disponible (2-4 horas)
- [ ] Paciencia y concentración

### Paso 2: Backups

- [ ] Anotar configuración actual de cámara
- [ ] Tomar fotos de configuración en app
- [ ] Guardar credenciales WiFi

### Paso 3: Preparación Mental

- [ ] Entiendo los riesgos
- [ ] Acepto pérdida de garantía
- [ ] Tengo plan B si falla (comprar cámara nueva)
- [ ] No tengo prisa

---

## 🚀 PROCESO DE INSTALACIÓN

### Método A: Script Automatizado (Recomendado)

El script hace todo automáticamente:

```bash
# 1. Ejecutar script
cd /Users/maui/_maui/domotica/home-assistant-blueprints
./prepare_dafang_sd.sh

# 2. Seguir instrucciones en pantalla
#    - Seleccionar disco SD
#    - Ingresar SSID WiFi
#    - Ingresar password WiFi
#    - Configurar RTSP

# 3. Esperar a que termine
#    El script:
#    ✅ Formatea la SD
#    ✅ Descarga firmware
#    ✅ Copia archivos
#    ✅ Configura WiFi
#    ✅ Configura RTSP
#    ✅ Expulsa SD

# 4. Insertar SD en cámara
# 5. Encender cámara
# 6. Esperar 3-5 minutos
# 7. Buscar IP
# 8. Probar RTSP
```

### Método B: Manual

Ver guía completa en:
```bash
cat docs/XIAOMI_FIRMWARE_CUSTOM_GUIA.md
```

---

## 📊 TIMELINE ESPERADO

```
00:00 - Inicio
│
├─ 00:05 - Identificar modelo en app Xiaomi
├─ 00:10 - Verificar compatibilidad online
├─ 00:15 - Ejecutar script prepare_dafang_sd.sh
├─ 00:20 - Script descarga firmware
├─ 00:25 - Script configura SD
├─ 00:30 - Insertar SD en cámara
│
├─ 00:35 - Encender cámara
│          └─ LED parpadea (instalando)
├─ 00:40 - Esperar...
├─ 00:45 - Esperar...
│
├─ 00:50 - LED se estabiliza (instalado)
├─ 00:55 - Buscar IP en red
├─ 01:00 - Probar RTSP
│
├─ 01:10 - Si funciona: Configurar Frigate
├─ 01:20 - Reiniciar Frigate
├─ 01:25 - Verificar detección
│
└─ 01:30 - ✅ COMPLETADO
```

**Tiempo total: 1.5 - 2 horas**
(Si todo sale bien)

---

## 🧪 DESPUÉS DE LA INSTALACIÓN

### 1. Buscar IP de la cámara

```bash
# Opción A: nmap
nmap -sn 192.168.1.0/24 | grep -B 2 "dafang"

# Opción B: buscar puerto 554 abierto
nmap -p 554 --open 192.168.1.0/24

# Opción C: en tu router
# Buscar dispositivo "dafang" o nuevo dispositivo
```

### 2. Probar SSH

```bash
ssh root@IP_CAMARA
# Password por defecto: ismart12

# Si funciona, verás:
# Welcome to DAFANG HACKS
```

### 3. Probar RTSP

```bash
# Usando configuración que ingresaste en script
ffmpeg -rtsp_transport tcp \
  -i "rtsp://USUARIO:PASSWORD@IP_CAMARA:554/live/ch0" \
  -frames:v 1 test_dafang.jpg

# Si funciona, verás una imagen
open test_dafang.jpg
```

### 4. Acceder a Web UI

```
http://IP_CAMARA

Usuario: admin
Password: ismart12
```

### 5. Cambiar passwords

```bash
ssh root@IP_CAMARA

# Cambiar password root
passwd

# Cambiar password web UI
nano /system/sdcard/config/userconfig.sh
```

---

## 🎬 INTEGRAR CON FRIGATE

Una vez verificado que RTSP funciona:

### 1. SSH al servidor

```bash
ssh nico@192.168.1.100
```

### 2. Editar configuración Frigate

```bash
cd /home/nico/frigate
nano config/config.yml
```

### 3. Agregar cámara

```yaml
cameras:
  puerta_frontal:
    enabled: true

    ffmpeg:
      inputs:
        - path: rtsp://admin:tupassword@IP_CAMARA:554/live/ch0
          roles:
            - record
            - detect

    detect:
      width: 640
      height: 360
      fps: 5

    objects:
      track:
        - person
        - car

    snapshots:
      enabled: true
      timestamp: true
      bounding_box: true

    record:
      enabled: true
      retain:
        days: 7
```

### 4. Reiniciar Frigate

```bash
docker-compose restart
docker logs -f frigate
```

### 5. Verificar en UI

```
http://192.168.1.100:5000
```

---

## 🚨 TROUBLESHOOTING

### Problema: LED parpadea indefinidamente

**Causa:** Firmware incompatible o SD corrupta

**Solución:**
1. Apagar cámara
2. Quitar SD
3. Reiniciar cámara
4. Si vuelve a firmware original → cámara OK pero incompatible
5. Si no arranca → necesitas recuperación con USB-TTL

### Problema: Cámara no se enciende después de SD

**Solución:**
1. Quitar SD
2. Intentar encender sin SD
3. Si no enciende → posible brick
4. Contactar soporte técnico o buscar servicio de reparación

### Problema: No encuentra IP en red

**Solución:**
1. Verificar LED (debe estar fijo o parpadeando regularmente)
2. Verificar configuración WiFi en SD (SSID/password correctos)
3. Reintentar formateo y copia de archivos
4. Probar con otra tarjeta SD

### Problema: RTSP no funciona

**Solución:**
```bash
# SSH a la cámara
ssh root@IP_CAMARA

# Verificar que rtsp está corriendo
ps | grep rtsp

# Ver logs
cat /var/log/rtsp.log

# Reiniciar servicio
/system/sdcard/controlscripts/rtsp restart
```

---

## 🆘 PLAN DE EMERGENCIA

### Si algo sale mal:

#### Escenario 1: Cámara no arranca con SD
```
✅ SOLUCIÓN: Quitar SD, cámara debería volver a funcionar
```

#### Escenario 2: Cámara no arranca sin SD
```
⚠️  PROBLEMA: Posible brick
📞 ACCIÓN: Necesitas recuperación con USB-TTL (avanzado)
💡 ALTERNATIVA: Buscar servicio técnico especializado
💰 OPCIÓN: Comprar cámara nueva
```

#### Escenario 3: RTSP no funciona después de instalación
```
✅ SOLUCIÓN: Revisar configuración
✅ ALTERNATIVA: Usar cámara con firmware Dafang pero sin Frigate
```

#### Escenario 4: Todo falla
```
💰 Comprar Tapo C310 (~$35)
⏱️  5 minutos de instalación
✅ RTSP nativo
✅ Garantía
✅ Sin dolores de cabeza
```

---

## 💰 ANÁLISIS COSTO/BENEFICIO

### Opción A: Firmware Custom

**Costos:**
- Tiempo: 2-4 horas
- Tarjeta SD: $5-10 (si no tienes)
- Riesgo de brick: $0-50 (valor de cámara)
- Estrés: Alto

**Beneficios:**
- Aprendizaje técnico: Alto
- Control total: Sí
- Costo monetario: Bajo
- RTSP: Sí (si funciona)

### Opción B: Comprar Tapo

**Costos:**
- Dinero: $30-35
- Tiempo: 5 minutos
- Riesgo: 0
- Estrés: 0

**Beneficios:**
- RTSP nativo: Sí
- Calidad imagen: Mejor
- Garantía: Sí
- Funciona: Garantizado

---

## 🎯 MI RECOMENDACIÓN FINAL

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│  Si valoras tu tiempo y tranquilidad:                 │
│  → Compra Tapo C310 ($35)                            │
│                                                        │
│  Si quieres aprender y experimentar:                  │
│  → Instala firmware custom                            │
│                                                        │
│  Si la cámara no es crítica:                          │
│  → Vale la pena intentar firmware custom              │
│                                                        │
│  Si la cámara es importante:                          │
│  → NO arriesgues, compra Tapo                        │
│                                                        │
└────────────────────────────────────────────────────────┘
```

**Mi consejo personal:**
Usa el dinero de una cena afuera ($35) y compra una Tapo. Ahorra 4 horas de trabajo y 0% de riesgo. La cámara Xiaomi déjala como está para control básico o como backup.

---

## 📁 ARCHIVOS DE SOPORTE

### Documentación:
- **`docs/XIAOMI_FIRMWARE_CUSTOM_GUIA.md`** - Guía detallada paso a paso
- **`PLAN_FIRMWARE_CUSTOM.md`** - Este documento

### Scripts:
- **`prepare_dafang_sd.sh`** - Preparación automatizada de SD
- **`test_rtsp_xiaomi.sh`** - Probar RTSP después de instalación

### Configuración:
- **`~/dafang_config.txt`** - Se creará con tu configuración después de ejecutar el script

---

## 🚀 DECISIÓN FINAL

**¿Qué vas a hacer?**

### A. Proceder con Firmware Custom

```bash
# Ejecuta:
./prepare_dafang_sd.sh

# Y sigue las instrucciones
```

### B. Comprar Tapo C310

```bash
# Enlaces de compra:
# - Amazon: ~$30-35 USD
# - MercadoLibre: ~$35-40 USD
# - AliExpress: ~$25-30 USD (envío lento)

# Instalación:
# 1. Desempacar
# 2. Conectar a corriente
# 3. Configurar en app Tapo (2 min)
# 4. Habilitar RTSP en configuración
# 5. Agregar a Frigate (3 min)
# 6. ¡Listo!
```

---

**Fecha de creación:** 14 de Noviembre, 2025
**Última actualización:** 14 de Noviembre, 2025

**¿Listo para empezar?** Identifica primero el modelo exacto de tu cámara en la app Xiaomi Home.

