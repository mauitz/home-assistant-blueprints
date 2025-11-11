# Changelog - PezAustral Presence Simulation

Todos los cambios notables en este blueprint serán documentados aquí.

---

## [1.1] - 2025-11-11

### 🚨 CRÍTICO - Bug Fix

#### Fixed
- **[CRÍTICO] Automatización no se podía detener** (#1)
  - Cambiado `mode: restart` a `mode: single`
  - Agregada verificación continua del estado de control durante ejecución
  - Implementado `wait_template` en delays para detención inmediata
  - La automatización ahora se detiene en menos de 5 segundos al desactivar

#### Added
- **Escena de parada de emergencia**
  - Nueva opción: `emergency_stop_scene`
  - Se activa automáticamente cuando se detiene manualmente
  - Permite apagar todos los switches inmediatamente

- **Verificación continua de estado**
  - El blueprint ahora verifica el estado del `automation_control_entity` antes de cada acción
  - Verifica durante todos los delays
  - Verifica entre loops

#### Changed
- **Loop mejorado**
  - Cambiado de `repeat.count` a `repeat.while` con condiciones
  - Permite salida limpia del loop
  - Mejor control del flujo de ejecución

#### Technical Details
- Mode cambiado de `restart` → `single`
- Agregadas condiciones `while` en el repeat principal
- Agregado `wait_template` con timeout en cada delay de luz
- Agregada acción `stop` cuando se detecta desactivación
- Documentación actualizada con fix urgente

### Migration Notes
**Si vienes de v1.0:**
1. Actualiza el blueprint desde el repositorio
2. Recarga blueprints en Home Assistant
3. Crea escena de parada de emergencia (opcional pero recomendado)
4. Actualiza tu automatización para incluir la escena
5. Prueba que se detiene correctamente

**Compatibilidad:** Todas las configuraciones de v1.0 son compatibles con v1.1

---

## [1.0] - 2025-11-08

### Initial Release

#### Added
- **Control de lámparas simultáneas**
  - Parámetro `max_lights_on` para limitar luces encendidas simultáneamente
  - Sistema automático de apagado de luces antiguas
  - Tracking interno de luces activas

- **Loop configurable**
  - 0-50 repeticiones o infinito
  - Delays aleatorios entre loops (min/max)
  - Escena de salida configurable

- **Múltiples triggers**
  - Tiempo específico
  - Elevación solar
  - Nivel de luz ambiental
  - Estado de entidad (ON/OFF)

- **Control avanzado**
  - Control por zona geográfica
  - Control por personas específicas
  - Control por rango de fechas
  - Días de la semana configurables

- **Configuración de luces**
  - Brillo configurable (solo luces)
  - Temperatura de color (solo luces)
  - Tiempo de transición ON/OFF
  - Orden de encendido: secuencial, reverso, aleatorio, simultáneo
  - Delays aleatorios entre encendidos

- **Configuración de duración**
  - Método: tiempo min/max o rango horario
  - Tiempo mínimo/máximo ON configurable
  - Transición de apagado configurable

- **Documentación completa**
  - Guía de instalación
  - Manual de configuración (50+ páginas)
  - Ejemplos de uso
  - FAQ y troubleshooting

#### Known Issues
- ⚠️ **[CRÍTICO]** Automatización no se puede detener una vez iniciada (Fixed en v1.1)
- ⚠️ Mode `restart` causa problemas de control (Fixed en v1.1)

---

## [Pre-Release] - 2025-11-07

### Development
- Diseño inicial basado en Holiday & Away Lighting de Blackshome
- Implementación de características únicas
- Testing inicial

---

## Notas de Versiones

### Semantic Versioning
Este proyecto sigue [Semantic Versioning](https://semver.org/):
- **MAJOR**: Cambios incompatibles en la API/configuración
- **MINOR**: Nuevas características compatibles hacia atrás
- **PATCH**: Bug fixes compatibles hacia atrás

### Política de Soporte
- **Última versión**: Soporte completo y actualizaciones activas
- **Versiones anteriores**: Solo bug fixes críticos de seguridad
- **Deprecated**: Sin soporte, migración recomendada

### Links
- [Repositorio GitHub](https://github.com/TU_USUARIO/home-assistant-blueprints)
- [Reportar Issues](https://github.com/TU_USUARIO/home-assistant-blueprints/issues)
- [Documentación](README.md)

---

*Changelog actualizado: 2025-11-11*

