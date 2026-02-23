# LightNode Entrance - Guía de Uso de Controles

## 🎮 PANEL DE CONTROL EN HOME ASSISTANT

### Vista Rápida

```
╔═══════════════════════════════════════════════════════╗
║            LIGHTNODE ENTRANCE CONTROLS                ║
╠═══════════════════════════════════════════════════════╣
║                                                       ║
║  🤖 MODOS DE OPERACIÓN                                ║
║  ┌─────────────────────────────────────────┐         ║
║  │ Control Automático          [ON] 🟦     │         ║
║  │ Solo de Noche               [ON] 🟦     │         ║
║  └─────────────────────────────────────────┘         ║
║                                                       ║
║  💡 CONTROL MANUAL                                    ║
║  ┌─────────────────────────────────────────┐         ║
║  │ Luz Derecha Manual          [OFF] ⬜    │         ║
║  │ Dimmer Luz Derecha          ▓▓▓▓▓░░░░░ 50%       │         ║
║  │                                          │         ║
║  │ Luz Izquierda Manual        [OFF] ⬜    │         ║
║  │ Dimmer Luz Izquierda        ▓▓▓▓▓▓▓▓▓▓ 100%      │         ║
║  └─────────────────────────────────────────┘         ║
║                                                       ║
║  ⚙️ CONFIGURACIÓN                                     ║
║  ┌─────────────────────────────────────────┐         ║
║  │ Umbral Luz (Solo de Noche)  ▓▓░░░░░░░░ 30%       │         ║
║  │ Timeout Apagado             ▓▓▓░░░░░░░ 70s       │         ║
║  │                                          │         ║
║  │ Distancia Inicio (X)        200 cm      │         ║
║  │ Brillo Inicio (Y)           ▓▓░░░░░░░░ 20%       │         ║
║  │ Distancia Máxima (Z)        50 cm       │         ║
║  └─────────────────────────────────────────┘         ║
║                                                       ║
║  📊 SENSORES (Solo lectura)                           ║
║  ┌─────────────────────────────────────────┐         ║
║  │ 👁️ Presencia Entrance       Detected    │         ║
║  │ 📏 Distancia Detección      125 cm      │         ║
║  │ ☀️ Luz Ambiente              73%        │         ║
║  └─────────────────────────────────────────┘         ║
╚═══════════════════════════════════════════════════════╝
```

---

## 🎯 GUÍA RÁPIDA: ¿QUÉ MODO USAR?

### 🤖 MODO AUTOMÁTICO (Recomendado)

**Cuándo usarlo**:
- ✅ Uso normal del pasillo/entrada
- ✅ Quieres manos libres
- ✅ Efecto progresivo al acercarte

**Configuración sugerida**:
```
Control Automático:     ON
Solo de Noche:          ON (solo funciona de noche)
Umbral Luz:             30% (ajusta según ambiente)
Distancia Inicio:       200cm
Brillo Inicio:          20%
Distancia Máxima:       50cm
Timeout:                30-60 segundos
```

### 🔦 MODO MANUAL

**Cuándo usarlo**:
- ✅ Quieres luz constante (sin automatización)
- ✅ Estás trabajando en el área
- ✅ Quieres brillo específico

**Configuración sugerida**:
```
Control Automático:     OFF
Solo de Noche:          OFF (o ON según prefieras)
Dimmer Derecha:         60%
Dimmer Izquierda:       60%

Acción: Activa switches manuales cuando necesites
```

---

## 📝 INSTRUCCIONES PASO A PASO

### CASO 1: Activar Modo Automático Completo

```
Objetivo: Sistema funciona solo, de noche, con efecto proximidad

Pasos:
1. Ve al dispositivo "LightNode Entrance" en HA
2. Activa "Control Automático" → ON
3. Activa "Solo de Noche" → ON
4. Ajusta "Umbral Luz" → 30% (o según tu ambiente)
5. Deja "Distancia Inicio" → 200cm
6. Deja "Brillo Inicio" → 20%
7. Deja "Distancia Máxima" → 50cm
8. Ajusta "Timeout" → 60 segundos

✅ Listo. Ahora espera a que oscurezca y camina por el pasillo.
```

### CASO 2: Activar Luz Manual Temporal

```
Objetivo: Necesitas luz ahora, sin automatización

Pasos:
1. Desactiva "Control Automático" → OFF
2. (Opcional) Desactiva "Solo de Noche" → OFF
3. Ajusta "Dimmer Luz Derecha" → 80%
4. Activa "Luz Derecha Manual" → ON

✅ Luz derecha encendida al 80% fijo.

Para apagar:
5. Desactiva "Luz Derecha Manual" → OFF
```

### CASO 3: Probar Efecto Proximidad

```
Objetivo: Ver el efecto gradual de cerca

Pasos:
1. Control Automático: ON
2. Solo de Noche: OFF (para prueba diurna)
3. Distancia Inicio: 150cm (más corto para test)
4. Brillo Inicio: 30%
5. Distancia Máxima: 40cm

Prueba:
- Aléjate 2 metros → Luz OFF
- Acércate a 1.5m → Luz 30% ✨
- Acércate a 1m → Luz ~50% 💡
- Acércate a 40cm → Luz 100% 🔆
- Observa el sensor "Distancia Detección" en tiempo real
```

### CASO 4: Configurar Solo para Noche

```
Objetivo: Solo funcione automáticamente cuando oscurezca

Pasos:
1. Control Automático: ON
2. Solo de Noche: ON
3. Umbral Luz: 40% (ajusta según tu horario de oscurecimiento)

Comportamiento:
- Día (Luz 60%): No enciende aunque detecte presencia
- Tarde (Luz 35%): Enciende al detectar presencia
- Noche (Luz 10%): Enciende al detectar presencia

Ajustar umbral:
- ¿Quieres que encienda antes (al atardecer)? → Sube a 50-60%
- ¿Solo de noche cerrada? → Baja a 20-25%
```

---

## 🎨 EJEMPLOS PRÁCTICOS

### Ejemplo 1: Pasillo Residencial Normal

```yaml
Uso: Pasillo de casa, tránsito rápido

Control Automático:     ON
Solo de Noche:          ON
Umbral Luz:             30%
Distancia Inicio:       180cm
Brillo Inicio:          20%
Distancia Máxima:       50cm
Timeout:                40 segundos

Resultado:
✅ Solo funciona de noche
✅ Te detecta a casi 2 metros
✅ Luz aumenta suavemente
✅ Apaga 40 seg después de salir
```

### Ejemplo 2: Entrada Principal con Luz Decorativa

```yaml
Uso: Entrada, a veces te quedas ahí

Control Automático:     ON
Solo de Noche:          OFF (siempre encendido)
Distancia Inicio:       250cm
Brillo Inicio:          15%
Distancia Máxima:       80cm
Timeout:                120 segundos

Resultado:
✅ Funciona día y noche
✅ Detección temprana (2.5m)
✅ Brillo muy gradual
✅ Tiempo largo para apagar (2 min)
```

### Ejemplo 3: Luz de Seguridad Nocturna

```yaml
Uso: Iluminar al levantarse de noche

Control Automático:     ON
Solo de Noche:          ON
Umbral Luz:             15% (solo noche cerrada)
Distancia Inicio:       300cm
Brillo Inicio:          5% (muy tenue)
Distancia Máxima:       100cm
Timeout:                45 segundos

Resultado:
✅ Solo de madrugada
✅ Luz inicial muy tenue (no deslumbra)
✅ Aumenta suavemente al acercarte
✅ Suficiente para orientarse
```

### Ejemplo 4: Control 100% Manual

```yaml
Uso: Quieres controlar todo tú

Control Automático:     OFF
Solo de Noche:          OFF
Dimmer Derecha:         70%
Dimmer Izquierda:       70%

Acción:
- Activas/desactivas switches cuando quieras
- Brillo fijo al 70%
- Sin reacción a movimiento
```

---

## 🔍 DIAGNÓSTICO

### Problema: Las luces no encienden automáticamente

**Verificar**:
1. ✅ Control Automático = ON
2. ✅ Si "Solo de Noche" = ON → Luz Ambiente < Umbral
3. ✅ Sensor "Presencia Entrance" detecta (ON)
4. ✅ Sensor "Distancia Detección" > 0 cm

**Solución**:
- Si Luz Ambiente alta → Desactiva "Solo de Noche" o ajusta Umbral
- Si no detecta → Verifica conexiones del LD2410C

### Problema: Luces no encienden manualmente

**Verificar**:
1. ✅ Control Automático = OFF
2. ✅ Si "Solo de Noche" = ON → Luz Ambiente < Umbral
3. ✅ Dimmer no está en 0%

**Solución**:
- Desactiva "Solo de Noche" temporalmente para probar
- Sube Dimmer a 100%
- Verifica que el switch manual esté ON

### Problema: Brillo no cambia con la distancia

**Verificar**:
1. ✅ Control Automático = ON
2. ✅ Sensor "Distancia Detección" está cambiando
3. ✅ Parámetros X, Y, Z están configurados
4. ✅ Distancia Inicio > Distancia Máxima

**Solución**:
- Observa logs en tiempo real
- Verifica que Distancia Inicio (ej: 200) > Distancia Máxima (ej: 50)

### Problema: Se apagan muy rápido

**Solución**:
- Aumenta "Timeout Apagado" a 60-120 segundos

### Problema: Demoran en encender

**Solución**:
- Aumenta "Distancia Inicio" para detección más temprana
- Verifica que LD2410C esté orientado correctamente

---

## 📊 TABLA DE SENSORES

| Sensor | Valor Ejemplo | Significado |
|--------|---------------|-------------|
| Presencia Entrance | Detected | Hay alguien cerca |
| Distancia Detección | 125 cm | Persona a 1.25m |
| Distancia Movimiento | 130 cm | Movimiento a 1.3m |
| Distancia Estático | 120 cm | Persona quieta a 1.2m |
| Luz Ambiente | 73% | Buena iluminación |
| Energía Movimiento | 85% | Señal fuerte de movimiento |
| Objetivo en Movimiento | ON | Detectando movimiento activo |

---

## 🎓 ENTENDIENDO EL EFECTO PROXIMIDAD

### Ejemplo Visual

```
                PASILLO / ENTRADA
                
Lejos           Acercando         Cerca          Muy cerca
│               │                 │              │
│ 300cm         │ 200cm           │ 100cm        │ 50cm
│               │                 │              │
│ 💡OFF         │ 💡20%          │ 💡60%       │ 💡100%
│               │                 │              │
│ Oscuro        │ Tenue           │ Medio        │ Máximo
│               │                 │              │
└───────────────┴─────────────────┴──────────────┴─────────
    Sin          Detecta →       Aumenta →      Máximo
    acción       Comienza         brillo         brillo

Distancia > X    Distancia = X    En medio       Distancia ≤ Z
```

### Curva de Brillo

```
Brillo (%)
100% │                          ╱────────
     │                        ╱
 80% │                      ╱
     │                    ╱
 60% │                  ╱
     │                ╱
 40% │              ╱
     │            ╱
 20% │          ╱────
     │        ╱
  0% │──────╱
     └───────┬─────┬─────┬─────┬────── Distancia (cm)
           300   200   125    50    0
           
     Sin     Inicio  Medio  Máximo  Junto
     acción  (X)            (Z)     al sensor
```

---

## 🚦 MATRIZ DE DECISIÓN

### ¿Cuándo Enciende?

| Control Auto | Solo Noche | Luz < Umbral | Presencia | Resultado |
|--------------|------------|--------------|-----------|-----------|
| ON | ON | ✅ Sí | ✅ Sí | ✅ ENCIENDE (auto) |
| ON | ON | ❌ No | ✅ Sí | ❌ No enciende |
| ON | ON | ✅ Sí | ❌ No | ❌ No enciende |
| ON | OFF | - | ✅ Sí | ✅ ENCIENDE (siempre) |
| OFF | ON | ✅ Sí | - | ✅ Manual OK |
| OFF | ON | ❌ No | - | ❌ Manual bloqueado |
| OFF | OFF | - | - | ✅ Manual OK (siempre) |

---

## 💬 LOGS EXPLICADOS

### Modo Automático Activado

```
[I] "¡Presencia detectada!"
[I] "Modo automático activado"
[D] "Distancia: 180cm → Brillo: 23%"
[D] "Distancia: 120cm → Brillo: 58%"
[D] "Distancia: 50cm → Brillo: 100%"
[I] "Sin presencia"
[I] "Iniciando timeout de 30 segundos..."
[I] "Timeout cumplido - Apagando LEDs"
```

**Interpretación**:
1. Detectó presencia a 180cm
2. Encendió al 23% (cerca de Y=20%)
3. Te acercaste a 120cm → Subió a 58%
4. Llegaste a 50cm (Z) → 100%
5. Saliste del rango
6. Esperó 30 segundos
7. Apagó con fade de 2 segundos

### Modo Manual Activado

```
[I] "Control automático DESACTIVADO - Modo manual"
[I] "Luz derecha ON al 70%"
```

**Interpretación**:
- Cambiaste a manual
- Activaste luz derecha
- Brillo fijo al 70%

### Solo de Noche Bloqueando

```
[W] "Solo de noche activado - hay luz (73 >= 30)"
```

**Interpretación**:
- Intentaste encender
- Hay 73% de luz ambiente
- Umbral es 30%
- Sistema bloquea encendido (hay suficiente luz natural)

---

## 🎬 TUTORIAL INTERACTIVO

### Paso 1: Reset a Configuración por Defecto

```
1. Control Automático:     ON
2. Solo de Noche:          ON
3. Umbral Luz:             30%
4. Timeout:                30s
5. Distancia Inicio:       200cm
6. Brillo Inicio:          20%
7. Distancia Máxima:       50cm
8. Dimmer Derecha:         100%
9. Dimmer Izquierda:       100%
```

### Paso 2: Primera Prueba de Día

```
Configuración:
- Control Automático: ON
- Solo de Noche: OFF ← Desactivar para probar de día

Acción:
1. Aléjate 3 metros
2. Acércate caminando hacia el sensor
3. Observa las luces aumentando
4. Pasa el sensor completamente
5. Luz debería estar al 100%
6. Aléjate
7. Espera 30 segundos → Apaga
```

### Paso 3: Ajustar Comportamiento

Si el comportamiento no es el deseado:

**Las luces encienden muy lejos**:
→ Reduce "Distancia Inicio" de 200 a 120cm

**El brillo inicial es muy alto**:
→ Reduce "Brillo Inicio" de 20% a 10%

**Alcanza 100% muy lejos**:
→ Reduce "Distancia Máxima" de 50 a 30cm

**Se apaga muy rápido**:
→ Aumenta "Timeout" de 30 a 60 segundos

### Paso 4: Configurar para la Noche

```
Una vez que estés satisfecho con el comportamiento:

1. Activa "Solo de Noche" → ON
2. Al oscurecer, el sistema funcionará automáticamente
3. Durante el día, no molestará
```

---

## 🔔 AUTOMATIZACIONES ADICIONALES (HA)

### Notificación al Detectar Presencia

```yaml
automation:
  - alias: "Notificar Presencia Entrada"
    trigger:
      - platform: state
        entity_id: binary_sensor.presencia_entrance
        to: "on"
    condition:
      - condition: time
        after: "22:00:00"
        before: "06:00:00"
    action:
      - service: notify.mobile_app
        data:
          message: "🚪 Presencia detectada en la entrada"
```

### Cambiar Brillo según Hora

```yaml
automation:
  - alias: "LightNode Brillo Nocturno"
    trigger:
      - platform: time
        at: "22:00:00"
    action:
      - service: number.set_value
        target:
          entity_id: number.brillo_inicio_y
        data:
          value: 10  # Brillo más bajo de noche

  - alias: "LightNode Brillo Normal"
    trigger:
      - platform: time
        at: "06:00:00"
    action:
      - service: number.set_value
        target:
          entity_id: number.brillo_inicio_y
        data:
          value: 25  # Brillo normal de día
```

---

## 🎯 RESUMEN FINAL

**Ahora tienes un sistema que**:

✅ **Entiende dónde estás** (efecto proximidad)  
✅ **Ajusta brillo según distancia** (5-100%)  
✅ **Funciona solo de noche** (opcional)  
✅ **Control manual completo** (switches + dimmers)  
✅ **6 parámetros ajustables** (personalización total)  
✅ **Transiciones suaves** (300ms-2000ms)  
✅ **Totalmente configurable** desde Home Assistant  

---

**¡Ve a Home Assistant y explora los nuevos controles!** 🚀

Encontrarás muchos más controles y opciones que antes.

**Refresca la página** del dispositivo en HA para ver todos los cambios.
