# 🌱 ESPHome - Sistema de Riego Automático

Este directorio contiene las configuraciones de ESPHome para el sistema de riego automático.

## 📁 Archivos

- **`riego_z1.yaml`**: Configuración principal para Zona 1 (2 bombas + 1 sensor)
- **`secrets.yaml`**: Archivo de secretos (contraseñas, claves API)

## 🚀 Instalación y Flasheo

### Requisitos previos

1. **Python 3.8+** instalado
2. **Cable USB** para conectar el ESP32
3. **Driver CP2102/CH340** (para comunicación USB con ESP32)

### Paso 1: Instalar ESPHome

```bash
# Opción 1: Con pip (recomendado)
pip3 install esphome

# Opción 2: Con Home Assistant (si ya lo usas)
# ESPHome puede instalarse como Add-on en HA
```

### Paso 2: Compilar el firmware

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
esphome compile riego_z1.yaml
```

### Paso 3: Flashear el ESP32 (primera vez - por USB)

**IMPORTANTE**: La primera vez debe ser por USB. Luego podrás actualizar por WiFi (OTA).

```bash
# Conecta el ESP32 al puerto USB
# Ejecuta:
esphome run riego_z1.yaml

# O especifica el puerto manualmente:
esphome run riego_z1.yaml --device /dev/cu.usbserial-0001
# (Ajusta el puerto según tu sistema)
```

### Paso 4: Verificar logs en tiempo real

```bash
esphome logs riego_z1.yaml
```

## 🔧 Calibración necesaria

### 1. Sensor de Humedad (GPIO34)
- **Método**: Medir en aire seco y en agua
- **Ubicación en YAML**: Líneas 37-40 (calibrate_linear)
- Ajustar valores según lecturas reales

### 2. Nivel del Tanque (HC-SR04)
- **Método**: Medir altura total del tanque
- **Ubicación en YAML**: Línea 68 (`altura_tanque`)
- Ajustar valor en centímetros

### 3. Sensor de Luz (LDR)
- Generalmente no requiere calibración
- Si es necesario, ajustar en líneas 106-111

## 📊 Entidades en Home Assistant

Una vez conectado, verás estas entidades en HA:

### Sensores
- `sensor.humedad_suelo_z1` - Humedad del suelo (%)
- `sensor.distancia_tanque_cm` - Distancia al agua (cm)
- `sensor.nivel_tanque` - Nivel del tanque (%)
- `sensor.temperatura_ambiente` - Temperatura (°C)
- `sensor.humedad_ambiente` - Humedad relativa (%)
- `sensor.luz_ambiente` - Luz ambiente (%)
- `sensor.wifi_signal` - Señal WiFi (dBm)

### Switches (Bombas)
- `switch.bomba_z1a` - Bomba Zona 1A
- `switch.bomba_z1b` - Bomba Zona 1B

### Luces (LEDs)
- `light.led_tanque_lleno` - LED verde
- `light.led_tanque_medio` - LED amarillo
- `light.led_tanque_bajo` - LED rojo
- `light.led_bomba_activa` - LED azul
- `light.led_wifi` - LED blanco

### Botones
- `button.reiniciar_esp32` - Reiniciar dispositivo

## 🔍 Troubleshooting

### El ESP32 no conecta a WiFi
1. Verifica SSID y password en `riego_z1.yaml`
2. El ESP32 **solo soporta WiFi 2.4GHz** (no 5GHz)
3. Busca la red `riego_z1_fallback` para conectar directamente

### No aparece en Home Assistant
1. Verifica que HA tiene la integración ESPHome instalada
2. Ve a **Configuración → Integraciones → Agregar Integración → ESPHome**
3. Ingresa la IP del ESP32 (revisa en tu router o en los logs)

### Los sensores muestran valores extraños
- **Humedad suelo**: Requiere calibración (ver arriba)
- **Nivel tanque**: Ajusta `altura_tanque` en el YAML
- **DHT11**: Si muestra NaN, revisa conexión del pin DATA

### Los relés no activan
1. Verifica alimentación del módulo de relés (5V)
2. Comprueba conexión de pines IN1 (GPIO23) e IN2 (GPIO22)
3. Si están invertidos, cambia `inverted: true` en el YAML

## 📝 Próximos pasos

- [ ] Flashear ESP32
- [ ] Verificar sensores en HA
- [ ] Calibrar sensor de humedad
- [ ] Ajustar altura del tanque
- [ ] Probar bombas sin carga
- [ ] Validar Zona 1 completamente
- [ ] Expandir a Zonas 2, 3 y 4
- [ ] Crear automatizaciones en HA
- [ ] Diseñar dashboard de riego

## 📚 Recursos

- [Documentación ESPHome](https://esphome.io/)
- [GPIO ESP32 Pinout](https://randomnerdtutorials.com/esp32-pinout-reference-gpios/)
- [Sensor HC-SR04](https://esphome.io/components/sensor/ultrasonic.html)
- [Sensor DHT11](https://esphome.io/components/sensor/dht.html)


