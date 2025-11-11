# 🏠 PezAustral Presence Simulation

**Versión:** 1.1 (Fixed - Nov 2025)  
**Blueprint para Home Assistant**

Simulación avanzada de presencia con control de lámparas simultáneas, loops configurables y detención inmediata.

---

## ✨ Características Principales

- **Control de lámparas simultáneas**: Limita cuántas pueden estar encendidas al mismo tiempo
- **Apagado inteligente**: Sistema de apagado automático en paralelo
- **Loop configurable**: 0-50 repeticiones o infinito
- **Detención inmediata**: Se detiene en menos de 5 segundos
- **Escena de salida**: Configurable para fin normal o parada de emergencia
- **Múltiples triggers**: Tiempo, sol, luz ambiental, entidades
- **Control por zona**: Activa solo cuando no hay personas
- **Control por fechas**: Define períodos específicos

---

## 🆕 Versión 1.1 - Cambios Críticos

### ✅ Corregido: Problema de No Detención

**Antes (v1.0):**
- ❌ `mode: restart` - No se podía detener
- ❌ Sin verificación durante ejecución
- ❌ Loop sin escape

**Ahora (v1.1):**
- ✅ `mode: single` - Detención limpia
- ✅ Verificación continua del estado
- ✅ Se detiene en < 5 segundos
- ✅ Escena de parada de emergencia

**Si vienes de v1.0**: Solo actualiza el blueprint desde el repositorio.

---

## 📦 Instalación

### Opción 1: Desde GitHub (Recomendado)

```
1. En Home Assistant:
   - Configuración → Automatizaciones y Escenas → Blueprints
   - Click en "Importar Blueprint"
   - URL: https://github.com/TU_USUARIO/home-assistant-blueprints/blob/main/blueprints/pezaustral_presence_simulation.yaml
   - Importar

2. Crear automatización:
   - Nueva Automatización → Desde Blueprint
   - Selecciona "PezAustral Presence Simulation"
   - Configura según necesites
```

### Opción 2: Manual

```bash
# Copia a tu Home Assistant:
/config/blueprints/automation/pezaustral/pezaustral_presence_simulation.yaml
```

---

## ⚡ Inicio Rápido

### Configuración Mínima

```yaml
- Luces: [Selecciona tus switches/luces]
- Máximo simultáneas: 2
- Trigger: input_boolean.presence_simulation (ON)
- Tiempo ON: 15-45 minutos
- Loop: Habilitado, 5 repeticiones
```

### Prueba Rápida (5 minutos)

```yaml
- Luces: [3 switches cualquiera]
- Máximo simultáneas: 1
- min_on_time: 1 minuto
- max_on_time: 2 minutos
- Loop: 2 repeticiones
- Activar y observar
```

---

## 📚 Documentación

- **[Guía Completa](GUIA_COMPLETA.md)**: Todas las opciones explicadas
- **[Ejemplos](../../examples/)**: Configuraciones listas para usar
- **[Troubleshooting](TROUBLESHOOTING.md)**: Solución de problemas
- **[Changelog](CHANGELOG.md)**: Historial de versiones

---

## 🎯 Ejemplos Rápidos

### Salida Nocturna (3 horas)

```yaml
Trigger: input_boolean.presence_simulation → ON
Luces: [sala, cocina, dormitorio]
Max simultáneas: 2
Tiempo ON: 15-30 min
Loop: 5 repeticiones
Escena salida: scene.apagar_todo
```

### Vacaciones (Infinito)

```yaml
Trigger: Elevación solar = -5
Luces: [Todas las de la casa]
Max simultáneas: 3
Tiempo ON: 20-45 min
Loop: Infinito
Control: Solo si nadie en zone.home
```

### Fin de Semana

```yaml
Trigger: Tiempo = 10:00
Luces: [Principales]
Max simultáneas: 2
Días: Sábado, Domingo
Loop: 8 repeticiones
```

---

## 🆚 Comparación con Versiones Anteriores

| Característica | v1.0 (con bug) | v1.1 (fixed) |
|----------------|----------------|--------------|
| Detención | ❌ Imposible | ✅ < 5 segundos |
| Mode | restart | single |
| Verificación continua | ❌ No | ✅ Sí |
| Escena emergencia | ❌ No | ✅ Sí |
| Control durante ejecución | ❌ No | ✅ Sí |

---

## 🤝 Basado En

Este blueprint está basado en [Holiday & Away Lighting de Blackshome](https://gist.github.com/Blackshome/0a34870755762bcb9fab159d5b94fd25), con mejoras significativas:

- Control de lámparas simultáneas
- Sistema de detención mejorado
- Loop más flexible
- Escena de parada de emergencia
- Verificación continua de estado

---

## 📄 Licencia

MIT License - Libre para uso personal y comercial.

---

## 🐛 Reportar Problemas

Si encuentras algún bug o tienes sugerencias:
- GitHub Issues: [Enlace a tu repo]
- Documentación de troubleshooting: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

*PezAustral Presence Simulation v1.1 - Noviembre 2025*

