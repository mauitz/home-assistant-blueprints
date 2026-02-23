# LightNode - Registro de Cambios

## [v2.2] - 2026-01-30 ⚙️ OPTIMIZACIÓN - Configuración 1m→0cm

### 🎯 Nuevos Parámetros por Defecto

**Objetivo**: Configurar el efecto de proximidad para un pasillo (1 metro → 0cm)

**Cambios en valores iniciales**:
- ✅ `distancia_inicio`: 200cm → **100cm** (1 metro)
- ✅ `brillo_inicio`: 20% → **10%** (inicio más tenue)
- ✅ `distancia_maxima`: 50cm → **0cm** (junto al sensor)
- ✅ Rango mínimo de "Distancia Máxima (Z)": 20cm → **0cm**

### 📊 Nuevo Comportamiento

```
Distancia > 1m:  Luces OFF (fuera de rango)
1m → 0cm:        Brillo 10% → 100% (gradual)
0cm (junto):     Brillo 100% (máximo)
```

### 📚 Documentación

- ✅ `CONFIGURACION_COMPLETA_v2.2.md`: Guía completa con:
  - Explicación detallada de TODOS los parámetros
  - Configuración recomendada para el pasillo
  - Troubleshooting completo
  - Ejemplos de uso y ajustes
  - Fórmulas de interpolación explicadas

### 🚀 Despliegue

- ✅ Compilado exitosamente (22.90 segundos)
- ✅ Desplegado vía OTA (5.82 segundos)
- ✅ Verificado funcionando en 192.168.1.15

---

## [v2.1.1] - 2026-01-29 🐛 BUGFIX - Sensor Distancia

### 🐛 Fix Crítico: LD2410C No Reportaba Distancia

**Problema Identificado**:
- Sensor LD2410C detectaba presencia (binary ON)
- NO reportaba valor de distancia (`detection_distance = 0`)
- Modo automático siempre ejecutaba "Sin detección - apagado"
- Logs mostraban: `[D][auto:268]: Sin detección - iniciando apagado`

**Solución Implementada**:
- ✅ Sistema de fallback para sensores de distancia
- ✅ Jerarquía: `detection_distance` → `moving_distance` → `still_distance`
- ✅ Logs mejorados con diagnóstico de qué sensor se está usando
- ✅ Previene apagado cuando sensores alternativos tienen valores válidos

### 🔧 Cambios Técnicos

```cpp
// Agregado en script control_automatico_proximidad:
if (distancia == 0 || isnan(distancia)) {
    // Usar sensores alternativos
    if (dist_movimiento > 0) { distancia = dist_movimiento; }
    else if (dist_estatico > 0) { distancia = dist_estatico; }
}
```

### 📝 Logs Nuevos
- ✅ `"Usando Distancia Movimiento: XXcm"`
- ✅ `"Usando Distancia Estático: XXcm"`
- ✅ `"Distancia final usada: XXcm"`
- ✅ `"Sin detección válida - iniciando apagado"` (solo cuando realmente no hay nada)

### 🚀 Despliegue
- ✅ Compilado exitosamente (5.98 segundos)
- ✅ Desplegado vía OTA (4.99 segundos)
- ✅ Verificado funcionando en 192.168.1.15

### 📚 Documentación
- ✅ `FIX_SENSOR_DISTANCIA.md`: Explicación completa del problema y fix

---

## [v2.1] - 2026-01-29 🎨 UI IMPROVEMENT

### ✨ Mejora de Interfaz de Usuario

**Reorganización completa de controles** para mejor usabilidad:

#### Numeración Lógica
- ✅ Todos los controles numerados (1-B) para forzar orden
- ✅ Agrupación clara: Modos → Manual → Configuración
- ✅ Fácil de seguir secuencialmente

#### Controles Renombrados
- ✅ `1. Control Automático` (antes: "Control Automático")
- ✅ `2. Solo de Noche` (antes: "Solo de Noche")
- ✅ `3. Luz Derecha` (antes: "Luz Derecha Manual")
- ✅ `4. Dimmer Derecha` (antes: "Dimmer Luz Derecha")
- ✅ `5. Luz Izquierda` (antes: "Luz Izquierda Manual")
- ✅ `6. Dimmer Izquierda` (antes: "Dimmer Luz Izquierda")
- ✅ `7. Timeout Apagado` (mantuvo nombre)
- ✅ `8. Umbral Luz` (antes: "Umbral Luz (Solo de Noche)")
- ✅ `9. Distancia Inicio (X)` (mantuvo nombre)
- ✅ `A. Brillo Inicio (Y)` (mantuvo nombre)
- ✅ `B. Distancia Máxima (Z)` (mantuvo nombre)

#### Iconos Mejorados
- ✅ `mdi:robot` para Control Automático (más descriptivo)
- ✅ `mdi:moon-waning-crescent` para Solo de Noche
- ✅ `mdi:light-recessed` para luces manuales
- ✅ `mdi:tune-vertical` para dimmers
- ✅ `mdi:timer-sand` para timeout

#### Sliders Uniformes
- ✅ Todos los controles de valor con `mode: slider`
- ✅ Distancia Inicio (X) cambiado de `box` a `slider`
- ✅ Distancia Máxima (Z) cambiado de `box` a `slider`

#### Limpieza de UI
- ✅ Luces LED internas ocultadas (`internal: true`)
- ✅ "LED Entrance Derecha/Izquierda" ya no aparecen en UI
- ✅ Control solo mediante switches numerados

### 📝 Documentos Nuevos
- ✅ `INTERFAZ_MEJORADA_v2.1.md`: Explicación completa de mejoras UI

### 🚀 Despliegue
- ✅ Compilado exitosamente (6.02 segundos)
- ✅ Flasheado vía USB (72 segundos)
- ✅ Verificado funcionando en 192.168.1.14

---

## [v2.0] - 2026-01-29 🎉 MAJOR UPDATE

### ✨ Nuevo: Sistema de Control Avanzado

**Rediseño completo del comportamiento** con efecto de proximidad progresivo:

#### Nuevos Switches
- ✅ **Control Automático**: Modo auto vs manual (reemplaza "Automatización Activada")
- ✅ **Solo de Noche**: Restricción por luz ambiente (afecta ambos modos)
- ✅ **Luz Derecha Manual**: Control directo guirnalda derecha
- ✅ **Luz Izquierda Manual**: Control directo guirnalda izquierda

#### Nuevos Dimmers/Sliders
- ✅ **Dimmer Luz Derecha** (5-100%): Brillo fijo modo manual
- ✅ **Dimmer Luz Izquierda** (5-100%): Brillo fijo modo manual
- ✅ **Distancia Inicio (X)** (50-600cm): Dónde comienza a encender
- ✅ **Brillo Inicio (Y)** (5-80%): Brillo a distancia X
- ✅ **Distancia Máxima (Z)** (20-200cm): Dónde alcanza 100%

#### Efecto de Proximidad Implementado
- ✅ **Interpolación lineal**: Brillo aumenta progresivamente según distancia
- ✅ **Fórmula**: `Brillo = Y + ((X - dist) / (X - Z)) × (100 - Y)`
- ✅ **Transiciones suaves**: 300ms para cambios automáticos
- ✅ **Detección continua**: Actualiza brillo en tiempo real

#### Mejoras de Lógica
- ✅ **Modo manual respeta "Solo de Noche"**: No puedes encender de día si está activado
- ✅ **Feedback en logs**: Mensajes detallados de decisiones
- ✅ **Aplicación inmediata**: Cambios de dimmer se aplican al instante
- ✅ **Timeout más largo**: 2 segundos de fade-out (vs 1 seg anterior)

### 📝 Documentos Nuevos
- ✅ `FUNCIONAMIENTO_AVANZADO.md`: Explicación completa del nuevo sistema
- ✅ `GUIA_USO_CONTROLES.md`: Tutorial paso a paso con ejemplos prácticos

### 🔄 Cambios Técnicos
- ✅ Refactorizado sistema de scripts
- ✅ Agregados 5 nuevos globals para parámetros
- ✅ Trigger automático en cambio de distancia
- ✅ Validación de condiciones antes de encender
- ✅ Logs más descriptivos con formato

### 🚀 Despliegue
- ✅ Compilado exitosamente (6.15 segundos)
- ✅ Flasheado vía USB (20 segundos)
- ✅ Verificado funcionando en 192.168.1.14
- ✅ Tamaño: 1,047,520 bytes (56.8% flash)
- ✅ RAM: 13.0% utilizada

## [v1.3] - 2026-01-20

### 🔄 Modificado
- **Nombre del dispositivo**: Cambiado de "lightnode-pasillo" a **"lightnode-entrance"**
- **Nombres de sensores y luces**: Actualizados a inglés
  - Presencia Pasillo → Presencia Entrance
  - LED Pasillo → LED Entrance
  - Objetivo en Movimiento → Objetivo en Movimiento Entrance
- **Archivo renombrado**: `lightnode_pasillo.yaml` → `lightnode_entrance.yaml`
- **Flasheo exitoso**: Firmware actualizado y verificado funcionando en 192.168.1.14

## [v1.2] - 2026-01-20

### ❌ Eliminado
- **Sensor DHT11**: Eliminado del diseño completo
  - Ya no se medirá temperatura ni humedad
  - GPIO 27 ahora disponible para futuros usos
  - Simplificación del montaje y reducción de componentes

### 📝 Documentos Actualizados

#### DIAGRAMA_VISUAL_CONEXIONES.md (v1.2)
- ✅ Eliminada sección completa del DHT11
- ✅ Renumerado sensor LD2410C de sección 6 a sección 5
- ✅ Actualizada lista de GPIOs (eliminado GPIO 27)
- ✅ Actualizado diagrama ASCII de layout
- ✅ Actualizada tabla de conexiones (eliminadas 4 filas del DHT11)
- ✅ Actualizado sistema de GND común
- ✅ Actualizados prompts para generación de imágenes
- ✅ Eliminado código de color verde (era para datos digitales del DHT11)
- ✅ Actualizada simbología de módulos

#### Proyecto_Pasillo_Luces_ESP32.md
- ✅ Eliminado "Reporta temperatura y humedad" de objetivos
- ✅ Actualizada lista de sensores (solo LD2410C y LDR)
- ✅ Actualizada lista de componentes (sin DHT11)
- ✅ Eliminada sección completa de DHT11 en sensores
- ✅ Actualizada asignación de pines (eliminado GPIO 27)
- ✅ Eliminadas consideraciones térmicas del DHT11
- ✅ Actualizada sección de software ESPHome

#### LISTA_MATERIALES.md
- ✅ Eliminado DHT11 de lista de sensores
- ✅ Actualizado código de colores de cables (eliminado verde)
- ✅ Actualizado resumen de cantidades
- ✅ Actualizado orden de montaje
- ✅ Actualizada sección de compatibilidad (eliminadas alternativas al DHT11)
- ✅ Actualizada sección de recursos (eliminado datasheet DHT11)

#### README.md
- ✅ Eliminada característica de monitoreo ambiental
- ✅ Actualizado diagrama de arquitectura ASCII
- ✅ Actualizada tabla de especificaciones técnicas
- ✅ Actualizada descripción del documento de consideraciones térmicas
- ✅ Eliminadas notas sobre gestión térmica del DHT11
- ✅ Actualizada sección de mejoras futuras

#### CONSIDERACIONES_TERMICAS.md
- ✅ Agregada nota prominente indicando que es documento de referencia
- ✅ Marcado como histórico (DHT11 eliminado del diseño final)
- ✅ Conservado para referencia técnica sobre comportamiento térmico del ESP32

### 📊 Resumen de Impacto

**Componentes eliminados**: 1
- DHT11

**GPIOs liberados**: 1
- GPIO 27 (antes DATA del DHT11)

**Conexiones eliminadas**: 3
- 3.3V → DHT11 VCC
- GPIO 27 → DHT11 DATA
- DHT11 GND → GND común

**Sensores finales**: 2
- LD2410C (detección de presencia mmWave)
- LDR (sensor de luz ambiente)

---

## [v1.1] - 2026-01-20

### 🔧 Modificado
- **R4**: Actualizada de 34Ω a 30Ω (3×10Ω en serie)
  - Razón: Disponibilidad de componentes
  - Impacto: ~12% más corriente en canal derecho
  - Diferencia de brillo: Despreciable en uso práctico

### 📝 Documentos Actualizados
- DIAGRAMA_VISUAL_CONEXIONES.md: Especificada configuración R4 = 3×10Ω
- Proyecto_Pasillo_Luces_ESP32.md: Actualizada lista de componentes
- LISTA_MATERIALES.md: Creado con BOM completo

---

## [v1.0] - 2026-01-20

### ✨ Inicial
- Creación del proyecto LightNode
- Documentación completa del sistema
- Especificaciones técnicas
- Diagramas de conexión
- Lista de materiales

### 📋 Documentos Creados
- README.md
- Proyecto_Pasillo_Luces_ESP32.md
- DIAGRAMA_VISUAL_CONEXIONES.md
- LISTA_MATERIALES.md
- CONSIDERACIONES_TERMICAS.md

---

## Próxima Versión Planeada

### Pendiente para v1.3 (futuro)
- [ ] Crear configuración ESPHome completa
- [ ] Crear automatizaciones para Home Assistant
- [ ] Documentar proceso de montaje con fotos
- [ ] Pruebas de campo y optimizaciones
- [ ] Diseño de PCB (versión final)

---

**Mantenedor**: Proyecto domótica Home Assistant  
**Repositorio**: home-assistant-blueprints/docs/lightnode/
