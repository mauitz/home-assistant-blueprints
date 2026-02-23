# LightNode - Lista de Materiales (BOM)

> **Bill of Materials** - Lista exacta de componentes para el montaje del LightNode

---

## COMPONENTES ELECTRÓNICOS

### Microcontrolador
- [ ] **1× ESP32 Dev Board** (30 pines)
  - Con puerto micro USB para alimentación
  - WiFi integrado

### Transistores
- [ ] **2× BC337 NPN** (TO-92)
  - Etiquetados como Q1 y Q2
  - Vceo: 45V, Ic: 800mA

### Resistencias - Canal Izquierdo
- [ ] **1× Resistencia 1kΩ** (R1 - base transistor)
  - Banda de colores: Marrón-Negro-Rojo-Dorado
- [ ] **1× Resistencia 34Ω** (R2 - limitadora LEDs)
  - Banda de colores: Naranja-Amarillo-Negro-Dorado

### Resistencias - Canal Derecho
- [ ] **1× Resistencia 1kΩ** (R3 - base transistor)
  - Banda de colores: Marrón-Negro-Rojo-Dorado
- [ ] **3× Resistencias 10Ω** (R4 - en serie = 30Ω total)
  - Banda de colores: Marrón-Negro-Negro-Dorado
  - **Importante**: Conectar las 3 en SERIE

### Resistencia - Sensor LDR
- [ ] **1× Resistencia 10kΩ** (R5 - pull-down)
  - Banda de colores: Marrón-Negro-Naranja-Dorado

### Sensores
- [ ] **1× Sensor LD2410C** (detección de presencia mmWave)
  - Módulo con UART (TX/RX)
  - Alimentación 3.3V
  
- [ ] **1× LDR** (fotorresistencia)
  - Rango típico: 1kΩ-1MΩ
  - Para detección de luz ambiente

### Cargas (LEDs)
- [ ] **2× Guirnaldas LED 5V**
  - Sin caja de pilas (cables pelados)
  - Consumo estimado: 100-300mA cada una
  - Etiquetadas como "LED Strip L" y "LED Strip R"

---

## MATERIAL DE MONTAJE

### Placa y Conexiones
- [ ] **1× Protoboard** (830 puntos mínimo)
- [ ] **Cables Dupont** (variedad de colores y longitudes)
  - Rojo: alimentación +5V y +3.3V
  - Negro: GND
  - Amarillo: PWM (GPIO 25, 26)
  - Azul: UART (GPIO 32, 33 para LD2410C)
  - Naranja: ADC (GPIO 34 para LDR)

### Alimentación
- [ ] **1× Cable micro USB**
- [ ] **1× Fuente USB 5V** (mínimo 1A recomendado)
  - Puede ser cargador de celular o puerto USB de PC

---

## HERRAMIENTAS NECESARIAS

- Pinzas de punta fina
- Cortador de alambre (opcional, para pelar cables)
- Multímetro (para verificación de continuidad y voltajes)
- Computadora con:
  - ESPHome instalado
  - Conexión WiFi
  - Home Assistant configurado

---

## RESUMEN DE CANTIDADES

| Tipo | Cantidad Total |
|------|----------------|
| ESP32 | 1 |
| Transistores BC337 | 2 |
| Resistencias 1kΩ | 2 |
| Resistencia 34Ω | 1 |
| Resistencias 10Ω | 3 |
| Resistencia 10kΩ | 1 |
| Sensor LD2410C | 1 |
| LDR | 1 |
| Guirnaldas LED 5V | 2 |
| Protoboard | 1 |
| Cables Dupont | ~20 |

---

## NOTAS IMPORTANTES

### ⚠️ Sobre las Resistencias de 10Ω (R4)
Las **3 resistencias de 10Ω deben conectarse en SERIE** (una tras otra) para obtener 30Ω total:

```
LED Strip R (-) --> [10Ω] --> [10Ω] --> [10Ω] --> Colector Q2
```

**NO las conectes en paralelo**, ya que eso daría 3.33Ω y causaría exceso de corriente.

### 💡 Verificación Rápida
- **Serie**: Resistencia total = R1 + R2 + R3 = 10Ω + 10Ω + 10Ω = 30Ω ✅
- **Paralelo**: Resistencia total = 1/(1/R1 + 1/R2 + 1/R3) = 3.33Ω ❌

### 🔍 Identificación de Resistencias por Bandas

| Valor | Banda 1 | Banda 2 | Banda 3 | Banda 4 | Visual |
|-------|---------|---------|---------|---------|--------|
| 10Ω | Marrón | Negro | Negro | Dorado | 🟤⚫⚫🟡 |
| 34Ω | Naranja | Amarillo | Negro | Dorado | 🟠🟡⚫🟡 |
| 1kΩ | Marrón | Negro | Rojo | Dorado | 🟤⚫🔴🟡 |
| 10kΩ | Marrón | Negro | Naranja | Dorado | 🟤⚫🟠🟡 |

### 📐 Preparación de Guirnaldas LED
Si tus guirnaldas vienen con caja de pilas:
1. Abre la caja de pilas
2. Identifica los cables rojo (+) y negro (-)
3. Corta los cables dejando suficiente longitud
4. Pela ~5mm de cada cable
5. Si no tiene colores: el cable que va al polo + de la pila es el positivo

### 🔌 Consideraciones de Alimentación
- **Consumo estimado total**: ~700mA máximo (ESP32 + sensores + 2 guirnaldas)
- **Fuente recomendada**: 5V @ 1A o superior
- **No alimentar desde**: USB de teclado o hub sin alimentación externa

---

## ORDEN DE MONTAJE SUGERIDO

1. ✅ Colocar ESP32 en el centro del protoboard
2. ✅ Conectar alimentación USB y verificar LED de encendido
3. ✅ Montar transistores Q1 y Q2 (izquierda y derecha)
4. ✅ Instalar resistencias de base (R1 y R3)
5. ✅ Instalar resistencias de colector:
   - R2: una sola de 34Ω
   - R4: tres de 10Ω en serie
6. ✅ Conectar guirnaldas LED (verificar polaridad)
7. ✅ Establecer GND común
8. ✅ Montar sensor LD2410C
9. ✅ Montar LDR con resistencia pull-down
10. ✅ Verificar continuidad con multímetro
11. ✅ Programar ESP32 con ESPHome
12. ✅ Probar funcionamiento

---

## VERIFICACIÓN PRE-ENERGIZADO

Antes de conectar el USB, verifica con multímetro:

- [ ] No hay cortocircuito entre 5V y GND
- [ ] No hay cortocircuito entre 3.3V y GND
- [ ] Resistencias de base están correctamente conectadas
- [ ] R4 está compuesta por 3×10Ω en SERIE (debe medir ~30Ω)
- [ ] Emisores de Q1 y Q2 están conectados a GND
- [ ] Polaridad de LEDs es correcta (rojo a 5V, negro a resistencia)

---

## COMPATIBILIDAD Y SUSTITUCIONES

### Transistores
- BC337 puede sustituirse por: BC547, 2N2222, 2N3904
- **No usar**: transistores PNP sin adaptar circuito

### Resistencias
- **R2**: Si no tienes 34Ω, puedes usar 33Ω o 39Ω
- **R4**: Alternativas si no tienes 3×10Ω:
  - 2×15Ω en serie = 30Ω
  - 22Ω + 10Ω en serie = 32Ω
  - 1×33Ω = 33Ω (casi ideal)

### Sensores
- LD2410C puede sustituirse por LD2410B o LD2410
- LDR: cualquier fotorresistencia estándar funciona

---

## RECURSOS ADICIONALES

### Datasheets
- [BC337 Datasheet](https://www.onsemi.com/pdf/datasheet/bc337-d.pdf)
- [ESP32 Pinout Reference](https://randomnerdtutorials.com/esp32-pinout-reference-gpios/)
- [LD2410C Documentation](https://github.com/esphome/esphome/blob/dev/esphome/components/ld2410/README.rst)

### Guías de Montaje
- [Proyecto_Pasillo_Luces_ESP32.md](./Proyecto_Pasillo_Luces_ESP32.md) - Documento técnico completo
- [DIAGRAMA_VISUAL_CONEXIONES.md](./DIAGRAMA_VISUAL_CONEXIONES.md) - Diagrama detallado para imagen

---

**Versión**: 1.0  
**Fecha**: 2026-01-20  
**Estado**: Lista verificada y lista para montaje
