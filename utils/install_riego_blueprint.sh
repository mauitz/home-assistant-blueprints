#!/bin/bash

# ============================================
# Script de Instalación - Sistema de Riego Inteligente
# ============================================

set -e

echo "🚰 Instalador del Blueprint de Riego Inteligente"
echo "================================================"
echo ""

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BLUEPRINT_FILE="$PROJECT_ROOT/blueprints/sistema_riego_inteligente.yaml"
EXAMPLE_FILE="$PROJECT_ROOT/examples/automatizaciones/riego_z1_auto.yaml"
DOC_FILE="$PROJECT_ROOT/docs/automatizaciones/RIEGO_INTELIGENTE.md"

# Detectar Home Assistant
echo -e "${BLUE}📍 Detectando Home Assistant...${NC}"

# Opciones comunes de ubicación
HA_CONFIG_PATHS=(
    "/config"                                    # Home Assistant OS / Supervised
    "$HOME/.homeassistant"                       # Home Assistant Core
    "/usr/share/hassio/homeassistant"           # Hassio
    "$HOME/homeassistant"                        # Instalación manual
)

HA_CONFIG=""
for path in "${HA_CONFIG_PATHS[@]}"; do
    if [ -d "$path" ] && [ -f "$path/configuration.yaml" ]; then
        HA_CONFIG="$path"
        break
    fi
done

if [ -z "$HA_CONFIG" ]; then
    echo -e "${YELLOW}⚠️  No se detectó automáticamente Home Assistant${NC}"
    echo ""
    echo "Por favor, ingresa la ruta de configuración de Home Assistant:"
    echo "(ejemplo: /config o /home/usuario/.homeassistant)"
    read -p "Ruta: " HA_CONFIG

    if [ ! -d "$HA_CONFIG" ] || [ ! -f "$HA_CONFIG/configuration.yaml" ]; then
        echo -e "${YELLOW}❌ Ruta inválida o no es una instalación de Home Assistant${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Home Assistant encontrado en: $HA_CONFIG${NC}"
echo ""

# Crear directorios
echo -e "${BLUE}📁 Creando estructura de directorios...${NC}"
mkdir -p "$HA_CONFIG/blueprints/automation/mauitz"
mkdir -p "$HA_CONFIG/blueprints/script/mauitz"

# Copiar blueprint
echo -e "${BLUE}📋 Copiando blueprint...${NC}"
cp "$BLUEPRINT_FILE" "$HA_CONFIG/blueprints/automation/mauitz/"
echo -e "${GREEN}✅ Blueprint copiado${NC}"

# Copiar ejemplo (opcional)
if [ -f "$EXAMPLE_FILE" ]; then
    echo ""
    read -p "¿Copiar también el ejemplo de configuración? (s/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
        mkdir -p "$HA_CONFIG/packages"
        cp "$EXAMPLE_FILE" "$HA_CONFIG/packages/riego_z1.yaml"
        echo -e "${GREEN}✅ Ejemplo copiado a packages/riego_z1.yaml${NC}"
        echo -e "${YELLOW}⚠️  Recuerda habilitar packages en configuration.yaml:${NC}"
        echo ""
        echo "homeassistant:"
        echo "  packages: !include_dir_named packages"
        echo ""
    fi
fi

# Mostrar siguiente paso
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Instalación completada${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📋 Próximos pasos:${NC}"
echo ""
echo "1. Reinicia Home Assistant o recarga las automatizaciones:"
echo "   Herramientas para desarrolladores → YAML → Recargar → Automatizaciones"
echo ""
echo "2. Crea los helpers recomendados:"
echo "   Configuración → Dispositivos y Servicios → Helpers → Crear Helper"
echo ""
echo "   - Input Boolean: riego_z1_manual (Modo Manual)"
echo "   - Input DateTime: riego_z1_ultimo (Último Riego)"
echo "   - Input Number: riego_z1_contador (Contador de Ciclos)"
echo ""
echo "3. Crea la automatización:"
echo "   Configuración → Automatizaciones → Crear → Desde Blueprint"
echo "   → 'Sistema de Riego Inteligente'"
echo ""
echo "4. Consulta la documentación completa:"
echo "   $DOC_FILE"
echo ""
echo -e "${BLUE}🎉 ¡Listo para automatizar tu riego!${NC}"

