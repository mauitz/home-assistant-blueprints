# 🔍 Diagnóstico SmartNode1 - Análisis de Problemas

**Fecha:** 2 Enero 2026
**Dispositivo:** smartnode1
**Estado TP4056:** Luz roja (cargando)
**Estado ESP32:** Luz roja (encendido)
**Voltaje VCC ESP32:** 4.09V ✅

---

## 📊 Problemas Detectados

### ❌ **1. Estado de Batería - NO VISIBLE**

**Síntoma:** No hay sensor de estado de batería en Home Assistant

**Causa:** El sensor de voltaje de batería NO estaba configurado

**Solución Aplicada:**
- ✅ Agregado sensor ADC en GPIO35 para "Battery Voltage"
- ✅ Agregado sensor template "Battery Level" (% calculado)

**⚠️ IMPORTANTE - Divisor de Voltaje:**

El ESP32 solo puede leer hasta **3.3V máximo** en sus pines ADC, pero tu batería entrega **3.0-4.2V**.

Necesitas un **divisor de voltaje resistivo**:

```
Batería+ (4.2V) ────┬──[R1: 10kΩ]──┬──[R2: 10kΩ]──┬── GND
                    │               │               │
                               GPIO35 (lee 2.1V max)
```

Con este divisor (1:1), cuando la batería está a 4.2V, GPIO35 lee 2.1V.

**Si NO tienes divisor de voltaje:**
- Conecta GPIO35 **directamente** a BAT+ del TP4056
- La lectura será incorrecta cuando batería > 3.3V
- O usa GPIO34/35/36/39 con resistencias 10kΩ (R1) y 10kΩ (R2)

---

### ❌ **2. Micrófono INMP441 - NO REPORTA DATOS**

**Síntoma:** No aparece el sensor "Sound Level" o muestra 0.0 dB

**Causa:** El micrófono está declarado pero **no se procesa** el audio

**Explicación Técnica:**

ESPHome declara el micrófono I2S así:

```yaml
microphone:
  - platform: i2s_audio
    id: smartnode_mic
    adc_type: external
    i2s_din_pin: GPIO33
    pdm: false
```

Pero esto **NO genera automáticamente** un sensor de nivel de sonido. El micrófono solo está disponible para:
- 🎤 **Voice Assistant** (asistente de voz)
- 📞 **VoIP** (llamadas)
- ⚠️ **NO para sensor de dB continuo**

**Solución Temporal:**
He dejado el sensor "Sound Level" como placeholder (devuelve 0.0).

**Solución Avanzada (requiere programación):**
Necesitas implementar un componente custom que:
1. Lea el buffer de audio del INMP441
2. Calcule el RMS (Root Mean Square)
3. Convierta a dB

**Alternativa Simple:**
Si solo quieres detección de ruido (no nivel exacto), usar un sensor de sonido analógico KY-037 o similar en un pin ADC.

**Verificación de Conexión INMP441:**

| Pin INMP441 | → | Pin ESP32 | Voltaje Actual | ✅/❌ |
|-------------|---|-----------|----------------|-------|
| VDD | → | 3.3V | 3.3V | ✅ CORRECTO |
| GND | → | GND | 0V | ✅ |
| SD | → | GPIO33 | - | ⚠️ VERIFICAR |
| WS | → | GPIO25 | - | ⚠️ VERIFICAR |
| SCK | → | GPIO26 | - | ⚠️ VERIFICAR |
| L/R | → | GND | 0V | ✅ CRÍTICO |

**⚠️ L/R debe estar en GND** (canal izquierdo). Si está flotante o en VDD, el micrófono no funciona.

---

### ❌ **3. DHT11 - Temperatura y Humedad "Desconocido"**

**Síntoma:** Sensores muestran "Desconocido" en Home Assistant

**Causas Posibles:**

#### A. Modelo no especificado (CORREGIDO)
```yaml
# ANTES (sin modelo)
- platform: dht
  pin: 4
  temperature: ...

# AHORA (con modelo)
- platform: dht
  pin: 4
  model: DHT11  # ← Especificado
  temperature: ...
```

#### B. Conexión física incorrecta

**Verificar con multímetro:**

| Pin DHT11 | → | Pin ESP32 | Voltaje Esperado | Medición Real |
|-----------|---|-----------|------------------|---------------|
| VCC (pin 1) | → | 3.3V | 3.3V | ? |
| DATA (pin 2) | → | GPIO4 | 3.3V (idle) | ? |
| NC (pin 3) | - | - | - | - |
| GND (pin 4) | → | GND | 0V | ? |

**Pasos de Diagnóstico:**

1. **Medir voltaje en VCC del DHT11:**
   ```bash
   Multímetro: VCC del DHT11 → GND
   Debe leer: 3.3V
   Si lee 0V → problema de alimentación
   Si lee 5V → ¡CUIDADO! DHT11 se puede dañar
   ```

2. **Verificar continuidad DATA:**
   ```bash
   Multímetro en modo continuidad:
   Pin DATA del DHT11 ↔ GPIO4 del ESP32
   Debe sonar "beep"
   ```

3. **Probar en otro pin:**
   Si GPIO4 no funciona, prueba GPIO2:
   ```yaml
   - platform: dht
     pin: 2  # Probar GPIO2
     model: DHT11
   ```

4. **Verificar sensor con otro ESP32/Arduino:**
   Prueba el DHT11 en otro dispositivo para descartar que esté defectuoso.

#### C. Sensor DHT11 dañado

Los DHT11 son **sensibles** a:
- ❌ Voltaje >3.6V (si conectaste a 5V aunque sea 1 segundo)
- ❌ Humedad extrema (condensación directa)
- ❌ Calor >60°C
- ❌ Soldadura directa en pines (si aplicaste calor >5 segundos)

**Síntomas de DHT11 dañado:**
- Siempre devuelve "Desconocido"
- Devuelve valores fijos (ej: siempre 0°C, 0%)
- Devuelve valores absurdos (ej: 180°C, 300%)

**Solución:** Reemplazar por nuevo DHT11 o mejor aún, usar **DHT22** (más preciso y robusto).

---

### ❌ **4. LDR - Lectura Invertida (7% con mucha luz)**

**Síntoma:** Con ventanas abiertas y luz de día, muestra 7% en vez de ~80-100%

**Causa:** Fórmula de conversión y/o circuito LDR incorrecto

**Tu Circuito Actual (según esquema):**

```
5V ──┬──[LDR]──┬──[R: 10kΩ]──┬── GND
     │         │              │
               └──→ GPIO32 (ADC)
```

**Análisis del Comportamiento:**

| Condición | LDR Resistencia | Voltaje en GPIO32 | ADC Raw | Antes (%) | Ahora (%) |
|-----------|-----------------|-------------------|---------|-----------|-----------|
| Luz alta | ~1 kΩ | ~4.5V (alto) | 0.9-1.0 | 2-10% ❌ | 90-100% ✅ |
| Oscuridad | ~100 kΩ | ~0.5V (bajo) | 0.0-0.1 | 90-100% ❌ | 0-10% ✅ |

**Problema Anterior:**
```yaml
filters:
  - lambda: 'return round(100.0 - (x * 0.024414062));'
  # Esto INVERTÍA el valor: mucha luz → bajo %
```

**Solución Aplicada:**
```yaml
filters:
  - calibrate_linear:
      - 0.0 -> 0.0    # 0V = oscuridad = 0%
      - 3.3 -> 100.0  # 3.3V = luz máxima = 100%
  - lambda: 'return round(x);'
```

**⚠️ VERIFICACIÓN NECESARIA:**

El problema puede ser también el **circuito físico**. Verifica:

1. **Orientación del LDR y resistencia:**
   ```
   CORRECTO:
   5V → LDR → GPIO32 + Resistencia 10kΩ → GND

   INCORRECTO (invierte lectura):
   5V → Resistencia 10kΩ → GPIO32 + LDR → GND
   ```

2. **Medir voltaje en GPIO32 con multímetro:**
   - Con mucha luz: debe leer **>2V**
   - En oscuridad: debe leer **<0.5V**

   Si está al revés, intercambia LDR y resistencia.

3. **LDR funcional:**
   - Mide resistencia del LDR con multímetro
   - Con luz: 1-5 kΩ
   - Tapado con mano: >50 kΩ
   - Si siempre lee lo mismo → LDR defectuoso

---

## 🔧 Esquema de Conexión Completo

### **Alimentación**

```
[USB Type-C] → [TP4056 IN+/IN-]
                     ↓
              [Batería 18650]
               Li-Ion 3.7V
               2600 mAh
                     ↓
         [TP4056 OUT+] → ESP32 VIN (4.09V ✅)
         [TP4056 OUT-] → ESP32 GND
```

**Estado Actual:**
- ✅ TP4056 luz roja = Cargando batería
- ✅ ESP32 luz roja = Encendido
- ✅ Voltaje VIN = 4.09V (óptimo)

---

### **Sensores - Estado de Conexión**

| Sensor | Pines ESP32 | Alimentación | Estado | Problema |
|--------|-------------|--------------|--------|----------|
| **LD2410** | GPIO16 (RX)<br>GPIO17 (TX) | 5V | ✅ Funcionando | Ninguno |
| **LDR** | GPIO32 (ADC) | 5V+10kΩ | ⚠️ Invertido | Circuito/código |
| **DHT11** | GPIO4 (DATA) | 3.3V | ❌ Desconocido | Conexión/sensor |
| **INMP441** | GPIO33 (SD)<br>GPIO25 (WS)<br>GPIO26 (SCK) | 3.3V | ⚠️ Sin datos | No implementado |
| **Batería** | GPIO35 (ADC) | Divisor voltaje | ❌ Sin sensor | Agregado ahora |

---

### **Diagrama de Pines Actual**

```
         ESP32-WROOM-32 (30 pines)
    ┌─────────────────────────────┐
    │                             │
VIN ┤ VIN (4.09V) ← TP4056 OUT+   │
GND ┤ GND ← TP4056 OUT-            │
3V3 ┤ 3.3V → DHT11 VCC            │
    │         → INMP441 VDD        │
    │                             │
  4 ┤ GPIO4 → DHT11 DATA          │ ⚠️ "Desconocido"
    │                             │
 16 ┤ GPIO16 → LD2410 RX          │ ✅ OK
 17 ┤ GPIO17 → LD2410 TX          │ ✅ OK
    │                             │
 25 ┤ GPIO25 → INMP441 WS         │ ⚠️ Verificar
 26 ┤ GPIO26 → INMP441 SCK        │ ⚠️ Verificar
    │                             │
 32 ┤ GPIO32 → LDR (ADC)          │ ⚠️ 7% (invertido)
 33 ┤ GPIO33 → INMP441 SD         │ ⚠️ Verificar
    │                             │
 35 ┤ GPIO35 → Batería ADC        │ ❌ Agregar divisor
    │                             │
    └─────────────────────────────┘
```

---

## 📋 Checklist de Verificación

### **1. Alimentación** ✅
- [x] TP4056 OUT+ → ESP32 VIN (4.09V)
- [x] TP4056 OUT- → ESP32 GND
- [x] Batería conectada a TP4056 BAT+/BAT-
- [x] LED rojo TP4056 encendido (cargando)
- [x] LED rojo ESP32 encendido

### **2. DHT11** ❌
- [ ] VCC → 3.3V (medir con multímetro)
- [ ] DATA → GPIO4 (verificar continuidad)
- [ ] GND → GND
- [ ] Modelo especificado en código: `model: DHT11`
- [ ] Probar en otro pin (GPIO2)
- [ ] Probar otro sensor DHT11/DHT22

### **3. LDR** ⚠️
- [ ] Circuito: 5V → LDR → GPIO32 + Resistencia → GND
- [ ] Medir voltaje GPIO32 con luz: >2V esperado
- [ ] Medir voltaje GPIO32 oscuro: <0.5V esperado
- [ ] Resistencia del LDR cambia con luz (1kΩ-100kΩ)
- [ ] Código actualizado con `calibrate_linear`

### **4. INMP441** ⚠️
- [ ] VDD → 3.3V (NO 5V)
- [ ] L/R → GND (canal izquierdo)
- [ ] SD → GPIO33
- [ ] WS → GPIO25
- [ ] SCK → GPIO26
- [ ] Cables <15cm de largo
- [ ] Alejado >2cm del LD2410
- [ ] Orificio del micrófono libre

### **5. Batería** ❌
- [ ] Divisor de voltaje instalado (R1:10kΩ + R2:10kΩ)
- [ ] Punto medio → GPIO35
- [ ] Verificar lectura en Home Assistant

---

## 🔨 Acciones Inmediatas

### **Prioridad 1: DHT11 (Temperatura/Humedad)**

1. **Desconecta USB del TP4056**
2. **Con multímetro en modo voltaje DC:**
   ```
   Punta roja: Pin VCC del DHT11
   Punta negra: GND
   → Debe leer 3.3V

   Si lee 0V: problema de alimentación
   Si lee 5V: ¡DETENER! DHT11 se puede quemar
   ```

3. **Con multímetro en modo continuidad:**
   ```
   Punta 1: Pin DATA del DHT11
   Punta 2: GPIO4 del ESP32
   → Debe sonar "beep"
   ```

4. **Reconecta USB y compila nuevo firmware:**
   ```bash
   cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
   esphome run smartnode1.yaml
   ```

5. **Revisa logs:**
   ```bash
   esphome logs smartnode1.yaml
   ```
   Busca errores como:
   - `[dht:xxx] Requesting data from DHT failed!`
   - `[dht:xxx] Checksum invalid`

### **Prioridad 2: LDR (Luz)**

1. **Medir voltaje en GPIO32:**
   ```
   Con luz natural (ventanas abiertas):
   Multímetro: GPIO32 → GND
   → Debe leer >2V

   Si lee <1V con luz: circuito invertido
   ```

2. **Si está invertido, intercambia LDR y resistencia:**
   ```
   ANTES:
   5V → Resistencia → GPIO32 + LDR → GND

   DESPUÉS:
   5V → LDR → GPIO32 + Resistencia → GND
   ```

3. **Recompila y sube firmware actualizado**

### **Prioridad 3: Batería (Voltaje)**

1. **Instalar divisor de voltaje:**
   ```
   Necesitas:
   - 2 resistencias de 10kΩ
   - Cable jumper

   Conexión:
   BAT+ del TP4056 → R1 (10kΩ) → GPIO35 + R2 (10kΩ) → GND
   ```

2. **Ajustar factor en código:**
   Si usas divisor 1:1 (dos resistencias iguales):
   ```yaml
   filters:
     - multiply: 2.0  # Duplica lectura (divide entre 2)
   ```

3. **Recompila firmware**

---

## 📊 Valores Esperados Después de Correcciones

| Sensor | Valor Actual | Valor Esperado | Estado |
|--------|--------------|----------------|--------|
| **Presence** | Detected | Detected | ✅ OK |
| **Moving Distance** | 30 cm | Variable | ✅ OK |
| **Room Temperature** | Desconocido | 15-30°C | ❌ Corregir |
| **Room Humidity** | Desconocido | 30-70% | ❌ Corregir |
| **Room Brightness** | 7% | 70-90% (día) | ❌ Corregir |
| **Sound Level** | 0 dB o ausente | 30-60 dB | ⚠️ No implementado |
| **Battery Voltage** | Ausente | 3.7-4.2V | ❌ Agregar divisor |
| **Battery Level** | Ausente | 70-100% | ❌ Agregar divisor |

---

## 🐛 Logs a Revisar

Después de recompilar, busca estos mensajes:

### **✅ Logs Correctos (esperados):**
```
[I][dht:xxx]: Got temperature=23.5°C humidity=55.0%
[I][adc:xxx]: 'Room Brightness': Got voltage=2.456V
[I][ld2410:xxx]: Presence detected at 45cm
[I][i2s_audio:xxx]: I2S audio initialized
```

### **❌ Logs con Error (indicadores de problema):**
```
[E][dht:xxx]: Requesting data from DHT failed!
  → DHT no conectado o pin incorrecto

[W][dht:xxx]: Invalid checksum
  → Cable DATA muy largo o con interferencia

[E][adc:xxx]: ADC out of range
  → Voltaje >3.3V en pin ADC (sin divisor)

[E][uart:xxx]: Reading from UART failed
  → LD2410 TX/RX invertidos
```

---

## 📸 Fotos Solicitadas (para diagnóstico)

Si los problemas persisten, sería útil ver:

1. **Conexión DHT11 → ESP32 GPIO4** (primer plano)
2. **Circuito LDR completo** (mostrar 5V → LDR → resistencia → GND)
3. **Conexión INMP441 completo** (especialmente pin L/R)
4. **Vista general del protoboard** (para identificar cruces)
5. **Voltímetro midiendo**:
   - VCC del DHT11
   - GPIO32 con luz
   - GPIO32 en oscuridad

---

## 📚 Referencias

- [DHT Sensor ESPHome](https://esphome.io/components/sensor/dht.html)
- [ADC Sensor ESPHome](https://esphome.io/components/sensor/adc.html)
- [I2S Audio ESPHome](https://esphome.io/components/i2s_audio.html)
- [LD2410 Component](https://esphome.io/components/sensor/ld2410.html)

---

**Próximos Pasos:**
1. ✅ Firmware actualizado → Recompilar y subir
2. ⚠️ Verificar conexiones físicas DHT11 y LDR
3. ❌ Agregar divisor de voltaje para batería
4. 📝 Reportar resultados después de cambios


