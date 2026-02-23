#!/bin/bash

# ═══════════════════════════════════════════════════════════
# LightNode - Análisis de Logs de Proximidad
# ═══════════════════════════════════════════════════════════

ESPHOME_DIR="/Users/maui/_maui/domotica/home-assistant-blueprints/esphome"
ESPHOME_BIN="/Users/maui/Library/Python/3.11/bin/esphome"
LIGHTNODE_IP="192.168.1.14"

echo "════════════════════════════════════════════════════════"
echo "  ANÁLISIS DE PROXIMIDAD - LIGHTNODE ENTRANCE"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Configuración actual esperada:"
echo "  • Distancia Inicio (X): 200cm"
echo "  • Brillo Inicio (Y): 20%"
echo "  • Distancia Máxima (Z): 50cm"
echo ""
echo "Comportamiento esperado:"
echo "  • Distancia > 200cm → Brillo 0%"
echo "  • Distancia = 200cm → Brillo 20%"
echo "  • Distancia = 125cm → Brillo 60% (interpolado)"
echo "  • Distancia ≤ 50cm → Brillo 100%"
echo ""
echo "════════════════════════════════════════════════════════"
echo ""
echo "Conectando a logs..."
echo "Busca líneas como:"
echo "  [D] Distancia: XXXcm → Brillo: XX%"
echo ""
echo "Presiona Ctrl+C para salir"
echo ""
sleep 2

cd "$ESPHOME_DIR" || exit 1

# Conectar a logs y filtrar solo las líneas de proximidad
"$ESPHOME_BIN" logs lightnode_entrance.yaml --device "$LIGHTNODE_IP" 2>&1 | grep --line-buffered -E "(Distancia:|auto,|Brillo|proximidad)"
