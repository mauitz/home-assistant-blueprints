# 🔄 Guía para Actualizar Home Assistant

## 📋 Antes de Empezar

### Verificar Versión Actual

1. En Home Assistant, ve a: **Configuración** → **Sistema** → **Información**
2. Busca: **Versión** (ejemplo: 2025.7.4)
3. Compara con la última versión disponible

**Última versión estable recomendada**: 2025.11.x o superior

---

## 🛡️ PASO 1: Hacer Backup (OBLIGATORIO)

### Opción A: Backup desde la UI (Recomendado)

1. **Configuración** → **Sistema** → **Copias de seguridad**
2. Click en **Crear copia de seguridad**
3. Nombre: `Pre-actualización-Dashboard-Maui`
4. Selecciona:
   - ✅ Configuración
   - ✅ Complementos
   - ✅ Carpetas personalizadas
5. Click en **Crear**
6. **Esperar** a que complete (puede tardar varios minutos)
7. **Descargar** el backup a tu computadora

### Opción B: Backup Manual vía SSH

```bash
# Conectarse al servidor
ssh nico@192.168.1.100

# Crear backup
cd /config
sudo tar -czf /backup/ha-backup-$(date +%Y%m%d).tar.gz .

# Copiar a tu computadora (desde tu Mac)
scp nico@192.168.1.100:/backup/ha-backup-*.tar.gz ~/Downloads/
```

---

## 🚀 PASO 2: Actualizar Home Assistant

### Método 1: Actualización desde la UI (Más Fácil)

1. **Configuración** → **Sistema** → **Actualizaciones**
2. Deberías ver: **Home Assistant Core Update Available**
3. Click en **Actualizar**
4. Lee el changelog (cambios importantes)
5. Click en **Actualizar** para confirmar
6. **Esperar** (puede tardar 10-15 minutos)
7. Home Assistant se reiniciará automáticamente

**⚠️ Durante la actualización:**
- No cierres el navegador
- No apagues el servidor
- No interrumpas el proceso

### Método 2: Actualización vía Supervisor (si lo tienes)

1. **Configuración** → **Complementos, copias de seguridad y Supervisor** → **Supervisor**
2. Tab **Panel de control**
3. Busca "Home Assistant Core"
4. Si hay actualización disponible, verás un botón **Actualizar**
5. Click y espera

### Método 3: Actualización vía SSH/CLI

```bash
# Conectarse
ssh nico@192.168.1.100

# Para Home Assistant OS / Supervised
ha core update

# Para Home Assistant Container (Docker)
docker pull ghcr.io/home-assistant/home-assistant:stable
docker stop homeassistant
docker rm homeassistant
# Recrear contenedor con nueva imagen
docker run -d --name homeassistant \
  --restart=unless-stopped \
  -v /PATH_TO_CONFIG:/config \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable

# Para Home Assistant Core (venv)
sudo systemctl stop home-assistant@homeassistant
sudo -u homeassistant -H -s
cd /srv/homeassistant
source bin/activate
pip3 install --upgrade homeassistant
exit
sudo systemctl start home-assistant@homeassistant
```

---

## ✅ PASO 3: Verificar Actualización

### Después de reiniciar:

1. **Espera 2-3 minutos** para que HA inicie completamente
2. Abre Home Assistant en el navegador
3. **Configuración** → **Sistema** → **Información**
4. Verifica que la **Versión** sea la nueva

### Checklist Post-Actualización:

- [ ] Home Assistant carga correctamente
- [ ] Puedes hacer login
- [ ] Las automatizaciones existentes funcionan
- [ ] Los dispositivos están conectados
- [ ] No hay errores críticos en el log

**Revisar logs:**
- **Configuración** → **Sistema** → **Registros**
- Busca errores (líneas rojas) relacionados con integraciones

---

## 🔧 PASO 4: Actualizar Integraciones y Add-ons

Después de actualizar HA Core:

1. **Configuración** → **Dispositivos y Servicios**
2. Si ves avisos de actualización, actualiza cada integración
3. **Configuración** → **Complementos**
4. Actualiza add-ons si hay actualizaciones disponibles

---

## ⚠️ Solución de Problemas

### Problema: Home Assistant no inicia después de actualizar

**Solución 1: Restaurar Backup**
1. Reinicia el servidor físicamente
2. Espera 5 minutos
3. Si sigue sin funcionar:
   - **Configuración** → **Sistema** → **Copias de seguridad**
   - Selecciona el backup pre-actualización
   - **Restaurar**

**Solución 2: Revisar Logs (vía SSH)**
```bash
ssh nico@192.168.1.100
ha core logs
# o
docker logs homeassistant
# o
journalctl -f -u home-assistant@homeassistant
```

### Problema: Integración específica falla

1. **Configuración** → **Dispositivos y Servicios**
2. Encuentra la integración con problemas
3. Click en ella → **⋮** → **Recargar**
4. Si no funciona → **Eliminar** y volver a agregar

### Problema: Automatizaciones no funcionan

1. **Configuración** → **Automatizaciones**
2. Edita cada automatización
3. Guarda sin cambios (para revalidar)
4. O: **Herramientas de Desarrollo** → **YAML** → **Recargar Automatizaciones**

---

## 📊 Compatibilidad con Dashboard Maui

| Componente | Versión Mínima HA | Recomendada |
|------------|-------------------|-------------|
| Mushroom Cards | 2023.11.0 | 2024.1.0+ |
| Browser Mod | 2023.9.0 | 2024.1.0+ |
| Custom Button Card | 2023.1.0 | Cualquiera |
| ApexCharts | 2023.6.0 | 2024.1.0+ |
| Card-Mod | 2023.1.0 | Cualquiera |
| Auto-Entities | 2023.1.0 | Cualquiera |

**Versión recomendada de Home Assistant para Dashboard Maui**: **2024.11.0 o superior**

---

## 🎯 Después de Actualizar

Una vez que Home Assistant esté actualizado y funcionando:

1. ✅ Verifica que todo funciona correctamente
2. 🔄 Actualiza integraciones si es necesario
3. 📦 Continúa con la instalación de dependencias HACS
4. 🚀 Instala el Dashboard Maui

---

## 📞 Checklist Final

- [ ] Backup creado y descargado
- [ ] Home Assistant actualizado a 2024.11+ o superior
- [ ] Sistema reiniciado y funcionando
- [ ] Logs sin errores críticos
- [ ] Automatizaciones existentes funcionan
- [ ] Dispositivos conectados
- [ ] Listo para instalar dependencias del dashboard

---

**¿Todo listo? ¡Ahora sí podemos instalar las dependencias y el dashboard!** 🚀


