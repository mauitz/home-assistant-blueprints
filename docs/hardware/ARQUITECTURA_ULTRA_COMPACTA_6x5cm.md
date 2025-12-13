# 🏗️ Arquitectura Ultra-Compacta - Protoboard 6.6×5.5cm

## 📐 Hardware Real Confirmado

**Protoboard:** 6.6 × 5.5 cm  
**Área útil:** ~18 filas × 20 columnas + 11 pads grandes  
**Espacio disponible:** EXTREMADAMENTE LIMITADO  

**Conclusión:** El ESP32 (5×2.5cm) **NO CABE** en la protoboard junto con otros componentes.

---

## 🎯 NUEVO ENFOQUE: Montaje Directo en Caja

### **Estrategia Completamente Diferente:**

```
┌─────────────────────────────────────────────────┐
│  CAJA STANCO 13×19×10 cm                        │
│                                                 │
│  COMPONENTES MONTADOS DIRECTAMENTE EN CAJA:    │
│                                                 │
│  ┌────────────────┐                            │
│  │ ESP32 30-pin   │  ← Tornillos directos      │
│  │ (sin protoboard)│     en fondo de caja       │
│  └───────┬────────┘                            │
│          │ Cables soldados directos            │
│          │                                      │
│  ┌───────┴────────────────┐                    │
│  │ PROTOBOARD 6.6×5.5cm   │                    │
│  │ (solo componentes      │                    │
│  │  auxiliares)           │                    │
│  │                        │                    │
│  │ - Regulador 3.3V       │                    │
│  │ - Divisor LDR          │                    │
│  │ - 5 LEDs + resistencias│                    │
│  │ - Distribución GND/VCC │                    │
│  └────────────────────────┘                    │
│                                                 │
│  ┌──────────┐                                  │
│  │ MÓDULO   │  ← Separado, cables directos     │
│  │ RELÉS 6CH│                                   │
│  └──────────┘                                  │
│                                                 │
│  DHT11, LDR, LD2410C → Pegados en paredes      │
│  HC-SR04 → En tapa (igual que antes)           │
└─────────────────────────────────────────────────┘
```

---

## 📏 ANÁLISIS DE TU PROTOBOARD

### **Distribución Real:**

```
┌───────────────────────────────────────────┐
│  PROTOBOARD 6.6×5.5 cm                    │
│                                           │
│  ┌─┐  ┌────────────────────────────┐     │
│  │1│  │                            │     │
│  │2│  │   MATRIZ 18×20             │     │
│  │3│  │   (~360 agujeros)          │     │
│  │4│  │                            │     │
│  │5│  │   Conexiones               │     │
│  │6│  │   internas                 │     │
│  │7│  │   por filas                │     │
│  │8│  │                            │     │
│  │9│  │                            │     │
│  │10│ │                            │     │
│  │11│ │                            │     │
│  └─┘  └────────────────────────────┘     │
│   ↑                                       │
│  Pads grandes                             │
│  (distribución                            │
│   de alimentación)                        │
└───────────────────────────────────────────┘
```

### **¿Qué SÍ cabe en esta protoboard?**

✅ Regulador AMS1117 (TO-220: 1×1.5cm)  
✅ 2 condensadores pequeños  
✅ 5 LEDs 3mm o 5mm  
✅ 7 resistencias (220Ω × 5, 10kΩ × 2)  
✅ Algunos cables de distribución  

❌ ESP32 30-pin (5×2.5cm) → **NO CABE**  
❌ Borneras (~3cm lineales) → **NO CABEN todas**  
❌ Módulo relés (5×3cm) → **NO CABE**  

---

## 🔧 NUEVA ARQUITECTURA: Montaje Híbrido

### **COMPONENTES Y SU UBICACIÓN:**

| Componente | Ubicación | Montaje |
|------------|-----------|---------|
| **ESP32** | Fondo de caja | Tornillos M3 + separadores |
| **Protoboard** | Junto al ESP32 | Tornillos M3 + separadores |
| **Módulo Relés** | Al lado | Tornillos o cinta |
| **Regulador 3.3V** | EN protoboard | Soldado |
| **LEDs** | EN protoboard | Soldados |
| **Divisor LDR** | EN protoboard | Soldado |
| **DHT11** | Pared lateral | Pegado (igual que antes) |
| **LDR** | Pared lateral | Pegado (igual que antes) |
| **LD2410C** | Pared opuesta | Pegado (igual que antes) |
| **HC-SR04** | Tapa/agua | Pegado (igual que antes) |

---

## 🎨 LAYOUT DETALLADO

### **1. PROTOBOARD (Solo componentes auxiliares):**

```
┌──────────────────────────────────────────┐
│  PROTOBOARD 6.6×5.5 cm                   │
│                                          │
│  PADS GRANDES (11):                      │
│  ┌─┐                                     │
│  │1├─ VCC 5V  ━━━━━━━━━━━━━━━━┓         │
│  │2├─ GND     ━━━━━━━━━━━━━━━━╋━━━┓     │
│  │3├─ VCC 3.3V ━━━━━━━━━━━━━━━╋━┓ ┃     │
│  │4├─ GND     ━━━━━━━━━━━━━━━━╋━╋━┛     │
│  │5├─ (conexión)               ┃ ┃       │
│  │6├─ (conexión)               ┃ ┃       │
│  │7├─ (conexión)               ┃ ┃       │
│  │8├─ (conexión)               ┃ ┃       │
│  │9├─ (conexión)               ┃ ┃       │
│  │10├─ (conexión)              ┃ ┃       │
│  │11├─ (conexión)              ┃ ┃       │
│  └─┘                           ┃ ┃       │
│                                ┃ ┃       │
│  ÁREA PRINCIPAL:               ┃ ┃       │
│  ┌─────────────────────────────┼─┼──┐   │
│  │                             ┃ ┃  │   │
│  │ [AMS1117]─→ IN 5V ──────────┛ ┃  │   │
│  │            OUT 3.3V ───────────┛  │   │
│  │            GND                    │   │
│  │ [C1 100µF] [C2 10µF]              │   │
│  │                                   │   │
│  │ 3.3V ━━┳━━ [R 10kΩ] ━━→ LDR pin  │   │
│  │        │                          │   │
│  │       LDR signal ━━→ ESP32 GPIO35│   │
│  │        │                          │   │
│  │ GND ━━━┻━━━━━━━━━━━━━━━━━━━━━━━ │   │
│  │                                   │   │
│  │ [LED1]─[R220Ω]─→ GPIO26 (cable)  │   │
│  │ [LED2]─[R220Ω]─→ GPIO25 (cable)  │   │
│  │ [LED3]─[R220Ω]─→ GPIO4  (cable)  │   │
│  │ [LED4]─[R220Ω]─→ GPIO2  (cable)  │   │
│  │ [LED5]─[R220Ω]─→ GPIO15 (cable)  │   │
│  │   │                               │   │
│  │ GND (común)                       │   │
│  └───────────────────────────────────┘   │
└──────────────────────────────────────────┘

NOTAS:
- Regulador: Esquina superior izquierda
- LEDs: Fila horizontal inferior
- Divisor LDR: Área central
- Rieles: Usar pads grandes 1-4
- Todo lo demás: Cables directos fuera de protoboard
```

---

### **2. ESP32 (Montado directamente en caja):**

```
FONDO DE CAJA
┌────────────────────────────┐
│                            │
│  ┌──────────────┐          │
│  │   ESP32      │          │
│  │   30-pin     │          │
│  │              │          │
│  │  [∙]    [∙]  │  ← Agujeros para tornillos
│  │              │     en la PCB del ESP32
│  └──────────────┘          │
│      ↑      ↑              │
│   Tornillo Tornillo        │
│   M2/M3    M2/M3           │
│      +        +            │
│  Separador Separador       │
│  (5-10mm) (5-10mm)         │
└────────────────────────────┘

CONEXIONES DESDE ESP32:
- Todos los pines mediante cables soldados
- Cables directos a sensores, relés, protoboard
- Sin headers (montaje permanente pero compacto)
```

**Ventaja:** Aprovecha el espacio de la caja sin ocupar la protoboard.

---

## 🔌 ESQUEMA DE CONEXIONES COMPLETO

### **Distribución de Cables:**

```
                    ┌────────────────┐
                    │  ALIMENTACIÓN  │
                    │    5V DC       │
                    └───────┬────────┘
                            │
                ┌───────────┴──────────┐
                │                      │
        ┌───────▼──────┐      ┌───────▼──────┐
        │ ESP32 VIN    │      │ Protoboard   │
        │ (5V)         │      │ Pad 1 (5V)   │
        └──────────────┘      └───────┬──────┘
                                      │
                              ┌───────▼──────┐
                              │ AMS1117 IN   │
                              │ (Regulador)  │
                              └───────┬──────┘
                                      │
                              ┌───────▼──────┐
                              │ AMS1117 OUT  │
                              │ (3.3V)       │
                              └───────┬──────┘
                                      │
                    ┌─────────────────┼─────────────────┐
                    │                 │                 │
            ┌───────▼──────┐  ┌───────▼──────┐  ┌──────▼─────┐
            │ DHT11 VCC    │  │ Hum.Suelo VCC│  │ LDR divisor│
            │ (3.3V)       │  │ (3.3V)       │  │ (3.3V)     │
            └──────────────┘  └──────────────┘  └────────────┘

GND COMÚN:
    Protoboard Pad 2/4 ━━┳━━ ESP32 GND (múltiples pines)
                          ┣━━ DHT11 GND
                          ┣━━ LDR GND
                          ┣━━ HC-SR04 GND
                          ┣━━ LD2410C GND
                          ┣━━ Hum.Suelo GND
                          ┣━━ Módulo Relés GND
                          ┗━━ LEDs GND
```

---

## 📋 TABLA DE CONEXIONES DETALLADA

### **ESP32 → Componentes (Cables directos):**

| ESP32 Pin | Destino | Cable | Longitud | Notas |
|-----------|---------|-------|----------|-------|
| **VIN** | 5V fuente | Rojo | 10cm | Alimentación |
| **GND (×4)** | GND común | Negro | 10cm | Usar múltiples |
| **3V3** | NC | - | - | NO usar (es salida) |
| **GPIO23** | Relé IN1 | Amarillo | 15cm | Bomba Z1A |
| **GPIO22** | Relé IN2 | Naranja | 15cm | Bomba Z1B |
| **GPIO21** | Relé IN3 | Verde | 15cm | Bomba Z2A |
| **GPIO19** | Relé IN4 | Azul | 15cm | Bomba Z2B |
| **GPIO18** | Relé IN5 | Violeta | 15cm | Bomba Z3A |
| **GPIO5** | Relé IN6 | Gris | 15cm | Bomba Z3B |
| **GPIO27** | DHT11 DATA | Amarillo | 30cm | Sensor temp/hum |
| **GPIO34** | Hum.Suelo OUT | Verde | Cable largo | Sensor humedad |
| **GPIO35** | LDR signal | Amarillo | 10cm | Desde protoboard |
| **GPIO13** | HC-SR04 TRIG | Amarillo | 100cm | Sensor nivel |
| **GPIO14** | HC-SR04 ECHO | Verde | 100cm | Sensor nivel |
| **GPIO32** | LD2410C RX | Verde | 40cm | Presencia |
| **GPIO33** | LD2410C TX | Azul | 40cm | Presencia |
| **GPIO26** | LED1 | Rojo | 10cm | A protoboard |
| **GPIO25** | LED2 | Naranja | 10cm | A protoboard |
| **GPIO4** | LED3 | Amarillo | 10cm | A protoboard |
| **GPIO2** | LED4 | Azul | 10cm | A protoboard |
| **GPIO15** | LED5 | Blanco | 10cm | A protoboard |

### **Protoboard → Sensores:**

| Protoboard | Destino | Cable | Longitud |
|------------|---------|-------|----------|
| **Pad 1 (5V)** | Fuente + | Rojo | 10cm |
| **Pad 2 (GND)** | Fuente - | Negro | 10cm |
| **Pad 3 (3.3V)** | DHT11 VCC | Rojo | 30cm |
| **Pad 3 (3.3V)** | Hum.Suelo VCC | Rojo | Cable largo |
| **LDR signal** | ESP32 GPIO35 | Amarillo | 10cm |
| **LED cátodos** | GND | Negro | interno |

---

## 🛠️ PROCESO DE CONSTRUCCIÓN ACTUALIZADO

### **FASE 1: Preparar Protoboard (1-2 horas)**

**Componentes en protoboard:**

1. **Regulador AMS1117:**
   ```
   Pin 1 (GND)  → Pad 2 (GND)
   Pin 2 (OUT)  → Pad 3 (3.3V)
   Pin 3 (IN)   → Pad 1 (5V)
   ```

2. **Condensadores:**
   - C1 (100µF): Entre Pad 1 (5V) y Pad 2 (GND)
   - C2 (10µF): Entre Pad 3 (3.3V) y Pad 4 (GND)

3. **Divisor LDR:**
   ```
   Pad 3 (3.3V) ━━━ [R 10kΩ] ━━━┳━━━ Signal → ESP32 GPIO35
                                 │
                              [Cable LDR]
                                 │
                    Pad 2 (GND) ━┻━━━ GND
   ```

4. **5 LEDs con resistencias:**
   ```
   Para cada LED:
   Cable desde ESP32 GPIO → [R 220Ω] → LED (+) → LED (-) → GND
   
   Soldadura en protoboard:
   - 5 resistencias en fila
   - 5 LEDs en fila
   - Todos los cátodos a GND común
   - Cables de entrada para los 5 GPIOs
   ```

5. **Distribución de alimentación:**
   - Usar pads grandes 1-4 como rieles
   - Puentes internos para distribuir 5V y GND
   - Salidas de 3.3V hacia sensores

**Resultado:** Protoboard compacta lista, con solo componentes auxiliares.

---

### **FASE 2: Montar ESP32 en Caja (30 min)**

**Pasos:**

1. **Marcar ubicación del ESP32:**
   - Centrado en el fondo de la caja
   - Dejar espacio para cables y otros componentes

2. **Perforar agujeros para tornillos:**
   - 2 agujeros M2 o M3 en fondo de caja
   - Alineados con agujeros del ESP32 (si tiene)
   - Si no tiene: usar cinta doble cara VHB

3. **Instalar separadores:**
   - Tornillo M2/M3 desde exterior
   - Separador de nylon 5-10mm altura
   - ESP32 atornillado sobre separadores

4. **Alternativa sin agujeros en ESP32:**
   - Cinta doble cara foam (3M VHB)
   - Hot glue en esquinas (no en componentes)
   - Asegurar que USB sea accesible

---

### **FASE 3: Montar Protoboard y Relés (30 min)**

1. **Protoboard junto al ESP32:**
   - Separadores M3 (10mm)
   - O cinta doble cara

2. **Módulo relés:**
   - Al lado opuesto
   - Separado del ESP32 (reduce ruido)
   - Tornillos o cinta

**Layout en fondo de caja:**
```
┌──────────────────────────┐
│ ESP32    Protoboard      │
│          (6.6×5.5)       │
│                          │
│              Módulo      │
│              Relés       │
│              6ch         │
└──────────────────────────┘
```

---

### **FASE 4: Cablear Todo (2-3 horas)**

**Orden recomendado:**

1. **Alimentación primero:**
   - Cable 5V desde prensaestopa a ESP32 VIN
   - Cable 5V desde ESP32 a protoboard Pad 1
   - Cable GND común (múltiples conexiones)

2. **Relés (6 cables control + 2 alimentación):**
   - ESP32 GPIO23-22-21-19-18-5 → Relés IN1-6
   - 5V y GND a módulo relés

3. **LEDs (5 cables desde ESP32 a protoboard):**
   - GPIO26, 25, 4, 2, 15 → Protoboard entradas LEDs

4. **Sensores en paredes (DHT11, LDR, LD2410C):**
   - DHT11: VCC(3.3V), DATA(GPIO27), GND
   - LDR: Signal(desde protoboard), GND
   - LD2410C: VCC(5V), TX(GPIO32), RX(GPIO33), GND

5. **Sensores externos (HC-SR04, Hum.Suelo):**
   - HC-SR04: VCC(5V), TRIG(GPIO13), ECHO(GPIO14), GND
   - Hum.Suelo: VCC(3.3V), OUT(GPIO34), GND

**Técnica de soldadura de cables al ESP32:**
```
1. Pelar cable 3-5mm
2. Estañar el extremo
3. Estañar el pad del ESP32
4. Soldar cable al pad (rápido, no sobrecalentar)
5. Termocontraíble sobre soldadura
6. Asegurar cable con hot glue cerca del ESP32
```

---

### **FASE 5: Sensores en Paredes (1 hora)**

**Igual que diseño anterior:**
- DHT11: Pared izq. con ventilación
- LDR: Pared izq. con agujero
- LD2410C: Pared derecha sin agujero
- HC-SR04: Tapa inferior + tapa reservorio

---

## 🧪 PRUEBAS

### **Prueba 1: Alimentación**
```
Sin conectar sensores:
✓ Medir 5V en ESP32 VIN
✓ Medir 5V en protoboard Pad 1
✓ Medir 3.3V en protoboard Pad 3
✓ Regulador no se calienta
```

### **Prueba 2: ESP32**
```
Flashear firmware:
✓ ESP32 se conecta por USB
✓ Firmware sube correctamente
✓ ESP32 aparece en HA
```

### **Prueba 3: LEDs y Relés**
```
Desde HA:
✓ Activar cada LED (5 de 5)
✓ Activar cada relé (6 de 6)
✓ Escuchar "click" de relés
```

### **Prueba 4: Sensores**
```
Con todo conectado:
✓ DHT11 lee temperatura
✓ LDR varía con luz
✓ LD2410C detecta presencia
✓ HC-SR04 mide distancia
✓ Sensor humedad responde
```

---

## ✅ CHECKLIST DE MATERIALES FINAL

### **Protoboard (solo auxiliares):**
- [x] Protoboard 6.6×5.5 cm (la tuya)
- [x] Regulador AMS1117-3.3V
- [x] Condensadores 100µF + 10µF
- [x] 5× LEDs 3mm/5mm
- [x] 5× R 220Ω + 2× R 10kΩ
- [x] Cable AWG24 multicolor (10m)

### **Montaje ESP32:**
- [x] ESP32 30-pin (el tuyo)
- [x] 2× Tornillos M2/M3 + separadores
- [x] O cinta doble cara VHB
- [x] Estaño + flux (soldadura cables)
- [x] Termocontraíble (protección soldaduras)

### **Cables punto a punto:**
- [x] Cable multicolor AWG22/24 (15m)
- [x] Cable identificable por colores
- [x] Termocontraíble varios tamaños

### **Sensores (igual que antes):**
- [x] DHT11 + cable 30cm
- [x] LDR + cable 30cm
- [x] LD2410C + cable 40cm
- [x] HC-SR04 + cable 1m
- [x] Sensor humedad suelo

### **Caja y montaje:**
- [x] Caja Stanco 13×19×10 cm
- [x] 6× Separadores nylon M3 (10mm)
- [x] 8× Tornillos M2/M3
- [x] 3-4× Prensaestopas
- [x] Silicona + hot glue
- [x] Cinta doble cara VHB

---

## 📊 COMPARACIÓN DE DISEÑOS

| Aspecto | Diseño Original | Diseño Compacto (v2) | **Diseño Ultra-Compacto (v3)** |
|---------|-----------------|----------------------|--------------------------------|
| Protoboard | 15×10cm | 9×15cm | **6.6×5.5cm** ✅ |
| ESP32 ubicación | En protoboard | En protoboard | **Separado en caja** ✅ |
| Uso protoboard | Todo | Componentes críticos | **Solo auxiliares** ✅ |
| Complejidad | Media | Media-Alta | **Alta** ⚠️ |
| Cables soldados | Pocos | Algunos | **Muchos** ⚠️ |
| Mantenibilidad | Alta (headers) | Media | **Baja** (soldado) ⚠️ |
| Compacidad | Baja | Media | **Máxima** ✅ |

---

## 🎯 VENTAJAS Y DESVENTAJAS

### **Ventajas ✅:**
- ✅ Usa tu protoboard real (6.6×5.5cm)
- ✅ Máxima compacidad posible
- ✅ Aprovecha todo el espacio de la caja
- ✅ Componentes en ubicaciones óptimas
- ✅ Menos puntos de fallo (menos conectores)

### **Desventajas ⚠️:**
- ⚠️ ESP32 soldado (no removible fácilmente)
- ⚠️ Muchos cables punto a punto
- ⚠️ Más tiempo de construcción
- ⚠️ Difícil de modificar después
- ⚠️ Requiere buenas habilidades de soldadura

---

## 💡 RECOMENDACIONES FINALES

### **Para este diseño ultra-compacto:**

1. **Planifica ANTES de soldar:**
   - Dibuja el routing de cables
   - Usa colores consistentes
   - Mide longitudes necesarias

2. **Soldadura de calidad:**
   - Soldador 40-60W
   - Estaño 60/40 con flux
   - Juntas brillantes (no opacas)
   - Termocontraíble en TODAS las soldaduras

3. **Gestión de cables:**
   - Usa bridas/amarras pequeñas
   - Agrupa cables por función
   - Etiqueta cables (cinta washi)
   - Hot glue para alivio de tensión

4. **Documenta TODO:**
   - Fotos de cada paso
   - Diagrama final de conexiones
   - Colores de cables anotados

5. **Prueba incremental:**
   - Probar cada componente al agregarlo
   - No soldar todo y probar al final
   - Usa multímetro constantemente

---

## 📚 ARCHIVOS DE DISEÑO

He creado un documento completo específico para tu protoboard de 6.6×5.5cm:

📄 **[ARQUITECTURA_ULTRA_COMPACTA_6x5cm.md](docs/hardware/ARQUITECTURA_ULTRA_COMPACTA_6x5cm.md)**

---

**Versión:** 3.0 (Ultra-Compacta Real)  
**Fecha:** Diciembre 2024  
**Hardware:** Protoboard 6.6×5.5cm + ESP32 montado separado  
**Complejidad:** Alta (muchos cables soldados)  
**Autor:** @mauitz

