# Guía: Uso del Tester/Multímetro para Smart Node V2

**Fecha:** 2 de enero de 2026
**Propósito:** Verificar voltajes y corrientes del sistema de alimentación

---

## 📐 Introducción al Multímetro

### Partes del Tester

```
┌─────────────────────┐
│    [PANTALLA LCD]   │
│                     │
│   ┌─────────┐       │
│   │ SELECTOR│       │  ← Perilla giratoria
│   │ ROTATIVO│       │
│   └─────────┘       │
│                     │
│  [Botones]          │
│                     │
│  ○ COM (Negro)      │  ← Puerto común (siempre conectado)
│  ○ VΩmA (Rojo)      │  ← Voltaje/Resistencia/mA
│  ○ 10A (Rojo)       │  ← Corriente alta (NO usar inicialmente)
└─────────────────────┘
```

### Cables/Puntas

- **Cable NEGRO** → Siempre en puerto **COM**
- **Cable ROJO** → Puerto **VΩmA** (para voltaje)

---

## 📊 Mediciones a Realizar

### 1️⃣ Voltaje de la Batería (Sin Carga)

**Objetivo:** Verificar el estado de carga de la batería 18650

#### Pasos:

```
1. DESCONECTAR USB del TP4056
2. DESCONECTAR la batería del TP4056 (cables BAT+ y BAT-)
3. Configurar tester:
   - Cable NEGRO → COM
   - Cable ROJO → VΩmA
   - Selector en: DCV 20V (o símbolo V⎓)
4. Medir:
   - Punta NEGRA → Terminal negativo batería (-)
   - Punta ROJA → Terminal positivo batería (+)
5. Leer pantalla
```

#### Valores Esperados:

| Voltaje | Estado | Acción |
|---------|--------|--------|
| **4.2V** | Cargada 100% | ✅ Perfecta |
| **3.7-4.0V** | Cargada 50-80% | ✅ Normal |
| **3.4-3.7V** | Cargada 20-50% | ⚠️ Necesita carga |
| **3.0-3.4V** | Casi vacía | ⚠️ Cargar pronto |
| **<3.0V** | Descargada crítica | 🔴 Peligro - puede dañarse |
| **>4.3V** | Sobrecarga | 🔴 PELIGRO - desconectar |

---

### 2️⃣ Voltaje del USB (Entrada TP4056)

**Objetivo:** Verificar que el USB entrega 5V correctos

#### Pasos:

```
1. CONECTAR USB Type-C al TP4056
2. NO conectar batería aún
3. Configurar tester:
   - Cable NEGRO → COM
   - Cable ROJO → VΩmA
   - Selector en: DCV 20V
4. Medir en los pads del TP4056:
   - Punta NEGRA → IN- (GND del USB)
   - Punta ROJA → IN+ (5V del USB)
5. Leer pantalla
```

#### Valores Esperados:

| Voltaje | Estado | Acción |
|---------|--------|--------|
| **4.8-5.3V** | ✅ Normal | OK para cargar |
| **4.5-4.8V** | ⚠️ Bajo | Cambiar cable/cargador USB |
| **<4.5V** | 🔴 Insuficiente | NO usar - puede dañar TP4056 |
| **>5.5V** | 🔴 Alto | Peligro de sobrevoltaje |

---

### 3️⃣ Voltaje de Salida (OUT+ / OUT-)

**Objetivo:** Verificar voltaje que llega al ESP32

#### Pasos:

```
1. CONECTAR batería al TP4056 (BAT+, BAT-)
2. NO conectar USB (medición solo con batería)
3. Configurar tester igual que antes
4. Medir:
   - Punta NEGRA → OUT- (o GND del ESP32)
   - Punta ROJA → OUT+ (o VIN del ESP32)
5. Leer pantalla
```

#### Valores Esperados:

| Voltaje | Estado | Acción |
|---------|--------|--------|
| **3.7-4.2V** | ✅ Normal | Coincide con voltaje batería |
| **3.3-3.7V** | ⚠️ Batería baja | Cargar pronto |
| **<3.0V** | 🔴 Crítico | ESP32 puede no funcionar |

**Nota:** El TP4056 NO regula el voltaje, pasa el voltaje de la batería directamente a OUT+

---

### 4️⃣ Corriente de Carga (Avanzado)

**⚠️ IMPORTANTE:** Esta medición es **delicada** y puede dañar el tester si se hace mal.

#### Pasos:

```
1. APAGAR el TP4056 (desconectar USB)
2. Desconectar el cable BAT+ de la batería
3. Configurar tester para CORRIENTE:
   - Cable NEGRO → COM
   - Cable ROJO → VΩmA (para <200mA)
   - Selector en: DCA 200mA o 2000mA
4. RECONECTAR en SERIE:

   [BAT+ del TP4056] → [ROJA del tester]
                     → [NEGRA del tester]
                     → [+ de la batería]

5. CONECTAR USB para iniciar carga
6. Leer corriente en pantalla
7. Medir por NO MÁS de 10 segundos
8. DESCONECTAR y volver a conectar normalmente
```

#### Valores Esperados Durante Carga:

| Corriente | Estado | Calor Esperado |
|-----------|--------|----------------|
| **800-1000mA** | ✅ Carga máxima | 🔥🔥🔥 Muy caliente (normal) |
| **400-800mA** | ✅ Carga media | 🔥🔥 Caliente (normal) |
| **100-400mA** | ⚠️ Batería casi llena | 🔥 Tibio |
| **<100mA** | ✅ Carga completa | ❄️ Frío |
| **>1200mA** | 🔴 Sobrecorriente | 🔥🔥🔥🔥 Peligro |

**⚠️ PRECAUCIÓN:**
- Si el tester pita o muestra "OL", ¡DESCONECTA INMEDIATAMENTE!
- NO midas corriente en paralelo (como voltaje), siempre en SERIE
- Si no estás seguro, **NO hagas esta medición**

---

### 5️⃣ Voltaje 3.3V del ESP32

**Objetivo:** Verificar regulador interno del ESP32

#### Pasos:

```
1. ESP32 debe estar encendido (conectado a batería)
2. Medir:
   - Punta NEGRA → Pin GND del ESP32
   - Punta ROJA → Pin 3V3 del ESP32
```

#### Valores Esperados:

| Voltaje | Estado |
|---------|--------|
| **3.2-3.4V** | ✅ Normal |
| **<3.1V** | 🔴 Problema con regulador |

---

## 🔥 Diagnóstico del Problema de Temperatura

### Causas del Sobrecalentamiento

#### 1. **Corriente de Carga Alta (Normal)**

Si la batería está muy descargada (3.0-3.5V), el TP4056 cargará a 1A completo:

```
Disipación = (5V - 3.5V) × 1A = 1.5W de calor
Temperatura = 70-90°C (muy caliente pero aceptable)
```

**Solución:** Esperar. Cuando llegue a 4.0V, bajará a ~0.5A y se enfriará.

#### 2. **Mala Ventilación**

Si el TP4056 está:
- Pegado a una superficie aislante (madera, plástico)
- Sin flujo de aire
- Cubierto por otros componentes

**Solución:** Ver sección de mejoras abajo.

#### 3. **Cortocircuito Parcial** 🔴

Si hay un cortocircuito en la batería o cables:

```
Corriente > 1.2A → Temperatura > 100°C → PELIGRO
```

**Verificar con tester:**
- Medir corriente de carga (paso 4)
- Si es >1.2A, HAY PROBLEMA

#### 4. **TP4056 Defectuoso**

Chip dañado o falsificación de baja calidad.

**Verificar:**
- Comparar con otro módulo TP4056
- Reemplazar por uno de mejor calidad

---

## ✅ Checklist de Verificación con Tester

### Antes de Cargar

- [ ] Voltaje batería: 3.0-4.2V (paso 1)
- [ ] Voltaje USB: 4.8-5.3V (paso 2)
- [ ] No hay cortocircuitos visibles

### Durante la Carga (Primeros 5 minutos)

- [ ] LED rojo encendido en TP4056
- [ ] Corriente: 800-1000mA (paso 4 - opcional)
- [ ] Temperatura: Caliente pero tocable >3 segundos
- [ ] Voltaje batería subiendo gradualmente

### Después de 30 Minutos

- [ ] Temperatura estabilizada o bajando
- [ ] Voltaje batería: >3.8V (paso 1)

### Carga Completa (2-3 horas)

- [ ] LED azul encendido en TP4056
- [ ] Corriente: <100mA
- [ ] Temperatura: Tibia o fría
- [ ] Voltaje batería: 4.15-4.20V

---

## 🛠️ Soluciones al Problema de Temperatura

### Solución 1: Disipador de Calor (RECOMENDADO)

```
Material: Disipador pequeño de aluminio (10x10mm)
Instalación:
1. Limpiar la superficie del chip IC del TP4056 con alcohol
2. Aplicar pasta térmica (muy poco)
3. Pegar disipador con cinta térmica adhesiva
4. NO usar silicona caliente (se derrite)
```

**Resultado esperado:** Reducción de 10-20°C

### Solución 2: Espaciado y Ventilación

```
ANTES:                    DESPUÉS:
┌─────────┐              ┌─────────┐
│ TP4056  │              │ TP4056  │ ← Elevado 5mm
│=========│              │░░░░░░░░░│    con separadores
│ Silicona│              │         │
│ Pegada  │              └─────────┘
└─────────┘                 ↑↑↑↑↑
                         Flujo de aire
```

**Opciones:**
- Espaciadores de plástico (5mm)
- Montaje con tornillos en lugar de pegamento
- Orientar el chip hacia arriba

### Solución 3: Reducir Corriente de Carga (Opcional)

Cambiar la resistencia R_PROG del TP4056:

```
Resistencia actual: ~1.2kΩ → 1A de carga
Cambiar a: 2.4kΩ → 0.5A de carga (menos calor)
```

**Pros:** Mucho menos calor (50% menos)
**Contras:** Tiempo de carga duplicado (5-6 horas)

**⚠️ Requiere soldar SMD** - no recomendado para principiantes

### Solución 4: Cargar a Temperatura Ambiente Baja

- Cargar en habitación fresca (no bajo el sol)
- Usar ventilador pequeño USB apuntando al módulo
- No cargar dentro de caja cerrada

---

## 📋 Tabla de Referencia Rápida

### Voltajes Normales del Sistema

| Punto de Medición | Voltaje Normal | Tolerancia |
|-------------------|----------------|------------|
| Batería (vacía) | 3.0-3.5V | ±0.1V |
| Batería (media) | 3.7-3.9V | ±0.1V |
| Batería (llena) | 4.15-4.20V | ±0.05V |
| USB (IN+) | 5.0V | 4.8-5.3V |
| ESP32 VIN | = Batería | ±0.1V |
| ESP32 3.3V | 3.3V | 3.2-3.4V |

### Temperaturas del TP4056

| Fase de Carga | Temp Normal | Temp Máxima |
|---------------|-------------|-------------|
| Inicio (batería baja) | 60-80°C | 90°C |
| Medio (batería 70%) | 50-60°C | 70°C |
| Final (batería >90%) | 40-50°C | 60°C |
| Carga completa | 30-40°C | 50°C |

---

## 🚨 Señales de Peligro - Detener Inmediatamente

### Detener y desconectar si:

1. **Temperatura > 100°C**
   - Humo
   - Olor a quemado
   - Decoloración del PCB

2. **Voltaje anormal**
   - Batería >4.3V (sobrecarga)
   - Batería <2.5V (descarga profunda)
   - USB >5.5V

3. **Comportamiento extraño**
   - Batería se hincha
   - LED parpadeando (no debería)
   - Corriente >1.5A
   - Ruidos o chisporroteo

### Qué hacer en emergencia:

```
1. DESCONECTAR USB inmediatamente
2. DESCONECTAR batería del TP4056
3. Dejar enfriar 30 minutos
4. Inspeccionar visualmente:
   - Componentes quemados
   - Cables derretidos
   - PCB decolorado
5. Si hay daños, REEMPLAZAR el módulo TP4056
```

---

## 📸 Fotos de Referencia para Mediciones

### Puntos de Medición en TP4056

```
Vista superior del TP4056:

    ┌────────────────────┐
USB │ [IN+]  [LED🔴🔵]   │ BAT+
 →  │ [IN-]      [IC]    │ BAT-
    │            [R]     │
    │ [OUT+]             │ → ESP32 VIN
    │ [OUT-]             │ → ESP32 GND
    └────────────────────┘

Medir:
• IN+ a IN- = 5V (con USB conectado)
• BAT+ a BAT- = 3.0-4.2V (voltaje batería)
• OUT+ a OUT- = igual que batería
```

---

## 🎓 Consejos de Seguridad

### Al Usar el Tester

1. ✅ **Siempre empezar en el rango más alto** y bajar
2. ✅ **Voltaje:** Se mide en PARALELO (tocando ambos puntos)
3. ✅ **Corriente:** Se mide en SERIE (interrumpiendo el cable)
4. ❌ **NUNCA** medir corriente en modo voltaje
5. ❌ **NUNCA** medir voltaje en modo corriente
6. ✅ **Doble-check** del selector antes de conectar
7. ✅ Mantener manos secas
8. ✅ No medir circuitos con >50V sin experiencia

### Al Cargar Baterías Li-Ion

1. ✅ Supervisar la primera carga completa
2. ✅ Cargar en superficie no inflamable
3. ✅ No dejar desatendido >4 horas
4. ❌ NO cargar batería hinchada
5. ❌ NO cargar si temperatura >90°C
6. ✅ Usar protección TP4056 (ya la tienes)
7. ✅ Tener extintor cerca (serio)

---

## 📝 Registro de Mediciones

### Template para tus pruebas:

```
Fecha: _______________
Hora: ________________

ANTES DE CARGAR:
[ ] Voltaje batería: ______V
[ ] Voltaje USB: ______V
[ ] Temperatura ambiente: ______°C

DURANTE CARGA (t=5 min):
[ ] Corriente carga: ______mA
[ ] Temperatura TP4056: ______ (tibio/caliente/muy caliente)
[ ] Voltaje batería: ______V

DURANTE CARGA (t=30 min):
[ ] Temperatura TP4056: ______
[ ] Voltaje batería: ______V

CARGA COMPLETA (LED azul):
[ ] Tiempo total: ______horas
[ ] Voltaje batería final: ______V
[ ] Temperatura final: ______

NOTAS:
_________________________________
_________________________________
```

---

## 🔗 Referencias

- [Datasheet TP4056](https://www.alldatasheet.com/datasheet-pdf/pdf/201624/ETC1/TP4056.html)
- [Cómo usar un multímetro](https://learn.sparkfun.com/tutorials/how-to-use-a-multimeter)
- [Seguridad con baterías Li-Ion](https://batteryuniversity.com/article/bu-304a-safety-concerns-with-li-ion)

---

**Última actualización:** 2 de enero de 2026
**Versión:** 1.0
**Estado:** Guía completa - Smart Node V2



