# 📊 Widget de Riego Inteligente

Widget especializado para monitorear y controlar el Sistema de Riego Inteligente en Home Assistant.

---

## 🎨 Características del Widget

### **Versión Completa (con Custom Cards)**
- ✨ Diseño moderno con Mushroom Cards
- 📊 Gráfico animado de humedad (Mini Graph Card)
- 🎯 Indicadores visuales de estado
- 🚀 Acciones rápidas con chips
- 💡 Colores dinámicos según estado
- 📱 Responsive y optimizado para móvil

### **Versión Básica (sin dependencias)**
- 📊 Compatible con cards nativas de HA
- 📈 Gráfico de historial de humedad
- 🎛️ Controles de bombas y sensores
- 🔔 Indicadores gauge para visualización
- ✅ Funciona sin instalar nada adicional

---

## 📦 Dependencias

### **Versión Completa Requiere:**

```yaml
# Custom cards necesarias (instalar vía HACS):
- mushroom-cards
- mini-graph-card
- card-mod (opcional, para estilos avanzados)
```

### **Versión Básica:**
- ✅ Sin dependencias, usa cards nativas de Home Assistant

---

## 🚀 Instalación

### **Opción 1: Widget Completo (Recomendado)**

#### Paso 1: Instalar Custom Cards

1. Abre **HACS** en Home Assistant
2. Ve a **Frontend**
3. Busca e instala:
   - **Mushroom**
   - **Mini Graph Card**
   - **Card Mod** (opcional)

#### Paso 2: Agregar Widget al Dashboard

1. Edita tu dashboard
2. **Agregar tarjeta** → **Manual**
3. Copia el contenido de:
   ```
   dashboards/widgets/widget_riego_z1.yaml
   ```
4. Pega y guarda

### **Opción 2: Widget Básico (Sin Custom Cards)**

1. Edita tu dashboard
2. **Agregar tarjeta** → **Manual**
3. Copia el contenido de:
   ```
   dashboards/widgets/widget_riego_z1_basico.yaml
   ```
4. Pega y guarda

---

## 🔧 Configuración de Scripts

El widget usa scripts auxiliares para acciones rápidas.

### **Instalar Scripts:**

1. Abre `configuration.yaml`

2. Agrega o incluye los scripts:

```yaml
# Opción A: Directo en configuration.yaml
script: !include scripts.yaml

# Opción B: En configuration.yaml directamente
script:
  # Pega aquí el contenido de examples/scripts/riego_scripts.yaml
```

3. Copia el contenido de:
   ```
   examples/scripts/riego_scripts.yaml
   ```

4. Reinicia Home Assistant

---

## 📋 Scripts Disponibles

### **1. Riego Manual 5 min**
```yaml
service: script.riego_manual_5min
```
Activa riego manual durante 5 minutos.

### **2. Riego Manual 10 min**
```yaml
service: script.riego_manual_10min
```
Activa riego manual durante 10 minutos.

### **3. Detener Todas las Bombas**
```yaml
service: script.detener_todas_bombas
```
Apaga todas las bombas inmediatamente.

### **4. Test de Bombas**
```yaml
service: script.test_bombas_z1
```
Prueba cada bomba durante 10 segundos.

### **5. Riego de Emergencia**
```yaml
service: script.riego_emergencia_z1
```
Riega hasta alcanzar 60% de humedad o 15 min máximo.

---

## 🎨 Personalización

### **Cambiar Colores**

Edita los umbrales en el widget:

```yaml
icon_color: >
  {% set humedad = states('sensor.humedad_suelo_z1') | float(0) %}
  {% if humedad < 30 %}
    red          # Suelo seco
  {% elif humedad < 50 %}
    orange       # Humedad baja
  {% elif humedad < 70 %}
    green        # Humedad OK
  {% else %}
    blue         # Suelo húmedo
  {% endif %}
```

### **Ajustar Gráfico**

```yaml
mini-graph-card:
  hours_to_show: 24      # Horas a mostrar (24, 48, 72...)
  points_per_hour: 2     # Puntos por hora (1, 2, 4...)
  line_width: 3          # Grosor de línea
```

### **Modificar Umbrales de Color**

```yaml
color_thresholds:
  - value: 0
    color: "#f44336"     # Rojo (0-30%)
  - value: 30
    color: "#ff9800"     # Naranja (30-50%)
  - value: 50
    color: "#4caf50"     # Verde (50-70%)
  - value: 70
    color: "#03a9f4"     # Azul (70-100%)
```

---

## 📊 Vista Previa del Widget

### **Secciones del Widget:**

#### 1. **Cabecera con Estado General**
```
🚰 Sistema de Riego - Zona 1
💧 Regando ahora | Humedad: 35%
```
- Muestra estado actual del sistema
- Color dinámico según estado
- Badge si modo manual activo

#### 2. **Sensores Principales**
```
[Humedad Suelo 33%] [Tanque 91%] [Luz 13%]
```
- Humedad del suelo con color dinámico
- Nivel del tanque
- Luz ambiente

#### 3. **Gráfico de Humedad**
```
📊 Gráfico animado de últimas 24 horas
```
- Línea con gradiente de color
- Umbrales visuales
- Animaciones suaves

#### 4. **Controles de Bombas**
```
[Bomba Z1A] [Bomba Z1B] [LED]
```
- Tap para activar/desactivar
- Hold para más información
- Fondo resaltado si está activa

#### 5. **Sensores Ambientales**
```
[Temperatura] [H. Ambiente] [Presencia]
```
- Temperatura con color según valor
- Humedad ambiente
- Sensor de presencia LD2410C

#### 6. **Control y Configuración**
```
⚙️ Modo Manual, Estado, Último Riego
```
- Toggle modo manual/automático
- Estado del sistema
- Tiempo desde último riego
- Chips de acciones rápidas

#### 7. **Acciones Rápidas**
```
[Regar] [Automatización] [Historia] [Config]
```
- Botones rápidos
- Navegación directa
- Información del sistema

---

## 🔍 Troubleshooting

### **Widget no aparece correctamente**

1. **Verifica custom cards instaladas:**
   ```
   HACS → Frontend → Busca "mushroom" y "mini-graph"
   ```

2. **Limpia caché del navegador:**
   ```
   Ctrl + F5 (Windows/Linux)
   Cmd + Shift + R (Mac)
   ```

3. **Verifica recursos cargados:**
   ```
   Configuración → Dashboards → Recursos
   ```

### **Scripts no funcionan**

1. **Verifica que los scripts estén cargados:**
   ```
   Herramientas → Servicios → Busca "script."
   ```

2. **Revisa errores en logs:**
   ```
   Configuración → Logs
   ```

3. **Verifica nombres de entidades:**
   - Los scripts usan entidades específicas
   - Cambia los `entity_id` según tu configuración

### **Entidades no existen**

Si algunas entidades no existen en tu sistema:

1. **Remueve o comenta esas líneas del widget**

2. **O crea helpers temporales:**
   ```yaml
   sensor:
     - platform: template
       sensors:
         riego_z1_estado_sistema:
           value_template: "OK"
   ```

---

## 🎯 Mejores Prácticas

### **Organización**

1. **Crea una vista dedicada para Riego:**
   ```yaml
   views:
     - title: Riego
       path: riego
       icon: mdi:sprinkler-variant
       cards:
         # Widget aquí
   ```

2. **Usa secciones si tienes múltiples zonas:**
   ```yaml
   - type: vertical-stack
     title: Zona 1
     cards:
       # Widget Z1

   - type: vertical-stack
     title: Zona 2
     cards:
       # Widget Z2
   ```

### **Mobile First**

- El widget está optimizado para móvil
- Usa `horizontal-stack` con máximo 3 cards
- Evita textos muy largos en chips

### **Performance**

- El gráfico se actualiza cada 60s
- Los sensores tienen polling según ESPHome
- Los scripts son single mode para evitar conflictos

---

## 📱 Uso en Móvil

### **App de Home Assistant:**

1. El widget se adapta automáticamente
2. Los botones son touch-friendly
3. Los chips son accesibles con un toque

### **Notificaciones:**

Configura acciones en notificaciones:

```yaml
service: notify.mobile_app_tu_telefono
data:
  message: "Riego iniciado"
  data:
    actions:
      - action: "STOP_RIEGO"
        title: "Detener"
      - action: "OPEN_WIDGET"
        title: "Ver Estado"
```

---

## 🚀 Próximas Mejoras (v2.2)

- [ ] Integración con clima (no regar si va a llover)
- [ ] Estadísticas de consumo de agua
- [ ] Comparación entre zonas
- [ ] Predicción de próximo riego
- [ ] Control por voz

---

## 📝 Changelog del Widget

### **v2.1** (2025-11-24)
- ✅ Widget completo con Mushroom Cards
- ✅ Widget básico sin dependencias
- ✅ 5 scripts auxiliares
- ✅ Documentación completa
- ✅ Soporte para LD2410C

### **v2.0** (2025-11-24)
- Blueprint de riego funcionando
- Integración ESP32 + ESPHome

---

**¡Tu widget está listo para usar!** 🎉

Para más información consulta la [documentación completa del sistema](../automatizaciones/RIEGO_INTELIGENTE.md).

