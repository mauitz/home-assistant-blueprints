#!/bin/bash

# Script para probar el micrófono del smartnode1
# Verifica logs y estado del componente I2S

echo "🎤 PRUEBA DE MICRÓFONO SMARTNODE1"
echo "================================="
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "1️⃣ Verificando conectividad con smartnode1..."
if ping -c 1 -W 1 192.168.1.13 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ SmartNode1 responde en 192.168.1.13${NC}"
else
    echo -e "${RED}❌ No se puede conectar con SmartNode1${NC}"
    exit 1
fi

echo ""
echo "2️⃣ Conectando a logs de ESPHome..."
echo -e "${YELLOW}Busca estas líneas para confirmar que el micrófono está OK:${NC}"
echo "   - [I][i2s_audio:...] Setting up I2S..."
echo "   - [I][microphone:...] Setting up Microphone..."
echo ""
echo -e "${YELLOW}Si ves errores como 'I2S timeout' o 'Failed to read', el micrófono NO está bien conectado${NC}"
echo ""
echo "Presiona Ctrl+C cuando termines de revisar los logs"
echo ""

# Esperar confirmación del usuario
read -p "Presiona ENTER para ver los logs en tiempo real..."

# Conectar a los logs
python3 -m esphome logs /Users/maui/_maui/domotica/home-assistant-blueprints/esphome/smartnode1.yaml
