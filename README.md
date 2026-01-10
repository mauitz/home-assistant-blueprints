# 🏠 Home Assistant Blueprints & Configurations

Colección de blueprints, automatizaciones y configuraciones para Home Assistant optimizadas para domótica inteligente.

---

## 📊 Estado del Sistema

**🏠 Home Assistant Pezaustral:** [Estado Completo del Sistema](docs/homeassistant_pezaustral.md)

Visión detallada del HA en producción (192.168.1.100:8123):
- ✅ 465 entidades activas
- ✅ 49 automatizaciones operativas
- ✅ Frigate (2 cámaras con IA)
- ✅ Simulación de Presencia v1.3
- ⚠️ Sistema de Riego (hardware offline)
- ✅ Backups diarios automáticos

**Scripts de análisis:**
```bash
# Resumen visual del estado del HA
bash utils/mostrar_resumen_ha.sh

# Análisis completo vía API
python3 utils/analyze_ha.py

# Estado de simulación de presencia
python3 utils/ha_manager.py status
```

---

## 📦 Proyectos

### 🏠 [Home Mode Manager](packages/home_mode_manager.yaml)

**NEW!** Sistema inteligente de gestión de modos globales de casa.

**Características:**
- ✅ 5 modos predefinidos: normal, away, sleeping, night, guest
- ✅ Transiciones automáticas basadas en presencia, hora y sol
- ✅ Horarios configurables (sin hardcode)
- ✅ Control por voz integrado
- ✅ Sincronización con escenas (opcional)
- ✅ Override manual con auto-reset
- ✅ Widget de dashboard incluido
- ✅ Integración con SmartNode Lighting

**Archivos:**
- [`packages/home_mode_manager.yaml`](packages/home_mode_manager.yaml) - Package principal
- [Documentación completa (EN)](docs/HOME_MODE_MANAGER.md)
- [Guía de instalación Casita (ES)](docs/HOME_MODE_MANAGER_CASITA.md)

**Uso con SmartNodes:**
```yaml
automation:
  use_blueprint:
    path: smartnode_presence_lighting_v2.yaml
    input:
      home_mode_entity: input_select.home_mode
      brightness_normal: 80    # Día
      brightness_noche: 40     # Noche
      brightness_durmiendo: 10 # Durmiendo
```

---

### 🎭 [Simulación de Presencia v2.2](docs/pezaustral_presence_simulation/) ⭐ UX UPGRADE

Blueprint avanzado para simular presencia en casa cuando estás fuera.

**v2.2 - Nuevas Funciones UX:**
- ✨ **NUEVO:** Función PAUSE/RESUME (pausar sin apagar luces)
- ✨ **NUEVO:** Sistema de notificaciones configurable
- ✨ **NUEVO:** Vista dedicada de dashboard con badge animado
- ✨ **NUEVO:** Botones inteligentes START/PAUSE/RESUME/STOP
- ✅ Múltiples luces simultáneas (bug v2.0 corregido en v2.1)
- ✅ Parámetro `max_lights_on` funcional
- ✅ Rotación dinámica de luces

**Características:**
- ⏸️ **PAUSE/RESUME:** Control fino durante ejecución sin perder estado
- 📱 **Notificaciones:** Alertas de inicio/stop/completado configurables
- 🎮 **Control Mejorado:** Botones dedicados con visibilidad inteligente
- 📊 **Vista Dedicada:** Dashboard completo con badge animado y estadísticas
- ✅ Control inteligente de múltiples luces/switches
- ✅ Límite de dispositivos encendidos simultáneamente
- ✅ **Cleanup automático** integrado (apaga todo al detener)
- ✅ Monitoreo en tiempo real con widgets
- ✅ Loops configurables o infinitos (0-99)
- ✅ Escenas de salida personalizables
- ✅ Logs detallados

**Archivos:**
- [`blueprints/pezaustral_presence_simulation.yaml`](blueprints/pezaustral_presence_simulation.yaml) - v2.2
- [Documentación completa](docs/pezaustral_presence_simulation/)
- [Changelog detallado](docs/pezaustral_presence_simulation/CHANGELOG.md)
- [Ejemplos de configuración](examples/)

---

### 📹 Frigate NVR

Configuraciones y automatizaciones para Frigate (detección de objetos con IA).

**Documentación:**
- [Instalación completa](docs/frigate/FRIGATE_INSTALACION_COMPLETA.md)
- [Quick Start](docs/frigate/FRIGATE_QUICK_START.md)
- [Optimización](docs/frigate/FRIGATE_OPCIONES_OPTIMIZACION.md)

**Ejemplos:**
- [Configuración Frigate](examples/frigate/frigate_config.yml)
- [Sistema de alertas](examples/frigate/camera_alert_system_v3.3_frigate.yaml)

---

### 📷 Cámaras IP

Guías de integración para cámaras Tapo y Xiaomi.

**Documentación:**
- [Cámaras Tapo](docs/camaras/CAMARAS_TAPO_INTEGRACION_CORRECTA.md)
- [Xiaomi con firmware custom](docs/camaras/XIAOMI_FIRMWARE_CUSTOM_GUIA.md)

---

### 🎙️ Smart Nodes (ESP32)

Estaciones inteligentes multisensor con audio bidireccional para asistente de voz por habitación.

**Documentación:**
- [Documentación completa](docs/smart_nodes/README.md)
- [Prototipo v1](docs/smart_nodes/prototype/)

---

### 🎨 Dashboard & UI

Dashboards personalizados con diseño moderno y widgets inteligentes.

**Archivos:**
- [Dashboard Maui v3.1](dashboards/maui_dashboard_v3.1.yaml)
- [Tema personalizado](themes/maui_theme.yaml)

**Documentación:**
- [Widgets inteligentes](docs/dashboard/WIDGET_AREA_INTELIGENTE.md)

---

### ⚡ Automatizaciones

Automatizaciones avanzadas reutilizables.

**Ejemplos:**
- [Atardecer inteligente](examples/automatizaciones/atardecer_inteligente.yaml)
- [Desactivar simulación al regresar](examples/automatizaciones/regreso_casa_desactivar_simulacion.yaml)

**Documentación:**
- [Atardecer inteligente](docs/automatizaciones/ATARDECER_INTELIGENTE.md)

---

### 🚰 [Irrigation System (Sistema de Riego Inteligente)](irrigation/) ⭐ NEW v3.2

Sistema completo de riego automático con ESP32 + ESPHome. **Instalación en 1 solo archivo.**

**Características:**
- ✅ Control automático por humedad del suelo
- ✅ Protección de nivel de tanque bajo
- ✅ Horarios de riego configurables
- ✅ Duración máxima y objetivos de humedad
- ✅ Notificaciones de inicio/fin de riego
- ✅ Modo manual y automático
- ✅ Múltiples zonas independientes
- ✨ **Package unificado** - Helpers, scripts, automatización en 1 archivo (v3.2)
- ✨ **Widget especializado para dashboard** (v2.1)
- ✨ **Scripts de control rápido** (v2.1)

**Instalación Rápida:**
```yaml
# 1. Copia el package a: /config/packages/sistema_riego_z1.yaml
# 2. Reinicia HA
# ¡Listo! Helpers, scripts y automatización se crean automáticamente
```

**Archivos principales:**
- 📦 [`packages/sistema_riego_z1.yaml`](packages/sistema_riego_z1.yaml) - **Package completo (RECOMENDADO)** ⭐
- [`blueprints/sistema_riego_inteligente.yaml`](blueprints/sistema_riego_inteligente.yaml) - Blueprint alternativo
- [`esphome/riego_z1.yaml`](esphome/riego_z1.yaml) - Firmware ESP32
- [`irrigation/`](irrigation/) - **Todo el sistema encapsulado**

**Documentación:**
- 📖 [README del Sistema](irrigation/README.md) - Índice completo
- 📖 [Instalación del Package](irrigation/docs/INSTALACION_PACKAGE_RIEGO.md) - Guía completa
- 📚 [Documentación completa](irrigation/docs/RIEGO_INTELIGENTE.md)
- 🏗️ [Hardware y Construcción](irrigation/hardware/) - Guías de construcción
- 🔧 [Troubleshooting DHT11](irrigation/docs/TROUBLESHOOTING_DHT11.md)
- 🎨 [Widgets](irrigation/widgets/) - Widgets para dashboard

---

### 🔧 Otros Blueprints

- **Tuya-Sonoff Sync**: [`blueprints/tuya_sonoff_sync.yaml`](blueprints/tuya_sonoff_sync.yaml)
  Sincronización entre dispositivos Tuya y Sonoff

---

## 📁 Estructura del Proyecto

```
home-assistant-blueprints/
├── packages/                # 📦 Packages autocontenidos (RECOMENDADO)
│   └── sistema_riego_z1.yaml     # Package completo de riego
├── blueprints/              # Blueprints reutilizables
│   ├── pezaustral_presence_simulation.yaml
│   ├── tuya_sonoff_sync.yaml
│   └── sistema_riego_inteligente.yaml
├── esphome/                 # Firmware ESP32/ESPHome
│   ├── riego_z1.yaml        # ESP32 - Sistema de riego Zona 1
│   ├── test_dht11_simple.yaml    # Firmware de prueba DHT11
│   └── secrets.yaml
├── irrigation/              # 🚰 Irrigation System (TODO encapsulado)
│   ├── README.md            # Documentación principal del sistema
│   ├── RESUMEN_PACKAGE_RIEGO.md
│   ├── docs/                # Documentación detallada
│   │   ├── RIEGO_INTELIGENTE.md
│   │   ├── INSTALACION_PACKAGE_RIEGO.md
│   │   ├── INSTALACION_RIEGO_RAPIDA.md
│   │   ├── TROUBLESHOOTING_DHT11.md
│   │   ├── DIAGNOSTICO_SENSORES.md
│   │   └── GUIA_RAPIDA_CONSTRUCCION.md
│   ├── hardware/            # Hardware y construcción
│   │   ├── ARQUITECTURA_PCB_8x12cm.md
│   │   ├── PINOUT_ESP32_30PIN.md
│   │   ├── DIAGRAMA_PINOUT_ESP32.md
│   │   ├── esp32.jpg
│   │   └── ...
│   ├── widgets/             # Widgets para dashboard
│   │   ├── widget_riego_z1.yaml
│   │   └── WIDGET_RIEGO.md
│   └── examples/            # Ejemplos y utilidades
│       ├── riego_z1_auto.yaml
│       ├── riego_scripts.yaml
│       └── ...
├── examples/                # Configuraciones de ejemplo (otros proyectos)
│   ├── presence_simulation_config.yaml
│   ├── presence_simulation_helpers.yaml
│   ├── frigate/
│   └── automatizaciones/
│       └── atardecer_inteligente.yaml
├── dashboards/              # Dashboards personalizados
│   ├── maui_dashboard.yaml  # Dashboard principal (v3.2)
│   ├── maui_dashboard_v3.1.yaml
│   ├── maui_templates/
│   └── maui_views/
├── docs/                    # Documentación organizada por proyecto
│   ├── pezaustral_presence_simulation/
│   ├── frigate/
│   ├── camaras/
│   ├── smart_nodes/
│   ├── dashboard/
│   ├── automatizaciones/    # Otras automatizaciones
│   └── homeassistant_pezaustral.md
├── utils/                   # Utilidades y scripts
│   ├── ha_manager.py
│   ├── verify_installation.sh
│   ├── verify_presence_simulation.sh
│   └── analyze_ha.py
├── themes/                  # Temas personalizados
│   └── maui_theme.yaml
└── HA_config_proxy/         # Configuración de Home Assistant de referencia
```

---

## 🚀 Instalación Rápida

### Simulación de Presencia

1. **Instalar helpers:**
   ```bash
   # Agregar a configuration.yaml el contenido de:
   cat examples/presence_simulation_helpers.yaml
   ```

2. **Importar blueprint:**
   ```
   Home Assistant → Configuración → Automatizaciones → Blueprints
   → Importar Blueprint
   → URL: https://github.com/mauitz/home-assistant-blueprints/blob/main/blueprints/pezaustral_presence_simulation.yaml
   ```

3. **Crear automatización:**
   ```
   Automatizaciones → Nueva → Desde Blueprint
   → Seleccionar "PezAustral Presence Simulation"
   → Configurar según tus necesidades
   ```

4. **Agregar widget al dashboard** (opcional):
   ```bash
   # Ver dashboards/maui_dashboard_v3.1.yaml
   # Sección: Widget de Simulación de Presencia
   ```

Ver [documentación completa](docs/pezaustral_presence_simulation/README.md)

---

## 🛠️ Utilidades

### Verificar Instalación

```bash
# Verificar que todo está configurado correctamente
./utils/verify_installation.sh
```

### Verificar Simulación de Presencia

```bash
# Diagnóstico completo del widget y helpers
./utils/verify_presence_simulation.sh
```

### Manager de Home Assistant

```python
# Gestión programática de Home Assistant
python utils/ha_manager.py
```

---

## 📚 Documentación

Toda la documentación está organizada por proyectos en la carpeta [`docs/`](docs/).

### Proyectos Principales

- [**Irrigation System**](irrigation/) - Sistema completo ESP32 + ESPHome ⭐
- [**Presence Simulation**](docs/pezaustral_presence_simulation/) - Blueprint completo con changelog y troubleshooting
- [**Frigate**](docs/frigate/) - NVR con detección de objetos
- [**Cámaras**](docs/camaras/) - Integración Tapo y Xiaomi
- [**Smart Nodes**](docs/smart_nodes/) - Estaciones inteligentes con audio bidireccional
- [**Dashboard**](docs/dashboard/) - Widgets y UI
- [**Automatizaciones**](docs/automatizaciones/) - Guías de automatizaciones avanzadas

---

## 🤝 Contribuir

Este es un proyecto personal, pero las contribuciones son bienvenidas.

1. Fork del repositorio
2. Crear rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit de cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

---

## 📝 Changelog

### v3.5 (Enero 2026) - 🎨 UX UPGRADE
- 🎉 **Simulación de Presencia v2.2 - NUEVAS FUNCIONES UX**
  - ✨ **Función PAUSE/RESUME:** Pausar simulación manteniendo luces encendidas
  - ✨ **Sistema de Notificaciones:** Alertas configurables (inicio/stop/completado)
  - ✨ **Vista Dedicada Dashboard:** Nueva vista "Simulación" con badge animado
  - ✨ **Controles Mejorados:** Botones START/PAUSE/RESUME/STOP inteligentes
  - 📊 **Badge Animado:** Indicador visual con estados dinámicos (activo/pausa/inactivo)
  - 🎮 **UX Mejorada:** Control fino sin perder estado, confirmación al detener
  - 📱 **Notificaciones Opcionales:** Soporte para cualquier servicio de notificación
  - 📚 **Documentación Completa:** README y CHANGELOG actualizados con v2.2
  - 🔧 **Nuevo Helper:** input_boolean.presence_simulation_paused
  - 📝 **Dashboard v3.5:** Vista dedicada con diseño profesional y responsive

### v3.4 (Enero 2026) - 🐛 BUGFIX CRÍTICO
- 🐛 **BUGFIX CRÍTICO - Simulación de Presencia v2.1**
  - Corregido bug crítico donde solo se encendía 1 luz a la vez
  - Parámetro `max_lights_on` ahora funciona correctamente
  - Implementada rotación dinámica real de luces
  - Nuevo parámetro `delay_between_lights` (10-60 seg)
  - Documentación completa del bugfix agregada
  - Actualización URGENTE recomendada desde v2.0

### v3.3 (Diciembre 2024)
- 📦 **Reorganización completa del Irrigation System**
  - Todo el sistema encapsulado en carpeta `irrigation/`
  - Nomenclatura en inglés (código) con documentación en español
  - Documentación, hardware, widgets y ejemplos organizados
  - README dedicado con índice completo
  - Estructura modular y profesional
  - Fácil localización de todos los componentes

### v3.2 (Noviembre 2024)
- 🧹 **Limpieza y Profesionalización del Proyecto**
  - Eliminados archivos temporales y duplicados
  - Dashboard sin versionado en nombre (`maui_dashboard.yaml`)
  - Widget con nombres de entidades corregidos
  - Documentación consolidada y organizada
  - Estructura profesional para versionado con git

- ✨ **Dashboard v3.2**
  - Nueva vista dedicada para Sistema de Riego
  - Widget integrado con estilo consistente
  - Información del ESP32 y controles

- ✅ **Sistema de Riego Inteligente** completo con ESP32 + ESPHome
  - 📦 **Package unificado** (`packages/sistema_riego_z1.yaml`) - Autocontenido y reutilizable
  - Blueprint de automatización con control por humedad
  - Firmware ESPHome para ESP32 con múltiples sensores
  - Integración con LD2410C (presencia mmWave)
  - Widget especializado con nombres correctos
  - 6 Scripts auxiliares incluidos en el package
  - Helpers automáticos (sin creación manual)
  - Documentación completa consolidada
  - Troubleshooting detallado para DHT11

### v2.1 (2025-11-24)
- ✅ Primer release del Sistema de Riego Inteligente
- ✅ Widget especializado y scripts auxiliares

### v2.1 (2026-01-10)
- 🐛 **BUGFIX CRÍTICO:** Corregido comportamiento de luces simultáneas
- ✅ Parámetro `max_lights_on` ahora funciona correctamente
- ✅ Implementada rotación dinámica real
- ✅ Nuevo parámetro `delay_between_lights`

### v2.0 (2025-11-18)
- ✅ Blueprint de simulación de presencia completamente reescrito
- ✅ Cleanup automático integrado (sin automatizaciones extras)
- ❌ Bug: Solo mantenía 1 luz encendida (corregido en v2.1)
- ✅ Reorganización completa del proyecto
- ✅ Documentación consolidada por proyectos
- ✅ Limpieza de archivos temporales

### v1.3 (2025-11)
- ✅ Monitoreo integrado en blueprint
- ✅ Widget de dashboard con estado en tiempo real

### v1.2 (2025-11)
- ✅ Logging detallado en logbook
- ✅ Tracking de cada acción

### v1.1 (2025-11)
- ✅ Detención limpia implementada
- ✅ Modo `single` para evitar múltiples ejecuciones

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver archivo `LICENSE` para más detalles.

---

## 🆘 Soporte

Si encuentras problemas:

1. Revisa la [documentación del proyecto](docs/)
2. Busca en [Issues](https://github.com/mauitz/home-assistant-blueprints/issues)
3. Abre un nuevo Issue con detalles

---

## 🙏 Créditos

- **Simulación de Presencia**: Basado en [Holiday & Away Lighting by Blackshome](https://gist.github.com/Blackshome/0a34870755762bcb9fab159d5b94fd25)
- **Home Assistant Community**: Por la inspiración y soporte
- **Frigate**: [blakeblackshear/frigate](https://github.com/blakeblackshear/frigate)

---

**Última actualización:** 2026-01-10
**Versión:** 3.4
