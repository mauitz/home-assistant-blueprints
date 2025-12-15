# 🚰 Sistema de Riego Inteligente

Sistema completo de riego automático con ESP32 + ESPHome integrado con Home Assistant.

---

## 📦 Estructura del Proyecto

```
sistema_riego/
├── README.md                    # Este archivo
├── RESUMEN_PACKAGE_RIEGO.md    # Resumen del package v3.2
│
├── docs/                        # Documentación
│   ├── RIEGO_INTELIGENTE.md    # Guía completa del sistema
│   ├── INSTALACION_PACKAGE_RIEGO.md  # Instalación del package
│   ├── INSTALACION_RIEGO_RAPIDA.md   # Guía rápida de instalación
│   ├── INSTALACION_PASO_A_PASO.md    # Instalación detallada
│   ├── TROUBLESHOOTING_DHT11.md      # Solución de problemas DHT11
│   ├── DIAGNOSTICO_SENSORES.md       # Diagnóstico de sensores
│   └── GUIA_RAPIDA_CONSTRUCCION.md   # Construcción rápida del hardware
│
├── hardware/                    # Hardware y construcción
│   ├── ARQUITECTURA_PCB_8x12cm.md      # Guía definitiva de construcción
│   ├── ARQUITECTURA_FISICA_MODULO.md   # Arquitectura física completa
│   ├── PINOUT_ESP32_30PIN.md           # Pinout detallado ESP32 30 pines
│   ├── DIAGRAMA_PINOUT_ESP32.md        # Diagramas de conexión
│   ├── VALIDACION_PLACA_30PIN.md       # Validación de hardware
│   ├── esp32.jpg                        # Imagen ESP32
│   ├── plancha.jpg                      # Imagen plancha protoboard
│   └── picos.jpg                        # Imagen componentes
│
├── widgets/                     # Widgets para dashboard
│   ├── widget_riego_z1.yaml           # Widget completo v2.1
│   ├── widget_riego_z1_basico.yaml    # Widget básico
│   └── WIDGET_RIEGO.md                # Documentación de widgets
│
└── examples/                    # Ejemplos y utilidades
    ├── riego_z1_auto.yaml            # Ejemplo de automatización
    ├── riego_helpers.yaml            # Ejemplo de helpers
    ├── riego_helpers_configuration.yaml
    ├── riego_scripts.yaml            # Scripts de ejemplo
    ├── crear_helpers_riego.sh        # Script para crear helpers
    └── install_riego_blueprint.sh    # Script de instalación
```

---

## 🚀 Inicio Rápido

### Opción 1: Package Unificado (RECOMENDADO) ⭐

**El package incluye TODO en un solo archivo:**
- ✅ Helpers (se crean automáticamente)
- ✅ Scripts (6 scripts incluidos)
- ✅ Sensors templates
- ✅ Automatización completa

**Instalación:**

1. Copia el package a Home Assistant:
   ```bash
   cp ../packages/sistema_riego_z1.yaml /config/packages/
   ```

2. Habilita packages en `/config/configuration.yaml`:
   ```yaml
   homeassistant:
     packages: !include_dir_named packages
   ```

3. Reinicia Home Assistant

4. ¡Listo! Todo se crea automáticamente.

📖 **Documentación completa:** [INSTALACION_PACKAGE_RIEGO.md](docs/INSTALACION_PACKAGE_RIEGO.md)

---

### Opción 2: Blueprint

**Requiere configuración manual de helpers y scripts.**

📖 **Documentación:** [INSTALACION_RIEGO_RAPIDA.md](docs/INSTALACION_RIEGO_RAPIDA.md)

---

## 🏗️ Hardware

### Componentes principales:

- **ESP32** (30 pines)
- **Sensores:**
  - Humedad del suelo (analógico)
  - HC-SR04 (nivel de tanque)
  - DHT11 (temperatura y humedad ambiente)
  - LDR (luz ambiente)
  - LD2410C (presencia mmWave - opcional)
- **Actuadores:**
  - Módulo relé 6 canales
  - Bombas de agua 5V
- **PCB:** Protoboard 8×12 cm montada en caja Stanco IP65

### Guías de construcción:

- 📌 **[Guía Rápida de Construcción](docs/GUIA_RAPIDA_CONSTRUCCION.md)** - Construcción en 4-6 horas
- 🏗️ **[Arquitectura PCB 8×12 cm](hardware/ARQUITECTURA_PCB_8x12cm.md)** - Guía definitiva completa
- 📐 **[Pinout ESP32 30-pin](hardware/PINOUT_ESP32_30PIN.md)** - Conexiones detalladas
- ✅ **[Validación Hardware](hardware/VALIDACION_PLACA_30PIN.md)** - Verificación de compatibilidad

---

## 🔧 Firmware ESPHome

El firmware se encuentra en: `../esphome/riego_z1.yaml`

**Incluye:**
- Sensores configurados y calibrados
- Control de bombas
- LEDs de estado
- API para Home Assistant
- OTA updates
- Logs detallados

**Flashear:**
```bash
cd ../esphome
python3 -m esphome run riego_z1.yaml --device 192.168.1.15
```

---

## 🎨 Dashboard

### Widget especializado:

Archivo: [`widgets/widget_riego_z1.yaml`](widgets/widget_riego_z1.yaml)

**Características:**
- Estado del sistema en tiempo real
- Sensores visualizados
- Controles de riego manual
- Botones de acción rápida
- Información del ESP32

📖 **Documentación:** [WIDGET_RIEGO.md](widgets/WIDGET_RIEGO.md)

---

## 📚 Documentación

### Guías principales:

| Documento | Descripción |
|-----------|-------------|
| [RIEGO_INTELIGENTE.md](docs/RIEGO_INTELIGENTE.md) | Documentación completa del sistema |
| [INSTALACION_PACKAGE_RIEGO.md](docs/INSTALACION_PACKAGE_RIEGO.md) | Instalación del package (RECOMENDADO) |
| [INSTALACION_RIEGO_RAPIDA.md](docs/INSTALACION_RIEGO_RAPIDA.md) | Instalación rápida con blueprint |
| [TROUBLESHOOTING_DHT11.md](docs/TROUBLESHOOTING_DHT11.md) | Solución de problemas DHT11 |
| [DIAGNOSTICO_SENSORES.md](docs/DIAGNOSTICO_SENSORES.md) | Diagnóstico de sensores |

### Hardware:

| Documento | Descripción |
|-----------|-------------|
| [ARQUITECTURA_PCB_8x12cm.md](hardware/ARQUITECTURA_PCB_8x12cm.md) | Guía definitiva de construcción del PCB |
| [PINOUT_ESP32_30PIN.md](hardware/PINOUT_ESP32_30PIN.md) | Pinout completo del ESP32 30 pines |
| [GUIA_RAPIDA_CONSTRUCCION.md](docs/GUIA_RAPIDA_CONSTRUCCION.md) | Construcción rápida (4-6 horas) |

---

## ✨ Características

### Sistema de Control:
- ✅ Control automático por humedad del suelo
- ✅ Protección de nivel de tanque bajo
- ✅ Horarios de riego configurables (6:00 - 22:00)
- ✅ Duración máxima configurable (default: 10 min)
- ✅ Objetivo de humedad configurable (default: 60%)
- ✅ Modo manual y automático
- ✅ Múltiples zonas independientes

### Notificaciones:
- ✅ Notificación de inicio de riego
- ✅ Notificación de fin de riego
- ✅ Alerta de tanque bajo
- ✅ Logs detallados en logbook

### Seguridad:
- ✅ Timeout de seguridad (10 min máximo)
- ✅ Verificación de nivel de tanque antes de regar
- ✅ Detención manual de emergencia
- ✅ Modo `single` (no permite ejecuciones simultáneas)

---

## 🔧 Scripts Incluidos

El package incluye 6 scripts listos para usar:

| Script | Descripción | Duración |
|--------|-------------|----------|
| `riego_manual_5min` | Riego manual 5 minutos | 5 min |
| `riego_manual_10min` | Riego manual 10 minutos | 10 min |
| `detener_todas_bombas` | Detención de emergencia | Inmediato |
| `test_bombas_z1` | Test de todas las bombas | 10s c/u |
| `riego_emergencia_z1` | Riego hasta 60% humedad | Hasta 15 min |
| `registrar_riego_z1` | Actualiza contador y timestamp | Inmediato |

---

## 🆘 Troubleshooting

### Problemas comunes:

1. **DHT11 no responde**
   - Ver: [TROUBLESHOOTING_DHT11.md](docs/TROUBLESHOOTING_DHT11.md)

2. **Sensores muestran "unavailable"**
   - Ver: [DIAGNOSTICO_SENSORES.md](docs/DIAGNOSTICO_SENSORES.md)

3. **No riega automáticamente**
   - Verificar modo manual (debe estar OFF)
   - Verificar humedad < 30%
   - Verificar nivel tanque > 20%
   - Verificar horario (6:00 - 22:00)

4. **Package no carga**
   - Verificar `configuration.yaml` tiene `packages: !include_dir_named packages`
   - Verificar sintaxis YAML con: Herramientas → YAML → Verificar configuración

---

## 📊 Estado del Sistema

### En producción (Home Assistant Pezaustral):

- ✅ Package: `packages/sistema_riego_z1.yaml`
- ✅ Firmware ESPHome: `esphome/riego_z1.yaml`
- ⚠️ Hardware: ESP32 actualmente offline
- ✅ Documentación: Completa y actualizada

---

## 🤝 Contribuir

Este sistema es parte del proyecto [home-assistant-blueprints](../).

Reporta problemas o sugiere mejoras en [GitHub Issues](https://github.com/mauitz/home-assistant-blueprints/issues).

---

## 📝 Changelog

### v3.2 (Diciembre 2024)
- ✨ **Package unificado** - Todo en 1 archivo
- ✅ Helpers automáticos (sin creación manual)
- ✅ 6 Scripts incluidos en el package
- ✅ Sensors templates (estado del sistema, tiempo desde último riego)
- ✅ Widget especializado v2.1
- 🏗️ Documentación de hardware completa (PCB 8×12 cm)
- 🔧 Troubleshooting DHT11 detallado
- 📦 Reorganización: Todo encapsulado en `sistema_riego/`

### v2.1 (Noviembre 2024)
- ✅ Primer release del Sistema de Riego Inteligente
- ✅ Widget especializado y scripts auxiliares

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT.

---

**Última actualización:** Diciembre 2024
**Versión:** 3.2
**Autor:** @mauitz
