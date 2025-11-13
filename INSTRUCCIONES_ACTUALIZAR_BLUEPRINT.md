# 🚀 ACTUALIZAR BLUEPRINT v1.3 EN HOME ASSISTANT

## ✅ PASO 1 COMPLETADO: Blueprint Actualizado en GitHub

El blueprint **ya está actualizado** en GitHub:
- Archivo: `blueprints/pezaustral_presence_simulation.yaml`
- Versión: **v1.3 con monitoreo integrado**
- URL: https://github.com/mauitz/home-assistant-blueprints/blob/main/blueprints/pezaustral_presence_simulation.yaml

---

## 🔄 PASO 2: Actualizar Blueprint en Home Assistant

Como el blueprint está importado desde GitHub, Home Assistant necesita **re-importarlo** para obtener la nueva versión.

### **Opción A: Re-importar desde la Interfaz** (Recomendado) ⚡

1. **Abre Home Assistant**:
   ```
   http://192.168.1.100:8123
   ```

2. **Ve a Configuración**:
   - Click en "⚙️ Configuration" (Configuración)
   - Click en "📋 Blueprints"

3. **Encuentra el Blueprint**:
   - Busca "PezAustral Presence Simulation"
   - Verás que dice "v1.2" o similar

4. **Re-importar**:
   - Click en el blueprint
   - Click en "⋮" (menú de opciones)
   - Click en **"Re-import blueprint"** o **"Actualizar desde origen"**
   - Home Assistant descargará la nueva versión desde GitHub

5. **Verificar**:
   - El blueprint debería mostrar ahora: **"PezAustral Presence Simulation v1.3"**
   - En la descripción verás: "**MONITOREO INTEGRADO**"

---

### **Opción B: Eliminar y Re-importar** (Si Opción A no funciona)

1. **Eliminar blueprint actual**:
   - Configuration → Blueprints
   - Click en "PezAustral Presence Simulation"
   - Click en "⋮" → "Delete"
   - **NOTA**: Esto NO eliminará tu automatización, solo el blueprint

2. **Re-importar desde GitHub**:
   - Configuration → Blueprints
   - Click en "+ IMPORT BLUEPRINT"
   - Pega la URL:
     ```
     https://github.com/mauitz/home-assistant-blueprints/blob/main/blueprints/pezaustral_presence_simulation.yaml
     ```
   - Click en "Preview"
   - Click en "Import Blueprint"

3. **Verificar**:
   - Debería aparecer "PezAustral Presence Simulation v1.3"

---

## 🔧 PASO 3: Actualizar tu Automatización

Una vez que el blueprint esté actualizado:

1. **Edita tu automatización**:
   - Configuration → Automations
   - Encuentra "Presence Simulation"
   - Click en "Edit"

2. **Agregar nuevo parámetro** (en modo YAML):
   - Click en "⋮" → "Edit in YAML"
   - Busca la sección `input:`
   - **Agrega al INICIO**:

   ```yaml
   use_blueprint:
     path: mauitz/pezaustral_presence_simulation.yaml
     input:
       enable_monitoring: true  # ← NUEVO EN V1.3

       # ... resto de tus inputs (no cambiar)
       automation_control_entity:
         - input_boolean.presence_simulation
       # etc...
   ```

3. **Guarda**:
   - Click en "Save"
   - La automatización se recargará con el nuevo blueprint

---

## 🧹 PASO 4 (OPCIONAL): Limpiar Automatizaciones Redundantes

Con v1.3, estas automatizaciones **ya NO son necesarias** (el monitoreo está integrado):

- ❌ "Presence Sim - Iniciar Monitoring"
- ❌ "Presence Sim - Detener Monitoring"
- ❌ "Presence Sim - Monitorear Switches"
- ❌ "Presence Sim - Actualizar Runtime"
- ❌ "Presence Sim - Parada de Emergencia"

**Puedes eliminarlas**:
1. Configuration → Automations
2. Selecciona cada automatización
3. Click en "⋮" → "Delete"

**IMPORTANTE**: Haz esto **DESPUÉS** de verificar que v1.3 funciona correctamente.

---

## ✅ PASO 5: Verificar Funcionamiento

### **Opción A: Prueba Manual**

1. **Activa la simulación**:
   - Enciende `input_boolean.presence_simulation`

2. **Observa el dashboard**:
   - El contador "Luces ON" debe actualizarse **inmediatamente**
   - "Luces Activas" debe mostrar los nombres de las luces
   - "Última Encendida" y "Última Apagada" deben actualizarse

3. **Si funciona correctamente**:
   - ✅ El monitoreo integrado está funcionando
   - ✅ Puedes eliminar las automatizaciones redundantes

### **Opción B: Verificación con Script**

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
python3 verify_installation.py
```

El script verificará:
- ✅ Que todos los helpers existan
- ✅ Que los switches se actualicen correctamente
- ✅ Que el contador sea consistente
- ✅ Que esté usando blueprint v1.3

---

## 🔍 TROUBLESHOOTING

### **El blueprint no se actualiza**

**Problema**: Después de re-importar, sigue mostrando v1.2

**Solución**:
1. Ve a Configuration → Blueprints
2. Click en el blueprint
3. Verifica que la **URL sea correcta**:
   ```
   https://github.com/mauitz/home-assistant-blueprints/blob/main/blueprints/pezaustral_presence_simulation.yaml
   ```
4. Si la URL es diferente, elimina el blueprint y re-impórtalo con la URL correcta

---

### **El contador sigue en 0**

**Problema**: Las luces se encienden pero el contador no se actualiza

**Posibles causas**:

1. **`enable_monitoring` está en `false`**:
   - Edita la automatización
   - Asegúrate que `enable_monitoring: true`

2. **Blueprint no actualizado**:
   - Verifica que diga "v1.3" en Configuration → Blueprints
   - Si dice "v1.2", repite el paso de re-importar

3. **Helpers no existen**:
   ```bash
   python3 ha_manager.py status
   ```
   - Verifica que todos los helpers estén disponibles
   - Si faltan, agrégalos desde `examples/presence_simulation_helpers.yaml`

---

### **Error al re-importar**

**Problema**: "Failed to import blueprint"

**Solución**:
1. Verifica que tengas conexión a internet
2. Verifica que GitHub esté accesible
3. Intenta con la Opción B (Eliminar y Re-importar)

---

## 📊 COMPARACIÓN: Antes vs Después

### **Antes (v1.2)**
```
Blueprint v1.2
  ↓
Enciende/apaga luces ✓
  ↓
❌ NO actualiza contadores
  ↓
5 automatizaciones de monitoreo
  ↓
Actualizan contadores (con delay)
```

### **Después (v1.3)**
```
Blueprint v1.3
  ↓
Enciende/apaga luces ✓
  ↓
✅ Actualiza contadores INMEDIATAMENTE
  ↓
Dashboard en tiempo real
```

**Resultado**:
- ✅ 5 automatizaciones menos
- ✅ Sin delays
- ✅ Siempre sincronizado
- ✅ Más fácil de mantener

---

## 🆘 ¿NECESITAS AYUDA?

Si encuentras problemas:

1. **Verifica el estado**:
   ```bash
   python3 ha_manager.py diagnose
   ```

2. **Ve los logs de Home Assistant**:
   - Settings → System → Logs
   - Busca errores relacionados con "presence_simulation"

3. **Revisa la documentación**:
   - `CHANGELOG_V1.3.md` - Detalles de cambios
   - `RESUMEN_IMPLEMENTACION.md` - Guía completa

---

**¡El blueprint v1.3 está listo en GitHub!**
Ahora solo falta re-importarlo en Home Assistant. 🚀

