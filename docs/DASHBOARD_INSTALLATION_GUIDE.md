# 📦 Guía de Instalación - Dashboard Maui

## PASO 1: Instalar HACS (si no lo tienes)

Si ya tienes HACS instalado, salta al PASO 2.

```bash
# En el servidor Home Assistant:
wget -O - https://get.hacs.xyz | bash -
```

Luego:
1. Reinicia Home Assistant
2. Ve a: Configuración → Dispositivos y Servicios → Agregar Integración
3. Busca "HACS" y sigue el proceso de configuración

---

## PASO 2: Instalar Dependencias en HACS

### 2.1 Mushroom Cards ⭐

1. Abre **HACS** en el sidebar
2. Click en **Frontend**
3. Click en **Explorar y descargar repositorios**
4. Busca: **Mushroom**
5. Selecciona: **Mushroom Cards**
6. Click en **Descargar**
7. Reinicia Home Assistant

**Repositorio**: `pilouk/lovelace-mushroom`

---

### 2.2 Browser Mod ⭐

1. HACS → Frontend → Explorar
2. Busca: **Browser Mod**
3. Descargar
4. Reinicia Home Assistant

**Repositorio**: `thomasloven/hass-browser_mod`

**Post-instalación**:
- Ve a: Configuración → Dispositivos y Servicios
- Deberías ver "Browser Mod" como integración
- Configúrala (acepta defaults)

---

### 2.3 Custom Button Card ⭐

1. HACS → Frontend → Explorar
2. Busca: **Button Card**
3. Selecciona: **button-card**
4. Descargar
5. Reinicia Home Assistant

**Repositorio**: `custom-cards/button-card`

---

### 2.4 ApexCharts Card ⭐

1. HACS → Frontend → Explorar
2. Busca: **ApexCharts**
3. Selecciona: **ApexCharts Card**
4. Descargar
5. Reinicia Home Assistant

**Repositorio**: `RomRider/apexcharts-card`

---

### 2.5 Card-Mod ⭐

1. HACS → Frontend → Explorar
2. Busca: **Card Mod**
3. Selecciona: **card-mod**
4. Descargar
5. Reinicia Home Assistant

**Repositorio**: `thomasloven/lovelace-card-mod`

---

### 2.6 Auto-Entities ⭐

1. HACS → Frontend → Explorar
2. Busca: **Auto Entities**
3. Selecciona: **auto-entities**
4. Descargar
5. Reinicia Home Assistant

**Repositorio**: `thomasloven/lovelace-auto-entities`

---

## PASO 3: Verificar Instalación

Después de instalar todas las dependencias y reiniciar:

1. Ve a: **Herramientas de Desarrollo** → **Información**
2. Busca en "Lovelace Resources"
3. Deberías ver:
   - `/hacsfiles/lovelace-mushroom/mushroom.js`
   - `/hacsfiles/browser-mod/browser-mod.js`
   - `/hacsfiles/button-card/button-card.js`
   - `/hacsfiles/apexcharts-card/apexcharts-card.js`
   - `/hacsfiles/lovelace-card-mod/card-mod.js`
   - `/hacsfiles/lovelace-auto-entities/auto-entities.js`

Si faltan, ve a HACS → Frontend → ⋮ (menú) → Recargar recursos

---

## PASO 4: Agregar Recursos Manualmente (si es necesario)

Si alguna dependencia no se carga automáticamente:

1. Ve a: **Configuración** → **Paneles de Control** → **Recursos**
2. Click en **Agregar Recurso**
3. Para cada uno:

```yaml
# Mushroom
URL: /hacsfiles/lovelace-mushroom/mushroom.js
Tipo: JavaScript Module

# Browser Mod
URL: /hacsfiles/browser-mod/browser-mod.js
Tipo: JavaScript Module

# Button Card
URL: /hacsfiles/button-card/button-card.js
Tipo: JavaScript Module

# ApexCharts
URL: /hacsfiles/apexcharts-card/apexcharts-card.js
Tipo: JavaScript Module

# Card-Mod
URL: /hacsfiles/lovelace-card-mod/card-mod.js
Tipo: JavaScript Module

# Auto-Entities
URL: /hacsfiles/lovelace-auto-entities/auto-entities.js
Tipo: JavaScript Module
```

---

## PASO 5: Configurar Tema (Opcional pero Recomendado)

Crea o edita `/config/themes/maui_theme.yaml`:

```yaml
maui_dark:
  # Colores principales
  primary-color: "#3B82F6"
  accent-color: "#8B5CF6"

  # Fondos
  primary-background-color: "#0F172A"
  secondary-background-color: "#1E293B"
  card-background-color: "#334155"

  # Texto
  primary-text-color: "#F1F5F9"
  secondary-text-color: "#CBD5E1"
  disabled-text-color: "#64748B"

  # Estados
  state-icon-color: "#94A3B8"
  state-icon-active-color: "#3B82F6"

  # Sidebar
  sidebar-background-color: "#1E293B"
  sidebar-text-color: "#F1F5F9"
  sidebar-selected-background-color: "#334155"

  # Switches
  switch-checked-color: "#10B981"
  switch-unchecked-color: "#64748B"

  # Bordes
  divider-color: "#475569"

  # Mushroom
  mush-rgb-red: "239, 68, 68"
  mush-rgb-orange: "245, 158, 11"
  mush-rgb-yellow: "234, 179, 8"
  mush-rgb-green: "16, 185, 129"
  mush-rgb-blue: "59, 130, 246"
  mush-rgb-purple: "139, 92, 246"
  mush-rgb-pink: "236, 72, 153"
```

En `configuration.yaml`, asegúrate de tener:

```yaml
frontend:
  themes: !include_dir_merge_named themes
```

Luego:
1. Reinicia Home Assistant
2. Ve a tu perfil (abajo a la izquierda)
3. Selecciona tema: **Maui Dark**

---

## PASO 6: Verificación Final

Abre cualquier panel de control y edítalo (⋮ → Editar Panel):

1. Click en **Agregar Tarjeta**
2. Busca "Mushroom" en la barra de búsqueda
3. Deberías ver:
   - Mushroom Alarm Control Panel Card
   - Mushroom Climate Card
   - Mushroom Cover Card
   - Mushroom Entity Card
   - ... (muchas más)

Si ves las tarjetas Mushroom, ¡todo está listo! ✅

---

## ⚠️ Solución de Problemas

### Error: "Custom element doesn't exist: mushroom-..."

**Solución**:
1. HACS → Frontend → ⋮ → Recargar recursos
2. Ctrl + F5 para recargar cache del navegador
3. Reiniciar Home Assistant

### Error: "browser_mod service not found"

**Solución**:
1. Configuración → Dispositivos y Servicios
2. Agregar Integración → Browser Mod
3. Completar configuración

### Las tarjetas no se ven bien

**Solución**:
1. Asegúrate de tener el tema aplicado
2. Limpia la caché del navegador (Ctrl + Shift + Delete)
3. Prueba en modo incógnito

---

## ✅ Checklist Final

- [ ] HACS instalado
- [ ] Mushroom Cards instalado
- [ ] Browser Mod instalado y configurado
- [ ] Custom Button Card instalado
- [ ] ApexCharts Card instalado
- [ ] Card-Mod instalado
- [ ] Auto-Entities instalado
- [ ] Todos los recursos cargados
- [ ] Tema Maui Dark aplicado (opcional)
- [ ] Tarjetas Mushroom visibles en editor

---

**¡Todo listo! Ahora podemos crear el dashboard.** 🚀

**Próximo paso**: Crear el dashboard base y comenzar con las secciones.


