#!/bin/bash
# Script para preparar tarjeta SD con Dafang Hacks
# Uso: ./prepare_dafang_sd.sh

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📦 PREPARACIÓN DE SD - DAFANG HACKS${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${RED}⚠️  ADVERTENCIA IMPORTANTE${NC}"
echo ""
echo "Este proceso instalará firmware custom en tu cámara Xiaomi."
echo ""
echo "RIESGOS:"
echo "  • Puede invalidar la garantía"
echo "  • Riesgo de 'brick' (cámara inservible)"
echo "  • Perderás acceso a app Xiaomi Home"
echo "  • No es reversible fácilmente"
echo ""
read -p "¿Entiendes los riesgos y deseas continuar? (escribe SI): " -r
echo
if [ "$REPLY" != "SI" ]; then
    echo -e "${YELLOW}Operación cancelada${NC}"
    exit 0
fi

# Verificar que no se esté ejecutando como root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ No ejecutes este script como root/sudo${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📋 PASO 1: Verificaciones${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verificar herramientas necesarias
echo -n "🔍 Verificando herramientas... "

MISSING_TOOLS=""

if ! command -v curl &> /dev/null; then
    MISSING_TOOLS="$MISSING_TOOLS curl"
fi

if ! command -v unzip &> /dev/null; then
    MISSING_TOOLS="$MISSING_TOOLS unzip"
fi

if [ -n "$MISSING_TOOLS" ]; then
    echo -e "${RED}❌${NC}"
    echo ""
    echo -e "${RED}Faltan herramientas:$MISSING_TOOLS${NC}"
    echo "Instala con: brew install$MISSING_TOOLS"
    exit 1
else
    echo -e "${GREEN}✅${NC}"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🔌 PASO 2: Identificar Tarjeta SD${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}⚠️  INSERTA LA TARJETA SD AHORA${NC}"
echo ""
echo "Requisitos de la SD:"
echo "  • Tamaño: 4-32 GB"
echo "  • Clase 10 o superior"
echo "  • Vacía o que no importe su contenido"
echo ""
read -p "Presiona ENTER cuando la SD esté insertada..."

echo ""
echo "Discos disponibles:"
echo ""
diskutil list | grep -E "^/dev/disk[0-9]"
echo ""

read -p "Ingresa el número del disco de la SD (ej: si es /dev/disk2, ingresa 2): " DISK_NUM

DISK_PATH="/dev/disk${DISK_NUM}"

# Verificar que el disco existe
if [ ! -e "$DISK_PATH" ]; then
    echo -e "${RED}❌ El disco $DISK_PATH no existe${NC}"
    exit 1
fi

# Mostrar información del disco
echo ""
echo "Información del disco seleccionado:"
diskutil info "$DISK_PATH" | grep -E "Device Node|Media Name|Total Size"
echo ""

# Confirmación de seguridad
echo -e "${RED}⚠️  ÚLTIMO AVISO${NC}"
echo ""
echo "Se formateará el disco: $DISK_PATH"
echo "Se borrarán TODOS los datos de esta tarjeta."
echo ""
read -p "¿Estás SEGURO? (escribe FORMATEAR): " -r
echo

if [ "$REPLY" != "FORMATEAR" ]; then
    echo -e "${YELLOW}Operación cancelada${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  💾 PASO 3: Formatear SD (FAT32)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "Formateando $DISK_PATH como FAT32..."
diskutil eraseDisk FAT32 DAFANG MBRFormat "$DISK_PATH"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al formatear${NC}"
    exit 1
fi

echo -e "${GREEN}✅ SD formateada correctamente${NC}"
sleep 2

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📥 PASO 4: Descargar Firmware${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

WORK_DIR="$HOME/dafang_firmware_temp"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "Descargando Dafang Hacks desde GitHub..."
DOWNLOAD_URL="https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks/archive/refs/heads/master.zip"

curl -L -o dafang_hacks.zip "$DOWNLOAD_URL"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al descargar firmware${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Descarga completada${NC}"

echo ""
echo "Descomprimiendo..."
unzip -q dafang_hacks.zip

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al descomprimir${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Descompresión completada${NC}"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📋 PASO 5: Configuración WiFi${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "Necesitamos configurar la conexión WiFi de la cámara."
echo ""
read -p "SSID de tu WiFi: " WIFI_SSID
read -sp "Password de tu WiFi: " WIFI_PASSWORD
echo ""
echo ""

if [ -z "$WIFI_SSID" ] || [ -z "$WIFI_PASSWORD" ]; then
    echo -e "${RED}❌ SSID y password son requeridos${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📋 PASO 6: Configuración RTSP${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "Configuración de RTSP para Frigate."
echo ""
read -p "Usuario RTSP (default: admin): " RTSP_USER
RTSP_USER=${RTSP_USER:-admin}

read -sp "Password RTSP: " RTSP_PASSWORD
echo ""
echo ""

if [ -z "$RTSP_PASSWORD" ]; then
    echo -e "${YELLOW}⚠️  Usando password por defecto (NO recomendado)${NC}"
    RTSP_PASSWORD="ismart12"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📦 PASO 7: Copiar Archivos a SD${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

SD_MOUNT="/Volumes/DAFANG"

# Verificar que SD está montada
if [ ! -d "$SD_MOUNT" ]; then
    echo -e "${RED}❌ SD no está montada en $SD_MOUNT${NC}"
    echo "Intenta desmontar y volver a montar la SD"
    exit 1
fi

echo "Copiando archivos de firmware..."

# Buscar directorio descomprimido
FIRMWARE_DIR=$(find "$WORK_DIR" -name "Xiaomi-Dafang-Hacks-master" -type d | head -n 1)

if [ ! -d "$FIRMWARE_DIR" ]; then
    echo -e "${RED}❌ No se encontró el directorio de firmware${NC}"
    exit 1
fi

# Copiar firmware base
echo "Copiando archivos base..."
cp -R "$FIRMWARE_DIR/firmware_mod/"* "$SD_MOUNT/"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al copiar archivos${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Archivos copiados${NC}"

echo ""
echo "Configurando WiFi..."

# Crear configuración WiFi
cat > "$SD_MOUNT/config/wpa_supplicant.conf" << EOF
network={
    ssid="$WIFI_SSID"
    psk="$WIFI_PASSWORD"
    key_mgmt=WPA-PSK
}
EOF

echo -e "${GREEN}✅ WiFi configurado${NC}"

echo ""
echo "Configurando RTSP..."

# Crear configuración RTSP
cat > "$SD_MOUNT/config/rtspserver.conf" << EOF
RTSP_PORT=554
RTSP_USERNAME=$RTSP_USER
RTSP_PASSWORD=$RTSP_PASSWORD
RTSP_STREAM_PATH=/live/ch0
RTSP_AUTHENTICATION=1
EOF

echo -e "${GREEN}✅ RTSP configurado${NC}"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  ✅ PASO 8: Finalización${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "Verificando archivos..."
ls -la "$SD_MOUNT/" | head -10

echo ""
echo "Expulsando SD de forma segura..."
diskutil eject "$SD_MOUNT"

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  No se pudo expulsar automáticamente${NC}"
    echo "Expulsa la SD manualmente desde Finder"
fi

# Limpiar archivos temporales
echo ""
echo "Limpiando archivos temporales..."
rm -rf "$WORK_DIR"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  🎉 ¡TARJETA SD LISTA!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "📋 CONFIGURACIÓN GUARDADA:"
echo "  • WiFi SSID: $WIFI_SSID"
echo "  • RTSP User: $RTSP_USER"
echo "  • RTSP Password: $RTSP_PASSWORD"
echo "  • RTSP URL: rtsp://$RTSP_USER:$RTSP_PASSWORD@IP_CAMARA:554/live/ch0"
echo ""

# Guardar configuración en archivo
cat > "$HOME/dafang_config.txt" << EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONFIGURACIÓN DAFANG HACKS
Fecha: $(date)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WiFi:
  SSID: $WIFI_SSID
  Password: $WIFI_PASSWORD

RTSP:
  Usuario: $RTSP_USER
  Password: $RTSP_PASSWORD
  URL: rtsp://$RTSP_USER:$RTSP_PASSWORD@IP_CAMARA:554/live/ch0

SSH (después de instalación):
  Usuario: root
  Password por defecto: ismart12
  Comando: ssh root@IP_CAMARA

Web UI (después de instalación):
  URL: http://IP_CAMARA
  Usuario: admin
  Password: ismart12
EOF

echo "Configuración guardada en: $HOME/dafang_config.txt"
echo ""

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  📱 PRÓXIMOS PASOS${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "1. Retira la tarjeta SD del lector"
echo ""
echo "2. APAGA la cámara (desconecta cable)"
echo ""
echo "3. Inserta la SD en la cámara"
echo ""
echo "4. ENCIENDE la cámara (conecta cable)"
echo ""
echo "5. Espera 3-5 minutos (LED parpadeará)"
echo "   ⚠️  NO DESCONECTAR durante este tiempo"
echo ""
echo "6. Busca la IP de la cámara:"
echo "   nmap -sn 192.168.1.0/24 | grep -B 2 dafang"
echo ""
echo "7. Verifica RTSP:"
echo "   ffmpeg -i \"rtsp://$RTSP_USER:$RTSP_PASSWORD@IP:554/live/ch0\" -frames:v 1 test.jpg"
echo ""
echo "8. Si funciona, configura Frigate"
echo "   (ver guía en docs/XIAOMI_FIRMWARE_CUSTOM_GUIA.md)"
echo ""

echo -e "${GREEN}✅ Preparación completada${NC}"
echo ""

exit 0

