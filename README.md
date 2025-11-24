a# 🏠 Home Assistant BlueprintsConfigurations

Colección de blueprints, automatizaciones y configuraciones para Home Assistant optimizadas para domótica inteligente.

---

## 📦 Proyectos

### 🎭 [Simulación de Presencia](docs/pezaustral_presence_simulation/)

Blueprint avanzado para simular presencia en casa cuando estás fuera.

**Características:**
- ✅ Control inteligente de múltiples luces/switches
- ✅ Límite de dispositivos encendidos simultáneamente
- ✅ **Cleanup automático** integrado (apaga todo al detener)
- ✅ Monitoreo en tiempo real con widgets
- ✅ Loops configurables o infinitos
- ✅ Escenas de salida personalizables
- ✅ Logs detallados

**Archivos:**
- [`blueprints/pezaustral_presence_simulation.yaml`](blueprints/pezaustral_presence_simulation.yaml)
- [Documentación completa](docs/pezaustral_presence_simulation/)
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

### 📡 Beacons BLE (ESP32)

Implementación de beacons Bluetooth Low Energy con ESP32 para presencia.

**Documentación:**
- [Implementación completa](docs/beacons/IMPLEMENTACION_BLE_BEACONS.md)
- [Configuración ESP32](docs/beacons/beacons-esp32.md)
- [Plantilla](docs/beacons/PLANTILLA_BEACONS.md)

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

### 🚰 [Sistema de Riego Inteligente](docs/automatizaciones/RIEGO_INTELIGENTE.md)

Blueprint completo para automatización de riego con ESP32 + ESPHome.

**Características:**
- ✅ Control automático por humedad del suelo
- ✅ Protección de nivel de tanque bajo
- ✅ Horarios de riego configurables
- ✅ Duración máxima y objetivos de humedad
- ✅ Notificaciones de inicio/fin de riego
- ✅ Modo manual y automático
- ✅ Múltiples zonas independientes

**Hardware:**
- ESP32 con sensores (humedad, nivel, temperatura, luz, presencia)
- Bombas de agua 5V + relés de 6 canales
- Integración completa con Home Assistant

**Archivos:**
- [`blueprints/sistema_riego_inteligente.yaml`](blueprints/sistema_riego_inteligente.yaml)
- [`esphome/riego_z1.yaml`](esphome/riego_z1.yaml) - Firmware ESP32
- [Documentación completa](docs/automatizaciones/RIEGO_INTELIGENTE.md)
- [Ejemplo de configuración](examples/automatizaciones/riego_z1_auto.yaml)

---

### 🔧 Otros Blueprints

- **Tuya-Sonoff Sync**: [`blueprints/tuya_sonoff_sync.yaml`](blueprints/tuya_sonoff_sync.yaml)
  Sincronización entre dispositivos Tuya y Sonoff

---

## 📁 Estructura del Proyecto

```
home-assistant-blueprints/
├── blueprints/              # Blueprints reutilizables
│   ├── pezaustral_presence_simulation.yaml
│   ├── tuya_sonoff_sync.yaml
│   └── sistema_riego_inteligente.yaml
├── esphome/                 # Firmware ESP32/ESPHome
│   ├── riego_z1.yaml        # ESP32 - Sistema de riego Zona 1
│   └── secrets.yaml
├── examples/                # Configuraciones de ejemplo
│   ├── presence_simulation_config.yaml
│   ├── presence_simulation_helpers.yaml
│   ├── frigate/
│   └── automatizaciones/
│       ├── riego_z1_auto.yaml
│       └── atardecer_inteligente.yaml
├── dashboards/              # Dashboards personalizados
│   ├── maui_dashboard_v3.1.yaml
│   ├── maui_templates/
│   └── maui_views/
├── docs/                    # Documentación organizada por proyecto
│   ├── pezaustral_presence_simulation/
│   ├── frigate/
│   ├── camaras/
│   ├── beacons/
│   ├── dashboard/
│   └── automatizaciones/
│       └── RIEGO_INTELIGENTE.md
├── utils/                   # Utilidades y scripts
│   ├── ha_manager.py
│   ├── verify_installation.sh
│   └── verify_presence_simulation.sh
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

- [**Simulación de Presencia**](docs/pezaustral_presence_simulation/) - Blueprint completo con changelog y troubleshooting
- [**Frigate**](docs/frigate/) - NVR con detección de objetos
- [**Cámaras**](docs/camaras/) - Integración Tapo y Xiaomi
- [**Beacons BLE**](docs/beacons/) - Presencia con ESP32
- [**Dashboard**](docs/dashboard/) - Widgets y UI
- [**Automatizaciones**](docs/automatizaciones/) - Guías de automatizaciones avanzadas
  - [Sistema de Riego Inteligente](docs/automatizaciones/RIEGO_INTELIGENTE.md) - ESP32 + ESPHome

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

### v2.1 (2025-11-24)
- ✅ **Sistema de Riego Inteligente** completo con ESP32 + ESPHome
  - Blueprint de automatización con control por humedad
  - Firmware ESPHome para ESP32 con múltiples sensores
  - Integración con LD2410C (presencia mmWave)
  - Documentación completa y ejemplos
- ✅ Gestión de múltiples zonas de riego
- ✅ Protección de nivel de tanque

### v2.0 (2025-11-18)
- ✅ Blueprint de simulación de presencia completamente reescrito
- ✅ Cleanup automático integrado (sin automatizaciones extras)
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

**Última actualización:** 2025-11-18
**Versión:** 2.0
