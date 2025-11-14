# 📹 Sistema de Alertas de Cámaras V2

Sistema dinámico que agranda automáticamente las cámaras cuando detectan movimiento o personas.

---

## ✨ Características

- **Alertas visuales**: Cámara se agranda cuando detecta movimiento
- **Animaciones**: Borde rojo pulsante y badge "🚨 DETECCIÓN ACTIVA"
- **Auto-reset**: Vuelve al tamaño normal después de 30 segundos
- **Aspect ratio dinámico**: 16:9 normal → 21:9 agrandado

---

## 📦 Instalación

### 1. Agregar Helpers

Edita `configuration.yaml` y agrega:

```yaml
input_text:
  camera_alert_active:
    name: Cámara con Alerta Activa
    initial: "none"
    icon: mdi:cctv

  camera_alert_timestamp:
    name: Timestamp de Última Alerta
    initial: "0"
    icon: mdi:clock-outline
```

O incluye el archivo:

```yaml
input_text: !include camera_alert_helpers.yaml
```

### 2. Agregar Automatizaciones

Copia `examples/camera_alert_automations.yaml` a tu configuración:

```yaml
automation: !include automations.yaml
```

Y agrega el contenido de `camera_alert_automations.yaml` a `automations.yaml`.

### 3. Actualizar Dashboard

Copia el contenido de `dashboards/maui_dashboard.yaml` al dashboard "maui" en Home Assistant.

### 4. Reiniciar Home Assistant

```bash
# En el servidor HA
ha core restart
```

O desde la UI: **Configuración** → **Sistema** → **Reiniciar**

---

## 🔧 Configuración de Triggers

Las automatizaciones están configuradas para escuchar:

### Opción A: Webhooks (Recomendado)

Si tus cámaras Tapo soportan webhooks:

1. **Configurar webhook en HA**:
   - URL: `http://TU_HA_IP:8123/api/webhook/tapo_c530ws_entrada_motion`
   - Método: POST

2. **Configurar en app Tapo**:
   - Ir a Configuración de Cámara
   - Notificaciones → Webhook
   - Agregar URL del webhook

### Opción B: Estado de Cámara

Las automatizaciones también escuchan cambios de estado:
- `camera.tapo_c530ws_entrada_live_view`: `idle` → `recording`
- `camera.tapo_c310_exterior_live_view`: `idle` → `recording`

### Opción C: Integración Personalizada

Si tienes sensores de movimiento de las cámaras:

```yaml
- platform: state
  entity_id: binary_sensor.tapo_c530ws_entrada_motion
  from: 'off'
  to: 'on'
```

---

## 🧪 Prueba Manual

Para probar el sistema manualmente:

### 1. Activar Alerta de Entrada

En **Herramientas para desarrolladores** → **Servicios**:

```yaml
service: input_text.set_value
data:
  entity_id: input_text.camera_alert_active
  value: "entrada"
```

La cámara de entrada debería agrandarse con borde rojo y animación.

### 2. Activar Alerta de Exterior

```yaml
service: input_text.set_value
data:
  entity_id: input_text.camera_alert_active
  value: "exterior"
```

### 3. Resetear a Normal

```yaml
service: input_text.set_value
data:
  entity_id: input_text.camera_alert_active
  value: "none"
```

---

## 🎨 Personalización

### Cambiar Duración de Alerta

En `camera_alert_automations.yaml`, modifica:

```yaml
# Cambiar de 30 a 60 segundos
- delay:
    seconds: 60
```

### Cambiar Colores

En `maui_dashboard.yaml`, modifica los estilos:

```yaml
border: 3px solid #10B981;  # Verde en vez de rojo
box-shadow: 0 0 24px rgba(16, 185, 129, 0.5);
```

### Cambiar Aspect Ratio

```yaml
aspect_ratio: "21:9"  # Ultra-wide
aspect_ratio: "16:9"  # Estándar
aspect_ratio: "4:3"   # Clásico
```

---

## 📊 Dashboard Estados

| Helper Value | Estado | Visualización |
|--------------|--------|---------------|
| `none` | Normal | Ambas cámaras 16:9 |
| `entrada` | Alerta Entrada | Solo entrada 21:9 + animación |
| `exterior` | Alerta Exterior | Solo exterior 21:9 + animación |

---

## 🔍 Troubleshooting

### La cámara no se agranda

1. **Verificar helper**:
   ```bash
   # Debería existir
   input_text.camera_alert_active
   ```

2. **Verificar estado**:
   - Ir a **Herramientas para desarrolladores** → **Estados**
   - Buscar `input_text.camera_alert_active`
   - Valor debe cambiar a `entrada` o `exterior`

3. **Verificar logs**:
   - **Configuración** → **Logs**
   - Buscar "Sistema de Alertas de Cámaras"

### La automatización no se dispara

1. **Verificar trigger**:
   - Los webhooks pueden no estar configurados
   - Probar con trigger manual primero

2. **Ajustar trigger**:
   - Usar el trigger que funcione con tu integración
   - Ver logs de HA para identificar eventos

### La cámara no vuelve a normal

1. **Verificar mode de automatización**:
   ```yaml
   mode: restart  # Debe estar en restart
   ```

2. **Reset manual**:
   ```yaml
   service: input_text.set_value
   data:
     entity_id: input_text.camera_alert_active
     value: "none"
   ```

---

## 🚀 Mejoras Futuras

- [ ] Integrar con sistema de notificaciones push
- [ ] Grabar clip de 10s cuando hay detección
- [ ] Histórico de detecciones en card
- [ ] Múltiples cámaras con prioridad
- [ ] Integración con alarma

---

## 📝 Notas

- **Performance**: Las conditional cards son muy eficientes
- **Compatibilidad**: Funciona con cualquier cámara de HA
- **Extensible**: Fácil agregar más cámaras
- **Testeable**: Prueba con helpers manualmente

---

**Versión**: 2.0
**Fecha**: Noviembre 2025
**Autor**: Maui Dashboard System

