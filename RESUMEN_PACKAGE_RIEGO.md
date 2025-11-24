# ✅ Sistema de Riego - Package Unificado v3.2

## 🎯 ¿Qué se hizo?

Has solicitado **unificar TODO el sistema de riego en 1 solo archivo reutilizable**. 

En Home Assistant, esto se llama **PACKAGE**, y es la forma profesional de encapsular sistemas completos.

---

## 📦 Package Completo Creado

**Archivo:** [`packages/sistema_riego_z1.yaml`](packages/sistema_riego_z1.yaml)

### Contenido del Package (TODO en 1 archivo):

✅ **Helpers** (se crean automáticamente):
- `input_boolean.riego_z1_manual` - Modo manual ON/OFF
- `input_datetime.riego_z1_ultimo` - Fecha/hora último riego
- `input_number.riego_z1_contador` - Contador de ciclos
- `input_number.riego_z1_duracion_custom` - Duración personalizada

✅ **Sensors Templates**:
- `sensor.riego_z1_tiempo_desde_ultimo_riego` - "Hace 2 horas" / "Hace 3 días"
- `sensor.riego_z1_estado_del_sistema` - Estado actual (Regando / Normal / Tanque Bajo)
- `binary_sensor.riego_z1_necesita_riego` - ¿Necesita riego? (Sí/No)

✅ **Scripts** (6 scripts funcionales):
- `script.riego_manual_5min` - Riego 5 minutos
- `script.riego_manual_10min` - Riego 10 minutos
- `script.detener_todas_bombas` - STOP emergencia
- `script.test_bombas_z1` - Test de bombas
- `script.riego_emergencia_z1` - Riego de emergencia
- `script.registrar_riego_z1` - Registrar riego manual

✅ **Automatización** (inline):
- Riego automático completo basado en humedad
- Protección de tanque bajo
- Horarios permitidos (6:00 - 22:00)
- Notificaciones
- Duración máxima 10 min
- Objetivo de humedad 60%

---

## 🚀 Cómo Instalarlo

### Paso 1: Habilitar Packages en HA

Edita `/config/configuration.yaml`:

```yaml
homeassistant:
  packages: !include_dir_named packages
```

### Paso 2: Copiar el Package

Desde **File Editor** o **SSH**:

```bash
# Copiar package a HA
cp /Users/maui/_maui/domotica/home-assistant-blueprints/packages/sistema_riego_z1.yaml \
   /config/packages/sistema_riego_z1.yaml
```

O desde la **UI de HA → File Editor**:
1. Crear `/config/packages/sistema_riego_z1.yaml`
2. Copiar contenido del archivo
3. Guardar

### Paso 3: Reiniciar Home Assistant

**Configuración → Sistema → Reiniciar**

⏱️ Espera 1-2 minutos

### Paso 4: Verificar

Ve a **Configuración → Dispositivos y Servicios → Helpers**

Deberías ver:
- ✅ Riego Z1 - Modo Manual
- ✅ Riego Z1 - Último Riego
- ✅ Riego Z1 - Contador de Ciclos
- ✅ Riego Z1 - Duración Custom

Ve a **Configuración → Automatizaciones y Escenas → Scripts**

Deberías ver:
- ✅ Riego Manual 5 minutos - Z1
- ✅ Riego Manual 10 minutos - Z1
- ✅ Detener Todas las Bombas
- ✅ Test de Bombas - Z1
- ✅ Riego de Emergencia - Z1
- ✅ Registrar Riego Manual - Z1

---

## 📖 Documentación Completa

He creado 2 documentos completos:

### 1. [INSTALACION_PACKAGE_RIEGO.md](docs/automatizaciones/INSTALACION_PACKAGE_RIEGO.md)

Guía completa de instalación:
- ✅ Qué es un package y por qué es mejor que blueprints
- ✅ Instalación paso a paso
- ✅ Verificación post-instalación
- ✅ Configuración del widget en dashboard
- ✅ Personalización de umbrales
- ✅ Troubleshooting completo

### 2. [TROUBLESHOOTING_DHT11.md](docs/automatizaciones/TROUBLESHOOTING_DHT11.md)

Diagnóstico completo del DHT11:
- ✅ Verificación de cableado (3 pines vs 4 pines)
- ✅ Resistencia pull-up (interna vs externa)
- ✅ 5 pruebas diagnósticas paso a paso
- ✅ Firmware de prueba aislado
- ✅ Alternativas (DHT22, BME280)
- ✅ Checklist completo

---

## 🔧 Mejoras al DHT11

He mejorado la configuración del DHT11 en `esphome/riego_z1.yaml`:

### Cambios:

```yaml
sensor:
  - platform: dht
    pin: 
      number: GPIO27
      mode:
        input: true
        pullup: true  # ← Pull-up interno habilitado
    model: DHT11
    temperature:
      name: "Temperatura Ambiente"
      filters:
        - sliding_window_moving_average:  # ← Filtro de estabilidad
            window_size: 3
    humidity:
      name: "Humedad Ambiente"
      filters:
        - sliding_window_moving_average:  # ← Filtro de estabilidad
            window_size: 3
    update_interval: 30s  # ← Aumentado a 30s (más estable)
```

### ¿Por qué estos cambios?

1. **Pull-up interno**: El DHT11 necesita una resistencia pull-up de 10kΩ. 
   - Si tu módulo ya la tiene (módulos con PCB), no afecta.
   - Si no la tiene (DHT11 "crudo"), ahora funciona sin resistencia externa.

2. **Filtro de promedio móvil**: Reduce lecturas erróneas.
   - Toma 3 mediciones y hace un promedio.
   - Elimina picos y valores anómalos.

3. **Update interval 30s**: El DHT11 es lento (tarda 2s por lectura).
   - Intervalos cortos (10s) pueden causar errores.
   - 30s es más estable y confiable.

### Flashear Firmware Mejorado

**Cuando el ESP32 esté disponible:**

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome

# Flashear firmware mejorado
python3 -m esphome run riego_z1.yaml --device 192.168.1.15

# Ver logs para verificar DHT11
python3 -m esphome logs riego_z1.yaml --device 192.168.1.15 | grep -i "dht"
```

**Logs esperados (si funciona):**

```
[D][dht:048]: Got Temperature=24.0°C Humidity=65.0%
```

**Si sigue sin funcionar**, consulta [`TROUBLESHOOTING_DHT11.md`](docs/automatizaciones/TROUBLESHOOTING_DHT11.md) para diagnóstico completo.

---

## 📊 Comparación: Package vs Blueprint

| Característica | Blueprint | Package |
|----------------|-----------|---------|
| Helpers | ❌ Crear manualmente | ✅ Automáticos |
| Scripts | ❌ Archivo separado | ✅ Incluidos |
| Sensors | ❌ No soportados | ✅ Incluidos |
| Automatización | ✅ Sí | ✅ Sí |
| Instalación | 4 pasos | 2 pasos |
| Portable | ⚠️ Parcial | ✅ Total |
| Reutilizable | ⚠️ Parcial | ✅ Total |

**Conclusión**: Package es la mejor opción para sistemas completos.

---

## 🎨 Widget en Dashboard

Para agregar el widget al dashboard, edita `maui_dashboard.yaml` y agrega:

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
        
        - type: entity
          entity: binary_sensor.riego_z1_necesita_riego
          name: Necesita Riego
    
    # Sensores
    - type: entities
      title: "📊 Sensores"
      entities:
        - sensor.riego_z1_humedad_suelo_z1
        - sensor.riego_z1_nivel_tanque
        - sensor.riego_z1_temperatura_ambiente
        - sensor.riego_z1_humedad_ambiente
    
    # Control
    - type: entities
      title: "💧 Control"
      entities:
        - input_boolean.riego_z1_manual
        - switch.riego_z1_bomba_z1a
        - switch.riego_z1_bomba_z1b
    
    # Botones
    - type: horizontal-stack
      cards:
        - type: button
          name: "5 min"
          tap_action:
            action: call-service
            service: script.riego_manual_5min
        
        - type: button
          name: "10 min"
          tap_action:
            action: call-service
            service: script.riego_manual_10min
        
        - type: button
          name: "STOP"
          tap_action:
            action: call-service
            service: script.detener_todas_bombas
```

---

## ✅ Resumen de Archivos

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| `packages/sistema_riego_z1.yaml` | **Package completo** | ✅ Creado |
| `esphome/riego_z1.yaml` | Firmware ESP32 (DHT11 mejorado) | ✅ Mejorado |
| `esphome/test_dht11_simple.yaml` | Firmware de prueba DHT11 | ✅ Creado |
| `docs/automatizaciones/INSTALACION_PACKAGE_RIEGO.md` | Guía de instalación | ✅ Creado |
| `docs/automatizaciones/TROUBLESHOOTING_DHT11.md` | Diagnóstico DHT11 | ✅ Creado |
| `utils/crear_helpers_riego.sh` | Script creación helpers (opcional) | ✅ Creado |
| `README.md` | Actualizado con packages | ✅ Actualizado |

---

## 🎯 Próximos Pasos

### 1. Instalar el Package en HA ⭐

```bash
# Habilitar packages en configuration.yaml
# Copiar package a /config/packages/
# Reiniciar HA
```

### 2. Flashear Firmware Mejorado

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
python3 -m esphome run riego_z1.yaml --device 192.168.1.15
```

### 3. Diagnosticar DHT11

Si el DHT11 sigue sin funcionar después del firmware mejorado:

```bash
# Usar firmware de prueba
python3 -m esphome run test_dht11_simple.yaml --device 192.168.1.15

# Ver logs
python3 -m esphome logs test_dht11_simple.yaml --device 192.168.1.15
```

Consulta [`TROUBLESHOOTING_DHT11.md`](docs/automatizaciones/TROUBLESHOOTING_DHT11.md)

### 4. Agregar Widget al Dashboard

Edita `maui_dashboard.yaml` con el código del widget.

---

## 🆘 Soporte

- 📖 [Instalación del Package](docs/automatizaciones/INSTALACION_PACKAGE_RIEGO.md)
- 🔧 [Troubleshooting DHT11](docs/automatizaciones/TROUBLESHOOTING_DHT11.md)
- 📚 [Documentación Completa](docs/automatizaciones/RIEGO_INTELIGENTE.md)
- 🐛 [GitHub Issues](https://github.com/mauitz/home-assistant-blueprints/issues)

---

**Versión**: 3.2  
**Fecha**: Noviembre 2024  
**Autor**: @mauitz

---

## 🎉 ¡Listo!

Ahora tienes un **sistema completo de riego encapsulado en 1 solo archivo**, portable, reutilizable, y profesional.

**Ventajas:**
- ✅ Instalación en 2 pasos (vs 6+ pasos antes)
- ✅ Sin creación manual de helpers
- ✅ Scripts incluidos
- ✅ Sensors automáticos
- ✅ Fácil de compartir y reutilizar
- ✅ Mantenimiento simple (1 archivo)

**🚀 Instala el package y disfruta de tu sistema de riego inteligente!**

