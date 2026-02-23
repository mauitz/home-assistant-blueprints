# LightNode - Consideraciones Térmicas
## Gestión de Calor y Precisión de Sensores

> ⚠️ **NOTA IMPORTANTE**: Este documento se conserva como referencia técnica. El sensor DHT11 fue **eliminado del diseño final** del LightNode (versión 1.2, 2026-01-20). El análisis térmico sigue siendo válido para entender el comportamiento del ESP32 y otros componentes.

> **Problema original**: Los componentes electrónicos generan calor que puede afectar las lecturas de sensores de temperatura como el DHT11.

---

## 🔥 FUENTES DE CALOR EN EL SISTEMA

### 1. ESP32 - Fuente Principal

**Disipación de potencia**:
- Consumo típico: 160-260mA @ 3.3V
- Potencia disipada: **0.5-0.9W**
- Temperatura del chip: +15-25°C sobre ambiente (operación normal)
- Con WiFi activo: +20-30°C sobre ambiente
- En carga alta (procesamiento): hasta +40-50°C sobre ambiente

**Zona de influencia térmica**:
- Radio crítico: **5cm** (error >2°C)
- Radio de impacto: **10cm** (error 1-2°C)
- Seguro: **>15cm** (error <0.5°C)

### 2. Transistores BC337 - Fuente Secundaria

**Con configuración actual** (R2=34Ω, R4=30Ω):
- Corriente por canal: ~120-127mA
- Vce saturación: 0.7V
- Potencia disipada por transistor: **0.09W** (90mW)
- Temperatura: +5-10°C sobre ambiente
- Caliente al tacto pero no crítico

**Zona de influencia térmica**:
- Radio crítico: **3cm** (error >1°C)
- Seguro: **>5cm** (error despreciable)

### 3. Guirnaldas LED

**Impacto térmico**:
- Los LEDs generan calor pero están **alejados** del protoboard
- No afectan lecturas del DHT11
- ✅ Sin preocupaciones térmicas

---

## 📊 TABLA DE IMPACTO TÉRMICO

| Distancia DHT11 | Desde ESP32 | Desde BC337 | Error Esperado | Estado |
|-----------------|-------------|-------------|----------------|---------|
| 0-3cm | 🔴 Crítico | 🔴 Crítico | +3-5°C | ❌ No usar |
| 3-5cm | 🟠 Alto | 🟡 Moderado | +2-3°C | ⚠️ Compensar |
| 5-10cm | 🟡 Moderado | 🟢 Bajo | +1-2°C | ⚠️ Calibrar |
| 10-15cm | 🟢 Bajo | ✅ Despreciable | +0.5-1°C | ✅ Aceptable |
| >15cm | ✅ Despreciable | ✅ Despreciable | <0.5°C | ✅ Óptimo |

---

## 🎯 SOLUCIONES RECOMENDADAS

### Solución A: Layout Térmico Optimizado (SIMPLE)

**Descripción**: Organizar componentes en la protoboard maximizando distancia térmica.

```
Protoboard Vista Superior (830 puntos)

Fila 1-5:    [DHT11]  [LDR]      [LD2410C]
             ↑
             Sensores de ambiente en zona fría
             
Fila 6-10:   (espacio vacío - barrera térmica)

Fila 11-25:       ┌─────────┐
                  │  ESP32  │
             [Q1] │ (CALOR) │ [Q2]
                  └─────────┘
             ↑
             Zona caliente
             
Fila 26-30:  [R2]            [R4]
              |               |
           [LED L]        [LED R]
```

**Características**:
- ✅ Distancia DHT11↔ESP32: >10cm (depende de protoboard)
- ✅ Convección natural ayuda (calor sube)
- ✅ No requiere cables adicionales
- ✅ Fácil de montar

**Medición práctica**:
- En protoboard 830pts: ~12-15cm de separación real
- Error térmico esperado: **<1°C**

### Solución B: DHT11 Externo (ÓPTIMA)

**Descripción**: Conectar el DHT11 mediante cables Dupont fuera del protoboard.

```
                    [DHT11]  ← En ubicación real de medición
                       |
                    ┌──┴──┐
                    │     │  Cables Dupont 10-15cm
                    │ VCC │  (rojo)
                    │ DAT │  (verde/amarillo)
                    │ GND │  (negro)
                    └──┬──┘
                       ↓
               ┌─────────────┐
               │  Protoboard │
               │   ESP32     │
               └─────────────┘
```

**Ventajas**:
- ✅ **Máxima precisión** de medición
- ✅ Mide temperatura **donde realmente importa**
- ✅ Independiente del calor del circuito
- ✅ Solo requiere 3 cables Dupont

**Desventajas**:
- ⚠️ Cables pueden soltarse
- ⚠️ Menos compacto

**Implementación**:
1. Conexiones en ESP32:
   - GPIO 27 → DHT11 DATA (cable verde)
   - 3.3V → DHT11 VCC (cable rojo)
   - GND → DHT11 GND (cable negro)
2. Longitud de cable: 10-20cm recomendado
3. Fijar DHT11 con cinta adhesiva o soporte impreso 3D

### Solución C: Compensación por Software (ÚLTIMA OPCIÓN)

**Descripción**: Si no puedes alejar el DHT11, corrige por código.

**Código ESPHome**:

```yaml
sensor:
  # Sensor DHT11 - lectura cruda (no exponer a HA)
  - platform: dht
    pin: GPIO27
    model: DHT11
    update_interval: 60s
    
    temperature:
      name: "Temperatura Raw"
      id: temp_raw
      internal: true  # No mostrar en Home Assistant
      accuracy_decimals: 1
      
    humidity:
      name: "Humedad Pasillo"
      accuracy_decimals: 0
  
  # Temperatura compensada (esta SÍ se expone a HA)
  - platform: template
    name: "Temperatura Pasillo"
    id: temp_compensada
    lambda: |-
      if (id(temp_raw).has_state()) {
        // Ajustar offset según tu calibración
        float offset = 1.5;  // °C a restar
        return id(temp_raw).state - offset;
      } else {
        return {};  // Sin valor aún
      }
    unit_of_measurement: "°C"
    device_class: "temperature"
    state_class: "measurement"
    accuracy_decimals: 1
    update_interval: 60s
```

**Procedimiento de calibración**:

1. **Preparar referencia**:
   - Usa termómetro digital calibrado
   - Colócalo **al lado** del montaje (no encima)
   - Espera 30 minutos para estabilización

2. **Tomar medidas** (3-5 muestras):
   ```
   Hora    | Termómetro Ref. | DHT11 Raw | Diferencia
   --------|-----------------|-----------|------------
   10:00   | 22.0°C         | 23.5°C    | +1.5°C
   14:00   | 25.0°C         | 26.3°C    | +1.3°C
   18:00   | 21.5°C         | 22.8°C    | +1.3°C
   --------|-----------------|-----------|------------
   Promedio offset: +1.4°C
   ```

3. **Configurar offset**:
   - Usa el promedio: `float offset = 1.4;`
   - Actualiza código ESPHome
   - Recompila y carga firmware

4. **Verificar precisión**:
   - Compara nuevamente con termómetro
   - Ajusta offset si es necesario
   - Objetivo: error <0.5°C

---

## 🧪 PRUEBAS Y VALIDACIÓN

### Test 1: Temperatura en Reposo

**Objetivo**: Verificar calentamiento con sistema encendido pero LEDs apagados.

**Procedimiento**:
1. Enciende el LightNode
2. Apaga ambas guirnaldas (PWM = 0%)
3. Espera 20 minutos
4. Compara DHT11 vs termómetro de referencia

**Resultado esperado**:
- Error <1°C → ✅ Layout correcto
- Error 1-2°C → ⚠️ Considera alejar DHT11
- Error >2°C → 🔴 Reubicación necesaria

### Test 2: Temperatura con Carga

**Objetivo**: Verificar calentamiento con LEDs al máximo.

**Procedimiento**:
1. Enciende ambas guirnaldas al 100%
2. Espera 30 minutos
3. Compara temperaturas

**Resultado esperado**:
- BC337 calientes al tacto (+5-10°C)
- ESP32 tibio (+20-25°C)
- Error DHT11 similar al Test 1 (los BC337 apenas influyen)

### Test 3: Estabilidad Temporal

**Objetivo**: Verificar deriva térmica a lo largo del día.

**Procedimiento**:
1. Registra temperatura cada hora por 24h
2. Compara tendencias DHT11 vs termómetro
3. Verifica que ambos sigan el mismo patrón

**Resultado esperado**:
- Ambos suben/bajan juntos → ✅ Compensación correcta
- DHT11 siempre offset constante → ✅ Compensación funciona
- DHT11 con deriva variable → 🔴 Problema de montaje

---

## 📐 DIMENSIONES PRÁCTICAS

### Protoboard 830 Puntos Estándar

**Dimensiones físicas**:
- Largo: 16.5cm
- Ancho: 5.5cm
- Área útil: ~90cm²

**Separaciones reales posibles**:

| Componente 1 | Componente 2 | Distancia Máxima | Estado Térmico |
|--------------|--------------|------------------|----------------|
| Fila 1 | Fila 10 | ~5cm | ⚠️ Justo |
| Fila 1 | Fila 20 | ~10cm | ✅ Aceptable |
| Fila 1 | Fila 30 | ~15cm | ✅ Óptimo |

**Recomendación**:
- DHT11 en filas 1-3
- ESP32 en filas 15-25
- Separación resultante: **12-15cm** → ✅ Muy bueno

---

## 🌡️ ALTERNATIVAS AL DHT11

Si la precisión térmica es crítica para tu aplicación:

### DHT22 / AM2302
- **Precisión**: ±0.5°C (vs ±2°C del DHT11)
- **Rango**: -40 a 80°C (vs 0-50°C del DHT11)
- **Precio**: ~3-5× más caro
- **Compatible**: Mismo código ESPHome (solo cambiar `model: DHT22`)
- ✅ **Recomendado** si necesitas precisión

### BME280
- **Precisión**: ±1°C
- **Extra**: Presión atmosférica
- **Conexión**: I2C (en vez de 1-wire)
- **Precio**: Moderado
- ✅ **Recomendado** para estaciones meteorológicas

### DS18B20
- **Precisión**: ±0.5°C
- **Ventaja**: Cable largo incluido (1-3m)
- **Desventaja**: Solo temperatura (sin humedad)
- **Conexión**: 1-wire
- ✅ **Recomendado** si no necesitas humedad

---

## ✅ CHECKLIST DE MONTAJE TÉRMICO

Antes de energizar el sistema:

- [ ] DHT11 está >10cm alejado del ESP32
- [ ] DHT11 está >5cm alejado de los BC337
- [ ] DHT11 tiene flujo de aire (no cubierto)
- [ ] ESP32 tiene espacio para disipar (no tapado)
- [ ] BC337 no están en contacto con otros componentes
- [ ] Protoboard tendrá ventilación en uso final

Después de energizar (20min de estabilización):

- [ ] ESP32 está tibio pero no quema al tacto
- [ ] BC337 están tibios (con LEDs encendidos)
- [ ] DHT11 reporta temperatura razonable (±2°C vs ambiente)
- [ ] Temperatura es estable (no sube continuamente)

---

## 📚 REFERENCIAS Y RECURSOS

### Datasheets
- [DHT11 Thermal Characteristics](https://www.mouser.com/datasheet/2/758/DHT11-Technical-Data-Sheet-Translated-Version-1143054.pdf) - Página 3, Operating Conditions
- [BC337 Power Dissipation](https://www.onsemi.com/pdf/datasheet/bc337-d.pdf) - Ptot = 625mW @ 25°C
- [ESP32 Thermal Management](https://www.espressif.com/sites/default/files/documentation/esp32_datasheet_en.pdf) - Sección 5.1

### Calculadoras
- **Potencia del transistor**: P = Vce × Ic
- **Temperatura estimada**: ΔT = P × Rθja (BC337: ~200°C/W en aire libre)
- **Para nuestro caso**: ΔT = 0.09W × 200 = 18°C (peor caso, en práctica ~10°C)

---

## 🎓 CONCLUSIÓN

**Para el proyecto LightNode**:

1. ✅ **El ESP32 es la fuente principal de calor** (no los BC337)
2. ✅ **Mantener DHT11 >10cm del ESP32** es suficiente
3. ✅ **Layout optimizado** en protoboard 830pts funciona bien
4. ✅ **DHT11 externo con cables** es la solución óptima si buscas máxima precisión
5. ✅ **Compensación SW** es opción válida si el layout no permite separación

**Error típico esperado con buenas prácticas**: <1°C (aceptable para domótica)

---

**Versión**: 1.0 (Referencia histórica)  
**Fecha**: 2026-01-20  
**Autor**: Documentación técnica proyecto LightNode  
**Última revisión**: 2026-01-20  
**Estado**: Documento de referencia - DHT11 eliminado del diseño final
