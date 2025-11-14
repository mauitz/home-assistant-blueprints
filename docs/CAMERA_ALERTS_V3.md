# 📹 Sistema de Alertas de Cámaras V3 - Con Binary Sensors Reales

**Versión:** 3.0  
**Fecha:** Noviembre 2025  
**Estado:** ✅ Producción  

---

## 🎯 Objetivo

Crear un sistema robusto de alertas de cámaras Tapo basado en **binary sensors reales** de detección, eliminando las limitaciones de las versiones anteriores y permitiendo encadenar comportamientos complejos.

---

## ❌ Problemas de las Versiones Anteriores

### V1 y V2:
- ❌ No usaban binary sensors reales
- ❌ Dependían de webhooks que las cámaras no soportan nativamente
- ❌ Estado de cámara (`idle` → `recording`) no es confiable
- ❌ No se pueden probar fácilmente
- ❌ No permiten diferenciar entre movimiento y persona

---

## ✅ Mejoras de V3

### Ventajas:
- ✅ **Binary sensors reales** de detección
- ✅ **Diferencia entre movimiento y persona**
- ✅ **Snapshots** automáticos con timestamp
- ✅ **Alarmas** integradas (sirena/luz de cámara)
- ✅ **Notificaciones** con imágenes
- ✅ **Encadenamiento** de comportamientos
- ✅ **Control local** (no depende de cloud)
- ✅ **Testeable** fácilmente

---

## 📦 Requisitos Previos

### 1. Integración Correcta Instalada

**DEBE estar instalada:**
- "Tapo: Cameras Control" de JurajNyiri
- Vía HACS
- Con control local habilitado

**Ver guía completa:** `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md`

### 2. Entidades Requeridas

**Deben existir estos binary sensors:**
- `binary_sensor.tapo_c530ws_entrada_motion`
- `binary_sensor.tapo_c530ws_entrada_person`
- `binary_sensor.tapo_c310_exterior_motion`
- `binary_sensor.tapo_c310_exterior_person`

**Switches de alarma:**
- `switch.tapo_c530ws_entrada_alarm`
- `switch.tapo_c310_exterior_alarm`

**Cámaras HD/SD:**
- `camera.tapo_c530ws_entrada_hd`
- `camera.tapo_c530ws_entrada_sd`
- `camera.tapo_c310_exterior_hd`
- `camera.tapo_c310_exterior_sd`

### 3. Configuración de Snapshots

**Crear directorio:**
```bash
mkdir -p /config/www/snapshots
chmod 755 /config/www/snapshots
```

---

## 🏗️ Arquitectura del Sistema

### Componentes:

```
┌─────────────────────────────────────────┐
│  Cámara Tapo (Hardware)                 │
│  • Detecta movimiento/persona           │
│  • Dispara binary sensor                │
└───────────────┬─────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────┐
│  Binary Sensor (HA)                     │
│  • binary_sensor.*_motion               │
│  • binary_sensor.*_person               │
└───────────────┬─────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────┐
│  Automatización (Trigger)               │
│  • Diferencia movimiento vs persona     │
│  • Aplica condiciones (presencia, etc)  │
└───────────────┬─────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────┐
│  Acciones Encadenadas                   │
│  1. Actualizar helpers                  │
│  2. Capturar snapshot                   │
│  3. Activar alarma (si es persona)      │
│  4. Enviar notificación                 │
│  5. Ejecutar escena                     │
│  6. Dashboard agranda cámara            │
│  7. Auto-reset después de X segundos    │
└─────────────────────────────────────────┘
```

---

## 📋 Automatizaciones V3

### 1. Entrada - Detección de Persona (Alta Prioridad)

**Trigger:** `binary_sensor.tapo_c530ws_entrada_person` → `on`

**Condición:** Usuario no está en casa

**Acciones:**
1. Actualizar helper `camera_alert_active` → `entrada`
2. Capturar snapshot HD
3. **Activar alarma** de cámara (sirena/luz)
4. Enviar notificación **CRÍTICA** con imagen
5. Encender luces (escena anochecer)
6. Agregar widget en dashboard
7. Esperar **60 segundos**
8. Desactivar alarma
9. Reset automático

**Mode:** `restart` (nueva detección reinicia timer)

---

### 2. Entrada - Detección de Movimiento (Prioridad Normal)

**Trigger:** `binary_sensor.tapo_c530ws_entrada_motion` → `on`

**Condición:** 
- Usuario no está en casa
- NO es persona (ya tiene otra automatización)

**Acciones:**
1. Actualizar helper
2. Capturar snapshot SD (más rápido)
3. Log en logbook
4. Agregar widget
5. Esperar **30 segundos**
6. Reset automático

**NO activa alarma ni notificación** (solo movimiento)

---

### 3. Exterior - Detección de Persona

Similar a "Entrada - Persona" pero para cámara exterior.

---

### 4. Exterior - Detección de Movimiento

Similar a "Entrada - Movimiento" pero para cámara exterior.

---

### 5. Reset Manual

Permite resetear el sistema manualmente si algo falla.

---

## 🎨 Dashboard V3 (Sin cambios)

El dashboard sigue usando el mismo sistema de conditional cards:
- Modo normal: ambas cámaras 16:9
- Modo alerta: cámara detectada 21:9 con borde rojo

**No requiere cambios** ya que usa `input_text.camera_alert_active`.

---

## 🔧 Instalación

### Paso 1: Instalar Integración Correcta

**Ver:** `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md`

1. Habilitar control local en cámaras
2. Crear usuarios de cámara
3. Instalar "Tapo: Cameras Control" en HACS
4. Configurar ambas cámaras
5. Verificar binary sensors creados

---

### Paso 2: Agregar Helpers

**En `configuration.yaml`:**

```yaml
input_select:
  camera_alert_type:
    name: Tipo de Última Alerta
    icon: mdi:alert-circle
    options:
      - "Ninguna"
      - "Movimiento"
      - "Persona"
    initial: "Ninguna"

input_datetime:
  camera_alert_last_trigger:
    name: Última Detección
    has_date: true
    has_time: true
    icon: mdi:clock-alert
```

**También necesitas los helpers de V2:**
- `input_text.camera_alert_active`
- `input_text.camera_alert_timestamp`

---

### Paso 3: Agregar Automatizaciones

**Copiar de:** `examples/camera_alert_system_v3.yaml`

**A:** `automations.yaml`

---

### Paso 4: Crear Directorio de Snapshots

```bash
ssh nico@192.168.1.100
mkdir -p /config/www/snapshots
chmod 755 /config/www/snapshots
exit
```

---

### Paso 5: Reiniciar HA

**Configuración** → **Sistema** → **Reiniciar**

---

### Paso 6: Verificar

**En Herramientas para desarrolladores → Estados:**

1. Buscar: `binary_sensor.tapo_c530ws_entrada_person`
2. Debe existir y estar en `off`
3. Hacer movimiento de persona frente a la cámara
4. Debe cambiar a `on`
5. Automatización se dispara
6. Dashboard agranda cámara
7. Notificación llega
8. Después de 60s vuelve a normal

---

## 🧪 Pruebas

### Test 1: Binary Sensor Manual

```yaml
# En Herramientas para desarrolladores → Estados
# Cambiar manualmente el estado:
binary_sensor.tapo_c530ws_entrada_person
```

⚠️ **Nota:** El estado volverá a `off` automáticamente (controlado por cámara)

---

### Test 2: Movimiento Real

1. Ir frente a cámara de entrada
2. Hacer movimientos
3. Verificar:
   - Dashboard agranda cámara ✅
   - Llega notificación ✅
   - Se crea snapshot en `/config/www/snapshots/` ✅
   - Log en logbook ✅
   - Después de 30-60s vuelve a normal ✅

---

### Test 3: Encadenamiento

**Al detectar persona:**

1. Widget agranda ✅
2. Alarma de cámara activa ✅
3. Luces se encienden ✅
4. Notificación con imagen ✅
5. Log detallado ✅

---

## 📊 Helpers y Estados

| Helper | Valores | Descripción |
|--------|---------|-------------|
| `camera_alert_active` | `none`, `entrada`, `exterior` | Qué cámara tiene alerta |
| `camera_alert_type` | `Ninguna`, `Movimiento`, `Persona` | Tipo de detección |
| `camera_alert_timestamp` | Timestamp | Cuándo fue |
| `camera_alert_last_trigger` | DateTime | Última detección |

---

## 🔗 Encadenamiento de Comportamientos

### Ejemplo 1: Persona + Luces + Alarma

```yaml
- service: scene.turn_on  # Encender luces
- service: switch.turn_on  # Activar alarma
- service: notify...        # Notificar
```

### Ejemplo 2: Movimiento Repetido → Patrón Sospechoso

**Próxima versión:** Detectar múltiples movimientos en X tiempo

### Ejemplo 3: Integración con Sistema de Alarma

**Próxima versión:** Si alarma está activada y hay detección → acción especial

---

## 🔍 Troubleshooting

### No se dispara la automatización

**Verificar:**
1. Binary sensor existe
2. Binary sensor cambia de estado (`off` → `on`)
3. Condiciones se cumplen (usuario no en casa)
4. Automatización está activada
5. Ver logs de automatización

---

### Snapshot no se guarda

**Verificar:**
1. Directorio `/config/www/snapshots/` existe
2. Permisos correctos (755)
3. Cámara HD/SD accesible
4. Ver logs de HA

---

### Alarma no suena

**Verificar:**
1. Switch `*_alarm` existe
2. Alarma configurada en app Tapo
3. Volumen de alarma no en 0
4. Switch responde (probar manualmente)

---

### Dashboard no agranda

**Verificar:**
1. Helper `camera_alert_active` cambia a `entrada`/`exterior`
2. Dashboard tiene conditional cards correctas
3. Recargar dashboard

---

## 📈 Mejoras Futuras

### Versión 3.1:
- [ ] Detección de patrones sospechosos
- [ ] Integración con alarma de HA
- [ ] Grabación automática de clips
- [ ] Histórico de detecciones

### Versión 3.2:
- [ ] AI/ML para filtrar falsas alarmas
- [ ] Reconocimiento facial
- [ ] Zonas de interés personalizadas
- [ ] Dashboard con histórico visual

---

## 📚 Referencias

- **Integración:** `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md`
- **Automatizaciones:** `examples/camera_alert_system_v3.yaml`
- **Dashboard:** `dashboards/maui_dashboard.yaml`
- **GitHub Tapo:** https://github.com/JurajNyiri/HomeAssistant-Tapo-Control

---

**¿Dudas?** Este sistema está diseñado para ser extensible y robusto. Cualquier comportamiento adicional se puede encadenar fácilmente en las actions de las automatizaciones.

