# Smart Node V3 - Nodo Inteligente Multisensor

## 📋 Descripción

Dispositivo multisensor basado en ESP32 con capacidad de detección de presencia mmWave, temperatura, humedad, luz ambiental y sistema de alimentación portátil con batería recargable.

**Estado:** ✅ **100% FUNCIONAL - Producción**  
**Última actualización:** 4 Enero 2026  
**Versión:** 3.0

---

## 🎯 Sensores Integrados

| Sensor | Función | Estado |
|--------|---------|--------|
| ✅ **LD2410** | Detección de presencia mmWave 24GHz | Funcionando |
| ✅ **DHT11** | Temperatura y humedad ambiente | Funcionando |
| ✅ **LDR** | Sensor de luz ambiental (0-100%) | Funcionando |
| ✅ **Batería** | Monitoreo de voltaje y nivel | Funcionando |
| ⏸️ **INMP441** | Micrófono I2S (placeholder) | Configurado |

---

## 🔌 Conexiones Verificadas

### **Alimentación**

```
[USB Type-C] → [TP4056] → [Batería 18650 Li-Ion 3.7V]
                   ↓
            [ESP32 VIN/GND]
```

| Pin ESP32 | Conexión | Voltaje |
|-----------|----------|---------|
| **VIN** | TP4056 OUT+ | 3.0-4.2V |
| **GND** | TP4056 OUT- | 0V |

---

### **LD2410 - Sensor de Presencia**

| Pin ESP32 | Pin LD2410 | Función |
|-----------|------------|---------|
| **5V** | VCC | Alimentación |
| **GND** | GND | Tierra |
| **GPIO16** | TX | UART RX |
| **GPIO17** | RX | UART TX |

**Configuración UART:** 256000 baud, NONE, 1 stop bit

---

### **DHT11 - Temperatura/Humedad**

| Pin ESP32 | Pin DHT11 | Función |
|-----------|-----------|---------|
| **3V3** | VCC (pin 1) | Alimentación 3.3V |
| **GPIO4** | DATA (pin 2) | Señal datos |
| **GND** | GND (pin 4) | Tierra |

**Valores típicos:** 15-30°C, 30-70% humedad

---

### **LDR - Sensor de Luz**

```
5V ──[LDR]──┬──[R: 10kΩ]──GND
            │
         GPIO32
```

| Componente | Conexiones |
|------------|------------|
| **LDR** | 5V → Punto medio |
| **Resistencia 10kΩ** | Punto medio → GND |
| **GPIO32** | Punto medio (ADC) |

**Valores típicos:** 0% (oscuridad) a 100% (luz directa)

---

### **INMP441 - Micrófono I2S**

| Pin ESP32 | Pin INMP441 | Función |
|-----------|-------------|---------|
| **3V3** | VDD | Alimentación 3.3V |
| **GND** | GND | Tierra |
| **GPIO33** | SD | I2S Serial Data |
| **GPIO25** | WS | I2S Word Select |
| **GPIO26** | SCK | I2S Clock |
| **GND** | L/R | Canal izquierdo |

⚠️ **Importante:** L/R debe estar en GND (no flotante)

---

### **Sensor de Batería - Divisor de Voltaje**

```
TP4056 OUT+ (3.0-4.2V)
      ↓
  [R1: 10kΩ]
      ↓
   Punto Medio (1.5-2.1V) → GPIO35
      ↓
  [R2: 10kΩ]
      ↓
     GND
```

| Componente | Conexiones |
|------------|------------|
| **R1 (10kΩ)** | OUT+ → Punto medio |
| **R2 (10kΩ)** | Punto medio → GND |
| **GPIO35** | Punto medio (ADC) |

**Cálculo:** Voltaje real = Lectura GPIO35 × 2

---

## 📊 Pines GPIO Utilizados

| GPIO | Dispositivo | Tipo | Función |
|------|-------------|------|---------|
| **GPIO4** | DHT11 | Digital | DATA |
| **GPIO16** | LD2410 | UART RX | Recibe datos |
| **GPIO17** | LD2410 | UART TX | Envía comandos |
| **GPIO25** | INMP441 | I2S | Word Select |
| **GPIO26** | INMP441 | I2S | Clock |
| **GPIO32** | LDR | ADC1 | Lectura luz |
| **GPIO33** | INMP441 | I2S | Serial Data |
| **GPIO35** | Batería | ADC1 | Voltaje batería |

### **Pines Disponibles para Expansión:**
GPIO2, 5, 13, 14, 15, 18, 19, 21, 22, 23, 34, 36, 39

---

## ⚙️ Configuración ESPHome

**Archivo:** `smartnode1.yaml`

### **Intervalos de Actualización:**

| Sensor | Intervalo | Frecuencia |
|--------|-----------|------------|
| Room Brightness (LDR) | 5 segundos | 12/minuto |
| Room Temperature (DHT11) | 60 segundos | 1/minuto |
| Room Humidity (DHT11) | 60 segundos | 1/minuto |
| Battery Voltage | 30 segundos | 2/minuto |
| Presence (LD2410) | ~1 segundo | Tiempo real |

### **Autonomía de Batería (2600mAh):**

| Modo | Autonomía Estimada |
|------|-------------------|
| WiFi activo + todos los sensores | 13-17 horas |
| WiFi con power save | 20-25 horas |

---

## 📱 Home Assistant - Entidades

Después de conectar, verás estas entidades:

### **Sensores de Ambiente:**
- `sensor.smartnode1_room_temperature` (°C)
- `sensor.smartnode1_room_humidity` (%)
- `sensor.smartnode1_room_brightness` (%)

### **Sensores de Presencia:**
- `binary_sensor.smartnode1_presence` (on/off)
- `binary_sensor.smartnode1_moving_target` (on/off)
- `binary_sensor.smartnode1_still_target` (on/off)
- `sensor.smartnode1_moving_distance` (cm)
- `sensor.smartnode1_still_distance` (cm)
- `sensor.smartnode1_detection_distance` (cm)

### **Sensores de Sistema:**
- `sensor.smartnode1_battery_voltage` (V)
- `sensor.smartnode1_battery_level` (%)

---

## 🔧 Instalación Rápida

### **1. Preparar Hardware**

```bash
# Conectar componentes según tabla de conexiones
# Verificar polaridad de batería
# Soldar divisor de voltaje (2x 10kΩ)
```

### **2. Compilar y Subir Firmware**

```bash
cd /ruta/al/proyecto/esphome
esphome run smartnode1.yaml
```

### **3. Agregar a Home Assistant**

1. Ve a **Configuración** → **Dispositivos y Servicios**
2. Espera a que aparezca "smartnode1" en descubiertos
3. Haz clic en **Configurar**
4. Ingresa la clave de encriptación (si se solicita)

---

## 📊 Valores Típicos de Sensores

| Sensor | Rango Normal | Alertas |
|--------|--------------|---------|
| **Temperatura** | 18-28°C | <15°C o >30°C |
| **Humedad** | 30-70% | <20% o >80% |
| **Luminosidad** | 0-100% | - |
| **Batería** | 3.5-4.2V | <3.3V crítico |
| **Presencia** | 0-6m | Configurable |

---

## 🐛 Troubleshooting

### **DHT11 no reporta datos**
- ✅ Verificar VCC = 3.3V (NO 5V)
- ✅ Verificar continuidad GPIO4 ↔ DHT11 DATA
- ✅ Reemplazar sensor si está dañado

### **LDR lee valores invertidos**
- ✅ Verificar circuito: 5V → LDR → GPIO32 + R → GND
- ✅ No al revés: 5V → R → GPIO32 + LDR → GND

### **Batería lee 0.15V o valores bajos**
- ✅ Verificar conexión GPIO35 al punto medio del divisor
- ✅ No conectar GPIO27 (es ADC2, incompatible con WiFi)
- ✅ Usar GPIO35 (ADC1)

### **Batería lee >5V**
- ✅ Normal si está conectado a USB (lee 5V USB)
- ✅ Desconectar USB para ver voltaje real de batería

---

## 📚 Archivos del Proyecto

```
docs/smart_nodes/prototype/
├── README.md                    ← Este archivo
├── SMARTNODE_V2.md             ← Documentación técnica detallada
├── GUIA_USO_TESTER.md          ← Guía uso multímetro
├── DIAGNOSTICO_SMARTNODE1.md   ← Diagnóstico completo
├── diagramaV3.svg              ← Diagrama circuito (visual)
├── device.yaml                 ← Configuración ESPHome
└── secrets.yaml                ← Credenciales WiFi

esphome/
└── smartnode1.yaml             ← Firmware activo
```

---

## ✅ Checklist de Verificación

Antes de considerar el dispositivo funcional:

- [ ] ESP32 enciende con batería (sin USB)
- [ ] WiFi conecta a la red (192.168.1.13)
- [ ] Home Assistant detecta el dispositivo
- [ ] Sensor temperatura reporta 15-30°C
- [ ] Sensor humedad reporta 20-80%
- [ ] Sensor luz varía con iluminación
- [ ] Sensor presencia detecta movimiento
- [ ] Batería reporta 3.5-4.2V
- [ ] Carga batería con USB Type-C

---

## 🎯 Próximas Mejoras (V4)

Posibles adiciones futuras:
- [ ] Sensor BME280 (presión atmosférica + mejor temp/hum)
- [ ] Pantalla OLED para feedback local
- [ ] Sensor CO2 (MH-Z19 o SCD30)
- [ ] Case impreso en 3D
- [ ] Deep sleep para mayor autonomía

---

## 📞 Soporte

Para problemas o dudas:
1. Revisar sección **Troubleshooting**
2. Consultar `DIAGNOSTICO_SMARTNODE1.md`
3. Verificar logs: `esphome logs smartnode1.yaml`
4. Usar multímetro según `GUIA_USO_TESTER.md`

---

**Última prueba exitosa:** 4 Enero 2026  
**Dispositivo:** smartnode1 @ 192.168.1.13  
**Todos los sensores verificados:** ✅ FUNCIONANDO

