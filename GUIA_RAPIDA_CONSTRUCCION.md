# 🚀 Guía Rápida de Construcción - Módulo de Riego ESP32

## 📋 Resumen Ultra-Rápido

**Objetivo:** Construir módulo ESP32 en protoboard montado en caja stanco

**Tiempo estimado:** 4-6 horas

**Documentación completa:**
- 🏗️ [Arquitectura Física Completa](docs/hardware/ARQUITECTURA_FISICA_MODULO.md)
- 📌 [Diagrama Pinout ESP32](docs/hardware/DIAGRAMA_PINOUT_ESP32.md)

---

## 🎯 Layout de la Plancha (Vista Rápida)

```
┌────────────────────────────────────────────────────────────┐
│  PLANCHA PROTOBOARD                                        │
│                                                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐        │
│  │ ZONA 1   │  │ ZONA 2   │  │ ZONA 3           │        │
│  │ ALIMENT. │  │ ESP32    │  │ MÓDULO RELÉS 6CH │        │
│  │          │  │ (headers)│  │                  │        │
│  │ [5V IN]  │  │ USB ↓    │  │ IN1-IN6          │        │
│  │ [3.3V]   │  │          │  │ COM NO           │        │
│  └──────────┘  └──────────┘  └──────────────────┘        │
│                                                            │
│  ┌──────────────────────────────────────────────────┐     │
│  │ ZONA 4: BORNERAS (Conexiones externas)          │     │
│  │ [HC-SR04] [Hum] [LD2410C] [DHT11] [LDR] [Bombas]│     │
│  └──────────────────────────────────────────────────┘     │
│                                                            │
│  ┌──────────────────────────────────────────────────┐     │
│  │ ZONA 5: LEDs y componentes                       │     │
│  │ [LED1-5] [Resistencias 220Ω x5]                  │     │
│  └──────────────────────────────────────────────────┘     │
│                                                            │
│  RIELES:  [+5V] [+3.3V] [GND] [GND]                       │
└────────────────────────────────────────────────────────────┘
```

---

## ⚡ Conexiones Críticas

### **Alimentación:**
```
Entrada 5V ━━━→ Regulador AMS1117 ━━━→ Riel 3.3V
            ┗━━━→ Riel 5V
```

### **ESP32 (lo más importante):**
```
VIN     → Riel 5V
GND (x4)→ Riel GND
GPIO23  → Relé IN1 (Bomba Z1A) ⭐
GPIO22  → Relé IN2 (Bomba Z1B) ⭐
GPIO27  → DHT11 DATA (cable a tapa) 🌡️
GPIO34  → Sensor Humedad Suelo 💧
GPIO35  → LDR (cable a tapa) ☀️
GPIO13  → HC-SR04 TRIG
GPIO14  → HC-SR04 ECHO
GPIO16  → LD2410C RX
GPIO17  → LD2410C TX
```

### **LEDs:**
```
GPIO26 → [220Ω] → LED Verde (Tank Full)
GPIO25 → [220Ω] → LED Rojo (Tank Low)
GPIO4  → [220Ω] → LED Amarillo (Tank Med)
GPIO2  → [220Ω] → LED Azul (Pump Active)
GPIO15 → [220Ω] → LED Blanco (WiFi)
```

---

## 🔧 Orden de Construcción (5 Fases)

### **FASE 1: Preparación (30 min)**
1. ✅ Limpiar plancha (alcohol isopropílico)
2. ✅ Marcar 5 zonas con marcador
3. ✅ Crear rieles de alimentación (cable AWG18)
   - Superior: +5V
   - 2do: +3.3V
   - 3ro y 4to: GND (doble)

### **FASE 2: Alimentación (45 min)**
1. ✅ Soldar bornera 2 pines (entrada 5V)
2. ✅ Soldar regulador AMS1117-3.3V
3. ✅ Soldar condensadores (100µF entrada, 10µF salida)
4. ✅ Conectar a rieles
5. ✅ **PROBAR:** Medir 5V y 3.3V con multímetro

### **FASE 3: ESP32 y Relés (1 hora)**
1. ✅ Soldar headers hembra para ESP32 (2x19 pines)
   - Usar ESP32 como guía de alineación
   - Soldar 1 pin, verificar, soldar resto
2. ✅ Conectar VIN → Riel 5V
3. ✅ Conectar GND → Riel GND
4. ✅ Montar módulo relés (tornillos o cinta doble cara)
5. ✅ Conectar relés:
   - VCC → Riel 5V
   - GND → Riel GND
   - IN1 → GPIO23, IN2 → GPIO22

### **FASE 4: Borneras y Sensores (1 hora)**
1. ✅ Soldar borneras en ZONA 4:
   - 4 pines: HC-SR04
   - 3 pines: Humedad Suelo
   - 4 pines: LD2410C
   - 3 pines: DHT11
   - 2 pines: LDR
   - 12 pines: Bombas (6x2)
2. ✅ Conectar borneras a GPIOs correspondientes
3. ✅ Soldar LEDs con resistencias 220Ω

### **FASE 5: Sensores en Tapa (1 hora)**
1. ✅ Perforar agujeros para prensaestopas
2. ✅ Montar DHT11 en tapa interior con cable
3. ✅ Montar LDR en tapa exterior
4. ✅ Sellar con silicona
5. ✅ Conectar a borneras

---

## 🧪 Pruebas Paso a Paso

### **Prueba 1: Alimentación** ⚡
```bash
SIN ESP32 conectado
Conectar fuente 5V

Multímetro:
├─ Riel 5V → GND: debe leer 5.0V ± 0.1V ✓
└─ Riel 3.3V → GND: debe leer 3.3V ± 0.1V ✓

Regulador: NO debe calentar excesivamente
```

### **Prueba 2: ESP32** 🖥️
```bash
Insertar ESP32 en headers
Conectar fuente 5V

LED azul del ESP32 debe encender ✓
Conectar USB: debe ser visible en PC ✓
```

### **Prueba 3: Relés** 🔌
```bash
Flashear firmware
Activar relé desde HA

Escuchar "CLICK" del relé ✓
Medir continuidad COM-NO ✓
```

### **Prueba 4: LEDs** 💡
```bash
Firmware debe encender LEDs en secuencia
Verificar cada color:
├─ Verde (Tank Full)
├─ Rojo (Tank Low)
├─ Amarillo (Tank Med)
├─ Azul (Pump)
└─ Blanco (WiFi)
```

### **Prueba 5: Sensores** 📊
```bash
En Home Assistant:
├─ DHT11: ~20-25°C, ~40-60% ✓
├─ HC-SR04: distancia en cm ✓
├─ Humedad: 0-100% ✓
├─ LDR: varía con luz ✓
└─ LD2410C: detecta presencia ✓
```

---

## 📦 Lista de Compras Esencial

### **Componentes Mínimos:**
- [ ] Plancha protoboard 15x10cm
- [ ] Headers hembra 2x19 pines (o tiras)
- [ ] Regulador AMS1117-3.3V
- [ ] 2x Condensadores electrolíticos (100µF, 10µF)
- [ ] 5x LEDs (colores variados)
- [ ] 7x Resistencias 220Ω
- [ ] 2x Resistencias 10kΩ
- [ ] Borneras varias (2p, 3p, 4p, 12p)
- [ ] Cable AWG18 (rojo/negro) - 3m
- [ ] Cable AWG22/24 multicolor - 10m
- [ ] 2x Prensaestopa PG7
- [ ] 4x Separadores nylon M3 + tornillos
- [ ] Caja Stanco IP65 (20x15x10cm)

### **Herramientas:**
- [ ] Soldador 40-60W
- [ ] Estaño 60/40
- [ ] Flux
- [ ] Pinzas
- [ ] Alicate corte
- [ ] Pelacables
- [ ] Multímetro ⚠️ **ESENCIAL**
- [ ] Taladro + brocas

---

## ⚠️ ERRORES COMUNES A EVITAR

### ❌ **Error 1: Conectar 3.3V del ESP32 al regulador**
- El pin 3.3V del ESP32 es SALIDA, no entrada
- Conectar VIN a 5V, no 3.3V a regulador

### ❌ **Error 2: No usar múltiples GND**
- ESP32 tiene 4 pines GND
- Conectar AL MENOS 2 de ellos al riel GND

### ❌ **Error 3: Relés sin VCC a 5V**
- Módulos relé necesitan 5V logic
- Conectar VCC del módulo a riel 5V, no 3.3V

### ❌ **Error 4: DHT11 dentro de la caja**
- DHT11 debe estar en TAPA (aire exterior)
- Dentro de la caja: temperatura incorrecta por calor

### ❌ **Error 5: LDR sin resistencia divisora**
- LDR necesita divisor resistivo para funcionar
- 3.3V → [R 10kΩ] → GPIO35 → [LDR] → GND

### ❌ **Error 6: Cables de potencia junto a señales**
- Separar cables de bombas (5V alto) de señales GPIO
- Routing: señales por un lado, potencia por otro

---

## 🎯 Checklist Final Antes de Cerrar

- [ ] Alimentación probada (5V y 3.3V OK)
- [ ] ESP32 inserta correctamente (no forzado)
- [ ] Todos los relés hacen "click"
- [ ] LEDs funcionan (5 de 5)
- [ ] DHT11 lee temperatura (~20-25°C)
- [ ] LDR varía con luz
- [ ] HC-SR04 mide distancia
- [ ] Sensor humedad responde
- [ ] LD2410C detecta presencia
- [ ] Firmware flasheado
- [ ] NO hay cortocircuitos (multímetro modo continuidad)
- [ ] Cables bien fijados (no sueltos)
- [ ] Prensaestopas sellados
- [ ] Silicona en penetraciones
- [ ] Plancha bien montada (separadores)

---

## 🆘 Troubleshooting Rápido

| Problema | Solución |
|----------|----------|
| Regulador se calienta mucho | Cortocircuito 3.3V-GND, verificar con multímetro |
| ESP32 no enciende | Verificar VIN a 5V y GND bien conectados |
| Relés no hacen click | Verificar VCC del módulo a 5V |
| DHT11 no lee | Ver [TROUBLESHOOTING_DHT11.md](docs/automatizaciones/TROUBLESHOOTING_DHT11.md) |
| LEDs no encienden | Verificar polaridad (ánodo a GPIO, cátodo a GND) |
| Sensor humedad no varía | Verificar GPIO34 (input only), no intercambiar con otro |

---

## 📚 Documentación Detallada

Para detalles completos:

- 🏗️ **[Arquitectura Física Completa](docs/hardware/ARQUITECTURA_FISICA_MODULO.md)**
  - 40+ páginas con diagramas
  - Orden de construcción detallado
  - Lista completa de materiales
  - Pruebas exhaustivas

- 📌 **[Diagrama Pinout ESP32](docs/hardware/DIAGRAMA_PINOUT_ESP32.md)**
  - Pinout completo
  - Restricciones de pines
  - Código de prueba
  - Consumo de corriente

- 🔧 **[Troubleshooting DHT11](docs/automatizaciones/TROUBLESHOOTING_DHT11.md)**
  - Diagnóstico paso a paso
  - 5 pruebas detalladas
  - Alternativas (DHT22, BME280)

---

## 🎉 ¡A construir!

**Recuerda:**
- Ve despacio, verifica cada paso
- Usa multímetro constantemente
- Documenta con fotos (útil para debug)
- Prueba antes de cerrar la caja

**¡Éxito con tu proyecto!** 🚀

---

**Versión**: 1.0
**Fecha**: Diciembre 2024
**Autor**: @mauitz

