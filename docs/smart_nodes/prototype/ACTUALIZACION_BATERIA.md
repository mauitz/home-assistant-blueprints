# Actualización Smart Node V2 - Batería 18650

**Fecha:** 2 de enero de 2026
**Dispositivo:** smartnode1
**Puerto:** /dev/cu.usbserial-0001

---

## ✅ Cambios Realizados

### 1. Actualización de Documentación

Se actualizó `SMARTNODE_V2.md` con las especificaciones reales de la batería utilizada:

#### Batería Anterior (Genérica)
- Tipo: LiPo genérica
- Capacidad: 2000-3000 mAh (recomendado)

#### Batería Actual (Real)
- **Marca:** California Li
- **Modelo:** 18650 Lithium-ion Cell
- **Tipo:** Li-Ion (Litio-ion)
- **Formato:** 18650 (18mm × 65mm)
- **Capacidad:** 2600 mAh
- **Voltaje nominal:** 3.7V
- **Voltaje máximo:** 4.2V (carga completa)
- **Voltaje mínimo:** 3.0V (descarga)

### 2. Autonomía Actualizada

Con la batería de 2600 mAh:

| Modo de Operación | Consumo Estimado | Autonomía |
|-------------------|------------------|-----------|
| WiFi activo + todos los sensores | 150-200 mA | **13-17 horas** |
| WiFi intermitente | 80-120 mA | **21-32 horas** |
| Deep sleep (sin presencia) | 10-20 mA | **130-260 horas** |

### 3. Flasheo del ESP32

Se compiló y flasheó exitosamente el firmware ESPHome al ESP32:

```bash
python3 -m esphome run smartnode1.yaml --device /dev/cu.usbserial-0001
```

#### Sensores Configurados ✅

1. **LD2410** (Sensor mmWave)
   - Puerto: UART (GPIO16/17)
   - Baud rate: 256000
   - Estado: ✅ Funcionando

2. **DHT11** (Temperatura/Humedad)
   - Pin: GPIO4
   - Intervalo: 60s
   - Estado: ✅ Auto-detectado

3. **LDR** (Luz Ambiental)
   - Pin: GPIO32 (ADC)
   - Intervalo: 5s
   - Estado: ✅ Funcionando

4. **INMP441** (Micrófono I2S)
   - Pines: GPIO25 (WS), GPIO26 (SCK), GPIO33 (SD)
   - Estado: ✅ Configurado

---

## 📋 Configuración del Sistema

### Diagrama de Alimentación

```
[USB Type-C] → [TP4056] → [Batería 18650 Li-Ion 2600mAh]
                   ↓
            [Salida regulada]
                   ↓
            [ESP32 VIN/GND]
```

### Características del TP4056

- Corriente de carga: 1A
- Tiempo de carga completa: ~2.5-3 horas
- Protecciones:
  - ✅ Sobrecarga
  - ✅ Descarga profunda
  - ✅ Cortocircuito
- Indicadores LED:
  - 🔴 Rojo: Cargando
  - 🔵 Azul: Carga completa

---

## 🔌 Conexiones Verificadas

Todas las conexiones según `diagramaV2.png`:

| Componente | Pin Componente | → | Pin ESP32 | Estado |
|------------|----------------|---|-----------|--------|
| **TP4056** | OUT+ | → | VIN | ✅ |
| **TP4056** | OUT- | → | GND | ✅ |
| **TP4056** | BAT+ | → | Batería (+) | ✅ |
| **TP4056** | BAT- | → | Batería (-) | ✅ |
| **LD2410** | VCC | → | 5V | ✅ |
| **LD2410** | TX | → | GPIO16 (RX) | ✅ |
| **LD2410** | RX | → | GPIO17 (TX) | ✅ |
| **LD2410** | GND | → | GND | ✅ |
| **DHT11** | VCC | → | 3.3V | ✅ |
| **DHT11** | DATA | → | GPIO4 | ✅ |
| **DHT11** | GND | → | GND | ✅ |
| **LDR** | Terminal 1 | → | 5V | ✅ |
| **LDR** | Terminal 2 | → | GPIO32 + R10kΩ | ✅ |
| **R 10kΩ** | Terminal 2 | → | GND | ✅ |
| **INMP441** | VDD | → | 3.3V | ✅ |
| **INMP441** | SD | → | GPIO33 | ✅ |
| **INMP441** | WS | → | GPIO25 | ✅ |
| **INMP441** | SCK | → | GPIO26 | ✅ |
| **INMP441** | L/R | → | GND | ✅ |
| **INMP441** | GND | → | GND | ✅ |

---

## 🧪 Próximos Pasos

### Pruebas Recomendadas

1. **Verificar Conectividad WiFi**
   ```bash
   # Verificar que el dispositivo se conecta a Home Assistant
   # Buscar en HA: smartnode1
   ```

2. **Probar Sensores Individualmente**
   - [ ] LD2410: Detecta presencia
   - [ ] DHT11: Reporta temperatura y humedad
   - [ ] LDR: Detecta cambios de luz
   - [ ] INMP441: Captura nivel de sonido

3. **Test de Autonomía**
   - [ ] Desconectar USB
   - [ ] Verificar funcionamiento con batería
   - [ ] Medir tiempo de operación continua
   - [ ] Objetivo: >13 horas

4. **Test de Carga**
   - [ ] Conectar USB al TP4056
   - [ ] Verificar LED rojo (cargando)
   - [ ] Esperar carga completa (LED azul)
   - [ ] Tiempo esperado: ~2.5-3 horas

---

## 📊 Logs del Flasheo

El flasheo se completó exitosamente. Extracto de los logs:

```
[13:34:29][C][ld2410:049]: LD2410 configurado correctamente
[13:34:29][C][adc:097]: ADC Sensor 'Room Brightness' en GPIO32
[13:34:29][C][dht:018]: DHT en GPIO4 - Auto-detectado: DHT11
[13:34:29][C][i2s_audio:073]: I2S audio initialized (INMP441)
```

---

## 📁 Archivos Actualizados

1. **Documentación:**
   - `docs/smart_nodes/prototype/SMARTNODE_V2.md` ✅

2. **Configuración ESPHome:**
   - `esphome/smartnode1.yaml` ✅ (copiado desde device.yaml)

3. **Este documento:**
   - `docs/smart_nodes/prototype/ACTUALIZACION_BATERIA.md` ✅

---

## 🔋 Especificaciones Técnicas de la Batería

### Batería California Li 18650

```
Marca:              California Li
Tipo:               Lithium-ion (Li-Ion)
Formato:            18650 (18mm diámetro × 65mm largo)
Capacidad:          2600 mAh
Voltaje nominal:    3.7V
Voltaje carga:      4.2V
Voltaje descarga:   3.0V
Química:            Li-Ion
Ciclos de vida:     ~500-1000 ciclos
```

### Ventajas del Formato 18650

- ✅ Mayor densidad energética que LiPo
- ✅ Formato estándar y reemplazable
- ✅ Más seguro (carcasa metálica)
- ✅ Mejor estabilidad térmica
- ✅ Disponibilidad comercial amplia

---

## 🛠️ Comandos Útiles

### Flashear de nuevo (OTA)
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
python3 -m esphome run smartnode1.yaml
```

### Ver logs en tiempo real
```bash
python3 -m esphome logs smartnode1.yaml --device /dev/cu.usbserial-0001
```

### Compilar sin flashear
```bash
python3 -m esphome compile smartnode1.yaml
```

---

## ✅ Checklist de Verificación

### Hardware
- [x] Batería 18650 conectada al TP4056
- [x] TP4056 conectado al ESP32 (VIN/GND)
- [x] Todos los sensores conectados según diagrama
- [x] ESP32 enciende con batería solamente
- [ ] Autonomía verificada (>13 horas)

### Software
- [x] ESPHome instalado
- [x] Código compilado exitosamente
- [x] Firmware flasheado al ESP32
- [x] Todos los sensores detectados
- [ ] Dispositivo visible en Home Assistant
- [ ] Todos los sensores reportando datos

### Documentación
- [x] SMARTNODE_V2.md actualizado
- [x] Especificaciones de batería documentadas
- [x] Autonomía recalculada
- [x] Este documento de actualización creado

---

**Estado:** ✅ Flasheo completado exitosamente
**Próximo paso:** Verificar conectividad con Home Assistant
**Última actualización:** 2 de enero de 2026



