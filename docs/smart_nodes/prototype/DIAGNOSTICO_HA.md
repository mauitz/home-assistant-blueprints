# Guía de Diagnóstico - Smart Node no reporta a Home Assistant

**Fecha:** 2 de enero de 2026
**Problema:** El dispositivo smartnode1 no aparece o no reporta datos en Home Assistant

---

## 🔍 Diagnóstico Inicial de tus Logs

### ✅ Lo que SÍ funciona:

1. **Sensor LDR (Luz Ambiental)** ✅
   - Reportando valores: 65%, 75%, 71%, etc.
   - Actualización cada 5 segundos
   - **Estado:** Funcionando correctamente

2. **ESP32 encendido** ✅
   - Ejecutando código
   - Sensores leyendo datos

### ❌ Lo que NO funciona:

1. **Sensor DHT11** 🔴
   ```
   [W][dht:174]: Requesting data from DHT failed!
   [W][dht:060]: Invalid readings! Please check your wiring
   ```
   - Reporta "nan" (not a number)
   - Error de lectura

2. **Conexión WiFi** ❓
   - No hay mensajes de WiFi en los logs
   - No se ve intento de conexión
   - **ESTE ES EL PROBLEMA PRINCIPAL**

---

## 🎯 Problema Principal: Sin Conexión WiFi

Si no hay mensajes de WiFi en los logs, el ESP32 **no se está conectando a la red**. Sin WiFi, no puede comunicarse con Home Assistant.

### Causas Posibles:

1. **Credenciales WiFi incorrectas** en `secrets.yaml`
2. **Red WiFi 5GHz** (ESP32 solo soporta 2.4GHz)
3. **Señal WiFi débil** donde está el dispositivo
4. **Problema con el módulo WiFi** del ESP32

---

## 📋 Plan de Diagnóstico Paso a Paso

### **Paso 1: Verificar Credenciales WiFi**

Primero, verifiquemos que el archivo `secrets.yaml` tiene las credenciales correctas:

```bash
# El archivo debería tener:
wifi_ssid: "PA Devices_2G"
wifi_password: "R3spons3d3v1s3s"
```

**⚠️ Importante:**
- El SSID debe ser **exactamente igual** (mayúsculas, espacios)
- La contraseña debe ser correcta
- **Debe ser red 2.4GHz**, no 5GHz

**Acción:** Verifica que tu red "PA Devices_2G" esté:
- [ ] Encendida y funcionando
- [ ] Es 2.4GHz (no 5GHz)
- [ ] Otros dispositivos se conectan correctamente

---

### **Paso 2: Ver Logs Completos desde el Boot**

Vamos a reiniciar el ESP32 y ver los logs desde el inicio para capturar los mensajes de WiFi:

```bash
# Comando para ver logs en tiempo real
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
python3 -m esphome logs smartnode1.yaml --device /dev/cu.usbserial-0001
```

**Mientras se ejecuta:**
1. Presiona el botón **RESET** (EN) del ESP32
2. Observa los logs desde el inicio
3. Busca estas líneas clave:

#### Logs Normales (BUENO):
```
[I][app:100]: ESPHome version 2024.11.3 compiled on...
[C][wifi:038]: Setting up WiFi...
[C][wifi:051]: Starting WiFi...
[C][wifi:052]:   SSID: 'PA Devices_2G'
[I][wifi:304]: WiFi Connecting to 'PA Devices_2G'...
[I][wifi:582]: WiFi Connected!
[C][wifi:419]:   IP Address: 192.168.1.XXX
[C][api:138]: Setting up Home Assistant API...
[I][app:062]: setup() finished successfully!
```

#### Logs con Problema WiFi (MALO):
```
[W][wifi:453]: WiFi Connection attempt failed
[W][wifi:469]: Connecting to 'PA Devices_2G'... Retrying in 5s
[W][wifi:469]: Connecting to 'PA Devices_2G'... Retrying in 10s
```

#### Logs con Problema de Contraseña (MALO):
```
[E][wifi:xxx]: WiFi authentication failed
[W][wifi:xxx]: Wrong password
```

---

### **Paso 3: Interpretar los Logs**

Una vez que veas los logs desde el boot, identifica cuál es tu caso:

#### **Caso A: Se conecta a WiFi pero no a Home Assistant**

Si ves:
```
[I][wifi:582]: WiFi Connected!
[C][wifi:419]: IP Address: 192.168.1.XXX
```

**Pero NO ves:**
```
[I][app:062]: setup() finished successfully!
```

**Problema:** Home Assistant no puede descubrir el dispositivo

**Solución:** Ver sección "Agregar Manualmente a HA" más abajo

---

#### **Caso B: No se conecta a WiFi - Credenciales incorrectas**

Si ves:
```
[E][wifi:xxx]: WiFi authentication failed
```

**Problema:** Contraseña incorrecta o SSID incorrecto

**Solución:**
1. Verificar `secrets.yaml`
2. Re-compilar y flashear

---

#### **Caso C: No se conecta a WiFi - No encuentra la red**

Si ves:
```
[W][wifi:xxx]: Can't connect to WiFi network 'PA Devices_2G'
[W][wifi:xxx]: Reason: SSID not found
```

**Problema:** El ESP32 no ve la red WiFi

**Posibles causas:**
- Red 5GHz (cambiar a 2.4GHz)
- Señal muy débil
- Canal WiFi incompatible (algunos ESP32 no soportan canales >11)

**Solución:**
1. Acercar el ESP32 al router
2. Verificar que es 2.4GHz
3. Cambiar canal del router a 1-11

---

#### **Caso D: Bootloop o reseteos constantes**

Si ves:
```
[I][app:100]: ESPHome version...
[Boot loop detected...]
[Rebooting...]
```

**Problema:** Código defectuoso o hardware con problemas

**Posibles causas:**
- Sensor DHT en cortocircuito
- Alimentación insuficiente
- Problema con el LD2410

**Solución:** Ver sección de Troubleshooting Hardware

---

### **Paso 4: Agregar Manualmente a Home Assistant**

Si el ESP32 se conecta a WiFi pero Home Assistant no lo descubre automáticamente:

#### En Home Assistant:

1. **Ir a:** Configuración → Dispositivos y Servicios
2. **Buscar:** "smartnode1" o "Smart Node 1"
3. **Si NO aparece:**

   a) Agregar integración manualmente:
   ```
   Configuración → Dispositivos y Servicios
   → + Agregar Integración
   → Buscar: "ESPHome"
   → Ingresar:
      - Host: 192.168.1.XXX (la IP que viste en logs)
      - Port: 6053 (default)
      - Encryption Key: uiBug7J/YQ2WEQwAinei45aUGm7L9cf6Sp82nI4GuIU=
   ```

4. **Hacer ping** desde tu computadora:
   ```bash
   ping 192.168.1.XXX
   # Debe responder
   ```

5. **Verificar puerto** desde tu computadora:
   ```bash
   nc -zv 192.168.1.XXX 6053
   # Debe mostrar: Connection succeeded
   ```

---

## 🔧 Soluciones Rápidas

### Solución 1: Modo Hotspot de Respaldo

El ESP32 tiene configurado un **hotspot de respaldo** que se activa si no puede conectarse a tu WiFi:

```yaml
ap:
  ssid: "Test1 Fallback Hotspot"
  password: "EFM0SoydaFKO"
```

**Cómo usarlo:**
1. Si el ESP32 no se conecta a tu WiFi después de 1 minuto
2. Creará su propia red WiFi llamada **"Test1 Fallback Hotspot"**
3. Conéctate a esa red desde tu teléfono/computadora
4. Contraseña: `EFM0SoydaFKO`
5. Se abrirá un portal para configurar WiFi

**Acción:**
- [ ] Espera 1-2 minutos después de encender
- [ ] Busca red "Test1 Fallback Hotspot" en tu teléfono
- [ ] Si aparece, conéctate y configura WiFi desde el portal

---

### Solución 2: Actualizar Configuración WiFi

Si las credenciales están mal, actualiza `secrets.yaml` y re-flashea:

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome

# 1. Editar secrets.yaml con las credenciales correctas
nano secrets.yaml

# 2. Re-compilar y flashear
python3 -m esphome run smartnode1.yaml --device /dev/cu.usbserial-0001
```

---

### Solución 3: Configuración WiFi Explícita (sin secrets)

Para debugging, prueba poner las credenciales directamente en el YAML:

```yaml
# En smartnode1.yaml, reemplazar:
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

# Por:
wifi:
  ssid: "PA Devices_2G"
  password: "R3spons3d3v1s3s"
  # Forzar 2.4GHz
  output_power: 8.5dB
  fast_connect: true
```

Luego re-compilar y flashear.

---

## 🐛 Troubleshooting del Sensor DHT11

El sensor DHT está fallando. Esto **NO impide** la conexión a Home Assistant, pero hay que arreglarlo:

### Problema Detectado:
```
[W][dht:174]: Requesting data from DHT failed!
[W][dht:060]: Invalid readings!
```

### Causas Posibles:

1. **Cable DATA mal conectado**
   - Debe estar en GPIO4 del ESP32
   - Verificar continuidad con tester

2. **Sensor defectuoso**
   - El DHT11 es frágil
   - Probar con otro sensor

3. **Falta resistencia pull-up**
   - Algunos DHT11 necesitan resistencia de 4.7kΩ o 10kΩ entre DATA y VCC
   - Conectar: VCC → Resistencia → DATA (y DATA → GPIO4)

4. **Voltaje insuficiente**
   - DHT11 necesita 3.3V estables
   - Medir con tester (debe ser 3.2-3.4V)

### Solución Temporal:

Deshabilita el DHT11 en la configuración para que no genere errores:

```yaml
# En smartnode1.yaml, comenta el sensor DHT:
sensor:
  # - platform: dht
  #   pin: 4
  #   temperature:
  #     name: "Room Temperature"
  #   humidity:
  #     name: "Room Humidity"
  #   update_interval: 60s
```

Re-compilar y flashear. Esto permitirá que el ESP32 funcione sin el DHT mientras lo arreglas.

---

## 📊 Checklist de Diagnóstico

### Red WiFi
- [ ] Red "PA Devices_2G" está encendida
- [ ] Es red 2.4GHz (NO 5GHz)
- [ ] Otros dispositivos se conectan correctamente
- [ ] SSID y contraseña en `secrets.yaml` son correctos
- [ ] ESP32 está cerca del router (señal fuerte)

### Logs del ESP32
- [ ] He visto los logs desde el boot (con RESET)
- [ ] Veo mensaje: "WiFi Connected!"
- [ ] Veo IP asignada: "IP Address: 192.168.X.X"
- [ ] Veo mensaje: "setup() finished successfully!"
- [ ] NO veo errores de autenticación WiFi

### Home Assistant
- [ ] Home Assistant está funcionando
- [ ] Busqué "smartnode1" en Dispositivos y Servicios
- [ ] Intenté agregar integración ESPHome manualmente
- [ ] Home Assistant y ESP32 están en la misma red

### Hardware
- [ ] ESP32 enciende (LED interno)
- [ ] Batería cargada (>3.5V)
- [ ] No hay componentes sueltos
- [ ] No hay cortocircuitos visibles

---

## 🧪 Comandos Útiles para Diagnóstico

### Ver logs en tiempo real (con cable USB):
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
python3 -m esphome logs smartnode1.yaml --device /dev/cu.usbserial-0001
```

### Re-compilar y flashear:
```bash
python3 -m esphome run smartnode1.yaml --device /dev/cu.usbserial-0001
```

### Validar configuración sin compilar:
```bash
python3 -m esphome config smartnode1.yaml
```

### Ver IP del dispositivo (si ya se conectó antes):
```bash
python3 -m esphome logs smartnode1.yaml
# Buscará el dispositivo en la red por mDNS
```

### Hacer ping al dispositivo (si conoces la IP):
```bash
ping smartnode1.local
# O
ping 192.168.1.XXX
```

---

## 🎯 Plan de Acción Recomendado

### Ahora Mismo (5 minutos):

1. **Conectar USB** al ESP32
2. **Ejecutar:**
   ```bash
   cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
   python3 -m esphome logs smartnode1.yaml --device /dev/cu.usbserial-0001
   ```
3. **Presionar botón RESET** del ESP32
4. **Observar logs** - buscar mensajes de WiFi
5. **Anotar:**
   - ¿Se conecta a WiFi? (Sí/No)
   - ¿Qué IP obtiene? ______
   - ¿Qué errores aparecen? ______

### Siguiente (10 minutos):

**Si NO se conecta a WiFi:**
1. Verificar `secrets.yaml`
2. Verificar que "PA Devices_2G" es 2.4GHz
3. Acercar ESP32 al router
4. Re-flashear si cambias algo

**Si SÍ se conecta a WiFi:**
1. Anotar la IP asignada
2. Ir a Home Assistant
3. Agregar integración ESPHome manualmente
4. Usar la IP y la clave de encriptación

### Después (según problema):

**Arreglar DHT11:**
1. Verificar conexión GPIO4
2. Agregar resistencia pull-up 10kΩ
3. O deshabilitar temporalmente

**Probar sensores:**
1. LDR ya funciona ✅
2. Verificar LD2410 en los logs
3. Verificar INMP441 en los logs

---

## 📞 Próximos Pasos

Una vez que identifiques el problema específico:

1. **Si es WiFi:** Te ayudaré a ajustar la configuración
2. **Si es Home Assistant:** Te guiaré en la integración manual
3. **Si es hardware:** Diagnóstico con tester

**¿Qué necesitas hacer AHORA?**

```bash
# Ejecuta esto y dime qué ves:
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
python3 -m esphome logs smartnode1.yaml --device /dev/cu.usbserial-0001

# Luego presiona RESET en el ESP32 y copia los primeros 50 líneas
# que aparezcan después del reset
```

---

**Última actualización:** 2 de enero de 2026
**Estado:** Guía de diagnóstico - esperando logs completos
**Próximo paso:** Ver logs desde el boot para identificar problema WiFi



