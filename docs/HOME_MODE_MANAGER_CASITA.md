# Home Mode Manager - Instalación en Casita

**Servidor:** casita.local
**Usuario:** maui
**Fecha Instalación:** Enero 2026

---

## 🎯 Qué es y Por Qué lo Necesitamos

Home Mode Manager es el sistema que **le dice a tu casa en qué situación estás** para que todas las automatizaciones actúen de forma inteligente.

### Problema Actual en Casita

Ahora mismo tienes:
- ✅ Escenas: "Nueva escena" (dormir), "Anochecer", "Amanecer", "Office"
- ✅ Comando de voz "Ta mañana" que activa escena de dormir
- ❌ Pero las escenas **NO son estados persistentes**
- ❌ No puedes preguntar "¿en qué modo estoy?"
- ❌ Las automatizaciones no saben el contexto

###

 Solución con Home Mode Manager

Ahora tendrás:
- ✅ **5 modos** rastreados: normal, away, sleeping, night, guest
- ✅ **Las escenas existentes se sincronizan** con los modos
- ✅ **Control por voz** ampliado (ya funciona con tu "Ta mañana")
- ✅ **SmartNodes ajustan brillo** según el modo (80% día, 40% noche, 10% durmiendo)
- ✅ **Dashboard visual** para ver y cambiar el modo

---

## 📦 Instalación Paso a Paso

### Paso 1: Conectarse al Servidor

```bash
ssh maui@casita.local
# O desde tu máquina local si tienes acceso a los archivos
```

### Paso 2: Copiar el Package

```bash
# Desde el repositorio
cd /Users/maui/_maui/domotica/home-assistant-blueprints

# Copiar al servidor (si es remoto)
scp packages/home_mode_manager.yaml maui@casita.local:/config/packages/

# O copiar localmente si ya estás en el servidor
cp packages/home_mode_manager.yaml /config/packages/
```

### Paso 3: Verificar configuration.yaml

Tu `configuration.yaml` ya tiene packages habilitado (línea 22):

```yaml
homeassistant:
  packages: !include_dir_named packages  # ✅ Ya configurado
```

### Paso 4: Reiniciar Home Assistant

```
1. Abrir el navegador: http://casita.local:8123
2. Settings → System → Restart
3. Esperar ~1 minuto
```

### Paso 5: Verificar Instalación

Ir a: `Developer Tools → States` y buscar:

```
input_select.home_mode
```

Debe mostrar: `normal` (o uno de los 5 modos)

---

## ⚙️ Configuración Específica para Casita

### 1. Configurar Sensores de Presencia

Editar `/config/packages/home_mode_manager.yaml` línea ~148:

```yaml
- name: "HMM Anyone Home"
  state: >
    {# 🔧 SENSORES DE CASITA #}

    {# Switches que indican actividad #}
    {% set bedroom3_active = is_state('switch.bedroom_3_switch_switch_3', 'on') %}
    {% set hall_active = is_state('switch.4gang_switch_2_switch_1', 'on') or
                         is_state('switch.4gang_switch_2_switch_2', 'on') %}

    {# Si tienes SmartNodes, agrégalos aquí: #}
    {# {% set smartnode1 = is_state('binary_sensor.smartnode1_presence', 'on') %} #}

    {# Presencia = algún switch encendido o movimiento #}
    {{ bedroom3_active or hall_active }}
```

**Nota:** Ajusta los `entity_id` según tus dispositivos reales. Puedes ver todos tus dispositivos en:
```
Developer Tools → States
```

### 2. Ajustar Horarios de Dormir

Por defecto: **23:30 - 07:00**

Para cambiarlo:
1. Ir al dashboard (paso 6)
2. Ajustar los sliders de configuración
3. O editar valores iniciales en el package:

```yaml
input_number:
  hmm_sleep_hour_start:
    initial: 22  # Cambiar de 23 a 22 (dormir a las 22:00)
```

### 3. Sincronizar con Escenas Existentes

El package ya está configurado para tus escenas:

| Modo | Escena que Activa |
|------|------------------|
| sleeping | `scene.nueva_escena` (tu escena "A dormir") |
| night | `scene.anocheser` (tu escena "Anochecer") |
| normal (amanecer) | `scene.amanecer` (tu escena "Amanecer") |

Para activar la sincronización:
1. Ir al dashboard
2. Activar el toggle **"Enable Scene Synchronization"**

### 4. Comandos de Voz

Ya configurados para ti:

| Comando | Modo |
|---------|------|
| **"Ta mañana"** | sleeping (mantiene tu comando actual) |
| **"Buenos días"** | normal |
| **"Nos vamos"** | away |

¿Quieres agregar más? Edita el package y añade:

```yaml
automation:
  - id: hmm_voice_custom
    alias: "[HMM] Voice - Tu Comando"
    trigger:
      - platform: conversation
        command: "A comer"  # Tu frase
    action:
      - service: script.hmm_force_mode
        data:
          mode: normal
```

---

## 📱 Dashboard para Casita

### Opción A: Widget Completo (Recomendado)

Agregar al dashboard principal (`/config/dashboards/maui_dashboard.yaml` o desde UI):

```yaml
type: vertical-stack
cards:
  # Estado actual
  - type: glance
    title: 🏠 Modo de Casa
    entities:
      - entity: input_select.home_mode
        name: Modo Actual
      - entity: binary_sensor.hmm_anyone_home
        name: Hay Alguien
      - entity: input_boolean.hmm_night_detected
        name: Es de Noche

  # Información detallada
  - type: entities
    entities:
      - entity: sensor.hmm_mode_description
        name: Descripción
      - entity: sensor.hmm_time_in_mode
        name: Tiempo en Modo
      - entity: sensor.hmm_sleep_time_formatted
        name: Horario Dormir

  # Botones de acción rápida
  - type: horizontal-stack
    cards:
      - type: button
        name: Normal
        icon: mdi:home
        tap_action:
          action: call-service
          service: script.hmm_force_mode
          data:
            mode: normal

      - type: button
        name: 😴 Dormir
        tap_action:
          action: call-service
          service: script.hmm_force_mode
          data:
            mode: sleeping

      - type: button
        name: 🏃 Salir
        tap_action:
          action: call-service
          service: script.hmm_force_mode
          data:
            mode: away

  # Configuración
  - type: entities
    title: ⚙️ Controles
    entities:
      - entity: input_boolean.hmm_manual_control
        name: Control Manual (2h)
      - entity: input_boolean.hmm_enable_scene_sync
        name: Sincronizar Escenas
      - entity: input_boolean.hmm_enable_voice_control
        name: Control por Voz

  # Horarios configurables
  - type: entities
    title: 🕐 Horarios
    entities:
      - entity: input_number.hmm_sleep_hour_start
        name: Hora Dormir
      - entity: input_number.hmm_sleep_minute_start
        name: Minuto Dormir
      - entity: input_number.hmm_wake_hour
        name: Hora Despertar
      - entity: input_number.hmm_wake_minute
        name: Minuto Despertar
      - entity: input_number.hmm_away_timeout
        name: Timeout Ausencia (min)
```

### Opción B: Widget Minimalista

Si prefieres algo más simple:

```yaml
type: entities
title: 🏠 Modo de Casa
entities:
  - entity: input_select.home_mode
    name: Modo Actual
  - entity: sensor.hmm_mode_description
    name: Estado
  - type: buttons
    entities:
      - entity: script.hmm_force_mode
        name: Normal
        tap_action:
          action: call-service
          service: script.hmm_force_mode
          data:
            mode: normal
      - entity: script.hmm_force_mode
        name: Dormir
        tap_action:
          action: call-service
          service: script.hmm_force_mode
          data:
            mode: sleeping
```

---

## 🔗 Integración con tus Dispositivos

### Switches Tuya/Sonoff

Tus switches actuales:

```
Bedroom 3:
- switch.bedroom_3_switch_switch_1
- switch.bedroom_3_switch_switch_2
- switch.bedroom_3_switch_switch_3

Hall (4 Gang):
- switch.4gang_switch_2_switch_1
- switch.4gang_switch_2_switch_2
- switch.4gang_switch_2_switch_3
- switch.4gang_switch_2_switch_4

Front Door:
- switch.4gang_switch_switch_1 al 4
- switch.2gang_switch_switch_1 al 2

Otros:
- switch.wifi_din_rail_switch_switch
- light.guirnalda_dimer_light
```

### Automatización Inteligente para Guirnalda

Tu luz `light.guirnalda_dimer_light` puede ajustarse según el modo:

```yaml
automation:
  - alias: "Guirnalda - Brillo por Modo"
    trigger:
      - platform: state
        entity_id: input_select.home_mode
    action:
      - choose:
          # Modo Normal: Brillo alto
          - conditions:
              - condition: template
                value_template: "{{ trigger.to_state.state == 'normal' }}"
            sequence:
              - service: light.turn_on
                target:
                  entity_id: light.guirnalda_dimer_light
                data:
                  brightness_pct: 80

          # Modo Noche: Brillo medio
          - conditions:
              - condition: template
                value_template: "{{ trigger.to_state.state == 'night' }}"
            sequence:
              - service: light.turn_on
                target:
                  entity_id: light.guirnalda_dimer_light
                data:
                  brightness_pct: 40

          # Modo Durmiendo: Brillo bajo
          - conditions:
              - condition: template
                value_template: "{{ trigger.to_state.state == 'sleeping' }}"
            sequence:
              - service: light.turn_on
                target:
                  entity_id: light.guirnalda_dimer_light
                data:
                  brightness_pct: 10

          # Modo Away: Apagar
          - conditions:
              - condition: template
                value_template: "{{ trigger.to_state.state == 'away' }}"
            sequence:
              - service: light.turn_off
                target:
                  entity_id: light.guirnalda_dimer_light
```

### Integración con Blueprint Tuya-Sonoff Sync

Tu automatización existente (`RelayCamaSwitch`) sigue funcionando normal. El modo no la afecta.

---

## 🎤 Comandos de Voz en Casita

### Comandos Ya Configurados

Di estos comandos a tu asistente de voz:

1. **"Ta mañana"** → Activa modo sleeping + escena "Nueva escena"
2. **"Buenos días"** → Activa modo normal + escena "Amanecer"
3. **"Nos vamos"** → Activa modo away (apaga todo)

### Probar Comandos

Desde el navegador:
```
Settings → Voice Assistants → Assist → Escribir comando
```

O desde la app móvil de Home Assistant.

---

## 🧪 Pruebas Iniciales

### Test 1: Verificar Modos

```bash
# En Developer Tools → Services

service: script.hmm_force_mode
data:
  mode: sleeping

# Luego revisar:
Developer Tools → States → input_select.home_mode
# Debe mostrar: sleeping
```

### Test 2: Probar Comando de Voz

Decir: **"Ta mañana"**

Verificar:
```
1. input_select.home_mode → sleeping
2. scene.nueva_escena → applied (switches apagados)
3. Logbook muestra: "Mode changed MANUALLY to: sleeping"
```

### Test 3: Transición Automática Noche

```bash
# Simular atardecer (si es de día)
Developer Tools → Services

service: input_boolean.turn_on
target:
  entity_id: input_boolean.hmm_night_detected

# Esperar 5 segundos, luego verificar:
input_select.home_mode → night
```

### Test 4: Dashboard Widget

1. Agregar el widget al dashboard
2. Hacer click en botón "😴 Dormir"
3. Verificar que el modo cambia
4. Verificar que el toggle "Manual Control" se activa
5. Esperar 2 horas (o cambiar manualmente) para que se desactive

---

## 📊 Monitoreo y Logs

### Ver Cambios de Modo

```
Settings → System → Logs

Filtrar por: "Home Mode Manager"
```

Verás mensajes como:
```
🌙 NIGHT mode activated - Sunset with presence
😴 SLEEPING mode activated
🏠 AWAY mode - No presence detected
```

### Ver Estado Actual

```
Developer Tools → States

Buscar:
- input_select.home_mode
- sensor.hmm_mode_description
- binary_sensor.hmm_anyone_home
```

### Historial de Cambios

```
Logbook → Buscar "home_mode"
```

Muestra todos los cambios de modo con timestamps.

---

## 🔧 Ajustes Recomendados para Casita

### Timeout de Casa Vacía

Por defecto: 15 minutos sin presencia → modo away

Si sales a menudo y vuelves rápido, aumentar a 30 minutos:

```
Dashboard → HMM Widget → Away Timeout → 30
```

### Horario de Dormir

Ajustar según tu rutina real:

```
Dashboard → HMM Widget → Sleep Time Start → 22:30
Dashboard → HMM Widget → Wake Time → 07:30
```

### Activar Sincronización de Escenas

```
Dashboard → HMM Widget → Enable Scene Synchronization → ON
```

Esto hará que:
- Al cambiar a sleeping → aplica "Nueva escena"
- Al cambiar a night → aplica "Anochecer"
- Al cambiar a normal (amanecer) → aplica "Amanecer"

---

## ⚠️ Problemas Comunes

### Problema 1: El modo no cambia automáticamente

**Causa:** Control manual activado

**Solución:**
```
Dashboard → Manual Control (2h) → OFF
```

O esperar 2 horas para que se desactive solo.

### Problema 2: "Anyone Home" siempre en OFF

**Causa:** No configuraste los sensores de presencia

**Solución:**
Editar `/config/packages/home_mode_manager.yaml` línea 148 y agregar tus switches/sensores reales.

### Problema 3: Las escenas no se aplican

**Causa:** Scene Sync desactivado

**Solución:**
```
Dashboard → Enable Scene Synchronization → ON
```

### Problema 4: Comando "Ta mañana" no funciona

**Causa:** Voice Control desactivado o no tienes Assist configurado

**Solución:**
1. Activar: Dashboard → Enable Voice Control → ON
2. Configurar Assist en HA si no está configurado

---

## 🎯 Próximos Pasos

### Semana 1: Monitoreo

- ✅ Observar cambios automáticos de modo
- ✅ Ajustar horarios según tu rutina
- ✅ Probar comandos de voz
- ✅ Verificar que las escenas se aplican correctamente

### Semana 2: Expansión

- 📱 Agregar más comandos de voz personalizados
- 💡 Configurar SmartNodes con el blueprint v2
- 🔔 Crear automatizaciones basadas en modos
- ⚙️ Afinar timeouts y configuraciones

### Semana 3: Optimización

- 🎨 Personalizar el dashboard
- 🏠 Agregar más sensores de presencia
- 🔊 Configurar notificaciones inteligentes según modo
- 🌡️ Integrar control de clima por modo

---

## 📞 Soporte

Si algo no funciona:

1. **Revisar logs:** Settings → System → Logs
2. **Verificar estados:** Developer Tools → States
3. **Consultar esta guía:** Todos los pasos están documentados
4. **Revisar el package:** `/config/packages/home_mode_manager.yaml`

---

## 📝 Resumen de Archivos en Casita

```
/config/
├── configuration.yaml  (ya configurado con packages)
├── packages/
│   └── home_mode_manager.yaml  (NUEVO - acabas de instalar)
├── scenes.yaml  (tus escenas existentes)
├── automations.yaml  (tus automatizaciones existentes)
└── dashboards/
    └── maui_dashboard.yaml  (agregar widget aquí)
```

---

## ✅ Checklist de Instalación

- [ ] Package copiado a `/config/packages/`
- [ ] Home Assistant reiniciado
- [ ] `input_select.home_mode` existe en States
- [ ] Sensores de presencia configurados
- [ ] Dashboard widget agregado
- [ ] Scene Sync activado
- [ ] Voice Control activado
- [ ] Horarios ajustados a tu rutina
- [ ] Comando "Ta mañana" probado
- [ ] Transición automática a noche probada
- [ ] Logs revisados (sin errores)

---

**¡Listo! Tu casa ahora es inteligente y sabe en qué situación estás en todo momento.** 🎉

---

**Fecha de instalación:** _______________
**Instalado por:** maui
**Servidor:** casita.local

