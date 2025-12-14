# 📋 Changelog - PezAustral Presence Simulation

---

## v2.0.0 (2025-11-18) - 🎉 MAJOR UPDATE

### ✨ Nuevas Características

- **🧹 CLEANUP AUTOMÁTICO INTEGRADO**
  - Ya NO requiere automatizaciones adicionales
  - Apaga TODAS las luces al detener la simulación
  - Funciona independientemente de cómo se detenga (manual, error, o fin normal)
  - Se ejecuta ANTES de las escenas de salida

- **🎯 SIMPLICIDAD**
  - Todo en un solo blueprint
  - Sin necesidad de instalar scripts adicionales
  - Configuración más sencilla

### 🔧 Mejoras Técnicas

- **Flujo de detención mejorado:**
  - El cleanup se ejecuta SIEMPRE (no solo al finalizar loops normalmente)
  - Variable `detener_manualmente` para distinguir tipo de detención
  - Escenas de salida se ejecutan DESPUÉS del cleanup

- **Código optimizado:**
  - Eliminadas dependencias de automatizaciones externas
  - Manejo de errores más robusto
  - Logs más descriptivos

### 🗑️ Deprecated

- ❌ `presence_simulation_cleanup_smart.yaml` (automatización externa) - Ya no necesaria
- ❌ `presence_simulation_cleanup.yaml` (automatización externa) - Ya no necesaria
- ❌ Scripts de instalación de cleanup - Ya no necesarios

### 📚 Documentación

- ✅ README actualizado con instrucciones v2.0
- ✅ Changelog consolidado
- ✅ Troubleshooting actualizado

### 🐛 Bugs Corregidos

- ✅ **Error de entity_id en logbook.log** (2025-12-14)
  - Corregido error: `Entity ID ['input_boolean.presence_simulation'] is an invalid entity ID`
  - Removido parámetro `entity_id` de llamadas a `logbook.log`
  - Los logs siguen funcionando normalmente sin asociación a entidad específica

- ✅ **Condiciones de verificación fallando** (2025-12-14)
  - Corregido error: Automatización terminaba inmediatamente sin encender luces
  - Problema: `is_state(automation_control_entity, 'on')` no evaluaba correctamente la variable
  - Solución: Cambiadas condiciones template por condiciones state directas usando `!input`
  - Afecta líneas 250-251, 285-287, y 393-398

### ⚠️ Breaking Changes

Ninguno. Compatible con configuraciones existentes de v1.3.

Solo necesitas:
1. Actualizar al nuevo blueprint v2.0
2. Eliminar automatización de cleanup si la tenías instalada
3. Reiniciar Home Assistant

---

## v1.3.0 (2025-11) - Monitoreo Integrado

### ✨ Nuevas Características

- **📊 MONITOREO INTEGRADO**
  - Actualización automática de helpers
  - Tracking de luces activas en tiempo real
  - Contador de loops automático
  - Estado de ejecución en tiempo real

### 🔧 Mejoras

- Helper `presence_simulation_running` actualizado automáticamente
- Lista de luces activas (`active_lights`) con nombres friendly
- Última luz encendida/apagada registrada
- Contador de luces simultáneas

### 📚 Documentación

- Guía de monitoreo con dashboard completo
- Widget de estado en tiempo real
- Ejemplos de configuración

---

## v1.2.0 (2025-11) - Logging Detallado

### ✨ Nuevas Características

- **📝 LOGGING DETALLADO EN LOGBOOK**
  - Tracking de cada luz que se enciende/apaga
  - Registro de inicio/fin de cada loop
  - Información de configuración al iniciar
  - Logs de escenas de salida

### 🔧 Mejoras

- Mensajes con emojis para fácil identificación
- Entity_id en cada log para filtrado
- Timestamps automáticos

---

## v1.1.0 (2025-11) - Detención Limpia

### ✨ Nuevas Características

- **🛑 SE PUEDE DETENER**
  - Desactivando el input_boolean de control
  - Verificación de estado ANTES de cada acción
  - Se detiene inmediatamente (< 5 segundos)

### 🔧 Mejoras Técnicas

- Modo `single` para evitar múltiples ejecuciones
- Verificación de estado en wait_template
- Stop limpio con mensaje descriptivo
- Variable `loop_interrupted` para tracking

### 🐛 Bugs Corregidos

- ❌ Problema: No se podía detener con `mode: restart`
  - ✅ Solución: Cambiado a `mode: single` + verificaciones continuas

---

## v1.0.0 (2025-11) - Release Inicial

### ✨ Características

- Control de lámparas simultáneas configurab le
- Loops configurables (0-50 o infinito)
- Tiempos aleatorios de encendido/apagado
- Transiciones configurables
- Escenas de salida (normal y emergencia)
- Control por zona y fechas
- Múltiples triggers (tiempo, sol, luz ambiental)

### 📚 Documentación

- README completo
- Troubleshooting
- Ejemplos de configuración

---

## 🔮 Roadmap

### v2.1 (Planeado)

- [ ] Perfiles predefinidos (casual, intensivo, aleatorio extremo)
- [ ] Prioridad de luces (algunas más probables que otras)
- [ ] Integración con calendario (días específicos)
- [ ] Notificaciones opcionales (inicio/fin)

### v2.2 (Considerando)

- [ ] Machine Learning para patrones realistas
- [ ] Integración con detectores de movimiento reales
- [ ] API para control externo
- [ ] Estadísticas de uso

---

## 📝 Notas de Migración

### De v1.3 a v2.0

**Pasos:**

1. **Actualizar blueprint:**
   ```
   Configuración → Automatizaciones → Blueprints
   → Reimportar desde GitHub (URL actualizada a v2.0)
   ```

2. **Eliminar automatización de cleanup (si la tienes):**
   ```
   Configuración → Automatizaciones
   → Buscar: "Presence Simulation - Cleanup"
   → Eliminar
   ```

3. **Verificar configuración:**
   ```bash
   ./utils/verify_presence_simulation.sh
   ```

4. **Probar:**
   - Activar simulación
   - Esperar luces encendidas
   - Desactivar
   - Verificar que TODO se apaga automáticamente

**NO necesitas:**
- ❌ Cambiar helpers
- ❌ Cambiar dashboard
- ❌ Reconfigurar la automatización
- ❌ Reinstalar scripts

---

## 🆘 Soporte

Si tienes problemas después de actualizar:

1. Ver [Troubleshooting](TROUBLESHOOTING.md)
2. Verificar logs: `Configuración → Registros → Logbook`
3. Abrir issue en GitHub con detalles

---

**Mantenedor:** [@mauitz](https://github.com/mauitz)
**Licencia:** MIT
**Última actualización:** 2025-11-18
