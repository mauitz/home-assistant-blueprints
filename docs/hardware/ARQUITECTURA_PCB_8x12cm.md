# 🏗️ Arquitectura Definitiva - PCB 8×12 cm

## 📐 Hardware Final Confirmado

**PCB:** 8 × 12 cm (fibra de vidrio)
**ESP32:** 30-pin WROOM-32 (5×2.5 cm)
**Caja:** Stanco 13×19×10 cm
**Proveedor:** Autoelectronica5G - Maldonado, Uruguay

---

## 🎯 Principios de Diseño

### **Distribución en Caja:**

```
┌─────────────────────────────────────────────────┐
│  CAJA STANCO 13×19×10 cm                        │
│                                                 │
│  ┌────────────────┐                            │
│  │ PCB 8×12 cm    │  ← Montada en fondo        │
│  │ (componentes   │     con separadores        │
│  │  centrales)    │                            │
│  └────────────────┘                            │
│                                                 │
│  ┌──────────┐                                  │
│  │ MÓDULO   │  ← Al lado, cables cortos        │
│  │ RELÉS 6CH│                                   │
│  └──────────┘                                  │
│                                                 │
│  SENSORES EXTERNOS (montados en paredes):      │
│  - DHT11: Pared izq. con ventilación           │
│  - LDR: Pared izq. con luz directa             │
│  - LD2410C: Pared der. (radar atraviesa)       │
│  - HC-SR04: Tapa inferior → agua reservorio    │
└─────────────────────────────────────────────────┘
```

---

## 📏 LAYOUT PCB 8×12 cm

### **Vista Superior (Distribución Completa):**

```
┌────────────────────────────────────────────────────────────┐
│  PCB 8×12 cm - Sistema de Riego Inteligente               │
│                                                            │
│  ←────────────────── 12 cm ──────────────────→            │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐ │
│  │ ZONA 1: ALIMENTACIÓN Y REGULACIÓN                    │ │
│  │                                                      │ │
│  │ [Bornera 2p] ──→ [AMS1117-3.3V] ──→ [Rieles]        │ │
│  │   5V entrada      IN OUT GND         5V 3.3V GND    │ │
│  │                   │  │  │                           │ │
│  │                [C1][C2]                             │ │
│  │               100µF 10µF                            │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐ │  ↑
│  │ ZONA 2: ESP32 30-pin (Centro)                        │ │  │
│  │                                                      │ │  │
│  │  ┌────────────────────────────────────────┐          │ │  │
│  │  │  ESP32-WROOM-32  (5 × 2.5 cm)         │          │ │  8
│  │  │                                        │          │ │  c
│  │  │  Headers hembra 2×15 pines             │          │ │  m
│  │  │  (ESP32 removible para mantenimiento)  │          │ │  │
│  │  │                                        │          │ │  │
│  │  │        USB ↓                           │          │ │  │
│  │  └────────────────────────────────────────┘          │ │  │
│  │                                                      │ │  │
│  │  Conexiones desde ESP32:                             │ │  │
│  │  - VIN → Riel 5V                                     │ │  │
│  │  - GND (×4) → Riel GND                               │ │  │
│  │  - GPIOs → Borneras/LEDs                             │ │  ↓
│  └──────────────────────────────────────────────────────┘ │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐ │
│  │ ZONA 3: BORNERAS DE CONEXIÓN (Inferior)             │ │
│  │                                                      │ │
│  │ ┌──┐ ┌─┐ ┌───┐ ┌───┐ ┌──┐ ┌──┐ ┌──────────┐        │ │
│  │ │3p│ │2p│ │4p │ │4p │ │3p│ │7p│ │  12p     │        │ │
│  │ └──┘ └─┘ └───┘ └───┘ └──┘ └──┘ └──────────┘        │ │
│  │  │    │    │     │     │    │        │              │ │
│  │ DHT  LDR  HC   LD   Hum  Relés   Bombas             │ │
│  │ 11        SR04 2410C              (salidas)          │ │
│  │                                                      │ │
│  │ Total: ~30 pines de borneras                         │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐ │
│  │ ZONA 4: LEDs Y INDICADORES (Borde)                  │ │
│  │                                                      │ │
│  │ [R220Ω]─[LED🟢] [R220Ω]─[LED🔴] [R220Ω]─[LED🟡]     │ │
│  │    GPIO26          GPIO25          GPIO4            │ │
│  │                                                      │ │
│  │ [R220Ω]─[LED🔵] [R220Ω]─[LED⚪]                      │ │
│  │    GPIO2           GPIO15                           │ │
│  │                                                      │ │
│  │ LEDs 3mm o 5mm + resistencias soldadas en PCB       │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐ │
│  │ ZONA 5: COMPONENTES AUXILIARES                      │ │
│  │                                                      │ │
│  │ Divisor resistivo LDR:                               │ │
│  │   3.3V ──[R 10kΩ]──┬──→ GPIO35 (ESP32)              │ │
│  │                    │                                 │ │
│  │                [Bornera LDR]                         │ │
│  │                    │                                 │ │
│  │   GND ─────────────┴─────                            │ │
│  │                                                      │ │
│  │ Pull-up DHT11 (opcional):                            │ │
│  │   3.3V ──[R 10kΩ]──→ GPIO27                          │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐ │
│  │ RIELES DE ALIMENTACIÓN (Bordes superior/inferior)   │ │
│  │                                                      │ │
│  │ [+5V]  ══════════════════════════════════════════   │ │
│  │ [+3.3V]══════════════════════════════════════════   │ │
│  │ [GND]  ══════════════════════════════════════════   │ │
│  │ [GND]  ══════════════════════════════════════════   │ │
│  │                                                      │ │
│  │ Doble riel GND para robustez                         │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                            │
│  ESPACIO LIBRE: ~30% (expansión futura)                   │
└────────────────────────────────────────────────────────────┘
```

---

## 🔌 TABLA DE CONEXIONES COMPLETA

### **Alimentación:**

| Origen | Destino | Cable | Notas |
|--------|---------|-------|-------|
| Fuente 5V + | Bornera PCB | Rojo 12AWG | Prensaestopa |
| Fuente 5V - | Bornera PCB | Negro 12AWG | Prensaestopa |
| Bornera + | Riel 5V | Interno PCB | Soldadura |
| Bornera - | Riel GND | Interno PCB | Soldadura |
| Riel 5V | AMS1117 IN | Interno PCB | - |
| AMS1117 OUT | Riel 3.3V | Interno PCB | - |
| AMS1117 GND | Riel GND | Interno PCB | - |

### **ESP32 a Rieles:**

| ESP32 Pin | Destino | Cable | Notas |
|-----------|---------|-------|-------|
| VIN | Riel 5V | Rojo corto | Soldado o header |
| GND (×4) | Riel GND | Negro corto | Usar múltiples |
| 3V3 | NC | - | Es salida, no conectar |

### **ESP32 a Relés:**

| ESP32 GPIO | Relé | Cable | Función |
|------------|------|-------|---------|
| GPIO23 | IN1 | Amarillo 15cm | Bomba Z1A |
| GPIO22 | IN2 | Naranja 15cm | Bomba Z1B |
| GPIO21 | IN3 | Verde 15cm | Bomba Z2A |
| GPIO19 | IN4 | Azul 15cm | Bomba Z2B |
| GPIO18 | IN5 | Violeta 15cm | Bomba Z3A |
| GPIO5 | IN6 | Gris 15cm | Bomba Z3B |

### **ESP32 a Borneras (Sensores):**

| ESP32 GPIO | Sensor | Bornera | Cable | Longitud |
|------------|--------|---------|-------|----------|
| GPIO27 | DHT11 DATA | 3p-pin2 | Amarillo | 10cm |
| GPIO34 | Hum.Suelo OUT | 3p-pin2 | Verde | 10cm |
| GPIO35 | LDR signal | - | Amarillo | Interno |
| GPIO13 | HC-SR04 TRIG | 4p-pin2 | Amarillo | 10cm |
| GPIO14 | HC-SR04 ECHO | 4p-pin3 | Verde | 10cm |
| GPIO32 | LD2410C RX | 4p-pin2 | Verde | 10cm |
| GPIO33 | LD2410C TX | 4p-pin3 | Azul | 10cm |

### **ESP32 a LEDs:**

| ESP32 GPIO | LED | Color | Cable |
|------------|-----|-------|-------|
| GPIO26 | LED1 | Verde | Amarillo 5cm |
| GPIO25 | LED2 | Rojo | Naranja 5cm |
| GPIO4 | LED3 | Amarillo | Amarillo 5cm |
| GPIO2 | LED4 | Azul | Azul 5cm |
| GPIO15 | LED5 | Blanco | Blanco 5cm |

### **Borneras a Sensores Externos:**

| Bornera | Pin | Destino | Cable | Longitud |
|---------|-----|---------|-------|----------|
| **DHT11 (3p)** | 1 | VCC (3.3V) | Rojo | 30cm |
|  | 2 | DATA | Amarillo | 30cm |
|  | 3 | GND | Negro | 30cm |
| **LDR (2p)** | 1 | Signal | Amarillo | 30cm |
|  | 2 | GND | Negro | 30cm |
| **HC-SR04 (4p)** | 1 | VCC (5V) | Rojo | 100cm |
|  | 2 | TRIG | Amarillo | 100cm |
|  | 3 | ECHO | Verde | 100cm |
|  | 4 | GND | Negro | 100cm |
| **LD2410C (4p)** | 1 | VCC (5V) | Rojo | 40cm |
|  | 2 | TX→RX | Verde | 40cm |
|  | 3 | RX→TX | Azul | 40cm |
|  | 4 | GND | Negro | 40cm |
| **Hum.Suelo (3p)** | 1 | VCC (3.3V) | Rojo | 5m |
|  | 2 | AOUT | Verde | 5m |
|  | 3 | GND | Negro | 5m |

---

## 🛠️ PROCESO DE CONSTRUCCIÓN

### **FASE 1: Preparar PCB (30 min)**

1. **Limpiar PCB:**
   - Lavar con agua y jabón
   - Secar completamente
   - Alcohol isopropílico (opcional)

2. **Marcar zonas:**
   - Usar marcador permanente
   - Delimitar 5 zonas principales
   - Marcar ubicación ESP32 (centrado)

3. **Planificar routing:**
   - Marcar rieles en bordes
   - Planificar rutas de cables
   - Identificar puntos de conexión

---

### **FASE 2: Soldar Componentes Fijos (2-3 horas)**

#### **Orden recomendado:**

**1. Rieles de alimentación (30 min):**
```
- Usar cable AWG18 o puentes de estaño
- Riel superior: +5V (un lado completo)
- Segundo riel: +3.3V (un lado completo)
- Rieles inferiores: GND × 2 (ambos lados)
- Conectar rieles GND entre sí (robusto)
```

**2. Regulador AMS1117 + condensadores (30 min):**
```
Ubicación: Esquina superior izquierda

Soldadura:
1. Insertar AMS1117 en PCB
2. Doblar pines 90° si es necesario
3. Soldar:
   - Pin IN → Riel 5V
   - Pin OUT → Riel 3.3V
   - Pin GND → Riel GND
4. Soldar C1 (100µF):
   - Positivo → Riel 5V
   - Negativo → Riel GND
5. Soldar C2 (10µF):
   - Positivo → Riel 3.3V
   - Negativo → Riel GND
```

**3. Headers para ESP32 (45 min):**
```
Headers hembra 2×15 pines

Procedimiento:
1. Posicionar headers en PCB (centrado)
2. Insertar ESP32 en headers (alineación)
3. Soldar UN pin de cada header
4. Verificar perpendicularidad
5. Si está bien: soldar resto de pines
6. Si está mal: desoldar y reajustar
7. Retirar ESP32 (queda removible)

Conexiones desde headers:
- VIN → Riel 5V (cable corto o puente)
- GND (pines 2, 7, 15, 16) → Riel GND
- Resto de pines → Borneras/LEDs
```

**4. Borneras (45 min):**
```
Ubicación: Borde inferior, en línea

Orden de izquierda a derecha:
[DHT11 3p] [LDR 2p] [HC-SR04 4p] [LD2410C 4p]
[Hum.Suelo 3p] [Relés 7p] [Bombas 12p]

Soldadura:
1. Posicionar todas las borneras
2. Verificar alineación
3. Soldar un pin de cada bornera
4. Verificar que estén rectas
5. Soldar resto de pines

Conexiones:
- Pin 1 de DHT11, Hum.Suelo → Riel 3.3V
- Pin 1 de HC-SR04, LD2410C → Riel 5V
- Pines GND → Riel GND
- Pines señal → ESP32 GPIOs (cables)
```

**5. LEDs + Resistencias (30 min):**
```
Ubicación: Borde lateral o inferior

Para cada LED:
1. Soldar resistencia 220Ω
2. Resistencia → Punto de conexión GPIO
3. LED ánodo (+) → Resistencia
4. LED cátodo (-) → Riel GND

Orden:
- LED1 Verde (GPIO26)
- LED2 Rojo (GPIO25)
- LED3 Amarillo (GPIO4)
- LED4 Azul (GPIO2)
- LED5 Blanco (GPIO15)

Técnica:
- Usar LEDs 3mm (más compactos)
- Doblar pines LED para montaje horizontal
- Termocontraíble opcional (estética)
```

**6. Divisor LDR (15 min):**
```
Ubicación: Espacio libre cerca de bornera LDR

Soldadura:
1. R 10kΩ entre Riel 3.3V y punto medio
2. Punto medio → GPIO35 (ESP32)
3. Punto medio → Bornera LDR pin 1
4. Bornera LDR pin 2 → Riel GND
```

---

### **FASE 3: Cablear ESP32 a Componentes (1-2 horas)**

#### **Materiales:**
- Cable AWG24 multicolor (10m)
- Pelacables
- Soldador + estaño
- Termocontraíble (opcional)

#### **Técnica de cableado:**

**Método 1: Con headers (ESP32 removible):**
```
1. Cable desde header pin → Destino
2. Soldar cable al header (lado inferior PCB)
3. Soldar cable al destino (bornera/LED/relé)
4. Cable organizado pegado a PCB con hot glue
```

**Método 2: Soldado directo (ESP32 permanente):**
```
1. ESP32 soldado directamente a PCB
2. Cables desde pads ESP32 → Destinos
3. Más compacto pero menos mantenible
```

**Recomendación para 8×12cm:** Usar **headers** (hay espacio suficiente)

#### **Orden de cableado:**

**1. Alimentación (prioritario):**
```
- ESP32 VIN → Riel 5V
- ESP32 GND (×2 mínimo) → Riel GND
```

**2. Relés (6 cables control):**
```
- GPIO23 → Bornera Relés pin 1 (IN1)
- GPIO22 → Bornera Relés pin 2 (IN2)
- GPIO21 → Bornera Relés pin 3 (IN3)
- GPIO19 → Bornera Relés pin 4 (IN4)
- GPIO18 → Bornera Relés pin 5 (IN5)
- GPIO5 → Bornera Relés pin 6 (IN6)
```

**3. Sensores (borneras):**
```
- GPIO27 → Bornera DHT11 pin 2
- GPIO34 → Bornera Hum.Suelo pin 2
- GPIO13 → Bornera HC-SR04 pin 2
- GPIO14 → Bornera HC-SR04 pin 3
- GPIO32 → Bornera LD2410C pin 2
- GPIO33 → Bornera LD2410C pin 3
```

**4. LEDs (5 cables):**
```
- GPIO26 → LED1 resistor
- GPIO25 → LED2 resistor
- GPIO4 → LED3 resistor
- GPIO2 → LED4 resistor
- GPIO15 → LED5 resistor
```

**5. LDR signal:**
```
- GPIO35 → Punto medio divisor LDR
```

---

### **FASE 4: Probar PCB (30 min)**

#### **Prueba 1: Alimentación (SIN ESP32)**
```bash
Conectar fuente 5V a bornera entrada

Multímetro:
✓ Riel 5V → GND: debe leer 5.0V ± 0.1V
✓ Riel 3.3V → GND: debe leer 3.3V ± 0.1V
✓ Regulador no se calienta excesivamente

Si falla:
- Verificar polaridad
- Verificar soldaduras AMS1117
- Buscar cortocircuitos
```

#### **Prueba 2: ESP32 (Con alimentación)**
```bash
Insertar ESP32 en headers

Observar:
✓ LED azul ESP32 enciende
✓ ESP32 no se calienta
✓ Conectar USB: PC detecta ESP32

Si falla:
- Verificar VIN y GND del ESP32
- Verificar que no hay cortos
```

#### **Prueba 3: LEDs individuales**
```bash
Flashear firmware de prueba

Activar cada GPIO desde HA:
✓ LED1 (GPIO26) enciende
✓ LED2 (GPIO25) enciende
✓ LED3 (GPIO4) enciende
✓ LED4 (GPIO2) enciende
✓ LED5 (GPIO15) enciende

Si falla alguno:
- Verificar polaridad LED
- Verificar soldadura resistor
- Verificar conexión GPIO
```

---

### **FASE 5: Montar en Caja (1 hora)**

#### **1. Preparar caja:**

**Perforaciones necesarias:**

```
PARED LATERAL IZQUIERDA:
- 6-8 agujeros 2-3mm (ventilación DHT11)
- 1 agujero 5mm (LDR)

PARED LATERAL DERECHA:
- Sin agujeros (LD2410C atraviesa plástico)

TAPA INFERIOR:
- 2 agujeros 5-6mm (HC-SR04 TRIG/ECHO)

ENTRADAS/SALIDAS:
- 1 prensaestopa PG9 (alimentación)
- 2 prensaestopas PG11/13 (bombas)
- 1 prensaestopa PG9 (sensor humedad suelo)

FONDO:
- 4 agujeros M3 (esquinas, separadores PCB)
- 2-4 agujeros M3 (módulo relés)
```

#### **2. Instalar prensaestopas:**
```
- Desde exterior: Insertar prensaestopa
- Desde interior: Tuerca de fijación
- No apretar completamente (dejar para después)
```

#### **3. Montar PCB:**
```
Materiales:
- 4× Separadores nylon M3 (10-15mm)
- 4× Tornillos M3 × 6mm
- 4× Tuercas M3

Montaje:
1. Tornillo desde exterior → Separador
2. PCB sobre separadores
3. Tuerca sobre PCB (fija PCB)

Resultado: PCB elevada 10-15mm del fondo
```

#### **4. Montar módulo relés:**
```
Ubicación: Al lado de PCB

Montaje:
- Opción A: Tornillos M3 (si tiene agujeros)
- Opción B: Cinta doble cara VHB
- Opción C: Hot glue en esquinas

Conexión:
- Cable desde Bornera Relés PCB → Módulo
- VCC relés → 5V (desde prensaestopa o PCB)
- GND relés → GND (desde PCB)
- IN1-6 → Cables desde bornera
```

#### **5. Conectar alimentación:**
```
Cable desde prensaestopa:
1. Pasar cable 5V por prensaestopa
2. Rojo (+) → Bornera PCB pin +
3. Negro (-) → Bornera PCB pin -
4. Apretar prensaestopa (sellado)
```

---

### **FASE 6: Sensores en Paredes (1-2 horas)**

#### **DHT11 (Pared lateral izquierda):**

**Preparación:**
1. Soldar cable 3 hilos (30cm) a DHT11
2. Termocontraíble en soldaduras
3. Probar con multímetro (continuidad)

**Montaje:**
```
Interior pared:
┌──────────┐
│  DHT11   │ ← Pegado con silicona/hot glue
│  módulo  │    mirando hacia agujeros
└────┬─────┘
     │ Cables hacia PCB
     ↓
 [Bornera DHT11 en PCB]
```

**Pasos:**
1. Perforar 6-8 agujeros 2-3mm en pared
2. Aplicar hot glue en DHT11
3. Pegar por dentro, alineado con agujeros
4. Dejar secar 10 minutos
5. Conectar a bornera PCB

#### **LDR (Pared lateral izquierda, junto a DHT11):**

**Preparación:**
1. Soldar cable 2 hilos (30cm) a LDR
2. Identificar polaridad si aplica
3. Termocontraíble

**Montaje:**
```
Desde exterior:
┌──────┐
│  ○   │ ← LDR insertado desde interior
└──────┘    visible al exterior

Desde interior:
  LDR ──→ [Cables] ──→ Bornera PCB
```

**Pasos:**
1. Perforar agujero 5mm en pared
2. Insertar LDR desde interior
3. Fijar con silicona transparente o hot glue
4. LDR debe "asomar" ligeramente al exterior
5. Conectar a bornera PCB

#### **LD2410C (Pared lateral derecha):**

**Preparación:**
1. Soldar cable 4 hilos (40cm) a LD2410C
2. Verificar TX/RX correctos
3. Termocontraíble

**Montaje:**
```
Interior pared (SIN agujeros):
┌───────────┐
│  LD2410C  │ ← Pegado con cinta VHB
│  📡       │    o hot glue
└─────┬─────┘
      │ Antena perpendicular a pared
      ↓
  [Bornera LD2410C en PCB]
```

**Pasos:**
1. NO perforar la pared (radar atraviesa)
2. Aplicar cinta doble cara o hot glue
3. Pegar LD2410C orientado perpendicular
4. Antena apuntando hacia donde detectar
5. Conectar a bornera PCB

#### **HC-SR04 (Sistema de tapas):**

**Preparación:**
1. Soldar cable 4 hilos (1 metro) a HC-SR04
2. Reforzar soldaduras (irá al agua)
3. Termocontraíble + silicona impermeable
4. Probar con multímetro

**Montaje tapas:**
```
CAJA (tapa inferior):
   ○  ○  ← 2 agujeros 5-6mm
   │  │
   Cable pasa
   │  │
════════ ← Tapa reservorio (pegada)
   ○  ○  ← 2 agujeros alineados
   │  │
[HC-SR04] ← En el agua
```

**Pasos:**
1. Perforar tapa caja: 2 agujeros 15mm separados
2. Perforar tapa reservorio: alineados con caja
3. Pasar cable desde PCB → tapas → agua
4. Montar HC-SR04 en agua:
   - Opción A: Flotador + sensor colgado
   - Opción B: Soporte fijo desde tapa
5. Alinear ambas tapas
6. Aplicar silicona en perímetro
7. Presionar tapas juntas
8. Dejar secar 24 horas
9. Sellar agujeros con silicona adicional
10. Conectar a bornera PCB

---

## 🧪 PRUEBAS FINALES

### **Test 1: Alimentación completa**
```bash
Con todo conectado:
✓ 5V en riel
✓ 3.3V en riel
✓ Módulo relés alimentado
✓ ESP32 enciende
✓ Ningún componente se calienta
```

### **Test 2: Relés**
```bash
Desde Home Assistant:
✓ Activar relé 1: Click + LED enciende
✓ Activar relé 2: Click + LED enciende
✓ ... (repetir para 6 relés)
✓ Bombas giran (si conectadas)
```

### **Test 3: LEDs**
```bash
Desde HA o script:
✓ LED Verde enciende (Tank Full)
✓ LED Rojo enciende (Tank Low)
✓ LED Amarillo enciende (Tank Med)
✓ LED Azul enciende (Pump Active)
✓ LED Blanco enciende (WiFi Status)
```

### **Test 4: Sensores**
```bash
En Home Assistant:
✓ DHT11 lee temperatura (~20-25°C)
✓ DHT11 lee humedad (~40-60%)
✓ LDR varía con luz (0-100%)
✓ HC-SR04 mide distancia (cm)
✓ LD2410C detecta presencia (on/off)
✓ Sensor humedad suelo responde (0-100%)
```

### **Test 5: Sistema completo**
```bash
Prueba de riego manual:
1. Activar script "Riego 5 min"
2. Verificar:
   ✓ LED Azul enciende (bomba activa)
   ✓ Relé hace click
   ✓ Bomba gira (si conectada)
3. Esperar 5 minutos
4. Verificar:
   ✓ Bomba se detiene
   ✓ LED Azul apaga
   ✓ Notificación en HA
```

---

## 📦 LISTA DE MATERIALES COMPLETA

### **PCB y Componentes Electrónicos:**

| Item | Cantidad | Especificación | Dónde Comprar |
|------|----------|----------------|---------------|
| **PCB perforada 8×12 cm** | 1 (4 compradas) | Fibra vidrio | Autoelectronica5G $150 |
| **ESP32 30-pin** | 1 | ESP-WROOM-32 | Ya tienes |
| Headers hembra | 2 | 15 pines 2.54mm | Autoelectronica5G |
| Regulador AMS1117-3.3V | 1 | TO-220 | Autoelectronica5G |
| Condensador electrolítico | 1 | 100µF 16V | Autoelectronica5G |
| Condensador electrolítico | 1 | 10µF 16V | Autoelectronica5G |
| Resistencias 220Ω | 5 | 1/4W | Autoelectronica5G |
| Resistencias 10kΩ | 2 | 1/4W | Autoelectronica5G |
| LEDs 3mm o 5mm | 5 | Verde, Rojo, Amarillo, Azul, Blanco | Autoelectronica5G |
| Borneras PCB 2.54mm | Variable | 2p, 3p, 4p, 12p | Autoelectronica5G |
| Módulo relés 6 canales | 1 | 5V con optoacoplador | - |

### **Sensores:**

| Item | Cantidad | Especificación |
|------|----------|----------------|
| DHT11 | 1 | Temperatura/humedad |
| LDR | 1 | Fotoresistor 5-10kΩ |
| LD2410C | 1 | mmWave presence sensor |
| HC-SR04 | 1 | Ultrasonic distance |
| Sensor humedad suelo | 1 | Capacitivo 3.3V |

### **Cables y Conexiones:**

| Item | Cantidad | Especificación |
|------|----------|----------------|
| Cable AWG24 multicolor | 10-15m | Señales |
| Cable AWG18 rojo/negro | 3m | Alimentación |
| Termocontraíble | 1m | Varios tamaños |
| Estaño | 1 rollo | 60/40 con flux |
| Flux pasta | 1 | Soldadura |

### **Montaje en Caja:**

| Item | Cantidad | Especificación |
|------|----------|----------------|
| Caja Stanco IP65 | 1 | 13×19×10 cm (ya tienes) |
| Separadores nylon M3 | 6-8 | 10-15mm |
| Tornillos M3 | 10-12 | 6-10mm |
| Tuercas M3 | 10-12 | - |
| Prensaestopas PG9 | 2-3 | IP68 |
| Prensaestopas PG11/13 | 2 | IP68 bombas |
| Silicona | 1 tubo | Sellado |
| Hot glue | 1 pistola | Fijación |
| Cinta doble cara VHB | 1 rollo | 3M |

### **Herramientas:**

| Item | Especificación |
|------|----------------|
| Soldador | 40-60W punta fina |
| Multímetro | Esencial ⚠️ |
| Pelacables | AWG22-26 |
| Alicate corte | - |
| Pinzas | Punta fina |
| Taladro | + brocas 2mm, 3mm, 5mm, 7mm, 10mm |
| Destornilladores | Phillips + plano |
| Pistola termocontraíble | Opcional |

---

## 💰 PRESUPUESTO ESTIMADO

### **Componentes en Autoelectronica5G:**

```
PCB 8×12 cm:              $150 UYU
Headers 15p (×2):         $60 UYU
Regulador AMS1117:        $40 UYU
Condensadores (×2):       $30 UYU
Resistencias (×7):        $35 UYU
LEDs (×5):                $50 UYU
Borneras:                 $100 UYU
Cable AWG24 (10m):        $80 UYU
Estaño + flux:            $100 UYU
──────────────────────
Subtotal:                 ~$645 UYU (~$16 USD)
```

### **Otros (proveedores varios):**

```
Módulo relés 6ch:         $300 UYU (~$8 USD)
DHT11:                    $150 UYU (~$4 USD)
HC-SR04:                  $100 UYU (~$2.5 USD)
LD2410C:                  $400 UYU (~$10 USD)
Sensor humedad:           $200 UYU (~$5 USD)
LDR:                      $20 UYU (~$0.5 USD)
Prensaestopas (×4):       $200 UYU (~$5 USD)
Separadores M3:           $100 UYU (~$2.5 USD)
Silicona:                 $100 UYU (~$2.5 USD)
──────────────────────
Subtotal:                 ~$1570 UYU (~$40 USD)
```

### **TOTAL PROYECTO:**

```
Componentes PCB:          $645 UYU
Otros componentes:        $1570 UYU
──────────────────────
TOTAL:                    ~$2215 UYU (~$56 USD)
```

*(Sin contar: ESP32, caja, bombas, herramientas que ya tienes)*

---

## ⏱️ TIEMPO DE CONSTRUCCIÓN

| Fase | Tiempo |
|------|--------|
| Preparar PCB | 30 min |
| Soldar componentes | 2-3 horas |
| Cablear ESP32 | 1-2 horas |
| Probar PCB | 30 min |
| Montar en caja | 1 hora |
| Sensores en paredes | 1-2 horas |
| Pruebas finales | 1 hora |
| **TOTAL** | **7-10 horas** |

**Recomendación:** Hacer en 2-3 sesiones de 3-4 horas cada una.

---

## 🎯 CONSEJOS FINALES

### **Soldadura:**
✓ Soldador a 350-380°C
✓ Usar flux generosamente
✓ Soldaduras brillantes (no opacas)
✓ No sobrecalentar componentes
✓ Limpiar punta soldador frecuentemente

### **Organización:**
✓ Usar colores consistentes de cables
✓ Etiquetar cables (cinta washi)
✓ Agrupar cables por función (bridas)
✓ Documentar con fotos
✓ Probar cada componente al agregarlo

### **Seguridad:**
✓ Desconectar alimentación al soldar
✓ Multímetro siempre a mano
✓ Verificar polaridad antes de conectar
✓ No forzar componentes
✓ Área ventilada para soldar

---

## 📚 ARCHIVOS RELACIONADOS

- **Firmware:** `/esphome/riego_z1.yaml`
- **Package HA:** `/packages/sistema_riego_z1.yaml`
- **Widget:** `/dashboards/widgets/widget_riego_z1.yaml`
- **Scripts:** `/examples/scripts/riego_scripts.yaml`
- **Pinout:** `/docs/hardware/PINOUT_ESP32_30PIN.md`
- **Validación:** `/docs/hardware/VALIDACION_PLACA_30PIN.md`

---

## 🆘 TROUBLESHOOTING

### **Problema: Regulador se calienta mucho**
- Causa: Cortocircuito 3.3V-GND
- Solución: Desconectar, buscar corto con multímetro

### **Problema: ESP32 no enciende**
- Causa: VIN o GND mal conectados
- Solución: Verificar continuidad con multímetro

### **Problema: LED no enciende**
- Causa: Polaridad invertida o resistor quemado
- Solución: Verificar polaridad, cambiar LED/resistor

### **Problema: Relé no activa**
- Causa: GPIO mal conectado o módulo sin alimentación
- Solución: Verificar VCC relés (5V), verificar IN1-6

### **Problema: Sensor no responde**
- Causa: Cable roto, bornera mal soldada, GPIO incorrecto
- Solución: Multímetro continuidad, verificar firmware

---

**Versión:** 1.0 FINAL
**Hardware:** PCB 8×12 cm + ESP32 30-pin
**Fecha:** Diciembre 2024
**Autor:** @mauitz
**Proveedor:** Autoelectronica5G - Maldonado, Uruguay

---

## ✅ ¡Listo para Construir!

Con esta PCB de 8×12 cm tienes:
- ✅ Espacio suficiente para todo
- ✅ Diseño cómodo de soldar
- ✅ Resultado profesional
- ✅ Fácil de mantener
- ✅ Espacio para expansión

**¡Mucha suerte con tu proyecto!** 🚀





