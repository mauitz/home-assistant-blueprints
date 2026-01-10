# 🏠 PezAustral Presence Simulation

## 📌 Estado en HA Pezaustral

**Versión instalada en HA (192.168.1.100:8123):** v2.1 (actualizar a v2.2 recomendado)
**Versión en repositorio local:** v2.2 ✅ **NUEVAS FUNCIONES UX**
**Blueprint para Home Assistant**

Simulación avanzada de presencia con control de lámparas simultáneas, loops configurables, detención inmediata, función PAUSE/RESUME y notificaciones configurables.

---

## 🆕 Diferencias de Versiones

### Instalada en HA: v2.1 ✅ **FUNCIONANDO CORRECTAMENTE**
- ✅ Cleanup automático integrado
- ✅ Monitoreo integrado
- ✅ Logging detallado
- ✅ Múltiples luces simultáneas (bug v2.0 corregido)
- ✅ Parámetro max_lights_on funcional
- ✅ Rotación dinámica de luces
- ✅ Delay configurable entre luces

### Disponible en Repo: v2.2 🎉 **NUEVAS FUNCIONES UX**
- Todo lo de v2.1 +
- ✨ **NUEVO:** Función PAUSE/RESUME (pausar sin apagar luces)
- ✨ **NUEVO:** Sistema de notificaciones configurable
- ✨ **NUEVO:** Vista dedicada de dashboard con icono propio
- ✨ **MEJORADO:** Control mejorado con botones dedicados (START/PAUSE/RESUME/STOP)
- ✨ **MEJORADO:** Badge animado de estado con indicadores visuales
- ✨ **MEJORADO:** UX general significativamente mejorada

> **💡 ACTUALIZACIÓN RECOMENDADA:** v2.2 trae mejoras significativas de experiencia de usuario y nuevas funcionalidades solicitadas por la comunidad.

---

## ✨ Características Principales

- **⏸️ PAUSE/RESUME (v2.2)**: Pausar simulación manteniendo luces encendidas
- **📱 Notificaciones (v2.2)**: Alertas configurables (inicio/stop/completado)
- **🎮 Control Mejorado (v2.2)**: Botones dedicados START/PAUSE/RESUME/STOP
- **📊 Vista Dedicada (v2.2)**: Dashboard completo con badge animado y controles avanzados
- **Control de lámparas simultáneas**: Limita cuántas pueden estar encendidas al mismo tiempo
- **Apagado inteligente**: Sistema de apagado automático en paralelo
- **Loop configurable**: 0-99 repeticiones o infinito
- **Detención inmediata**: Se detiene en menos de 2 segundos
- **Escena de salida**: Configurable para fin normal o parada de emergencia
- **Múltiples triggers**: Tiempo, sol, luz ambiental, entidades
- **Control por zona**: Activa solo cuando no hay personas
- **Control por fechas**: Define períodos específicos

---

## 📊 Estado Actual en Pezaustral

### Automatizaciones Activas:
1. **Presence Simulation** - ✅ ON (v1.3)
   - 6 switches configurados
   - Máximo 2 luces simultáneas
   - 10 loops configurados
   - Monitoreo integrado habilitado

2. **Presence Simulation - Cleanup Inteligente** - ✅ ON
   - Apaga todas las luces al detener
   - Actualiza contadores

3. **Atardecer Inteligente** - ✅ ON
   - Inicia simulación si no estás en casa

4. **Regreso a Casa - Desactivar Simulación** - ✅ ON
   - Desactiva al detectar llegada

### Automatizaciones con Problemas:
⚠️ 5 automatizaciones de monitoreo en estado "unavailable" (obsoletas con v1.3)

---

## 🆕 Evolución de Versiones

### v1.3 (Instalada) ✅
- ✅ Monitoreo integrado en el blueprint
- ✅ Actualización automática de helpers
- ✅ Logging detallado
- ⚠️ Requiere automatización de cleanup separada

### v2.0 (Disponible en repo) 🎯
- Todo lo de v1.3 +
- ✅ Cleanup integrado (sin automatización extra)
- ✅ Un solo blueprint hace todo

---

## 📦 Instalación

### Opción 1: Desde GitHub (Recomendado)

```
1. En Home Assistant:
   - Configuración → Automatizaciones y Escenas → Blueprints
   - Click en "Importar Blueprint"
   - URL: https://github.com/TU_USUARIO/home-assistant-blueprints/blob/main/blueprints/pezaustral_presence_simulation.yaml
   - Importar

2. Crear automatización:
   - Nueva Automatización → Desde Blueprint
   - Selecciona "PezAustral Presence Simulation"
   - Configura según necesites
```

### Opción 2: Manual

```bash
# Copia a tu Home Assistant:
/config/blueprints/automation/pezaustral/pezaustral_presence_simulation.yaml
```

---

## ⚡ Inicio Rápido

### Configuración Mínima

```yaml
- Luces: [Selecciona tus switches/luces]
- Máximo simultáneas: 2
- Trigger: input_boolean.presence_simulation (ON)
- Tiempo ON: 15-45 minutos
- Loop: Habilitado, 5 repeticiones
```

### Prueba Rápida v2.1 (3-4 minutos)

```yaml
- Luces: [4-6 switches cualquiera]
- Máximo simultáneas: 2
- time_on_min: 2 minutos
- time_on_max: 3 minutos
- delay_between_lights_min: 5 segundos
- delay_between_lights_max: 10 segundos
- Loop: 1 repetición
- Activar y observar
  → Deberías ver 2 luces encendidas simultáneamente
```

---

## 📚 Documentación

- **[Guía Completa](GUIA_COMPLETA.md)**: Todas las opciones explicadas
- **[Ejemplos](../../examples/)**: Configuraciones listas para usar
- **[Troubleshooting](TROUBLESHOOTING.md)**: Solución de problemas
- **[Changelog](CHANGELOG.md)**: Historial de versiones

---

## 🎯 Ejemplos Rápidos

### Salida Nocturna (3 horas)

```yaml
Trigger: input_boolean.presence_simulation → ON
Luces: [sala, cocina, dormitorio]
Max simultáneas: 2
Tiempo ON: 15-30 min
Loop: 5 repeticiones
Escena salida: scene.apagar_todo
```

### Vacaciones (Infinito)

```yaml
Trigger: Elevación solar = -5
Luces: [Todas las de la casa]
Max simultáneas: 3
Tiempo ON: 20-45 min
Loop: Infinito
Control: Solo si nadie en zone.home
```

### Fin de Semana

```yaml
Trigger: Tiempo = 10:00
Luces: [Principales]
Max simultáneas: 2
Días: Sábado, Domingo
Loop: 8 repeticiones
```

---

## 🆚 Comparación con Versiones Anteriores

| Característica | v1.3 | v2.0 (buggy) | v2.1 (fixed) | v2.2 (UX) |
|----------------|------|--------------|--------------|-----------|
| Detención | ✅ < 5 seg | ✅ < 5 seg | ✅ < 5 seg | ✅ < 2 seg |
| Cleanup automático | ❌ Externa | ✅ Integrado | ✅ Integrado | ✅ Integrado |
| Luces simultáneas | ✅ Funciona | ❌ **ROTO** | ✅ **CORREGIDO** | ✅ Funcionando |
| max_lights_on | ✅ Operativo | ❌ Ignorado | ✅ Operativo | ✅ Operativo |
| Rotación de luces | ✅ Sí | ❌ No | ✅ Sí | ✅ Sí |
| Delay entre luces | ⚠️ Fijo | ❌ N/A | ✅ Configurable | ✅ Configurable |
| Monitoreo | ✅ Sí | ✅ Sí | ✅ Mejorado | ✅ Mejorado |
| **PAUSE/RESUME** | ❌ No | ❌ No | ❌ No | ✅ **NUEVO** |
| **Notificaciones** | ❌ No | ❌ No | ❌ No | ✅ **NUEVO** |
| **Vista dedicada** | ❌ No | ❌ No | ❌ No | ✅ **NUEVO** |
| **Badge animado** | ❌ No | ❌ No | ❌ No | ✅ **NUEVO** |
| **Botones dedicados** | ❌ No | ❌ No | ❌ No | ✅ **NUEVO** |

---

## 🤝 Basado En

Este blueprint está basado en [Holiday & Away Lighting de Blackshome](https://gist.github.com/Blackshome/0a34870755762bcb9fab159d5b94fd25), con mejoras significativas:

- Control de lámparas simultáneas
- Sistema de detención mejorado
- Loop más flexible
- Escena de parada de emergencia
- Verificación continua de estado

---

## 📄 Licencia

MIT License - Libre para uso personal y comercial.

---

## 🐛 Reportar Problemas

Si encuentras algún bug o tienes sugerencias:
- GitHub Issues: [Enlace a tu repo]
- Documentación de troubleshooting: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

*PezAustral Presence Simulation v2.2 - Enero 2026*

