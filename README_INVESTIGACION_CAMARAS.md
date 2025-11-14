# 🔍 Investigación de Cámaras - Home Assistant

## 📋 Resumen Ejecutivo

Se realizó una investigación completa del sistema de cámaras en tu Home Assistant.

### Hallazgos Principales:

✅ **Frigate está instalado y funcionando** con 2 cámaras Tapo
⚠️ **Cámara Xiaomi detectada pero sin detección IA**
✅ **8 automatizaciones activas con Frigate**
🎯 **Posible integrar Xiaomi con Frigate si tiene RTSP**

---

## 📁 Archivos Generados

### 📊 Scripts de Investigación:
- **`investigate_cameras.py`** - Investigación completa de todas las cámaras y automatizaciones
- **`get_xiaomi_camera_info.py`** - Información específica de la cámara Xiaomi
- **`test_rtsp_xiaomi.sh`** - Script para probar acceso RTSP automáticamente

### 📖 Documentación:
- **`RESUMEN_INVESTIGACION.md`** - Resumen completo de hallazgos ⭐
- **`INFORME_CAMARA_XIAOMI.md`** - Informe detallado de la cámara Xiaomi
- **`COMANDOS_UTILES.md`** - Comandos útiles y referencia rápida
- **`camera_investigation_report.json`** - Reporte completo en JSON

---

## 🚀 Inicio Rápido

### 1️⃣ Ver Resumen de Investigación
```bash
cat RESUMEN_INVESTIGACION.md
```

### 2️⃣ Investigar Sistema Completo
```bash
python3 investigate_cameras.py
```

### 3️⃣ Obtener Info de Cámara Xiaomi
```bash
python3 get_xiaomi_camera_info.py
```

### 4️⃣ Probar RTSP (necesitas IP de la cámara)
```bash
./test_rtsp_xiaomi.sh 192.168.1.XXX
```

---

## 🎯 Cámara Xiaomi - Situación Actual

### ✅ Lo que FUNCIONA:
- Conectividad (estado: `home`)
- Control on/off
- Configuración de detección de movimiento
- Info de almacenamiento (238 GB SD, 99% llena ⚠️)
- Switches de configuración

### ❌ Lo que NO funciona:
- Stream de video en Home Assistant
- Binary sensors de detección
- Detección inteligente de personas/objetos
- Snapshots en automatizaciones

### 🔧 Por qué:
La integración `xiaomi_home` es para **CONTROL**, no para **VISUALIZACIÓN** ni **DETECCIÓN IA**.

---

## 💡 Solución Propuesta: Integrar con Frigate

### Requisitos:
1. Cámara debe tener **RTSP** habilitado
2. Obtener **IP** de la cámara
3. Obtener **credenciales RTSP**

### Beneficios:
✅ Stream visible en Home Assistant
✅ Detección IA (personas, vehículos, animales)
✅ Binary sensors para automatizaciones
✅ Snapshots con bounding boxes
✅ Grabación inteligente en servidor
✅ Timeline de eventos

---

## 📝 Pasos Siguientes

### Paso 1: Obtener IP de la Cámara

**Opción A:** App Xiaomi Home
- Abrir app → Front door cam → Configuración → Info del dispositivo

**Opción B:** Router
- Buscar dispositivo "chuangmi_camera_029a02"

**Opción C:** Ejecutar script
```bash
python3 get_xiaomi_camera_info.py
```

### Paso 2: Probar RTSP

Una vez tengas la IP:
```bash
./test_rtsp_xiaomi.sh IP_CAMARA
```

Ejemplo:
```bash
./test_rtsp_xiaomi.sh 192.168.1.150
```

El script probará automáticamente múltiples URLs y credenciales.

### Paso 3A: Si RTSP Funciona ✅

1. Editar configuración de Frigate:
```bash
ssh nico@192.168.1.100
nano /home/nico/frigate/config/config.yml
```

2. Agregar configuración (ver ejemplo en `RESUMEN_INVESTIGACION.md`)

3. Reiniciar Frigate:
```bash
docker-compose restart
```

4. Verificar en UI: http://192.168.1.100:5000

5. Crear automatizaciones con nuevos binary sensors

### Paso 3B: Si RTSP NO Funciona ❌

**Opciones:**

A. **Instalar firmware custom** (avanzado)
   - Xiaomi Dafang Hacks
   - Requiere conocimientos técnicos
   - Puede invalidar garantía

B. **Reemplazar cámara** (recomendado)
   - Tapo C310/C320WS (~$30-50)
   - Reolink E1 Pro
   - Cualquier con RTSP nativo

C. **Mantener como está** (limitado)
   - Solo control básico
   - Sin video en HA
   - Sin detección IA

---

## 📊 Comparativa: Antes vs Después

| Característica | SIN Frigate | CON Frigate |
|----------------|-------------|-------------|
| Stream en HA | ❌ | ✅ |
| Detección IA | ❌ | ✅ |
| Binary Sensors | ❌ | ✅ |
| Snapshots | ❌ | ✅ |
| Automatizaciones avanzadas | ❌ | ✅ |
| Grabación servidor | ❌ | ✅ |

---

## 🛠️ Herramientas Disponibles

### Scripts Python:
```bash
# Investigación completa
python3 investigate_cameras.py

# Info de Xiaomi
python3 get_xiaomi_camera_info.py

# Manager general de HA
python3 ha_manager.py status
```

### Scripts Bash:
```bash
# Test RTSP automático
./test_rtsp_xiaomi.sh IP_CAMARA
```

---

## 📚 Documentación Completa

### Lee estos archivos en orden:

1. **`RESUMEN_INVESTIGACION.md`** ⭐ - Empieza aquí
   - Resumen ejecutivo
   - Hallazgos principales
   - Plan de acción

2. **`INFORME_CAMARA_XIAOMI.md`** - Detalles técnicos
   - Todas las entidades de la cámara
   - Análisis de integración
   - Problemas identificados

3. **`COMANDOS_UTILES.md`** - Referencia rápida
   - Comandos útiles
   - Troubleshooting
   - Tests rápidos

---

## 🔗 Recursos Externos

- **Frigate Documentation:** https://docs.frigate.video
- **Xiaomi Camera Hacks:** https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks
- **Tapo Integration:** https://github.com/JurajNyiri/HomeAssistant-Tapo-Control
- **Cámaras compatibles con Frigate:** https://docs.frigate.video/frigate/camera_setup

---

## ⚠️ Advertencias

### Tarjeta SD 99% Llena
La cámara Xiaomi tiene la SD llena (32 MB libres de 238 GB).

**Solución:**
```bash
# Formatear desde HA (perderás grabaciones)
curl -X POST \
  -H "Authorization: Bearer TU_TOKEN" \
  http://192.168.1.100:8123/api/services/button/press \
  -d '{"entity_id": "button.chuangmi_us_447604776_029a02_format_a_4_1"}'
```

O desde la app Xiaomi Home: Configuración → Almacenamiento → Formatear

---

## 📞 Siguiente Paso

**Ejecuta este script para obtener la IP y probar RTSP:**

```bash
python3 get_xiaomi_camera_info.py
```

Luego, si obtienes la IP:
```bash
./test_rtsp_xiaomi.sh IP_QUE_OBTUVISTE
```

**Si el test RTSP funciona:** ¡Estás listo para integrar con Frigate!
**Si el test RTSP falla:** Considera alternativas (firmware custom o nueva cámara)

---

## 📊 Estado de Automatizaciones

### ✅ Activas y Funcionando:
- 🚨 Frigate - Entrada - PERSONA
- 🚗 Frigate - Entrada - VEHÍCULO
- 🚨 Frigate - Exterior - PERSONA
- 🚗 Frigate - Exterior - VEHÍCULO (última detección: hoy 16:43) ✅
- 🐕 Frigate - Entrada - ANIMAL
- Reset Manual V3.3
- Test Manual V3.3
- Simulación de Presencia
- Atardecer Inteligente
- Regreso a Casa
- Al Amanecer
- Anochecer

### ❌ Deshabilitadas (29):
La mayoría son versiones antiguas de automatizaciones que fueron reemplazadas por las de Frigate V3.3.

---

## 🎬 Sistema Frigate Actual

### Cámaras Integradas:

1. **Entrada (Tapo C530WS)**
   - Estado: ✅ Recording
   - Detección IA: ✅ Activa
   - Binary sensors: ✅ Funcionando

2. **Exterior (Tapo C310)**
   - Estado: ✅ Recording
   - Detección IA: ✅ Activa
   - Binary sensors: ✅ Funcionando

### Próxima Cámara:

3. **Puerta Frontal (Xiaomi Chuangmi)** 🎯
   - Pendiente verificar RTSP
   - Integrar con Frigate
   - Obtener detección IA

---

## 🏆 Objetivo Final

**Tener 3 cámaras con detección IA en Frigate:**
1. ✅ Entrada (Tapo C530WS) - Listo
2. ✅ Exterior (Tapo C310) - Listo
3. 🎯 Puerta Frontal (Xiaomi) - Pendiente RTSP

**Una vez completado:**
- 3 cámaras con IA
- 15+ binary sensors para automatizaciones
- Detección de personas, vehículos, animales
- Grabación inteligente centralizada
- Notificaciones con snapshots procesados
- Timeline unificado de eventos

---

**Creado:** 14 de Noviembre, 2025
**Por:** Sistema de Investigación Automatizado
**Para:** Maui - Home Assistant Blueprints

**¿Preguntas?** Lee `RESUMEN_INVESTIGACION.md` para más detalles.

