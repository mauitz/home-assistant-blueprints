# 🎯 Sistema de Alertas V3.1 - MEJORAS IMPLEMENTADAS

## ✅ **Problemas Resueltos:**

### 1. **Solo UNA notificación** (antes: 3 notificaciones)
- **Problema:** Se recibían múltiples notificaciones por una sola detección
- **Solución:** 
  - Usar `tag: "camera_entrada"` en las notificaciones
  - Cambiar `mode: restart` a `mode: single`
  - Esto previene ejecuciones simultáneas

### 2. **Reset más rápido** (antes: 30s → ahora: 10s)
- **Problema:** 30 segundos era demasiado tiempo
- **Solución:** Reducir delay a 10 segundos
- **Beneficio:** Widget vuelve a normal más rápido

### 3. **Widget se agranda** (antes: misma columna)
- **Problema:** Widget no ocupaba más espacio cuando había alerta
- **Solución:** Crear dashboard V3.1 con `type: custom:grid-layout`
- **Resultado:** Widget ocupa **2 columnas** cuando hay alerta

### 4. **Sirena menos molesta** (antes: 10s → ahora: 5s)
- Reducir duración de sirena para no molestar tanto
- Mantiene función de alerta pero es menos invasiva

---

## 🚀 **Cambios Técnicos:**

### Automatizaciones V3.1 (`HA_config_proxy/automations.yaml`):
- ✅ IDs actualizados: `1763075000301-304`
- ✅ `mode: single` en todas las automatizaciones
- ✅ `tag` en notificaciones para evitar duplicados
- ✅ Delay reducido a 10 segundos
- ✅ Sirena reducida a 5 segundos
- ✅ Reset automático sin condicional

### Dashboard V3.1 (`dashboards/maui_dashboard_v3.1.yaml`):
- ✅ `type: custom:grid-layout` a nivel de vista
- ✅ `grid-template-columns: repeat(auto-fill, minmax(350px, 1fr))`
- ✅ `view_layout: grid-column: span 2` en alertas
- ✅ Aspecto ratio `21:9` para alertas (más ancho)
- ✅ Animación pulsante mejorada
- ✅ Badge "🚨 DETECCIÓN ACTIVA" más grande

---

## 📊 **Comparación V3.0 vs V3.1:**

| Aspecto | V3.0 | V3.1 |
|---------|------|------|
| Notificaciones | 3 (spam) | 1 (con tag) |
| Reset | 30 segundos | 10 segundos |
| Widget | 1 columna | 2 columnas |
| Sirena | 10 segundos | 5 segundos |
| Mode | restart (permite duplicados) | single (previene duplicados) |
| Dashboard | masonry layout | grid layout |

---

## ⚠️ **Limitación Conocida:**

### **Velocidad de detección inicial**
- **Problema:** La notificación de Tapo llega ANTES que la de HA
- **Causa:** 
  - Tapo notifica directamente desde la cámara (instantáneo)
  - HA depende del polling del `binary_sensor` (1-2 segundos)
- **Solución:** 
  - No es configurable desde automatizaciones
  - Depende del `scan_interval` de la integración Tapo
  - Por defecto: 2 segundos
  - **Recomendación:** Aceptar este delay (es normal en integraciones locales)

---

## 📦 **Archivos Creados/Modificados:**

### Nuevos:
- ✅ `examples/camera_alert_system_v3.1_optimized.yaml`
- ✅ `dashboards/maui_dashboard_v3.1.yaml`
- ✅ `MEJORAS_V3.1.md` (este archivo)

### Actualizados:
- ✅ `HA_config_proxy/automations.yaml` (V3.1)

---

## 🎯 **Cómo Instalar V3.1:**

### **Paso 1:** Copiar automatizaciones
```bash
scp HA_config_proxy/automations.yaml nico@192.168.1.100:/home/nico/docker-config/homeassistant/
```

### **Paso 2:** Crear nuevo dashboard (Opción A)

**Desde la UI de Home Assistant:**
1. Configuración → Dashboards
2. Click en `+` (Agregar dashboard)
3. Nombre: "Maui V3.1"
4. Icono: `mdi:home`
5. Tipo: **"Vista de cuadrícula (grid)"**
6. Copiar contenido de `dashboards/maui_dashboard_v3.1.yaml`

**O actualizar dashboard existente (Opción B):**
```bash
scp dashboards/maui_dashboard_v3.1.yaml nico@192.168.1.100:/home/nico/docker-config/homeassistant/dashboards/maui.yaml
```

### **Paso 3:** Instalar `grid-layout` de HACS (si no está)
1. HACS → Frontend
2. Buscar: "Lovelace Layout Card"
3. Instalar
4. Reiniciar HA

### **Paso 4:** Reiniciar Home Assistant
```
Configuración → Sistema → Reiniciar
```

### **Paso 5:** Probar
1. Ir al dashboard "Maui V3.1"
2. Pasar mano frente a cámara
3. Verificar:
   - ✅ Solo 1 notificación
   - ✅ Widget se agranda (2 columnas)
   - ✅ Reset en 10 segundos
   - ✅ Sirena 5 segundos

---

## 🎉 **Resultado Final:**

- ✅ **1 notificación** en lugar de 3
- ✅ **Widget se agranda** a 2 columnas
- ✅ **Reset rápido** en 10 segundos
- ✅ **Sirena breve** de 5 segundos
- ✅ **Sin duplicados** gracias a `mode: single`

---

## 📝 **Notas:**

1. El delay de 1-2 segundos en detección inicial es **normal** y no se puede eliminar
2. Si quieres que el widget ocupe **3 columnas**, cambiar `span 2` por `span 3`
3. Para ajustar la duración del reset, cambiar el `delay: seconds: 10`
4. Para ajustar la sirena, cambiar `duration: 5`

---

**Versión:** V3.1  
**Fecha:** 2025-11-14  
**Commit:** (por realizar)

