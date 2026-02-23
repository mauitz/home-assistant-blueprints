#!/bin/bash

# ═══════════════════════════════════════════════════════════
# Captura logs de proximidad del LightNode
# ═══════════════════════════════════════════════════════════

ESPHOME_DIR="/Users/maui/_maui/domotica/home-assistant-blueprints/esphome"
ESPHOME_BIN="/Users/maui/Library/Python/3.11/bin/esphome"
OUTPUT_FILE="/tmp/lightnode_proximity_logs.txt"

cd "$ESPHOME_DIR" || exit 1

echo "Capturando logs de proximidad durante 30 segundos..."
echo "Por favor:"
echo "  1. Activa '1. Control Automático' en Home Assistant"
echo "  2. Camina hacia el sensor desde 2-3 metros"
echo "  3. Pasa junto al sensor"
echo "  4. Aléjate"
echo ""
echo "Iniciando captura..."
echo ""

# Capturar logs filtrados durante 30 segundos
(echo "2"; sleep 35) | "$ESPHOME_BIN" logs lightnode_entrance.yaml 2>&1 | \
grep --line-buffered -E "(Distancia:|auto,|Brillo|proximidad|Presencia)" | \
head -50 > "$OUTPUT_FILE"

echo "═══════════════════════════════════════════════════════"
echo "LOGS CAPTURADOS:"
echo "═══════════════════════════════════════════════════════"
cat "$OUTPUT_FILE"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "Archivo guardado en: $OUTPUT_FILE"
