# 📊 Sistema de Monitoring - Presence Simulation

Panel de control en tiempo real para monitorear tu simulación de presencia.

---

## 🎯 ¿Qué es?

Un sistema completo de helpers, automatizaciones y tarjetas de dashboard que te permite:

- ✅ Ver estado actual (activa/inactiva)
- ✅ Tiempo de ejecución en tiempo real
- ✅ Progreso del loop con barra visual
- ✅ Loops completados vs total
- ✅ Luces activas (nombres y cantidad)
- ✅ Última luz encendida/apagada
- ✅ Tiempo restante estimado
- ✅ Controles de inicio/detención

---

## 📦 Componentes

### 1. Helpers (`presence_simulation_helpers.yaml`)
Define 10 helpers + 4 sensores template para tracking de estado.

### 2. Automatizaciones (`presence_simulation_monitoring.yaml`)
5 automatizaciones auxiliares que actualizan los helpers automáticamente.

### 3. Tarjeta Dashboard (`dashboard_card.yaml`)
3 versiones de tarjeta (completa, simplificada, compacta).

---

## ⚡ Instalación Rápida (15 minutos)

### Paso 1: Helpers
```yaml
# Agrega a configuration.yaml:
# Contenido de: /examples/presence_simulation_helpers.yaml
# Reinicia Home Assistant
```

### Paso 2: Automatizaciones
```bash
# Copia a:
/config/packages/presence_simulation_monitoring.yaml
# ⚠️ Modifica los entity_id de tus switches
# Reinicia Home Assistant
```

### Paso 3: Dashboard
```bash
# Dashboard → Editar → Agregar Tarjeta → YAML
# Pega contenido de: /examples/dashboard_card.yaml (OPCIÓN 2)
# Guarda
```

### Paso 4: Configurar
```bash
# Helpers → presence_simulation_loop_total
# Establece: 10 (o tu loop_count configurado)
```

---

## 📺 Vista del Dashboard

```
╔═══════════════════════════════════════════════════════╗
║        🏠 SIMULACIÓN DE PRESENCIA                     ║
╠═══════════════════════════════════════════════════════╣
║                                                        ║
║  Control: [● ON]      Estado: [●] En ejecución       ║
║                                                        ║
║  📋 Estado: En ejecución                              ║
║  ⏱️ Tiempo Activo: 01:23:45                          ║
║  📈 Progreso: [████████░░░░] 60%                     ║
║  🔄 Loops: 6 de 10 completados                       ║
║  ⏳ Tiempo Restante: ~1h 40m                         ║
║                                                        ║
║  💡 Luces Activas: 2 de 2 (máximo)                   ║
║  📝 Dispositivos: switch_1, switch_2                  ║
║  ⬆️ Última Encendida: switch_3                       ║
║  ⬇️ Última Apagada: switch_4                         ║
║                                                        ║
║  [▶ INICIAR]              [⬛ DETENER]                ║
║                                                        ║
╚═══════════════════════════════════════════════════════╝
```

---

## 🎮 Uso

### Iniciar Simulación
```bash
# Desde dashboard:
→ Click botón INICIAR

# O manualmente:
→ Activa input_boolean.presence_simulation
```

### Detener Simulación
```bash
# Desde dashboard:
→ Click botón DETENER

# Resultado:
✅ Se detiene en < 5 segundos
✅ Apaga todas las luces
✅ Actualiza estado
```

### Monitorear
El dashboard se actualiza automáticamente:
- **Cada segundo**: Cambios de switches
- **Cada minuto**: Tiempo transcurrido
- **Inmediato**: Progreso de loops

---

## 📁 Archivos del Sistema

```
examples/
├── presence_simulation_helpers.yaml      # Helpers + sensores
├── presence_simulation_monitoring.yaml   # Automatizaciones
└── dashboard_card.yaml                   # Tarjetas UI
```

---

## ⚙️ Configuración Avanzada

### Personalizar Colores

En `dashboard_card.yaml`:
```yaml
color: |
  {% set progress = states('sensor.progress') | int %}
  {% if progress < 30 %}
    rgb(76, 175, 80)   # Verde
  {% elif progress < 70 %}
    rgb(255, 193, 7)   # Amarillo
  {% else %}
    rgb(244, 67, 54)   # Rojo
  {% endif %}
```

### Agregar Notificaciones

En `presence_simulation_monitoring.yaml`:
```yaml
# Al final de "Monitorear Switches":
- service: notify.mobile_app_tu_telefono
  data:
    title: "💡 Luz Encendida"
    message: "{{ trigger.to_state.attributes.friendly_name }}"
```

### Agregar Gráficas Históricas

Nueva tarjeta:
```yaml
type: history-graph
title: "📈 Historial"
entities:
  - input_number.presence_simulation_lights_on_count
  - input_number.presence_simulation_loop_counter
hours_to_show: 24
```

---

## 🐛 Troubleshooting

### Helpers no aparecen
```bash
1. Verifica configuration.yaml (sintaxis YAML)
2. Reinicia Home Assistant
3. Configuración → Helpers → Busca "presence_simulation"
```

### Dashboard muestra "unavailable"
```bash
# Verifica que todos los helpers existen:
Herramientas de Desarrollo → Estados
→ Busca: presence_simulation
→ Deben aparecer ~14 entidades
```

### Contador de loops no avanza
```bash
# Agrega a tu automatización principal:
- service: input_number.set_value
  target:
    entity_id: input_number.presence_simulation_loop_counter
  data:
    value: >
      {{ states('input_number.presence_simulation_loop_counter') | int + 1 }}
```

### Barra de progreso no aparece
```bash
# Opción 1: Instala bar-card desde HACS
# Opción 2: Usa dashboard_card.yaml OPCIÓN 2 (sin custom cards)
```

---

## 📚 Documentación Completa

- [Instalación Detallada](../pezaustral_presence_simulation/README.md)
- [Troubleshooting](../pezaustral_presence_simulation/TROUBLESHOOTING.md)
- [Ejemplos](../../examples/)

---

## 💡 Tips

1. **Prueba con tiempos cortos primero** (1-2 min) para verificar
2. **Usa loop_total = 99 para infinito** en el display
3. **Custom cards mejoran la UI** pero no son obligatorios
4. **Notificaciones móviles** son muy útiles para monitoreo remoto

---

*Sistema de Monitoring - PezAustral Presence Simulation v1.1*  
*Noviembre 2025*

