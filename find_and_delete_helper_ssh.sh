#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
# Buscar y Eliminar presence_simulation_2 del servidor vía SSH
# ════════════════════════════════════════════════════════════════════════════

set -e

HA_HOST="192.168.1.100"
HA_USER="nico"
HA_PASSWORD="NicoMaui1"

echo "════════════════════════════════════════════════════════════════"
echo "      BUSCAR Y ELIMINAR presence_simulation_2"
echo "════════════════════════════════════════════════════════════════"
echo ""

echo "🔍 Conectando al servidor y buscando presence_simulation_2..."
echo ""

ssh -o StrictHostKeyChecking=no "$HA_USER@$HA_HOST" << 'ENDSSH'

cd /config

echo "📂 Buscando en archivos YAML..."
echo "────────────────────────────────────────────────────────────────"

# Buscar en todos los archivos YAML
YAML_FILES=$(find . -name "*.yaml" -o -name "*.yml" 2>/dev/null | grep -v ".storage")

for file in $YAML_FILES; do
    if grep -q "presence_simulation_2" "$file" 2>/dev/null; then
        echo "✓ Encontrado en: $file"
        grep -n "presence_simulation_2" "$file"
    fi
done

echo ""
echo "📂 Buscando en directorio packages/..."
echo "────────────────────────────────────────────────────────────────"

if [ -d "packages" ]; then
    if grep -r "presence_simulation_2" packages/ 2>/dev/null; then
        echo "✓ Encontrado en packages/"
    else
        echo "✗ No encontrado en packages/"
    fi
else
    echo "✗ No existe directorio packages/"
fi

echo ""
echo "📂 Buscando en archivos .storage/..."
echo "────────────────────────────────────────────────────────────────"

if grep -l "presence_simulation_2" .storage/*.json 2>/dev/null; then
    echo ""
    echo "Archivos que contienen presence_simulation_2:"
    grep -l "presence_simulation_2" .storage/*.json 2>/dev/null

    echo ""
    echo "Contenido relevante:"
    grep -C 3 "presence_simulation_2" .storage/*.json 2>/dev/null | head -20
fi

echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

ENDSSH

echo ""
echo "✅ Búsqueda completada"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "              📋 PRÓXIMOS PASOS"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Si se encontró en archivos YAML:"
echo "  → Editar ese archivo y eliminar la definición"
echo "  → Copiar el archivo actualizado al servidor"
echo "  → Reiniciar Home Assistant"
echo ""
echo "Si se encontró en .storage/:"
echo "  → Es un archivo interno de HA"
echo "  → Se puede editar manualmente con MUCHO cuidado"
echo "  → O intentar forzar recarga desde la UI"
echo ""
echo "════════════════════════════════════════════════════════════════"


