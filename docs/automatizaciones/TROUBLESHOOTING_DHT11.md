# 🔧 Troubleshooting: DHT11 No Entrega Datos

## 🎯 Síntoma

El sensor DHT11 aparece en Home Assistant pero muestra:
- `unknown`
- `unavailable`
- Sin valores de temperatura ni humedad

Los logs del ESP32 muestran:
```
[E][dht:036]: Requesting data from DHT failed!
[W][dht:060]: Invalid readings! Please check your wiring.
```

---

## ✅ Verificaciones Rápidas

### 1. Conexión Física ✓

**Si tienes módulo DHT11 (3 pines con PCB azul/rojo):**

```
DHT11 Module    ESP32
============    =====
VCC (o +)    →  3.3V ✓ (CORRECTO)
DATA/OUT/S   →  GPIO27
GND (o -)    →  GND
```

**Si tienes DHT11 "crudo" (4 pines sin PCB):**

```
DHT11 Pin       ESP32           Notas
=========       =====           =====
Pin 1 (VCC)  →  3.3V           ✓
Pin 2 (DATA) →  GPIO27         ⚠️ Necesita resistencia 10kΩ a 3.3V
Pin 3 (NC)   →  sin conectar   No se usa
Pin 4 (GND)  →  GND            ✓
```

### 2. ⚠️ Resistencia Pull-Up

El DHT11 **requiere una resistencia pull-up de 10kΩ** entre DATA y VCC (3.3V).

**¿Tu módulo ya la tiene?**
- ✅ **Módulos DHT11 en PCB**: Ya incluyen la resistencia
- ❌ **DHT11 "crudo"**: Debes agregarla tú

**Cómo agregar resistencia pull-up:**

```
         3.3V
          |
         [10kΩ]  ← Resistencia
          |
GPIO27 ←--+
          |
       [DHT11 DATA]
          |
         GND
```

O usa el pull-up interno del ESP32 (ver configuración más abajo).

### 3. Voltaje Correcto

- ✅ **3.3V** → Recomendado para ESP32
- ⚠️ **5V** → Puede funcionar, pero arriesgas el ESP32 si DATA envía 5V a GPIO27

**¿Ya lo conectaste a 5V antes?**
- Si el DHT11 estuvo conectado a 5V con el ESP32, puede haberse dañado el ESP32.
- El DHT11 mismo soporta 5V sin problemas.

### 4. Cable Corto

- ✅ **Máximo 20cm** de cable entre DHT11 y ESP32
- ❌ Si usas cables largos (>50cm), el sensor puede fallar por interferencias

### 5. GPIO Correcto

Verifica en los logs del ESP32:

```bash
# Ver configuración de pines
python3 -m esphome logs riego_z1.yaml --device 192.168.1.15 | grep -i "dht"
```

Debe decir:
```
[C][dht:011]: DHT Sensor:
[C][dht:012]:   Pin: GPIO27
[C][dht:017]:   Model: DHT11
```

---

## 🧪 Pruebas de Diagnóstico

### Prueba 1: Habilitar Pull-Up Interno

Edita `esphome/riego_z1.yaml`:

```yaml
sensor:
  - platform: dht
    pin: 
      number: GPIO27
      mode:
        input: true
        pullup: true  # ← Agregar pull-up interno
    model: DHT11
    temperature:
      name: "Temperatura Ambiente"
      id: temperatura
    humidity:
      name: "Humedad Ambiente"
      id: humedad_ambiente
    update_interval: 30s  # ← Aumentar intervalo
```

Flashea:
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
python3 -m esphome run riego_z1.yaml --device 192.168.1.15
```

### Prueba 2: Usar DHT22 en vez de DHT11

A veces el firmware detecta mejor con el driver DHT22:

```yaml
sensor:
  - platform: dht
    pin: GPIO27
    model: DHT22  # ← Cambiar temporalmente
    temperature:
      name: "Temperatura Ambiente"
    humidity:
      name: "Humedad Ambiente"
    update_interval: 30s
```

**Nota**: Si funciona con `DHT22` pero tu sensor es DHT11, es señal de que el sensor está mal conectado o dañado.

### Prueba 3: Firmware de Prueba Aislado

Usa el firmware de prueba simple que creamos:

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome

# Compilar y flashear firmware de prueba
python3 -m esphome run test_dht11_simple.yaml --device 192.168.1.15

# Ver logs en tiempo real
python3 -m esphome logs test_dht11_simple.yaml --device 192.168.1.15
```

**Logs esperados:**

✅ **Funcionando:**
```
[D][dht:048]: Got Temperature=24.0°C Humidity=65.0%
DHT11 → Temp: 24.0°C, Hum: 65.0%
```

❌ **No funciona:**
```
[E][dht:036]: Requesting data from DHT failed!
[W][dht:060]: Invalid readings! Please check your wiring.
```

### Prueba 4: Cambiar de GPIO

A veces el GPIO27 puede tener problemas. Prueba con otro GPIO:

**GPIOs seguros en ESP32:**
- GPIO26
- GPIO25
- GPIO33
- GPIO32

Cambia físicamente el DHT11 a GPIO26 y edita el YAML:

```yaml
sensor:
  - platform: dht
    pin: GPIO26  # ← Nuevo pin
    model: DHT11
    ...
```

### Prueba 5: Verificar con Multímetro

Con el ESP32 **encendido**:

1. **VCC del DHT11**: Debe medir **3.3V**
2. **GND del DHT11**: Debe medir **0V**
3. **DATA del DHT11**: Debe medir **entre 1.5V - 3.3V** (fluctúa)

Si DATA mide 0V o 3.3V fijo → problema de conexión o sensor dañado.

---

## 🔍 Posibles Causas y Soluciones

| Síntoma | Causa Probable | Solución |
|---------|----------------|----------|
| Siempre `unknown` | Falta resistencia pull-up | Agregar 10kΩ o habilitar pull-up interno |
| Funciona intermitente | Cable largo o interferencia | Usar cable corto (<20cm) y resistencia externa |
| Valores locos (999°C) | Sensor dañado | Reemplazar DHT11 |
| No responde en absoluto | Cable DATA desconectado | Revisar conexión física |
| Funcionó antes, ahora no | Sensor dañado por 5V | Reemplazar DHT11 y usar 3.3V |
| Error de timeout | `update_interval` muy corto | Cambiar a 30s o más |

---

## 🛠️ Configuración Recomendada Final

Después de las pruebas, usa esta configuración en `riego_z1.yaml`:

```yaml
sensor:
  # DHT11 - Temperatura y Humedad Ambiente
  - platform: dht
    pin: 
      number: GPIO27
      mode:
        input: true
        pullup: true  # Pull-up interno habilitado
    model: DHT11
    temperature:
      name: "Temperatura Ambiente"
      id: temperatura
      filters:
        - offset: 0.0  # Calibración si es necesario
        - sliding_window_moving_average:
            window_size: 3
            send_every: 3
    humidity:
      name: "Humedad Ambiente"
      id: humedad_ambiente
      filters:
        - offset: 0.0  # Calibración si es necesario
        - sliding_window_moving_average:
            window_size: 3
            send_every: 3
    update_interval: 30s  # Cada 30 segundos (más estable)
```

**Mejoras de esta configuración:**
- ✅ Pull-up interno habilitado
- ✅ Filtro de promedio móvil (reduce lecturas erróneas)
- ✅ Update interval más largo (30s vs 10s)
- ✅ Calibración por offset si es necesario

---

## 🆘 Si Nada Funciona

### Opción 1: Reemplazar con DHT22

El **DHT22** es más preciso y robusto que el DHT11:

```yaml
sensor:
  - platform: dht
    pin: GPIO27
    model: DHT22  # ← Cambio definitivo
    temperature:
      name: "Temperatura Ambiente"
      accuracy_decimals: 1
    humidity:
      name: "Humedad Ambiente"
      accuracy_decimals: 1
    update_interval: 30s
```

**Ventajas del DHT22:**
- Más preciso (-40 a 80°C vs 0 a 50°C)
- Humedad 0-100% vs 20-80%
- Menos errores de lectura
- Mismo pinout que DHT11

Costo: ~$2-3 USD

### Opción 2: Usar Sensor BME280 (I2C)

Si tienes problemas constantes con DHT, considera el **BME280**:

```yaml
i2c:
  sda: GPIO21
  scl: GPIO22
  scan: true

sensor:
  - platform: bme280
    temperature:
      name: "Temperatura Ambiente"
      oversampling: 16x
    humidity:
      name: "Humedad Ambiente"
      oversampling: 16x
    pressure:
      name: "Presión Atmosférica"
    address: 0x76
    update_interval: 60s
```

**Ventajas:**
- ✅ Mucho más preciso
- ✅ Incluye presión atmosférica
- ✅ Protocolo I2C (más robusto)
- ✅ Sin necesidad de resistencias pull-up

Costo: ~$3-5 USD

### Opción 3: Omitir Temporalmente

Si no es crítico, puedes comentar el DHT11 temporalmente:

```yaml
# sensor:
#   - platform: dht
#     pin: GPIO27
#     model: DHT11
#     ...
```

El resto del sistema de riego funcionará sin problemas.

---

## 📊 Checklist de Diagnóstico

- [ ] Cable DATA conectado a GPIO27
- [ ] VCC conectado a 3.3V (NO 5V)
- [ ] GND conectado a GND
- [ ] Resistencia pull-up 10kΩ presente (o pull-up interno habilitado)
- [ ] Cable menor a 20cm
- [ ] `update_interval` de al menos 30s
- [ ] Sensor no está dañado (probado con firmware aislado)
- [ ] GPIO27 no está siendo usado por otro componente
- [ ] Logs no muestran errores de DHT

Si todas las verificaciones pasan y aún no funciona → **Sensor DHT11 defectuoso**, reemplazar.

---

## 📚 Recursos

- [ESPHome DHT Documentation](https://esphome.io/components/sensor/dht.html)
- [DHT11 Datasheet](https://www.mouser.com/datasheet/2/758/DHT11-Technical-Data-Sheet-Translated-Version-1143054.pdf)
- [ESP32 GPIO Reference](https://randomnerdtutorials.com/esp32-pinout-reference-gpios/)

---

**Versión**: 1.0  
**Autor**: @mauitz

