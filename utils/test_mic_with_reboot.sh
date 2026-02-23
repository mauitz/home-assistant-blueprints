#!/bin/bash

# Script para reiniciar SmartNode1 y capturar logs de arranque del micrófono

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎤 PRUEBA DEFINITIVA DEL MICRÓFONO${NC}"
echo "=========================================="
echo ""
echo "Este script va a:"
echo "  1. Conectarse a los logs del SmartNode1"
echo "  2. Pedirte que reinicies el dispositivo"
echo "  3. Capturar los mensajes de inicialización del I2S/Micrófono"
echo ""
echo -e "${YELLOW}⚠️  Necesitas acceso a Home Assistant para reiniciar el dispositivo${NC}"
echo ""
read -p "Presiona ENTER para continuar..."
echo ""

cd /Users/maui/_maui/domotica/home-assistant-blueprints

echo -e "${GREEN}📡 Conectando a logs del SmartNode1...${NC}"
echo ""
echo -e "${YELLOW}🔄 AHORA: Ve a Home Assistant y reinicia el SmartNode1:${NC}"
echo "   Configuración → Dispositivos → SmartNode1 → Reiniciar"
echo ""
echo -e "${BLUE}Busca estos mensajes durante el arranque:${NC}"
echo ""
echo -e "${GREEN}   ✅ [I][i2s_audio:xxx] Setting up I2S Audio...${NC}"
echo -e "${GREEN}   ✅ [I][microphone:xxx] Setting up Microphone...${NC}"
echo ""
echo -e "${YELLOW}Si ves errores de I2S, el micrófono tiene problemas de hardware.${NC}"
echo ""
echo "Presiona Ctrl+C para salir cuando termines de ver los logs"
echo ""
echo "=========================================="
sleep 2

# Conectar a logs en tiempo real
python3 -m esphome logs esphome/smartnode1.yaml
