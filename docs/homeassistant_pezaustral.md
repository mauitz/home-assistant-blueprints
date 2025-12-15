# 🏠 Home Assistant - Pezaustral
## Estado y Configuración Actual del Sistema

**📍 Ubicación:** Casa, Montevideo, Uruguay
**🌐 URL:** http://192.168.1.100:8123
**📦 Versión:** 2025.11.1
**⏰ Zona Horaria:** America/Montevideo
**📅 Última actualización:** 14 de Diciembre, 2025

---

## 📊 Resumen General

```
Total de Entidades:      399  (↓66 desde último análisis)
Automatizaciones:        48   (↓1)
  - Activas (ON):        12   (100% de las necesarias) ✅
  - Obsoletas:           36   (pendientes de eliminar)
Scripts:                 7    ✅
Dominios únicos:         31   (↓2)
Blueprints propios:      3    ✅
```

### ℹ️ Estado de Automatizaciones

**Las 12 automatizaciones activas son el 100% de la funcionalidad requerida.** Las 36 automatizaciones "unavailable" son obsoletas por:
- ✅ 15 de Frigate (sistema desinstalado intencionalmente)
- ✅ 5 de monitoreo de presencia (integradas en blueprint v1.3)
- ✅ 2 duplicadas de scene.anochecer
- ✅ ~14 otras automatizaciones sin entidades válidas

**Acción:** Limpieza de automatizaciones obsoletas (no crítico, solo mantenimiento)

### 🔌 Dominios Principales

| Dominio | Cantidad | Cambio | Estado |
|---------|----------|--------|--------|
| **Switches** | 82 | ↓8 | ✅ Activo |
| **Sensores** | 80 | ↓24 | ⚠️ Reducidos |
| **Automatizaciones** | 48 | ↓1 | ⚠️ 75% unavailable |
| **Selectores** | 36 | = | ✅ Activo |
| **Botones** | 28 | = | ✅ Activo |
| **Números** | 20 | = | ✅ Activo |
| **Sensores Binarios** | 16 | ↓14 | ⚠️ Reducidos |
| **Device Trackers** | 14 | = | ✅ Activo |
| **Actualizaciones** | 14 | ↓1 | ✅ Activo |
| **Luces** | 14 | = | ✅ Activo |

---

## 🔧 Integraciones Principales

### 🎥 Frigate (Sistema de Detección por IA)
**Estado:** 🚫 **DESINSTALADO INTENCIONALMENTE**

ℹ️ **Decisión de Arquitectura:** Frigate fue desinstalado porque el hardware actual no es adecuado para su funcionamiento.

- **Automatizaciones Obsoletas (15):**
  - ❌ Entrada - Detección de PERSONA
  - ❌ Entrada - Detección de VEHÍCULO
  - ❌ Entrada - Detección de ANIMAL
  - ❌ Exterior - Detección de PERSONA
  - ❌ Exterior - Detección de VEHÍCULO
  - ❌ Alertas y expansión de cámara
  - ❌ Activación/desactivación por movimiento
  - ❌ Modo nocturno/matutino

- **Estado Actual:**
  - ✅ Frigate desinstalado completamente
  - ❌ 15 automatizaciones en estado "unavailable"
  - ⏳ Se requiere otro tipo de hardware para detección por IA

- **Futuro:**
  - Se necesitarán otros dispositivos para detección e identificación por IA
  - Hardware actual no es compatible con Frigate
  - No se planea reinstalar en el corto plazo

- **✅ Acción Requerida:**
  - **Eliminar las 15 automatizaciones obsoletas de Frigate**
  - Configuración → Automatizaciones → Filtrar "frigate" o "unavailable"
  - Eliminar manualmente cada automatización obsoleta

### 🌱 ESPHome (Control de Hardware)
**Estado:** ⚠️ **Parcialmente operativo**

- **Dispositivos configurados:**
  - **Riego Z1** (ESP32) - ⚠️ OFFLINE
    - 20 sensores configurados (unavailable)
    - Integración definida pero dispositivo desconectado
    - Requiere reconexión del ESP32

### 📱 Tuya (Dispositivos Inteligentes)
**Estado:** ✅ **Operativo**

Múltiples dispositivos Tuya conectados:
- Switches de iluminación
- Cámaras
- Botones
- Ventiladores
- Sistema de alarma

### 🔌 Sonoff (Switches y Luces)
**Estado:** ✅ **Operativo**

Dispositivos Sonoff integrados para control de iluminación y switches.

### 📱 Xiaomi Home
**Estado:** ✅ **Operativo**

Integración completa con ecosistema Xiaomi:
- Luces
- Sensores
- Media players
- Persianas (covers)
- Selectores

### 📱 TP-Link Tapo
**Estado:** ✅ **Operativo**

Control de dispositivos Tapo (principalmente cámaras C530WS).

### 📍 Mobile App (Companion App)
**Estado:** ✅ **Operativo**

- Device tracking activo (usuario: blacky)
- Notificaciones push configuradas
- Binary sensors del móvil
- Integración completa con zonas

---

## 🎭 Funcionalidades Principales

### 1. 🎭 Simulación de Presencia
**Estado:** ✅ **Instalado y Funcional**

Sistema completo de simulación de presencia cuando no hay nadie en casa.

#### Configuración Actual:
- **Blueprint:** `pezaustral_presence_simulation.yaml` (v1.3)
- **Switches controlados:** 6 dispositivos
  - Bathroom 3 Switch 1
  - Hall 4 Switch 1
  - Cama Este (Sonoff)
  - Front door 4 Switch 1
  - Bathroom 3 Switch 2
  - Bedroom 3 Switch 1

#### Características:
- ✅ Control por entidad: `input_boolean.presence_simulation`
- ✅ Máximo 2 luces encendidas simultáneamente
- ✅ Delays aleatorios entre 5-120 segundos
- ✅ Duración de encendido: 8-30 minutos
- ✅ Sistema de loops: 10 ciclos configurados
- ✅ Monitoreo integrado
- ✅ Escena de salida: `scene.bedtime`
- ✅ Parada de emergencia configurada

#### Automatizaciones Activas:
1. **Presence Simulation** - ✅ ON (blueprint v1.3)
2. **Atardecer Inteligente** - ✅ ON
   - Activa escena de anochecer 30 min después del ocaso
   - Si no estás en casa, inicia simulación automáticamente
3. **Regreso a Casa - Desactivar Simulación** - ✅ ON
   - Desactiva la simulación cuando detecta que regresas

#### Automatizaciones Eliminadas:
- ❌ **Presence Simulation - Cleanup Inteligente** - ELIMINADA
  - Ya no existe en el sistema
  - Posiblemente integrada en v2.0 del blueprint o eliminada manualmente

#### Estado Actual (Última Reinicialización):
```yaml
Simulación activa: OFF
Loops completados: 0 de 10  (reseteado)
Luces encendidas: 0
Hora de inicio: 2025-12-14 20:19:52  (actualizada)
Estado: Inactiva
Última luz encendida: - (sin historial)
Última luz apagada: - (sin historial)
```

#### Automatizaciones Obsoletas (Unavailable):
⚠️ Las siguientes 7 automatizaciones están en estado **unavailable** y deben eliminarse:

**Monitoreo de Presencia (5):**
- ❌ Presence Sim - Iniciar Monitoring
- ❌ Presence Sim - Detener Monitoring
- ❌ Presence Sim - Monitorear Switches
- ❌ Presence Sim - Actualizar Runtime
- ❌ Presence Sim - Parada de Emergencia

**Duplicadas de Scene Anochecer (2):**
- ❌ Simulación de presencia al activar escena anochecer
- ❌ Presencia - ON al activar scene.anocheser

> **Recomendación:** Eliminar estas 7 automatizaciones obsoletas. El blueprint v1.3 incluye el monitoreo integrado.

### 2. 🌱 Sistema de Riego Inteligente
**Estado:** ⚠️ **Configurado pero Hardware Offline**

Sistema de riego automático con sensores y control de bombas.

#### Hardware Requerido:
- ESP32 (Riego Z1) - ⚠️ **DESCONECTADO**
- Sensor de humedad de suelo
- Sensor ultrasónico de nivel de tanque
- Sensor DHT11 (temperatura y humedad ambiente)
- Sensor de luz
- Sensor de presencia radar
- 2 Bombas de agua (Z1A y Z1B)

#### Estado de Sensores:
Todos los sensores ESPHome están **unavailable**:
- ❌ Humedad del suelo
- ❌ Nivel de tanque
- ❌ Temperatura ambiente
- ❌ Humedad ambiente
- ❌ Luz ambiente
- ❌ Sensor de movimiento

#### Scripts Disponibles:
| Script | Estado | Función |
|--------|--------|---------|
| `riego_manual_5min` | ✅ Listo | Riego manual 5 minutos |
| `riego_manual_10min` | ✅ Listo | Riego manual 10 minutos |
| `detener_todas_bombas` | ✅ Listo | Parada de emergencia |
| `test_bombas_z1` | ✅ Listo | Test de hardware |
| `riego_emergencia_z1` | ✅ Listo | Riego hasta 60% humedad |
| `registrar_riego_z1` | ✅ Listo | Actualizar contador |

#### Automatización:
- **Riego Z1** - ✅ ON (esperando hardware)

#### ⚠️ Acción Requerida:
Para activar el sistema completamente:
1. Conectar y flashear ESP32 con `/esphome/riego_z1.yaml`
2. Verificar conexión de sensores
3. Calibrar sensor de nivel de tanque
4. Probar bombas con `test_bombas_z1`

#### Documentación:
- 📄 [Guía de Instalación](automatizaciones/INSTALACION_PACKAGE_RIEGO.md)
- 📄 [Configuración Completa](automatizaciones/RIEGO_INTELIGENTE.md)
- 📄 [Troubleshooting DHT11](automatizaciones/TROUBLESHOOTING_DHT11.md)
- 📄 [Instalación Rápida](../INSTALACION_RIEGO_RAPIDA.md)

### 3. 🎬 Escenas Automatizadas

#### Escenas Configuradas:
1. **Amanecer** (`scene.amanecer`)
   - ✅ Trigger: 10 min después del amanecer
   - Automatización activa

2. **Anochecer** (`scene.nightfall` / `scene.anochecer`)
   - ✅ Trigger: Al atardecer
   - ✅ Integrada con simulación de presencia
   - Automatización activa

3. **A Dormir** (`scene.nueva_escena`)
   - ✅ Trigger: Comando de voz "Ta mañana"
   - Automatización activa

4. **Bedtime** (`scene.bedtime`)
   - Usada como escena de salida en simulación de presencia
   - Aplicada al regresar a casa

### 4. 📱 Sistema de Notificaciones

#### Servicio Principal:
- **notify.mobile_app_blacky** (iPhone de Nico)

#### Tipos de Notificaciones Activas:
1. **🚨 Alertas de Cámaras (Críticas)**
   - Detección de personas en entrada
   - Con sonido de alarma
   - Imagen incluida
   - Acción: Ver clip en Frigate

2. **🎭 Simulación de Presencia**
   - Inicio automático al atardecer
   - Desactivación al regresar
   - Notificaciones time-sensitive

3. **🌅 Eventos Solares**
   - Atardecer inteligente
   - Verificación de presencia

4. **💧 Sistema de Riego (cuando esté activo)**
   - Inicio de riego
   - Tanque bajo
   - Riego completado

### 5. 🔄 Sincronización Tuya-Sonoff

**Blueprint:** `tuya_sonoff_sync.yaml`

#### Automatización Activa:
- **RelayCamaSwitch**
  - Sincroniza: Tuya `bedroom_3_switch_switch_3` ↔ Sonoff `sonoff_10025ffc47_1`
  - Debounce: 0.3 segundos
  - Estado: ✅ ON

---

## 📂 Configuración de Archivos

### Estructura de Configuración:

```
/config/
├── configuration.yaml      ✅ Configuración principal
├── automations.yaml        ✅ 49 automatizaciones
├── scripts.yaml            ✅ 7 scripts
├── scenes.yaml             ✅ Escenas
├── secrets.yaml            ✅ Credenciales
├── blueprints/
│   └── automation/
│       └── mauitz/
│           ├── pezaustral_presence_simulation.yaml  ✅ v1.3
│           ├── sistema_riego_inteligente.yaml       ✅
│           └── tuya_sonoff_sync.yaml                ✅
├── packages/               ⚠️ VACÍO (no se usa actualmente)
└── themes/
    └── maui_theme.yaml     ✅ Tema personalizado
```

### ⚠️ Diferencias con Repositorio Local:

El repositorio local tiene un **package completo de riego** (`packages/sistema_riego_z1.yaml`) que **NO está instalado** en el HA actual.

**Estado actual en HA:**
- ✅ Scripts de riego en `scripts.yaml`
- ✅ Blueprint de riego instalado
- ✅ Automatización de riego activa (basada en blueprint)
- ❌ Package NO instalado en `/config/packages/`

**Helpers del sistema de riego:**
Los helpers (input_boolean, input_datetime, input_number) están definidos directamente en `configuration.yaml`, no como package.

---

## 🎛️ Helpers Configurados

### Simulación de Presencia:
```yaml
input_boolean:
  - presence_simulation              ✅ Control principal
  - presence_simulation_running      ⚠️ Unavailable

input_number:
  - presence_simulation_loop_counter ✅ 3.0
  - presence_simulation_loop_total   ✅ 10.0
  - presence_simulation_lights_on_count ✅ 0.0

input_datetime:
  - presence_simulation_start_time   ✅ 2025-12-13 21:23:56
  - presence_simulation_last_update  ✅

input_text:
  - presence_simulation_status       ✅ "Detenida"
  - presence_simulation_active_lights ✅ "Ninguna"
  - presence_simulation_last_light_on ✅
  - presence_simulation_last_light_off ✅
```

### Alertas de Cámaras:
```yaml
input_text:
  - camera_alert_active              ✅
  - camera_alert_timestamp           ✅
```

### Optimización de Frigate:
```yaml
input_boolean:
  - frigate_optimization_enabled     ✅ true
  - frigate_night_mode_force_detect  ✅ true

counter:
  - frigate_entrada_activations_today  ✅
  - frigate_exterior_activations_today ✅

timer:
  - frigate_entrada_cooldown         ✅ 2:00
  - frigate_exterior_cooldown        ✅ 2:00
```

### Sensores Template Activos:

#### Simulación de Presencia:
- `sensor.presence_simulation_runtime` - Tiempo activo
- `sensor.presence_simulation_progress` - Loops completados
- `sensor.presence_simulation_active_lights_list` - Lista de luces
- `sensor.presence_simulation_status_summary` - Resumen
- `sensor.presence_simulation_time_remaining` - Tiempo estimado

#### Frigate:
- `sensor.frigate_cpu_saved_percent` - % CPU ahorrado
- `binary_sensor.frigate_alguna_camara_detectando` - Estado detección
- `binary_sensor.frigate_night_mode_active` - Modo nocturno (22:00-06:00)

---

## 🔧 Mantenimiento y Backups

### Sistema de Backups Automáticos:
- **Estado:** ✅ Activo
- **Frecuencia:** Diaria
- **Último backup exitoso:** 2025-12-14 08:25:56
- **Próximo backup:** 2025-12-15 08:10:39

### Backups Recientes:
```
Automatic_backup_2025.11.1_2025-12-14_05.25.tar
Automatic_backup_2025.11.1_2025-12-13_04.50.tar
Automatic_backup_2025.11.1_2025-12-12_05.35.tar
Pre-actualización-Dashboard-Maui_2025-11-14_00.27.tar
```

---

## 📱 Device Tracking

### Dispositivos Rastreados:
- **device_tracker.blacky** (iPhone de Nico)
  - ✅ Usado para automatizaciones de presencia
  - ✅ Trigger de regreso a casa
  - ✅ Cálculo de distancia a zona home

### Zonas Configuradas:
- **zone.home** (Casa)
  - Coordenadas: -34.873557, -55.115418
  - Radio de detección configurado

---

## 🚨 Tareas de Mantenimiento

### 1. 🔧 Limpieza de Automatizaciones Obsoletas
**Prioridad:** MEDIA

**Situación:**
- 36 de 48 automatizaciones en estado "unavailable"
- La mayoría son obsoletas por decisiones de arquitectura

**Automatizaciones a Eliminar:**

#### A. **Frigate** (15 automatizaciones) - Sistema desinstalado
- ✅ **Decisión:** Frigate fue desinstalado intencionalmente
- ✅ **Hardware incompatible**
- 🗑️ **Acción:** Eliminar las 15 automatizaciones

#### B. **Monitoreo de Presencia** (5 automatizaciones) - Obsoletas
- ✅ **Razón:** Blueprint v1.3 integra el monitoreo
- 🗑️ **Acción:** Eliminar:
  - Presence Sim - Iniciar Monitoring
  - Presence Sim - Detener Monitoring
  - Presence Sim - Monitorear Switches
  - Presence Sim - Actualizar Runtime
  - Presence Sim - Parada de Emergencia

#### C. **Escenas Duplicadas** (2 automatizaciones)
- ✅ **Razón:** Ya existe "Atardecer Inteligente"
- 🗑️ **Acción:** Eliminar:
  - Simulación de presencia al activar escena anochecer
  - Presencia - ON al activar scene.anocheser

**Procedimiento de Limpieza:**
```
1. Ir a: Configuración → Automatizaciones y Escenas → Automatizaciones
2. Ordenar por estado o buscar "unavailable"
3. Eliminar las 22 automatizaciones obsoletas listadas arriba
4. Verificar que solo queden las 12 automatizaciones activas
```

**Resultado esperado:**
- Sistema limpio con solo automatizaciones funcionales
- 12 automatizaciones activas (100% operativas)
- 0 automatizaciones unavailable

### 2. ⚠️ ESP32 Riego Z1 Offline
**Prioridad:** Media

**Síntomas:**
- Todas las entidades de riego en estado "unavailable"
- ~20 sensores desconectados
- Scripts listos pero sin hardware
- Automatización "Riego Z1" activa pero esperando hardware

**Solución:**
1. Verificar alimentación del ESP32
2. Revisar conexión WiFi
3. Re-flashear con ESPHome si es necesario
4. Verificar en ESPHome dashboard: Configuración → ESPHome

### 3. ⚠️ Reducción de Entidades (66 menos)
**Prioridad:** Baja (Informativo)

**Cambios detectados:**
- Sensores: 104 → 80 (↓24)
- Binary Sensors: 30 → 16 (↓14)
- Switches: 90 → 82 (↓8)

**Posibles causas:**
- Limpieza de entidades de Frigate
- Eliminación de sensores ESPHome offline
- Limpieza de entidades duplicadas

**Impacto:**
- Positivo si fueron limpiadas intencionalmente
- Verificar si alguna entidad importante fue eliminada por error

### 4. ⚠️ Packages No Utilizados
**Prioridad:** Baja

El directorio `/config/packages/` está vacío pero configurado.

**Recomendación:**
Mover helpers de riego al package `sistema_riego_z1.yaml` para mejor modularización.

---

## 📊 Uso de Recursos

### Integrations Load:
```
Total componentes cargados: 50+
Dominios activos: 33
Entidades totales: 465
```

### Optimizaciones Activas:
- ✅ Frigate con cooldown de 2 minutos entre alertas
- ✅ CPU ahorrado con detección selectiva de cámaras
- ✅ Backups automáticos fuera de horas pico
- ✅ Sensores template eficientes

---

## 🎨 Frontend y Dashboards

### Tema Activo:
- **maui_theme.yaml** - ✅ Instalado

### Tarjetas HACS Instaladas:
```
/www/community/
├── apexcharts-card/           ✅ Gráficos avanzados
├── button-card/               ✅ Botones personalizados
├── lovelace-auto-entities/    ✅ Entidades automáticas
├── card-mod/                  ✅ Modificación de estilos
├── layout-card/               ✅ Layouts personalizados
├── lovelace-mushroom/         ✅ Estilo Mushroom
├── mushroom-better-sliders/   ✅ Sliders mejorados
└── mini-graph-card/           ✅ Gráficos compactos
```

---

## 🔐 Seguridad

### Configuración de Proxy:
```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
    - 127.0.0.0/24
```

### Acceso:
- ✅ Long-lived access tokens configurados
- ✅ Mobile app autenticada
- ✅ Secrets en archivo separado

---

## 📝 Notas de Versión

### Versión HA 2025.11.1
- ✅ Sistema estable
- ✅ Todas las integraciones funcionando
- ✅ Backups automáticos activos
- ⚠️ ESP32 requiere reconexión

### Últimas Actualizaciones:
- **2025-11-14:** Instalación de helpers de Frigate
- **2025-11-14:** Pre-backup antes de actualización de dashboard
- **2025-12-14:** Verificación de estado y documentación

---

## 🔗 Enlaces Rápidos

### URLs Internas:
- **Home Assistant:** http://192.168.1.100:8123
- **Frigate UI:** http://192.168.1.100:5000
- **Frigate API:** http://192.168.1.100:5000/api/

### Repositorio:
- **GitHub:** https://github.com/mauitz/home-assistant-blueprints

### Documentación Local:
- [Blueprints](../blueprints/)
- [Presencia](pezaustral_presence_simulation/)
- [Riego](automatizaciones/)
- [Frigate](frigate/)
- [Cámaras](camaras/)
- [Hardware](hardware/)

---

## ✅ Estado General: OPERATIVO (100% de funcionalidad activa)

| Categoría | Estado | Notas |
|-----------|--------|-------|
| 🏠 Sistema Principal | ✅ Operativo | HA 2025.11.1 estable |
| 🎭 Simulación Presencia | ✅ Operativo | v1.3, 3 automatizaciones activas |
| 🎥 Frigate | 🚫 Desinstalado | Hardware incompatible (decisión intencional) |
| 🌱 Sistema Riego | ⚠️ Hardware Offline | ESP32 desconectado, scripts OK |
| 📱 Notificaciones | ✅ Operativo | Mobile app Blacky activo |
| 🎬 Escenas | ✅ Operativo | 4 escenas automatizadas |
| 🔄 Backups | ✅ Operativo | Diarios, próximo: 15-12-2025 08:03 |
| 📊 Dashboards | ✅ Operativo | Tema Maui, tarjetas HACS |
| 🤖 Automatizaciones | ✅ 12 activas | 36 obsoletas pendientes de eliminar |

### 🔧 Tareas de Mantenimiento Pendientes:

1. **Eliminar 22 automatizaciones obsoletas** (15 Frigate + 7 otras)
2. **Reconectar ESP32 Riego** (20 sensores offline) - Prioridad media
3. **Planificar solución alternativa para detección por IA** (futuro)

### ℹ️ Notas Importantes:

- **Sistema operativo al 100%** de las funcionalidades activas
- Las automatizaciones "unavailable" son obsoletas por decisiones de arquitectura
- No hay problemas críticos, solo limpieza pendiente

---

**Generado automáticamente** mediante análisis de API de Home Assistant
**Fecha:** Domingo 14 de Diciembre, 2025 23:13
**Script:** `utils/analyze_ha.py`
**Última actualización:** Análisis completo con 399 entidades, 48 automatizaciones
