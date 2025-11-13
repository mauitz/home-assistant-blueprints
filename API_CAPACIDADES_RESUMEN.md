# 🔬 CAPACIDADES DE LA API DE HOME ASSISTANT

## 📊 Resumen Ejecutivo

La API REST de Home Assistant proporciona acceso **completo para lectura y control**, pero **limitado para edición**.

**Veredicto**: Perfecto para **monitoreo y control**, requiere interfaz web para **gestión**.

---

## ✅ LO QUE PUEDO HACER VÍA API

### **📖 LECTURA (GET)** - Acceso Completo

| Capacidad | Endpoint | Disponible |
|-----------|----------|------------|
| Ver todas las entidades | `GET /api/states` | ✅ |
| Ver entidad específica | `GET /api/states/{entity_id}` | ✅ |
| Ver servicios disponibles | `GET /api/services` | ✅ |
| Ver configuración de HA | `GET /api/config` | ✅ |
| Ver eventos del sistema | `GET /api/events` | ✅ |
| Ver historial de estados | `GET /api/history/period/{timestamp}` | ✅ |
| Ver logbook | `GET /api/logbook/{timestamp}` | ✅ |

**Datos que puedo obtener de automatizaciones**:
- ✅ Nombre y friendly_name
- ✅ Estado (on/off)
- ✅ Atributos (última ejecución, ID, etc.)
- ✅ Blueprint usado (path)
- ✅ Inputs configurados (nombres, no valores YAML)
- ✅ Última vez que se ejecutó

---

### **🎮 CONTROL (POST)** - Acceso Completo

| Capacidad | Endpoint | Disponible |
|-----------|----------|------------|
| Activar automatización | `POST /api/services/automation/turn_on` | ✅ |
| Desactivar automatización | `POST /api/services/automation/turn_off` | ✅ |
| Ejecutar manualmente | `POST /api/services/automation/trigger` | ✅ |
| Toggle on/off | `POST /api/services/automation/toggle` | ✅ |
| Recargar todas | `POST /api/services/automation/reload` | ✅ |
| Llamar cualquier servicio | `POST /api/services/{domain}/{service}` | ✅ |
| Disparar eventos | `POST /api/events/{event_type}` | ✅ |

**Ejemplo - Ejecutar automatización**:
```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "automation.presence_simulation"}' \
  http://192.168.1.100:8123/api/services/automation/trigger
```

---

## ❌ LO QUE **NO** PUEDO HACER VÍA API

### **✏️ EDICIÓN/GESTIÓN** - NO Disponible

| Operación | Disponible | Requiere |
|-----------|------------|----------|
| Crear automatización nueva | ❌ | Interfaz Web o SSH |
| Modificar configuración YAML | ❌ | Interfaz Web o SSH |
| Cambiar inputs del blueprint | ❌ | Interfaz Web |
| Eliminar automatización | ❌ | Interfaz Web |
| Ver código YAML completo | ❌ | SSH o File Editor |
| Editar condiciones/acciones | ❌ | Interfaz Web |
| **Re-importar blueprints** | ❌ | **Interfaz Web** |
| **Actualizar blueprints** | ❌ | **Interfaz Web** |
| Editar código de blueprints | ❌ | SSH o File Editor |
| Acceso a configuration.yaml | ❌ | SSH o File Editor |
| Acceso a automations.yaml | ❌ | SSH o File Editor |

---

## 🤖 AUTOMATIZACIONES - Qué Puedo Hacer

### ✅ **PUEDO**:

#### **1. Ver Todas las Automatizaciones**
```python
states = requests.get(f"{url}/api/states", headers=headers).json()
automations = [s for s in states if s['entity_id'].startswith('automation.')]
```

#### **2. Ver Detalles de una Automatización**
```python
auto = requests.get(f"{url}/api/states/automation.presence_simulation", 
                   headers=headers).json()

print(auto['state'])  # 'on' o 'off'
print(auto['attributes']['friendly_name'])  # Nombre
print(auto['attributes']['last_triggered'])  # Última ejecución
print(auto['attributes']['blueprint']['path'])  # Blueprint usado
```

#### **3. Controlar Automatizaciones**
```python
# Activar
requests.post(f"{url}/api/services/automation/turn_on",
             headers=headers,
             json={"entity_id": "automation.presence_simulation"})

# Desactivar
requests.post(f"{url}/api/services/automation/turn_off",
             headers=headers,
             json={"entity_id": "automation.presence_simulation"})

# Ejecutar manualmente
requests.post(f"{url}/api/services/automation/trigger",
             headers=headers,
             json={"entity_id": "automation.presence_simulation"})
```

#### **4. Monitorear en Tiempo Real**
- Ver cuándo se ejecutó por última vez
- Ver si está activada/desactivada
- Ver atributos actuales
- Detectar cambios de estado

---

### ❌ **NO PUEDO**:

1. **Crear** nueva automatización
2. **Modificar** configuración existente
3. **Ver** el código YAML completo
4. **Cambiar** inputs del blueprint
5. **Eliminar** automatización
6. **Re-importar** o actualizar blueprints

---

## 💡 CASOS DE USO PRÁCTICOS

### **Caso 1: Monitoreo y Control** ✅ **PERFECTO PARA API**

**Objetivo**: Dashboard personalizado para controlar automatizaciones

```python
# Ver estado
status = get_automation_status("automation.presence_simulation")

# Control
if status == 'off':
    turn_on_automation("automation.presence_simulation")

# Monitoreo
last_run = get_last_triggered("automation.presence_simulation")
```

**Resultado**: ✅ Completamente viable vía API

---

### **Caso 2: Configuración y Setup** ❌ **REQUIERE INTERFAZ WEB**

**Objetivo**: Crear automatización nueva o modificar configuración

```yaml
# Esto NO se puede hacer vía API:
use_blueprint:
  path: mauitz/pezaustral_presence_simulation.yaml
  input:
    enable_monitoring: true  # ← Cambiar esto requiere interfaz web
    lights_on:
      - switch.luz_1
      - switch.luz_2
```

**Resultado**: ❌ Requiere interfaz web o SSH

---

### **Caso 3: Verificación y Diagnóstico** ✅ **PERFECTO PARA API**

**Objetivo**: Verificar que el blueprint esté funcionando

```python
# Ver atributos
auto = get_automation("automation.presence_simulation")

# Verificar blueprint
blueprint_path = auto['attributes']['blueprint']['path']
if 'v1.3' in blueprint_path:
    print("✅ Usando blueprint actualizado")

# Verificar configuración
inputs = auto['attributes']['blueprint']['input'].keys()
if 'enable_monitoring' in inputs:
    print("✅ Monitoreo configurado")
```

**Resultado**: ✅ Completamente viable vía API

---

## 🛠️ HERRAMIENTAS DESARROLLADAS

### **1. `ha_manager.py`** - Manager Principal

```python
from ha_manager import HAManager

manager = HAManager()

# Test conexión
manager.test_connection()

# Ver estado completo
manager.print_status_report()

# Diagnosticar problemas
manager.diagnose_monitoring_issue()

# Obtener datos específicos
status = manager.get_presence_simulation_status()
switches = manager.get_switches_status()
automations = manager.find_presence_automations()
```

### **2. `test_api_capabilities.py`** - Explorador de API

```bash
python3 test_api_capabilities.py
```

Muestra:
- ✅ Qué puedes hacer
- ❌ Qué no puedes hacer
- 📊 Estadísticas del sistema

### **3. `verify_installation.py`** - Verificador

```bash
python3 verify_installation.py
```

Verifica:
- ✅ Helpers configurados
- ✅ Switches funcionando
- ✅ Monitoreo en tiempo real
- ✅ Consistencia de datos

---

## 📖 DOCUMENTACIÓN OFICIAL

**Home Assistant REST API**:
- https://developers.home-assistant.io/docs/api/rest/

**Endpoints principales**:
- `/api/` - Info de la API
- `/api/states` - Estados de entidades
- `/api/services` - Servicios disponibles
- `/api/services/{domain}/{service}` - Llamar servicio
- `/api/config` - Configuración de HA
- `/api/events` - Eventos del sistema

---

## 🎯 RESUMEN FINAL

| Operación | Disponibilidad | Herramienta |
|-----------|----------------|-------------|
| **Lectura** | ✅ 100% | API REST |
| **Control** | ✅ 100% | API REST |
| **Monitoreo** | ✅ 100% | API REST |
| **Edición** | ❌ 0% | Interfaz Web |
| **Creación** | ❌ 0% | Interfaz Web |
| **Blueprints** | ❌ 0% | Interfaz Web |

---

## 💼 RECOMENDACIONES

### **Para Desarrollo**:
1. **Monitoreo y control** → Usar API REST ✅
2. **Dashboards personalizados** → Usar API REST ✅
3. **Automatización de tareas** → Usar API REST ✅

### **Para Gestión**:
1. **Configuración inicial** → Usar Interfaz Web ⚠️
2. **Editar automatizaciones** → Usar Interfaz Web ⚠️
3. **Actualizar blueprints** → Usar Interfaz Web ⚠️

### **Para Mantenimiento**:
1. **Monitoreo** → `ha_manager.py status` ✅
2. **Diagnóstico** → `ha_manager.py diagnose` ✅
3. **Verificación** → `verify_installation.py` ✅

---

**La API es PERFECTA para lo que necesitamos: monitoreo, control y diagnóstico en tiempo real.** ✨

