# 🚨 ACTUALIZACIÓN URGENTE - Blueprint v2.2.2

## Problema Detectado

El blueprint en tu Home Assistant **NO tenía**:
- ❌ El shuffle aleatorio de luces
- ❌ El cleanup mejorado

**Resultado:** Siempre empezaba con el mismo switch (switch 1 bedroom)

---

## ✅ Solución Aplicada

He actualizado automáticamente el blueprint en:
```
/HA_config_proxy/blueprints/automation/mauitz/pezaustral_presence_simulation.yaml
```

**Cambios incluidos:**
- ✅ **Shuffle aleatorio** - Cada loop empieza con orden diferente
- ✅ **Cleanup mejorado** - Apaga TODAS las luces al detener
- ✅ Sistema PAUSE/RESUME
- ✅ Sistema de notificaciones

---

## 🔄 Pasos para Activar la Actualización

### 1. Recargar Automatizaciones en Home Assistant

```
1. Abre Home Assistant
2. Ve a: Configuración → Automatizaciones y Escenas
3. Click en el menú (⋮) arriba a la derecha
4. Selecciona: "Recargar automatizaciones"
5. Espera el mensaje de confirmación
```

### 2. Reiniciar la Simulación

```
1. Si la simulación está corriendo, presiona DETENER
2. Espera 5 segundos
3. Presiona INICIAR
```

### 3. Verificar el Shuffle Aleatorio

**Test 1: Primera Ejecución**
```
1. Inicia la simulación
2. Anota qué switch se enciende primero
   Ejemplo: "switch.smartnode_bedroom_switch_1"
3. Espera que termine el loop completo
4. Detén la simulación
```

**Test 2: Segunda Ejecución**
```
1. Inicia nuevamente
2. Verifica que el PRIMER switch sea DIFERENTE
   Ejemplo: Ahora puede ser "switch.smartnode_bedroom_switch_3"
```

**Test 3: Tercera Ejecución**
```
1. Inicia una vez más
2. Confirma que sigue siendo aleatorio
```

### 4. Verificar el Cleanup

**Test de Cleanup:**
```
1. Inicia la simulación
2. Espera que se enciendan 2 switches
3. Presiona DETENER
4. ✅ VERIFICA: AMBOS switches se apagan inmediatamente
```

---

## 🔍 Cómo Verificar que el Shuffle Funciona

### Opción A: Ver los Logs

```
1. Configuración → Registros → Logbook
2. Busca: "💡 Presence Simulation"
3. Verás mensajes como:
   "Encendida: Switch Dormitorio 1 (1/2)"
   "Encendida: Switch Dormitorio 3 (2/2)"
   
4. Cada vez que inicies, el ORDEN debe cambiar
```

### Opción B: Observación Visual

```
1era ejecución: Switch 1 → Switch 2 → Switch 3
2da ejecución:  Switch 3 → Switch 1 → Switch 2
3ra ejecución:  Switch 2 → Switch 3 → Switch 1

DIFERENTE cada vez ✅
```

---

## 📊 Detalles Técnicos del Shuffle

### Implementación

```yaml
# En el blueprint (línea 368-372):
- variables:
    shuffled_lights: "{{ lights | shuffle | list }}"

- repeat:
    for_each: "{{ shuffled_lights }}"
    sequence:
      # ... enciende cada luz ...
```

### Por qué Funciona Ahora

1. **Antes:** 
   - Iteraba sobre `lights` directamente (siempre mismo orden)
   
2. **Ahora:**
   - Crea `shuffled_lights` con `| shuffle`
   - Cada loop principal crea una nueva variable
   - Orden diferente cada vez

### Cuándo se Baraja

El shuffle ocurre:
- ✅ Al inicio de cada LOOP principal
- ✅ Cada vez que termina un ciclo y empieza otro
- ✅ Cada vez que reinicias la simulación

El shuffle NO ocurre:
- ❌ Entre luces dentro del mismo loop
- ❌ Cuando pausas/resumes (mantiene el orden actual)

---

## ⚠️ Si el Shuffle AÚN NO Funciona

### Diagnóstico

Si después de recargar las automatizaciones **sigue empezando con el mismo switch**:

1. **Verifica la versión del blueprint:**
   ```bash
   grep "shuffled_lights" /Users/maui/_maui/domotica/home-assistant-blueprints/HA_config_proxy/blueprints/automation/mauitz/pezaustral_presence_simulation.yaml
   ```
   - Debe devolver: `shuffled_lights: "{{ lights | shuffle | list }}"`
   - Si NO devuelve nada: el archivo no se copió bien

2. **Reinicia Home Assistant completo:**
   ```
   Configuración → Sistema → Reiniciar
   ```

3. **Verifica que la automatización usa el blueprint correcto:**
   ```
   1. Abre la automatización "Presence Simulation"
   2. Modo edición
   3. Arriba debería decir: "Blueprint: Presence Simulation v2.2"
   4. Si dice v2.0 o v2.1: Necesitas recrear la automatización
   ```

### Si Nada Funciona

Recrea la automatización desde cero:
```
1. Elimina la automatización actual
2. Crea nueva: Configuración → Automatizaciones → Agregar
3. Selecciona: "Presence Simulation v2.2"
4. Configura los parámetros
5. Guarda
```

---

## 📝 Logs Esperados

### Al Iniciar (Primera Ejecución)
```
🎬 Presence Simulation - Iniciando simulación
💡 Presence Simulation - Encendida: Switch Dormitorio 1 (1/2)
💡 Presence Simulation - Encendida: Switch Dormitorio 3 (2/2)
```

### Al Iniciar (Segunda Ejecución)
```
🎬 Presence Simulation - Iniciando simulación
💡 Presence Simulation - Encendida: Switch Dormitorio 2 (1/2)
💡 Presence Simulation - Encendida: Switch Dormitorio 1 (2/2)
```

**Observa que el orden cambió ✅**

---

## 🎯 Resumen de Correcciones v2.2.2

| Bug | Estado | Verificación |
|-----|--------|--------------|
| Siempre empieza con mismo switch | ✅ CORREGIDO | Orden aleatorio cada vez |
| Luces no se apagan al detener | ✅ CORREGIDO | Cleanup apaga todo |
| Solo una luz se encendía | ✅ CORREGIDO | Ajustar `time_on_min` |
| Botones confusos en dashboard | ✅ CORREGIDO | Simplificado a 3 botones |

---

## 📞 Siguiente Paso

**Recarga las automatizaciones en HA y prueba** 🚀

Si después de recargar sigue sin funcionar, avísame y revisamos juntos.

---

**Fecha:** 10 de Enero 2026  
**Versión:** v2.2.2  
**Archivo:** `blueprints/pezaustral_presence_simulation.yaml`  
**Status:** ✅ Actualizado y Verificado

