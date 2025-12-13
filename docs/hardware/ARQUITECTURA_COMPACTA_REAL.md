# 🏗️ Arquitectura Compacta Real - Módulo de Riego

## 📐 Diseño Actualizado con Tu Protoboard Real

**Protoboard:** ~9x15 cm (la que tienes)
**Caja Stanco:** 13x19x10 cm (bordes redondeados)
**Principio:** Protoboard = Solo electrónica central, Sensores = Montados en caja

---

## 🎯 Nuevo Enfoque de Diseño

### **Distribución de Componentes:**

```
┌─────────────────────────────────────────────────────┐
│  CAJA STANCO 13x19x10 cm                            │
│                                                     │
│  ┌────────────────────────────────────────────┐    │
│  │ PARED LATERAL IZQUIERDA                    │    │
│  │                                            │    │
│  │  ┌──────┐    ┌─────┐                      │    │
│  │  │DHT11 │    │ LDR │   (Pegados con      │    │
│  │  │ 🌡️   │    │ ☀️  │    silicona/         │    │
│  │  └──┬───┘    └──┬──┘    hot glue)         │    │
│  │     │cables    │cables                    │    │
│  └─────┼──────────┼──────────────────────────┘    │
│        │          │                                │
│        ↓          ↓                                │
│  ┌──────────────────────────────────────────┐     │
│  │ INTERIOR CAJA                            │     │
│  │                                          │     │
│  │  ┌────────────────────┐  ┌────────────┐ │     │
│  │  │   PROTOBOARD       │  │  MÓDULO    │ │     │
│  │  │   (componentes     │  │  RELÉS     │ │     │
│  │  │    críticos)       │  │  6 canales │ │     │
│  │  │                    │  │            │ │     │
│  │  │  [ESP32]           │  │ ┌───────┐  │ │     │
│  │  │  [Regulador]       │  │ │Relés  │  │ │     │
│  │  │  [Borneras]        │  │ │1-6    │  │ │     │
│  │  │                    │  │ └───────┘  │ │     │
│  │  └────────────────────┘  └────────────┘ │     │
│  │                                          │     │
│  │  Separadores 10mm altura                 │     │
│  └──────────────────────────────────────────┘     │
│                                                     │
│  ┌────────────────────────────────────────────┐    │
│  │ PARED LATERAL DERECHA                      │    │
│  │                                            │    │
│  │     ┌──────────┐                          │    │
│  │     │ LD2410C  │  (mmWave atraviesa       │    │
│  │     │  📡      │   plástico, no           │    │
│  │     └────┬─────┘   necesita agujero)      │    │
│  │          │cables                           │    │
│  └──────────┼─────────────────────────────────┘    │
│             ↓                                       │
│                                                     │
│  ┌────────────────────────────────────────────┐    │
│  │ TAPA INFERIOR (hacia abajo)                │    │
│  │                                            │    │
│  │  ┌─────────┐  ┌─────────┐                 │    │
│  │  │Agujero 1│  │Agujero 2│                 │    │
│  │  │ (para    │  │ (para    │                │    │
│  │  │  HC-SR04)│  │  HC-SR04)│                │    │
│  │  └─────────┘  └─────────┘                 │    │
│  │                                            │    │
│  │  Cable HC-SR04 →→→ Dentro del reservorio  │    │
│  └────────────────────────────────────────────┘    │
│                                                     │
│  PEGADO:                                            │
│  Tapa caja ═══ Tapa reservorio                     │
│  (HC-SR04 siempre fijo en el agua)                 │
└─────────────────────────────────────────────────────┘
```

---

## 📐 LAYOUT PROTOBOARD COMPACTA

### **Vista Superior de Tu Protoboard:**

```
┌──────────────────────────────────────────────────────────┐
│  PROTOBOARD ~9x15 cm (Tu protoboard real)               │
│                                                          │
│  ┌──────────────┐  ┌─────────────────┐                 │
│  │ ZONA 1       │  │ ZONA 2          │                 │
│  │ ALIMENTACIÓN │  │ ESP32 30-pin    │                 │
│  │              │  │                 │                 │
│  │ [Bornera 5V] │  │  ┌───────────┐  │                 │
│  │ [AMS1117]    │  │  │  ESP32    │  │                 │
│  │ [Cond.]      │  │  │  WROOM-32 │  │                 │
│  │              │  │  │           │  │                 │
│  │ Rieles:      │  │  │  Headers  │  │                 │
│  │ [+5V]═══════════════╪═══════════╪══╗                │
│  │ [+3.3V]═════════════╪═══════════╪══╣                │
│  │ [GND]═══════════════╪═══════════╪══╣                │
│  │ [GND]═══════════════╪═══════════╪══╝                │
│  └──────────────┘  │  └───────────┘  │                 │
│                    │      USB ↓      │                 │
│                    └─────────────────┘                 │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │ ZONA 3: BORNERAS (Todas las conexiones externas)│  │
│  │                                                  │  │
│  │ [DHT11]  [LDR]  [HC-SR04]  [LD2410C]  [Relés]   │  │
│  │  3-pin   2-pin    4-pin      4-pin     7-pin    │  │
│  │                                                  │  │
│  │ [Hum.Suelo]  [Bombas conexión a relés]          │  │
│  │   3-pin           6x2-pin                        │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │ ZONA 4: LEDs (compacto)                          │  │
│  │                                                  │  │
│  │ [R220Ω] [R220Ω] [R220Ω] [R220Ω] [R220Ω]         │  │
│  │   ↓       ↓       ↓       ↓       ↓             │  │
│  │ [LED1]  [LED2]  [LED3]  [LED4]  [LED5]          │  │
│  │  🟢      🔴      🟡      🔵      ⚪              │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │ ZONA 5: LDR Divisor                              │  │
│  │ [R 10kΩ] (entre 3.3V y GPIO35)                   │  │
│  └──────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘

NOTA: NO hay espacio para módulo relés en la protoboard
      → Se monta separado en la caja
```

---

## 🔧 MONTAJE DE COMPONENTES EN CAJA

### **1. Protoboard (Base de la Caja)**

**Montaje:**
```
┌────────────────────────────┐
│ Fondo de Caja Stanco       │
│                            │
│  ┌─────────────────────┐   │
│  │                     │   │
│  │   PROTOBOARD        │   │
│  │   (sobre            │   │
│  │   separadores)      │   │
│  │                     │   │
│  └─────────────────────┘   │
│      ↑           ↑         │
│   Separador  Separador     │
│   10-15mm    10-15mm       │
└────────────────────────────┘
```

**Fijación:**
- 4 separadores de nylon M3 (10-15mm)
- Atornillar desde exterior de caja
- Cinta doble cara como respaldo

---

### **2. Módulo Relés (Junto a Protoboard)**

**Montaje:**
```
┌──────────────────────────────┐
│ Interior Caja                │
│                              │
│  [Protoboard]  [Módulo Relés]│
│      ↓              ↓        │
│   Separadores   Tornillos    │
│   o cinta       o cinta      │
└──────────────────────────────┘
```

**Conexión:**
- Cables cortos (10-15cm) desde protoboard a módulo
- VCC/GND desde rieles de protoboard
- IN1-IN6 desde GPIOs del ESP32 (bornera intermedia)

**Fijación del módulo relés:**
- **Opción A:** Tornillos M3 si tiene agujeros
- **Opción B:** Cinta doble cara foam (3M VHB)
- **Opción C:** Pegamento hot glue

---

### **3. DHT11 (Pared Lateral Izquierda)**

**Ubicación:** Interior de pared lateral, con ventilación

**Montaje:**
```
EXTERIOR CAJA          INTERIOR CAJA
=============          =============

   [Aire]              ┌──────────┐
     ↓                 │  DHT11   │
  ┌─────┐              │  módulo  │
  │ ∙∙∙ │ ← Agujeros   │          │
  │ ∙∙∙ │   pequeños   └────┬─────┘
  └─────┘   (2-3mm)         │
     │                      │
  Pared plástico         Cable 3 hilos
                         (20-30cm)
                            │
                            ↓
                      [Bornera en
                       protoboard]
```

**Pasos:**
1. Perforar 6-8 agujeros pequeños (2-3mm) en pared lateral
2. Montar DHT11 con **silicona** o **hot glue** por dentro
3. DHT11 queda pegado mirando hacia los agujeros
4. Cable de 20-30cm hacia protoboard (bornera 3 pines)

**Cables:**
```
DHT11 → Cable → Bornera protoboard
VCC   → Rojo  → Pin 1 (3.3V)
DATA  → Amarillo → Pin 2 (GPIO27)
GND   → Negro → Pin 3 (GND)
```

---

### **4. LDR (Pared Lateral Izquierda, junto a DHT11)**

**Ubicación:** Cerca del DHT11, orientado hacia fuera

**Montaje:**
```
EXTERIOR CAJA          INTERIOR CAJA
=============          =============

   [Luz solar]
     ↓
  ┌──────┐             [Resistor 10kΩ]
  │  ○   │ ← LDR         en protoboard
  │      │   visible         ↑
  └──────┘   desde       Cable 2 hilos
     │       exterior    (20-30cm)
  Pared plástico            │
                            ↓
                      [Bornera en
                       protoboard]
```

**Opciones de montaje:**

**Opción A: Agujero transparente**
1. Perforar agujero 5mm en pared
2. Insertar LDR desde interior
3. Fijar con silicona transparente o hot glue
4. LDR "asoma" al exterior (recibe luz directa)

**Opción B: Interior con plástico traslúcido**
1. Pegar LDR por dentro de la pared
2. Marcar zona exterior con esmalte transparente
3. LDR recibe luz a través del plástico

**Recomendación:** Opción A (más preciso)

**Cables:**
```
LDR → Cable → Bornera protoboard
Pin 1 → Amarillo → Pin 1 (a GPIO35 vía divisor)
Pin 2 → Negro → Pin 2 (GND)
```

**Divisor resistivo en protoboard:**
```
Riel 3.3V ━━━┬━━━━━━━ (riel)
             │
           [R 10kΩ] ← Soldado en protoboard
             │
             ├━━━━━→ GPIO35 (ADC)
             │
         [Bornera LDR pin 1]
             │
         [Bornera LDR pin 2] ━━━→ GND
```

---

### **5. LD2410C (Pared Lateral Derecha)**

**Ubicación:** Pared opuesta, orientado hacia donde quieres detectar presencia

**Ventaja mmWave:** El radar **atraviesa plástico** perfectamente, no necesita agujeros

**Montaje:**
```
EXTERIOR CAJA          INTERIOR CAJA
=============          =============

   [Persona]           ┌───────────┐
     ↓                 │  LD2410C  │
  ┌─────────┐          │  📡       │
  │         │ ←────────│  módulo   │
  │  CAJA   │  Ondas   │           │
  │         │  mmWave  └─────┬─────┘
  └─────────┘  atraviesan    │
     │         plástico    Cable 4 hilos
  Pared plástico          (30-40cm)
  (sin agujeros)              │
                              ↓
                        [Bornera en
                         protoboard]
```

**Pasos:**
1. **NO perforar** la pared (el radar atraviesa)
2. Pegar LD2410C con **cinta doble cara** o **hot glue** por dentro
3. Orientar la antena perpendicular a la pared
4. Cable de 30-40cm hacia protoboard

**Cables:**
```
LD2410C → Cable → Bornera protoboard
VCC     → Rojo  → Pin 1 (5V)
TX      → Verde → Pin 2 (GPIO32)
RX      → Azul  → Pin 3 (GPIO33)
GND     → Negro → Pin 4 (GND)
```

**Orientación óptima:**
```
Vista desde arriba:

PARED CAJA
==========
    │
    │  [LD2410C]  ← Antena apuntando →→→
    │   ══════    perpendicular a pared
    │
```

---

### **6. HC-SR04 (Tapa Inferior + Tapa Reservorio)**

**Ubicación:** En tapa de la caja (que va hacia abajo) y atraviesa tapa del reservorio

**Concepto:**
```
┌────────────────────────────────────────────────┐
│  CAJA STANCO (cerrada, tapa abajo)             │
│  ┌──────────────────────────────────────────┐  │
│  │ Contenido: Protoboard + módulo relés     │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  TAPA INFERIOR (hacia abajo)                   │
│  ┌──────────────────────────────────────────┐  │
│  │  ┌───┐     ┌───┐                         │  │
│  │  │ ∙ │     │ ∙ │  ← Agujeros para        │  │
│  │  │ T │     │ E │     TRIG y ECHO         │  │
│  │  └─┬─┘     └─┬─┘                         │  │
│  └────┼─────────┼───────────────────────────┘  │
│       │         │                               │
│       │  Cables atraviesan                      │
│       ↓         ↓                               │
└───────┼─────────┼───────────────────────────────┘
        │         │
════════╪═════════╪═══════════════════════════════
  TAPA RESERVORIO (pegada a tapa caja)
════════╪═════════╪═══════════════════════════════
        │  ┌───┐  │
        │  │ ∙ │  │  ← Agujeros alineados
        │  │ ∙ │  │
        │  └───┘  │
════════╪═════════╪═══════════════════════════════
        │         │
        │ ┌─────────────┐
        └─┤  HC-SR04    │  ← Sensor dentro del agua
          │  montado en │
          │  soporte    │
          └─────────────┘
              │
          AGUA DEL TANQUE
```

**Montaje Paso a Paso:**

**1. Preparar Tapa de Caja:**
```
Tapa inferior caja:
┌──────────────────────┐
│                      │
│  ○ TRIG  ○ ECHO      │ ← 2 agujeros (5-6mm)
│   (15mm separados)   │
│                      │
└──────────────────────┘
```

**2. Preparar Tapa de Reservorio:**
```
Tapa reservorio:
┌──────────────────────┐
│                      │
│  ○ TRIG  ○ ECHO      │ ← 2 agujeros alineados
│                      │
│ (alinear con tapa    │
│  de la caja)         │
└──────────────────────┘
```

**3. Pasar Cables:**
- Cable 4 hilos (1 metro o más)
- Desde protoboard → interior caja → tapa caja → tapa reservorio → sensor en agua

**4. Montar HC-SR04:**
```
Opciones:

A) En soporte flotante:
   [Flotador]
       │
   [HC-SR04] ← Sensores hacia abajo
       │
   [Contrapeso]

B) Colgado desde tapa:
   Tapa reservorio
       │
   [Cables]
       │
   [HC-SR04] ← A ~5cm de la tapa
```

**5. Pegar Tapas:**
- Aplicar **silicona** o **pegamento impermeable** en perímetro
- Alinear agujeros
- Presionar y dejar secar 24h
- Tapas quedan **permanentemente unidas**

**Cables:**
```
HC-SR04 → Cable (1m) → Bornera protoboard
VCC     → Rojo       → Pin 1 (5V)
TRIG    → Amarillo   → Pin 2 (GPIO13)
ECHO    → Verde      → Pin 3 (GPIO14)
GND     → Negro      → Pin 4 (GND)
```

**Sellado:**
- Usar **prensaestopa IP68** donde cable entra a caja
- Silicona adicional en agujeros de tapas
- HC-SR04 debe ser **resistente al agua** (muchos modelos lo son)

---

## 🔌 CONEXIONES EN PROTOBOARD

### **Resumen de Borneras Necesarias:**

| Componente | Bornera | Conexión | Ubicación |
|------------|---------|----------|-----------|
| **Alimentación 5V** | 2 pines | Entrada DC | ZONA 1 |
| **DHT11** | 3 pines | VCC, DATA, GND | ZONA 3 |
| **LDR** | 2 pines | Signal, GND | ZONA 3 |
| **HC-SR04** | 4 pines | VCC, TRIG, ECHO, GND | ZONA 3 |
| **LD2410C** | 4 pines | VCC, TX, RX, GND | ZONA 3 |
| **Hum. Suelo** | 3 pines | VCC, AOUT, GND | ZONA 3 |
| **Relés Control** | 7 pines | IN1-6, GND | ZONA 3 |
| **Relés Poder** | 2 pines | VCC, GND | ZONA 3 |
| **Bombas** | 12 pines (6x2) | Salidas relés | Externo |

**Total borneras:** ~37 pines

**Distribución en protoboard:**
- Usar borneras modulares de 2/3/4 pines (apilables)
- Ubicar todas en un borde (ZONA 3)
- Acceso fácil para conectar/desconectar

---

## 📏 DIMENSIONES Y UBICACIONES

### **Caja Stanco 13x19x10 cm:**

```
Vista Superior (tapa abierta):
┌─────────────────────────────┐  ← 19 cm
│                             │
│  DHT11+LDR                  │
│    ┌─┐                      │
│    └─┘                      │
│                      ┌───┐  │
│                      │LD │  │  ← LD2410C
│                      │24 │  │
│   ┌──────────┐       │10 │  │
│   │Protoboard│       └───┘  │
│   │          │              │
│   │  ESP32   │  [Relés]     │
│   │          │   6ch        │
│   └──────────┘              │
│                             │
└─────────────────────────────┘
      ↑
    13 cm

Vista Lateral:
┌─────────────────────┐
│ ┌─┐            ┌──┐ │ ← DHT11, LD2410C en paredes
│ └─┘            └──┘ │
│                     │
│  ┌──────┐  ┌────┐  │ ← Protoboard + Relés elevados
│  │Proto │  │Relé│  │
│  └──────┘  └────┘  │  10 cm altura
│     ↑        ↑     │
│  Separadores       │
├─────────────────────┤
│ TAPA (con agujeros) │ ← HC-SR04 cables
└─────────────────────┘
```

---

## ⚡ ALIMENTACIÓN

### **Entrada a la Caja:**

```
Exterior           Interior Caja
========           =============

[Fuente 5V]
  +  -
   ││
   ││ ──→ [Prensaestopa]──→ [Bornera 5V]
   ││                           │
Cable DC 2 hilos            Protoboard
(12-18 AWG)                 ZONA 1
```

**Prensaestopa:**
- PG7 o PG9 (IP68)
- Sellado hermético
- Entrada lateral de caja (abajo)

**Distribución interna:**
```
Bornera 5V ━━━┳━━━→ Riel 5V (protoboard)
              │      ├─→ ESP32 VIN
              │      ├─→ HC-SR04 VCC
              │      ├─→ LD2410C VCC
              │      └─→ Módulo Relés VCC
              │
              ├━━━→ Regulador AMS1117 → Riel 3.3V
              │                           ├─→ DHT11 VCC
              │                           ├─→ Sensor Hum. VCC
              │                           └─→ LDR divisor
              │
              └━━━→ Riel GND (común a todo)
```

---

## 🛠️ ORDEN DE CONSTRUCCIÓN ACTUALIZADO

### **FASE 1: Protoboard (2-3 horas)**

1. ✅ Crear rieles de alimentación (4 rieles: 5V, 3.3V, GND x2)
2. ✅ Soldar regulador AMS1117 + condensadores
3. ✅ Soldar headers para ESP32 (2x15 pines)
4. ✅ Soldar todas las borneras en ZONA 3
5. ✅ Soldar LEDs + resistencias 220Ω
6. ✅ Soldar divisor resistivo LDR (R 10kΩ)
7. ✅ Cablear conexiones ESP32 ↔ borneras
8. ✅ **PROBAR**: Alimentación 5V y 3.3V correctos

---

### **FASE 2: Preparar Sensores (1-2 horas)**

**DHT11:**
1. Soldar cable 3 hilos (20-30cm)
2. Termocontraíble en soldaduras
3. Conector JST opcional (desconexión fácil)

**LDR:**
1. Soldar cable 2 hilos (20-30cm)
2. Termocontraíble
3. Identificar polaridad (si aplica)

**LD2410C:**
1. Soldar cable 4 hilos (30-40cm)
2. Termocontraíble
3. Conector JST opcional

**HC-SR04:**
1. Soldar cable 4 hilos (1 metro)
2. Termocontraíble reforzado (va al agua)
3. Impermeabilizar soldaduras (silicona)

---

### **FASE 3: Preparar Caja (1 hora)**

**Perforaciones:**

1. **Pared lateral izquierda (DHT11):**
   - 6-8 agujeros 2-3mm (ventilación)
   - Patrón cuadrícula 2x3

2. **Pared lateral izquierda (LDR):**
   - 1 agujero 5mm (insertar LDR)
   - A 3-5cm del DHT11

3. **Tapa inferior (HC-SR04):**
   - 2 agujeros 5-6mm separados 15mm
   - Centrados en la tapa

4. **Entrada alimentación:**
   - 1 agujero para prensaestopa PG7/PG9
   - Lateral inferior de la caja

5. **Salidas bombas:**
   - 1-2 prensaestopas PG11/PG13 (cables gruesos)
   - Lateral opuesto a alimentación

**Fondo caja:**
- 4 agujeros M3 para separadores (esquinas)

---

### **FASE 4: Montar en Caja (2 horas)**

**Orden:**

1. **Instalar prensaestopas** (desde exterior)
2. **Fijar separadores** en fondo (desde exterior)
3. **Montar protoboard** sobre separadores
4. **Montar módulo relés** junto a protoboard
5. **Conectar alimentación** desde prensaestopa a bornera
6. **Pegar DHT11** en pared lateral (hot glue/silicona)
7. **Pegar LDR** en agujero de pared
8. **Pegar LD2410C** en pared opuesta
9. **Conectar todos los sensores** a borneras de protoboard
10. **Cablear módulo relés** (IN1-6, VCC, GND)

---

### **FASE 5: Tapa y Sensor de Nivel (1 hora)**

**HC-SR04 en Reservorio:**

1. **Preparar tapa de caja:**
   - Perforar 2 agujeros (ya hecho)
   - Pasar cable desde interior

2. **Preparar tapa de reservorio:**
   - Perforar 2 agujeros alineados
   - Pasar cable hacia interior tanque

3. **Montar HC-SR04:**
   - Opción A: Flotador con sensor
   - Opción B: Suspendido desde tapa

4. **Pegar tapas:**
   - Aplicar silicona en perímetro
   - Alinear agujeros perfectamente
   - Presionar y dejar secar 24h

5. **Sellar:**
   - Silicona adicional en agujeros
   - Prensaestopa donde cable entra a caja

---

## 🧪 PRUEBAS FINALES

### **Prueba 1: Alimentación**
```bash
Con caja abierta:
✓ Medir 5V en riel
✓ Medir 3.3V en riel
✓ Regulador no se calienta
```

### **Prueba 2: ESP32 y Sensores Internos**
```bash
Conectar a HA:
✓ ESP32 visible en HA
✓ LEDs funcionan (5 de 5)
✓ Relés hacen click (6 de 6)
```

### **Prueba 3: Sensores en Paredes**
```bash
Con caja cerrada:
✓ DHT11 lee temperatura (~20-25°C)
✓ LDR varía con luz (cubrir/descubrir)
✓ LD2410C detecta presencia (mover mano)
```

### **Prueba 4: HC-SR04 en Tanque**
```bash
Con tanque lleno:
✓ HC-SR04 lee distancia
✓ Nivel aumenta/disminuye al llenar/vaciar
✓ Sin fugas en tapas pegadas
```

---

## ✅ CHECKLIST DE MATERIALES ACTUALIZADO

### **Protoboard:**
- [x] 1x Protoboard ~9x15cm (la que tienes)
- [x] Headers hembra 2x15 pines
- [x] Regulador AMS1117-3.3V
- [x] Condensadores 100µF, 10µF
- [x] 5x LEDs + 5x R 220Ω
- [x] 2x R 10kΩ (LDR divisor + DHT11 si necesario)
- [x] Borneras: 2p(x3), 3p(x3), 4p(x3), 7p(x1), 12p(x1)
- [x] Cable AWG22/24 multicolor (10m)

### **Sensores con Cable:**
- [x] DHT11 + cable 3 hilos (30cm)
- [x] LDR + cable 2 hilos (30cm)
- [x] LD2410C + cable 4 hilos (40cm)
- [x] HC-SR04 + cable 4 hilos (1m)
- [x] Sensor humedad suelo + cable 3 hilos (3-5m)

### **Caja y Montaje:**
- [x] Caja Stanco 13x19x10 cm (la que tienes)
- [x] 4x Separadores nylon M3 (10-15mm)
- [x] 4x Tornillos M3 + tuercas
- [x] 3-4x Prensaestopas PG7/PG9/PG11
- [x] Silicona impermeable (sellado)
- [x] Hot glue o silicona adhesiva (sensores)
- [x] Cinta doble cara foam (módulo relés)

### **Herramientas:**
- [x] Soldador + estaño
- [x] Multímetro ⚠️
- [x] Taladro + brocas (2mm, 3mm, 5mm, 7mm)
- [x] Pistola hot glue (opcional)
- [x] Pelacables, alicate corte, pinzas

---

## 📊 VENTAJAS DE ESTE DISEÑO

✅ **Compacto:** Aprovecha toda la protoboard
✅ **Modular:** Sensores desconectables vía borneras
✅ **Accesible:** ESP32 removible (headers)
✅ **Profesional:** Componentes en ubicaciones óptimas
✅ **Mantenible:** Fácil acceso a todo sin desoldar
✅ **Robusto:** Sellado IP65, protección contra humedad
✅ **Preciso:** Sensores en ubicaciones correctas (DHT11 con aire, LDR con luz)

---

**Versión:** 2.0 (Diseño Compacto Real)
**Fecha:** Diciembre 2024
**Hardware:** Protoboard 9x15cm + Caja 13x19x10cm
**Autor:** @mauitz

