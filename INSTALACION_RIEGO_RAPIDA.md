# ⚡ Instalación Rápida - Sistema de Riego

## 🎯 **3 Pasos para Activar el Riego Automático**

---

### **PASO 1: Copiar Blueprint a Home Assistant**

**Opción A - File Editor/Samba:**
1. Abre **File Editor** en Home Assistant
2. Navega a `config/blueprints/automation/`
3. Crea carpeta `mauitz` si no existe
4. Crea archivo `sistema_riego_inteligente.yaml`
5. Copia el contenido de:
   ```
   blueprints/sistema_riego_inteligente.yaml
   ```
6. Guarda el archivo

**Opción B - Terminal/SSH:**
```bash
cd /config/blueprints/automation/
mkdir -p mauitz
# Luego copia el archivo manualmente
```

**Recargar:**
- **Herramientas para Desarrolladores** → **YAML** → **Recargar Automatizaciones**

---

### **PASO 2: Crear Helpers (Opcionales pero Recomendados)**

Ve a: **Configuración → Dispositivos y Servicios → Helpers**

#### 1. Input Boolean - Modo Manual
- Tipo: **Toggle**
- Nombre: `Riego Z1 - Modo Manual`
- ID de entidad: `riego_z1_manual`
- Icono: `mdi:hand-back-right`

#### 2. Input DateTime - Último Riego
- Tipo: **Fecha y hora**
- Nombre: `Riego Z1 - Último Riego`
- ID: `riego_z1_ultimo`
- ✅ Tiene fecha
- ✅ Tiene hora

#### 3. Input Number - Contador
- Tipo: **Número**
- Nombre: `Riego Z1 - Contador de Ciclos`
- ID: `riego_z1_contador`
- Min: 0, Max: 1000, Paso: 1

---

### **PASO 3: Crear la Automatización**

1. **Configuración** → **Automatizaciones y Escenas**
2. **+ Crear Automatización**
3. **Crear automatización desde blueprint**
4. Busca: **"Sistema de Riego Inteligente"**
5. Configura:

```yaml
Zona: "Zona 1 - Jardín Principal"
Bomba: switch.bomba_z1a
Sensor Humedad: sensor.humedad_suelo_z1
Sensor Tanque: sensor.nivel_tanque

Humedad Mínima: 30%
Humedad Objetivo: 60%
Nivel Mínimo Tanque: 20%
Duración Máxima: 10 min
Intervalo Mínimo: 4 horas

Horario: 06:00 - 22:00
Riego Nocturno: No

Modo Manual (opcional): input_boolean.riego_z1_manual
```

6. **Guardar** como: `Riego Automático - Zona 1`

---

## 🧪 **Prueba Rápida**

### Prueba Manual:
1. Activa `input_boolean.riego_z1_manual` (si lo creaste)
2. Activa `switch.bomba_z1a` desde Home Assistant
3. Verifica que riega
4. Apaga todo

### Prueba Automática:
1. Desactiva modo manual
2. Si humedad < 30% y tanque > 20%
3. Espera 5 minutos
4. Debería regar automáticamente

---

## 📊 **Dashboard Simple**

Agrega esta tarjeta a tu dashboard:

```yaml
type: entities
title: 🚰 Riego Z1
entities:
  - sensor.humedad_suelo_z1
  - sensor.nivel_tanque
  - switch.bomba_z1a
  - switch.bomba_z1b
  - input_boolean.riego_z1_manual
```

---

## 📚 **Documentación Completa**

- [Instalación Detallada](docs/automatizaciones/INSTALACION_PASO_A_PASO.md)
- [Guía Completa del Sistema](docs/automatizaciones/RIEGO_INTELIGENTE.md)
- [Configuración de Helpers](examples/helpers/riego_helpers.yaml)
- [Ejemplo de Automatización](examples/automatizaciones/riego_z1_auto.yaml)

---

## ✅ **Checklist**

- [ ] Blueprint copiado y recargado
- [ ] 3 helpers creados
- [ ] Automatización configurada
- [ ] Prueba manual OK
- [ ] Dashboard agregado

---

## 🆘 **Ayuda Rápida**

**Blueprint no aparece:**
- Recarga automatizaciones: Herramientas → YAML → Automatizaciones

**No aparecen las entidades:**
- Verifica que `riego_z1` esté conectado en Dispositivos

**No riega automáticamente:**
- Verifica: modo manual OFF, humedad < 30%, tanque > 20%, horario OK

---

**¡Listo en 3 pasos!** 🎉

