# LightNode - Diagrama Visual de Conexiones
## Documento para Generación de Imagen Técnica

> **Propósito**: Este documento describe detalladamente el diagrama de conexiones del sistema LightNode para que un modelo de generación de imágenes (IA) pueda crear una representación gráfica precisa y clara.

---

## DESCRIPCIÓN GENERAL DEL LAYOUT

**Vista**: Diagrama esquemático horizontal de circuito electrónico
**Estilo**: Técnico profesional con componentes claramente identificados
**Elementos principales**: ESP32 en el centro, dos etapas de potencia simétricas, sensores en zona superior

---

## COMPONENTES Y POSICIONES

### 1. ESP32 Dev Board (Centro del diagrama)
- **Posición**: Centro del diagrama
- **Representación**: Placa de desarrollo ESP32 con 30 pines (15 por lado)
- **Etiquetas visibles**:
  - Pines de alimentación: "5V", "3.3V", "GND"
  - GPIOs específicos: "GPIO 25", "GPIO 26", "GPIO 34", "GPIO 32", "GPIO 33"
- **Alimentación**: Cable USB conectado al pin "5V" con símbolo USB

### 2. Etapa de Potencia Izquierda (Canal 1 - Guirnalda Izquierda)
- **Posición**: Lado izquierdo del ESP32
- **Componentes**:
  - **Transistor BC337 (Q1)**:
    - Forma: Símbolo NPN con encapsulado TO-92
    - Etiquetas: "C" (colector), "B" (base), "E" (emisor)
    - Texto: "BC337 Q1"

  - **Resistencia de Base (R1)**:
    - Entre GPIO 25 y Base del transistor
    - Valor: "1kΩ"
    - Color: Naranja (resistencia)

  - **Resistencia de Colector (R2)**:
    - Entre LEDs y Colector del transistor
    - Valor: "34Ω"
    - Color: Naranja (resistencia)

  - **Guirnalda LED Izquierda**:
    - Símbolo: Cadena de 3-4 LEDs conectados
    - Etiqueta: "LED Strip L 5V"
    - Terminal positivo conectado a 5V del ESP32
    - Terminal negativo conectado a R2

**Flujo de conexiones Canal 1**:
```
ESP32 GPIO 25 --[R1: 1kΩ]--> Base BC337(Q1)
ESP32 5V --> (+) LED Strip L (-) --[R2: 34Ω]--> Colector BC337(Q1)
Emisor BC337(Q1) --> GND
```

### 3. Etapa de Potencia Derecha (Canal 2 - Guirnalda Derecha)
- **Posición**: Lado derecho del ESP32 (simétrica a la izquierda)
- **Componentes**: Idénticos al Canal 1, con las siguientes diferencias:
  - **Transistor BC337 (Q2)**
  - **Resistencia de Base (R3)**: "1kΩ"
  - **Resistencia de Colector (R4)**: "30Ω (3×10Ω en serie)"
  - **Guirnalda LED Derecha**: "LED Strip R 5V"

**Flujo de conexiones Canal 2**:
```
ESP32 GPIO 26 --[R3: 1kΩ]--> Base BC337(Q2)
ESP32 5V --> (+) LED Strip R (-) --[R4: 30Ω (3×10Ω)]--> Colector BC337(Q2)
Emisor BC337(Q2) --> GND
```

> **Nota**: R4 está compuesta por tres resistencias de 10Ω conectadas en serie para obtener 30Ω total, muy cercano al valor ideal de 34Ω del canal izquierdo.

### 4. Sensor LDR (Parte Superior Izquierda)
- **Posición**: Arriba a la izquierda del ESP32
- **Componentes**:
  - **LDR (Fotorresistencia)**:
    - Símbolo: Resistencia con flechas hacia adentro
    - Etiqueta: "LDR"

  - **Resistencia Pull-down (R5)**:
    - Valor: "10kΩ"
    - Entre GPIO 34 y GND

**Flujo de conexiones LDR**:
```
ESP32 3.3V --> LDR --> GPIO 34 (ADC)
GPIO 34 --[R5: 10kΩ]--> GND
```

### 5. Sensor LD2410C (Parte Superior Izquierda)
- **Posición**: Arriba a la izquierda del ESP32 (lado opuesto al LDR)
- **Representación**: Módulo sensor mmWave con pines
- **Pines visibles**:
  - "VCC" conectado a 3.3V del ESP32
  - "TX" conectado a GPIO 32 (RX del ESP32, lado izquierdo)
  - "RX" conectado a GPIO 33 (TX del ESP32, lado izquierdo)
  - "GND" conectado a GND común

**Flujo de conexiones LD2410C**:
```
ESP32 3.3V --> LD2410C VCC
ESP32 GPIO 32 --> LD2410C TX
ESP32 GPIO 33 --> LD2410C RX
LD2410C GND --> GND común
```

> **Nota**: Se usan GPIO 32 y 33 del lado izquierdo del ESP32 para optimizar el layout físico del montaje, manteniendo los cables cortos y evitando cruces.

---

## SISTEMA DE GND COMÚN

- **Representación**: Línea horizontal gruesa en la parte inferior del diagrama
- **Símbolo**: Símbolo de tierra (⏚) repetido en varios puntos
- **Conexiones al GND común**:
  - Emisor del BC337 (Q1)
  - Emisor del BC337 (Q2)
  - GND del ESP32
  - GND del LD2410C
  - Resistencia R5 (pull-down del LDR)

---

## CÓDIGO DE COLORES PARA CABLES

Para mejorar la claridad visual del diagrama, usa estos colores estándar:

- **Rojo**: Alimentación positiva (+5V, +3.3V)
- **Negro**: GND (tierra)
- **Amarillo**: Señales PWM (GPIO 25, GPIO 26)
- **Azul**: Comunicación UART (GPIO 16, GPIO 17)
- **Naranja**: Señal analógica ADC (GPIO 34)
- **Gris**: Conexiones de resistencias

---

## ANOTACIONES Y ETIQUETAS IMPORTANTES

### Voltajes y corrientes
- Cerca del pin 5V: "5V USB"
- Cerca del pin 3.3V: "3.3V (sensores)"
- Junto a cada guirnalda: "5V LED String"

### Advertencias visuales
- Junto a los BC337: "⚠️ Caída de tensión ~0.7V"
- En zona de potencia: "PWM Control (0-100%)"

### Valores de componentes
- Cada resistencia debe mostrar su valor claramente
- Los transistores deben estar etiquetados como "BC337 (NPN)"
- R4 debe indicar "3×10Ω = 30Ω" para claridad de montaje

---

## SIMBOLOGÍA A UTILIZAR

### Transistor NPN (BC337)
```
    C (Colector)
    |
  --+--
 |     |
-|  Q  |
 |     |
  --+--
    |
    E (Emisor)

B (Base) ---|
```

### Resistencia
```
--[====]--  (con valor al lado: "1kΩ", "34Ω", "30Ω", "10kΩ")
```

### Resistencias en Serie (R4 = 3×10Ω)
```
--[10Ω]--[10Ω]--[10Ω]--  (etiqueta: "30Ω total")
```

### LED / LED Strip
```
--[>|]--[>|]--[>|]--  (cadena de LEDs)
```

### LDR (Fotorresistencia)
```
   ↓ ↓
--[====]--
```

### Módulo (LD2410C)
```
┌─────────┐
│ LD2410C │
├─────────┤
│  VCC    │---
│  TX     │---
│  RX     │---
│  GND    │---
└─────────┘
```

---

## DISPOSICIÓN ESPACIAL DETALLADA

```
   [LD2410C]                            [LDR]
       |                                  |
       +--------+--------+--------+-------+
                |  3.3V  |  3.3V  |
                |        |        |
   [Q1]       GPIO32  ESP32   GPIO34     [Q2]
   BC337      GPIO33  DEV      (ADC)     BC337
    |           |     BOARD      |         |
   [R2]       GPIO25        GPIO26      [R4]
    |           |              |          |
  [LED L]       |              |       [LED R]
                |              |
                +──────────────+
                       |
                 [GND COMÚN]
                      ⏚
```

---

## INSTRUCCIONES PARA EL MODELO DE IA

**Estilo artístico**: Diagrama esquemático técnico profesional, limpio y claro

**Elementos a destacar**:
1. Simetría visual entre ambos canales de LEDs
2. Claridad en las conexiones PWM desde los GPIO
3. Separación clara entre zona de potencia (5V) y zona de sensores (3.3V)
4. GND común bien visible y conectado a todos los componentes necesarios
5. Sensores distribuidos: LD2410C a la izquierda (GPIO 32/33), LDR a la derecha (GPIO 34)
6. Layout optimizado: sensores en lados opuestos del ESP32 para cables cortos y sin cruces

**Calidad del diagrama**:
- Líneas nítidas y rectas
- Texto legible en todos los componentes
- Símbolos electrónicos estándar IEEE
- Flujo de izquierda a derecha y de arriba a abajo
- Espaciado adecuado entre componentes

**Formato de salida sugerido**:
- SVG o PNG de alta resolución (mínimo 1920x1080)
- Fondo blanco o ligeramente gris (#F5F5F5)
- Líneas negras o azul oscuro
- Componentes con relleno sutil

---

## TABLA RESUMEN DE CONEXIONES

| Desde         | Componente | Hacia        | Componente | Notas                    |
|---------------|------------|--------------|------------|--------------------------|
| ESP32 5V      | Pin        | LED Strip L  | Positivo   | Canal izquierdo          |
| ESP32 5V      | Pin        | LED Strip R  | Positivo   | Canal derecho            |
| ESP32 GPIO 25 | Pin        | R1           | Terminal   | Control PWM izquierda    |
| R1            | Terminal   | Q1 Base      | Pin        | Resistencia 1kΩ          |
| LED Strip L   | Negativo   | R2           | Terminal   | Resistencia 34Ω          |
| R2            | Terminal   | Q1 Colector  | Pin        | -                        |
| Q1 Emisor     | Pin        | GND          | Común      | -                        |
| ESP32 GPIO 26 | Pin        | R3           | Terminal   | Control PWM derecha      |
| R3            | Terminal   | Q2 Base      | Pin        | Resistencia 1kΩ          |
| LED Strip R   | Negativo   | R4           | Terminal   | Resistencia 30Ω (3×10Ω) |
| R4            | Terminal   | Q2 Colector  | Pin        | -                        |
| Q2 Emisor     | Pin        | GND          | Común      | -                        |
| ESP32 3.3V    | Pin        | LDR          | Terminal   | Alimentación sensor luz  |
| LDR           | Terminal   | GPIO 34      | Pin        | Señal analógica          |
| GPIO 34       | Pin        | R5           | Terminal   | Pull-down 10kΩ           |
| R5            | Terminal   | GND          | Común      | -                        |
| ESP32 3.3V    | Pin        | LD2410C VCC  | Pin        | Alimentación sensor      |
| ESP32 GPIO 32 | Pin        | LD2410C TX   | Pin        | UART RX del ESP32        |
| ESP32 GPIO 33 | Pin        | LD2410C RX   | Pin        | UART TX del ESP32        |
| LD2410C GND   | Pin        | GND          | Común      | -                        |
| ESP32 GND     | Pin        | GND          | Común      | Referencia común         |

---

## INFORMACIÓN TÉCNICA ADICIONAL

### Características eléctricas
- **Alimentación principal**: 5V DC vía USB (500mA - 1A recomendado)
- **Tensión de sensores**: 3.3V (regulador interno del ESP32)
- **Corriente por LED strip**: ~100-300mA por guirnalda (máx)
- **PWM frequency**: 5kHz (recomendado para LEDs)
- **PWM resolution**: 8 bits (0-255)

### Consideraciones de diseño
1. **Caída de tensión en BC337**: ~0.7V entre colector y emisor, las guirnaldas recibirán ~4.3V en lugar de 5V
2. **Disipación de calor**: Los BC337 pueden calentarse con corrientes >300mA
3. **Protección**: Considerar agregar diodos flyback si se cambian las guirnaldas por cargas inductivas
4. **Alternativa futura**: Reemplazar BC337 por MOSFET logic-level (ej: IRLZ44N) para mayor eficiencia

### Configuración específica de resistencias
- **R2 (Canal Izquierdo)**: 34Ω (resistencia única)
- **R4 (Canal Derecho)**: 30Ω total (3 resistencias de 10Ω en serie)
- **Diferencia de brillo**: ~12% más corriente en canal derecho → brillo ligeramente mayor
- **Compensación**: Opcional via software (ajuste PWM) si se requiere brillo idéntico
- **Consumo estimado**: Canal L ~120mA, Canal R ~127mA (a máximo brillo)

---

## PROMPTS SUGERIDOS PARA GENERACIÓN DE IMAGEN

### Prompt básico
```
Create a professional electronic circuit schematic diagram for a LightNode system.
The diagram should show an ESP32 development board in the center, with two
symmetrical NPN transistor (BC337) stages for controlling LED strips on the left
and right sides. Include sensors at the top: LDR (light sensor) on the left,
and LD2410C (mmWave presence sensor) on the right. Use standard IEEE electronic
symbols, clear labels for all components (resistors with values, GPIO pin numbers),
and show a common ground connection at the bottom. Use a clean white background
with black lines and subtle color coding for different signal types.
```

### Prompt detallado
```
Generate a detailed electronic schematic diagram with the following specifications:

CENTRAL COMPONENT:
- ESP32 development board with labeled pins: 5V, 3.3V, GND, GPIO 25, GPIO 26,
  GPIO 34, GPIO 32, GPIO 33

LEFT SIDE (PWM Channel 1):
- BC337 NPN transistor (Q1) with labeled C, B, E pins
- 1kΩ resistor (R1) between GPIO 25 and base
- 34Ω resistor (R2) between LED strip and collector
- LED strip symbol labeled "LED Strip L 5V"
- Emitter connected to ground

RIGHT SIDE (PWM Channel 2):
- Mirrored configuration with BC337 (Q2), R3 (1kΩ), R4 (30Ω, shown as 3×10Ω in series), and LED Strip R

TOP SENSORS:
- LD2410C module with VCC, TX (GPIO 32), RX (GPIO 33), GND connections (top left)
- LDR with 10kΩ pull-down resistor to GPIO 34 (top right)

BOTTOM:
- Common ground bus connecting all ground points with ground symbol

STYLING:
- Professional technical diagram style
- Clear component labels and values
- Standard electronic symbols (IEEE/IEC)
- Color-coded wires: red (5V), black (GND), yellow (PWM), blue (UART), orange (analog)
- High resolution, clean white background
- Adequate spacing between components
```

---

## VERSIÓN Y METADATOS

- **Versión del documento**: 1.3
- **Fecha de creación**: 2026-01-20
- **Última actualización**: 2026-01-20
- **Proyecto**: LightNode - Sistema de iluminación inteligente con ESP32
- **Autor**: Generado para proyecto de domótica Home Assistant
- **Propósito**: Base para generación de diagrama técnico mediante IA

### Historial de cambios
- **v1.3** (2026-01-20): Optimización de pines - LD2410C movido a GPIO 32/33 (lado izquierdo) para mejor layout
- **v1.2** (2026-01-20): Eliminado sensor DHT11 del diseño (no se usará temperatura/humedad)
- **v1.1** (2026-01-20): Actualizado R4 a 30Ω (3×10Ω en serie) según disponibilidad de componentes
- **v1.0** (2026-01-20): Versión inicial del documento

---

**Documento listo para ser utilizado con modelos de generación de imágenes como DALL-E, Midjourney, Stable Diffusion, o similares.**
