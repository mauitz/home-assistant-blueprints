# 🔧 Troubleshooting - PezAustral Presence Simulation

## Problemas Comunes y Soluciones

---

## 🚨 CRÍTICO: No Se Puede Detener la Automatización

### Síntomas
- Activas `input_boolean.presence_simulation`
- Luces se encienden y funcionan bien
- Desactivas el `input_boolean`
- ❌ **La automatización NO se detiene**
- Continúa encendiendo/apagando luces
- Tuviste que reiniciar Home Assistant

### Causa
Estás usando la **versión 1.0** del blueprint que tenía un bug crítico.

### Solución Inmediata

**1. Actualiza el blueprint:**
```bash
# En Home Assistant:
Configuración → Automatizaciones y Escenas → Blueprints
→ Menú (⋮) → Recargar blueprints

# O fuerza actualización desde GitHub:
→ Eliminar blueprint viejo
→ Importar de nuevo desde repositorio
```

**2. Si aún está corriendo, detenla:**
```bash
Opción A: Deshabilitar automatización
→ Configuración → Automatizaciones 
→ "Presence Simulation" → Toggle OFF

Opción B: Apagar switches manualmente
→ Herramientas de Desarrollo → Servicios
→ Servicio: switch.turn_off
→ Target: [Tus 6 switches]
→ Llamar Servicio

Opción C: Reiniciar HA (última opción)
→ Configuración → Sistema → Reiniciar
```

**3. Crear escena de parada de emergencia:**
```yaml
# En Configuración → Escenas → Nueva Escena
Nombre: Emergency Stop
Entidades:
  switch.switch_1: off
  switch.switch_2: off
  # ... todos tus switches en OFF
```

**4. Actualizar automatización:**
```bash
→ Editar automatización
→ Scroll hasta "Escena de Salida"
→ En "Escena de Parada de Emergencia" → Selecciona scene.emergency_stop
→ Guardar
```

**5. Verificar que funciona:**
```bash
1. Activa input_boolean.presence_simulation
2. Espera 30 segundos
3. Desactiva input_boolean.presence_simulation
4. ✅ Debe detenerse en < 5 segundos
5. ✅ Debe apagar todas las luces
```

---

## ⚙️ Problemas de Configuración

### Las luces no se encienden

**Verifica:**
1. El `input_boolean` está en ON
2. Las condiciones se cumplen (día de semana, fechas, etc.)
3. Los entity_id de las luces son correctos
4. Las luces están disponibles (no offline)

**Solución:**
```bash
# Ver logs:
Configuración → Sistema → Logs
# Busca errores relacionados

# Probar manualmente:
Herramientas de Desarrollo → Servicios
→ light.turn_on o switch.turn_on
→ entity_id: [tu_switch]
```

### Se encienden más luces del límite

**Causa:** `entity_order_on: entities_on_same_time`

**Solución:**
```yaml
# Cambia a:
entity_order_on: entities_on_shuffled  # Recomendado
# O:
entity_order_on: entities_on_sequence
entity_order_on: entities_on_reverse
```

### El contador de loops no funciona

**Causa:** Falta incrementar en tu automatización

**Solución:** Agrega al final de cada loop:
```yaml
- service: input_number.set_value
  target:
    entity_id: input_number.presence_simulation_loop_counter
  data:
    value: >
      {{ states('input_number.presence_simulation_loop_counter') | int + 1 }}
```

---

## 💡 Problemas con Luces Específicas

### Las luces no respetan el brillo configurado

**Causa:** Solo aplica a entidades `light.*`, no a `switch.*`

**Solución:**
- Para switches: El brillo no aplica
- Para luces: Verifica que sean compatibles con `brightness_pct`

### Algunas luces no se apagan

**Verifica:**
1. Los entity_id son correctos
2. Las luces responden a comandos manuales
3. No hay otra automatización controlándolas

**Solución:**
```bash
# Apagar manualmente:
Herramientas de Desarrollo → Servicios
→ homeassistant.turn_off
→ entity_id: [la_luz_problemática]
```

---

## 🔄 Problemas con Loops

### Loop infinito no se detiene

**Esperado:** Loop infinito (count: 0) debe detenerse manualmente

**Solución:**
- Desactiva el `input_boolean`
- Con v1.1, se detendrá en < 5 segundos

### La escena de salida no se activa

**Causa:** Loop es infinito (count: 0)

**Solución:** La escena de salida solo se activa cuando:
- Loop tiene número específico (1, 2, 3, etc.)
- Se completan todas las repeticiones
- NO se interrumpe manualmente

Para loop infinito:
- Usa "Escena de Parada de Emergencia" en su lugar

---

## 📊 Problemas con Monitoring

### Helpers no aparecen

**Solución:**
```bash
1. Verifica configuration.yaml
2. Busca errores de sintaxis YAML
3. Reinicia Home Assistant
4. Configuración → Helpers → Verifica que existen
```

### El dashboard muestra "Entity not available"

**Causa:** Falta algún helper o sensor

**Solución:**
```bash
Herramientas de Desarrollo → Estados
→ Busca: presence_simulation
→ Verifica que todos existen:
  - input_boolean.presence_simulation_running
  - input_number.presence_simulation_loop_counter
  - input_text.presence_simulation_status
  - sensor.presence_simulation_runtime
```

### La barra de progreso no funciona

**Causa:** Falta custom card `bar-card`

**Solución:**
```bash
Opción A: Instalar bar-card desde HACS
Opción B: Usar tarjeta simplificada (sin custom cards)
```

---

## 🌐 Problemas con Triggers

### No se activa al atardecer

**Verifica:**
```yaml
trigger_type: sun_elevation
sun_elevation: -5  # ← Ajusta este valor
# Valores negativos = después del atardecer
```

### No se activa con luz ambiental

**Verifica:**
1. El sensor de luz existe y funciona
2. El umbral es correcto para tu sensor
3. La luz actual está por debajo del umbral

---

## 🔧 Diagnóstico Avanzado

### Ver traza de ejecución

```bash
1. Configuración → Automatizaciones
2. Tu automatización → Menú (⋮)
3. "Traza" o "Trace"
4. Ejecuta la automatización
5. Revisa cada paso
```

### Ver variables en tiempo real

```bash
Herramientas de Desarrollo → Estados
→ automation.presence_simulation
→ attributes → last_triggered
→ Revisa context y variables
```

### Logs detallados

En `configuration.yaml`:
```yaml
logger:
  default: info
  logs:
    homeassistant.components.automation: debug
```

---

## 🆘 Última Opción: Reset Completo

Si nada funciona:

```bash
1. Deshabilitar automatización
2. Apagar manualmente todas las luces
3. Eliminar automatización
4. Recargar blueprints
5. Crear automatización de nuevo
6. Configurar desde cero con valores simples
7. Probar con 1-2 switches primero
8. Incrementar complejidad gradualmente
```

---

## 📞 Obtener Ayuda

Si sigues teniendo problemas:

1. **Revisa los logs**: Configuración → Sistema → Logs
2. **Consulta ejemplos**: `/examples/` en el repositorio
3. **GitHub Issues**: Reporta con:
   - Versión de Home Assistant
   - Versión del blueprint
   - Configuración YAML (sin datos sensibles)
   - Logs relevantes
   - Pasos para reproducir

---

## ✅ Checklist de Verificación

Antes de reportar un problema, verifica:

- [ ] Usando versión 1.1 (o más reciente) del blueprint
- [ ] Blueprint recargado en Home Assistant
- [ ] Automatización guardada correctamente
- [ ] Entity_id de luces son correctos
- [ ] Input_boolean existe y funciona
- [ ] Condiciones se cumplen (día, fecha, zona, etc.)
- [ ] Probado con configuración simple primero
- [ ] Revisado logs de Home Assistant
- [ ] Traza de automatización revisada

---

*Troubleshooting - PezAustral Presence Simulation v1.1*  
*Noviembre 2025*

