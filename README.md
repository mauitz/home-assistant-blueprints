# 🏠 Home Assistant Blueprints

Colección de blueprints para Home Assistant, enfocados en automatización inteligente y simulación de presencia.

---

## 📦 Blueprints Disponibles

### 🏠 PezAustral Presence Simulation
**Versión:** 1.1 (Fixed - Nov 2025)

Simulación avanzada de presencia con control de lámparas simultáneas y detención inmediata.

**Características:**
- Control de lámparas simultáneas (límite configurable)
- Apagado inteligente en paralelo
- Loop configurable (0-50 o infinito)
- **Detención inmediata** (< 5 segundos) 🆕
- Escena de parada de emergencia 🆕
- Múltiples triggers (tiempo, sol, luz, entidades)
- Control por zona y personas

**Instalación:**
```
[![Import Blueprint](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https://github.com/TU_USUARIO/home-assistant-blueprints/blob/main/blueprints/pezaustral_presence_simulation.yaml)
```

**Documentación:**
- [README](docs/pezaustral_presence_simulation/README.md)
- [Troubleshooting](docs/pezaustral_presence_simulation/TROUBLESHOOTING.md)
- [Changelog](docs/pezaustral_presence_simulation/CHANGELOG.md)
- [Ejemplos](/examples/)

**Basado en:** [Holiday & Away Lighting by Blackshome](https://gist.github.com/Blackshome/0a34870755762bcb9fab159d5b94fd25)

---

### 🔄 Tuya-Sonoff Sync
**Versión:** 1.0

Sincronización bidireccional entre dos switches (ej: Tuya ↔ Sonoff) con protección anti-loop.

**Características:**
- Sincronización ON/OFF bidireccional
- Protección anti-loop
- Debounce configurable
- Modo queued

**Instalación:**
```
[![Import Blueprint](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https://github.com/TU_USUARIO/home-assistant-blueprints/blob/main/blueprints/tuya_sonoff_sync.yaml)
```

---

## 📂 Estructura del Repositorio

```
home-assistant-blueprints/
├── blueprints/                          # Blueprints principales
│   ├── pezaustral_presence_simulation.yaml
│   └── tuya_sonoff_sync.yaml
├── examples/                            # Ejemplos de configuración
│   ├── presence_simulation_config.yaml       # Config básica
│   ├── presence_simulation_optimized.yaml    # Config optimizada
│   ├── presence_simulation_helpers.yaml      # Helpers para monitoring
│   ├── presence_simulation_monitoring.yaml   # Automatizaciones auxiliares
│   ├── dashboard_card.yaml                   # Tarjeta dashboard
│   └── exit_scene_example.yaml               # Escena de ejemplo
├── docs/                                # Documentación
│   ├── pezaustral_presence_simulation/
│   │   ├── README.md
│   │   ├── TROUBLESHOOTING.md
│   │   └── CHANGELOG.md
│   └── monitoring/
│       └── README.md
└── README.md                            # Este archivo
```

---

## 🚀 Inicio Rápido

### PezAustral Presence Simulation

**1. Importar Blueprint:**
```bash
Configuración → Automatizaciones y Escenas → Blueprints
→ Importar Blueprint → URL del repositorio
```

**2. Crear Automatización:**
```yaml
Nombre: Simulación de Presencia
Blueprint: PezAustral Presence Simulation
Config:
  - Trigger: input_boolean.presence_simulation
  - Luces: [switch.sala, switch.cocina, switch.dormitorio]
  - Máximo simultáneas: 2
  - Tiempo ON: 15-45 min
  - Loop: 5 repeticiones
```

**3. Probar:**
```bash
1. Activa input_boolean.presence_simulation
2. Observa las luces
3. Desactiva input_boolean.presence_simulation
4. ✅ Se debe detener en < 5 segundos
```

---

## 📚 Documentación

### Por Blueprint

- **PezAustral Presence Simulation**
  - [README completo](docs/pezaustral_presence_simulation/README.md)
  - [Troubleshooting](docs/pezaustral_presence_simulation/TROUBLESHOOTING.md)
  - [Changelog](docs/pezaustral_presence_simulation/CHANGELOG.md)
  - [Ejemplos](examples/)

- **Tuya-Sonoff Sync**
  - Ver comentarios en el blueprint

### Recursos Adicionales

- [Sistema de Monitoring](docs/monitoring/README.md) - Panel de control para simulación de presencia
- [Ejemplos de Configuración](examples/) - Configs listas para usar

---

## 🆕 Últimas Actualizaciones

### v1.1 - PezAustral Presence Simulation (2025-11-11)
- 🚨 **CRÍTICO**: Corregido bug que impedía detener la automatización
- ✅ Ahora se detiene en menos de 5 segundos
- ✅ Agregada escena de parada de emergencia
- ✅ Verificación continua de estado durante ejecución

[Ver changelog completo](docs/pezaustral_presence_simulation/CHANGELOG.md)

---

## 🛠️ Requisitos

- **Home Assistant**: v2024.1 o superior (recomendado v2025.7+)
- **Dispositivos**: Cualquier entidad `switch.*` o `light.*` compatible
- **Protocolos**: Zigbee, Z-Wave, WiFi, Bluetooth (cualquiera que HA soporte)

---

## 💡 Casos de Uso

### Simulación de Presencia

**Escenario 1: Vacaciones**
```yaml
Trigger: Elevación solar (-5°)
Luces: Todas las principales
Max simultáneas: 3
Loop: Infinito
Control: Solo si zona.home vacía
```

**Escenario 2: Salida Nocturna**
```yaml
Trigger: input_boolean manual
Luces: Sala, cocina, entrada
Max simultáneas: 2
Loop: 5 repeticiones (~3 horas)
Escena salida: Apagar todo
```

**Escenario 3: Rutina Laboral**
```yaml
Trigger: Lunes-Viernes 09:00
Luces: Principales
Max simultáneas: 1
Loop: 8 repeticiones
Días: Lun-Vie
```

---

## 🤝 Contribuir

¿Encontraste un bug? ¿Tienes una sugerencia?

1. **Issues**: Reporta en [GitHub Issues](https://github.com/TU_USUARIO/home-assistant-blueprints/issues)
2. **Pull Requests**: Mejoras bienvenidas
3. **Documentación**: Ayuda a mejorar las guías

### Reportar Bugs

Incluye:
- Versión de Home Assistant
- Versión del blueprint
- Configuración YAML (sin datos sensibles)
- Logs relevantes
- Pasos para reproducir

---

## 📄 Licencia

MIT License - Libre para uso personal y comercial.

---

## 🙏 Créditos

### PezAustral Presence Simulation
- **Autor**: PezAustral
- **Basado en**: [Holiday & Away Lighting](https://gist.github.com/Blackshome/0a34870755762bcb9fab159d5b94fd25) por Blackshome
- **Versión**: 1.1 (Noviembre 2025)

### Tuya-Sonoff Sync
- **Autor**: PezAustral
- **Versión**: 1.0

---

## 🔗 Links Útiles

- [Home Assistant](https://www.home-assistant.io/)
- [Home Assistant Community](https://community.home-assistant.io/)
- [Blueprint Documentation](https://www.home-assistant.io/docs/automation/using_blueprints/)

---

## 📊 Estadísticas

- **Blueprints**: 2
- **Ejemplos**: 6
- **Documentación**: ~40 páginas
- **Última actualización**: Noviembre 2025

---

*Home Assistant Blueprints - Automatización Inteligente*  
*Actualizado: 2025-11-11*
