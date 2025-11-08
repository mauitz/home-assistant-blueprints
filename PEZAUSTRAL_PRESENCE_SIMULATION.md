# 🏠 PezAustral Presence Simulation

## Versión 1.0

Blueprint avanzado para Home Assistant que simula presencia en tu hogar mediante el control inteligente de luces y otros dispositivos.

---

## 📋 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Características Principales](#características-principales)
3. [Instalación](#instalación)
4. [Configuración](#configuración)
   - [Control de Automatización](#1-control-de-automatización)
   - [Configuración de Triggers](#2-configuración-de-triggers)
   - [Configuración de Luces](#3-configuración-de-luces)
   - [Configuración de Duración](#4-configuración-de-duración)
   - [Configuración de Loop](#5-configuración-de-loop)
   - [Escena de Salida](#6-escena-de-salida)
   - [Días de la Semana](#7-días-de-la-semana)
   - [Condiciones Globales](#8-condiciones-globales)
5. [Ejemplos de Uso](#ejemplos-de-uso)
6. [Preguntas Frecuentes](#preguntas-frecuentes)
7. [Solución de Problemas](#solución-de-problemas)
8. [Créditos](#créditos)

---

## Introducción

**PezAustral Presence Simulation** es un blueprint que te permite simular tu presencia en casa cuando estás de vacaciones o ausente. A diferencia de otras soluciones, este blueprint incluye características avanzadas como:

- **Control de lámparas simultáneas**: Limita cuántas luces pueden estar encendidas al mismo tiempo
- **Sistema inteligente de apagado**: Apaga automáticamente las luces más antiguas cuando se alcanza el límite
- **Modo loop con repeticiones**: Repite la simulación múltiples veces
- **Escena de salida**: Configura un estado final cuando termina la simulación

### Basado en:
Este blueprint está basado en el excelente trabajo de **Blackshome**: [Holiday & Away Lighting](https://gist.github.com/Blackshome/0a34870755762bcb9fab159d5b94fd25)

---

## Características Principales

### ✨ Funcionalidades Destacadas

#### 1. **Control de Lámparas Simultáneas** 🔢
Define un máximo de lámparas que pueden estar encendidas al mismo tiempo. Cuando se alcanza este límite, el sistema apaga automáticamente las luces más antiguas antes de encender nuevas.

**Ejemplo:** Si tienes 10 luces configuradas pero estableces el máximo en 3, nunca habrá más de 3 luces encendidas simultáneamente, creando una simulación más realista y ahorrando energía.

#### 2. **Apagado Inteligente en Paralelo** 🔄
El sistema gestiona automáticamente el encendido y apagado de luces de forma que:
- Cuando una nueva luz debe encenderse y ya se alcanzó el límite, se apaga la más antigua
- Las luces se mantienen encendidas por períodos aleatorios (dentro de los rangos configurados)
- El flujo es continuo y natural

#### 3. **Modo Loop con Repeticiones** 🔁
- **Habilitable/Deshabitable**: Activa o desactiva el modo de repetición
- **Repeticiones configurables**: Define cuántas veces se repetirá la secuencia (0 = infinito)
- **Delay aleatorio entre loops**: Tiempo de espera variable entre cada repetición para mayor naturalidad

#### 4. **Escena de Salida** 🎬
Al finalizar todas las repeticiones, puedes activar automáticamente una escena específica. Por ejemplo:
- Apagar todas las luces
- Dejar solo una luz encendida en modo nocturno
- Activar luces exteriores

#### 5. **Múltiples Tipos de Trigger** ⚡
- **Tiempo específico**: Activa a una hora determinada
- **Elevación solar**: Activa cuando el sol alcanza cierta altura
- **Nivel de luz ambiental**: Activa cuando la luz ambiental cae por debajo de un umbral
- **Estado de entidad**: Activa cuando otra entidad cambia a ON o OFF

#### 6. **Control por Zona y Personas** 📍
- Activa la simulación solo cuando no hay nadie en casa
- Monitorea personas específicas o cualquier dispositivo en una zona
- Perfecto para activarse automáticamente cuando sales de casa

#### 7. **Personalización Completa de Luces** 💡
- Brillo configurable
- Temperatura de color
- Tiempo de transición al encender/apagar
- Orden de encendido (secuencial, reverso, aleatorio, simultáneo)
- Delays aleatorios entre cada luz

---

## Instalación

### Método 1: Desde la interfaz de Home Assistant

1. Ve a **Configuración** → **Automatizaciones y Escenas** → **Blueprints**
2. Haz clic en **Importar Blueprint**
3. Pega la URL de este archivo o súbelo manualmente
4. Haz clic en **Importar**

### Método 2: Manual

1. Copia el archivo `pezaustral_presence_simulation.yaml` a tu carpeta de blueprints:
   ```
   /config/blueprints/automation/pezaustral/
   ```

2. Reinicia Home Assistant o recarga las automatizaciones

---

## Configuración

### 1. Control de Automatización

Controla cuándo y cómo se activa la automatización.

#### Parámetros:

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| **Entidad de Control** | Entity | No | Input boolean o switch para activar/desactivar la automatización manualmente |
| **Fecha de Inicio** | Date | No | Primera fecha en la que la automatización estará activa |
| **Fecha de Fin** | Date | No | Última fecha en la que la automatización estará activa |
| **Control por Zona** | Zone | No | Zona a monitorear (se activa cuando no hay nadie) |
| **Personas a Rastrear** | Person | No | Personas específicas a monitorear en la zona |

#### Ejemplo de uso:
```yaml
Entidad de Control: input_boolean.vacation_mode
Fecha de Inicio: 2025-12-20
Fecha de Fin: 2025-12-30
Control por Zona: zone.home
Personas a Rastrear: 
  - person.juan
  - person.maria
```

**Resultado**: La automatización solo se ejecutará entre el 20 y 30 de diciembre, cuando ni Juan ni María estén en casa, y solo si `input_boolean.vacation_mode` está activado.

---

### 2. Configuración de Triggers

Define **cuándo** se activará la simulación de presencia.

#### Parámetros:

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| **Tipo de Trigger** | Select | **Sí** | Método de activación (tiempo, sol, luz, entidad) |
| **Hora de Activación** | Time | Condicional | Hora específica (solo si tipo = tiempo) |
| **Elevación Solar** | Number | Condicional | Ángulo del sol en grados (solo si tipo = elevación solar) |
| **Sensor de Luz Ambiental** | Entity | Condicional | Sensor de lux (solo si tipo = luz ambiental) |
| **Umbral de Luz Ambiental** | Number | Condicional | Nivel de luz en lux para activar |
| **Entidad Trigger** | Entity | Condicional | Entidad a monitorear (solo si tipo = entidad) |

#### Opciones de Tipo de Trigger:

1. **Tiempo específico** 🕐
   - Se activa a una hora determinada cada día
   - Ejemplo: `18:00:00` para activar todos los días a las 6 PM

2. **Elevación Solar** ☀️
   - Se activa cuando el sol alcanza cierta elevación
   - Valores negativos = después del atardecer
   - Ejemplo: `-5` para activar poco después del atardecer

3. **Nivel de luz ambiental** 💡
   - Se activa cuando un sensor de luz detecta oscuridad
   - Ejemplo: `100 lux` para activar cuando hay poca luz

4. **Estado de entidad (ON)** ✅
   - Se activa cuando otra entidad se enciende
   - Útil para encadenar automatizaciones

5. **Estado de entidad (OFF)** ❌
   - Se activa cuando otra entidad se apaga
   - Útil para secuencias complejas

---

### 3. Configuración de Luces

La sección más importante: define **qué luces controlar** y **cómo comportarse**.

#### Parámetros Principales:

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| **Luces y Entidades para Encender** | Entity | **Sí** | Lista de luces/switches a controlar |
| **Máximo de Lámparas Encendidas** | Number | **Sí** | Límite de luces simultáneas (1-20) |
| **Orden de Encendido** | Select | **Sí** | Cómo se encenderán las luces |
| **Delay Mínimo entre Encendidos** | Number | No | Segundos mínimos entre luces (default: 5) |
| **Delay Máximo entre Encendidos** | Number | No | Segundos máximos entre luces (default: 30) |
| **Brillo** | Number | No | Porcentaje de brillo 1-100% (default: 100) |
| **Temperatura de Color** | Number | No | Kelvin 2000-6500K (default: 3000) |
| **Tiempo de Transición ON** | Number | No | Segundos de transición al encender (default: 1) |

#### 🔢 Máximo de Lámparas Encendidas (Característica Clave)

Este es el parámetro que hace único a este blueprint. Define cuántas luces pueden estar encendidas simultáneamente.

**¿Cómo funciona?**
1. El sistema enciende luces siguiendo el orden configurado
2. Cuando se alcanza el límite (ejemplo: 3 luces)
3. Antes de encender una cuarta luz, apaga automáticamente la primera que se encendió
4. Mantiene siempre el límite sin superarlo
5. Cada luz permanece encendida su tiempo aleatorio individual

**Ejemplo práctico:**
```
Luces configuradas: Sala, Cocina, Dormitorio, Baño, Pasillo (5 total)
Máximo de lámparas: 2

Secuencia:
1. T=0min: Enciende Sala
2. T=2min: Enciende Cocina (ahora hay 2 encendidas)
3. T=15min: Se apaga Sala (tiempo individual cumplido)
4. T=17min: Enciende Dormitorio (ahora hay 2: Cocina + Dormitorio)
5. T=20min: Se apaga Cocina
6. T=22min: Enciende Baño (ahora hay 2: Dormitorio + Baño)
... y así sucesivamente
```

#### Opciones de Orden de Encendido:

1. **Secuencial** 📝
   - Enciende en el orden que seleccionaste
   - Predecible y sistemático

2. **Reversa** 🔄
   - Enciende en orden inverso
   - Útil para simular diferentes patrones

3. **Aleatorio** 🎲
   - Enciende en orden al azar cada vez
   - **Recomendado**: Más natural y realista

4. **Todas al mismo tiempo** 🌟
   - Enciende todas las luces simultáneamente
   - Útil para efectos específicos

#### Configuración de Apariencia (solo para luces):

- **Brillo**: Define la intensidad de las luces
  - `100%` = Máximo brillo
  - `50%` = Media intensidad
  - `25%` = Luz tenue

- **Temperatura de Color**: Define el tono de luz
  - `2700K` = Luz cálida (amarillenta)
  - `4000K` = Luz neutra
  - `6500K` = Luz fría (azulada)

**Tip**: Usa temperaturas cálidas (2700-3000K) por la noche para simular ambientes hogareños.

---

### 4. Configuración de Duración

Define **cuánto tiempo** permanecerán encendidas las luces.

#### Parámetros:

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| **Método de Duración** | Select | **Sí** | Cómo calcular el tiempo de encendido |
| **Tiempo Mínimo ON** | Number | **Sí** | Minutos mínimos encendida cada luz |
| **Tiempo Máximo ON** | Number | **Sí** | Minutos máximos encendida cada luz |
| **Hora Más Temprana de Apagado** | Time | Condicional | Primera hora posible de apagado |
| **Hora Más Tardía de Apagado** | Time | Condicional | Última hora posible de apagado |
| **Tiempo de Transición OFF** | Number | No | Segundos de transición al apagar (default: 2) |

#### Métodos de Duración:

1. **Tiempo ON Mínimo/Máximo** ⏱️
   - Cada luz permanece encendida entre X y Y minutos
   - El tiempo se elige aleatoriamente para cada luz
   - **Ejemplo**: Min=15, Max=60 → cada luz estará encendida entre 15 y 60 minutos
   - **Recomendado**: Más flexible y natural

2. **Rango de tiempo de apagado** 🕐
   - Define ventanas horarias para apagar
   - Útil para forzar que todas las luces se apaguen antes de cierta hora
   - **Ejemplo**: Earliest=22:00, Latest=23:59 → todas las luces se apagarán entre las 10 PM y medianoche

**Recomendación**: Usa tiempos variados para mayor realismo. Por ejemplo:
```
Tiempo Mínimo: 10 minutos
Tiempo Máximo: 45 minutos
```
Esto simula que alguien está en una habitación por períodos variables.

---

### 5. Configuración de Loop

Permite **repetir la simulación** múltiples veces.

#### Parámetros:

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| **Habilitar Loop** | Boolean | No | Activa el modo de repetición |
| **Cantidad de Repeticiones** | Number | No | Veces que se repite (0 = infinito) |
| **Delay Mínimo entre Loops** | Number | No | Minutos mínimos entre repeticiones |
| **Delay Máximo entre Loops** | Number | No | Minutos máximos entre repeticiones |

#### ¿Cómo funciona el Loop?

Cuando está habilitado, la simulación completa se repite múltiples veces:

1. **Loop deshabilitado** (default):
   - La automatización se ejecuta una sola vez
   - Termina cuando todas las luces se apagan

2. **Loop habilitado con N repeticiones**:
   - La simulación se ejecuta N veces
   - Entre cada repetición hay un delay aleatorio
   - Al terminar todas las repeticiones, se activa la escena de salida (si está configurada)

3. **Loop infinito** (repeticiones = 0):
   - La simulación se repite indefinidamente
   - Solo se detiene si:
     - Desactivas manualmente la automatización
     - Se desactiva la entidad de control
     - Ya no se cumplen las condiciones (ej: alguien llega a casa)

#### Ejemplo de Configuración:

**Escenario**: Quieres simular presencia durante toda la noche

```yaml
Habilitar Loop: Sí
Cantidad de Repeticiones: 5
Delay Mínimo entre Loops: 5 minutos
Delay Máximo entre Loops: 15 minutos
```

**Resultado**:
- La secuencia completa de luces se ejecuta
- Espera entre 5-15 minutos
- La secuencia se ejecuta nuevamente
- Se repite 5 veces en total
- Duración total estimada: 3-6 horas (depende de tus otros ajustes)

**Uso típico**:
- **Loop infinito**: Para toda la noche mientras estás de vacaciones
- **3-5 repeticiones**: Para una tarde/noche
- **1-2 repeticiones**: Para probar o eventos cortos

---

### 6. Escena de Salida

Configura un estado final cuando termina toda la simulación.

#### Parámetros:

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| **Habilitar Escena de Salida** | Boolean | No | Activa la escena al finalizar |
| **Escena de Salida** | Scene | Condicional | Escena de Home Assistant a activar |

#### ¿Cuándo se activa?

La escena de salida se activa **solo** cuando:
1. El loop está habilitado Y
2. Se completaron todas las repeticiones configuradas

Si el loop está deshabilitado o es infinito, la escena NO se activará automáticamente.

#### Usos comunes:

1. **Apagar todo** 💤
   ```yaml
   Crear una escena llamada "Apagar todas las luces"
   Configurar: Todas las luces en OFF
   ```

2. **Modo nocturno** 🌙
   ```yaml
   Crear escena "Luz nocturna"
   Configurar: Solo luz del pasillo al 10% de brillo
   ```

3. **Seguridad** 🔒
   ```yaml
   Crear escena "Luces exteriores"
   Configurar: Luces de entrada encendidas, interiores apagadas
   ```

4. **Retorno a estado normal** 🏠
   ```yaml
   Crear escena "Iluminación habitual"
   Configurar: Tus luces en el estado que normalmente tienen
   ```

#### Cómo crear una escena:

1. Ve a **Configuración** → **Automatizaciones y Escenas** → **Escenas**
2. Haz clic en **Agregar Escena**
3. Dale un nombre descriptivo
4. Configura el estado que deseas para cada entidad
5. Guarda la escena
6. Selecciónala en este blueprint

---

### 7. Días de la Semana

Restringe la automatización a días específicos.

#### Parámetros:

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| **Días de la Semana** | Multi-select | No | Días en los que se ejecutará |

#### Opciones:
- Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo

#### Ejemplos de uso:

1. **Solo fines de semana**:
   ```
   Seleccionar: Sábado, Domingo
   ```

2. **Solo días laborables**:
   ```
   Seleccionar: Lunes, Martes, Miércoles, Jueves, Viernes
   ```

3. **Todos los días** (default):
   ```
   Seleccionar: Todos
   ```

**Tip**: Combina esto con el control por zona para simular tu rutina. Por ejemplo, activa la simulación en días laborables cuando sales a trabajar.

---

### 8. Condiciones Globales

Agrega condiciones personalizadas adicionales.

#### Parámetro:

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| **Condiciones Adicionales** | Condition | No | Condiciones YAML personalizadas |

Este campo te permite agregar cualquier condición que Home Assistant soporte.

#### Ejemplos:

1. **Solo cuando hace mal tiempo**:
   ```yaml
   - condition: state
     entity_id: weather.home
     state: 'rainy'
   ```

2. **Solo si la temperatura exterior es baja**:
   ```yaml
   - condition: numeric_state
     entity_id: sensor.outdoor_temperature
     below: 10
   ```

3. **Solo si un sensor de movimiento no detecta nada**:
   ```yaml
   - condition: state
     entity_id: binary_sensor.motion_sensor
     state: 'off'
     for:
       minutes: 30
   ```

---

## Ejemplos de Uso

### Ejemplo 1: Simulación Básica durante Vacaciones

**Escenario**: Estarás de vacaciones 2 semanas y quieres simular presencia todas las noches.

**Configuración**:
```yaml
Control de Automatización:
  Fecha de Inicio: 2025-12-15
  Fecha de Fin: 2025-12-29
  Control por Zona: zone.home
  Personas a Rastrear: [person.yo, person.pareja]

Triggers:
  Tipo: Elevación Solar
  Elevación Solar: -5 (poco después del atardecer)

Luces:
  Entidades: [light.sala, light.cocina, light.dormitorio, light.bano, light.pasillo]
  Máximo de Lámparas: 2
  Orden: Aleatorio
  Delay Mínimo: 10s
  Delay Máximo: 60s
  Brillo: 80%
  Temperatura: 2800K
  Transición ON: 2s

Duración:
  Método: Tiempo ON Mínimo/Máximo
  Mínimo: 15 min
  Máximo: 45 min
  Transición OFF: 3s

Loop:
  Habilitar: Sí
  Repeticiones: 8
  Delay Mínimo: 3 min
  Delay Máximo: 10 min

Escena de Salida:
  Habilitar: Sí
  Escena: scene.apagar_todo

Días: Todos los días
```

**Resultado**:
- Se activa cada noche al atardecer (solo si nadie está en casa)
- Durante ~4-6 horas simula actividad
- Máximo 2 luces encendidas simultáneamente
- Cada luz está entre 15-45 minutos encendida
- Se repite 8 ciclos completos
- Al final apaga todo

---

### Ejemplo 2: Simulación Simple para Salida Nocturna

**Escenario**: Sales a cenar y volverás en 3-4 horas.

**Configuración**:
```yaml
Control de Automatización:
  Entidad de Control: input_boolean.cena_fuera

Triggers:
  Tipo: Estado de entidad (ON)
  Entidad: input_boolean.cena_fuera

Luces:
  Entidades: [light.sala, light.cocina, light.entrada]
  Máximo de Lámparas: 1
  Orden: Aleatorio
  Brillo: 70%

Duración:
  Método: Tiempo ON Mínimo/Máximo
  Mínimo: 20 min
  Máximo: 40 min

Loop:
  Habilitar: Sí
  Repeticiones: 3
  Delay Mínimo: 5 min
  Delay Máximo: 10 min

Escena de Salida:
  Habilitar: Sí
  Escena: scene.luz_entrada_minima
```

**Uso**:
1. Activa `input_boolean.cena_fuera` antes de salir
2. La simulación comienza inmediatamente
3. Se repite 3 veces (~2-3 horas total)
4. Al terminar deja solo luz de entrada tenue
5. Cuando llegues, desactiva el input_boolean

---

### Ejemplo 3: Simulación de Rutina Laboral

**Escenario**: Trabajas fuera de casa en días laborables y quieres simular que alguien está en casa.

**Configuración**:
```yaml
Control de Automatización:
  Control por Zona: zone.home
  Personas: [person.yo]

Triggers:
  Tipo: Tiempo específico
  Hora: "09:00:00"

Luces:
  Entidades: [light.oficina, light.sala, light.cocina]
  Máximo de Lámparas: 1
  Orden: Secuencial

Duración:
  Mínimo: 30 min
  Máximo: 90 min

Loop:
  Habilitar: Sí
  Repeticiones: 4
  Delay: 10-20 min

Escena de Salida:
  Habilitar: Sí
  Escena: scene.casa_vacia

Días: Lunes a Viernes
```

**Resultado**:
- Se activa a las 9 AM en días laborables
- Solo si no estás en casa
- Simula actividad durante ~4-6 horas
- Al terminar configura estado "casa vacía"

---

### Ejemplo 4: Simulación Ultra-Realista para Viaje Largo

**Escenario**: Viaje de 1 mes, máxima simulación de presencia.

**Configuración**:
```yaml
Control de Automatización:
  Entidad de Control: input_boolean.vacation_mode
  Fecha Inicio: 2026-01-10
  Fecha Fin: 2026-02-10
  Control por Zona: zone.home

Triggers:
  Tipo: Elevación Solar
  Elevación: -3

Luces:
  Entidades: [light.sala, light.cocina, light.dormitorio1, light.dormitorio2, 
             light.bano, light.pasillo, light.estudio, light.comedor]
  Máximo: 3
  Orden: Aleatorio
  Delay Min: 5s
  Delay Max: 120s
  Brillo: Random entre automaciones (usa diferentes)
  Temperatura: 2800K
  Transición: 5s

Duración:
  Mínimo: 10 min
  Máximo: 60 min
  Transición OFF: 5s

Loop:
  Habilitar: Sí
  Repeticiones: 0 (infinito)
  Delay Min: 1 min
  Delay Max: 8 min

Escena de Salida:
  No habilitada (loop infinito)

Días: Todos

Condiciones Globales:
  - Hora entre 18:00 y 01:00
```

**Resultado**:
- Activo todo el mes cuando no estés en casa
- Se ejecuta cada noche de 6 PM a 1 AM
- Hasta 3 luces simultáneas
- Comportamiento muy variado y natural
- Diferentes duraciones y delays aleatorios

---

## Preguntas Frecuentes

### ¿Cuál es la diferencia con el blueprint original de Blackshome?

Las principales diferencias son:

1. **Control de lámparas simultáneas**: Limitas cuántas luces pueden estar encendidas al mismo tiempo
2. **Sistema de apagado inteligente**: Apaga automáticamente luces viejas cuando se alcanza el límite
3. **Modo loop mejorado**: Repeticiones configurables con delays aleatorios
4. **Escena de salida**: Estado final configurable
5. **Documentación en español**: Guía completa en castellano

### ¿Funciona con switches y enchufes, no solo luces?

Sí, puedes seleccionar cualquier entidad que se pueda encender/apagar:
- Luces (`light.*`)
- Switches (`switch.*`)
- Enchufes inteligentes
- Cualquier dispositivo compatible

**Nota**: Los ajustes de brillo, color y temperatura solo aplicarán a entidades `light.*`.

### ¿Cuánta energía consume esto?

Depende de tus configuraciones. El parámetro "Máximo de lámparas encendidas" te ayuda a controlar esto:

- **Máximo = 1**: Muy eficiente, solo 1 luz a la vez
- **Máximo = 2-3**: Balance entre realismo y eficiencia
- **Máximo = 5+**: Más realista pero mayor consumo

**Tip**: Usa bombillas LED de bajo consumo para minimizar el gasto.

### ¿Puedo tener múltiples automatizaciones con este blueprint?

¡Sí! Puedes crear varias automatizaciones basadas en este blueprint para diferentes escenarios:

1. **Automatización 1**: Planta baja, activación al atardecer
2. **Automatización 2**: Planta alta, activación más tarde
3. **Automatización 3**: Luces exteriores, activación diferente

Cada una con sus propias configuraciones independientes.

### ¿Se puede activar manualmente sin esperar el trigger?

Sí, tienes varias opciones:

1. **Usar un input_boolean como trigger**:
   ```yaml
   Tipo de Trigger: Estado de entidad (ON)
   Entidad: input_boolean.activar_simulacion
   ```

2. **Ejecutar manualmente** desde la interfaz:
   - Ve a Automatizaciones
   - Encuentra tu automatización
   - Haz clic en "Ejecutar"

3. **Crear un script** que active la automatización

### ¿Qué pasa si llego a casa mientras la automatización está activa?

Si configuraste el "Control por Zona" con personas, la automatización se detendrá automáticamente cuando detecte que alguien llegó a casa.

**Cómo funciona**:
1. La automatización se ejecuta cada X minutos (según tus loops)
2. Antes de cada repetición, verifica las condiciones
3. Si detecta que alguien está en casa, se detiene
4. No se ejecuta la escena de salida

**Recomendación**: Usa `mode: restart` (ya incluido) para que se reinicie limpiamente.

### ¿Cómo pruebo la configuración sin esperar horas?

Para pruebas rápidas, usa estos valores:

```yaml
Duración:
  Mínimo: 1 min
  Máximo: 2 min

Loop:
  Habilitar: Sí
  Repeticiones: 2
  Delay Mínimo: 0 min
  Delay Máximo: 1 min

Luces:
  Delay entre encendidos: 5-10 segundos
```

Esto te dará un ciclo completo en ~5-10 minutos para verificar que todo funciona correctamente.

**Después de probar, ajusta a valores realistas para uso real.**

### ¿Puedo usar diferentes brillos/colores para cada luz?

En la versión actual, todos los ajustes de brillo y color se aplican a todas las luces por igual.

**Alternativa**: Crea múltiples automatizaciones con diferentes grupos de luces y diferentes configuraciones.

### ¿El modo loop infinito (0 repeticiones) consumirá recursos?

No significativamente. Home Assistant está optimizado para este tipo de automatizaciones. El loop infinito:
- Solo se ejecuta cuando se cumplen las condiciones
- Tiene delays entre iteraciones
- Se detiene si se desactiva cualquier condición
- No sobrecarga el sistema

### ¿Funciona con Zigbee, Z-Wave, WiFi?

Sí, es agnóstico al protocolo. Funciona con cualquier luz o dispositivo que Home Assistant pueda controlar:
- Zigbee
- Z-Wave
- WiFi (Tuya, Shelly, etc.)
- Bluetooth
- Cualquier integración de Home Assistant

---

## Solución de Problemas

### Las luces no se encienden

**Verificar**:
1. ✅ La automatización está habilitada
2. ✅ La entidad de control (si la usas) está en ON
3. ✅ El día actual está en la lista de "Días de la semana"
4. ✅ Las fechas de inicio/fin incluyen hoy
5. ✅ Las condiciones de zona/personas se cumplen
6. ✅ El trigger se activó (revisa el historial)

**Depuración**:
```yaml
1. Ve a Configuración → Automatizaciones
2. Encuentra tu automatización
3. Haz clic en "Ejecutar" para probar manualmente
4. Revisa los logs en Configuración → Sistema → Logs
```

### Se encienden más luces del límite configurado

**Posibles causas**:
1. El parámetro "Orden de Encendido" está en "Todas al mismo tiempo"
   - **Solución**: Cambia a "Secuencial", "Reversa" o "Aleatorio"

2. Otras automatizaciones están encendiendo luces
   - **Solución**: Desactiva temporalmente otras automatizaciones para probar

3. Intervención manual (alguien enciende luces manualmente)
   - **Solución**: Esto es normal, el blueprint no apaga luces encendidas manualmente

### Las luces se apagan demasiado rápido

**Causa**: Los tiempos de duración son muy cortos

**Solución**:
```yaml
Duración:
  Tiempo Mínimo: Aumentar (ej: 20 min)
  Tiempo Máximo: Aumentar (ej: 60 min)
```

### Las luces se quedan encendidas después de la simulación

**Posibles causas**:

1. **No configuraste escena de salida**
   - **Solución**: Crea una escena que apague todo y configúrala

2. **El loop es infinito**
   - **Solución**: Cambia `Repeticiones: 0` a un número específico

3. **La automatización se detuvo inesperadamente**
   - **Solución**: Verifica los logs

**Solución rápida**: Crea una escena "Apagar todo" y actívala manualmente:
```yaml
1. Ve a Configuración → Escenas
2. Crea nueva escena
3. Configura todas las luces en OFF
4. Guarda como "Apagar Todo"
5. Actívala manualmente cuando necesites
```

### El loop no se repite

**Verificar**:
1. ✅ "Habilitar Loop" está activado
2. ✅ "Cantidad de Repeticiones" es mayor a 1 (o 0 para infinito)
3. ✅ Las condiciones se siguen cumpliendo entre loops
4. ✅ No llegaste a la fecha de fin

**Nota**: Si alguna condición deja de cumplirse (ej: alguien llega a casa), el loop se detendrá.

### La escena de salida no se activa

**Causa más común**: El loop es infinito (repeticiones = 0)

La escena de salida **solo se activa** cuando:
- Loop está habilitado
- Se completaron TODAS las repeticiones configuradas
- Repeticiones debe ser un número específico (1, 2, 3, etc.), no 0

**Solución**: Cambia de loop infinito a un número específico de repeticiones.

### Errores en los logs

**Error común**: "Template Error"

**Causa**: Configuración incorrecta de sensores o entidades

**Solución**:
1. Revisa que todas las entidades existan
2. Verifica que los sensores de luz ambiental devuelvan valores numéricos
3. Asegúrate de que las entidades de trigger estén disponibles

### La automatización se ejecuta en momentos inesperados

**Verificar**:
1. El tipo de trigger seleccionado
2. Las condiciones de zona/personas
3. Los días de la semana configurados
4. Las condiciones globales

**Tip depuración**: Activa el "Trace" de la automatización:
```
1. Edita tu automatización
2. Menú (⋮) → Trace
3. Ejecuta la automatización
4. Revisa cada paso para ver dónde falla
```

---

## Créditos

### Autor Original
Este blueprint está basado en el excelente trabajo de **Blackshome**:
- Blueprint original: [Holiday & Away Lighting](https://gist.github.com/Blackshome/0a34870755762bcb9fab159d5b94fd25)
- Comunidad Home Assistant: [Discusión y FAQ](https://community.home-assistant.io/t/871550)

### Modificaciones - PezAustral Presence Simulation
**Versión**: 1.0  
**Fecha**: Noviembre 2025  
**Autor**: PezAustral

**Nuevas características agregadas**:
- ✅ Control de lámparas simultáneas con límite configurable
- ✅ Sistema de apagado inteligente en paralelo
- ✅ Modo loop con repeticiones configurables
- ✅ Delays aleatorios entre loops
- ✅ Escena de salida configurable
- ✅ Documentación completa en español

### Contribuir

¿Encontraste un bug o tienes una sugerencia? Contribuciones bienvenidas:
- Reporta issues
- Sugiere mejoras
- Comparte tus configuraciones

### Licencia

Este proyecto mantiene la licencia del blueprint original.

### Agradecimientos

- A **Blackshome** por el blueprint original que sirvió de base
- A la comunidad de **Home Assistant** por el soporte continuo
- A todos los que prueben y mejoren este blueprint

---

## Changelog

### Versión 1.0 (Noviembre 2025)
- ✨ Primera versión pública
- ✅ Control de lámparas simultáneas
- ✅ Sistema de apagado inteligente
- ✅ Modo loop configurable
- ✅ Escena de salida
- ✅ Documentación completa en español

---

## Soporte

¿Necesitas ayuda? Tienes varias opciones:

1. **Documentación**: Revisa esta guía completa
2. **Ejemplos**: Revisa la sección de ejemplos de uso
3. **FAQ**: Revisa las preguntas frecuentes
4. **Comunidad**: Comparte en foros de Home Assistant

---

## Notas Finales

Este blueprint fue diseñado para ser **flexible, potente y fácil de usar**. Las configuraciones por defecto están pensadas para un uso típico, pero siéntete libre de experimentar y ajustar a tus necesidades.

**Recuerda**:
- Prueba primero con tiempos cortos
- Ajusta gradualmente a tu gusto
- Usa el límite de lámparas para eficiencia
- El modo aleatorio es más realista
- Los loops son perfectos para simulaciones largas

¡Disfruta de tu nuevo sistema de simulación de presencia! 🏠✨

---

*Documento creado para PezAustral Presence Simulation v1.0*  
*Última actualización: Noviembre 2025*

