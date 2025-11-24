# 🚰 Sistema de Riego Inteligente - Instalación Paso a Paso

Guía detallada para instalar y configurar el sistema de riego automático.

---

## 📋 **Prerrequisitos**

### ✅ Hardware Validado
- [x] ESP32 conectado y funcionando
- [x] Sensores operacionales (humedad, nivel tanque, luz, LD2410C)
- [x] Relés activando correctamente
- [x] Bombas probadas y funcionando
- [x] LEDs de estado operativos

### ✅ Software
- [x] Home Assistant instalado y funcionando
- [x] ESPHome configurado en el ESP32
- [x] Dispositivo `riego_z1` visible en Home Assistant

---

## 🚀 **Instalación**

### **Opción A: Script Automático (Recomendado)**

Si tienes acceso SSH a Home Assistant:

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
./utils/install_riego_blueprint.sh
```

### **Opción B: Manual**

#### 1. Copiar Blueprint

**Desde tu Mac:**
```bash
# Si Home Assistant está en la misma red
scp blueprints/sistema_riego_inteligente.yaml \
    usuario@homeassistant.local:/config/blueprints/automation/mauitz/
```

**O usando File Editor en Home Assistant:**
1. Ve a **File Editor** (o **Samba Share**)
2. Navega a `config/blueprints/automation/`
3. Crea carpeta `mauitz` si no existe
4. Copia el archivo `sistema_riego_inteligente.yaml`

#### 2. Recargar Configuración

**En Home Assistant:**
1. Ve a **Herramientas para Desarrolladores**
2. Click en **YAML**
3. Click en **RECARGAR → Automatizaciones**

---

## 🎛️ **Configurar Helpers**

Los helpers permiten control manual y registro de riegos.

### **Método 1: Desde la UI (Más Fácil)**

Ve a **Configuración → Dispositivos y Servicios → Helpers**

#### Helper 1: Modo Manual
- Click **+ CREAR HELPER**
- Tipo: **Toggle** (Input Boolean)
- Nombre: `Riego Z1 - Modo Manual`
- ID: `riego_z1_manual`
- Icono: `mdi:hand-back-right`

#### Helper 2: Último Riego
- Tipo: **Fecha y hora** (Input DateTime)
- Nombre: `Riego Z1 - Último Riego`
- ID: `riego_z1_ultimo`
- ✅ Tiene fecha
- ✅ Tiene hora

#### Helper 3: Contador de Ciclos
- Tipo: **Número** (Input Number)
- Nombre: `Riego Z1 - Contador de Ciclos`
- ID: `riego_z1_contador`
- Mínimo: `0`
- Máximo: `1000`
- Paso: `1`
- Modo: Caja

### **Método 2: Desde YAML**

1. Abre `configuration.yaml`
2. Copia el contenido de `examples/helpers/riego_helpers.yaml`
3. Guarda y reinicia Home Assistant

---

## ⚙️ **Crear Automatización**

### **Paso 1: Desde la UI**

1. Ve a **Configuración → Automatizaciones y Escenas**
2. Click en **+ CREAR AUTOMATIZACIÓN**
3. Selecciona **Crear automatización desde blueprint**
4. Busca **"Sistema de Riego Inteligente"**

### **Paso 2: Configurar Parámetros**

Rellena los campos con estos valores para Zona 1:

#### **Identificación**
- **Nombre de la Zona**: `Zona 1 - Jardín Principal`

#### **Dispositivos**
- **Bomba de Riego**: `switch.bomba_z1a` (o `switch.bomba_z1b`)
- **Sensor de Humedad del Suelo**: `sensor.humedad_suelo_z1`
- **Sensor de Nivel del Tanque**: `sensor.nivel_tanque`

#### **Umbrales de Humedad**
- **Humedad Mínima para Riego**: `30%`
  - *Si baja de 30%, se activa el riego*
- **Humedad Objetivo**: `60%`
  - *Se detiene al llegar a 60%*

#### **Nivel del Tanque**
- **Nivel Mínimo del Tanque**: `20%`
  - *No riega si el tanque tiene menos de 20%*

#### **Duración y Frecuencia**
- **Duración Máxima del Riego**: `10 minutos`
  - *Tiempo máximo que puede regar en un ciclo*
- **Intervalo Mínimo entre Riegos**: `4 horas`
  - *Tiempo mínimo entre dos riegos*

#### **Horarios**
- **Permitir Riego Nocturno**: ❌ (desactivado)
- **Hora de Inicio Permitida**: `06:00`
- **Hora Final Permitida**: `22:00`

#### **Notificaciones (Opcional)**
- **Servicio de Notificación**: (déjalo vacío por ahora)
  - *Ejemplo: `notify.mobile_app_iphone_de_maui`*
- **Notificar Inicio de Riego**: ✅
- **Notificar Tanque Bajo**: ✅

#### **Modo Manual (Opcional)**
- **Helper Modo Manual**: `input_boolean.riego_z1_manual`
  - *Si lo creaste en el paso anterior*

### **Paso 3: Guardar**

1. Click en **GUARDAR**
2. Asigna un nombre: `Riego Automático - Zona 1`
3. Click en **GUARDAR** nuevamente

---

## 🧪 **Probar el Sistema**

### **Prueba 1: Modo Manual**

1. Activa el helper `input_boolean.riego_z1_manual`
2. La automatización debería **detenerse**
3. Activa manualmente `switch.bomba_z1a`
4. Verifica que riega correctamente
5. Apaga la bomba
6. Desactiva el modo manual

### **Prueba 2: Simulación de Suelo Seco**

**⚠️ IMPORTANTE: Esto activará el riego real**

1. Asegúrate que:
   - Modo manual está OFF
   - Tanque tiene >20%
   - Es un horario permitido (06:00 - 22:00)

2. Saca el sensor de humedad del suelo (o desconéctalo)
   - La humedad caerá a 0%

3. Espera 5 minutos

4. El sistema debería:
   - ✅ Activar la bomba automáticamente
   - ✅ Encender el LED de bomba
   - ✅ Regar durante el tiempo configurado

5. Vuelve a conectar el sensor de humedad

### **Prueba 3: Protección de Tanque Bajo**

1. Temporalmente cambia el umbral de tanque a `95%` en la automatización
2. Esto simulará tanque bajo
3. Intenta regar:
   - ❌ El sistema **no debería** activar el riego
   - ✅ Debería enviar notificación de tanque bajo (si configuraste notificaciones)
4. Vuelve el umbral a `20%`

---

## 📊 **Dashboard Recomendado**

Agrega este código a tu dashboard para monitorear el riego:

```yaml
type: vertical-stack
title: 🚰 Sistema de Riego Z1
cards:
  # Estado General
  - type: entities
    title: Estado del Sistema
    entities:
      - entity: sensor.humedad_suelo_z1
        name: Humedad del Suelo
        icon: mdi:water-percent
      - entity: sensor.nivel_tanque
        name: Nivel del Tanque
        icon: mdi:gauge
      - type: divider
      - entity: switch.bomba_z1a
        name: Bomba Z1A
        tap_action:
          action: toggle
      - entity: switch.bomba_z1b
        name: Bomba Z1B
        tap_action:
          action: toggle
      - type: divider
      - entity: input_boolean.riego_z1_manual
        name: Modo Manual

  # Gráfico de Humedad
  - type: history-graph
    title: 📈 Historial de Humedad (24h)
    hours_to_show: 24
    refresh_interval: 60
    entities:
      - entity: sensor.humedad_suelo_z1
        name: Humedad Suelo

  # Nivel del Tanque
  - type: gauge
    entity: sensor.nivel_tanque
    name: Nivel del Tanque
    min: 0
    max: 100
    needle: true
    severity:
      green: 50
      yellow: 30
      red: 0

  # Controles Rápidos
  - type: horizontal-stack
    cards:
      - type: button
        name: Regar Z1A
        icon: mdi:water-pump
        tap_action:
          action: call-service
          service: switch.turn_on
          service_data:
            entity_id: switch.bomba_z1a
        hold_action:
          action: call-service
          service: switch.turn_off
          service_data:
            entity_id: switch.bomba_z1a

      - type: button
        name: Regar Z1B
        icon: mdi:water-pump
        tap_action:
          action: call-service
          service: switch.turn_on
          service_data:
            entity_id: switch.bomba_z1b
        hold_action:
          action: call-service
          service: switch.turn_off
          service_data:
            entity_id: switch.bomba_z1b

  # Información Adicional
  - type: entities
    title: Información
    entities:
      - entity: sensor.temperatura_ambiente
        name: Temperatura
      - entity: sensor.luz_ambiente
        name: Luz Ambiente
      - entity: binary_sensor.presencia_detectada
        name: Presencia (LD2410C)
```

---

## 📱 **Configurar Notificaciones (Opcional)**

### **Paso 1: Identificar tu Servicio de Notificación**

Ve a **Herramientas para Desarrolladores → Servicios**

Busca servicios que empiecen con `notify.`:
- `notify.mobile_app_iphone_de_maui`
- `notify.mobile_app_android`
- `notify.persistent_notification` (notificaciones en HA)

### **Paso 2: Editar la Automatización**

1. Ve a la automatización de riego
2. Click en **⋮ → Editar**
3. En **Servicio de Notificación**, ingresa tu servicio
4. Guarda

### **Paso 3: Probar**

Desde **Herramientas para Desarrolladores → Servicios**:

```yaml
service: notify.mobile_app_iphone_de_maui
data:
  title: "🚰 Prueba de Riego"
  message: "Notificación de prueba"
```

---

## 🔧 **Ajustar Parámetros**

Después de algunos días de uso, puedes ajustar:

### **Si riega muy frecuente:**
- ↓ Aumenta **Intervalo Mínimo** (ej. 6 horas)
- ↓ Baja **Humedad Mínima** (ej. 25%)

### **Si riega muy poco:**
- ↑ Aumenta **Humedad Mínima** (ej. 35%)
- ↓ Reduce **Intervalo Mínimo** (ej. 2 horas)

### **Si riega demasiado tiempo:**
- ↓ Reduce **Duración Máxima** (ej. 5 min)
- ↓ Reduce **Humedad Objetivo** (ej. 50%)

### **Si no alcanza la humedad objetivo:**
- ↑ Aumenta **Duración Máxima** (ej. 15 min)
- ↑ Aumenta **Humedad Objetivo** (ej. 70%)

---

## ✅ **Checklist de Instalación**

- [ ] Blueprint copiado a `/config/blueprints/automation/mauitz/`
- [ ] Automatizaciones recargadas en HA
- [ ] Helpers creados:
  - [ ] `input_boolean.riego_z1_manual`
  - [ ] `input_datetime.riego_z1_ultimo`
  - [ ] `input_number.riego_z1_contador`
- [ ] Automatización creada y configurada
- [ ] Prueba manual exitosa
- [ ] Prueba automática exitosa
- [ ] Dashboard agregado
- [ ] Notificaciones configuradas (opcional)

---

## 🆘 **Troubleshooting**

### **El blueprint no aparece en la lista**
1. Verifica que el archivo esté en la carpeta correcta
2. Recarga las automatizaciones: Herramientas → YAML → Automatizaciones
3. Reinicia Home Assistant si es necesario

### **No puedo seleccionar las entidades**
1. Verifica que el ESP32 esté conectado: `riego_z1` debe aparecer en Dispositivos
2. Verifica que las entidades existan:
   - `sensor.humedad_suelo_z1`
   - `sensor.nivel_tanque`
   - `switch.bomba_z1a`

### **El riego no se activa automáticamente**
Ver [Troubleshooting en RIEGO_INTELIGENTE.md](RIEGO_INTELIGENTE.md#troubleshooting)

---

## 📚 **Documentación Adicional**

- [Documentación Completa](RIEGO_INTELIGENTE.md)
- [Ejemplo de Configuración](../../examples/automatizaciones/riego_z1_auto.yaml)
- [Configuración ESP32](../../esphome/riego_z1.yaml)

---

**¡Listo! Tu sistema de riego inteligente está configurado y funcionando.** 🎉

