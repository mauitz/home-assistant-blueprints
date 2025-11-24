# 📦 Instalación del Package: Sistema de Riego Inteligente

## 🎯 ¿Qué es un Package?

Un **package** en Home Assistant es un archivo YAML que **encapsula toda la configuración** relacionada con un sistema específico. Es **reutilizable**, **portable** y **autocontenido**.

### Ventajas sobre Blueprints:
- ✅ Incluye **helpers**, **scripts**, **sensors**, **automations**
- ✅ **Todo en un solo archivo** (no necesitas crear helpers manualmente)
- ✅ **Fácil de compartir y reutilizar**
- ✅ **Se activa automáticamente** al reiniciar HA

---

## 📋 Requisitos Previos

### 1. Hardware (ESP32 ya flasheado)
- ✅ ESP32 con firmware `riego_z1.yaml` flasheado
- ✅ Sensor de humedad (GPIO34)
- ✅ Sensor de nivel de tanque (GPIO13/14)
- ✅ DHT11 temperatura/humedad (GPIO27)
- ✅ Bombas en relés IN1 (GPIO23) e IN2 (GPIO22)
- ✅ ESP32 conectado a WiFi y visible en Home Assistant

### 2. Integración ESPHome en HA
El ESP32 debe estar integrado y las siguientes entidades deben existir:
```
switch.riego_z1_bomba_z1a
switch.riego_z1_bomba_z1b
sensor.riego_z1_humedad_suelo_z1
sensor.riego_z1_nivel_tanque
sensor.riego_z1_temperatura_ambiente
sensor.riego_z1_humedad_ambiente
```

### 3. Home Assistant con sistema de packages habilitado

---

## 🚀 Instalación Paso a Paso

### **Paso 1: Habilitar Packages en Home Assistant**

Edita tu `configuration.yaml`:

```yaml
homeassistant:
  packages: !include_dir_named packages
```

Si ya tienes `homeassistant:` configurado, solo agrega la línea `packages:`:

```yaml
homeassistant:
  name: Mi Casa
  latitude: -34.xxx
  longitude: -58.xxx
  # ... otras configuraciones ...
  
  # Agregar esta línea
  packages: !include_dir_named packages
```

### **Paso 2: Crear Directorio de Packages**

Conéctate a tu Home Assistant (SSH, File Editor, o SAMBA) y crea el directorio:

```bash
mkdir -p /config/packages
```

### **Paso 3: Copiar el Package**

Copia el archivo `packages/sistema_riego_z1.yaml` a `/config/packages/`:

**Opción A: Desde File Editor (más fácil)**
1. Ve a **Home Assistant → Configuración → Add-ons → File Editor**
2. Crea el archivo `/config/packages/sistema_riego_z1.yaml`
3. Copia todo el contenido del package
4. **Guardar**

**Opción B: Desde SSH**
```bash
# Copiar archivo desde este repositorio
cp packages/sistema_riego_z1.yaml /config/packages/

# O descargarlo directamente
wget -O /config/packages/sistema_riego_z1.yaml \
  https://raw.githubusercontent.com/mauitz/home-assistant-blueprints/main/packages/sistema_riego_z1.yaml
```

### **Paso 4: Verificar el Archivo**

Usa el **Check Configuration** de HA:
1. Ve a **Configuración → Sistema → Herramientas del Sistema**
2. Click en **VERIFICAR CONFIGURACIÓN**
3. Debe decir: **"Configuración válida!"**

Si hay errores, revisa:
- Indentación correcta (usa espacios, no tabs)
- Nombres de entidades coinciden con tu ESP32

### **Paso 5: Reiniciar Home Assistant**

**Configuración → Sistema → Reiniciar**

⏱️ Espera 1-2 minutos

---

## ✅ Verificación Post-Instalación

### 1. Verifica los Helpers Creados

Ve a **Configuración → Dispositivos y Servicios → Helpers**

Deberías ver:
- ✅ `Riego Z1 - Modo Manual` (toggle)
- ✅ `Riego Z1 - Último Riego` (fecha/hora)
- ✅ `Riego Z1 - Contador de Ciclos` (número)
- ✅ `Riego Z1 - Duración Custom` (número)

### 2. Verifica los Scripts Creados

Ve a **Configuración → Automatizaciones y Escenas → Scripts**

Deberías ver:
- ✅ `Riego Manual 5 minutos - Z1`
- ✅ `Riego Manual 10 minutos - Z1`
- ✅ `Detener Todas las Bombas`
- ✅ `Test de Bombas - Z1`
- ✅ `Riego de Emergencia - Z1`
- ✅ `Registrar Riego Manual - Z1`

### 3. Verifica los Sensors Templates

Ve a **Herramientas de Desarrollo → Estados**

Busca:
- ✅ `sensor.riego_z1_tiempo_desde_ultimo_riego`
- ✅ `sensor.riego_z1_estado_del_sistema`
- ✅ `binary_sensor.riego_z1_necesita_riego`

### 4. Verifica la Automatización

Ve a **Configuración → Automatizaciones y Escenas → Automatizaciones**

Deberías ver:
- ✅ `Riego Automático - Zona 1` (habilitada por defecto)

---

## 🎛️ Configuración y Uso

### Activar/Desactivar Modo Manual

**Método 1: Desde el toggle**
- Ve a **Configuración → Helpers**
- Encuentra `Riego Z1 - Modo Manual`
- **ON** = Riego manual (automatización pausada)
- **OFF** = Riego automático (activo)

**Método 2: Desde servicio**
```yaml
service: input_boolean.turn_on
target:
  entity_id: input_boolean.riego_z1_manual
```

### Ejecutar Riego Manual

**Desde Herramientas de Desarrollo → Servicios**:

```yaml
service: script.riego_manual_5min
```

O desde el dashboard (ver sección de widget más abajo).

### Probar las Bombas

```yaml
service: script.test_bombas_z1
```

Esto probará cada bomba durante 10 segundos.

---

## 🎨 Widget de Dashboard

Para agregar el widget al dashboard, copia este código en tu `maui_dashboard.yaml`:

```yaml
- type: vertical-stack
  title: "🌱 Sistema de Riego - Zona 1"
  cards:
    # Estado General
    - type: horizontal-stack
      cards:
        - type: entity
          entity: sensor.riego_z1_estado_del_sistema
          name: Estado
          icon: mdi:state-machine
        
        - type: entity
          entity: binary_sensor.riego_z1_necesita_riego
          name: Necesita Riego
    
    # Sensores
    - type: entities
      title: "📊 Sensores"
      entities:
        - entity: sensor.riego_z1_humedad_suelo_z1
          name: "Humedad Suelo"
          icon: mdi:water-percent
        
        - entity: sensor.riego_z1_nivel_tanque
          name: "Nivel Tanque"
          icon: mdi:water-well
        
        - entity: sensor.riego_z1_temperatura_ambiente
          name: "Temperatura"
          icon: mdi:thermometer
        
        - entity: sensor.riego_z1_humedad_ambiente
          name: "Humedad Ambiente"
          icon: mdi:water-percent
    
    # Control de Bombas
    - type: entities
      title: "💧 Control"
      entities:
        - entity: input_boolean.riego_z1_manual
          name: "Modo Manual"
          icon: mdi:hand-back-right
        
        - entity: switch.riego_z1_bomba_z1a
          name: "Bomba Z1A"
          icon: mdi:water-pump
        
        - entity: switch.riego_z1_bomba_z1b
          name: "Bomba Z1B"
          icon: mdi:water-pump
    
    # Scripts Rápidos
    - type: horizontal-stack
      cards:
        - type: button
          name: "Regar 5 min"
          icon: mdi:timer-10
          tap_action:
            action: call-service
            service: script.riego_manual_5min
        
        - type: button
          name: "Regar 10 min"
          icon: mdi:timer-outline
          tap_action:
            action: call-service
            service: script.riego_manual_10min
        
        - type: button
          name: "STOP"
          icon: mdi:stop-circle
          tap_action:
            action: call-service
            service: script.detener_todas_bombas
    
    # Estadísticas
    - type: entities
      title: "📈 Estadísticas"
      entities:
        - entity: input_number.riego_z1_contador
          name: "Ciclos de Riego"
          icon: mdi:counter
        
        - entity: sensor.riego_z1_tiempo_desde_ultimo_riego
          name: "Último Riego"
          icon: mdi:clock-outline
        
        - entity: input_datetime.riego_z1_ultimo
          name: "Fecha/Hora Último Riego"
```

---

## ⚙️ Personalización

### Cambiar Umbrales de Riego

Edita el package (`/config/packages/sistema_riego_z1.yaml`):

```yaml
# Línea ~370 - Humedad mínima
- condition: numeric_state
  entity_id: sensor.riego_z1_humedad_suelo_z1
  below: 30  # ← Cambia este valor (0-100%)

# Línea ~395 - Humedad objetivo
- wait_template: >
    {{ states('sensor.riego_z1_humedad_suelo_z1') | float(0) >= 60 }}  # ← Cambia 60
```

### Cambiar Horarios Permitidos

```yaml
# Línea ~380
- condition: time
  after: "06:00:00"  # ← Hora inicio
  before: "22:00:00"  # ← Hora fin
```

### Cambiar Nivel Mínimo de Tanque

```yaml
# Línea ~375
- condition: numeric_state
  entity_id: sensor.riego_z1_nivel_tanque
  above: 20  # ← Nivel mínimo en %
```

Después de cada cambio:
1. **Verificar configuración**
2. **Reiniciar Home Assistant**

---

## 🔧 Troubleshooting

### "Entity not found" para sensores

**Problema**: El package no encuentra `sensor.riego_z1_humedad_suelo_z1`

**Solución**:
1. Ve a **Herramientas de Desarrollo → Estados**
2. Busca tus sensores del ESP32 (pueden tener otro nombre)
3. Edita el package y reemplaza con los nombres correctos:

```bash
# Buscar y reemplazar en el package
sensor.riego_z1_humedad_suelo_z1 → sensor.TU_NOMBRE_REAL
switch.riego_z1_bomba_z1a → switch.TU_NOMBRE_REAL
```

### Helpers no se crean

**Problema**: Los helpers no aparecen después de reiniciar

**Solución**:
1. Verifica que `packages: !include_dir_named packages` esté en `configuration.yaml`
2. Verifica que el archivo esté en `/config/packages/sistema_riego_z1.yaml`
3. Revisa el log: **Configuración → Sistema → Logs**

### Automatización no se dispara

**Problema**: La automatización existe pero no se ejecuta

**Solución**:
1. Ve a **Configuración → Automatizaciones → Riego Automático - Zona 1**
2. Verifica que esté **habilitada** (toggle ON)
3. Revisa las trazas: Click en la automatización → **TRAZAS**

---

## 🗑️ Desinstalación

Para eliminar completamente el sistema:

1. **Deshabilitar la automatización**:
   - Ve a **Configuración → Automatizaciones → Riego Automático - Zona 1**
   - Click en **⋮** → **Deshabilitar**

2. **Eliminar el package**:
   ```bash
   rm /config/packages/sistema_riego_z1.yaml
   ```

3. **Reiniciar Home Assistant**

Los helpers, scripts y sensors se eliminarán automáticamente.

---

## 📚 Archivos Relacionados

- **Package**: `/packages/sistema_riego_z1.yaml`
- **ESPHome Config**: `/esphome/riego_z1.yaml`
- **Widget Completo**: `/dashboards/widgets/widget_riego_z1.yaml`
- **Documentación**: `/docs/automatizaciones/RIEGO_INTELIGENTE.md`

---

## 🆘 Soporte

Si tienes problemas:
1. Revisa los logs: **Configuración → Sistema → Logs**
2. Verifica la configuración: **Sistema → Herramientas → Verificar Configuración**
3. Consulta: [GitHub Issues](https://github.com/mauitz/home-assistant-blueprints/issues)

---

**Versión**: 3.2  
**Última actualización**: Noviembre 2024  
**Autor**: @mauitz

