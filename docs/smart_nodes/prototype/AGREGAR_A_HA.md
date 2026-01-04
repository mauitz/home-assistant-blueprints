# Cómo Agregar Smart Node a Home Assistant

**Dispositivo:** smartnode1
**IP:** 192.168.1.13
**MAC:** 04:83:08:57:5e:c8
**Estado:** Conectado al WiFi con autenticación intermitente

---

## 📝 Pasos para Agregar a Home Assistant

### Opción 1: Agregar por IP (RECOMENDADO)

Ya que el dispositivo tiene IP asignada, agrégalo manualmente:

#### En Home Assistant:

1. **Ir a:** Configuración → Dispositivos y Servicios
2. **Clic en:** `+ AGREGAR INTEGRACIÓN` (botón abajo a la derecha)
3. **Buscar:** `ESPHome`
4. **Seleccionar:** ESPHome
5. **Completar los datos:**

```
Host: 192.168.1.13
Port: 6053
Encryption Key: uiBug7J/YQ2WEQwAinei45aUGm7L9cf6Sp82nI4GuIU=
```

6. **Clic en:** ENVIAR
7. **Esperar:** Debería aparecer "Smart Node 1" con todos los sensores

---

## 🔧 Si no funciona inmediatamente

### Paso 1: Hacer Ping

Verifica conectividad desde tu computadora:

```bash
ping 192.168.1.13
```

**Resultado esperado:**
```
64 bytes from 192.168.1.13: icmp_seq=0 ttl=255 time=5.123 ms
64 bytes from 192.168.1.13: icmp_seq=1 ttl=255 time=4.891 ms
```

**Si responde:** El ESP32 está accesible ✅
**Si no responde:** Hay problema de red ❌

---

### Paso 2: Verificar Puerto ESPHome

```bash
nc -zv 192.168.1.13 6053
```

**Resultado esperado:**
```
Connection to 192.168.1.13 port 6053 [tcp/*] succeeded!
```

---

### Paso 3: Verificar Logs OTA (Over The Air)

Si el ESP32 sigue encendido, intenta ver logs por WiFi en vez de USB:

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
python3 -m esphome logs smartnode1.yaml
```

Esto buscará el dispositivo por mDNS (`smartnode1.local`) en la red.

---

## 🛠️ Mejoras para Estabilidad WiFi

El problema actual es que el ESP32 se conecta pero se desconecta constantemente. Vamos a mejorar la configuración:

### Actualización de Configuración WiFi

```yaml
wifi:
  ssid: "PA Devices_2G"
  password: "R3spons3d3v1s3s"

  # Mejoras para conexión estable
  fast_connect: true
  reboot_timeout: 15min
  power_save_mode: none

  # Asignar IP estática (evita problemas DHCP)
  manual_ip:
    static_ip: 192.168.1.13
    gateway: 192.168.1.1
    subnet: 255.255.255.0
    dns1: 192.168.1.1
    dns2: 8.8.8.8

  ap:
    ssid: "Test1 Fallback Hotspot"
    password: "EFM0SoydaFKO"
```

---

## 🔍 Diagnóstico del Problema de Autenticación

Los logs muestran:
```
reason='Association Failed' (código 1e10)
reason='Authentication Failed' (código 600)
```

### Posibles Causas:

#### 1. **Señal WiFi Débil** 📶

**Síntomas:**
- Se conecta y desconecta
- "Association Failed"

**Solución:**
- Acerca el ESP32 al router (prueba con <2 metros)
- Verifica que no hay paredes/obstáculos entre ellos

#### 2. **Configuración del Router** ⚙️

**Revisa en tu router:**

- [ ] **Seguridad WiFi:** Debe ser WPA2-PSK (no WPA3)
- [ ] **Canal:** Usa canal 1, 6 u 11 (no auto)
- [ ] **Ancho de banda:** 20MHz (no 40MHz)
- [ ] **Filtro MAC:** Desactivado (o agregar MAC del ESP32)
- [ ] **Aislamiento AP:** Desactivado
- [ ] **802.11w (PMF):** Desactivado

#### 3. **Interferencia** 📡

**Prueba:**
- Apagar temporalmente otros dispositivos WiFi cercanos
- Cambiar canal del router (probar 1, 6 y 11)
- Alejar de microondas, Bluetooth, etc.

#### 4. **Problema de Compatibilidad ESP32**

Algunos routers tienen problemas con ciertos chips ESP32.

**Solución temporal:**
- Crear red "guest" en el router solo para IoT
- Configuración simple: WPA2, canal fijo, 20MHz

---

## 🎯 Plan de Acción Ahora

### Paso 1: Agregar a Home Assistant (5 minutos)

**Hazlo ahora mismo mientras está conectado:**

1. Ve a Home Assistant
2. Configuración → Dispositivos y Servicios
3. + Agregar Integración → ESPHome
4. Host: `192.168.1.13`
5. Encryption Key: `uiBug7J/YQ2WEQwAinei45aUGm7L9cf6Sp82nI4GuIU=`

**Aunque se desconecte después, quedará configurado y se reconectará automáticamente.**

---

### Paso 2: Mejorar Señal WiFi (10 minutos)

**Mientras pruebas la integración:**

1. **Acerca el ESP32 al router** lo más posible
2. **Observa los logs** - ¿mejora la estabilidad?
3. Si es posible, usa **cable USB de datos** (no solo carga) para alimentación más estable

---

### Paso 3: Configurar IP Estática (15 minutos)

Una vez que funcione en Home Assistant, configurar IP estática ayudará mucho:

1. Reserva la IP 192.168.1.13 en tu router para la MAC 04:83:08:57:5e:c8
2. O actualiza el código para usar IP estática (te ayudo)

---

## 📊 Información para Soporte

**Detalles del dispositivo:**
```
Nombre: smartnode1
IP: 192.168.1.13
MAC: 04:83:08:57:5e:c8
Router: PA Devices_2G (canal: ?)
Señal: ? dBm
Error: Association/Authentication Failed intermitente
```

---

## ✅ Checklist de Soluciones

- [ ] Agregar a Home Assistant con IP 192.168.1.13
- [ ] Acercar ESP32 al router (<2m)
- [ ] Verificar seguridad router = WPA2 (no WPA3)
- [ ] Cambiar canal router a 1, 6 u 11 (fijo)
- [ ] Configurar IP estática en router
- [ ] Actualizar código con IP estática
- [ ] Reducir potencia TX si señal es fuerte
- [ ] Probar con otro router/hotspot para descartar hardware

---

**Próximo paso:** Agregar el dispositivo a Home Assistant AHORA con la IP 192.168.1.13

**¿Funcionó?** Dime si aparece en Home Assistant y vemos los sensores.


