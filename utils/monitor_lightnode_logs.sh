#!/bin/bash

# LightNode - Monitor de Logs en Tiempo Real
# Filtra logs relevantes para diagnosticar el sensor de proximidad

echo "═══════════════════════════════════════════════════"
echo "  LightNode Entrance - Monitor de Logs"
echo "═══════════════════════════════════════════════════"
echo ""
echo "📡 Conectando a 192.168.1.15..."
echo "🔍 Filtrando logs de: Distancia, Brillo, Auto, Presencia"
echo ""
echo "💡 Tip: Muévete cerca/lejos del sensor para ver los cambios"
echo "⏹️  Presiona Ctrl+C para detener"
echo ""
echo "═══════════════════════════════════════════════════"
echo ""

cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome

/Users/maui/Library/Python/3.11/bin/esphome logs lightnode_entrance.yaml \
  --device 192.168.1.15 2>&1 | \
  grep --line-buffered -E "(Distancia|Brillo|auto|Presencia|Setting:)"
