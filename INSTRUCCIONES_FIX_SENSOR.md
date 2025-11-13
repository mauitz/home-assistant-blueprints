# 🔧 CÓMO CORREGIR EL ERROR DEL SENSOR EN HOME ASSISTANT

## 📍 UBICACIÓN DEL SENSOR CON ERROR

El sensor `sensor.presence_simulation_runtime` está definido en tu archivo:

```
/config/configuration.yaml
Líneas: 144-163
```

---

## ✏️ CAMBIO A REALIZAR

### **ANTES (❌ Con error):**

```yaml
      - name: "Presence Simulation Runtime"
        unique_id: presence_simulation_runtime
        icon: mdi:timer
        state: >
          {% if is_state('input_boolean.presence_simulation_running', 'on') %}
            {% set start_time = states('input_datetime.presence_simulation_start_time') %}
            {% if start_time not in ['unknown', 'unavailable', ''] %}
              {% set start = strptime(start_time, '%Y-%m-%d %H:%M:%S') %}
              {% set duration = now() - start %}
              {% set hours = duration.total_seconds() // 3600 %}
              {% set minutes = (duration.total_seconds() % 3600) // 60 %}
              {{ '%02d:%02d' | format(hours, minutes) }}
            {% else %}
              00:00
            {% endif %}
          {% else %}
            Inactiva
          {% endif %}
        attributes:
          friendly_name: "Tiempo Activo"
```

### **DESPUÉS (✅ Corregido):**

```yaml
      - name: "Presence Simulation Runtime"
        unique_id: presence_simulation_runtime
        icon: mdi:timer
        state: >
          {% if is_state('input_boolean.presence_simulation_running', 'on') %}
            {% set start_time = states('input_datetime.presence_simulation_start_time') %}
            {% if start_time not in ['unknown', 'unavailable', ''] %}
              {% set start_timestamp = as_timestamp(strptime(start_time, '%Y-%m-%d %H:%M:%S')) %}
              {% set current_timestamp = as_timestamp(now()) %}
              {% set duration_seconds = current_timestamp - start_timestamp %}
              {% set hours = (duration_seconds // 3600) | int %}
              {% set minutes = ((duration_seconds % 3600) // 60) | int %}
              {{ '%02d:%02d' | format(hours, minutes) }}
            {% else %}
              00:00
            {% endif %}
          {% else %}
            Inactiva
          {% endif %}
        attributes:
          friendly_name: "Tiempo Activo"
```

---

## 📝 CAMBIOS ESPECÍFICOS (líneas 151-154)

Reemplaza estas 4 líneas:

```yaml
              {% set start = strptime(start_time, '%Y-%m-%d %H:%M:%S') %}
              {% set duration = now() - start %}
              {% set hours = duration.total_seconds() // 3600 %}
              {% set minutes = (duration.total_seconds() % 3600) // 60 %}
```

Por estas 5 líneas:

```yaml
              {% set start_timestamp = as_timestamp(strptime(start_time, '%Y-%m-%d %H:%M:%S')) %}
              {% set current_timestamp = as_timestamp(now()) %}
              {% set duration_seconds = current_timestamp - start_timestamp %}
              {% set hours = (duration_seconds // 3600) | int %}
              {% set minutes = ((duration_seconds % 3600) // 60) | int %}
```

---

## 🚀 CÓMO APLICAR EL CAMBIO

### **Opción 1: Editor de archivos de Home Assistant** (Más fácil)

1. Instala el add-on **File Editor** (si no lo tienes):
   - Ve a **Configuración** → **Add-ons** → **Add-on Store**
   - Busca "File Editor"
   - Instala e inicia

2. Abre File Editor:
   - Click en el ícono de carpeta en la barra lateral
   
3. Edita el archivo:
   - Abre `/config/configuration.yaml`
   - Busca la línea 151 (o busca "Presence Simulation Runtime")
   - Reemplaza las 4 líneas como se indica arriba
   
4. Guarda el archivo

5. Valida la configuración:
   - Ve a **Developer Tools** → **YAML**
   - Click en **"Check Configuration"**
   - Debe decir "Configuration valid!"

6. Recarga templates:
   - **Developer Tools** → **YAML** → **Template Entities**
   - O reinicia Home Assistant

### **Opción 2: SSH o acceso directo**

Si tienes acceso SSH o SAMBA:

1. Edita el archivo `/config/configuration.yaml`
2. Busca el sensor (línea ~151)
3. Aplica los cambios
4. Guarda
5. Valida: `ha core check`
6. Recarga: **Developer Tools** → **YAML** → **Template Entities**

### **Opción 3: Studio Code Server** (Si lo tienes instalado)

1. Abre Studio Code Server
2. Navega a `configuration.yaml`
3. Busca "Presence Simulation Runtime" (Ctrl+F)
4. Reemplaza las líneas
5. Guarda
6. Valida y recarga

---

## ✅ VERIFICACIÓN

Después de aplicar el cambio y recargar:

1. Ve a **Developer Tools** → **States**
2. Busca `sensor.presence_simulation_runtime`
3. Debe mostrar un tiempo como "00:15" o "Inactiva"
4. **NO** debe haber errores en los logs

---

## 🎯 RESULTADO ESPERADO

- ✅ No más errores de `TemplateError` en los logs
- ✅ El sensor muestra correctamente el tiempo transcurrido
- ✅ El dashboard de monitoreo funciona sin errores

---

## ⚠️ IMPORTANTE

- Este cambio **NO** afecta al blueprint
- Solo corrige el sensor de monitoreo
- El blueprint seguirá funcionando igual
- Los logs del blueprint te dirán si las luces se encienden o no

---

## 🆘 SI TIENES DUDAS

Muéstrame:
1. Captura de los logs después de ejecutar la automatización
2. Estado actual de los switches
3. Configuración del blueprint en tu automatización


