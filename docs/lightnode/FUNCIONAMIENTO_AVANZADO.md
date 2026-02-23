# LightNode - Funcionamiento Avanzado con Efecto Proximidad

## ✅ DESPLEGADO EN: lightnode-entrance (192.168.1.14)

**Versión**: 2.0  
**Fecha**: 2026-01-29  
**Firmware**: Actualizado y operativo

---

## 🎛️ CONTROLES PRINCIPALES

### 1. **Control Automático** (Switch)

**Función**: Master switch del sistema  
**Estados**:
- **ON** 🟦: Modo automático con efecto de proximidad
- **OFF** ⬜: Modo manual - controlas las luces manualmente

**Comportamiento**:
```
ON  → Sistema reacciona automáticamente a la proximidad
      Brillo aumenta/disminuye según distancia
      
OFF → Sistema manual
      Usas switches y dimmers para controlar
```

---

### 2. **Solo de Noche** (Switch)

**Función**: Restricción por nivel de luz ambiente  
**Estados**:
- **ON** 🟦: Solo funciona cuando está oscuro
- **OFF** ⬜: Funciona siempre, día y noche

**Cómo funciona**:
```
Solo de Noche = ON
│
├─ Luz Ambiente >= Umbral (ej: 73% >= 30%)
│  └─ NO enciende (hay luz suficiente) ✅
│
└─ Luz Ambiente < Umbral (ej: 15% < 30%)
   └─ SÍ enciende (está oscuro) ✅
```

**Afecta a**:
- ✅ Modo automático
- ✅ Modo manual (también respeta el umbral)

**Configurar umbral**: Slider "Umbral Luz (Solo de Noche)"

---

## 🎚️ CONTROLES MANUALES

### 3. **Luz Derecha Manual** (Switch)
**Función**: Enciende/apaga guirnalda derecha manualmente  
**Activo solo cuando**: Control Automático = OFF

**Comportamiento**:
```
Switch ON → Enciende al brillo configurado en "Dimmer Luz Derecha"
          → Si "Solo de Noche" está ON, verifica luz ambiente primero
          
Switch OFF → Apaga la guirnalda
```

### 4. **Dimmer Luz Derecha** (Slider 5-100%)
**Función**: Define el brillo cuando enciendes manualmente  
**Rango**: 5% - 100%

**Uso**:
```
1. Control Automático = OFF
2. Ajusta "Dimmer Luz Derecha" a 50%
3. Activa "Luz Derecha Manual"
4. Guirnalda enciende al 50%

Cambiar dimmer con luz encendida → aplica brillo inmediatamente
```

### 5. **Luz Izquierda Manual** (Switch)
**Función**: Enciende/apaga guirnalda izquierda manualmente  
**Comportamiento**: Idéntico a Luz Derecha

### 6. **Dimmer Luz Izquierda** (Slider 5-100%)
**Función**: Define el brillo de la guirnalda izquierda  
**Comportamiento**: Idéntico a Dimmer Derecha

---

## 🤖 MODO AUTOMÁTICO AVANZADO

### Concepto: Efecto de Proximidad

El sistema detecta qué tan cerca estás y ajusta el brillo progresivamente:

```
   Lejos                Cerca              Muy cerca
   200cm               100cm                50cm
     │                   │                    │
     V                   V                    V
   20% brillo         60% brillo          100% brillo
     │                   │                    │
   Comienza          Se ilumina         Máximo brillo
  a encender          más                 al pasar
```

### Parámetros Configurables

#### **Distancia Inicio (X)** - Default: 200cm
**Función**: A qué distancia empieza a encender

```
Ejemplo con X = 200cm:
- Estás a 250cm → Luz = 0% (muy lejos)
- Estás a 200cm → Luz = 20% (empieza a encender) ✨
- Estás a 150cm → Luz = 40% (aumentando)
```

**Rango**: 50 - 600 cm  
**Recomendado**: 150-250cm para pasillos

#### **Brillo Inicio (Y)** - Default: 20%
**Función**: Brillo inicial cuando detecta a X metros

```
Ejemplo con Y = 20%:
- Detecta a 200cm → Enciende al 20%
- Te acercas → Brillo aumenta gradualmente
- Llegas a 50cm → Brillo = 100%
```

**Rango**: 5 - 80%  
**Recomendado**: 15-30% (suficiente para ver sin deslumbrar)

#### **Distancia Máxima (Z)** - Default: 50cm
**Función**: A qué distancia alcanza 100% de brillo

```
Ejemplo con Z = 50cm:
- Estás a 100cm → Luz = 60% (interpolado)
- Estás a 50cm  → Luz = 100% (máximo) 💡
- Estás a 30cm  → Luz = 100% (mantiene máximo)
```

**Rango**: 20 - 200 cm  
**Recomendado**: 40-80cm (justo cuando pasas el sensor)

### Fórmula de Interpolación

```
Brillo = Y + ((X - distancia_actual) / (X - Z)) × (100 - Y)

Donde:
X = Distancia Inicio
Y = Brillo Inicio  
Z = Distancia Máxima
```

**Ejemplo práctico**:
```
X = 200cm, Y = 20%, Z = 50cm
Estás a 125cm (punto medio)

Brillo = 20 + ((200 - 125) / (200 - 50)) × (100 - 20)
       = 20 + (75 / 150) × 80
       = 20 + (0.5 × 80)
       = 20 + 40
       = 60% ✅
```

---

## 🎬 ESCENARIOS DE USO

### Escenario 1: Día Soleado (Luz 73%)

```
Configuración:
- Control Automático: ON
- Solo de Noche: ON
- Umbral: 30%

Resultado:
1. Te acercas al sensor
2. Sistema detecta: Luz 73% >= 30%
3. NO enciende (hay luz natural) ✅
4. Sensores siguen monitoreando pero no actúan
```

### Escenario 2: Noche Oscura (Luz 15%)

```
Configuración:
- Control Automático: ON
- Solo de Noche: ON
- Umbral: 30%
- X=200cm, Y=20%, Z=50cm

Resultado:
1. Estás a 300cm → Luz OFF (muy lejos)
2. Caminas a 200cm → Detecta presencia → Luz 20% ✨
3. Caminas a 125cm → Luz sube a 60% 💡
4. Pasas a 50cm → Luz 100% 🔆
5. Te alejas a 200cm → Luz baja a 20%
6. Te alejas a 300cm → Sin detección → Timeout → Apaga ⬛
```

### Escenario 3: Modo Manual de Noche

```
Configuración:
- Control Automático: OFF
- Solo de Noche: ON
- Umbral: 30%
- Luz Ambiente: 15% (oscuro)
- Dimmer Derecha: 70%

Acción:
1. Activas "Luz Derecha Manual"
2. Sistema verifica: 15% < 30% → OK (está oscuro)
3. Enciende al 70% fijo ✅
4. No reacciona a movimiento
5. Manual hasta que la apagues
```

### Escenario 4: Modo Manual de Día (No Permitido)

```
Configuración:
- Control Automático: OFF
- Solo de Noche: ON
- Umbral: 30%
- Luz Ambiente: 73% (día)

Acción:
1. Intentas activar "Luz Derecha Manual"
2. Sistema verifica: 73% >= 30% → NO OK (hay luz)
3. NO enciende ❌
4. Log: "Solo de noche activado - hay luz"
5. Switch vuelve a OFF automáticamente
```

### Escenario 5: Siempre Manual (Sin Restricciones)

```
Configuración:
- Control Automático: OFF
- Solo de Noche: OFF
- Dimmer: 100%

Resultado:
✅ Enciendes cuando quieras
✅ Funciona día y noche
✅ Brillo fijo que configuraste
✅ No reacciona a movimiento
```

---

## 📊 TABLA DE MODOS

| Control Auto | Solo Noche | Comportamiento |
|--------------|------------|----------------|
| ON | ON | Automático con proximidad, solo si oscuro |
| ON | OFF | Automático con proximidad, siempre |
| OFF | ON | Manual, solo si oscuro |
| OFF | OFF | Manual, siempre |

---

## 🔧 CONFIGURACIONES RECOMENDADAS

### Para Pasillo Estrecho (2m ancho)
```
Distancia Inicio: 150cm
Brillo Inicio: 15%
Distancia Máxima: 40cm
Timeout: 20 segundos

Resultado: Luz sutil que aumenta rápido al pasar
```

### Para Entrada Amplia (3-4m ancho)
```
Distancia Inicio: 250cm
Brillo Inicio: 25%
Distancia Máxima: 80cm
Timeout: 45 segundos

Resultado: Detección temprana, transición suave
```

### Para Máxima Detección
```
Distancia Inicio: 400cm
Brillo Inicio: 10%
Distancia Máxima: 100cm
Timeout: 60 segundos

Resultado: Te detecta de muy lejos, brillo muy gradual
```

### Para Luz Nocturna Suave
```
Distancia Inicio: 200cm
Brillo Inicio: 5%
Distancia Máxima: 50cm
Timeout: 30 segundos
Solo de Noche: ON
Umbral: 20%

Resultado: Solo de noche, brillo muy bajo, aumenta al acercarse
```

---

## 📈 MONITOREO Y DEBUG

### Ver Logs en Tiempo Real

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
/Users/maui/Library/Python/3.11/bin/esphome logs lightnode_entrance.yaml
```

**Mensajes que verás**:
```
[I] "¡Presencia detectada!"
[I] "Modo automático activado"
[D] "Distancia: 150cm → Brillo: 45%"
[I] "Sin presencia"
[I] "Iniciando timeout de 30 segundos..."
[I] "Timeout cumplido - Apagando LEDs"
```

### Sensores Útiles para Monitoreo

| Sensor | Qué Muestra | Uso |
|--------|-------------|-----|
| **Distancia Detección** | 0-600cm | Qué tan cerca estás |
| **Distancia Movimiento** | 0-600cm | Movimiento detectado |
| **Distancia Estático** | 0-600cm | Persona quieta detectada |
| **Luz Ambiente** | 0-100% | Nivel de luz actual |
| **Objetivo en Movimiento** | ON/OFF | Si detecta movimiento |

---

## 🧪 PRUEBAS RECOMENDADAS

### Test 1: Verificar Modo Automático

```
1. Control Automático: ON
2. Solo de Noche: OFF (para que siempre funcione)
3. Acércate desde 3 metros
4. Observa cómo la luz aumenta gradualmente
5. Pasa el sensor completamente
6. Luz debería estar al 100%
7. Aléjate y espera el timeout
8. Luz debería apagarse
```

### Test 2: Verificar Solo de Noche

```
1. Control Automático: ON
2. Solo de Noche: ON
3. Umbral: 80% (para forzar condición)
4. Si Luz Ambiente < 80%: Funcionará
5. Si Luz Ambiente >= 80%: No funcionará
```

### Test 3: Ajustar Parámetros de Proximidad

```
1. Configuración inicial: X=200, Y=20%, Z=50
2. Acércate y observa comportamiento
3. Ajusta X a 300 → Debería detectar más lejos
4. Ajusta Y a 40% → Brillo inicial más alto
5. Ajusta Z a 30 → Alcanza 100% más cerca
```

### Test 4: Modo Manual

```
1. Control Automático: OFF
2. Solo de Noche: OFF
3. Dimmer Derecha: 60%
4. Activa "Luz Derecha Manual"
5. Luz debería encender al 60% fijo
6. Cambia Dimmer a 80% → Debería aplicarse inmediatamente
7. Muévete frente al sensor → No debería cambiar nada
```

---

## 🎯 DIFERENCIAS CON VERSIÓN ANTERIOR

| Característica | Versión 1.0 | Versión 2.0 (Actual) |
|----------------|-------------|----------------------|
| Control automático | Encendido simple ON/OFF | Efecto proximidad progresivo |
| Brillo | Siempre 100% | Variable 5-100% según distancia |
| Modo manual | No disponible | Switches + Dimmers independientes |
| Solo de noche | Solo en automático | En automático Y manual |
| Parámetros configurables | 2 (umbral, timeout) | 6 (umbral, timeout, X, Y, Z, dimmers) |
| Detección | ON/OFF binario | Continua con interpolación |

---

## 💡 TIPS Y TRUCOS

### Tip 1: Luz Nocturna Permanente
```
Control Automático: OFF
Luz Derecha Manual: ON
Dimmer: 5%

Resultado: Luz tenue constante (no automática)
```

### Tip 2: Solo Iluminar al Pasar
```
Distancia Inicio: 100cm (corto alcance)
Brillo Inicio: 50%
Distancia Máxima: 30cm
Timeout: 10 segundos

Resultado: Solo enciende cuando estás MUY cerca, apaga rápido
```

### Tip 3: Luz Ambiental Continua
```
Control Automático: ON
Distancia Inicio: 500cm (muy lejos)
Brillo Inicio: 10%
Timeout: 300 segundos

Resultado: Mantiene luz tenue casi permanente
```

### Tip 4: Desactivar Temporalmente
```
Control Automático: OFF
Todas las luces manuales: OFF

Resultado: Sistema completamente apagado
```

---

## 🔄 ACTUALIZACIONES FUTURAS POSIBLES

Ideas para mejorar (no implementadas aún):

- [ ] **Direccionalidad**: Detectar si vienes de izquierda o derecha
  - Encender solo el lado correspondiente
  
- [ ] **Horarios**: Comportamiento diferente día/noche
  - De día: brillo bajo
  - De noche: brillo alto
  
- [ ] **Aprendizaje**: Adaptar según uso
  - Recordar horarios de tránsito
  
- [ ] **Escenas**: Presets rápidos
  - "Película", "Lectura", "Dormir"

---

## 📚 RESUMEN EJECUTIVO

**El LightNode Entrance ahora tiene**:

✅ **2 modos**: Automático (con proximidad) o Manual  
✅ **Control independiente**: Cada guirnalda con switch + dimmer  
✅ **Efecto proximidad**: Brillo aumenta al acercarte  
✅ **Solo de noche**: Funciona solo cuando está oscuro  
✅ **6 parámetros ajustables**: Personalización completa  
✅ **Interpolación suave**: Transiciones naturales  
✅ **Logs detallados**: Debug fácil  

**En Home Assistant verás**:
- 2 Switches de modo (Control Auto, Solo Noche)
- 2 Switches manuales (Luz Derecha/Izquierda)
- 6 Sliders configurables
- Todos los sensores de distancia y luz

---

**¡Ve a Home Assistant y prueba los nuevos controles!** 🚀

**URL**: `http://192.168.1.100:8123`  
**Dispositivo**: LightNode Entrance
