# Problema de Voltaje - Smart Node V2

**Fecha:** 2 de enero de 2026
**Detectado por:** Usuario (medición con tester)
**Estado:** Documentado - Solución temporal aplicada

---

## 🔴 Problema Detectado

### Medición Real:
```
Batería 18650: 3.4V (descargada ~20%)
TP4056 OUT+: 3.4V
ESP32 VIN: 3.4V
Resultado: ESP32 NO FUNCIONA
```

### Causa Raíz:

El **TP4056 NO es un regulador de voltaje**, solo pasa el voltaje de la batería directamente:

```
Batería → TP4056 OUT+ → ESP32 VIN → Regulador AMS1117 → 3.3V
                                           ↓
                                    Necesita ≥4.5V
                                    Recibe 3.4V
                                           ↓
                                    ❌ NO PUEDE REGULAR
```

**El regulador interno del ESP32 (AMS1117):**
- **Voltaje mínimo:** 4.5V (especificación)
- **Voltaje práctico:** 4.0-5.5V (funciona pero fuera de spec)
- **Con 3.4V:** No puede generar 3.3V estables → ESP32 no funciona

---

## 📊 Análisis de Voltajes

### Voltaje de Batería vs Funcionamiento

| Voltaje Batería | Estado Carga | TP4056 OUT | ESP32 Funciona | Notas |
|-----------------|--------------|------------|----------------|-------|
| **4.2V** | 100% | 4.2V | ✅ SÍ | Óptimo (justo al límite) |
| **4.0V** | 80% | 4.0V | ✅ SÍ | Funcional pero al límite |
| **3.7V** | 50% | 3.7V | ⚠️ Inestable | Puede resetear, WiFi inestable |
| **3.5V** | 30% | 3.5V | ⚠️ Muy inestable | Resets frecuentes |
| **3.4V** | 20% | 3.4V | ❌ NO | No enciende o bootloop |
| **3.0V** | 0% | 3.0V | ❌ NO | No funciona |

### Rangos de Operación

```
Voltaje Óptimo:    [4.0V ═══════════════════ 4.2V]  ✅
Voltaje Funcional: [3.8V ──────── 4.2V]            ⚠️
Voltaje Crítico:   [3.5V ─── 3.8V]                 🔴
No Funciona:       [3.0V ─── 3.5V]                 ❌
```

---

## ⚡ Soluciones

### Solución 1: Cargar Batería (TEMPORAL)

**Descripción:** Mantener batería siempre >4.0V

**Implementación:**
1. Cargar batería hasta 4.2V (LED azul en TP4056)
2. Usar dispositivo hasta ~3.8V
3. Recargar (autonomía: ~8-10 horas útiles)

**Pros:**
- ✅ No requiere cambios de hardware
- ✅ Funciona con setup actual

**Contras:**
- ❌ Autonomía reducida (solo 60-70% de batería utilizable)
- ❌ Desperdicio de energía en regulador
- ❌ No funciona cuando batería <3.8V

---

### Solución 2: Agregar Módulo Boost (RECOMENDADO)

**Descripción:** Convertir 3.0-4.2V → 5V estable

**Módulo:** MT3608 o similar
- Entrada: 2-24V
- Salida: 5V (ajustable)
- Eficiencia: ~93%
- Costo: ~$1 USD

**Diagrama:**
```
[Batería 18650]
      ↓
[TP4056 OUT+/OUT-]
      ↓
[MT3608 Boost]  ← Configurar salida a 5V
  IN+  IN-
   ↓    ↓
[OUT+ OUT-]
   ↓    ↓
[ESP32 VIN / GND]
```

**Pros:**
- ✅ Funciona con batería 3.0-4.2V (100% utilizable)
- ✅ Voltaje estable 5V siempre
- ✅ Mayor autonomía (13-17 horas)
- ✅ Protección para ESP32

**Contras:**
- ❌ Requiere componente adicional
- ❌ Más espacio en PCB
- ❌ Levemente más complejo

**Implementación:**
1. Comprar módulo MT3608
2. Ajustar potenciómetro para salida de 5.0V
3. Conectar:
   - TP4056 OUT+ → MT3608 IN+
   - TP4056 OUT- → MT3608 IN-
   - MT3608 OUT+ → ESP32 VIN
   - MT3608 OUT- → ESP32 GND

---

### Solución 3: Conexión Directa a 3V3 (AVANZADO)

**Descripción:** Bypass del regulador interno ESP32

**Diagrama:**
```
[Batería 18650]
      ↓
[TP4056 OUT+]
      ↓
[Regulador 3.3V Externo]  ← AMS1117-3.3V o LD1117-3.3V
      ↓
[ESP32 pin 3V3] (NO VIN)
```

**Pros:**
- ✅ Máxima eficiencia (sin doble regulación)
- ✅ Menor desperdicio de energía
- ✅ Máxima autonomía

**Contras:**
- ❌ Requiere regulador externo
- ❌ MÁS componentes
- ❌ Requiere bypass del regulador interno (peligroso)
- ❌ No recomendado para principiantes

---

## 🔧 Mejoras para V3

### Hardware Recomendado para Próxima Versión:

#### Opción A: Módulo Todo-en-uno
```
Usar módulo: "18650 Shield for ESP32"
- Incluye TP4056 + Boost a 5V + Protección
- Plug & play
- Voltaje estable garantizado
```

#### Opción B: PCB Personalizada
```
Integrar en PCB:
1. TP4056 (cargador)
2. MT3608 (boost a 5V)
3. Protección batería
4. Conector JST para batería
```

#### Opción C: LiPo con Regulador Integrado
```
Usar módulo: "Adafruit PowerBoost 1000C"
- Carga batería LiPo/Li-Ion
- Boost a 5V automático
- Indicador de batería
- Salida USB 5V/1A
```

---

## 📈 Comparación de Soluciones

| Criterio | Setup Actual | + Módulo Boost | + PowerBoost 1000C |
|----------|--------------|----------------|-------------------|
| **Voltaje mínimo funcional** | 3.8V | 3.0V | 2.7V |
| **Autonomía utilizable** | 60-70% | 100% | 100% |
| **Tiempo operación (2600mAh)** | 8-10h | 13-17h | 13-17h |
| **Estabilidad voltaje** | Variable | 5V fijo | 5V fijo |
| **Costo adicional** | $0 | ~$1 | ~$20 |
| **Complejidad** | Baja | Media | Baja |
| **Recomendado para** | Pruebas | Producción | Proyecto final |

---

## ✅ Plan de Implementación

### Fase 1: Inmediato (Hoy)
- [x] Cargar batería a 4.2V
- [ ] Probar funcionamiento con batería cargada
- [ ] Documentar autonomía real

### Fase 2: Corto Plazo (Esta Semana)
- [ ] Comprar módulo MT3608
- [ ] Probar boost converter en protoboard
- [ ] Medir eficiencia y autonomía
- [ ] Actualizar diagrama si funciona bien

### Fase 3: Mediano Plazo (Próximas Semanas)
- [ ] Diseñar PCB con boost integrado
- [ ] Agregar indicador LED de batería baja
- [ ] Implementar sensor de voltaje de batería en código
- [ ] Alertas en Home Assistant cuando batería <3.5V

---

## 🧪 Pruebas a Realizar

### Con Setup Actual (Batería Cargada)
```
1. Cargar batería a 4.2V
2. Desconectar USB
3. Medir cada 30 minutos:
   - Voltaje batería
   - ¿ESP32 funciona? (ping)
   - ¿Sensores reportan a HA?
4. Anotar voltaje cuando ESP32 deja de funcionar
```

### Con Módulo Boost (Futuro)
```
1. Descargar batería a 3.0V
2. Conectar boost (salida 5V)
3. Verificar ESP32 funciona
4. Medir autonomía completa (hasta 3.0V)
```

---

## 📝 Lecciones Aprendidas

### Error en Documentación Original:
```
❌ INCORRECTO: "TP4056 OUT+ → ESP32 VIN | Alimentación 5V"
✅ CORRECTO: "TP4056 OUT+ → ESP32 VIN | Voltaje batería (3.0-4.2V)"
```

### Asunción Incorrecta:
Se asumió que:
- TP4056 regulaba voltaje a 5V
- ESP32 podía funcionar con voltaje de batería directamente

**Realidad:**
- TP4056 solo carga, no regula salida
- ESP32 necesita >4.0V en VIN para funcionar confiablemente
- Regulador interno AMS1117 tiene dropout de ~1.2V

### Importancia de Mediciones:
✅ **El tester reveló el problema real**
- Sin medición, se hubiera pensado en WiFi, código, etc.
- Con medición, se identificó problema de hardware inmediatamente

---

## 🔗 Referencias

- [Datasheet TP4056](https://www.alldatasheet.com/datasheet-pdf/pdf/201624/ETC1/TP4056.html)
- [ESP32 Power Supply Requirements](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/hw-reference/esp32/get-started-devkitc.html#power-supply-options)
- [AMS1117 Voltage Regulator Datasheet](https://www.advanced-monolithic.com/pdf/ds1117.pdf)
- [MT3608 Boost Converter](https://www.olimex.com/Products/Breadboarding/BB-PWR-3608/resources/MT3608.pdf)

---

## 📞 Recomendación Final

**Para el usuario AHORA:**
1. ✅ Cargar batería a 4.2V
2. ✅ Probar funcionamiento
3. ✅ Usar dispositivo hasta ~3.8V
4. ✅ Recargar antes de que baje de 3.8V

**Para V3 del Smart Node:**
1. 🎯 Agregar módulo boost MT3608
2. 🎯 Sensor de voltaje de batería en código
3. 🎯 Alertas cuando batería <3.7V
4. 🎯 PCB integrada con todo incluido

---

**Estado:** Problema identificado y documentado
**Solución temporal:** Cargar batería
**Solución permanente:** Módulo boost (V3)
**Última actualización:** 2 de enero de 2026



