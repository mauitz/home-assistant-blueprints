# LightNode - Análisis del Comportamiento de Proximidad

## 🔍 DIAGNÓSTICO: Modo Automático se Comporta Raro

**Fecha**: 2026-01-29  
**Estado**: Manual funciona ✅ | Automático tiene problemas ❌

---

## 📐 FÓRMULA DE INTERPOLACIÓN ACTUAL

### Código Implementado

```cpp
// Parámetros
float dist_inicio = id(distancia_inicio);    // X: Default 200cm
float dist_maxima = id(distancia_maxima);    // Z: Default 50cm
int brillo_min = id(brillo_inicio);         // Y: Default 20%

// Cálculo del brillo
if (distancia > dist_inicio) {
    brillo = 0;                              // Muy lejos
} else if (distancia <= dist_maxima) {
    brillo = 100;                            // Muy cerca
} else {
    // Interpolación lineal
    float rango_distancia = dist_inicio - dist_maxima;  // 200 - 50 = 150cm
    float rango_brillo = 100.0 - brillo_min;           // 100 - 20 = 80%
    float progreso = (dist_inicio - distancia) / rango_distancia;
    brillo = brillo_min + (progreso * rango_brillo);
}
```

### Valores Esperados (Config Default)

| Distancia | Cálculo | Brillo Esperado |
|-----------|---------|-----------------|
| > 200cm | Fuera de rango | 0% |
| 200cm | Y inicial | 20% |
| 175cm | 20 + (25/150 × 80) = 20 + 13.3 | 33% |
| 150cm | 20 + (50/150 × 80) = 20 + 26.7 | 47% |
| 125cm | 20 + (75/150 × 80) = 20 + 40 | 60% |
| 100cm | 20 + (100/150 × 80) = 20 + 53.3 | 73% |
| 75cm | 20 + (125/150 × 80) = 20 + 66.7 | 87% |
| 50cm | Mínimo Z | 100% |
| < 50cm | Pegado al sensor | 100% |

---

## 🐛 PROBLEMAS COMUNES Y CAUSAS

### Problema 1: Brillo Parpadea o Cambia Constantemente

**Síntomas**:
- Luz oscila rápidamente
- Brillo inestable
- Parpadeo visible

**Causas Posibles**:

#### A. Sensor LD2410C Reporta Valores Inestables

El sensor mmWave puede:
- Alternar entre "movimiento" y "estático"
- Reportar distancias fluctuantes (125cm → 130cm → 120cm → ...)
- Cambiar entre 0cm (sin detección) y valores grandes

**Solución**:
```yaml
# Agregar filtro de suavizado a distancia_deteccion
sensor:
  - platform: ld2410
    detection_distance:
      name: "Distancia Detección"
      id: distancia_deteccion
      filters:
        - sliding_window_moving_average:
            window_size: 5      # Promedio de 5 lecturas
            send_every: 2       # Actualizar cada 2 lecturas
        - throttle: 500ms       # Máximo 1 actualización cada 0.5s
```

#### B. Script se Ejecuta Demasiado Frecuentemente

Cada cambio pequeño en distancia → recalcula brillo → transición

**Diagnóstico**:
```
Logs muestran:
[D] Distancia: 125cm → Brillo: 60%
[D] Distancia: 127cm → Brillo: 59%  ← Cambio de 1% cada 0.1s
[D] Distancia: 124cm → Brillo: 61%
[D] Distancia: 126cm → Brillo: 60%
```

**Solución**:
Agregar umbral de cambio mínimo antes de actualizar:

```cpp
// En el script control_automatico_proximidad
static int ultimo_brillo = -1;
int diferencia = abs(brillo - ultimo_brillo);

if (diferencia >= 5) {  // Solo actualizar si cambia ≥5%
    // Aplicar nuevo brillo
    ultimo_brillo = brillo;
}
```

### Problema 2: Luces Encienden cuando NO Hay Nadie

**Síntomas**:
- Luces se activan solas
- Encienden con movimientos lejanos (ventiladores, cortinas)

**Causas Posibles**:

#### A. Distancia Inicio (X) Muy Grande

Default: 200cm (2 metros) puede ser demasiado sensible

**Solución**:
```
En Home Assistant:
"9. Distancia Inicio (X)" → Reducir a 120-150cm
```

#### B. LD2410C Muy Sensible

El sensor detecta movimientos mínimos

**Solución en HA**:
```
"LD2410 Max Move Distance" → Reducir a 3-4 gates
"LD2410 Max Still Distance" → Reducir a 2-3 gates
```

### Problema 3: Luces NO Encienden al Acercarse

**Síntomas**:
- Tienes que estar MUY cerca para que encienda
- Solo enciende cuando ya pasaste

**Causas Posibles**:

#### A. Distancia Inicio (X) Muy Pequeña

Default: 200cm, pero si lo cambiaste a 50cm → no detecta hasta estar encima

**Solución**:
```
"9. Distancia Inicio (X)" → Aumentar a 200-300cm
```

#### B. Solo de Noche Bloqueando

Hay luz ambiente y está activado

**Diagnóstico**:
```
Logs muestran:
[D] Solo de noche activado - hay luz (73 >= 30)
```

**Solución**:
```
Opción 1: "2. Solo de Noche" → OFF
Opción 2: "8. Umbral Luz" → Aumentar a 80-90%
```

### Problema 4: Brillo Siempre al Máximo o Mínimo

**Síntomas**:
- Solo enciende al 20% o al 100%
- No hay transición gradual

**Causas Posibles**:

#### A. Rango de Distancia Muy Estrecho

Si X y Z están muy cerca:
- X = 60cm
- Z = 50cm
- Rango = 10cm → Casi no hay interpolación

**Solución**:
```
X debe ser al menos 100cm mayor que Z:
- X = 200cm
- Z = 50cm
- Rango = 150cm ✓
```

#### B. Sensor Solo Reporta Extremos

LD2410C configurado incorrectamente

**Verificar**:
```
En Home Assistant, observa "Distancia Detección":
- ¿Muestra valores intermedios (100-180cm)?
- ¿O solo 0cm y 300cm+?
```

---

## 📊 CÓMO ANALIZAR LOS LOGS

### Ejecutar Script de Análisis

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
./utils/analyze_proximity_logs.sh
```

### Qué Buscar en los Logs

#### Logs Normales (Correcto)

```
[D] auto: Distancia: 195cm → Brillo: 23%
[D] auto: Distancia: 180cm → Brillo: 31%
[D] auto: Distancia: 160cm → Brillo: 41%
[D] auto: Distancia: 140cm → Brillo: 52%
[D] auto: Distancia: 120cm → Brillo: 63%
[D] auto: Distancia: 100cm → Brillo: 73%
[D] auto: Distancia: 80cm → Brillo: 84%
[D] auto: Distancia: 60cm → Brillo: 94%
[D] auto: Distancia: 45cm → Brillo: 100%
```

**Análisis**: ✅ Progresión suave y gradual

#### Logs Problemáticos - Fluctuación

```
[D] auto: Distancia: 125cm → Brillo: 60%
[D] auto: Distancia: 128cm → Brillo: 58%
[D] auto: Distancia: 123cm → Brillo: 61%
[D] auto: Distancia: 0cm → Brillo: 0%      ← Pérdida de detección
[D] auto: Distancia: 126cm → Brillo: 59%
[D] auto: Distancia: 127cm → Brillo: 59%
[D] auto: Distancia: 0cm → Brillo: 0%      ← Otra vez
```

**Análisis**: ❌ Sensor inestable, necesita filtrado

#### Logs Problemáticos - Solo Extremos

```
[D] auto: Distancia: 0cm → Brillo: 0%
[D] auto: Distancia: 0cm → Brillo: 0%
[D] auto: Distancia: 45cm → Brillo: 100%   ← Salto directo
[D] auto: Distancia: 0cm → Brillo: 0%
[D] auto: Distancia: 48cm → Brillo: 100%
```

**Análisis**: ❌ No hay detección intermedia, LD2410C mal configurado

---

## 🔧 SOLUCIONES PASO A PASO

### Solución 1: Agregar Filtros de Suavizado

Editar `esphome/lightnode_entrance.yaml`:

```yaml
sensor:
  - platform: ld2410
    detection_distance:
      name: "Distancia Detección"
      id: distancia_deteccion
      filters:
        # Promediar 5 lecturas
        - sliding_window_moving_average:
            window_size: 5
            send_every: 2
        # Máximo 1 actualización cada 0.5 segundos
        - throttle: 500ms
        # Ignorar cambios menores a 10cm
        - delta: 10
      on_value:
        then:
          - if:
              condition:
                switch.is_on: switch_control_automatico
              then:
                - script.execute: control_automatico_proximidad
```

### Solución 2: Agregar Umbral de Cambio

Editar el script `control_automatico_proximidad`:

```yaml
script:
  - id: control_automatico_proximidad
    mode: restart
    then:
      - lambda: |-
          // Variables estáticas para recordar estado anterior
          static int ultimo_brillo_aplicado = -1;
          static uint32_t ultimo_cambio_ms = 0;
          uint32_t ahora = millis();
          
          float distancia = id(distancia_deteccion).state;
          
          // ... cálculo de brillo existente ...
          
          // Solo aplicar si:
          // 1. Cambió más de 5% Y
          // 2. Han pasado al menos 300ms desde el último cambio
          int diferencia = abs(brillo - ultimo_brillo_aplicado);
          uint32_t tiempo_desde_cambio = ahora - ultimo_cambio_ms;
          
          if (diferencia >= 5 && tiempo_desde_cambio >= 300) {
              ESP_LOGD("auto", "Distancia: %.0fcm → Brillo: %d%% (cambio %d%%)", 
                       distancia, brillo, diferencia);
              
              // Aplicar brillo...
              ultimo_brillo_aplicado = brillo;
              ultimo_cambio_ms = ahora;
          } else {
              ESP_LOGV("auto", "Cambio menor ignorado: %.0fcm → %d%% (diff %d%%)", 
                       distancia, brillo, diferencia);
          }
```

### Solución 3: Ajustar Parámetros en Home Assistant

#### Para Pasillo Estable

```
9. Distancia Inicio (X): 150cm   (más corto, menos sensible)
A. Brillo Inicio (Y): 30%        (empieza más alto)
B. Distancia Máxima (Z): 60cm    (100% más lejos)
7. Timeout: 45s                  (apaga más lento)
```

#### Para Entrada con Movimiento

```
9. Distancia Inicio (X): 250cm   (más largo, más anticipación)
A. Brillo Inicio (Y): 15%        (empieza muy tenue)
B. Distancia Máxima (Z): 40cm    (100% muy cerca)
7. Timeout: 20s                  (apaga más rápido)
```

---

## 🧪 PRUEBAS RECOMENDADAS

### Prueba 1: Verificar Interpolación Matemática

```python
# Ejecutar en Python para validar fórmula
X = 200  # dist_inicio
Y = 20   # brillo_inicio
Z = 50   # dist_maxima

def calcular_brillo(distancia):
    if distancia > X:
        return 0
    elif distancia <= Z:
        return 100
    else:
        rango_distancia = X - Z
        rango_brillo = 100 - Y
        progreso = (X - distancia) / rango_distancia
        return Y + (progreso * rango_brillo)

# Probar varios valores
for dist in [250, 200, 175, 150, 125, 100, 75, 50, 25]:
    brillo = calcular_brillo(dist)
    print(f"{dist}cm → {brillo:.0f}%")
```

**Resultado esperado**:
```
250cm → 0%
200cm → 20%
175cm → 33%
150cm → 47%
125cm → 60%
100cm → 73%
75cm → 87%
50cm → 100%
25cm → 100%
```

### Prueba 2: Observar Sensor en Tiempo Real

En Home Assistant:
```
1. Ve a: "Distancia Detección"
2. Observa el gráfico histórico
3. ¿Es suave o tiene picos/valles?
   
Gráfico suave:     ✅ Sensor estable
    ─────╱‾‾‾╲─────
    
Gráfico erático:   ❌ Sensor inestable
    ──╱╲─╱╲╱‾╲─╱╲──
```

### Prueba 3: Modo Manual vs Automático

```
1. Manual: "4. Dimmer Derecha" → 60%
   - Activa "3. Luz Derecha"
   - ¿Luz estable al 60%?
   
   ✅ Sí: Hardware OK, problema en automático
   ❌ No: Problema de hardware

2. Automático: "1. Control Automático" → ON
   - Párate a 1.5m del sensor
   - ¿Luz estable o parpadea?
   
   ✅ Estable: Sensor/código OK
   ❌ Parpadea: Sensor inestable o código ejecuta demasiado
```

---

## 📈 TABLA DE DIAGNÓSTICO RÁPIDO

| Síntoma | Causa Probable | Solución |
|---------|----------------|----------|
| Luz parpadea constantemente | Sensor inestable | Agregar filtros (sliding_window, throttle) |
| Solo enciende 0% o 100% | Rango X-Z muy estrecho | X ≥ Z + 100cm |
| Enciende con cualquier movimiento | X muy grande | Reducir X a 120-150cm |
| No enciende hasta estar MUY cerca | X muy pequeño | Aumentar X a 200-300cm |
| Se comporta errático | Múltiples triggers | Agregar umbral cambio (5%) |
| Solo funciona de día | "Solo de Noche" activo | Desactivar o ajustar umbral |
| Brillo correcto pero inestable | Transiciones muy frecuentes | throttle: 500ms + delta: 10 |

---

## 💡 CONFIGURACIÓN RECOMENDADA ESTABLE

### En el YAML (requiere recompilación)

```yaml
sensor:
  - platform: ld2410
    detection_distance:
      name: "Distancia Detección"
      id: distancia_deteccion
      filters:
        - sliding_window_moving_average:
            window_size: 5
            send_every: 2
        - throttle: 500ms
        - delta: 10
```

### En Home Assistant (cambio inmediato)

```
1. Control Automático: ON
2. Solo de Noche: OFF (para pruebas)
7. Timeout: 30s
8. Umbral Luz: 30%
9. Distancia Inicio (X): 180cm
A. Brillo Inicio (Y): 25%
B. Distancia Máxima (Z): 50cm

LD2410:
- LD2410 Max Move Distance: 4 gates
- LD2410 Max Still Distance: 3 gates
- LD2410 Timeout: 5s
```

---

## 🎯 SIGUIENTE PASO

### 1. Ejecutar Análisis de Logs

```bash
./utils/analyze_proximity_logs.sh
```

**Observa durante 1-2 minutos mientras te mueves**:
- ¿Los valores de distancia son estables?
- ¿El brillo calculado tiene sentido?
- ¿Hay muchos cambios en <1 segundo?

### 2. Según Resultados

**Si logs muestran fluctuación rápida**:
→ Implementar Solución 1 (Filtros de suavizado)

**Si logs muestran brillo correcto pero luz parpadea**:
→ Implementar Solución 2 (Umbral de cambio)

**Si logs muestran comportamiento errático**:
→ Ajustar LD2410C (Max Distance gates)

### 3. Reportar Hallazgos

Copia algunas líneas de los logs y las analizamos juntos para ver exactamente qué está pasando.

---

## 📞 INFORMACIÓN ADICIONAL NECESARIA

Para diagnosticar mejor, responde:

1. **¿Cómo se comporta "raro"?**
   - [ ] Parpadea rápidamente
   - [ ] Enciende/apaga sin razón
   - [ ] Brillo no corresponde a distancia
   - [ ] Otro: ___________

2. **¿Logs actuales?**
   - Ejecuta: `./utils/analyze_proximity_logs.sh`
   - Copia 10-20 líneas de ejemplo

3. **¿Configuración actual?**
   - ¿Cambiaste los valores default de X, Y, Z?
   - ¿"Solo de Noche" está ON u OFF?

---

**¡Ejecuta el script de análisis y revisemos los logs juntos!** 📊
