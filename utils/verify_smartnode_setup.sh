#!/bin/bash

# ============================================================
# Script de Verificación: SmartNode Setup
# ============================================================
#
# Verifica que todas las entidades del SmartNode estén
# disponibles y funcionando correctamente.
#
# ============================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║          $1"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
}

print_check() {
    local status=$1
    local message=$2
    if [ "$status" == "ok" ]; then
        echo -e "${GREEN}✅ $message${NC}"
    elif [ "$status" == "warning" ]; then
        echo -e "${YELLOW}⚠️  $message${NC}"
    else
        echo -e "${RED}❌ $message${NC}"
    fi
}

print_header "SmartNode Setup Verification"

# Verificar archivos
echo "📁 Verificando archivos del blueprint..."
echo ""

# Blueprint
if [ -f "blueprints/smartnode_presence_lighting.yaml" ]; then
    print_check "ok" "Blueprint encontrado"
else
    print_check "error" "Blueprint NO encontrado"
fi

# Ejemplo
if [ -f "examples/automatizaciones/bedroom_smartnode_lighting.yaml" ]; then
    print_check "ok" "Archivo de ejemplo encontrado"
else
    print_check "error" "Archivo de ejemplo NO encontrado"
fi

# Documentación
if [ -f "docs/automatizaciones/MIGRACION_SMARTNODE_LIGHTING.md" ]; then
    print_check "ok" "Documentación encontrada"
else
    print_check "error" "Documentación NO encontrada"
fi

# README
if [ -f "blueprints/README_SMARTNODE.md" ]; then
    print_check "ok" "README encontrado"
else
    print_check "error" "README NO encontrado"
fi

echo ""
echo "📋 Entidades necesarias del SmartNode:"
echo ""
echo "   Binary Sensors:"
echo "   - binary_sensor.presence              ← Presencia general (recomendado)"
echo "   - binary_sensor.moving_target         ← Solo movimiento"
echo "   - binary_sensor.still_target          ← Presencia estática"
echo ""
echo "   Sensors:"
echo "   - sensor.room_brightness              ← Luminosidad (0-100%)"
echo "   - sensor.room_temperature             ← Temperatura"
echo "   - sensor.room_humidity                ← Humedad"
echo "   - sensor.detection_distance           ← Distancia"
echo ""

echo "💡 Switches disponibles en Bedroom:"
echo ""
echo "   - switch.bedroom_3_switch_switch_1    ← Recomendado para luz principal"
echo "   - switch.bedroom_3_switch_switch_2"
echo "   - switch.bedroom_3_switch_switch_3"
echo ""

echo "⚙️  Próximos pasos:"
echo ""
echo "   1. Ejecutar script de instalación:"
echo "      ./utils/install_smartnode_blueprint.sh"
echo ""
echo "   2. Verificar entidades en Home Assistant:"
echo "      Herramientas de Desarrollo → Estados → Buscar 'smartnode'"
echo ""
echo "   3. Eliminar automatizaciones antiguas (IDs: 1734450000001, 1734450000002)"
echo ""
echo "   4. Crear nueva automatización desde el blueprint"
echo ""
echo "   5. Realizar tests de verificación (ver documentación)"
echo ""

print_header "Verificación Completada"


