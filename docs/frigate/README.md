# 📁 Documentación de Frigate

## 📌 Estado Actual

**🔴 SISTEMA DESINSTALADO TEMPORALMENTE**

Frigate fue instalado y funcionó correctamente, pero fue desinstalado debido a limitaciones de recursos del servidor actual.

- **Razón:** Consumo de CPU del 100% que saturaba el servidor
- **Fecha de desinstalación:** 14 de Diciembre, 2025
- **Estado:** Configuraciones guardadas, listo para reinstalar con hardware adecuado

---

## 📚 Documentación Disponible

### 🔴 IMPORTANTE - Lee primero
- **[INFORME_FRIGATE_ANALISIS_FINAL.md](./INFORME_FRIGATE_ANALISIS_FINAL.md)**
  - Análisis completo del sistema implementado
  - Razones de la desinstalación
  - Proceso completo de desinstalación paso a paso
  - Proceso de reinstalación para el futuro
  - **LEE ESTE ARCHIVO PRIMERO**

### 📖 Guías de Instalación
- **[FRIGATE_INSTALACION_COMPLETA.md](./FRIGATE_INSTALACION_COMPLETA.md)**
  - Guía detallada paso a paso
  - Requisitos del sistema
  - Configuración de cámaras
  - Integración con Home Assistant
  - Troubleshooting completo

- **[FRIGATE_QUICK_START.md](./FRIGATE_QUICK_START.md)**
  - Instalación rápida en 15-20 minutos
  - Checklist paso a paso
  - Configuración básica
  - Verificaciones esenciales

### ⚡ Optimización
- **[FRIGATE_OPTIMIZACION_MOTION_BASED.md](./FRIGATE_OPTIMIZACION_MOTION_BASED.md)**
  - Detección activada por movimiento
  - Ahorro de 70-80% de CPU
  - Automatizaciones avanzadas
  - Configuración de helpers

- **[FRIGATE_OPCIONES_OPTIMIZACION.md](./FRIGATE_OPCIONES_OPTIMIZACION.md)**
  - Comparación de estrategias de optimización
  - Motion-Based vs Scheduled vs Zones
  - Google Coral TPU
  - Guía de decisión

---

## 🗂️ Configuraciones Disponibles

### En `examples/frigate/`

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| `frigate_config.yml` | Configuración base documentada | ✅ Lista |
| `frigate_config_optimizado.yml` | Config optimizada con mejores prácticas | ✅ Lista |
| `camera_alert_system_v3.3_frigate.yaml` | Automatizaciones V3.3 con IA | ✅ Lista |
| `camera_alert_helpers.yaml` | Helpers necesarios | ✅ Lista |

---

## 🚀 Cómo Reinstalar (Futuro)

### Requisitos Previos

**Necesitas UNA de estas opciones:**

#### Opción A: Servidor Dedicado (Recomendado)
```
Características mínimas:
• CPU: 4 cores dedicados
• RAM: 8 GB
• Disco: 100 GB SSD
• Solo para Frigate

Costo: $300-800 USD
```

#### Opción B: Google Coral TPU (Más económico)
```
Hardware:
• Google Coral USB Accelerator
• Puerto USB 3.0 disponible

Beneficios:
• CPU baja de 100% a 5-10%
• Soporta hasta 8 cámaras
• Compatible con servidor actual

Costo: ~$60 USD
```

### Pasos de Reinstalación

1. **Preparar hardware** (servidor dedicado o Coral TPU)
2. **Restaurar backup** del servidor
3. **Seguir guía** en `INFORME_FRIGATE_ANALISIS_FINAL.md`
4. **Reinstalar integración** en Home Assistant
5. **Verificar** funcionamiento

Ver detalles completos en: [INFORME_FRIGATE_ANALISIS_FINAL.md](./INFORME_FRIGATE_ANALISIS_FINAL.md#-proceso-de-reinstalación-futuro)

---

## 🔧 Scripts Disponibles

### Desinstalación
```bash
cd /Users/maui/_maui/domotica/home-assistant-blueprints
./utils/uninstall_frigate.sh
```

**Este script:**
- ✅ Crea backup completo automático
- ✅ Detiene y elimina contenedor
- ✅ Limpia archivos
- ✅ Guía para limpiar Home Assistant
- ✅ Verificación final

---

## 📦 Backup Disponible

### En el Servidor
```
~/frigate_backup_YYYYMMDD/
├── frigate_config_backup/     # Config real que funcionaba
├── docker-compose.yml          # Docker compose usado
├── frigate_db_backup.db       # Base de datos de eventos
├── automations_backup.yaml    # Automatizaciones con V3.3
└── INVENTARIO_BACKUP.txt      # Inventario completo
```

### En el Repositorio
- Toda la documentación actualizada
- Configuraciones listas para usar
- Scripts de instalación/desinstalación

---

## ❓ Preguntas Frecuentes

### ¿Por qué fue desinstalado?
Frigate requiere mucho procesamiento de CPU. En el servidor actual (compartido con otros servicios), causaba saturación del 100% de CPU, haciendo el sistema inestable.

### ¿Se perdió algo?
No. Todo está documentado y respaldado:
- ✅ Configuraciones guardadas
- ✅ Documentación completa
- ✅ Proceso de reinstalación definido
- ✅ Backup en el servidor

### ¿Cuándo se puede reinstalar?
Cuando tengas:
- Servidor dedicado con más recursos, O
- Google Coral TPU (~$60) para aceleración por hardware

### ¿Qué funciona mientras tanto?
Sistema V3.2 con detección nativa de Tapo:
- ✅ Detección de movimiento básica
- ✅ Notificaciones
- ✅ Snapshots (sin bounding boxes)
- ⚠️ Solo personas (no vehículos/animales)

### ¿Vale la pena Coral TPU?
**SÍ**, si:
- Planeas usar Frigate a largo plazo
- Tienes 2+ cámaras
- Tu servidor actual tiene USB 3.0

**Beneficios:**
- CPU baja de 100% a 5-10%
- Detección más rápida
- Escalable a 8 cámaras

---

## 📖 Recursos Externos

- **Frigate Documentation:** https://docs.frigate.video/
- **Google Coral Store:** https://coral.ai/products/accelerator/
- **Frigate GitHub:** https://github.com/blakeblackshear/frigate
- **Home Assistant Integration:** https://www.home-assistant.io/integrations/frigate/

---

## 📝 Orden de Lectura Recomendado

### Si nunca instalaste Frigate:
1. `FRIGATE_QUICK_START.md` - Para entender qué es
2. `INFORME_FRIGATE_ANALISIS_FINAL.md` - Para entender por qué no funcionó
3. Esperar hasta tener hardware adecuado

### Si vas a reinstalar:
1. `INFORME_FRIGATE_ANALISIS_FINAL.md` - Sección "Proceso de Reinstalación"
2. `FRIGATE_INSTALACION_COMPLETA.md` - Guía paso a paso
3. `FRIGATE_OPTIMIZACION_MOTION_BASED.md` - Si quieres optimizar aún más

### Si quieres optimizar un sistema existente:
1. `FRIGATE_OPCIONES_OPTIMIZACION.md` - Comparar estrategias
2. `FRIGATE_OPTIMIZACION_MOTION_BASED.md` - Implementar la mejor opción

---

## 🎯 Conclusión

Frigate es un **excelente sistema** de detección por IA, pero requiere:
- Hardware dedicado, O
- Aceleración por hardware (Coral TPU)

**No es viable** en un servidor compartido con recursos limitados.

La solución está **completamente documentada y lista** para cuando tengas el hardware adecuado.

---

**Última actualización:** 14 de Diciembre, 2025
**Estado:** Sistema desinstalado, documentado y listo para reinstalar
