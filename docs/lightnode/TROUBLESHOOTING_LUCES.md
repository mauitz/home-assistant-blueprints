# LightNode - Troubleshooting: Luces No Prenden

## ⚠️ PROBLEMA: LAS LUCES NO ENCIENDEN

**Síntomas**: Las guirnaldas LED no prenden al activar los switches en Home Assistant

**Última actualización**: 2026-01-29

---

## 🔍 DIAGNÓSTICO RÁPIDO (5 MIN)

### Verificación Inmediata

```
1. ¿El ESP32 está encendido?
   ✅ Sí: LED integrado del ESP32 encendido
   ❌ No: Problema de alimentación USB
   
2. ¿Home Assistant ve el dispositivo?
   ✅ Sí: lightnode-entrance en 192.168.1.14
   ❌ No: Problema de red/WiFi
   
3. ¿Los switches responden en HA?
   ✅ Sí: Software funcionando
   ❌ No: ESP32 no responde
   
4. ¿Las guirnaldas LED funcionaban antes?
   ✅ Sí: Se probaron directamente a 5V
   ❌ No verificado: Probar primero
```

---

## 📋 CIRCUITO DE LAS LUCES

### Diagrama Simplificado

```
Para cada canal (Derecha/Izquierda):

ESP32 5V ──┬─────────────► LED (+) Positivo
           │
ESP32 GPIO25/26          LED (-)
  (PWM)                    │
    │                      │
    ├──[R1/R3]──► Q1/Q2   │
    │   1kΩ      Base      │
    │              │       │
    │           Colector ──┴──[R2/R4]──┐
    │              │                    │
    │           Emisor                  │
    │              │                    │
GND ───────────────┴────────────────────┘

Componentes por canal:
- R1/R3: 1kΩ (base del transistor)
- Q1/Q2: BC337 NPN (switch de potencia)
- R2: 34Ω (limitadora canal izquierdo)
- R4: 30Ω = 3×10Ω en serie (canal derecho)
```

### Puntos Críticos a Verificar

```
A. Alimentación 5V a LED (+)
B. GPIO PWM funcionando
C. Transistor BC337 correctamente conectado
D. Resistencias en sus lugares correctos
E. GND común conectado
```

---

## 🧪 PROCEDIMIENTO DE DIAGNÓSTICO COMPLETO

## PASO 1: VERIFICAR SOFTWARE Y LOGS

### 1.1 Ver Logs en Tiempo Real

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
/Users/maui/Library/Python/3.11/bin/esphome logs lightnode_entrance.yaml
```

### 1.2 Probar Control Manual

En Home Assistant:

```
1. "1. Control Automático": OFF (desactivar auto)
2. "4. Dimmer Derecha": 100% (máximo)
3. "3. Luz Derecha": ON
```

**Observa los logs**, deberías ver:

```
[I] "Control automático DESACTIVADO - Modo manual"
[I] "Luz derecha ON al 100%"
```

Si NO ves estos mensajes → Problema de comunicación ESP32

### 1.3 Verificar Estado de las Luces

En los logs busca:

```bash
# Estado de las luces internas
light.led_derecha
light.led_izquierda
```

Deberían mostrar `state: ON` y `brightness: 1.0` (100%)

---

## PASO 2: VERIFICAR ALIMENTACIÓN 5V

### 2.1 Probar Guirnaldas Directamente

**Material**: Guirnaldas LED, cable USB

```
1. Desconecta las guirnaldas del circuito
2. Conecta cable Rojo (+) de guirnalda a 5V del ESP32
3. Conecta cable Negro (-) de guirnalda a GND del ESP32
4. La guirnalda debería encender al 100%

Resultado:
✅ Enciende: LED funcional, problema en circuito de control
❌ No enciende: LED defectuosa o mal pelada
```

### 2.2 Medir Voltaje en LED (+)

**Material**: Multímetro en modo voltaje DC

```
1. Punta ROJA del multímetro: Pin 5V del ESP32
2. Punta NEGRA del multímetro: GND
3. Lectura esperada: 4.8V - 5.2V

Resultado:
✅ 4.8-5.2V: Alimentación correcta
❌ Menos: Problema de alimentación USB
```

---

## PASO 3: VERIFICAR TRANSISTORES BC337

### 3.1 Identificar Pines del BC337

```
Vista FRONTAL del BC337 (cara plana hacia ti):

     ___
    /   \
   |  Q  |  ← Cara con el código impreso
   |_____|
    | | |
    C B E

C = Colector (izquierda)
B = Base (centro)
E = Emisor (derecha)
```

### 3.2 Verificar Conexiones del Transistor Q1 (Izquierda)

```
Pin BASE (centro):
  Conectado a: R1 (1kΩ) ← GPIO 25
  
Pin COLECTOR (izquierda):
  Conectado a: R2 (34Ω) ← LED Izquierda (-)
  
Pin EMISOR (derecha):
  Conectado a: GND común

VERIFICAR VISUALMENTE:
- Los tres pines están insertados en el protoboard
- No hay cortos entre pines
- El transistor está en la orientación correcta
```

### 3.3 Verificar Conexiones del Transistor Q2 (Derecha)

```
Pin BASE (centro):
  Conectado a: R3 (1kΩ) ← GPIO 26
  
Pin COLECTOR (izquierda):
  Conectado a: R4 (3×10Ω = 30Ω) ← LED Derecha (-)
  
Pin EMISOR (derecha):
  Conectado a: GND común
```

### 3.4 Probar Transistor con Multímetro (Diode Test)

**Material**: Multímetro en modo "Diode Test" o "⏵|"

```
TEST 1: Unión Base-Emisor (debe conducir)
  Punta ROJA: Base
  Punta NEGRA: Emisor
  Lectura esperada: 0.6V - 0.7V
  
TEST 2: Unión Base-Colector (debe conducir)
  Punta ROJA: Base
  Punta NEGRA: Colector
  Lectura esperada: 0.6V - 0.7V
  
TEST 3: Colector-Emisor (NO debe conducir sin señal en base)
  Punta ROJA: Colector
  Punta NEGRA: Emisor
  Lectura esperada: OL (Open Line) o muy alto

Resultado:
✅ Lecturas correctas: Transistor funcional
❌ Lecturas anormales: Transistor dañado, reemplazar
```

---

## PASO 4: VERIFICAR RESISTENCIAS

### 4.1 Resistencias del Canal IZQUIERDO

```
R1 (Base Q1): 1kΩ
  Colores: Marrón-Negro-Rojo-Dorado
  Entre: GPIO 25 → Base de Q1
  Multímetro: ~1000Ω

R2 (Limitadora LED): 34Ω
  Colores: Naranja-Amarillo-Negro-Dorado
  Entre: LED Izq (-) → Colector Q1
  Multímetro: ~34Ω
```

### 4.2 Resistencias del Canal DERECHO

```
R3 (Base Q2): 1kΩ
  Colores: Marrón-Negro-Rojo-Dorado
  Entre: GPIO 26 → Base de Q2
  Multímetro: ~1000Ω

R4 (Limitadora LED): 3×10Ω EN SERIE = 30Ω total
  Colores: Marrón-Negro-Negro-Dorado (cada una)
  Entre: LED Der (-) → Colector Q2
  Multímetro: ~30Ω (las 3 juntas)
  
  ⚠️ IMPORTANTE: Las 3 resistencias de 10Ω deben estar EN SERIE
     No en paralelo, no solo 1 o 2
```

### 4.3 Cómo Medir Resistencias In-Circuit

```
1. Apaga el ESP32 (desconecta USB)
2. Multímetro en modo resistencia (Ω)
3. Mide entre los extremos de cada resistencia
4. Verifica que los valores sean correctos

NOTA: Mediciones in-circuit pueden dar valores ligeramente diferentes
      debido a otros componentes en paralelo
```

---

## PASO 5: VERIFICAR SEÑAL PWM

### 5.1 Medir Voltaje en GPIO con Multímetro

```
Material: Multímetro en modo voltaje DC

PRUEBA:
1. En HA: "3. Luz Derecha" → ON
2. "4. Dimmer Derecha" → 100%
3. Medir voltaje:
   - Punta ROJA: GPIO 26
   - Punta NEGRA: GND
   
Resultado esperado:
  ✅ ~3.3V: GPIO enviando señal PWM al 100%
  ❌ 0V: GPIO no activo (problema software/ESP32)
  
4. Cambiar dimmer a 50%
5. Voltaje debería bajar a ~1.6V (promedio PWM)
```

### 5.2 Verificar con LED de Prueba (Opcional)

```
Material: LED común + resistencia 220Ω

TEST RÁPIDO DE GPIO:
1. LED ánodo (+): GPIO 26 (a través de 220Ω)
2. LED cátodo (-): GND
3. En HA: "3. Luz Derecha" → ON
4. LED debería encender/dimmer según el slider

Resultado:
✅ LED enciende: GPIO funciona, problema en transistor/circuito
❌ LED no enciende: GPIO no funciona (revisar código)
```

---

## PASO 6: PRUEBA DE BYPASS (Forzar Transistor)

### 6.1 Activar Transistor Manualmente

**Material**: Cable jumper

```
PRUEBA: ¿El transistor conduce correctamente?

1. Mantén "3. Luz Derecha" ON en HA
2. Con un jumper, conecta:
   Base de Q2 ──► 3.3V (o GPIO 26)
   
3. La guirnalda debería encender

Resultado:
✅ Enciende: Transistor funciona, problema en R3 o conexión GPIO
❌ No enciende: Transistor dañado O circuito LED mal conectado
```

---

## PASO 7: VERIFICAR CIRCUITO COMPLETO

### 7.1 Checklist de Conexiones (Canal Derecho)

```
[ ] 1. ESP32 5V → LED Derecha (+) cable rojo
[ ] 2. LED Derecha (-) → R4 (primer terminal de 10Ω)
[ ] 3. R4 (30Ω total) → Colector Q2 (pin izquierdo BC337)
[ ] 4. GPIO 26 → R3 (1kΩ)
[ ] 5. R3 → Base Q2 (pin centro BC337)
[ ] 6. Emisor Q2 (pin derecho BC337) → GND común
[ ] 7. GND común → ESP32 GND
```

### 7.2 Checklist de Conexiones (Canal Izquierdo)

```
[ ] 1. ESP32 5V → LED Izquierda (+) cable rojo
[ ] 2. LED Izquierda (-) → R2 (34Ω)
[ ] 3. R2 → Colector Q1 (pin izquierdo BC337)
[ ] 4. GPIO 25 → R1 (1kΩ)
[ ] 5. R1 → Base Q1 (pin centro BC337)
[ ] 6. Emisor Q1 (pin derecho BC337) → GND común
[ ] 7. GND común → ESP32 GND
```

---

## 🔧 PRUEBA PASO A PASO SIMPLIFICADA

### Test Básico de Funcionamiento

```
MATERIAL NECESARIO:
- Multímetro
- Cable jumper

PROCEDIMIENTO:

PASO A: Verificar Guirnalda LED
  1. Desconectar guirnalda del circuito
  2. Conectar directamente a 5V y GND del ESP32
  3. ¿Enciende?
     ✅ Sí → LED funcional, continúa PASO B
     ❌ No → LED defectuosa, reemplazar

PASO B: Verificar GPIO PWM
  1. Multímetro: voltaje DC
  2. Punta roja: GPIO 26, Punta negra: GND
  3. En HA: Luz Derecha ON, Dimmer 100%
  4. ¿Mide ~3.3V?
     ✅ Sí → GPIO funciona, continúa PASO C
     ❌ No → Problema software/ESP32, revisar logs

PASO C: Verificar Transistor BC337
  1. Con GPIO activo (paso B)
  2. Medir voltaje entre Colector y Emisor de Q2
  3. ¿Voltaje bajo (<0.3V)?
     ✅ Sí → Transistor conduce, continúa PASO D
     ❌ No → Transistor no conduce, verificar:
            - Conexión Base correcta
            - R3 (1kΩ) presente
            - Transistor no quemado

PASO D: Verificar Circuito LED Completo
  1. Con transistor conduciendo (paso C)
  2. Medir voltaje en LED (-):
     - Debería estar cerca de 0V (casi GND)
  3. ¿La guirnalda enciende?
     ✅ Sí → ¡FUNCIONA! 🎉
     ❌ No → Verificar:
            - R4 (30Ω) presente y correcta
            - Conexión LED (-) a R4
            - Conexión 5V a LED (+)
```

---

## 🐛 PROBLEMAS COMUNES Y SOLUCIONES

### Problema 1: GPIO Activo pero LED No Enciende

**Síntomas**:
- Logs muestran "Luz derecha ON"
- Multímetro mide 3.3V en GPIO 26
- LED no enciende

**Causas Posibles**:
1. **Transistor mal orientado**
   - Solución: Verificar pinout CBE, reorientar
   
2. **Resistencia de base (R3) faltante o incorrecta**
   - Solución: Medir R3, debe ser ~1kΩ
   
3. **Transistor quemado**
   - Solución: Probar con diode test, reemplazar

### Problema 2: Guirnalda Enciende Débil

**Síntomas**:
- LED enciende pero muy tenue, incluso al 100%

**Causas Posibles**:
1. **Resistencia limitadora muy alta**
   - R4 debe ser 30Ω (3×10Ω), no 3kΩ
   - Solución: Verificar código de colores, reemplazar
   
2. **Alimentación USB insuficiente**
   - Puerto USB no entrega suficiente corriente
   - Solución: Usar fuente USB 5V 2A dedicada

### Problema 3: Solo Una Guirnalda Funciona

**Síntomas**:
- Canal izquierdo funciona, derecho no (o viceversa)

**Causas Posibles**:
1. **Conexión GPIO diferente**
   - Verificar GPIO 25 (izq) y GPIO 26 (der)
   
2. **Transistor de un canal defectuoso**
   - Solución: Probar/reemplazar Q1 o Q2

### Problema 4: LED Parpadea o Es Inestable

**Síntomas**:
- LED titila rápidamente
- Brillo inconsistente

**Causas Posibles**:
1. **Conexión floja en protoboard**
   - Solución: Reinsertarlos firmemente
   
2. **Cable defectuoso**
   - Solución: Reemplazar cables dupont
   
3. **GND común no conectado correctamente**
   - Solución: Verificar continuidad GND ESP32 ↔ Emisor transistor

---

## 📸 PUNTOS DE MEDICIÓN CLAVE

### Mapa de Voltajes Esperados (Canal Derecho @ 100%)

```
                    5V (4.8-5.2V)
                      │
                      ├──► LED (+) [5V]
                      │
ESP32                 │    LED (-) [~0.3V]
GPIO26 [3.3V PWM]     │       │
  │                   │       │
  └──[R3 1kΩ]────► Base Q2    │
                      │       │
                   Colector ──┴──[R4 30Ω]
                      │
                   Emisor [0V] ───► GND [0V]
```

### Puntos Críticos de Medición

| Punto | Esperado @ ON (100%) | Esperado @ OFF |
|-------|---------------------|----------------|
| GPIO 26 | 3.3V | 0V |
| Base Q2 | ~2.6V (con R3) | 0V |
| Colector Q2 | ~0.3V | ~5V |
| Emisor Q2 | 0V | 0V |
| LED (+) | 5V | 5V |
| LED (-) | ~0.3V | ~5V |

---

## 🎯 DIAGNÓSTICO RÁPIDO POR SÍNTOMAS

### "No pasa nada al activar switch"

```
Verificar:
1. Logs de ESPHome (¿aparece el comando?)
2. Estado de light.led_derecha (¿cambia a ON?)
3. Voltaje en GPIO 26 (¿pasa de 0V a 3.3V?)

Problema más probable:
- Software: Revisar código ESPHome
- Hardware: GPIO defectuoso en ESP32
```

### "Multímetro mide 3.3V en GPIO pero LED no enciende"

```
Verificar:
1. Conexión GPIO → R3 → Base Q2
2. Transistor orientación y continuidad
3. Probar activar transistor manualmente (jumper base a 3.3V)

Problema más probable:
- Transistor mal conectado o quemado
- Resistencia R3 faltante/incorrecta
```

### "Guirnalda funciona directa a 5V pero no con circuito"

```
Verificar:
1. Transistor conduce (Colector-Emisor debe ser <0.3V cuando activo)
2. R4 (30Ω) presente y correcta
3. Conexión LED (-) → R4 → Colector

Problema más probable:
- Circuito de potencia incompleto
- Transistor no conduce suficiente
```

---

## 🛠️ HERRAMIENTAS NECESARIAS

### Básicas (Imprescindibles)

- ✅ Multímetro digital
- ✅ Cables jumper
- ✅ Destornillador pequeño (ajustar conexiones)

### Avanzadas (Opcionales)

- ⭐ Osciloscopio (ver señal PWM real)
- ⭐ Fuente de alimentación ajustable
- ⭐ LED de prueba con resistencia 220Ω
- ⭐ Transistor BC337 de repuesto

---

## 📞 SIGUIENTE PASO

Si después de todas estas pruebas **las luces siguen sin funcionar**:

### Opción 1: Validación Completa

```bash
# Ver logs detallados en tiempo real
cd ~/
_maui/domotica/home-assistant-blueprints/esphome
/Users/maui/Library/Python/3.11/bin/esphome logs lightnode_entrance.yaml
```

Busca errores como:
- `light.led_derecha` no cambia de estado
- Advertencias de GPIO
- Errores de compilación

### Opción 2: Test de Hardware Mínimo

Simplificar el circuito:

```
1. Desconecta TODO excepto:
   - ESP32 alimentado por USB
   - 1 LED de prueba común
   - 1 resistencia 220Ω
   
2. Conecta:
   GPIO 26 ──[220Ω]──► LED ánodo (+)
   LED cátodo (-) ──► GND
   
3. Activa "3. Luz Derecha" en HA
4. ¿LED enciende?
   ✅ Sí: GPIO funciona, problema en circuito transistor/LED
   ❌ No: Problema en ESP32 o software
```

### Opción 3: Recompilar y Re-flashear

Por si el firmware tiene algún problema:

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
/Users/maui/Library/Python/3.11/bin/esphome compile lightnode_entrance.yaml
/Users/maui/Library/Python/3.11/bin/esphome upload --device /dev/cu.usbserial-0001 lightnode_entrance.yaml
```

---

## 📋 CHECKLIST FINAL DE VERIFICACIÓN

Antes de pedir ayuda, confirma:

```
Hardware:
[ ] ESP32 enciende y conecta a WiFi
[ ] Guirnaldas probadas directamente a 5V (funcionan)
[ ] Transistores BC337 orientados correctamente (CBE)
[ ] R3/R1 = 1kΩ presentes en ambos canales
[ ] R4 = 30Ω (3×10Ω en serie) en canal derecho
[ ] R2 = 34Ω en canal izquierdo
[ ] GND común conectado a emisores y ESP32
[ ] 5V conectado a LED (+) de ambas guirnaldas

Software:
[ ] lightnode-entrance visible en HA (192.168.1.14)
[ ] Switches responden (cambian de estado en UI)
[ ] Logs muestran comandos al activar switches
[ ] "Control Automático" desactivado para pruebas manuales

Mediciones:
[ ] GPIO 26 mide 3.3V cuando "Luz Derecha" ON
[ ] GPIO 25 mide 3.3V cuando "Luz Izquierda" ON
[ ] Voltaje 5V presente en LED (+)
[ ] Transistor conduce (Colector-Emisor <0.3V cuando activo)
```

---

## 💡 TIPS FINALES

1. **Trabaja con un canal a la vez**: Primero haz funcionar el derecho, luego el izquierdo
2. **Usa el multímetro constantemente**: No confíes solo en la vista
3. **Revisa continuidad**: Asegúrate que los cables/protoboard hacen buen contacto
4. **Fotos del montaje**: Toma fotos para comparar con el diagrama
5. **Paciencia**: Electrónica requiere meticulosidad

---

**¡Buena suerte con el diagnóstico!** 🔧

Si necesitas ayuda con algún paso específico, pregunta.
