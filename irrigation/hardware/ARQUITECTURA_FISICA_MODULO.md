# 🏗️ Arquitectura Física - Módulo de Riego ESP32

## 📐 Vista General del Diseño

```
┌─────────────────────────────────────────────────────────────┐
│  CAJA STANCO (Pegada a tapa del reservorio)                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    TAPA DE LA CAJA                    │  │
│  │  ┌─────┐    ┌──────┐         ┌────────────┐          │  │
│  │  │ LDR │    │DHT11 │         │  Prensa-   │          │  │
│  │  │ ↑   │    │ con  │         │  estopas   │          │  │
│  │  │Luz  │    │ventil│         │  (cables)  │          │  │
│  │  └─────┘    └──────┘         └────────────┘          │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              INTERIOR DE LA CAJA                      │  │
│  │                                                        │  │
│  │  ┌──────────────────────────────────────┐             │  │
│  │  │      PLANCHA PROTOBOARD              │             │  │
│  │  │  (Montaje horizontal)                │             │  │
│  │  │                                      │             │  │
│  │  │  [ZONA 1: ALIMENTACIÓN]              │             │  │
│  │  │  [ZONA 2: ESP32]                     │             │  │
│  │  │  [ZONA 3: MÓDULO RELÉS]              │             │  │
│  │  │  [ZONA 4: BORNERAS SEÑALES]          │             │  │
│  │  │  [ZONA 5: SENSORES INTERNOS]         │             │  │
│  │  │                                      │             │  │
│  │  └──────────────────────────────────────┘             │  │
│  │                                                        │  │
│  │  Separadores de nylon (10-15mm altura)                │  │
│  │                                                        │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                              │
│  Cables externos:                                            │
│  • HC-SR04 → Al interior del tanque (sensor de nivel)       │
│  • Sensor humedad → Al suelo de la zona de riego            │
│  • 6x bombas → Conexión a relés                             │
│  • Alimentación 5V DC                                        │
└─────────────────────────────────────────────────────────────┘
```

---

## 📍 ZONA 1: Distribución de Componentes en la Plancha

### Layout Propuesto (Vista Superior)

```
┌──────────────────────────────────────────────────────────────────┐
│  PLANCHA PROTOBOARD (Aprox. 15x10 cm)                            │
│                                                                   │
│  ┌─────────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │  ZONA 1         │  │  ZONA 2      │  │  ZONA 3          │   │
│  │  ALIMENTACIÓN   │  │  ESP32       │  │  MÓDULO RELÉS    │   │
│  │                 │  │              │  │  6 canales       │   │
│  │  [Bornera]      │  │  ┌────────┐  │  │  ┌──────────┐   │   │
│  │  +5V  GND       │  │  │ ESP32  │  │  │  │ Relay    │   │   │
│  │  ┌──┐ ┌──┐     │  │  │ DevKit │  │  │  │ Module   │   │   │
│  │  │+ │ │- │     │  │  │        │  │  │  │ JQC-3FF  │   │   │
│  │  └──┘ └──┘     │  │  │ v1     │  │  │  │          │   │   │
│  │                 │  │  │        │  │  │  │ IN1-IN6  │   │   │
│  │  [Regulador]    │  │  │        │  │  │  │ VCC GND  │   │   │
│  │  AMS1117-3.3V   │  │  │ USB    │  │  │  │ COM NO NC│   │   │
│  │  IN OUT GND     │  │  └────────┘  │  │  └──────────┘   │   │
│  │  ┌──┬──┬──┐    │  │              │  │                  │   │
│  │  │5V│3V│GN│    │  │  [Pines      │  │  [Cables a      │   │
│  │  └──┴──┴──┘    │  │   header]    │  │   borneras]     │   │
│  └─────────────────┘  └──────────────┘  └──────────────────┘   │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  ZONA 4: BORNERAS DE SEÑALES (Conexiones externas)       │  │
│  │                                                            │  │
│  │  [HC-SR04] [Hum.Suelo] [LD2410C] [Bombas x6]             │  │
│  │  TRIG ECHO   SIG GND    TX RX     B1 B2 B3 B4 B5 B6      │  │
│  │  ┌──┬──┐    ┌──┬──┐   ┌──┬──┐   ┌──┬──┬──┬──┬──┬──┐    │  │
│  │  │  │  │    │  │  │   │  │  │   │  │  │  │  │  │  │    │  │
│  └──┴──┴──┴────┴──┴──┴───┴──┴──┴───┴──┴──┴──┴──┴──┴──┴────┘  │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  ZONA 5: SENSORES INTERNOS (montados EN la plancha)     │   │
│  │                                                           │   │
│  │  [5x LEDs Status]           [DHT11 en conector]          │   │
│  │  LED1 LED2 LED3 LED4 LED5   (se monta en tapa)          │   │
│  │   🔴   🟡   🟢   🔵   ⚪                                  │   │
│  │                                                           │   │
│  │  [LDR con resistor]         [Resistores pull-up]         │   │
│  │  (se monta en tapa)         10kΩ para I2C si necesario  │   │
│  │                                                           │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  RIELES DE ALIMENTACIÓN (en los bordes)                  │   │
│  │                                                           │   │
│  │  [+5V]  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │   │
│  │  [+3.3V]━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │   │
│  │  [GND]  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │   │
│  │  [GND]  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │   │
│  └──────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🎯 PRINCIPIOS DE DISEÑO

### 1. **Separación por Funciones**
- **ZONA 1 (Izquierda)**: Entrada de alimentación y regulación
- **ZONA 2 (Centro)**: Cerebro (ESP32)
- **ZONA 3 (Derecha)**: Actuadores (módulo relés)
- **ZONA 4 (Inferior)**: Interfaces de conexión externa
- **ZONA 5 (Superior)**: Sensores internos y componentes auxiliares

### 2. **Flujo de Corriente**
```
Entrada 5V → Regulador 3.3V → ESP32 → Señales → Periféricos
              ↓
         Módulo Relés (5V directo)
```

### 3. **Gestión de Calor**
- Regulador AMS1117 en borde (disipación)
- ESP32 en centro (ventilación cruzada)
- Módulo relés alejado del ESP32
- DHT11 en tapa (aire fresco exterior)

### 4. **Gestión de Ruido**
- Relés separados físicamente del ESP32
- Cables de potencia alejados de señales
- GND común robusto (doble riel)

---

## 🔌 DETALLES DE CONEXIÓN POR COMPONENTE

### A. ESP32 (ZONA 2 - Centro)

**Montaje:**
```
1. Soldar pines header hembra de 19 pines (x2) a la plancha
2. ESP32 se inserta en los headers (removible)
3. Orientación: USB hacia el borde frontal (fácil acceso)
```

**Distribución de pines (lado izquierdo del ESP32):**
```
3V3  ━━━━━→ Riel 3.3V
GND  ━━━━━→ Riel GND
GPIO15 ━━━→ LED WiFi
GPIO2  ━━━→ LED Bomba Activa
GPIO4  ━━━→ LED Tanque Medio
GPIO16 ━━━→ LD2410C RX (cable a bornera)
GPIO17 ━━━→ LD2410C TX (cable a bornera)
GPIO5  ━━━→ Relé 6 (IN6)
GPIO18 ━━━→ Relé 5 (IN5)
GPIO19 ━━━→ Relé 4 (IN4)
GPIO21 ━━━→ Relé 3 (IN3)
GND  ━━━━━→ Riel GND
GPIO22 ━━━→ Relé 2 (IN2) [Bomba Z1B]
GPIO23 ━━━→ Relé 1 (IN1) [Bomba Z1A]
```

**Distribución de pines (lado derecho del ESP32):**
```
GND  ━━━━━→ Riel GND
GPIO27 ━━━→ DHT11 DATA (cable a tapa)
GPIO26 ━━━→ LED Tanque Lleno
GPIO25 ━━━→ LED Tanque Bajo
GPIO34 ━━━→ Sensor Humedad Suelo (cable a bornera)
GPIO35 ━━━→ LDR (cable a tapa)
GPIO32 ━━━→ (Reserva)
GPIO33 ━━━→ (Reserva)
GPIO14 ━━━→ HC-SR04 ECHO (cable a bornera)
GPIO13 ━━━→ HC-SR04 TRIG (cable a bornera)
GND  ━━━━━→ Riel GND
VIN  ━━━━━→ Riel 5V (alimentación principal)
```

---

### B. MÓDULO RELÉS (ZONA 3 - Derecha)

**Conexión del módulo:**
```
Módulo Relés 6 canales (JQC-3FF o similar)
┌─────────────────────────────────────┐
│  VCC  ━━━→ Riel 5V                  │
│  GND  ━━━→ Riel GND                 │
│  IN1  ━━━→ GPIO23 (Bomba Z1A)       │
│  IN2  ━━━→ GPIO22 (Bomba Z1B)       │
│  IN3  ━━━→ GPIO21 (Bomba Z2A)       │
│  IN4  ━━━→ GPIO19 (Bomba Z2B)       │
│  IN5  ━━━→ GPIO18 (Bomba Z3A)       │
│  IN6  ━━━→ GPIO5  (Bomba Z3B)       │
└─────────────────────────────────────┘

Salidas de potencia (6 relés):
┌─────────────────────────────────────┐
│  COM1 ━━━→ +5V bomba                │
│  NO1  ━━━→ Bomba 1 + (a bornera)    │
│                                      │
│  COM2 ━━━→ +5V bomba                │
│  NO2  ━━━→ Bomba 2 + (a bornera)    │
│                                      │
│  COM3-6: Similar para bombas 3-6    │
│                                      │
│  NOTA: Negativo de bombas →         │
│        GND común (bornera)           │
└─────────────────────────────────────┘
```

**Importante:**
- Módulo relés requiere 5V lógica (no 3.3V)
- ESP32 GPIO puede manejar módulos de 5V (tolerancia)
- Si el módulo tiene jumper JD-VCC, dejarlo en HIGH level trigger

---

### C. ALIMENTACIÓN (ZONA 1 - Izquierda)

**Esquema:**
```
                     ┌─────────────┐
Entrada 5V DC ━━━━━→│  Bornera    │
  (+) (-)            │  2 pines    │
                     └──────┬──────┘
                            │
                ┌───────────┴───────────┐
                │                       │
                ↓                       ↓
        ┌──────────────┐        ┌──────────────┐
        │ Riel 5V      │        │ Regulador    │
        │ (módulo      │        │ AMS1117-3.3V │
        │  relés,      │        │              │
        │  VIN ESP32)  │        │  IN ━━ 5V    │
        └──────────────┘        │  OUT ━ 3.3V  │
                                │  GND ━ GND   │
                                └──────┬───────┘
                                       │
                                       ↓
                                ┌─────────────┐
                                │ Riel 3.3V   │
                                │ (ESP32,     │
                                │  sensores)  │
                                └─────────────┘

GND ━━━━━━━━━━━━━━━━━━━━━━━━━→ Doble riel GND
                                 (robusto)
```

**Componentes necesarios:**
- Bornera 2 pines (5V entrada)
- Regulador AMS1117-3.3V (TO-220 o SMD)
- Condensadores:
  - 100µF 16V (entrada regulador)
  - 10µF 16V (salida regulador)
  - 100nF cerámico (desacople)

---

### D. DHT11 (Montado en TAPA)

**Razón:** Necesita aire fresco exterior (no aire caliente de dentro de la caja)

**Montaje:**
```
TAPA DE LA CAJA STANCO
┌──────────────────────────────────┐
│                                  │
│    ┌─────────┐                   │
│    │  DHT11  │  ← Montado aquí   │
│    │  [|||]  │     (interior)    │
│    └────┬────┘                   │
│         │ Cable 3 hilos          │
│         │ (20cm aprox.)          │
│         ↓                        │
└─────────┼────────────────────────┘
          │
    ┌─────┼─────┐
    │ Prensa-   │  ← Sello hermético
    │ estopa    │
    └─────┼─────┘
          │
          ↓
    Interior caja
    ┌──────────────┐
    │ A plancha:   │
    │ VCC → 3.3V   │
    │ DATA → GPIO27│
    │ GND → GND    │
    └──────────────┘
```

**Componentes necesarios:**
- DHT11 (módulo con 3 pines recomendado)
- Cable 3 hilos AWG22 o AWG24 (20cm)
- Prensaestopa PG7 o PG9 (sellado)
- Opcional: Mini conector JST 3 pines (desconexión fácil)

**En la plancha:**
- Bornera 3 pines o conector JST hembra
- Resistencia pull-up 10kΩ entre DATA y 3.3V (ya está en firmware)

---

### E. LDR (Montado en TAPA)

**Razón:** Debe recibir luz ambiente exterior

**Montaje:**
```
TAPA DE LA CAJA STANCO
┌──────────────────────────────────┐
│                                  │
│  ┌───┐                            │
│  │LDR│  ← Montado en agujero     │
│  │ ○ │     de la tapa            │
│  └─┬─┘     (cara exterior)       │
│    │ Cable 2 hilos               │
│    ↓                             │
└────┼───────────────────────────┘
     │
 ┌───┼───┐
 │Prensa-│  ← Sello
 │estopa │
 └───┼───┘
     │
     ↓
Interior caja
┌──────────────────┐
│ A plancha:       │
│                  │
│  LDR1 → GPIO35   │
│  LDR2 → GND      │
│                  │
│ Divisor          │
│ resistivo:       │
│  3.3V            │
│   │              │
│  [10kΩ]          │
│   │─────→ GPIO35 │
│  [LDR]           │
│   │              │
│  GND             │
└──────────────────┘
```

**Componentes necesarios:**
- LDR (fotoresistor) 5-10kΩ nominal
- Resistencia 10kΩ (divisor)
- Cable 2 hilos AWG24 (20cm)
- Prensaestopa pequeño
- Opcional: Termocontraíble transparente sobre LDR (protección)

**En la plancha:**
```
3.3V ━━━┬━━━━ Riel 3.3V
        │
       [R 10kΩ]
        │
        ├━━━━━━→ GPIO35 (ADC)
        │
       [LDR]
        │
GND ━━━┴━━━━ Riel GND
```

---

### F. SENSORES EXTERNOS (Borneras ZONA 4)

#### **F.1. HC-SR04 (Ultrasónico - Nivel de Tanque)**

**Conexión:**
```
Bornera 4 pines:
┌────────────────────────┐
│ VCC  → 5V             │
│ TRIG → GPIO13         │
│ ECHO → GPIO14         │
│ GND  → GND            │
└────────────────────────┘

Cable: 4 hilos, hasta 2m
Ubicación: Interior del tanque
          (montado en tapa o flotador)
```

#### **F.2. Sensor Humedad Suelo (Capacitivo)**

**Conexión:**
```
Bornera 3 pines:
┌────────────────────────┐
│ VCC  → 3.3V           │
│ AOUT → GPIO34 (ADC)   │
│ GND  → GND            │
└────────────────────────┘

Cable: 3 hilos, hasta 5m
Ubicación: Enterrado en zona de riego
```

#### **F.3. LD2410C (Presencia mmWave)**

**Conexión:**
```
Bornera 4 pines:
┌────────────────────────┐
│ VCC  → 5V             │
│ TX   → GPIO16 (RX2)   │
│ RX   → GPIO17 (TX2)   │
│ GND  → GND            │
└────────────────────────┘

Cable: 4 hilos, hasta 1m
Ubicación: Montado en caja o exterior
           (detecta presencia cerca)
```

#### **F.4. Bombas de Agua (x6)**

**Conexión:**
```
Bornera 12 pines (6x2):
┌────────────────────────────────┐
│ B1+ B1-  ← Bomba 1 (Z1A)      │
│ B2+ B2-  ← Bomba 2 (Z1B)      │
│ B3+ B3-  ← Bomba 3 (Z2A)      │
│ B4+ B4-  ← Bomba 4 (Z2B)      │
│ B5+ B5-  ← Bomba 5 (Z3A)      │
│ B6+ B6-  ← Bomba 6 (Z3B)      │
└────────────────────────────────┘

Configuración interna:
  Relé COM → +5V bomba
  Relé NO  → B+ (positivo bomba)
  B- (negativo bomba) → GND común
```

---

### G. LEDs DE ESTADO (ZONA 5)

**Montaje en plancha:**

```
┌────────────────────────────────────────┐
│ LED1  LED2  LED3  LED4  LED5           │
│  🔴    🟡    🟢    🔵    ⚪             │
│  │     │     │     │     │             │
│ [R]   [R]   [R]   [R]   [R]   ← 220Ω  │
│  │     │     │     │     │             │
│ GPIO26│    │     │     │               │
│      GPIO25│     │     │               │
│           GPIO4  │     │               │
│                GPIO2   │               │
│                      GPIO15            │
│                                        │
│ GND ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
└────────────────────────────────────────┘
```

**Función de cada LED:**
- **LED1 (GPIO26)**: Tanque Lleno (Verde)
- **LED2 (GPIO25)**: Tanque Bajo (Rojo)
- **LED3 (GPIO4)**: Tanque Medio (Amarillo)
- **LED4 (GPIO2)**: Bomba Activa (Azul)
- **LED5 (GPIO15)**: WiFi Status (Blanco)

**Componentes:**
- 5x LEDs (colores sugeridos arriba)
- 5x Resistencias 220Ω
- Opcional: Guía de luz (fibra óptica a tapa)

---

## 🛠️ ORDEN DE CONSTRUCCIÓN

### **FASE 1: Preparación de la Plancha**

1. **Limpiar la plancha**
   - Lija suave si hay oxidación
   - Alcohol isopropílico

2. **Marcar zonas con marcador permanente**
   - Zona 1: Alimentación (izquierda)
   - Zona 2: ESP32 (centro)
   - Zona 3: Relés (derecha)
   - Zona 4: Borneras (inferior)
   - Zona 5: LEDs (superior)

3. **Crear rieles de alimentación**
   ```
   Lado superior: +5V
   Segundo: +3.3V
   Tercero: GND
   Cuarto: GND (refuerzo)
   ```
   - Usar cable AWG18 o bus de estaño continuo
   - Soldar puntos cada 10 agujeros

---

### **FASE 2: Soldadura de Componentes Fijos**

#### **Paso 1: Alimentación (ZONA 1)**

```
Orden:
1. Bornera 2 pines (entrada 5V)
2. Regulador AMS1117-3.3V
3. Condensadores (100µF entrada, 10µF salida)
4. Puentes a rieles de alimentación
```

**Soldadura:**
1. Insertar bornera, soldar
2. AMS1117:
   - Pin 1 (GND) → Riel GND
   - Pin 2 (OUT/3.3V) → Riel 3.3V
   - Pin 3 (IN/5V) → Bornera +
3. Condensadores:
   - C1 (100µF) entre 5V y GND (cerca de entrada)
   - C2 (10µF) entre 3.3V y GND (cerca de salida)
4. Puente: Bornera GND → Riel GND
5. Puente: Bornera +5V → Riel 5V

**Probar:** Conectar fuente 5V, medir 3.3V con multímetro

---

#### **Paso 2: Pines Header para ESP32 (ZONA 2)**

```
Materiales:
- 2x header hembra de 19 pines (2.54mm)
- O alternativamente: 2x tira de pines de 19
```

**Soldadura:**
1. **Posicionar ESP32 en la plancha** para marcar ubicación
2. Insertar headers en ESP32 (para alineación)
3. Posicionar conjunto sobre plancha
4. Soldar UN PIN de cada header (fijación temporal)
5. Verificar alineación y perpendicularidad
6. Soldar resto de pines
7. Retirar ESP32 (queda removible)

**Conexiones desde headers:**
- Header izquierdo pin VIN → Riel 5V
- Headers GND (varios) → Riel GND
- Headers 3V3 → Riel 3.3V

---

#### **Paso 3: Módulo Relés (ZONA 3)**

**Opción A: Módulo con agujeros de montaje**
1. Fijar módulo con tornillos + separadores de nylon
2. Cables desde módulo a plancha:
   - VCC → Riel 5V
   - GND → Riel GND
   - IN1-IN6 → Pistas hacia headers ESP32

**Opción B: Módulo sin montaje**
1. Usar cinta doble cara foam (aislante)
2. Cables directos como Opción A

**Soldadura de conexiones de control:**
```
ESP32 GPIO23 ━━━━━→ IN1 del módulo
ESP32 GPIO22 ━━━━━→ IN2 del módulo
ESP32 GPIO21 ━━━━━→ IN3 del módulo
ESP32 GPIO19 ━━━━━→ IN4 del módulo
ESP32 GPIO18 ━━━━━→ IN5 del módulo
ESP32 GPIO5  ━━━━━→ IN6 del módulo
```

---

#### **Paso 4: Borneras de Señales (ZONA 4)**

Soldar borneras en este orden:

1. **Bornera 4 pines** (HC-SR04)
   ```
   Pin 1 → Riel 5V
   Pin 2 → Pista a GPIO13
   Pin 3 → Pista a GPIO14
   Pin 4 → Riel GND
   ```

2. **Bornera 3 pines** (Humedad Suelo)
   ```
   Pin 1 → Riel 3.3V
   Pin 2 → Pista a GPIO34
   Pin 3 → Riel GND
   ```

3. **Bornera 4 pines** (LD2410C)
   ```
   Pin 1 → Riel 5V
   Pin 2 → Pista a GPIO17 (TX del ESP32)
   Pin 3 → Pista a GPIO16 (RX del ESP32)
   Pin 4 → Riel GND
   ```

4. **Bornera 3 pines** (DHT11)
   ```
   Pin 1 → Riel 3.3V
   Pin 2 → Pista a GPIO27
   Pin 3 → Riel GND
   ```

5. **Bornera 2 pines** (LDR)
   ```
   Pin 1 → Pista a GPIO35
   Pin 2 → Riel GND
   ```
   (Resistor divisor ya soldado en zona LDR)

6. **Bornera 12 pines** (Bombas - 6x2)
   - Conectar a salidas COM/NO de cada relé

---

#### **Paso 5: LEDs y Resistencias (ZONA 5)**

```
Por cada LED:
1. Soldar resistor 220Ω
2. Resistor → GPIO correspondiente
3. LED ánodo (+) → resistor
4. LED cátodo (-) → Riel GND
```

Distribución:
```
GPIO26 ━[220Ω]━ LED1 (Verde)   ━ GND
GPIO25 ━[220Ω]━ LED2 (Rojo)    ━ GND
GPIO4  ━[220Ω]━ LED3 (Amarillo)━ GND
GPIO2  ━[220Ω]━ LED4 (Azul)    ━ GND
GPIO15 ━[220Ω]━ LED5 (Blanco)  ━ GND
```

**Opcional:** Soldar bases para LEDs 3mm o 5mm

---

#### **Paso 6: Circuito LDR**

```
Soldadura:
1. Resistor 10kΩ:
   - Pin 1 → Riel 3.3V
   - Pin 2 → Nodo común (GPIO35)

2. Cable a bornera LDR:
   - Desde nodo común → Bornera pin 1
   - Bornera pin 2 → Riel GND
```

---

### **FASE 3: Cableado de Pistas**

Usar cable AWG22 o AWG24 (preferible flexible multifilamento)

**Códigos de colores sugeridos:**
- Rojo: +5V
- Naranja: +3.3V
- Negro: GND
- Amarillo: Señales digitales
- Verde: Señales analógicas (ADC)
- Azul: UART (TX/RX)
- Blanco: I2C (SDA/SCL) si se usa

**Routing de cables:**
1. **Alimentación primero** (gruesos, AWG18)
   - 5V y GND a módulo relés
   - 3.3V y GND a headers ESP32

2. **Señales de control** (delgados, AWG24)
   - GPIOs a borneras
   - GPIOs a módulo relés

3. **Evitar cruces** entre cables de potencia y señal

---

### **FASE 4: Preparación de Sensores en Tapa**

#### **DHT11 en Tapa**

```
1. Perforar agujero PG7 en tapa
2. Insertar prensaestopa
3. Pasar cable 3 hilos por prensaestopa
4. Soldar cable a DHT11:
   - Rojo → VCC
   - Amarillo → DATA
   - Negro → GND
5. Sellar con silicona
6. Cerrar prensaestopa
7. Conectar a bornera interna
```

#### **LDR en Tapa**

```
1. Perforar agujero pequeño (5mm) en tapa
2. Insertar LDR desde EXTERIOR
3. Fijar con pegamento transparente (exterior)
4. Soldar cable 2 hilos:
   - Amarillo → LDR pin 1
   - Negro → LDR pin 2
5. Pasar cable por agujero
6. Conectar a bornera interna
```

**Alternativa:** Usar prensaestopa miniatura

---

### **FASE 5: Montaje en Caja**

#### **Materiales adicionales:**
- 4x separadores de nylon M3 (10-15mm)
- 4x tornillos M3 (6mm)
- 4x tuercas M3
- Cinta doble cara (respaldo)

#### **Montaje:**

```
1. Perforar 4 agujeros en fondo de caja stanco
   (esquinas, para separadores)

2. Atornillar separadores desde exterior:
   Exterior caja: [Tornillo] → [Separador] → Interior

3. Fijar plancha sobre separadores:
   Plancha → [Tuerca M3]

4. Verificar que plancha no toque fondo
   (10-15mm de separación)

5. Opcional: Cinta doble cara como respaldo
```

---

## 🧪 PRUEBAS Y VALIDACIÓN

### **Prueba 1: Alimentación**

```bash
Sin ESP32 conectado:
1. Conectar fuente 5V DC a bornera
2. Multímetro:
   - Entre riel 5V y GND → debe leer 5V ± 0.1V
   - Entre riel 3.3V y GND → debe leer 3.3V ± 0.1V
3. Verificar que regulador no se calienta excesivamente
```

**✅ Debe pasar antes de continuar**

---

### **Prueba 2: LEDs**

```bash
Con ESP32 insertado:
1. Flashear firmware de prueba (test_leds.yaml)
2. Encender sistema
3. Verificar que cada LED enciende en secuencia
4. Verificar colores correctos
```

---

### **Prueba 3: Relés**

```bash
Con ESP32 + firmware:
1. Activar relé 1 desde HA
2. Escuchar "click" del relé
3. Multímetro entre COM1 y NO1 (debe conducir)
4. Repetir con relés 2-6
```

---

### **Prueba 4: Sensores**

```bash
DHT11:
- Debe mostrar temperatura ~20-25°C
- Debe mostrar humedad ~40-60%

HC-SR04:
- Debe mostrar distancia en cm

Humedad Suelo:
- Debe variar entre 0-100%

LDR:
- Debe variar con luz ambiente

LD2410C:
- Debe detectar presencia
```

---

### **Prueba 5: Integración Completa**

```bash
1. Montar plancha en caja
2. Conectar DHT11 y LDR en tapa
3. Cerrar caja
4. Conectar sensores externos
5. Probar riego manual 5 min
6. Verificar todas las lecturas en HA
```

---

## 📦 LISTA DE MATERIALES ADICIONALES

### **Componentes Electrónicos**

| Componente | Cantidad | Especificación |
|------------|----------|----------------|
| Plancha protoboard | 1 | 15x10cm mínimo |
| Headers hembra 19 pines | 2 | 2.54mm |
| Regulador AMS1117-3.3V | 1 | TO-220 o SMD |
| Condensador 100µF 16V | 1 | Electrolítico |
| Condensador 10µF 16V | 1 | Electrolítico |
| Condensador 100nF | 2 | Cerámico |
| Resistencias 220Ω | 5 | 1/4W |
| Resistencia 10kΩ | 2 | 1/4W |
| LEDs 5mm | 5 | Colores: R,Y,G,B,W |
| Bornera 2 pines | 3 | 5.08mm pitch |
| Bornera 3 pines | 2 | 5.08mm pitch |
| Bornera 4 pines | 2 | 5.08mm pitch |
| Bornera 12 pines | 1 | 5.08mm o 6x2 pines |

### **Cableado**

| Componente | Cantidad | Especificación |
|------------|----------|----------------|
| Cable AWG18 (rojo) | 2m | Alimentación 5V |
| Cable AWG18 (negro) | 2m | GND |
| Cable AWG22 multicolor | 10m | Señales |
| Cable 3 hilos AWG24 | 0.5m | DHT11 |
| Cable 2 hilos AWG24 | 0.5m | LDR |
| Cable 4 hilos AWG22 | 3m | HC-SR04, LD2410C |
| Termocontraíble | 1m | Protección |

### **Montaje**

| Componente | Cantidad | Especificación |
|------------|----------|----------------|
| Separadores nylon M3 | 4 | 10-15mm |
| Tornillos M3x6mm | 4 | Inox |
| Tuercas M3 | 4 | Inox |
| Prensaestopa PG7 | 2 | IP68 |
| Silicona neutra | 1 | Sellado |
| Cinta doble cara | 1 | Foam 3M |
| Caja Stanco | 1 | IP65, 20x15x10cm |

### **Herramientas**

- Soldador 40-60W
- Estaño 60/40 con flux
- Flux adicional
- Mecha desoldadora
- Pinzas
- Alicate corte
- Pelacables
- Multímetro
- Taladro + brocas
- Destornilladores
- Pistola termocontraíble

---

## 🔍 CONSIDERACIONES ESPECIALES

### **1. Gestión Térmica**

```
Fuentes de calor:
- Regulador AMS1117 (~200mW)
- ESP32 (~500mW)
- Módulo relés (~1W con 6 relés activos)

Total: ~2W → Temperatura interior +5-10°C

Solución:
- Ventilación: 2-4 agujeros pequeños (3mm) en tapa
- DHT11 en exterior (medición correcta)
- Separación plancha/fondo (10-15mm)
```

### **2. Humedad y Condensación**

```
Riesgo: Caja cerca del reservorio de agua

Protección:
✓ Caja IP65 (Stanco)
✓ Prensaestopas IP68
✓ Silicona en todas las penetraciones
✓ Bolsa desecante (sílica gel) dentro de caja
✓ Conformal coating en plancha (opcional)
```

### **3. Mantenimiento**

```
Diseño modular:
✓ ESP32 removible (headers)
✓ Sensores desconectables (borneras)
✓ Tapa de caja con bisagra o clips

Acceso fácil a:
- USB del ESP32 (actualización OTA o cable)
- LEDs visibles desde exterior (opcional)
- Botones de prueba (opcional)
```

### **4. Expansión Futura**

```
GPIOs libres en el diseño:
- GPIO32, GPIO33 (reserva)

Posibles adiciones:
- Sensor de pH (si se expande a hidropónico)
- Sensor de EC (conductividad)
- Display OLED I2C
- Botones de control manual
```

---

## 🎨 ACABADO PROFESIONAL

### **Opciones de Mejora**

1. **Serigrafía casera:**
   - Imprimir etiquetas en papel adhesivo transparente
   - Identificar borneras, LEDs, zonas

2. **Guías de luz:**
   - Fibra óptica desde LEDs a exterior de caja
   - Visibilidad de estados sin abrir

3. **Display exterior:**
   - OLED 0.96" I2C en tapa
   - Muestra: Temp, Humedad, Estado

4. **Botones de control:**
   - 3 botones en tapa (Modo Manual, Test, Reset)
   - GPIO con pull-up

---

## 📷 FOTOS RECOMENDADAS

Documenta el proceso:
1. Plancha marcada (zonas)
2. Rieles de alimentación soldados
3. Cada fase de componentes
4. Cableado completo
5. Pruebas con multímetro
6. Montaje en caja
7. Sistema funcionando

---

## ✅ CHECKLIST FINAL

### Antes de cerrar la caja:

- [ ] Alimentación probada (5V y 3.3V correctos)
- [ ] ESP32 inserta correctamente
- [ ] Todos los LEDs funcionan
- [ ] Relés hacen "click" al activar
- [ ] DHT11 lee temperatura y humedad
- [ ] LDR varía con luz
- [ ] HC-SR04 mide distancia
- [ ] Sensor humedad suelo responde
- [ ] LD2410C detecta presencia
- [ ] Firmware flasheado y funcionando
- [ ] Todos los cables fijados (no sueltos)
- [ ] Sin cortocircuitos (multímetro)
- [ ] Prensaestopas sellados
- [ ] Silicona en penetraciones
- [ ] Bolsa desecante dentro
- [ ] Separadores bien fijados
- [ ] Caja cierra correctamente

---

**Versión**: 1.0
**Fecha**: Diciembre 2024
**Autor**: @mauitz

---

¡Éxito con tu construcción! 🚀

