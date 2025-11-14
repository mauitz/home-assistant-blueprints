# 🔄 ACTUALIZAR AUTOMATIZACIONES EN EL SERVIDOR

## 📋 **RESUMEN DE CAMBIOS**

Se han modificado las automatizaciones para que **TODAS** las detecciones (personas + vehículos) sean **críticas** con acceso directo al clip en Frigate.

### ✅ **Cambios Aplicados:**

**Antes:**
- 🚨 Personas → Crítica + Sirena
- 🚗 Vehículos → Normal + Sin sirena

**Ahora:**
- 🚨 Personas → **Crítica + Sirena + Ver Clip**
- 🚗 Vehículos → **Crítica + Sirena + Ver Clip**

---

## 🚀 **ACTUALIZAR EN EL SERVIDOR**

### **Opción 1: Copiar Archivo Completo (RECOMENDADO)**

```bash
# 1. Copiar automations.yaml actualizado al servidor
scp HA_config_proxy/automations.yaml nico@192.168.1.100:/tmp/automations_new.yaml

# 2. SSH al servidor
ssh nico@192.168.1.100

# 3. Backup del archivo actual
sudo cp /opt/server/containers/homeassistant/config/automations.yaml \
        /opt/server/containers/homeassistant/config/automations.yaml.backup

# 4. Reemplazar con el nuevo
sudo mv /tmp/automations_new.yaml \
        /opt/server/containers/homeassistant/config/automations.yaml

# 5. Ajustar permisos
sudo chown ${USER}:${USER} /opt/server/containers/homeassistant/config/automations.yaml

# 6. Reiniciar Home Assistant
docker restart homeassistant

# 7. Ver logs (opcional)
docker logs -f homeassistant
```

---

### **Opción 2: Editar Manualmente en el Servidor**

Si prefieres editar manualmente, aquí están los cambios:

```bash
ssh nico@192.168.1.100
sudo nano /opt/server/containers/homeassistant/config/automations.yaml
```

**Buscar y reemplazar 4 secciones:**

#### **1. Entrada - Persona (línea ~363)**

**Agregar después de `image:`:**
```yaml
          actions:
            - action: "URI"
              title: "Ver Clip"
              uri: "http://192.168.1.100:5000/events?camera=entrada&label=person"
```

#### **2. Entrada - Vehículo (línea ~420)**

**Cambiar descripción:**
```yaml
  description: >
    Detecta vehículos (car, truck, motorcycle) en la entrada.
    Notificación CRÍTICA con acceso al clip.
```

**Cambiar notificación (línea ~450):**
```yaml
    # Notificación CRÍTICA con clip
    - service: notify.mobile_app_blacky
      data:
        title: "🚗 VEHÍCULO en Entrada"
        message: "Detectado a las {{ now().strftime('%H:%M') }}"
        data:
          push:
            interruption-level: critical  # ← Cambiar de 'active' a 'critical'
            sound: alarm.caf              # ← Agregar esta línea
          tag: "frigate_entrada_vehicle"
          image: "http://192.168.1.100:5000/api/entrada/car/snapshot.jpg"
          actions:                        # ← Agregar todo esto
            - action: "URI"
              title: "Ver Clip"
              uri: "http://192.168.1.100:5000/events?camera=entrada&label=car"

    # Activar sirena (5 segundos)  ← Agregar estas líneas
    - service: siren.turn_on
      target:
        entity_id: siren.tapo_c530ws_entrada_siren
      data:
        duration: 5

    # Encender floodlight
    - service: light.turn_on
      target:
        entity_id: light.tapo_c530ws_entrada_floodlight_timed
      data:
        brightness: 255                  # ← Cambiar de 180 a 255

    - delay:
        seconds: 10

    - service: siren.turn_off           # ← Agregar estas líneas
      target:
        entity_id: siren.tapo_c530ws_entrada_siren
```

#### **3. Exterior - Persona (línea ~534)**

**Agregar después de `image:`:**
```yaml
          actions:
            - action: "URI"
              title: "Ver Clip"
              uri: "http://192.168.1.100:5000/events?camera=exterior&label=person"
```

#### **4. Exterior - Vehículo (línea ~580)**

**Mismo cambio que Entrada - Vehículo:**
```yaml
  description: >
    Detecta vehículos en el exterior.
    Notificación CRÍTICA con acceso al clip.

    # Notificación CRÍTICA con clip
    - service: notify.mobile_app_blacky
      data:
        title: "🚗 VEHÍCULO en Exterior"
        message: "Detectado a las {{ now().strftime('%H:%M') }}"
        data:
          push:
            interruption-level: critical  # ← Cambiar
            sound: alarm.caf              # ← Agregar
          tag: "frigate_exterior_vehicle"
          image: "http://192.168.1.100:5000/api/exterior/car/snapshot.jpg"
          actions:
            - action: "URI"
              title: "Ver Clip"
              uri: "http://192.168.1.100:5000/events?camera=exterior&label=car"

    # Activar sirena (5 segundos)
    - service: siren.turn_on
      target:
        entity_id: siren.tapo_c310_exterior_siren
      data:
        duration: 5

    # Encender floodlight
    - service: light.turn_on
      target:
        entity_id: light.tapo_c310_exterior_floodlight_timed
      data:
        brightness: 255  # ← Cambiar

    - delay:
        seconds: 10

    - service: siren.turn_off
      target:
        entity_id: siren.tapo_c310_exterior_siren
```

**Guardar:** `Ctrl+O`, `Enter`, `Ctrl+X`

**Reiniciar Home Assistant:**
```bash
docker restart homeassistant
```

---

## ✅ **VERIFICACIÓN**

Después de reiniciar Home Assistant:

### **1. Verificar que las automatizaciones están activas:**

```bash
# En el servidor o vía API
curl -H "Authorization: Bearer TU_TOKEN" \
     http://192.168.1.100:8123/api/states/automation.frigate_entrada_vehiculo | jq .
```

### **2. Probar notificación:**

- Pasar frente a cualquier cámara
- Deberías recibir notificación **CRÍTICA** con sirena
- La notificación debe tener botón **"Ver Clip"**
- Al hacer click, debe abrir Frigate UI con el evento

### **3. Verificar logs de Frigate:**

```bash
docker logs frigate --tail=50 | grep -E "person|car|WARN|ERROR"
```

---

## 🎯 **RESUMEN DE MEJORAS**

| Característica | Antes | Ahora |
|----------------|-------|-------|
| **Personas** | Crítica + Sirena | Crítica + Sirena + Ver Clip |
| **Vehículos** | Normal sin sirena | Crítica + Sirena + Ver Clip |
| **Floodlight** | 180/255 brillo | 255 brillo (todas) |
| **Botón Ver Clip** | ❌ No | ✅ Sí (todas) |
| **Sirena** | Solo personas | Todas las detecciones |

---

## 📞 **SOPORTE**

Si algo no funciona:

1. Verificar logs de Home Assistant: `docker logs homeassistant --tail=100`
2. Verificar logs de Frigate: `docker logs frigate --tail=100`
3. Verificar que los binary sensors están disponibles: Herramientas de desarrollador → Estados
4. Probar manualmente: Configuración → Automatizaciones → Ejecutar

---

**Fecha:** 2025-11-14
**Versión:** V3.3.1 (Todas críticas)

