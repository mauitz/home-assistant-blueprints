# 🔧 Corrección de Entidades - Sistema de Riego

## ❓ ¿Por qué el Widget NO puede estar dentro del Blueprint?

**Respuesta corta:** Son sistemas completamente diferentes en Home Assistant.

### **Blueprints de Automatizaciones:**
```yaml
blueprint:
  name: "Mi Blueprint"
  domain: automation  # ← Solo puede ser "automation" o "script"
  input: ...
trigger: ...
condition: ...
action: ...
```

- **Función:** Definen **lógica** (triggers, conditions, actions)
- **Dónde viven:** `config/blueprints/automation/`
- **Qué controlan:** Cuándo y cómo se ejecutan acciones
- **NO pueden:** Crear elementos visuales/UI

### **Widgets de Dashboard:**
```yaml
type: vertical-stack
cards:
  - type: entities
    entities: ...
```

- **Función:** Definen **interfaz visual** (cards, botones, gráficos)
- **Dónde viven:** En los dashboards de Home Assistant
- **Qué muestran:** Estado de entidades y controles visuales
- **NO pueden:** Definir automatizaciones

### **Son Independientes:**

```
Blueprint (Automatización)  ←→  Entidades  ←→  Widget (Dashboard)
        ↓                          ↓                    ↓
  Controla bombas          switch.bomba_z1a      Muestra botón
  según humedad            sensor.humedad_z1      Muestra gráfico
```

**Analogía:** Es como preguntarse "¿puedo poner un cuadro dentro de un reloj?". Son cosas diferentes:
- **Blueprint** = El reloj (funcionalidad/lógica)
- **Widget** = El cuadro (decoración/interfaz)

---

## 🔍 Problema: Nombres de Entidades Incorrectos

### **Nombres Incorrectos en el Widget Original:**

```yaml
❌ sensor.humedad_suelo_z1      # Sin prefijo
❌ sensor.nivel_tanque          # Sin prefijo
❌ switch.bomba_z1a             # Sin prefijo
❌ sensor.temperatura_ambiente  # Sin prefijo
```

### **Nombres Correctos (con prefijo del ESP32):**

```yaml
✅ sensor.riego_z1_humedad_suelo_z1
✅ sensor.riego_z1_nivel_tanque
✅ switch.riego_z1_bomba_z1a
✅ sensor.riego_z1_temperatura_ambiente
```

**¿Por qué?** Porque en el ESPHome configuraste:
```yaml
esphome:
  name: riego_z1  # ← Este es el prefijo de todas las entidades
```

---

## 📝 Lista Completa de Entidades

### **Sensores:**
```yaml
sensor.riego_z1_humedad_suelo_z1          # Humedad del suelo (%)
sensor.riego_z1_distancia_tanque_cm       # Distancia en cm
sensor.riego_z1_nivel_tanque              # Nivel del tanque (%)
sensor.riego_z1_temperatura_ambiente      # Temperatura (°C)
sensor.riego_z1_humedad_ambiente          # Humedad ambiente (%)
sensor.riego_z1_luz_ambiente_raw          # Luz raw (0-4095)
sensor.riego_z1_luz_ambiente              # Luz (%)
sensor.riego_z1_wifi_signal               # Señal WiFi (dBm)
```

### **Sensores LD2410C:**
```yaml
sensor.riego_z1_distancia_movimiento      # Distancia movimiento
sensor.riego_z1_distancia_quieto          # Distancia quieto
sensor.riego_z1_energia_movimiento        # Energía movimiento
sensor.riego_z1_energia_quieto            # Energía quieto
sensor.riego_z1_distancia_deteccion       # Distancia detección
# ... + sensores g0-g8 de energía
```

### **Switches (Bombas):**
```yaml
switch.riego_z1_bomba_z1a                 # Bomba Z1A
switch.riego_z1_bomba_z1b                 # Bomba Z1B
```

### **Lights (LEDs):**
```yaml
light.riego_z1_led_tanque_lleno           # LED tanque lleno
light.riego_z1_led_tanque_medio           # LED tanque medio
light.riego_z1_led_tanque_bajo            # LED tanque bajo
light.riego_z1_led_bomba_activa           # LED bomba activa
light.riego_z1_led_wifi                   # LED WiFi
```

### **Binary Sensors:**
```yaml
binary_sensor.riego_z1_presencia_detectada  # Presencia LD2410C
binary_sensor.riego_z1_objetivo_en_movimiento
binary_sensor.riego_z1_objetivo_quieto
binary_sensor.riego_z1_estado_pin_out
binary_sensor.riego_z1_ld2410c_out_digital
binary_sensor.riego_z1_estado_conexion     # Estado conexión
```

### **Buttons:**
```yaml
button.riego_z1_reiniciar_esp32            # Reiniciar ESP32
```

---

## 🔧 Cómo Corregir

### **Paso 1: Reemplazar el Widget**

1. **Borra el widget actual** de tu dashboard

2. **Copia el widget corregido:**
   - Archivo local: `dashboards/widgets/widget_riego_z1_corregido.yaml`
   - Este tiene TODOS los nombres correctos con prefijo `riego_z1_`

3. **Pégalo en tu dashboard**

### **Paso 2: Actualizar los Scripts**

1. **En Home Assistant**, abre tu archivo de scripts

2. **Reemplaza TODO el contenido** con:
   - Archivo local: `examples/scripts/riego_scripts.yaml`
   - Ya está corregido con los prefijos correctos

3. **Recarga scripts:**
   ```
   Herramientas → YAML → Scripts
   ```

### **Paso 3: Verificar Entidades**

1. Ve a **Configuración → Dispositivos**

2. Busca: `riego_z1`

3. Deberías ver todas las entidades listadas arriba

4. Si alguna no aparece, verifica el ESP32 esté encendido y conectado

---

## 🧪 Prueba Rápida

### **Verificar que todo funciona:**

1. **Ve a Herramientas → Estados**

2. **Busca:** `riego_z1`

3. **Deberías ver:**
   ```
   sensor.riego_z1_humedad_suelo_z1       33.8 %
   sensor.riego_z1_nivel_tanque           91 %
   switch.riego_z1_bomba_z1a              off
   switch.riego_z1_bomba_z1b              off
   ```

4. **Si ves valores**, ¡está funcionando! ✅

---

## 📋 Checklist de Corrección

- [ ] Widget reemplazado con `widget_riego_z1_corregido.yaml`
- [ ] Scripts actualizados con nombres correctos
- [ ] Scripts recargados en HA
- [ ] Entidades visibles en Configuración → Dispositivos
- [ ] Widget muestra valores reales (no "Entity not found")
- [ ] Botones de scripts funcionan

---

## 🆘 Si Sigue sin Funcionar

### **1. ESP32 no aparece en Dispositivos:**
```bash
# Ver logs del ESP32
esphome logs riego_z1.yaml
```

Verifica:
- ✅ ESP32 encendido
- ✅ Conectado al WiFi
- ✅ API key coincide

### **2. Entidades con "unavailable":**
- Espera 1-2 minutos (inicialización)
- Reinicia el ESP32 desde HA
- Verifica sensores físicamente conectados

### **3. Widget sigue mostrando "Entity not found":**
- Verifica que copiaste el widget **corregido**
- Busca las entidades manualmente en HA
- Compara nombres exactos (mayúsculas, guiones bajos)

---

## 📚 Resumen

### **Lo que aprendiste:**

1. ✅ **Blueprints ≠ Widgets** (son sistemas separados)
2. ✅ **Prefijos de entidades** dependen del nombre del dispositivo
3. ✅ **Todas las entidades** de tu ESP32 empiezan con `riego_z1_`
4. ✅ **Widgets y scripts** deben usar los nombres exactos

### **Archivos corregidos:**

```
dashboards/widgets/widget_riego_z1_corregido.yaml  ← Widget corregido
examples/scripts/riego_scripts.yaml                ← Scripts corregidos
```

---

**¡Con estos archivos el sistema debería funcionar perfectamente!** 🎉

