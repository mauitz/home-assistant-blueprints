# 🚰 Sistema de Riego Inteligente

Blueprint completo para automatización de riego con ESP32 + ESPHome + Home Assistant.

---

## 📋 Características

### ✅ Control Inteligente
- **Riego por humedad**: Riega automáticamente cuando el suelo está seco
- **Protección de tanque**: No permite riego si el nivel está bajo
- **Horarios programables**: Define ventanas de riego permitidas
- **Duración controlada**: Tiempo máximo y detención por objetivo alcanzado
- **Intervalo mínimo**: Evita riegos muy frecuentes

### 🔔 Notificaciones
- Inicio y fin de riego
- Alertas de tanque bajo
- Estado del sistema

### 🎛️ Modos de Operación
- **Automático**: Riega basándose en sensores y configuración
- **Manual**: Desactiva la automatización temporalmente
- **Forzado**: Control directo de bombas desde HA

---

## 🔧 Instalación

### 1. Copiar el Blueprint

```bash
# Desde el terminal o SSH de Home Assistant:
cd /config/blueprints/automation/
mkdir -p mauitz
cp /path/to/sistema_riego_inteligente.yaml mauitz/
```

O desde la interfaz de Home Assistant:
1. Ve a **Configuración** → **Automatizaciones y Escenas**
2. Click en **Blueprints**
3. Click en **Importar Blueprint**
4. Pega la URL del blueprint (si está en GitHub)

### 2. Crear Helpers (Opcional pero Recomendado)

Ve a **Configuración** → **Dispositivos y Servicios** → **Helpers** y crea:

#### Input Boolean (Modo Manual)
- **Nombre**: Riego Z1 - Modo Manual
- **ID**: `input_boolean.riego_z1_manual`
- **Icono**: `mdi:hand-back-right`

#### Input DateTime (Último Riego)
- **Nombre**: Riego Z1 - Último Riego
- **ID**: `input_datetime.riego_z1_ultimo`
- **Tiene Fecha**: ✅
- **Tiene Hora**: ✅

#### Input Number (Contador)
- **Nombre**: Riego Z1 - Contador de Ciclos
- **ID**: `input_number.riego_z1_contador`
- **Mínimo**: 0
- **Máximo**: 1000
- **Paso**: 1

### 3. Crear la Automatización

#### Opción A: Desde la Interfaz (Recomendado)
1. Ve a **Configuración** → **Automatizaciones**
2. Click en **Crear Automatización** → **Usar un Blueprint**
3. Selecciona **Sistema de Riego Inteligente**
4. Rellena los campos según tu configuración

#### Opción B: Desde YAML
Copia el contenido de `examples/automatizaciones/riego_z1_auto.yaml` a tu archivo `automations.yaml`.

---

## ⚙️ Configuración

### Parámetros Principales

| Parámetro | Descripción | Valor Recomendado |
|-----------|-------------|-------------------|
| **Humedad Mínima** | Nivel para activar riego | 30% |
| **Humedad Objetivo** | Nivel para detener riego | 60% |
| **Nivel Mínimo Tanque** | Nivel mínimo del tanque | 20% |
| **Duración Máxima** | Tiempo máximo de riego | 10 min |
| **Intervalo Mínimo** | Tiempo entre riegos | 4 horas |
| **Hora Inicio** | Inicio de ventana de riego | 06:00 |
| **Hora Fin** | Fin de ventana de riego | 22:00 |

### Entidades Requeridas

#### ESP32 - ESPHome
```yaml
# Debe tener configurado:
- Sensor de humedad del suelo (sensor.humedad_suelo_z1)
- Sensor de nivel de tanque (sensor.nivel_tanque)
- Switch de bomba (switch.bomba_z1a o switch.bomba_z1b)
```

---

## 📱 Uso

### Modo Automático (Normal)
1. El sistema monitorea constantemente la humedad del suelo
2. Cuando baja del umbral mínimo (30%), activa el riego
3. Verifica que:
   - El tanque tenga suficiente agua (>20%)
   - Esté dentro del horario permitido
   - Haya pasado el intervalo mínimo
4. Riega hasta alcanzar la humedad objetivo (60%) o duración máxima (10 min)
5. Se detiene y espera el siguiente ciclo

### Modo Manual
1. Activa el helper `input_boolean.riego_z1_manual`
2. La automatización se desactiva temporalmente
3. Controla las bombas manualmente desde HA
4. Desactiva el helper para volver al modo automático

### Riego Forzado
Activa directamente el switch de la bomba:
```yaml
service: switch.turn_on
target:
  entity_id: switch.bomba_z1a
```

---

## 🎯 Casos de Uso

### Jardín de Césped
```yaml
humedad_minima: 40  # Césped requiere más humedad
humedad_objetivo: 70
duracion_riego: 15  # Riegos más largos
hora_inicio_permitido: "05:00:00"  # Temprano en la mañana
hora_fin_permitido: "08:00:00"
permitir_riego_nocturno: false
```

### Huerto de Verduras
```yaml
humedad_minima: 35
humedad_objetivo: 65
duracion_riego: 10
hora_inicio_permitido: "06:00:00"
hora_fin_permitido: "20:00:00"
intervalo_minimo: 6  # Menos frecuente
```

### Plantas Suculentas
```yaml
humedad_minima: 20  # Pueden estar más secas
humedad_objetivo: 40
duracion_riego: 5  # Riegos cortos
intervalo_minimo: 12  # Muy espaciados
```

### Invernadero
```yaml
humedad_minima: 45  # Alta humedad constante
humedad_objetivo: 75
duracion_riego: 8
permitir_riego_nocturno: true  # Puede regar de noche
intervalo_minimo: 3  # Muy frecuente
```

---

## 🔍 Troubleshooting

### ❌ El riego no se activa

**Verifica:**
1. ✅ Modo automático activado (`input_boolean.riego_z1_manual` OFF)
2. ✅ Humedad por debajo del umbral
3. ✅ Nivel de tanque suficiente
4. ✅ Dentro del horario permitido
5. ✅ Ha pasado el intervalo mínimo

**Ver logs:**
```yaml
# En Home Assistant:
Herramientas → Registros → Buscar "Riego"
```

### ❌ El riego no se detiene

**Posibles causas:**
1. Sensor de humedad desconectado o sin lectura
2. Bomba no responde al comando OFF
3. Timeout de duración máxima no configurado

**Solución de emergencia:**
```yaml
# Apagar manualmente:
service: switch.turn_off
target:
  entity_id: switch.bomba_z1a
```

### ❌ Notificaciones no llegan

**Verifica:**
1. Servicio de notificación correcto: `notify.mobile_app_tu_telefono`
2. Aplicación de Home Assistant instalada en el móvil
3. Permisos de notificación habilitados

**Probar servicio:**
```yaml
service: notify.mobile_app_iphone
data:
  message: "Prueba de notificación"
```

### ❌ Sensor de humedad no lee

**Verifica en ESPHome:**
```bash
esphome logs riego_z1.yaml
```

**Busca:**
- Errores de ADC
- Valores fuera de rango
- Problemas de calibración

---

## 📊 Dashboard Recomendado

### Tarjeta de Estado de Riego

```yaml
type: vertical-stack
cards:
  - type: entities
    title: 🚰 Sistema de Riego Z1
    entities:
      - entity: sensor.humedad_suelo_z1
        name: Humedad del Suelo
      - entity: sensor.nivel_tanque
        name: Nivel del Tanque
      - entity: switch.bomba_z1a
        name: Bomba Z1A
      - entity: switch.bomba_z1b
        name: Bomba Z1B
      - entity: input_boolean.riego_z1_manual
        name: Modo Manual

  - type: history-graph
    title: 📈 Historial de Humedad
    hours_to_show: 24
    entities:
      - entity: sensor.humedad_suelo_z1
        name: Humedad Suelo

  - type: gauge
    entity: sensor.nivel_tanque
    name: Nivel del Tanque
    min: 0
    max: 100
    severity:
      green: 50
      yellow: 30
      red: 0
```

---

## 🚀 Próximas Mejoras

### Planificadas
- [ ] Integración con pronóstico del clima (no regar si va a llover)
- [ ] Múltiples zonas con prioridades
- [ ] Histórico de consumo de agua
- [ ] Ajuste automático de umbrales por estación del año
- [ ] Integración con sensor de lluvia
- [ ] Control por voz (Alexa/Google Home)

---

## 📝 Licencia

MIT License - Libre para uso personal y comercial

## 👤 Autor

**Mauitz** - Sistema de Riego Inteligente para Home Assistant

---

## 📞 Soporte

- **Issues**: Reporta problemas en GitHub
- **Documentación**: Consulta la wiki del proyecto
- **Comunidad**: Foro de Home Assistant en español

---

**Última actualización**: Noviembre 2025

