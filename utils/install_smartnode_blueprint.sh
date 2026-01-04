#!/bin/bash

# ============================================================
# Script de Instalación: SmartNode Presence Lighting Blueprint
# ============================================================
#
# Este script copia el blueprint a la ubicación correcta de
# Home Assistant y proporciona instrucciones de uso.
#
# Uso:
#   ./install_smartnode_blueprint.sh
#
# ============================================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir con color
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Banner
echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║   SmartNode Presence Lighting Blueprint Installer     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Detectar directorio de trabajo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

print_info "Directorio del proyecto: $PROJECT_ROOT"

# Verificar que existe el blueprint
BLUEPRINT_SRC="$PROJECT_ROOT/blueprints/smartnode_presence_lighting.yaml"

if [ ! -f "$BLUEPRINT_SRC" ]; then
    print_error "No se encuentra el blueprint en: $BLUEPRINT_SRC"
    exit 1
fi

print_success "Blueprint encontrado"

# Ruta de destino en Home Assistant
HA_CONFIG="$PROJECT_ROOT/HA_config_proxy"
BLUEPRINT_DEST="$HA_CONFIG/blueprints/automation/mauitz"

# Verificar que existe el directorio de HA
if [ ! -d "$HA_CONFIG" ]; then
    print_error "No se encuentra el directorio de Home Assistant: $HA_CONFIG"
    exit 1
fi

print_success "Directorio de Home Assistant encontrado"

# Crear directorio de blueprints si no existe
print_info "Creando estructura de directorios..."
mkdir -p "$BLUEPRINT_DEST"

# Copiar blueprint
print_info "Copiando blueprint..."
cp "$BLUEPRINT_SRC" "$BLUEPRINT_DEST/smartnode_presence_lighting.yaml"

print_success "Blueprint instalado en: $BLUEPRINT_DEST"

# Verificar instalación
if [ -f "$BLUEPRINT_DEST/smartnode_presence_lighting.yaml" ]; then
    print_success "¡Instalación completada exitosamente!"
else
    print_error "Error en la instalación"
    exit 1
fi

# Mostrar próximos pasos
echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║                   PRÓXIMOS PASOS                       ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

print_info "1. Reiniciar Home Assistant o recargar automatizaciones:"
echo "   - Ir a Configuración → YAML → Recargar automatizaciones"
echo ""

print_info "2. Eliminar automatizaciones antiguas:"
echo "   - Habitación - Presencia Detectada (ID: 1734450000001)"
echo "   - Habitación - Sin Presencia (ID: 1734450000002)"
echo ""

print_info "3. Crear nueva automatización:"
echo "   - Ir a Configuración → Automatizaciones → Crear"
echo "   - Seleccionar: SmartNode - Iluminación Automática por Presencia"
echo ""

print_info "4. Configurar parámetros para el dormitorio:"
echo "   - Sensor de Presencia: binary_sensor.presence"
echo "   - Sensor de Luminosidad: sensor.room_brightness"
echo "   - Luz: switch.bedroom_3_switch_switch_1"
echo "   - Umbral de Oscuridad: 30%"
echo "   - Delay al Apagar: 5 segundos"
echo ""

print_info "5. Probar la automatización:"
echo "   - Ver: docs/automatizaciones/MIGRACION_SMARTNODE_LIGHTING.md"
echo ""

print_warning "IMPORTANTE: Hacer backup de automations.yaml antes de eliminar las automatizaciones antiguas"

echo ""
print_success "¡Listo! El blueprint está instalado y listo para usar."
echo ""

# Mostrar ubicación del ejemplo
print_info "Archivo de ejemplo disponible en:"
echo "   $PROJECT_ROOT/examples/automatizaciones/bedroom_smartnode_lighting.yaml"
echo ""

# Mostrar ubicación de la documentación
print_info "Documentación completa en:"
echo "   $PROJECT_ROOT/docs/automatizaciones/MIGRACION_SMARTNODE_LIGHTING.md"
echo ""


