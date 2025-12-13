# 🔍 Diagnóstico de Sensores - Sistema de Riego

## ❌ Problemas Detectados en la Captura:

### 1. **"Entidad no encontrada" en Control Manual**
```
⚙️ Control Manual
⚠️ Entidad no encontrada
```

**Causa:** El helper `input_boolean.riego_z1_manual` no existe en Home Assistant.

**Solución:**
1. Ve a **Configuración → Dispositivos y Servicios → Helpers**
2. Click **+ CREAR HELPER**
3. Tipo: **Toggle** (Input Boolean)
4. Nombre: `Riego Z1 - Modo Manual`
5. ID: `riego_z1_manual`
6. Icono: `mdi:hand-back-right`
7. Guardar

---

### 2. **"Entidad no es numérica: sensor.riego_z1_nivel_tanque"**
```
⚠️ Entidad no es numérica: sensor.riego_z1_nivel_tanque
```

**Causa:** El sensor HC-SR04 puede estar:
- Mal conectado
- Demasiado lejos del agua (>400cm)
- Cables invertidos (TRIG/ECHO)

**Cableado correcto HC-SR04:**
```
HC-SR04        ESP32
========       =====
VCC   ───────► 5V
GND   ───────► GND
TRIG  ───────► GPIO13
ECHO  ───────► GPIO14
```

**Verificar:**
- ¿El sensor está montado apuntando al agua?
- ¿La distancia es menor a 4 metros?
- ¿Los cables están bien conectados?

---

### 3. **Temperatura y Humedad Ambiente NO aparecen**
```
✅ Humedad del Suelo: 34.9%  (funciona)
❌ Temperatura Ambiente: no data
❌ Humedad Ambiente: no data
```

**Causa:** El sensor **DHT11** no está funcionando.

**Sensor:** DHT11 en GPIO27

**Posibles problemas:**

#### A) **Cable mal conectado**
```
DHT11         ESP32
=====         =====
VCC (pin 1)  → 5V o 3.3V
DATA (pin 2) → GPIO27  ⚠️ VERIFICAR
NC (pin 3)   → (sin conectar)
GND (pin 4)  → GND
```

**⚠️ IMPORTANTE:**
- DHT11 tiene 4 pines
- Algunos módulos DHT11 tienen 3 pines (ya integran la resistencia)
- Verifica que el pin DATA esté en GPIO27

#### B) **Falta resistencia pull-up**
```
        3.3V
         |
        [ ] 10kΩ resistor
         |
    ────┴──── GPIO27 (DATA)
```

Si tienes un DHT11 "crudo" (sin módulo), necesitas una resistencia de 10kΩ entre VCC y DATA.

#### C) **Sensor dañado**
- El DHT11 es sensible
- Si se sobrecalienta o se moja, puede dañarse
- Prueba con otro DHT11 si tienes

---

### 4. **Scripts con "Ejecutar" pero "Entidad no encontrada"**
```
🚰 Regar 5 minutos    [Ejecutar]
⚠️ Entidad no encontrada
```

**Causa:** La automatización `automation.riego_automatico_zona_1` no existe.

**Solución:**
1. Ve a **Configuración → Automatizaciones**
2. Click **+ CREAR AUTOMATIZACIÓN**
3. Selecciona **Crear desde Blueprint**
4. Busca "Sistema de Riego Inteligente"
5. Configúrala con:
   ```yaml
   Zona: "Zona 1"
   Bomba: switch.riego_z1_bomba_z1a
   Sensor Humedad: sensor.riego_z1_humedad_suelo_z1
   Sensor Tanque: sensor.riego_z1_nivel_tanque
   ```

---

## 🧪 **Pruebas de Diagnóstico:**

### **Prueba 1: Ver logs del ESP32**
```bash
# En tu Mac
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
python3 -m esphome logs riego_z1.yaml --device 192.168.1.15
```

**Busca errores del DHT11:**
```
[E][dht:036]: Requesting data from DHT failed!
[E][dht:060]: Invalid data received from DHT11
```

Si ves estos errores → **DHT11 mal conectado o dañado**

---

### **Prueba 2: Verificar entidades en HA**
1. Ve a **Herramientas para Desarrolladores → Estados**
2. Busca: `riego_z1`
3. Verifica qué sensores muestran valores:

```yaml
✅ sensor.riego_z1_humedad_suelo_z1       33.8 %
✅ sensor.riego_z1_luz_ambiente           13 %
❌ sensor.riego_z1_temperatura_ambiente   unavailable
❌ sensor.riego_z1_humedad_ambiente       unavailable
❓ sensor.riego_z1_nivel_tanque           unknown o unavailable
```

---

### **Prueba 3: Test del DHT11**

Voy a crear un firmware de diagnóstico simple para probar SOLO el DHT11:

```yaml
# test_dht11.yaml
esphome:
  name: test_dht11

esp32:
  board: esp32dev
  framework:
    type: arduino

wifi:
  ssid: "sunsetlabs-2.4GHz"
  password: "bienvenido"

logger:
  level: DEBUG  # Ver logs detallados

api:
ota:

sensor:
  - platform: dht
    pin: GPIO27
    model: DHT11
    temperature:
      name: "Test Temperatura"
    humidity:
      name: "Test Humedad"
    update_interval: 2s  # Actualizar cada 2 segundos
```

---

## 🔧 **Plan de Acción:**

### **Paso 1: Verificar DHT11**
1. **Apaga el ESP32**
2. **Verifica el cableado:**
   - VCC → 3.3V (NO 5V, puede dañarlo)
   - DATA → GPIO27
   - GND → GND
3. **Enciende el ESP32**
4. **Ve los logs** (comando arriba)

### **Paso 2: Verificar HC-SR04 (nivel tanque)**
1. **Verifica cableado:**
   - TRIG → GPIO13
   - ECHO → GPIO14
   - VCC → 5V
   - GND → GND
2. **Verifica que apunta al agua**
3. **Distancia < 400cm**

### **Paso 3: Crear Helpers y Automatización**
1. Crear `input_boolean.riego_z1_manual`
2. Crear automatización desde el blueprint
3. Recargar dashboard

---

## 📊 **Estado Actual de Sensores:**

| Sensor | Estado | Pin | Problema |
|--------|--------|-----|----------|
| Humedad Suelo Z1 | ✅ Funciona | GPIO34 | Ninguno |
| Luz Ambiente | ✅ Funciona | GPIO35 | Ninguno |
| Nivel Tanque | ❌ No numérico | GPIO13/14 | Mal conectado o fuera de rango |
| Temperatura | ❌ No data | GPIO27 | DHT11 no responde |
| Humedad Ambiente | ❌ No data | GPIO27 | DHT11 no responde |
| LD2410C | ❓ Desconocido | GPIO16/17 | No visible en captura |

---

## ✅ **Checklist de Solución:**

- [ ] Verificar cableado DHT11 en GPIO27
- [ ] Verificar cableado HC-SR04 en GPIO13/14
- [ ] Crear helper `input_boolean.riego_z1_manual`
- [ ] Crear automatización desde blueprint
- [ ] Ver logs del ESP32 para errores específicos
- [ ] Probar con otro DHT11 si es necesario
- [ ] Recargar dashboard después de fixes

---

## 🆘 **Si Nada Funciona:**

### **Opción 1: Desactivar sensores problemáticos**
Comenta las líneas del DHT11 en `riego_z1.yaml` y reflashea:

```yaml
# sensor:
#   - platform: dht
#     pin: GPIO27
#     model: DHT11
#     ...
```

### **Opción 2: Usar solo los sensores que funcionan**
El sistema de riego puede funcionar solo con:
- ✅ Humedad del suelo (funciona)
- ✅ Nivel del tanque (si lo arreglas)

Los demás son opcionales.

---

**¿Quieres que revisemos los logs del ESP32 juntos para ver exactamente qué está fallando?**


