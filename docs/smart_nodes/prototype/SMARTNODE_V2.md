# Smart Node V2 - Documentación Completa

## 📋 Descripción

Smart Node V2 es un dispositivo multi-sensor basado en ESP32 con capacidad de detección de presencia mmWave, temperatura, humedad, luz ambiental y sonido. Incluye sistema de alimentación portátil con batería LiPo recargable vía USB Type-C.

**🔗 Diagrama Interactivo:** [Ver proyecto en Cirkit Designer](https://app.cirkitdesigner.com/project/1f130e13-60b2-4685-955e-98ec5cd9cd9a)

---

## 🔧 Componentes del Sistema

### Hardware Principal
- **ESP32 DevKit** (30 pines - WROOM-32)
- **LD2410** - Sensor mmWave de presencia (24GHz)
- **DHT11 o DHT22** - Sensor de temperatura y humedad
- **LDR + Resistencia 10kΩ** - Sensor de luz ambiental
- **INMP441** - Micrófono I2S digital
- **Módulo TP4056 con USB Type-C** - Cargador de batería LiPo
- **Batería Li-Ion 18650 3.7V 2600mAh** (California Li)

### Características
- ✅ Detección de presencia por radar mmWave
- ✅ Medición de temperatura y humedad
- ✅ Sensor de luz ambiental
- ✅ Captura de nivel de sonido
- ✅ Alimentación portátil con batería recargable
- ✅ Autonomía: 10-15 horas
- ✅ Integración con Home Assistant vía ESPHome

---

## 🔌 Diagrama de Conexiones

**Archivo local:** `diagramaV2.png`
**Diagrama interactivo:** [Ver en Cirkit Designer](https://app.cirkitdesigner.com/project/1f130e13-60b2-4685-955e-98ec5cd9cd9a)

### Resumen Visual de Conexiones

```
         [INMP441]           [TP4056 + Batería]
            ↓                        ↓
      P33,P26,P25              VIN/GND
            ↓                        ↓
     ┌────────────────────────────────┐
     │                                │
     │      ESP32-WROOM-32            │
     │         DevKit                 │
     │                                │
     └────────────────────────────────┘
        ↓      ↓      ↓      ↓
      P4     P32    P16    P17
      ↓       ↓      ↓      ↓
    [DHT]  [LDR] [LD2410]
```

---

## 📊 Tabla de Conexiones Completa

### INMP441 (Micrófono I2S Digital)

| Pin INMP441 | → | Pin ESP32 | Función | Color Cable |
|-------------|---|-----------|---------|-------------|
| VDD | → | 3.3V | Alimentación | 🔴 Rojo |
| GND | → | GND | Tierra | ⚫ Negro |
| SD | → | GPIO33 | I2S Data | 🟡 Amarillo |
| WS | → | GPIO25 | I2S Word Select | 🟢 Verde |
| SCK | → | GPIO26 | I2S Clock | 🔵 Azul |
| L/R | → | GND | Canal izquierdo | ⚫ Negro |

**⚠️ Importante:**
- Alimentar con 3.3V, **NUNCA 5V**
- Cables cortos (<15cm) para evitar ruido
- Orificio del micrófono debe quedar libre (sin obstrucciones)
- Alejar >2cm del LD2410 para evitar interferencias

---

### LD2410 (Sensor mmWave)

| Pin LD2410 | → | Pin ESP32 | Función | Color Cable |
|------------|---|-----------|---------|-------------|
| VCC | → | 5V | Alimentación | 🔴 Rojo |
| GND | → | GND | Tierra | ⚫ Negro |
| TX | → | GPIO16 (RX) | UART TX | 🟠 Naranja |
| RX | → | GPIO17 (TX) | UART RX | 🔵 Azul |
| OUT | - | No conectar | Salida digital (opcional) | - |

**Configuración UART:**
- Baud rate: 256000
- Parity: NONE
- Stop bits: 1

---

### DHT11/DHT22 (Sensor Temperatura/Humedad)

| Pin DHT | → | Pin ESP32 | Función | Color Cable |
|---------|---|-----------|---------|-------------|
| VCC | → | 3.3V | Alimentación | 🔴 Rojo |
| DATA | → | GPIO4 | Señal de datos | 🟢 Verde |
| GND | → | GND | Tierra | ⚫ Negro |

**⚠️ Nota importante:**
- **GPIO4** es el pin correcto (NO usar GPIO5)
- GPIO5 es strapping pin y puede causar problemas en el boot

**Actualización de intervalos:**
- Temperatura: cada 60 segundos
- Humedad: cada 60 segundos

---

### LDR (Sensor de Luz Ambiental)

Circuito divisor de voltaje:

```
5V ──┬──[LDR]──┬──[Resistencia 10kΩ]──┬── GND
     │         │                      │
               └────→ GPIO32 (ADC)
```

| Componente | Conexión 1 | Conexión 2 |
|------------|-----------|------------|
| LDR | 5V | Unión con resistencia |
| Resistencia 10kΩ | Unión con LDR | GND |
| GPIO32 | Punto medio (unión LDR + resistencia) | - |

**Configuración ADC:**
- Pin: GPIO32 (ADC1_CH4)
- Muestras: 3
- Intervalo: 5 segundos
- Filtro: Conversión a porcentaje (0-100%)

---

### TP4056 (Módulo de Carga + Alimentación)

```
Diagrama de Flujo de Alimentación:

[USB Type-C] → [TP4056] → [Batería 18650 Li-Ion 3.7V 2600mAh]
                   ↓
            [Salida regulada]
                   ↓
            [ESP32 VIN/GND]
```

| Terminal TP4056 | → | Conexión | Función |
|----------------|---|----------|---------|
| IN+ | ← | USB Type-C (+5V) | Entrada de carga |
| IN- | ← | USB Type-C (GND) | Tierra de carga |
| BAT+ | ↔ | Batería rojo (+) | Positivo batería |
| BAT- | ↔ | Batería negro (-) | Negativo batería |
| OUT+ | → | ESP32 VIN | Voltaje batería (3.0-4.2V) |
| OUT- | → | ESP32 GND | Tierra común |

**⚠️ IMPORTANTE - Voltaje de Salida:**
- El TP4056 **NO regula** el voltaje de salida
- OUT+ = Voltaje de la batería (3.0-4.2V directamente)
- El ESP32 necesita batería **>3.7V** (idealmente >4.0V) para funcionar
- Con batería <3.5V, el ESP32 puede no encender o funcionar inestablemente

**Características:**
- Corriente de carga: 1A
- Voltaje de carga: 4.2V (estándar LiPo)
- Protección: Sobrecarga, descarga profunda, cortocircuito
- LEDs indicadores en módulo:
  - 🔴 Rojo: Cargando
  - 🔵 Azul: Carga completa

---

### Batería Li-Ion 18650

**Especificaciones:**
- Marca: California Li
- Modelo: 18650 Lithium-ion Cell
- Voltaje nominal: 3.7V
- Voltaje máximo (cargada): 4.2V
- Voltaje mínimo (descargada): 3.0V
- Capacidad: 2600 mAh
- Tipo: Litio-ion (Li-Ion)
- Formato: 18650 (18mm diámetro × 65mm largo)

**Estimación de autonomía (2600mAh):**
| Modo | Consumo | Autonomía |
|------|---------|-----------|
| WiFi activo + todos los sensores | 150-200 mA | 13-17 horas |
| WiFi intermitente | 80-120 mA | 21-32 horas |
| Deep sleep (fuera de alcance) | 10-20 mA | 130-260 horas |

---

## 📍 Resumen de Pines GPIO Utilizados

| GPIO | Dispositivo | Función | Tipo | Seguridad |
|------|-------------|---------|------|-----------|
| **GPIO4** | DHT Sensor | Data | Digital | ✅ Seguro |
| **GPIO16** | LD2410 | RX UART | Digital | ✅ Seguro |
| **GPIO17** | LD2410 | TX UART | Digital | ✅ Seguro |
| **GPIO25** | INMP441 | WS (I2S) | Digital | ✅ Seguro |
| **GPIO26** | INMP441 | SCK (I2S) | Digital | ✅ Seguro |
| **GPIO32** | LDR | ADC | Analógico | ✅ Seguro |
| **GPIO33** | INMP441 | SD (I2S) | Digital | ✅ Seguro |

### Pines Disponibles para Expansión

**GPIO seguros disponibles:**
- GPIO13, GPIO14, GPIO18, GPIO19, GPIO21, GPIO22, GPIO23, GPIO27

**ADC disponibles (solo input):**
- GPIO34, GPIO35, GPIO36 (SVP), GPIO39 (SVN)

### 🚫 Pines a EVITAR

Según [referencia ESP32-WROOM-32](https://lastminuteengineers.com/esp32-wroom-32-pinout-reference/):

| Pines | Razón |
|-------|-------|
| GPIO0, GPIO2, GPIO5, GPIO12, GPIO15 | Strapping pins (afectan boot) |
| GPIO1, GPIO3 | UART0 (programación/debug) |
| GPIO6-11 | Conectados a Flash memory |

---

## 💻 Configuración ESPHome

### Archivo: `device.yaml`

```yaml
esphome:
  name: smartnode1
  friendly_name: Smart Node 1

esp32:
  board: esp32dev
  framework:
    type: esp-idf

logger:

api:
  encryption:
    key: "uiBug7J/YQ2WEQwAinei45aUGm7L9cf6Sp82nI4GuIU="

ota:
  - platform: esphome
    password: "fc6b855770911eb3179ff203b83f5ec8"

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  ap:
    ssid: "Test1 Fallback Hotspot"
    password: "EFM0SoydaFKO"

captive_portal:

# I2S Audio para INMP441
i2s_audio:
  - id: mic_i2s
    i2s_lrclk_pin: GPIO25
    i2s_bclk_pin: GPIO26

microphone:
  - platform: i2s_audio
    id: smartnode_mic
    adc_type: external
    i2s_din_pin: GPIO33
    pdm: false

# UART para LD2410
uart:
  tx_pin: 17
  rx_pin: 16
  baud_rate: 256000
  parity: NONE
  stop_bits: 1

ld2410:

# Sensores
sensor:
  # LDR - Sensor de Luz
  - platform: adc
    pin: 32
    name: "Room Brightness"
    update_interval: 5s
    accuracy_decimals: 0
    unit_of_measurement: "%"
    raw: true
    samples: 3
    filters:
      - lambda: 'return round(100.0 - (x * 0.024414062));'

  # DHT - Temperatura y Humedad
  - platform: dht
    pin: 4
    temperature:
      name: "Room Temperature"
    humidity:
      name: "Room Humidity"
    update_interval: 60s

  # Sensor de nivel de sonido (template para INMP441)
  - platform: template
    name: "Sound Level"
    id: sound_level
    unit_of_measurement: "dB"
    accuracy_decimals: 1
    update_interval: 1s
    icon: "mdi:microphone"

  # LD2410 - Sensores avanzados
  - platform: ld2410
    moving_distance:
      name: Moving Distance
    still_distance:
      name: Still Distance
    moving_energy:
      name: Move Energy
    still_energy:
      name: Still Energy
    detection_distance:
      name: Detection Distance
    g0:
      move_energy:
        name: g0 move energy
      still_energy:
        name: g0 still energy
    g1:
      move_energy:
        name: g1 move energy
      still_energy:
        name: g1 still energy
    g2:
      move_energy:
        name: g2 move energy
      still_energy:
        name: g2 still energy
    g3:
      move_energy:
        name: g3 move energy
      still_energy:
        name: g3 still energy
    g4:
      move_energy:
        name: g4 move energy
      still_energy:
        name: g4 still energy
    g5:
      move_energy:
        name: g5 move energy
      still_energy:
        name: g5 still energy
    g6:
      move_energy:
        name: g6 move energy
      still_energy:
        name: g6 still energy
    g7:
      move_energy:
        name: g7 move energy
      still_energy:
        name: g7 still energy
    g8:
      move_energy:
        name: g8 move energy
      still_energy:
        name: g8 still energy

# Sensores binarios LD2410
binary_sensor:
  - platform: ld2410
    has_target:
      name: Presence
    has_moving_target:
      name: Moving Target
    has_still_target:
      name: Still Target
```

---

## 🔧 Guía de Construcción

### Materiales Necesarios

**Herramientas:**
- Soldador 30-40W
- Estaño 60/40 o 63/37
- Flux (recomendado)
- Multímetro
- Alcohol isopropílico
- Pinzas de precisión

**Cables:**
- Cables dupont o AWG 24-26
- Colores: rojo, negro, amarillo, verde, azul, naranja, violeta
- Longitud: 10-20 cm

**Componentes adicionales:**
- Protoboard o PCB perforada
- Estaño
- Resistencia 10kΩ (para LDR)
- Cinta aislante o termoretráctil

---

### Orden de Montaje Recomendado

#### 1. Preparación y Prueba de Alimentación

```bash
1. Conectar batería al TP4056 (BAT+, BAT-)
2. Conectar TP4056 OUT+ → ESP32 VIN
3. Conectar TP4056 OUT- → ESP32 GND
4. Verificar que ESP32 enciende (LED interno)
5. Cargar batería vía USB (verificar LED carga del TP4056)
```

**✅ Verificación:**
- ESP32 debe encender
- TP4056 debe mostrar LED de carga al conectar USB
- Voltaje en VIN debe ser ~3.7-4.2V con batería

---

#### 2. Sensores Básicos (LD2410, DHT, LDR)

**A. LD2410:**
```
1. VCC → 5V (o VIN)
2. GND → GND
3. TX → GPIO16
4. RX → GPIO17
5. Verificar con multímetro continuidad
```

**B. DHT Sensor:**
```
1. VCC → 3.3V
2. DATA → GPIO4 (⚠️ NO GPIO5)
3. GND → GND
```

**C. LDR:**
```
1. LDR extremo 1 → 5V
2. LDR extremo 2 → GPIO32 + Resistencia 10kΩ
3. Resistencia 10kΩ otro extremo → GND
```

**✅ Verificación:**
- Compilar y flashear código básico
- Verificar en Home Assistant que aparecen sensores
- Probar cada sensor individualmente

---

#### 3. INMP441 (Micrófono I2S)

```
Orden de soldadura:
1. Primero: GND y VDD (alimentación)
2. Segundo: L/R → GND
3. Tercero: WS → GPIO25
4. Cuarto: SCK → GPIO26
5. Quinto: SD → GPIO33
```

**⚠️ Precauciones:**
- No calentar más de 3 segundos por pin
- Usar cables cortos (<15cm)
- Verificar polaridad de VDD (3.3V)
- No obstruir orificio del micrófono

**✅ Verificación:**
- Compilar código con I2S habilitado
- Buscar en logs: `[I][i2s_audio:073]: I2S audio initialized`
- Verificar sensor "Sound Level" en HA

---

#### 4. Integración Final

```
1. Montar todos los componentes en carcasa/protoboard
2. Asegurar cables con bridas o cinta
3. Verificar que no hay cortocircuitos (multímetro)
4. Flashear código completo
5. Verificar todos los sensores en Home Assistant
6. Probar autonomía con batería (desconectar USB)
```

---

## 🧪 Pruebas y Verificación

### Checklist de Verificación Post-Montaje

**Alimentación:**
- [ ] ESP32 enciende con batería solamente
- [ ] TP4056 carga batería al conectar USB
- [ ] Voltaje en VIN entre 3.5-4.2V
- [ ] No hay calentamiento excesivo

**Conectividad:**
- [ ] ESP32 se conecta a WiFi
- [ ] Aparece en Home Assistant
- [ ] API responde correctamente

**Sensores:**
- [ ] LD2410 detecta presencia
- [ ] DHT reporta temperatura y humedad
- [ ] LDR detecta cambios de luz
- [ ] INMP441 captura nivel de sonido

**Autonomía:**
- [ ] Funciona >13 horas con batería 2600mAh
- [ ] Recarga completa en ~2.5-3 horas (corriente 1A)

---

## 🐛 Troubleshooting

### Problema: ESP32 no enciende

**Causas posibles:**
- Batería descargada completamente
- TP4056 mal conectado
- Cortocircuito en alimentación

**Soluciones:**
1. Conectar USB al TP4056, esperar 10 minutos
2. Verificar voltaje en BAT+ con multímetro (debe ser >3.0V)
3. Verificar continuidad OUT+ → VIN
4. Revisar que no haya puentes de soldadura

---

### Problema: LD2410 no detecta

**Causas posibles:**
- TX/RX invertidos
- Baud rate incorrecto
- Alimentación insuficiente

**Soluciones:**
1. Verificar TX del sensor → GPIO16 (RX del ESP32)
2. Confirmar baud_rate: 256000 en código
3. Medir voltaje en VCC del LD2410 (debe ser 5V)
4. Revisar logs: debe aparecer `[ld2410:xxx]`

---

### Problema: DHT no reporta datos

**Causas posibles:**
- Pin incorrecto (GPIO5 en vez de GPIO4)
- Sensor defectuoso
- Timing incorrecto

**Soluciones:**
1. **Confirmar que está en GPIO4** (NO GPIO5)
2. Cambiar `update_interval` a 60s
3. Probar con otro sensor DHT
4. Verificar 3.3V en VCC del DHT

---

### Problema: INMP441 sin audio o ruido

**Causas posibles:**
- Cables muy largos (>15cm)
- Interferencia con LD2410
- Pin L/R no conectado a GND
- Alimentación incorrecta (5V en vez de 3.3V)

**Soluciones:**
1. Acortar cables de conexión I2S
2. Alejar INMP441 del LD2410 (>2cm)
3. **Verificar L/R → GND**
4. Confirmar VDD en 3.3V (NO 5V)
5. Agregar condensador 100nF entre VDD y GND

---

### Problema: Batería dura poco

**Causas posibles:**
- Batería de baja capacidad
- WiFi siempre activo
- Demasiados update_interval frecuentes

**Soluciones:**
1. Usar batería ≥2600mAh (como la 18650 California Li)
2. Configurar sleep mode cuando no hay presencia
3. Aumentar intervalos de sensores:
   - DHT: 60s → 120s
   - LDR: 5s → 10s
4. Reducir potencia WiFi: `output_power: 8.5dB`

---

## 📈 Optimizaciones Avanzadas

### Reducción de Consumo

```yaml
# Agregar en wifi:
wifi:
  # ... configuración existente ...
  power_save_mode: light
  output_power: 10dB
  fast_connect: true

# Agregar deep sleep cuando no hay presencia
deep_sleep:
  id: deep_sleep_control
  run_duration: 30s
  sleep_duration: 5min

# Script para activar sleep si no hay presencia por 30min
script:
  - id: check_presence
    then:
      - if:
          condition:
            binary_sensor.is_off: presence
          then:
            - delay: 30min
            - deep_sleep.enter: deep_sleep_control
```

---

### Calibración de Sensores

**LD2410:**
```yaml
# Ajustar sensibilidad por distancia
ld2410:
  timeout: 5s
  max_move_distance: 4.5m
  max_still_distance: 4.5m
  g0:
    move_threshold: 50
    still_threshold: 40
  # ... ajustar g1-g8 según necesidad
```

**LDR:**
```yaml
# Calibrar según luminosidad de tu entorno
filters:
  - calibrate_linear:
      - 0.0 -> 0.0   # Oscuridad total
      - 1.0 -> 100.0 # Luz máxima
  - lambda: 'return round(x);'
```

---

## 📚 Referencias

### Diagrama del Proyecto
- [Diagrama Interactivo en Cirkit Designer](https://app.cirkitdesigner.com/project/1f130e13-60b2-4685-955e-98ec5cd9cd9a)
- Archivo local: `diagramaV2.png`

### Documentación Oficial
- [ESP32-WROOM-32 Pinout](https://lastminuteengineers.com/esp32-wroom-32-pinout-reference/)
- [ESPHome Documentation](https://esphome.io/)
- [LD2410 Component](https://esphome.io/components/sensor/ld2410.html)
- [DHT Sensor](https://esphome.io/components/sensor/dht.html)
- [I2S Audio](https://esphome.io/components/i2s_audio.html)

### Datasheets
- [INMP441 Datasheet](https://invensense.tdk.com/products/digital/inmp441/)
- [TP4056 Datasheet](https://www.alldatasheet.com/datasheet-pdf/pdf/201624/ETC1/TP4056.html)
- [ESP32 Technical Reference](https://www.espressif.com/sites/default/files/documentation/esp32_technical_reference_manual_en.pdf)

---

## 📝 Historial de Versiones

### Versión 2.0 (Actual)
- ✅ Agregado INMP441 (micrófono I2S)
- ✅ Sistema de alimentación portátil (TP4056 + LiPo)
- ✅ DHT movido de GPIO5 → GPIO4 (fix strapping pin)
- ✅ Optimización de pines según referencia oficial
- ❌ Removidos LEDs externos (no necesarios)

### Versión 1.0 (Inicial)
- Sensores básicos: LD2410, DHT, LDR
- Alimentación USB directa
- GPIO5 para DHT (problemático)

---

## 🎯 Próximas Mejoras (V3)

Posibles adiciones futuras:
- [ ] Sensor BME280 (presión atmosférica)
- [ ] Pantalla OLED para feedback local
- [ ] Botón físico de reset/configuración
- [ ] Sensor de CO2 (MH-Z19 o SCD30)
- [ ] Case impreso en 3D
- [ ] Montaje en pared con magnetos

---

## 📞 Soporte

Para problemas o consultas:
- Revisar sección de Troubleshooting
- Verificar logs de ESPHome: `esphome logs device.yaml`
- Consultar documentación oficial de ESPHome
- Verificar conexiones con multímetro

---

**Última actualización:** Diciembre 2025
**Versión documento:** 2.0
**Estado:** Producción
**Diagrama:** [Ver en Cirkit Designer](https://app.cirkitdesigner.com/project/1f130e13-60b2-4685-955e-98ec5cd9cd9a) | Archivo local: `diagramaV2.png`

