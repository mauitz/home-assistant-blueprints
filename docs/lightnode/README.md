# LightNode - Documentación del Proyecto

## ¿Qué es LightNode?

LightNode es un sistema de iluminación inteligente basado en ESP32 diseñado para pasillospasillo y espacios de tránsito. Detecta presencia, controla guirnaldas LED con efecto dimmer PWM, y considera el nivel de luz ambiente para automatizar la iluminación de forma eficiente.

## Características Principales

- 🎯 **Detección de presencia** mediante sensor mmWave (LD2410C)
- 💡 **Control dual de LED strips** con PWM independiente
- 🌅 **Sensor de luz ambiente** (LDR) para activación inteligente
- ✨ **Efecto de proximidad** progresivo (brillo aumenta al acercarte)
- 🎚️ **Control manual completo** con switches y dimmers independientes
- 🌙 **Modo "Solo de Noche"** con umbral configurable
- 🔌 **Alimentación simple** vía USB 5V
- 🏠 **Integración completa** con Home Assistant vía ESPHome

## Documentos del Proyecto

### 📋 [Proyecto_Pasillo_Luces_ESP32.md](./Proyecto_Pasillo_Luces_ESP32.md)
Documento principal con especificaciones técnicas, lista de componentes, arquitectura del sistema y notas de implementación.

**Contenido**:
- Objetivos y arquitectura general
- Lista completa de componentes
- Diagramas de conexión eléctrica
- Asignación de pines del ESP32
- Guía de montaje físico
- Configuración de software (ESPHome)
- Automatizaciones para Home Assistant

### 🎨 [DIAGRAMA_VISUAL_CONEXIONES.md](./DIAGRAMA_VISUAL_CONEXIONES.md)
Documento detallado para generación de diagramas visuales mediante IA. Contiene descripciones precisas del circuito para crear representaciones gráficas profesionales.

**Contenido**:
- Descripción detallada del layout del circuito
- Posición y conexión de cada componente
- Código de colores para cables
- Simbología electrónica estándar
- Tabla resumen de todas las conexiones
- Prompts optimizados para modelos de generación de imágenes

### 📦 [LISTA_MATERIALES.md](./LISTA_MATERIALES.md)
Bill of Materials (BOM) completo con todos los componentes necesarios para el montaje.

**Contenido**:
- Lista detallada de componentes electrónicos
- Especificación exacta de resistencias (incluyendo R4 = 3×10Ω)
- Material de montaje necesario
- Herramientas requeridas
- Identificación de resistencias por código de colores
- Orden de montaje sugerido
- Checklist de verificación pre-energizado

### 🎮 [GUIA_USO_CONTROLES.md](./GUIA_USO_CONTROLES.md) ⭐ NUEVO
Guía completa de uso del panel de control en Home Assistant.

**Contenido**:
- Explicación detallada de cada control
- Matriz de decisión (cuándo enciende/apaga)
- Tutorial paso a paso con ejemplos
- Casos de uso prácticos
- Troubleshooting de controles
- Logs explicados

### 🤖 [FUNCIONAMIENTO_AVANZADO.md](./FUNCIONAMIENTO_AVANZADO.md) ⭐ v2.0
Documentación del sistema de efecto proximidad y control avanzado.

**Contenido**:
- Modos de operación detallados
- Efecto de proximidad explicado
- Fórmula de interpolación
- Escenarios de uso con configuraciones
- Monitoreo y debug
- Diferencias con versión anterior

### 🎨 [INTERFAZ_MEJORADA_v2.1.md](./INTERFAZ_MEJORADA_v2.1.md) ⭐ v2.1
Documentación de mejoras de interfaz de usuario.

**Contenido**:
- Numeración y orden lógico de controles
- Iconos mejorados y descriptivos
- Sliders uniformes
- Comparación antes/después
- Instrucciones de verificación

### ⚡ [VERIFICACION_RAPIDA.md](./VERIFICACION_RAPIDA.md) 🚨 EMPIEZA AQUÍ
Guía rápida visual para diagnosticar luces que no encienden (5 min).

**Contenido**:
- 4 pasos de diagnóstico rápido
- Verificación visual de conexiones
- Pruebas simples sin herramientas
- Checklist fotográfico
- Tabla de diagnóstico rápida
- Problemas más comunes (60%+ casos)

### 🔧 [TROUBLESHOOTING_LUCES.md](./TROUBLESHOOTING_LUCES.md) 📖 GUÍA COMPLETA
Guía técnica completa de diagnóstico con multímetro.

**Contenido**:
- Procedimiento de diagnóstico paso a paso
- Verificación de conexiones físicas
- Pruebas con multímetro detalladas
- Problemas comunes y soluciones
- Checklist de verificación completo
- Mapa de voltajes esperados

### 🌡️ [CONSIDERACIONES_TERMICAS.md](./CONSIDERACIONES_TERMICAS.md)
Análisis de gestión térmica del sistema (referencia histórica).

**Contenido**:
- Análisis de fuentes de calor (ESP32 y BC337)
- Consideraciones de diseño térmico
- **Nota**: Documento conservado como referencia técnica, aunque el DHT11 fue eliminado del diseño final

## Arquitectura del Sistema

```
┌─────────────────────────────────────────────────┐
│                 LIGHTNODE SYSTEM                 │
├─────────────────────────────────────────────────┤
│                                                 │
│  [LD2410C]                         [LDR]       │
│      │                                │         │
│   GPIO32/33                        GPIO34      │
│      │                                │         │
│      └──────────┬───────────────┬────┘         │
│                 │               │               │
│           ┌─────┴─────┐         │               │
│           │   ESP32   │  ← Controlador         │
│           │  ESPHome  │                         │
│           └─────┬─────┘                         │
│                 │                               │
│        ┌────────┴────────┐                      │
│        │                 │                      │
│    [BC337]           [BC337]  ← Drivers        │
│       │                 │                       │
│   [LED L]           [LED R]   ← Salidas        │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Especificaciones Técnicas Rápidas

| Característica | Especificación |
|----------------|----------------|
| Microcontrolador | ESP32 Dev Board (30 pines) |
| Alimentación | 5V DC (USB), 500mA - 1A |
| Control de LEDs | 2 canales PWM independientes |
| Transistores | 2× BC337 NPN (TO-92) |
| Sensor de presencia | LD2410C (mmWave, UART) |
| Sensor de luz | LDR + resistencia 10kΩ |
| Conectividad | WiFi (ESP32) + ESPHome |
| Plataforma | Home Assistant |

## Estado del Proyecto

✅ **Fase de Diseño** - Completada  
✅ **Fase de Prototipado** - Completada  
✅ **Fase de Implementación** - Completada  
✅ **Fase de Pruebas** - Completada  
✅ **Despliegue v2.0** - Sistema de proximidad operativo  
✅ **Despliegue v2.1** - Interfaz mejorada  
✅ **Despliegue v2.1.1** - Fix sensor distancia  
✅ **Despliegue v2.2** - Configuración 1m→0cm (192.168.1.15) 🎯  

## Próximos Pasos

1. [x] Generar diagrama visual del circuito usando el documento de conexiones
2. [x] Montar el prototipo en protoboard
3. [x] Configurar el firmware ESPHome
4. [x] Desplegar firmware (v2.0 con efecto proximidad)
5. [ ] Realizar pruebas de funcionamiento completas
6. [ ] Calibrar parámetros de proximidad
7. [ ] Crear automatizaciones adicionales en Home Assistant
8. [ ] Documentar resultados y optimizaciones finales
9. [ ] Diseñar segunda unidad (lightnode2)

## Recursos Adicionales

- **ESPHome**: [esphome.io](https://esphome.io)
- **Home Assistant**: [home-assistant.io](https://www.home-assistant.io)
- **LD2410C Datasheet**: Documentación del sensor mmWave
- **BC337 Datasheet**: Especificaciones del transistor

## Mejoras Futuras Consideradas

1. **Reemplazar BC337 por MOSFET** (ej: IRLZ44N) para mayor eficiencia y menos caída de tensión
2. **Agregar sensores adicionales** según necesidades (temperatura, humedad, etc.)
3. **Implementar OTA** (Over-The-Air updates) para actualización remota
4. **PCB personalizado** para versión final (reducir tamaño y mejorar confiabilidad)
5. **Carcasa 3D** diseñada específicamente para el montaje final

## Notas Importantes

⚠️ **Caída de tensión**: Los transistores BC337 introducen una caída de ~0.7V, por lo que las guirnaldas recibirán aproximadamente 4.3V en lugar de 5V. El brillo máximo será ligeramente menor que con alimentación directa.

⚠️ **Corriente máxima**: Verificar que cada guirnalda LED no consuma más de 500mA para evitar sobrecalentamiento de los BC337.

⚠️ **GND común**: Es crítico mantener un GND común entre todos los componentes para evitar problemas de referencia de voltaje.

---

**Documento creado**: 2026-01-20  
**Última actualización**: 2026-01-20  
**Versión**: 1.0
