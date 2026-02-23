# LightNode - Guía de Instalación ESPHome

## 🎯 Requisitos Previos

### Hardware
- ✅ LightNode montado y soldado
- ✅ ESP32 conectado a la computadora vía USB
- ✅ Todos los componentes instalados según el diseño

### Software
- ✅ Python 3.8 o superior
- ✅ ESPHome instalado
- ✅ Home Assistant funcionando (opcional para primera instalación)

---

## 📦 PASO 1: Instalar ESPHome

### En macOS/Linux:
```bash
pip3 install esphome
```

### Verificar instalación:
```bash
esphome version
```

Deberías ver algo como: `Version: 2024.x.x`

---

## 🔐 PASO 2: Configurar Secrets

### Crear archivo de secretos:
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
cp secrets.yaml.example secrets.yaml
```

### Editar `secrets.yaml`:
```yaml
# WiFi de tu casa
wifi_ssid: "TuRedWiFi"
wifi_password: "TuContraseña"

# API key (se genera automáticamente en el primer compile)
api_key: ""  # Déjalo vacío por ahora

# Contraseña OTA
ota_password: "lightnode2026"
```

---

## 🚀 PASO 3: Primera Compilación y Flash

### Compilar y flashear por USB:
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
esphome run lightnode_pasillo.yaml
```

### Durante el proceso:
1. ESPHome compilará el firmware (puede tomar 2-5 minutos)
2. Te preguntará cómo quieres flashear:
   ```
   How do you want to upload the firmware?
   [0] /dev/cu.usbserial-XXXX (USB)
   [1] Over The Air (lightnode-pasillo.local)
   ```
3. **Selecciona [0]** para el primer flash (USB)

### Si hay múltiples puertos USB:
Identifica el correcto con:
```bash
ls -la /dev/cu.*
```

Busca algo como:
- `/dev/cu.usbserial-0001`
- `/dev/cu.SLAB_USBtoUART`
- `/dev/cu.usbserial-XXXX`

---

## 📡 PASO 4: Verificar Conexión WiFi

### Monitorear logs en tiempo real:
```bash
esphome logs lightnode_pasillo.yaml
```

### Deberías ver:
```
[I][wifi:xxx]: WiFi connected!
[I][wifi:xxx]: IP Address: 192.168.X.XXX
[I][api:xxx]: Connected to MQTT
```

### Si NO conecta al WiFi:
1. El ESP32 creará un AP de fallback
2. Red: **"LightNode Pasillo Fallback"**
3. Contraseña: **"lightnode123"**
4. Conéctate y accede a: `http://192.168.4.1`
5. Configura tu WiFi desde el portal web

---

## 🏠 PASO 5: Agregar a Home Assistant

### Opción A: Auto-descubrimiento (recomendado)
1. Ve a Home Assistant
2. **Configuración** → **Dispositivos y servicios**
3. Deberías ver: **"ESPHome: lightnode-pasillo descubierto"**
4. Haz clic en **"CONFIGURAR"**
5. Ingresa la API key cuando se solicite (aparece en los logs)

### Opción B: Agregar manualmente
1. **Configuración** → **Dispositivos y servicios** → **"+ AGREGAR INTEGRACIÓN"**
2. Busca: **"ESPHome"**
3. Host: `lightnode-pasillo.local` o la IP que viste en los logs
4. Puerto: `6053`
5. API key: (copia de los logs o deja vacío si aún no se generó)

---

## 🧪 PASO 6: Pruebas Básicas

### 1. Verificar sensores en Home Assistant
Ve a **Dispositivos** y busca **"LightNode Pasillo"**

Deberías ver:
- ✅ Presencia Pasillo (binary_sensor)
- ✅ Luz Ambiente (sensor)
- ✅ LED Pasillo Izquierda (light)
- ✅ LED Pasillo Derecha (light)
- ✅ Umbral Luz (number)
- ✅ Timeout Apagado (number)

### 2. Probar LEDs manualmente
En Home Assistant:
1. Busca **"LED Pasillo Izquierda"**
2. Enciéndela → debería iluminar la guirnalda izquierda
3. Ajusta el brillo con el slider
4. Repite con la derecha

### 3. Probar sensor de presencia
1. Observa el sensor **"Presencia Pasillo"**
2. Muévete frente al LD2410C
3. Debería cambiar a **"Detectado"**
4. Espera 5 segundos sin moverte
5. Debería cambiar a **"Despejado"**

### 4. Probar LDR
1. Observa el sensor **"Luz Ambiente"**
2. Debería mostrar un valor entre 0-100%
3. Cubre el LDR con la mano → valor baja
4. Apunta una linterna → valor sube

### 5. Probar automatización completa
1. Ajusta **"Umbral Luz"** a 50%
2. Cubre el LDR (simular oscuridad)
3. Muévete frente al sensor
4. Las luces deberían encenderse automáticamente ✨
5. Aléjate y espera 30 segundos
6. Las luces deberían apagarse

---

## 🔧 Troubleshooting

### ESP32 no aparece en puertos USB
```bash
# Verificar conexión
ls -la /dev/cu.* | grep usb

# Si no aparece, instalar driver CH340 o CP2102
# macOS: https://github.com/adrianmihalko/ch340g-ch34g-ch34x-mac-os-x-driver
```

### Error: "Failed to connect"
```bash
# Verificar que el ESP32 está en modo bootloader
# Mantén presionado el botón BOOT mientras conectas el USB
```

### WiFi no conecta
1. Verifica SSID y contraseña en `secrets.yaml`
2. Asegúrate de que el ESP32 está cerca del router
3. Usa WiFi 2.4GHz (NO 5GHz)
4. Conéctate al AP de fallback y configura desde ahí

### LEDs no encienden
1. Verifica polaridad de las guirnaldas (rojo=+5V)
2. Verifica que los transistores están bien conectados
3. Mide voltaje en colector del BC337 (debería tener ~4.3V con LED on)
4. Revisa conexiones de las resistencias de base (1kΩ)

### LD2410C no detecta presencia
1. Verifica conexiones TX/RX (deben estar cruzadas)
2. TX del LD2410C → GPIO 32 (RX del ESP32)
3. RX del LD2410C → GPIO 33 (TX del ESP32)
4. Verifica alimentación 3.3V (NO 5V)
5. Revisa logs: `esphome logs lightnode_pasillo.yaml`

### LDR siempre muestra 0% o 100%
1. Verifica conexión a GPIO 34
2. Verifica resistencia pull-down de 10kΩ
3. Prueba cubrir/descubrir el LDR
4. Revisa logs para ver voltaje crudo

---

## 🔄 Actualizaciones Futuras (OTA)

Una vez que el ESP32 está en WiFi, puedes actualizar sin USB:

```bash
esphome run lightnode_pasillo.yaml
```

Selecciona: **[1] Over The Air**

---

## 📊 Monitoreo en Tiempo Real

### Ver logs continuamente:
```bash
esphome logs lightnode_pasillo.yaml
```

### Ver solo errores:
```bash
esphome logs lightnode_pasillo.yaml | grep -i error
```

### Ver activaciones de presencia:
```bash
esphome logs lightnode_pasillo.yaml | grep -i "presencia"
```

---

## ⚙️ Configuración Avanzada

### Ajustar sensibilidad del LD2410C
Desde Home Assistant, puedes ver sensores adicionales:
- Distancia de detección
- Energía de movimiento
- Energía estático

Para ajustar rangos, modifica en el YAML:
```yaml
ld2410:
  timeout: 5s
  max_move_distance: 6m    # Aumenta para más alcance
  max_still_distance: 4m   # Aumenta para detectar personas quietas
```

### Ajustar comportamiento de las luces
Desde Home Assistant:
- **Umbral Luz**: A qué nivel de oscuridad activar (0-100%)
- **Timeout Apagado**: Cuántos segundos esperar sin presencia (5-300s)

### Deshabilitar automatización temporalmente
Usa el switch **"Automatización Activada"** en Home Assistant

---

## 📝 Archivos de Configuración

### Ubicación:
```
esphome/
├── lightnode_pasillo.yaml    ← Configuración principal
├── secrets.yaml               ← Credenciales (no subir a git)
└── secrets.yaml.example       ← Plantilla de ejemplo
```

### Backup automático:
ESPHome guarda backups en:
```
.esphome/build/lightnode-pasillo/
```

---

## 🎓 Próximos Pasos

1. ✅ Verificar funcionamiento básico
2. ✅ Ajustar umbrales según tu espacio
3. ✅ Crear automatizaciones adicionales en Home Assistant
4. ✅ Integrar con otras luces/escenas
5. ✅ Documentar configuración final

---

## 📚 Recursos Útiles

- [ESPHome Documentation](https://esphome.io/)
- [LD2410 Component](https://esphome.io/components/sensor/ld2410.html)
- [Home Assistant ESPHome Integration](https://www.home-assistant.io/integrations/esphome/)
- Proyecto LightNode: `/docs/lightnode/`

---

**¡Felicitaciones! Tu LightNode está funcionando** 🎉

**Versión**: 1.0  
**Fecha**: 2026-01-20  
**Hardware**: LightNode v1.3
