# 🔄 Actualización Manual de Home Assistant - Guía Paso a Paso

## ⚠️ PASO 1: BACKUP (OBLIGATORIO)

**ANTES DE CONTINUAR, HAZ ESTO:**

1. Ve a: http://192.168.1.100:8123
2. **Configuración** → **Sistema** → **Copias de seguridad**
3. Click en **"Crear copia de seguridad"**
4. Nombre: `Pre-actualización-manual-Nov-2025`
5. Marca todas las opciones:
   - ✅ Configuración
   - ✅ Complementos
   - ✅ Carpetas personalizadas
6. Click **"Crear"**
7. **ESPERA** a que termine (puede tardar 5-10 minutos)
8. Click en **"Descargar"** y guarda en tu Mac

**¡NO CONTINÚES SIN HACER EL BACKUP!**

---

## 🔍 PASO 2: Identificar Tipo de Instalación

Necesitamos saber cómo está instalado tu Home Assistant para usar el método correcto.

### Conéctate al servidor:

```bash
ssh nico@192.168.1.100
```

### Ejecuta este comando para identificar el tipo:

```bash
# Comando para identificar instalación
if command -v ha &> /dev/null; then
    echo "✅ Tipo: Home Assistant OS / Supervised"
    echo "   Método: Usar 'ha core update'"
elif docker ps | grep -q homeassistant; then
    echo "✅ Tipo: Home Assistant Container (Docker)"
    echo "   Método: Actualizar imagen Docker"
elif systemctl list-units --full -all | grep -q home-assistant; then
    echo "✅ Tipo: Home Assistant Core (venv)"
    echo "   Método: Actualizar Python venv"
else
    echo "⚠️  No se pudo identificar el tipo de instalación"
fi
```

**Copia el resultado y dime qué tipo de instalación tienes.**

---

## 🚀 PASO 3: Actualización según Tipo

### MÉTODO A: Home Assistant OS / Supervised

Si el comando anterior mostró "Home Assistant OS / Supervised":

```bash
# Conectado por SSH al servidor

# 1. Ver versión actual
ha core info

# 2. Ver actualizaciones disponibles
ha core update --backup

# 3. Si pregunta, confirma con 'y'

# 4. ESPERAR (puede tardar 10-15 minutos)
# No interrumpas el proceso

# 5. Verificar que terminó
ha core info

# 6. Reiniciar Home Assistant
ha core restart

# 7. Esperar 2-3 minutos y verificar en el navegador
```

---

### MÉTODO B: Home Assistant Container (Docker)

Si usas Docker:

```bash
# Conectado por SSH al servidor

# 1. Ver versión actual
docker exec homeassistant python -m homeassistant --version

# 2. Detener contenedor actual
docker stop homeassistant

# 3. Hacer backup del contenedor (por si acaso)
docker commit homeassistant homeassistant-backup-$(date +%Y%m%d)

# 4. Eliminar contenedor viejo
docker rm homeassistant

# 5. Descargar última versión
docker pull ghcr.io/home-assistant/home-assistant:stable

# 6. Recrear contenedor con nueva imagen
docker run -d \
  --name homeassistant \
  --restart=unless-stopped \
  -e TZ=America/Santiago \
  -v /PATH_TO_YOUR_CONFIG:/config \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable

# IMPORTANTE: Reemplaza /PATH_TO_YOUR_CONFIG con la ruta real
# Normalmente es: /home/nico/homeassistant o /config

# 7. Ver logs para verificar que inicia bien
docker logs -f homeassistant

# Presiona Ctrl+C cuando veas que ya inició
```

---

### MÉTODO C: Home Assistant Core (venv)

Si usas instalación en Python venv:

```bash
# Conectado por SSH al servidor

# 1. Detener Home Assistant
sudo systemctl stop home-assistant@homeassistant

# 2. Cambiar a usuario homeassistant
sudo -u homeassistant -H -s

# 3. Ir al directorio del venv
cd /srv/homeassistant

# 4. Activar entorno virtual
source bin/activate

# 5. Ver versión actual
python -m homeassistant --version

# 6. Actualizar Home Assistant
pip3 install --upgrade homeassistant

# 7. Salir del usuario homeassistant
exit

# 8. Iniciar Home Assistant
sudo systemctl start home-assistant@homeassistant

# 9. Ver logs
sudo journalctl -f -u home-assistant@homeassistant

# Presiona Ctrl+C cuando veas que ya inició
```

---

## ✅ PASO 4: Verificación Post-Actualización

### 1. Espera 2-3 minutos

Después de reiniciar/iniciar, espera a que Home Assistant cargue completamente.

### 2. Abre en el navegador

```
http://192.168.1.100:8123
```

### 3. Verifica la versión

- **Configuración** → **Sistema** → **Información**
- Busca **"Versión"**
- Debería ser 2025.11.x o superior

### 4. Revisa el log

- **Configuración** → **Sistema** → **Registros**
- Busca errores (líneas rojas)
- Si hay errores menores de integraciones, ignóralos por ahora

### 5. Prueba básica

- ✅ Puedes navegar por la interfaz
- ✅ Las automatizaciones aparecen
- ✅ Los dispositivos están conectados
- ✅ Puedes controlar switches/luces

---

## 🔧 PASO 5: Solución de Problemas

### Problema: Home Assistant no inicia

```bash
# Ver logs en tiempo real
# Para HA OS/Supervised:
ha core logs

# Para Docker:
docker logs homeassistant

# Para venv:
sudo journalctl -f -u home-assistant@homeassistant
```

**Si hay errores críticos:**

1. Restaura el backup desde la UI
2. O vuelve a la versión anterior (si es Docker):
   ```bash
   docker stop homeassistant
   docker rm homeassistant
   docker run -d --name homeassistant ... homeassistant-backup-FECHA
   ```

### Problema: Error de integración específica

1. Ve a: **Configuración** → **Dispositivos y Servicios**
2. Encuentra la integración con problemas
3. Click → **⋮** → **Recargar**
4. Si no funciona → **Eliminar** y volver a agregar

### Problema: Automatización no funciona

```bash
# En Herramientas de Desarrollo → YAML
# Recargar Automatizaciones
```

---

## 📊 PASO 6: Actualizar Integraciones

Después de actualizar HA Core:

1. **Configuración** → **Dispositivos y Servicios**
2. Si ves avisos de actualización → Click en cada uno → **Actualizar**
3. **Configuración** → **Complementos**
4. Actualiza add-ons si hay disponibles

---

## ✅ Checklist Final

- [ ] Backup creado y descargado
- [ ] Tipo de instalación identificado
- [ ] Home Assistant actualizado
- [ ] Versión verificada (2025.11.x+)
- [ ] Logs sin errores críticos
- [ ] Interfaz carga correctamente
- [ ] Automatizaciones funcionan
- [ ] Dispositivos conectados
- [ ] Integraciones actualizadas

---

## 🎯 Después de Actualizar

Una vez que todo funciona:

1. ✅ **Browser Mod** ahora se podrá instalar sin problemas
2. ✅ Continúa con la instalación de dependencias HACS
3. ✅ Instala el Dashboard Maui

---

**¿Listo para empezar? Dime cuando hayas hecho el backup para continuar.** 🚀

