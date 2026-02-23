# 📊 Dashboard Maui - Documentación

## 📌 Archivo Principal

**Archivo único:** `maui_dashboard.yaml`

- **Versión actual:** 3.4
- **Fecha:** 15 de Diciembre, 2025
- **Estado:** Producción

---

## 🗂️ Historial de Versiones

### v3.4 (15 Diciembre 2025) - **ACTUAL**
**Cambios:**
- ✅ **Eliminado sistema de agrandamiento dinámico de cámaras**
- ✅ Vista simple de cámaras (sin condicionales)
- ✅ Eliminadas dependencias de `input_text.camera_alert_active`
- ✅ Código simplificado y limpio
- ✅ Ya no depende de automatizaciones de detección

**Características:**
- Vista Home: Cámaras simples, Escenas, Control de Presencia
- Vista Riego: Sistema de Riego Inteligente Zona 1
- Estética minimalista oscura profesional
- Sin dependencias de sistemas de detección externos

**Nota:** El sistema de agrandamiento dinámico fue eliminado porque dependía de Frigate, que ya no está instalado.

### v3.3 (15 Diciembre 2025)
**Cambios:**
- ✅ Eliminada sección de Frigate (sistema desinstalado temporalmente)
- ✅ Widget de cámaras con agrandamiento dinámico funcional
- ✅ Limpieza de entidades no disponibles
- ✅ Sistema optimizado sin dependencias de Frigate

**Características:**
- Vista Home: Cámaras, Escenas, Control de Presencia
- Vista Riego: Sistema de Riego Inteligente Zona 1
- Agrandamiento dinámico de cámaras en alerta
- Estética minimalista oscura profesional

### v3.2 (24 Noviembre 2025)
**Cambios:**
- ✅ Agregada sección de Frigate con detección IA
- ✅ Detección de personas, vehículos y animales
- ✅ Snapshots con bounding boxes

**Nota:** Frigate fue desinstalado posteriormente (v3.3) por limitaciones de recursos del servidor.

### v3.1 (Noviembre 2025)
**Cambios:**
- ✅ Vista dedicada para Sistema de Riego Inteligente
- ✅ Gauges y gráficos de humedad
- ✅ Control manual de bombas

### v3.0 (Octubre 2025)
**Cambios:**
- ✅ Widget de cámaras con agrandamiento a 2 columnas en alerta
- ✅ Sistema de control de presencia
- ✅ Escenas dinámicas auto-generadas
- ✅ Grid layout personalizado

---

## 📖 Estructura del Dashboard

### Vista 1: Home
```
- Título: Cámaras
- Widget Cámara Entrada (vista simple)
- Widget Cámara Exterior (vista simple)

- Título: Escenas y Control
- Escenas dinámicas (auto-entities)
- Control de Simulación de Presencia

- Título: Áreas
- Botón "Ver Todas las Áreas"

- Título: Simulación de Presencia
- Estado y Control
- Progreso y Tiempo
- Luces Activas
```

### Vista 2: Riego
```
- Widget Principal: Sistema de Riego - Zona 1
  - Estado General (glance)
  - Estado del Sistema (markdown dinámico)
  - Gráfico de Humedad (24h)
  - Control de Bombas
  - Sensores Ambientales
  - Indicadores LED
  - Control Manual
  - Gauges (humedad y tanque)

- Información del Sistema
  - Datos del ESP32
```

---

## 🚀 Cómo Actualizar el Dashboard en Home Assistant

### Método: Copiar y Pegar en la UI (Recomendado)

1. **Abrir el dashboard en modo edición:**
   ```
   http://homeassistant.local:8123/dashboard-maui
   Click en el menú (⋮) → Editar dashboard
   Click en el menú (⋮) → Raw configuration editor
   ```

2. **Copiar el contenido completo de `maui_dashboard.yaml`:**
   - Abre el archivo en tu editor
   - Selecciona TODO el contenido
   - Copia (Cmd+C)

3. **Pegar en Home Assistant:**
   - Selecciona TODO el contenido actual en el editor
   - Pega el nuevo contenido (Cmd+V)
   - Click en "GUARDAR"
   - Click en "✕" para cerrar el editor
   - Click en "LISTO" para salir del modo edición

4. **Verificar:**
   - Refresca la página (Cmd+R)
   - Verifica que todo se vea correctamente
   - No debe haber sección de Frigate
   - Cámaras deben funcionar correctamente

---

## 🔧 Entidades Requeridas

### Cámaras
- `camera.tapo_c530ws_entrada_live_view`
- `camera.tapo_c310_exterior_live_view`

### Presencia
- `input_boolean.presence_simulation`
- `input_boolean.presence_simulation_running`
- `input_text.presence_simulation_status`
- `input_number.presence_simulation_loop_counter`
- `input_number.presence_simulation_loop_total`
- `input_number.presence_simulation_lights_on_count`
- `sensor.presence_simulation_runtime`
- `sensor.presence_simulation_progress`
- `sensor.presence_simulation_time_remaining`

### Riego (Zona 1)
- `switch.riego_z1_bomba_z1a`
- `switch.riego_z1_bomba_z1b`
- `sensor.riego_z1_humedad_suelo_z1`
- `sensor.riego_z1_nivel_tanque`
- `sensor.riego_z1_temperatura`
- `sensor.riego_z1_humedad_relativa`
- Y más sensores del ESP32...

---

## ⚠️ Notas Importantes

### Sobre Frigate
- **Estado:** Desinstalado temporalmente (v3.3)
- **Razón:** Consumo excesivo de CPU en servidor actual
- **Reinstalación:** Cuando se cuente con servidor dedicado o Google Coral TPU
- **Documentación:** Ver `docs/frigate/INFORME_FRIGATE_ANALISIS_FINAL.md`

### Sobre las Versiones Antiguas
- `maui_dashboard_v3.1.yaml` - **DEPRECATED** (mantener solo para referencia)
- Solo mantener y usar `maui_dashboard.yaml` como archivo principal

---

## 🎨 Personalización

### Cambiar Colores
El dashboard usa variables CSS. Para personalizarlo, edita los valores en `card_mod.style`:

```yaml
background: #1A1A1A  # Color de fondo
border: 1px solid #2A2A2A  # Color de borde
color: #E0E0E0  # Color de texto
```

### Agregar Nueva Vista
```yaml
- title: Nombre Vista
  path: ruta-vista
  icon: mdi:icono
  theme: maui_dark
  type: custom:grid-layout
  layout:
    grid-template-columns: repeat(auto-fill, minmax(350px, 1fr))
    grid-gap: 16px
  badges: []
  cards:
    # Tus cards aquí...
```

---

## 🐛 Troubleshooting

### Error: "Entity not available"
- Verifica que todas las entidades existen
- Revisa que los nombres de entidades coincidan con los de tu HA
- Ve a: Herramientas de desarrollador → Estados → Busca la entidad

### Helpers Obsoletos (Pueden eliminarse)
Estos helpers ya no se usan desde la v3.4:
- `input_text.camera_alert_active` - Usado por sistema de agrandamiento (eliminado)
- `input_text.camera_alert_timestamp` - Usado por sistema de agrandamiento (eliminado)

### Faltan escenas en el dashboard
- Las escenas se generan automáticamente con `custom:auto-entities`
- Verifica que tengas escenas creadas en HA
- Verifica que la card `custom:button-card` esté instalada

---

## 📦 Custom Cards Requeridas

Estas custom cards deben estar instaladas en Home Assistant:

1. **layout-card**
   - Para el grid layout personalizado

2. **button-card**
   - Para los botones personalizados de escenas

3. **auto-entities**
   - Para generar escenas dinámicamente

4. **card-mod**
   - Para estilos personalizados

**Instalación:** HACS → Frontend → Buscar cada card → Instalar

---

## 🔄 Workflow de Actualización

1. **Editar localmente:**
   - Edita `dashboards/maui_dashboard.yaml`
   - Prueba la sintaxis YAML

2. **Actualizar versión:**
   - Incrementa número de versión en la cabecera
   - Actualiza fecha
   - Documenta cambios en este README

3. **Subir a HA:**
   - Copia el contenido completo del YAML
   - Pega en el Raw configuration editor de HA
   - Guarda y verifica

4. **Commit:**
   - Commit de cambios en el repositorio
   - Incluye descripción de cambios

---

## 📝 Changelog Detallado

### 2025-12-15 - v3.4
- Eliminado sistema completo de agrandamiento dinámico de cámaras
- Simplificada vista de cámaras a modo estático (sin condicionales)
- Eliminadas 3 cards condicionales complejas
- Código reducido y más mantenible
- Ya no depende de helpers de alerta de cámaras

### 2025-12-15 - v3.3
- Eliminada sección completa de Frigate
- Limpieza de referencias a entidades de Frigate
- Dashboard funcional sin dependencias externas

### 2025-11-24 - v3.2
- Agregado widget de Frigate con 3 subsecciones
- Detección de personas, vehículos y animales
- Integración con binary sensors de Frigate

### 2025-11-14 - v3.1
- Vista de Riego completada
- Gauges para humedad y nivel de tanque
- Control manual de bombas

### 2025-10 - v3.0
- Release inicial del dashboard Maui
- Widget de agrandamiento de cámaras
- Sistema de simulación de presencia

---

**Última actualización:** 15 de Diciembre, 2025
**Mantenido por:** Maui
**Repositorio:** home-assistant-blueprints



