#!/bin/bash
# Script para probar acceso RTSP a cámara Xiaomi
# Uso: ./test_rtsp_xiaomi.sh IP_CAMARA

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🎥 TEST DE RTSP - CÁMARA XIAOMI${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verificar argumentos
if [ -z "$1" ]; then
    echo -e "${RED}❌ Error: Debes proporcionar la IP de la cámara${NC}"
    echo ""
    echo "Uso:"
    echo "  $0 IP_CAMARA"
    echo ""
    echo "Ejemplo:"
    echo "  $0 192.168.1.150"
    echo ""
    exit 1
fi

CAMERA_IP=$1

# Verificar que ffmpeg esté instalado
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}❌ ffmpeg no está instalado${NC}"
    echo ""
    echo "Para instalar:"
    echo "  brew install ffmpeg"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ ffmpeg encontrado${NC}"
echo ""

# Crear directorio para tests
TEST_DIR="rtsp_tests_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$TEST_DIR"
echo -e "${GREEN}✅ Creado directorio: $TEST_DIR${NC}"
echo ""

# Array de URLs RTSP a probar
declare -a RTSP_URLS=(
    "rtsp://admin:admin@${CAMERA_IP}:554/live/ch0"
    "rtsp://admin:admin@${CAMERA_IP}:554/stream1"
    "rtsp://admin:admin@${CAMERA_IP}:554/stream2"
    "rtsp://admin:admin@${CAMERA_IP}:8554/live"
    "rtsp://admin:admin@${CAMERA_IP}:8554/live/ch0"
    "rtsp://root:@${CAMERA_IP}:554/live/ch0"
    "rtsp://root:@${CAMERA_IP}:554/stream1"
    "rtsp://admin:@${CAMERA_IP}:554/live/ch0"
    "rtsp://admin:@${CAMERA_IP}:554/stream1"
    "rtsp://${CAMERA_IP}:554/live/ch0"
)

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🔍 PROBANDO CONECTIVIDAD${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 1. Ping
echo -n "🔌 Ping a $CAMERA_IP... "
if ping -c 3 -W 2 "$CAMERA_IP" &> /dev/null; then
    echo -e "${GREEN}✅ Responde${NC}"
else
    echo -e "${RED}❌ No responde${NC}"
    echo ""
    echo -e "${YELLOW}La cámara no responde a ping. Verifica:${NC}"
    echo "  1. IP correcta"
    echo "  2. Cámara encendida"
    echo "  3. Misma red WiFi"
    echo ""
    exit 1
fi

# 2. Test puerto 554 (RTSP estándar)
echo -n "🔌 Puerto 554 (RTSP)... "
if timeout 3 bash -c "cat < /dev/null > /dev/tcp/${CAMERA_IP}/554" 2>/dev/null; then
    echo -e "${GREEN}✅ Abierto${NC}"
else
    echo -e "${YELLOW}⚠️  Cerrado o no responde${NC}"
fi

# 3. Test puerto 8554 (RTSP alternativo)
echo -n "🔌 Puerto 8554 (RTSP alt)... "
if timeout 3 bash -c "cat < /dev/null > /dev/tcp/${CAMERA_IP}/8554" 2>/dev/null; then
    echo -e "${GREEN}✅ Abierto${NC}"
else
    echo -e "${YELLOW}⚠️  Cerrado o no responde${NC}"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🎬 PROBANDO URLs RTSP${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

SUCCESS_COUNT=0
TOTAL_URLS=${#RTSP_URLS[@]}

for i in "${!RTSP_URLS[@]}"; do
    url="${RTSP_URLS[$i]}"
    test_num=$((i + 1))
    output_file="$TEST_DIR/test_${test_num}.jpg"

    echo -e "${YELLOW}[$test_num/$TOTAL_URLS]${NC} Probando:"

    # Mostrar URL ofuscando password
    display_url=$(echo "$url" | sed -E 's/:([^@]+)@/:***@/')
    echo "  📹 $display_url"

    # Probar capturar frame (timeout 10 segundos)
    if timeout 10 ffmpeg -rtsp_transport tcp -i "$url" -frames:v 1 -f image2 "$output_file" -y &> "$TEST_DIR/test_${test_num}.log" 2>&1; then
        file_size=$(stat -f%z "$output_file" 2>/dev/null || echo "0")

        if [ "$file_size" -gt 1000 ]; then
            echo -e "  ${GREEN}✅ ÉXITO - Imagen capturada (${file_size} bytes)${NC}"
            echo -e "  📁 Guardada en: $output_file"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))

            # Si es el primer éxito, mostrar más info
            if [ $SUCCESS_COUNT -eq 1 ]; then
                echo ""
                echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
                echo -e "${GREEN}  🎉 ¡RTSP FUNCIONA!${NC}"
                echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
                echo ""
                echo -e "${GREEN}✅ URL funcional encontrada:${NC}"
                echo "  $url"
                echo ""
                echo "Puedes ver la imagen capturada:"
                echo "  open $output_file"
                echo ""
            fi
        else
            echo -e "  ${RED}❌ Falló - Archivo vacío${NC}"
        fi
    else
        echo -e "  ${RED}❌ Falló - Timeout o error de conexión${NC}"
    fi

    echo ""
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📊 RESUMEN${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $SUCCESS_COUNT -gt 0 ]; then
    echo -e "${GREEN}✅ URLs funcionando: $SUCCESS_COUNT de $TOTAL_URLS${NC}"
    echo ""
    echo -e "${GREEN}🎯 PRÓXIMOS PASOS:${NC}"
    echo ""
    echo "1. Abrir imágenes capturadas:"
    echo "   open $TEST_DIR/*.jpg"
    echo ""
    echo "2. Identificar la mejor URL (mejor calidad)"
    echo ""
    echo "3. Agregar a Frigate config:"
    echo "   ssh nico@192.168.1.100"
    echo "   nano /home/nico/frigate/config/config.yml"
    echo ""
    echo "4. Usar la URL exitosa en configuración"
    echo ""
    echo "5. Ver ejemplo de configuración en:"
    echo "   cat RESUMEN_INVESTIGACION.md"
    echo ""
else
    echo -e "${RED}❌ No se pudo conectar con ninguna URL RTSP${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  POSIBLES CAUSAS:${NC}"
    echo ""
    echo "1. La cámara NO tiene RTSP habilitado"
    echo "   → Algunas Xiaomi no lo tienen por defecto"
    echo ""
    echo "2. Credenciales incorrectas"
    echo "   → Intenta desde la app Xiaomi Home:"
    echo "   → Configuración → Credenciales RTSP"
    echo ""
    echo "3. Firmware bloqueado"
    echo "   → Modelos nuevos pueden tener RTSP bloqueado"
    echo "   → Considera firmware custom o cámara alternativa"
    echo ""
    echo -e "${YELLOW}💡 ALTERNATIVAS:${NC}"
    echo ""
    echo "A. Instalar firmware custom:"
    echo "   https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks"
    echo ""
    echo "B. Reemplazar por cámara con RTSP nativo:"
    echo "   • Tapo C310/C320 (~\$35)"
    echo "   • Reolink E1 Pro"
    echo "   • Cualquier cámara compatible con Frigate"
    echo ""
    echo "C. Usar solo para control (estado actual)"
    echo "   • Sin video en HA"
    echo "   • Sin detección IA"
    echo ""
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📁 ARCHIVOS GENERADOS${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Directorio: $TEST_DIR/"
echo "  • Imágenes capturadas: test_*.jpg"
echo "  • Logs de ffmpeg: test_*.log"
echo ""
echo "Para revisar logs de errores:"
echo "  cat $TEST_DIR/test_*.log"
echo ""

# Ofrecer abrir directorio
if [ $SUCCESS_COUNT -gt 0 ]; then
    read -p "¿Abrir directorio con resultados? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "$TEST_DIR"
    fi
fi

echo ""
echo -e "${GREEN}✅ Test completado${NC}"
echo ""

exit 0

