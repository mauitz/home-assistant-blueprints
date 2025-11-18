# 🚀 FRIGATE - OPCIONES DE OPTIMIZACIÓN DE RECURSOS

**Fecha:** 14 de Noviembre, 2025
**Problema:** Frigate consumiendo CPU al 100% todo el tiempo
**Objetivo:** Reducir consumo manteniendo efectividad

---

## 📊 COMPARACIÓN DE ESTRATEGIAS

| Estrategia | Ahorro CPU | Complejidad | Efectividad | Recomendada |
|-----------|------------|-------------|-------------|-------------|
| **1. Motion-Based Detection** | 70-80% | Media | ⭐⭐⭐⭐⭐ | ✅ **SÍ** |
| **2. Scheduled Detection** | 50-60% | Baja | ⭐⭐⭐⭐ | ⚠️ Depende |
| **3. Zone Optimization** | 20-30% | Baja | ⭐⭐⭐ | ⚠️ Complemento |
| **4. Hardware Acceleration** | 60-80% | Alta | ⭐⭐⭐⭐⭐ | 💰 $60 |
| **5. Lower FPS/Resolution** | 30-40% | Muy Baja | ⭐⭐⭐ | ⚠️ Último recurso |

---

## ✅ ESTRATEGIA 1: MOTION-BASED DETECTION (RECOMENDADA)

### Cómo Funciona:
```
Cámara Tapo detecta movimiento (hardware)
  ↓
Home Assistant recibe notificación
  ↓
Activa detección de Frigate (IA)
  ↓
Procesa durante 2-5 minutos
  ↓
Si no hay más movimiento → Desactiva detección
```

### Ventajas:
- ✅ **70-80% menos CPU** cuando no hay movimiento
- ✅ Detección instantánea (cámara detecta primero)
- ✅ No pierdes grabaciones (sigue grabando sin IA)
- ✅ Configurable por horario
- ✅ IA solo cuando realmente importa

### Desventajas:
- ⚠️ Requiere integración Tapo correcta
- ⚠️ Dependes del detector de movimiento de la cámara
- ⚠️ Configuración media (automatizaciones)

### Requisitos:
1. Integración **"Tapo: Cameras Control"** (JurajNyiri)
2. Sensores de movimiento funcionando
3. Frigate con MQTT habilitado

### Instalación:
```bash
# OPCIÓN A: Instalación automática
./install_frigate_optimization.sh

# OPCIÓN B: Manual
# Ver: docs/FRIGATE_OPTIMIZACION_MOTION_BASED.md
```

---

## 🕐 ESTRATEGIA 2: SCHEDULED DETECTION (Horarios)

### Cómo Funciona:
```
Desactiva detección en horarios de baja actividad
Mantiene grabación 24/7
Solo procesa IA en horarios definidos
```

### Ventajas:
- ✅ **50-60% menos CPU** (si inactividad es predecible)
- ✅ Muy simple de implementar
- ✅ No requiere sensores adicionales
- ✅ Configurable fácilmente

### Desventajas:
- ⚠️ Puede perderte eventos fuera de horario
- ⚠️ Solo útil si actividad es predecible

### Ejemplo de Configuración:

```yaml
# ════════════════════════════════════════════════════════════════════════════
# FRIGATE - Detección Programada
# ════════════════════════════════════════════════════════════════════════════

# Desactivar detección durante el día (horario laboral)
- id: frigate_disable_daytime
  alias: "Frigate - Desactivar Durante Día"
  triggers:
    - platform: time
      at: "08:00:00"
  actions:
    - service: switch.turn_off
      target:
        entity_id:
          - switch.frigate_entrada_detect
          - switch.frigate_exterior_detect

# Activar detección por la noche
- id: frigate_enable_night
  alias: "Frigate - Activar Por Noche"
  triggers:
    - platform: time
      at: "19:00:00"
  actions:
    - service: switch.turn_on
      target:
        entity_id:
          - switch.frigate_entrada_detect
          - switch.frigate_exterior_detect
```

**Cuándo usar:**
- Si NO estás en casa durante el día
- Si la actividad importante es solo nocturna
- Como complemento de Motion-Based

---

## 🎯 ESTRATEGIA 3: ZONE OPTIMIZATION (Zonas)

### Cómo Funciona:
```
Define zonas específicas importantes
Solo procesa objetos en esas zonas
Ignora movimiento fuera de zonas
```

### Ventajas:
- ✅ **20-30% menos CPU**
- ✅ Reduce falsos positivos
- ✅ Muy simple de configurar
- ✅ Compatible con otras estrategias

### Desventajas:
- ⚠️ Ahorro limitado
- ⚠️ Requiere ajustar zonas manualmente

### Configuración en Frigate:

```yaml
cameras:
  entrada:
    zones:
      puerta_principal:
        coordinates: 200,100,600,100,600,400,200,400
        objects:
          - person

    objects:
      filters:
        person:
          # Solo alertar si está en zona definida
          required_zones: ["puerta_principal"]
```

**Cuándo usar:**
- Si solo te importa un área específica
- Para reducir falsos positivos (ej: calle con mucho tráfico)
- Como **complemento** de Motion-Based

---

## 🔧 ESTRATEGIA 4: HARDWARE ACCELERATION (Google Coral)

### Cómo Funciona:
```
Procesamiento de IA en hardware dedicado (TPU)
Libera CPU casi completamente
Puede manejar 8+ cámaras sin problema
```

### Ventajas:
- ✅ **60-80% menos CPU** (pasa de CPU a TPU)
- ✅ Procesamiento 24/7 sin problema
- ✅ Escalable a más cámaras
- ✅ Detección más rápida

### Desventajas:
- 💰 Costo: ~$60 USD (Google Coral USB)
- ⚠️ Requiere puerto USB disponible
- ⚠️ Configuración técnica

### Instalación:

**Comprar:**
- Google Coral USB Accelerator (~$60)
- Amazon / MercadoLibre

**Configurar en Frigate:**

```yaml
detectors:
  coral1:
    type: edgetpu
    device: usb

cameras:
  entrada:
    detect:
      enabled: true
      fps: 5  # Puedes subir a 5 sin problemas
```

**Cuándo usar:**
- Si planeas agregar más cámaras
- Si el ahorro de 70-80% no es suficiente
- Si prefieres procesamiento continuo sin preocuparte

**Inversión vale la pena si:**
- Tienes 3+ cámaras
- Planeas usar Frigate a largo plazo
- CPU actual está muy limitado

---

## 📉 ESTRATEGIA 5: LOWER FPS/RESOLUTION (Último Recurso)

### Cómo Funciona:
```
Reducir FPS de detección (de 5 → 2-3)
Usar stream de menor resolución
Procesar menos frames = menos CPU
```

### Ventajas:
- ✅ **30-40% menos CPU**
- ✅ Muy simple de implementar
- ✅ No requiere cambios en HA

### Desventajas:
- ⚠️ Puede perderte objetos rápidos
- ⚠️ Menor calidad de detección
- ⚠️ No recomendado si tienes alternativas

### Configuración:

```yaml
cameras:
  entrada:
    detect:
      fps: 2  # Reducir de 3 a 2
      width: 480  # Reducir de 640
      height: 270  # Reducir de 360
```

**Cuándo usar:**
- Solo si **NADA más funciona**
- Si hardware es muy limitado
- Siempre como **último recurso**

---

## 🎯 RECOMENDACIÓN PARA TU CASO

### Tu Situación Actual:
- 2 cámaras Tapo (C530WS + C310)
- Frigate en CPU continuo al 100%
- Actividad no es constante

### Solución Recomendada:

**1. INMEDIATO: Motion-Based Detection**
```bash
./install_frigate_optimization.sh
```
- Ahorro: 70-80% CPU
- Efectividad: 100%
- Tiempo: 15 minutos

**2. COMPLEMENTO: Scheduled Detection**
- Desactivar durante horario laboral si no estás
- Ahorro adicional: 10-20%

**3. OPCIONAL: Zone Optimization**
- Definir zonas importantes
- Reduce falsos positivos
- Ahorro adicional: 5-10%

**4. FUTURO: Google Coral (si planeas más cámaras)**
- Inversión: $60
- Escalable a 8+ cámaras
- CPU casi liberado completamente

### Implementación Sugerida (Paso a Paso):

#### Fase 1: Motion-Based (HOY)
```bash
# Instalar optimización motion-based
./install_frigate_optimization.sh

# Monitorear por 24-48 horas
ssh nico@192.168.1.100
docker logs -f homeassistant | grep "Frigate Optimización"
```

#### Fase 2: Ajustar Tiempos (Día 2-3)
```yaml
# Si ves que se activa muy seguido:
delay:
  minutes: 3  # Aumentar de 2 a 3

# Si ves que tarda en desactivarse:
for:
  minutes: 2  # Reducir de 3 a 2
```

#### Fase 3: Agregar Horarios (Día 4-7)
```yaml
# Agregar automatización de horarios
# Solo si tu actividad es muy predecible
```

#### Fase 4: Evaluar Coral (Semana 2)
```
Si después de todo el ahorro aún es alto:
  → Considerar Google Coral
Si CPU está bajo control:
  → No hace falta
```

---

## 📊 TABLA DE DECISIÓN RÁPIDA

| Situación | Solución Recomendada |
|-----------|---------------------|
| **"CPU al 100% todo el tiempo"** | Motion-Based Detection |
| **"Solo me importa la noche"** | Scheduled Detection |
| **"Muchos falsos positivos"** | Zone Optimization |
| **"Tengo 3+ cámaras"** | Google Coral |
| **"No quiero complicarme"** | Scheduled Detection + Lower FPS |
| **"Máxima eficiencia"** | Motion-Based + Scheduled + Coral |

---

## 🚀 QUICK START (15 Minutos)

### Paso 1: Verificar Integración Tapo
```bash
ssh nico@192.168.1.100
docker exec homeassistant ha-cli state list | grep -i "tapo.*motion"
```

**Si NO hay sensores de movimiento:**
- Instalar "Tapo: Cameras Control" de JurajNyiri
- Ver: `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md`

### Paso 2: Instalar Optimización
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
./install_frigate_optimization.sh
```

### Paso 3: Verificar en Home Assistant
1. Ir a **Configuración → Automatizaciones**
2. Buscar: "Frigate - Entrada - Activar Detección"
3. Verificar que está **Activa**

### Paso 4: Monitorear
```bash
# Ver activaciones en tiempo real
ssh nico@192.168.1.100
docker logs -f homeassistant | grep "Frigate Optimización"
```

### Paso 5: Ver Estadísticas
En Home Assistant, agregar card:
```yaml
type: entities
entities:
  - sensor.frigate_cpu_saved_percent
  - switch.frigate_entrada_detect
  - switch.frigate_exterior_detect
  - counter.frigate_entrada_activations_today
```

---

## 📚 DOCUMENTACIÓN RELACIONADA

- **Implementación completa:** `docs/FRIGATE_OPTIMIZACION_MOTION_BASED.md`
- **Integración Tapo:** `docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md`
- **Config actual Frigate:** `frigate_config_optimizado.yml`
- **Instalación Frigate:** `docs/FRIGATE_INSTALACION_COMPLETA.md`

---

## ❓ FAQ

### ¿Pierdo grabaciones con Motion-Based?
**No.** Frigate sigue grabando 24/7, solo desactiva el procesamiento de IA cuando no hay movimiento.

### ¿Qué pasa si hay movimiento pero Frigate está desactivado?
El sistema activa Frigate **en menos de 1 segundo** cuando la cámara detecta movimiento. No pierdes nada.

### ¿Puedo combinar varias estrategias?
**Sí.** De hecho es recomendado:
- Motion-Based (base)
- Scheduled (noches/días)
- Zones (áreas específicas)

### ¿Cuánto tarda la instalación?
- **Automática:** 5-10 minutos
- **Manual:** 30-45 minutos

### ¿Puedo deshacer los cambios?
**Sí.** El instalador crea backups automáticos. Ver sección de troubleshooting en documentación.

### ¿Necesito Google Coral?
**No necesariamente.** Con Motion-Based Detection deberías ver reducción de 70-80% de CPU. Coral es solo si:
- Tienes 3+ cámaras
- Planeas agregar más
- Quieres procesamiento 24/7 sin preocuparte

---

## ✅ RESUMEN EJECUTIVO

**Tu problema:**
- Frigate al 100% CPU
- Cámaras sin actividad constante
- Desperdicio de recursos

**Solución recomendada:**
```bash
./install_frigate_optimization.sh
```

**Resultado esperado:**
- ✅ CPU reducido en 70-80%
- ✅ Detecciones igual de efectivas
- ✅ Grabaciones continuas preservadas
- ✅ Sistema más eficiente

**Tiempo de implementación:** 15 minutos
**Dificultad:** Media (script automático)
**Riesgo:** Bajo (backups automáticos)

**¿Empezamos? 🚀**


