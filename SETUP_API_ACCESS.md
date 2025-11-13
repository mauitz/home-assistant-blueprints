# 🚀 CONFIGURAR ACCESO API A HOME ASSISTANT

## 📝 Paso 1: Crear Token de Acceso

1. Abre Home Assistant: `http://192.168.1.100:8123/`
2. Inicia sesión con tu usuario (`nico`)
3. Haz click en tu perfil (abajo a la izquierda, donde dice "nico")
4. Scroll hasta **"Long-Lived Access Tokens"**
5. Click **"Create Token"**
6. Dale un nombre: `Blueprint Manager API`
7. **COPIA EL TOKEN** (solo se muestra una vez)

---

## ⚙️ Paso 2: Configurar Variables de Entorno

### **Opción A: Archivo .env (Recomendado)**

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints

# Crear archivo .env
cp .env.example .env

# Editar y pegar tu token
nano .env
```

Contenido de `.env`:
```bash
HA_URL=http://192.168.1.100:8123
HA_TOKEN=tu_token_aqui_pegado
```

### **Opción B: Variables de Shell**

```bash
export HA_URL="http://192.168.1.100:8123"
export HA_TOKEN="tu_token_aqui"
```

---

## 🐍 Paso 3: Instalar Dependencias

```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints

# Instalar requirements
pip3 install -r requirements.txt
```

---

## ✅ Paso 4: Probar Conexión

```bash
python3 ha_manager.py test
```

**Salida esperada:**
```
✅ Connected to Home Assistant
   URL: http://192.168.1.100:8123
   Message: API running
```

---

## 📊 Comandos Disponibles

### **1. Test de Conexión**
```bash
python3 ha_manager.py test
```

### **2. Reporte de Estado Completo**
```bash
python3 ha_manager.py status
```

Muestra:
- Estado de todos los helpers de monitoreo
- Estado de cada switch (encendido/apagado)
- Automatizaciones relacionadas con presence simulation

### **3. Diagnóstico del Sistema**
```bash
python3 ha_manager.py diagnose
```

Detecta:
- Si hay discrepancia entre switches encendidos y contador
- Si faltan automatizaciones de monitoreo
- Problemas de configuración

---

## 🔧 Uso desde Python

```python
from ha_manager import HAManager

# Crear instancia
manager = HAManager()

# Test
manager.test_connection()

# Ver estado completo
manager.print_status_report()

# Diagnóstico
manager.diagnose_monitoring_issue()

# Consultas específicas
status = manager.get_presence_simulation_status()
switches = manager.get_switches_status()
automations = manager.find_presence_automations()
```

---

## 🔒 Seguridad

⚠️ **IMPORTANTE**:

1. **NO SUBIR** el archivo `.env` a git (ya está en `.gitignore`)
2. **NO COMPARTIR** tu token de acceso
3. El token da **acceso completo** a tu Home Assistant

Si el token se compromete:
1. Ve a tu perfil en HA
2. Click en "Long-Lived Access Tokens"
3. **Revoke** el token comprometido
4. Crea uno nuevo

---

## 🚀 Próximos Pasos

Una vez configurado el acceso API, podremos:

1. **Ver estado en tiempo real** del sistema
2. **Detectar automáticamente** qué está instalado y qué falta
3. **Instalar automatizaciones** programáticamente
4. **Modificar configuraciones** sin editar archivos manualmente
5. **Crear scripts** para tareas comunes

---

## ❓ Troubleshooting

### Error: "HA_TOKEN not found"
- Verifica que el archivo `.env` existe
- Verifica que tiene el formato correcto
- Prueba con: `cat .env`

### Error: "Connection failed"
- Verifica que HA esté accesible: `curl http://192.168.1.100:8123`
- Verifica que estés en la misma red
- Verifica que el token sea correcto

### Error: "HTTP 401 Unauthorized"
- El token es inválido o expiró
- Crea un nuevo token en HA

---

**¿Listo para configurarlo?**

