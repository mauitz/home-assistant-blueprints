#!/bin/bash

# ═══════════════════════════════════════════════════════════
# LightNode - Script de Prueba de LEDs
# ═══════════════════════════════════════════════════════════
# Prueba automática de los controles de iluminación
# Uso: ./test_lightnode_leds.sh
# ═══════════════════════════════════════════════════════════

set -e

LIGHTNODE_IP="192.168.1.14"
ESPHOME_DIR="/Users/maui/_maui/domotica/home-assistant-blueprints/esphome"
ESPHOME_BIN="/Users/maui/Library/Python/3.11/bin/esphome"

echo "════════════════════════════════════════════════════════"
echo "  LIGHTNODE ENTRANCE - PRUEBA DE LEDS"
echo "════════════════════════════════════════════════════════"
echo ""

# Función para esperar
wait_seconds() {
    local seconds=$1
    echo -n "Esperando ${seconds}s..."
    sleep "$seconds"
    echo " ✓"
}

# Verificar conectividad
echo "1️⃣  Verificando conectividad con LightNode..."
if ping -c 2 -W 2 "$LIGHTNODE_IP" &>/dev/null; then
    echo "   ✅ LightNode responde en $LIGHTNODE_IP"
else
    echo "   ❌ No se puede alcanzar $LIGHTNODE_IP"
    echo "   Verifica que el ESP32 esté encendido y conectado"
    exit 1
fi

echo ""
echo "2️⃣  Conectando a logs de ESPHome..."
echo "   Presiona Ctrl+C después de observar 30 segundos"
echo "   Busca mensajes como:"
echo "   - 'Luz derecha ON al XX%'"
echo "   - 'Control automático DESACTIVADO'"
echo ""
echo "   Abriendo logs en 3 segundos..."
wait_seconds 3

cd "$ESPHOME_DIR" || exit 1

# Mostrar logs por 30 segundos
echo ""
echo "════════════════════════════════════════════════════════"
echo "  LOGS EN TIEMPO REAL (Ctrl+C para salir)"
echo "════════════════════════════════════════════════════════"
timeout 30 "$ESPHOME_BIN" logs lightnode_entrance.yaml 2>&1 || true

echo ""
echo "════════════════════════════════════════════════════════"
echo "  INSTRUCCIONES PARA PRUEBA MANUAL"
echo "════════════════════════════════════════════════════════"
echo ""
echo "En Home Assistant (http://192.168.1.100:8123):"
echo ""
echo "Configuración → Dispositivos → LightNode Entrance"
echo ""
echo "PRUEBA 1: Luz Derecha"
echo "  1. '1. Control Automático' → OFF"
echo "  2. '4. Dimmer Derecha' → 100%"
echo "  3. '3. Luz Derecha' → ON"
echo "  4. ¿La guirnalda derecha enciende?"
echo ""
echo "PRUEBA 2: Luz Izquierda"
echo "  1. '6. Dimmer Izquierda' → 100%"
echo "  2. '5. Luz Izquierda' → ON"
echo "  3. ¿La guirnalda izquierda enciende?"
echo ""
echo "PRUEBA 3: Dimmer"
echo "  1. Con luces encendidas"
echo "  2. Baja '4. Dimmer Derecha' a 50%"
echo "  3. ¿El brillo disminuye?"
echo ""
echo "════════════════════════════════════════════════════════"
echo "  DIAGNÓSTICO"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Si las luces NO encienden:"
echo ""
echo "  📖 Lee: docs/lightnode/TROUBLESHOOTING_LUCES.md"
echo ""
echo "  Verificaciones rápidas:"
echo "  1. ¿Viste mensajes 'Luz derecha ON' en los logs?"
echo "  2. ¿Las guirnaldas funcionan conectadas directamente a 5V?"
echo "  3. ¿Los transistores BC337 están bien orientados?"
echo "  4. ¿Las resistencias tienen los valores correctos?"
echo ""
echo "  Herramientas necesarias:"
echo "  - Multímetro"
echo "  - Documento de troubleshooting (ruta arriba)"
echo ""
echo "════════════════════════════════════════════════════════"
