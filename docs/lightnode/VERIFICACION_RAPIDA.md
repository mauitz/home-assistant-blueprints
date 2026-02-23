# LightNode - Verificación Rápida de Conexiones

## ⚡ DIAGNÓSTICO RÁPIDO (5 MINUTOS)

**Situación**: Las luces no encienden al activar los switches en Home Assistant

---

## 🔴 PASO 1: PRUEBA DE SOFTWARE (2 min)

### En Home Assistant

```
1. Abre: http://192.168.1.100:8123
2. Ve a: Configuración → Dispositivos → "LightNode Entrance"
3. Configura:
   ├─ "1. Control Automático" → OFF  ❌
   ├─ "4. Dimmer Derecha" → 100%     ━━━━━━━━━━ 
   └─ "3. Luz Derecha" → ON           🟦
```

### ¿Qué debería pasar?

```
✅ SI FUNCIONA:
   - Guirnalda derecha enciende
   - Problema resuelto ✓

❌ NO FUNCIONA:
   - Continúa al PASO 2
```

---

## 🟠 PASO 2: PRUEBA DE GUIRNALDA (2 min)

### Prueba Directa a 5V

```
Material: Guirnalda LED, ESP32

1. APAGA el ESP32 (desconecta USB)
2. Desconecta la guirnalda del circuito
3. Conecta directamente:
   
   Guirnalda (+) ROJO  ──► Pin 5V del ESP32
   Guirnalda (-) NEGRO ──► Pin GND del ESP32
   
4. Conecta USB al ESP32
```

### ¿Qué debería pasar?

```
✅ ENCIENDE:
   - La guirnalda funciona
   - El problema está en el CIRCUITO DE CONTROL
   - Continúa al PASO 3

❌ NO ENCIENDE:
   - La guirnalda está DEFECTUOSA o mal pelada
   - Verifica:
     • Cables pelados correctamente
     • Polaridad correcta (+/-)
     • Prueba con la otra guirnalda
```

---

## 🟡 PASO 3: VERIFICAR TRANSISTOR BC337

### Identificar Orientación

Vista FRONTAL del BC337 (cara plana hacia ti):

```
     _PLANO_
    /       \
   |   BC337 |  ← Lado con texto impreso
   |_________|
    │   │   │
    C   B   E

    │   │   │
    │   │   └──► E = EMISOR (derecha)
    │   └──────► B = BASE (centro)
    └──────────► C = COLECTOR (izquierda)
```

### Verificar Conexiones (Canal Derecho)

```
COLECTOR (izquierda): 
  ├─ Cable que viene de: R4 (30Ω = 3 resistencias de 10Ω)
  └─ R4 conectada a: LED Derecha cable NEGRO (-)

BASE (centro):
  ├─ Cable que viene de: R3 (resistencia 1kΩ)
  └─ R3 conectada a: GPIO 26 del ESP32

EMISOR (derecha):
  └─ Cable que va a: GND común (negro)
```

### Diagrama Simplificado

```
LED Derecha (-)
     │
     │ Negro
     ▼
   [R4] 30Ω (3×10Ω en serie)
     │
     ▼
   COLECTOR ←── Pin IZQUIERDO del BC337
     │
   BASE     ←── Pin CENTRO del BC337 ←─[R3 1kΩ]← GPIO 26
     │
   EMISOR   ←── Pin DERECHO del BC337
     │
     ▼
    GND
```

---

## 🟢 PASO 4: PRUEBA CON MULTÍMETRO (1 min)

### Verificar que GPIO Envía Señal

```
Material: Multímetro en modo voltaje DC

1. En HA: "3. Luz Derecha" → ON, Dimmer 100%
2. Multímetro:
   - Punta ROJA: GPIO 26
   - Punta NEGRA: GND
   
Lectura esperada: ~3.3V

Resultado:
  ✅ 3.3V: GPIO funciona, problema en TRANSISTOR/CONEXIONES
  ❌ 0V: Problema en SOFTWARE o ESP32
```

### Verificar Transistor Conduce

```
Material: Multímetro en modo voltaje DC

Con "Luz Derecha" ON:

1. Medir Colector-Emisor:
   - Punta ROJA: Colector (pin izquierdo BC337)
   - Punta NEGRA: Emisor (pin derecho BC337)
   
Lectura esperada: <0.3V (casi 0V)

Resultado:
  ✅ <0.3V: Transistor CONDUCE correctamente
  ❌ >1V: Transistor NO conduce, problema en:
          • Conexión Base incorrecta
          • R3 (1kΩ) faltante
          • Transistor quemado/mal orientado
```

---

## 📸 FOTOS DE REFERENCIA

### Conexión Correcta del BC337

```
Vista desde arriba del protoboard:

  GPIO26 ──[R3]──┐
                 │
  LED(-)─[R4]────●─── Pin COLECTOR (izq)
                 │
                 ●─── Pin BASE (centro)
                 │
  GND ───────────●─── Pin EMISOR (der)
  
  ● = Orificio del protoboard
```

### Resistencias Correctas

```
R3 (Base): 1kΩ
  Colores: MARRÓN-NEGRO-ROJO-Dorado
           │      │     │    │
           1      0     ×100 ±5%
  
R4 (Limitadora): 3×10Ω en SERIE
  Cada una: MARRÓN-NEGRO-NEGRO-Dorado
            │      │     │      │
            1      0     ×1     ±5%
  
  ⚠️ IMPORTANTE: Las 3 resistencias de 10Ω deben estar 
     conectadas EN SERIE (una tras otra), NO en paralelo
     
     CORRECTO:   [10Ω]───[10Ω]───[10Ω]  = 30Ω total
     INCORRECTO: [10Ω]
                 [10Ω]  = 3.3Ω total ❌
                 [10Ω]
```

---

## 🔍 CHECKLIST VISUAL RÁPIDO

### Verificar a Simple Vista

```
Canal Derecho (LED Derecha):

[ ] ESP32 Pin 5V tiene cable ROJO hacia LED(+)
[ ] LED Derecha cable NEGRO conectado a una resistencia
[ ] Hay 3 resistencias de 10Ω (marrón-negro-negro) en SERIE
[ ] Las 3 resistencias van al pin IZQUIERDO del BC337
[ ] Hay una resistencia 1kΩ (marrón-negro-rojo)
[ ] La 1kΩ conecta GPIO 26 con pin CENTRO del BC337
[ ] Pin DERECHO del BC337 va a GND (cable negro)
[ ] Transistor BC337 cara PLANA hacia el frente
```

---

## 🎯 PROBLEMAS MÁS COMUNES

### 1. Transistor al Revés

```
SÍNTOMA: GPIO mide 3.3V pero LED no enciende

CAUSA: BC337 girado 180°
       Colector y Emisor intercambiados

SOLUCIÓN:
  1. Saca el transistor del protoboard
  2. Gíralo 180° (cara plana debe estar hacia ti)
  3. Reinserta en el mismo sitio
```

### 2. Resistencias de 10Ω en Paralelo

```
SÍNTOMA: LED enciende MUY BRILLANTE incluso al 10%
         LED puede quemarse o atenuarse

CAUSA: Las 3 resistencias de 10Ω están en paralelo
       Resistencia total = 3.3Ω (muy baja)
       
SOLUCIÓN:
  Conectarlas EN SERIE (una tras otra):
  LED(-) → [10Ω] → [10Ω] → [10Ω] → Colector
```

### 3. Resistencia de Base Incorrecta

```
SÍNTOMA: GPIO mide 3.3V pero transistor no conduce

CAUSA: R3 no es 1kΩ o está mal conectada
       
SOLUCIÓN:
  1. Verificar código de colores: Marrón-Negro-Rojo
  2. Medir con multímetro: ~1000Ω
  3. Verificar conexión: GPIO 26 → R3 → Base
```

---

## 💡 PRUEBA DEFINITIVA: JUMPER DIRECTO

### Bypass del Circuito

Si todo lo anterior falla, prueba esto:

```
Material: Cable jumper

PRUEBA:
1. Mantén "3. Luz Derecha" ON en HA
2. Con un jumper, conecta TEMPORALMENTE:
   
   Pin 3.3V del ESP32 ──► Base del BC337 (pin centro)
   
3. ¿Qué pasa?

Resultado:
  ✅ LED ENCIENDE:
     - Transistor funciona
     - Problema en GPIO 26 o R3
     - Verifica:
       • GPIO 26 mide 3.3V?
       • R3 (1kΩ) está presente?
       • R3 conectada correctamente?
  
  ❌ NO ENCIENDE:
     - Problema en transistor o circuito LED
     - Verifica:
       • Transistor orientación
       • R4 (30Ω) presente
       • Conexión LED(-) a R4 a Colector
       • 5V llegando a LED(+)
```

---

## 📊 TABLA DE DIAGNÓSTICO

| Prueba | Resultado | Qué Significa | Siguiente Paso |
|--------|-----------|---------------|----------------|
| Switch ON en HA | LED enciende | ✅ TODO FUNCIONA | ¡Disfruta! |
| Switch ON en HA | LED no enciende | ❌ Problema hardware | → Paso 2 |
| LED directo 5V | Enciende | ✅ LED funciona | → Paso 3 |
| LED directo 5V | No enciende | ❌ LED defectuosa | Reemplazar LED |
| GPIO 26 voltaje | 3.3V | ✅ Software OK | → Verificar transistor |
| GPIO 26 voltaje | 0V | ❌ Software/ESP32 | Ver logs ESPHome |
| Colector-Emisor | <0.3V | ✅ Transistor conduce | → Verificar R4 y LED(-) |
| Colector-Emisor | >1V | ❌ Transistor no conduce | Orientación/Base/R3 |
| Jumper 3.3V→Base | LED enciende | ✅ Transistor OK | Problema en GPIO/R3 |
| Jumper 3.3V→Base | No enciende | ❌ Circuito LED | R4/Conexiones LED |

---

## 🆘 SI SIGUES ATASCADO

### Documentación Completa

Lee el documento completo de troubleshooting:

```
docs/lightnode/TROUBLESHOOTING_LUCES.md
```

Incluye:
- ✅ Procedimiento detallado con multímetro
- ✅ Pruebas de cada componente
- ✅ Diagramas de voltajes esperados
- ✅ Soluciones a 10+ problemas comunes

### Ejecutar Script de Diagnóstico

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
./utils/test_lightnode_leds.sh
```

Este script:
- Verifica conectividad
- Muestra logs en tiempo real
- Da instrucciones paso a paso

---

## ✅ RESUMEN RÁPIDO

```
1. Prueba switch en HA
   └─ ❌ No funciona
       │
2. Prueba LED directo a 5V
   └─ ✅ Funciona
       │
3. Verifica transistor BC337:
   ├─ Orientación correcta (plano hacia ti)
   ├─ Pin IZQUIERDO: Colector → R4 → LED(-)
   ├─ Pin CENTRO: Base ← R3 ← GPIO 26
   └─ Pin DERECHO: Emisor → GND
       │
4. Mide con multímetro:
   ├─ GPIO 26: debe ser 3.3V (con switch ON)
   └─ Colector-Emisor: debe ser <0.3V (transistor conduciendo)
       │
5. Si todo mide correcto pero no enciende:
   └─ Verifica conexiones LED(-) → R4 → Colector
```

---

**¡Sigue estos pasos y encuentra el problema!** 🔧

La mayoría de los casos son:
- 🥇 Transistor al revés (60%)
- 🥈 Resistencia R3 faltante/incorrecta (20%)
- 🥉 Conexión floja en protoboard (15%)
- 🏅 LED defectuosa o mal pelada (5%)
