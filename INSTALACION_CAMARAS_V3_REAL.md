# 📹 Instalación Sistema de Alertas de Cámaras V3 (ADAPTADO)

> **Versión final adaptada a las entidades REALES de tu integración Tapo**

## ✅ Pre-requisitos (YA CUMPLIDOS)

- [x] Integración "Tapo: Cameras Control" (JurajNyiri) instalada
- [x] C530WS Entrada configurada y funcionando
- [x] C310 Exterior configurada y funcionando  
- [x] 137 entidades Tapo disponibles
- [x] Binary sensor `binary_sensor.tapo_c530ws_entrada_motion_alarm` funcionando

---

## 📦 Paso 1: Actualizar Helpers en `configuration.yaml`

### 1.1. Agregar nuevos helpers

Actualiza tu `configuration.yaml` con los siguientes cambios (YA ACTUALIZADOS EN `HA_config_proxy/configuration.yaml`):

```yaml
# ──────────────────────────────────────────────────────────────
# INPUT SELECT - Nuevo en V3
# ──────────────────────────────────────────────────────────────
input_select:
  camera_alert_type:
    name: Tipo de Alerta
    options:
      - "Ninguna"
      - "Movimiento"
      - "Persona"
      - "Vehículo"
      - "Mascota"
      - "Test"
    initial: "Ninguna"
    icon: mdi:eye-settings

# ──────────────────────────────────────────────────────────────
# INPUT DATETIME - Nuevo en V3
# ──────────────────────────────────────────────────────────────
input_datetime:
  camera_alert_last_trigger:
    name: Última Detección de Cámara
    has_date: true
    has_time: true
    icon: mdi:calendar-clock
```

---

## 📝 Paso 2: Actualizar Automatizaciones

Las automatizaciones ya están actualizadas en `HA_config_proxy/automations.yaml`.

**Incluyen:**

1. **📹 Entrada - Detección (Binary Sensor)** 
   - Trigger: `binary_sensor.tapo_c530ws_entrada_motion_alarm`
   - ✅ USA BINARY SENSOR REAL
   - ✅ Sirena, snapshot, notificación, floodlight
   - ✅ Encadena `scene.anochecer`

2. **📹 Exterior - Detección (Webhook)**
   - Trigger: `webhook_id: tapo_c310_exterior_motion_detected`
   - ⚠️  C310 no tiene binary sensor
   - ✅ Mismo comportamiento que Entrada

3. **Reset Manual de Alertas**
   - Limpia sistema manualmente

4. **Test Manual - Alertas de Cámaras**
   - Para probar sin esperar detección real

---

## 📂 Paso 3: Crear Directorio de Snapshots

```bash
# Dentro del contenedor Docker de HA
docker exec -it homeassistant bash
cd /config
mkdir -p www/snapshots
chmod 755 www/snapshots
exit
```

O desde SSH:

```bash
cd /home/nico/docker-config/homeassistant
mkdir -p www/snapshots
chmod 755 www/snapshots
```

---

## 🔄 Paso 4: Aplicar Cambios en el Servidor

### 4.1. Copiar archivos actualizados

```bash
# Desde tu máquina local, conectado por SSH:
scp HA_config_proxy/configuration.yaml nico@192.168.1.100:/home/nico/docker-config/homeassistant/
scp HA_config_proxy/automations.yaml nico@192.168.1.100:/home/nico/docker-config/homeassistant/
```

### 4.2. Reiniciar Home Assistant

**Opción A: Desde la UI**
```
Configuración → Sistema → Reiniciar
```

**Opción B: Desde terminal**
```bash
docker restart homeassistant
```

---

## ✅ Paso 5: Verificar Instalación

### 5.1. Verificar helpers creados

```
Configuración → Dispositivos y servicios → Helpers
```

Buscar:
- ✅ `camera_alert_type` (Selector)
- ✅ `camera_alert_last_trigger` (Fecha/Hora)

### 5.2. Verificar automatizaciones cargadas

```
Configuración → Automatizaciones y escenas
```

Buscar:
- ✅ `📹 Entrada - Detección (Binary Sensor)`
- ✅ `📹 Exterior - Detección (Webhook)`
- ✅ `Reset Manual de Alertas de Cámaras`
- ✅ `Test Manual - Alertas de Cámaras`

---

## 🧪 Paso 6: Test del Sistema

### Test 1: Simulación Manual

1. Ir a: **Configuración → Dispositivos y servicios → Helpers**
2. Buscar: `camera_alert_active`
3. Cambiar valor a: `test`
4. **Resultado esperado:**
   - Alerta aparece en dashboard por 15 segundos
   - Notificación en celular
   - Log en logbook

### Test 2: Binary Sensor Real (C530WS)

1. Pasar la mano frente a la cámara de entrada
2. **Resultado esperado:**
   - Binary sensor cambia a `on`
   - Widget se agranda en dashboard
   - Sirena suena por 10 segundos
   - Floodlight se enciende
   - Notificación con snapshot
   - Se activa `scene.anochecer`
   - Después de 45 segundos: widget vuelve a tamaño normal

### Test 3: Webhook Manual (C310)

**Activar webhook:**

```bash
curl -X POST http://192.168.1.100:8123/api/webhook/tapo_c310_exterior_motion_detected \
  -H "Content-Type: application/json"
```

**Resultado esperado:**
- Igual que Test 2 pero para cámara exterior

---

## 🎯 Diferencias Clave vs V2

| Aspecto | V2 (Obsoleto) | V3 (Actual) |
|---------|---------------|-------------|
| Trigger Entrada | Webhook inexistente | ✅ Binary sensor REAL |
| Trigger Exterior | Webhook inexistente | Webhook manual |
| Sirena | ❌ No funcionaba | ✅ `siren.turn_on` |
| Snapshot | ❌ No incluido | ✅ Con timestamp |
| Notificación | ❌ Sin imagen | ✅ Con imagen |
| Floodlight | ❌ No incluido | ✅ Brightness 255 |
| Encadenamiento | ❌ No disponible | ✅ `scene.anochecer` |
| Test | ❌ No disponible | ✅ Modo test |

---

## 🚨 Troubleshooting

### ❌ Problema: Binary sensor no se activa

**Verificar:**
```bash
# Desde Developer Tools → States
binary_sensor.tapo_c530ws_entrada_motion_alarm
```

**Solución:**
1. Verificar que la detección de movimiento esté habilitada en la cámara
2. Verificar que `switch.tapo_c530ws_entrada_motion_detection` esté en `on`

### ❌ Problema: Sirena no suena

**Verificar:**
```bash
# Desde Developer Tools → Services
siren.turn_on
entity_id: siren.tapo_c530ws_entrada_siren
```

**Si no funciona:**
- Verificar que la sirena esté habilitada en la app Tapo
- Verificar volumen: `number.tapo_c530ws_entrada_siren_volume`

### ❌ Problema: Snapshots no se guardan

**Verificar directorio:**
```bash
docker exec homeassistant ls -la /config/www/snapshots
```

**Si no existe:**
```bash
docker exec homeassistant mkdir -p /config/www/snapshots
docker exec homeassistant chmod 755 /config/www/snapshots
```

### ❌ Problema: Notificaciones sin imagen

**Verificar ruta:**
```
/local/snapshots/entrada_YYYYMMDD_HHMMSS.jpg
```

Debe corresponder a:
```
/config/www/snapshots/entrada_YYYYMMDD_HHMMSS.jpg
```

---

## 🎉 Sistema Completo

Una vez completados todos los pasos:

✅ **Cámara Entrada (C530WS):**
- Detección automática por binary sensor
- Alerta visual en dashboard
- Sirena + floodlight
- Snapshot + notificación
- Encadena scene.anochecer

✅ **Cámara Exterior (C310):**
- Detección manual por webhook
- Mismo comportamiento que Entrada

✅ **Extensible:**
- Fácil agregar más comportamientos
- Fácil agregar más cámaras
- Test manual disponible

---

## 📚 Archivos Relacionados

- `examples/camera_alert_system_v3_real.yaml` - Automatizaciones listas para copiar
- `examples/camera_alert_helpers.yaml` - Helpers actualizados
- `docs/CAMERA_ALERTS_V3.md` - Documentación técnica
- `HA_config_proxy/configuration.yaml` - Configuration.yaml actualizado
- `HA_config_proxy/automations.yaml` - Automations.yaml actualizado

---

## 🔗 Próximos Pasos

1. **Instalar Webhook para C310:**
   - Configurar IFTTT o Tasker para disparar webhook
   - O usar Tapo app notifications + Automation

2. **Mejorar Dashboard:**
   - Widget con información de última detección
   - Galería de snapshots recientes

3. **Agregar más comportamientos:**
   - Grabar clip de video
   - Enviar snapshot a Telegram
   - Activar otras escenas según hora

---

**¿Listo para instalar?** 🚀

Sigue los pasos 1-6 en orden y tendrás el sistema funcionando en ~15 minutos.

