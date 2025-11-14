# 🏠 Home Assistant - Automatizaciones Avanzadas

Colección completa de blueprints, automatizaciones y dashboards para Home Assistant, con enfoque en simulación de presencia, detección inteligente con IA y UI moderna.

---

## 📦 **COMPONENTES PRINCIPALES**

### 🎯 **1. Presence Simulation Blueprint (v1.3)**

Simulación inteligente de presencia con monitoreo integrado y control de lámparas simultáneas.

**Características:**
- ✅ Monitoreo integrado (loops, luces activas, tiempo de ejecución)
- ✅ Control de lámparas simultáneas configurable
- ✅ Detención inmediata (< 5 segundos)
- ✅ Loops configurables (0-50 o infinito)
- ✅ Múltiples triggers (tiempo, elevación solar, sensores)
- ✅ Logging detallado para debugging

**Instalación:**
```yaml
Configuración → Blueprints → Importar
URL: https://github.com/mauitz/home-assistant-blueprints/blob/main/blueprints/pezaustral_presence_simulation.yaml
```

**Documentación completa:** [docs/pezaustral_presence_simulation/](docs/pezaustral_presence_simulation/)

---

### 📸 **2. Sistema de Detección con Frigate NVR**

Detección de objetos con IA (YOLO) usando Frigate para personas, vehículos y animales.

**Características:**
- 🚨 Detección de personas (alerta crítica)
- 🚗 Detección de vehículos (alerta normal)
- 🐕 Detección de animales (alerta silenciosa)
- 📷 Snapshots con bounding boxes
- 🔔 Notificaciones push diferenciadas
- 🎛️ Widget de dashboard con estados en tiempo real
- 🔊 Activación de sirenas y floodlights

**Cámaras soportadas:**
- Tapo C530WS (Entrada) - Personas + Vehículos
- Tapo C310 (Exterior) - Personas + Vehículos + Animales

**Instalación:** [INSTALAR_FRIGATE_SERVIDOR.md](INSTALAR_FRIGATE_SERVIDOR.md)

**Automatizaciones:** [examples/camera_alert_system_v3.3_frigate.yaml](examples/camera_alert_system_v3.3_frigate.yaml)

---

### 🌆 **3. Atardecer Inteligente**

Automatizaciones para gestión inteligente de iluminación al atardecer y control de simulación de presencia.

**Características:**
- 🌅 Activa escena "Anochecer" 30 min después del ocaso
- 🏠 Detecta si usuario está en casa
- 🔐 Activa simulación de presencia si no hay nadie
- 🔔 Notificaciones push al activar/desactivar
- 🚪 Desactivación automática al regresar a casa

**Automatizaciones:**
- [examples/atardecer_inteligente.yaml](examples/atardecer_inteligente.yaml)
- [examples/regreso_casa_desactivar_simulacion.yaml](examples/regreso_casa_desactivar_simulacion.yaml)

**Documentación:** [docs/ATARDECER_INTELIGENTE.md](docs/ATARDECER_INTELIGENTE.md)

---

### 🎨 **4. Dashboard Maui**

Dashboard moderno y profesional con diseño oscuro y funcionalidad avanzada.

**Características:**
- 📹 Vistas de cámaras en tiempo real
- 🎭 Botones de escenas con acceso rápido
- 📍 Widget de áreas (navegación al dashboard nativo)
- 📊 Widget de monitoreo de Frigate (personas/vehículos/animales)
- 📸 Cámaras dinámicas que se agrandan al detectar alertas
- 🎨 Tema oscuro profesional (Maui Dark)

**Dashboard:** [dashboards/maui_dashboard_v3.1.yaml](dashboards/maui_dashboard_v3.1.yaml)

**Tema:** [themes/maui_theme.yaml](themes/maui_theme.yaml)

**Documentación:** [docs/FRIGATE_QUICK_START.md](docs/FRIGATE_QUICK_START.md)

---

### 🔄 **5. Tuya-Sonoff Sync**

Sincronización bidireccional entre switches Tuya y Sonoff con protección anti-loop.

**Instalación:**
```yaml
Configuración → Blueprints → Importar
URL: https://github.com/mauitz/home-assistant-blueprints/blob/main/blueprints/tuya_sonoff_sync.yaml
```

---

## 📂 **ESTRUCTURA DEL PROYECTO**

```
home-assistant-blueprints/
├── blueprints/                              # Blueprints principales
│   ├── pezaustral_presence_simulation.yaml  # v1.3 con monitoreo integrado
│   ├── pezaustral_presence_simulation_v1.3.yaml
│   └── tuya_sonoff_sync.yaml
│
├── dashboards/                              # Dashboards Lovelace
│   ├── maui_dashboard_v3.1.yaml             # Dashboard principal
│   ├── maui_templates/                      # Templates reutilizables
│   └── maui_views/                          # Vistas modulares
│
├── themes/                                  # Temas personalizados
│   └── maui_theme.yaml                      # Tema oscuro profesional
│
├── examples/                                # Configuraciones de ejemplo
│   ├── atardecer_inteligente.yaml           # Automatización atardecer
│   ├── regreso_casa_desactivar_simulacion.yaml
│   ├── camera_alert_system_v3.3_frigate.yaml # Automatizaciones Frigate
│   ├── camera_alert_helpers.yaml            # Helpers para alertas
│   ├── frigate_config.yml                   # Config de Frigate
│   ├── presence_simulation_config.yaml      # Config básica de simulación
│   ├── presence_simulation_helpers.yaml     # Helpers para monitoreo
│   └── exit_scene_example.yaml              # Escena de salida
│
├── docs/                                    # Documentación completa
│   ├── pezaustral_presence_simulation/      # Docs del blueprint
│   │   ├── README.md
│   │   ├── TROUBLESHOOTING.md
│   │   └── CHANGELOG.md
│   ├── ATARDECER_INTELIGENTE.md             # Atardecer inteligente
│   ├── CAMARAS_TAPO_INTEGRACION_CORRECTA.md # Integración Tapo
│   ├── FRIGATE_INSTALACION_COMPLETA.md      # Instalación Frigate detallada
│   ├── FRIGATE_QUICK_START.md               # Quick start Frigate
│   ├── IMPLEMENTACION_BLE_BEACONS.md        # BLE beacons (futuro)
│   ├── PLANTILLA_BEACONS.md                 # Template para beacons
│   ├── WIDGET_AREA_INTELIGENTE.md           # Widget de áreas
│   └── beacons-esp32.md                     # ESP32 beacons
│
├── HA_config_proxy/                         # Proxy de config del servidor
│   ├── configuration.yaml                   # Configuración principal
│   ├── automations.yaml                     # Todas las automatizaciones
│   └── scenes.yaml                          # Escenas
│
├── ha_manager.py                            # CLI para gestión vía API
├── setup.sh                                 # Setup de API access
├── requirements.txt                         # Dependencias Python
├── INSTALAR_FRIGATE_SERVIDOR.md             # Guía de instalación Frigate
└── README.md                                # Este archivo
```

---

## 🚀 **INICIO RÁPIDO**

### **Opción 1: Simulación de Presencia**

```bash
1. Importar blueprint desde GitHub
2. Crear input_boolean.presence_simulation
3. Configurar lista de luces
4. Activar y probar
```

### **Opción 2: Frigate + Detección IA**

```bash
1. Instalar Frigate en Docker (ver INSTALAR_FRIGATE_SERVIDOR.md)
2. Configurar cámaras en frigate_config.yml
3. Instalar integración Frigate en Home Assistant
4. Importar automatizaciones V3.3
5. Actualizar dashboard con widget de monitoreo
```

### **Opción 3: Dashboard Maui**

```bash
1. Instalar HACS custom cards (Button Card, Grid Layout, Card-Mod)
2. Instalar tema Maui Dark
3. Importar dashboard maui_dashboard_v3.1.yaml
4. Ajustar entity_ids a tu configuración
```

---

## 📚 **DOCUMENTACIÓN**

### **Blueprints**
- [Presence Simulation - README](docs/pezaustral_presence_simulation/README.md)
- [Presence Simulation - Troubleshooting](docs/pezaustral_presence_simulation/TROUBLESHOOTING.md)
- [Presence Simulation - Changelog](docs/pezaustral_presence_simulation/CHANGELOG.md)

### **Automatizaciones**
- [Atardecer Inteligente](docs/ATARDECER_INTELIGENTE.md)
- [Frigate - Quick Start](docs/FRIGATE_QUICK_START.md)
- [Frigate - Instalación Completa](docs/FRIGATE_INSTALACION_COMPLETA.md)

### **Cámaras y Detección**
- [Integración Tapo Correcta](docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md)
- [Instalar Frigate en Servidor](INSTALAR_FRIGATE_SERVIDOR.md)

### **Dashboard y UI**
- [Widget de Área Inteligente](docs/WIDGET_AREA_INTELIGENTE.md)

### **Futuras Implementaciones**
- [BLE Beacons - Implementación](docs/IMPLEMENTACION_BLE_BEACONS.md)
- [BLE Beacons - Plantilla](docs/PLANTILLA_BEACONS.md)
- [ESP32 Beacons](docs/beacons-esp32.md)

---

## 🆕 **ÚLTIMAS ACTUALIZACIONES**

### **v3.3 - Sistema de Detección con Frigate** (Nov 2025)
- ✅ Integración completa de Frigate NVR
- ✅ Detección con IA (YOLO): personas, vehículos, animales
- ✅ 7 automatizaciones específicas por tipo de objeto
- ✅ Widget de dashboard con timestamps y animaciones
- ✅ Notificaciones diferenciadas por tipo de detección
- ✅ Snapshots con bounding boxes

### **v3.1 - Dashboard Maui** (Nov 2025)
- ✅ Cámaras dinámicas que se agrandan al detectar
- ✅ Widget de monitoreo de Frigate en tiempo real
- ✅ Tema oscuro profesional
- ✅ Grid layout para mejor organización
- ✅ Notificaciones optimizadas (una sola por detección)

### **v1.3 - Presence Simulation** (Nov 2025)
- ✅ Monitoreo integrado en el blueprint
- ✅ Logging detallado
- ✅ Sensores de progreso y estado
- ✅ Sin necesidad de automatizaciones externas

---

## 🛠️ **REQUISITOS**

### **Sistema**
- **Home Assistant**: v2024.10+ (recomendado 2025.7+)
- **Supervisor/Docker**: Para instalación de Frigate
- **HACS**: Para custom cards del dashboard

### **Hardware Recomendado (Frigate)**
- **CPU**: 3+ cores
- **RAM**: 2GB+ disponibles
- **Disco**: 20GB+ para grabaciones (ajustable)
- **Red**: Gigabit ethernet (recomendado)

### **Integraciones**
- **Frigate** (HACS): Para detección con IA
- **Tapo: Cameras Control** (HACS): Para cámaras Tapo
- **Mosquitto MQTT**: Para comunicación Frigate-HA

---

## 💡 **CASOS DE USO**

### **1. Seguridad en Vacaciones**
```yaml
Sistema completo:
- Simulación de presencia activada al atardecer
- Frigate monitoreando 24/7
- Notificaciones críticas de personas detectadas
- Dashboard con estado en tiempo real
```

### **2. Automatización Nocturna**
```yaml
Al atardecer:
- Activa escena "Anochecer"
- Si no hay nadie: Inicia simulación de presencia
- Detecta personas/vehículos con Frigate
- Notifica cualquier movimiento
```

### **3. Monitoreo Diurno**
```yaml
Durante el día:
- Frigate detecta vehículos (notificación normal)
- Frigate detecta personas (alerta crítica + sirena)
- Dashboard muestra estado en tiempo real
- Grabaciones automáticas de eventos
```

---

## 🎯 **BLUEPRINTS POTENCIALES PARA OPEN SOURCE**

### ✅ **Ya Disponibles**
1. **Presence Simulation** (v1.3) - Listo para compartir
2. **Tuya-Sonoff Sync** - Listo para compartir

### 🚧 **En Consideración**
3. **Frigate Alert System** - Sistema completo de alertas con notificaciones diferenciadas
4. **Intelligent Sunset** - Automatización de atardecer con simulación de presencia
5. **Dynamic Camera Dashboard** - Widget de cámaras que se agranda al detectar

**Nota:** Los sistemas 3-5 son muy específicos de la instalación actual, pero podrían ser generalizados para la comunidad.

---

## 🤝 **CONTRIBUIR**

¿Encontraste un bug? ¿Tienes una sugerencia?

1. **Issues**: [GitHub Issues](https://github.com/mauitz/home-assistant-blueprints/issues)
2. **Pull Requests**: Mejoras bienvenidas
3. **Documentación**: Ayuda a mejorar las guías

---

## 📄 **LICENCIA**

MIT License - Libre para uso personal y comercial.

---

## 🙏 **CRÉDITOS**

### **Presence Simulation**
- **Autor**: Mauitz (PezAustral)
- **Basado en**: [Holiday & Away Lighting](https://gist.github.com/Blackshome/0a34870755762bcb9fab159d5b94fd25) por Blackshome
- **Versión**: 1.3 (Noviembre 2025)

### **Frigate Integration**
- **Frigate NVR**: [blakeblackshear/frigate](https://github.com/blakeblackshear/frigate)
- **YOLO Model**: [Ultralytics](https://github.com/ultralytics/ultralytics)

### **Dashboard**
- **Mushroom Cards**: [piitaya/lovelace-mushroom](https://github.com/piitaya/lovelace-mushroom)
- **Grid Layout**: [thomasloven/lovelace-layout-card](https://github.com/thomasloven/lovelace-layout-card)
- **Card-Mod**: [thomasloven/lovelace-card-mod](https://github.com/thomasloven/lovelace-card-mod)

---

## 🔗 **LINKS ÚTILES**

- [Home Assistant](https://www.home-assistant.io/)
- [Frigate NVR](https://frigate.video/)
- [HACS](https://hacs.xyz/)
- [Home Assistant Community](https://community.home-assistant.io/)

---

## 📊 **ESTADÍSTICAS**

- **Blueprints**: 2 (+ 3 en consideración)
- **Automatizaciones**: 12 activas
- **Documentación**: ~50 páginas
- **Cámaras**: 2 (Tapo C530WS + C310)
- **Objetos detectados**: Personas, vehículos, animales
- **Última actualización**: Noviembre 2025

---

*Home Assistant Blueprints - Automatización Inteligente con IA*  
*Actualizado: 2025-11-14*
