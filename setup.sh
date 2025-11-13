#!/bin/bash
# Setup script para Home Assistant Blueprint Manager

set -e

echo "════════════════════════════════════════════════════════════════"
echo "              🚀 CONFIGURACIÓN AUTOMÁTICA"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Check if .env exists
if [ -f ".env" ]; then
    echo "⚠️  El archivo .env ya existe."
    read -p "¿Quieres recrearlo? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "✅ Usando .env existente"
    else
        rm .env
    fi
fi

# Create .env if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creando archivo .env..."
    
    # Prompt for token
    echo ""
    echo "Por favor, pega tu token de acceso de Home Assistant:"
    echo "(El token que acabas de crear en HA)"
    read -r HA_TOKEN
    
    # Create .env file
    cat > .env << EOL
# Home Assistant Configuration
HA_URL=http://192.168.1.100:8123
HA_TOKEN=${HA_TOKEN}
EOL
    
    echo "✅ Archivo .env creado"
fi

echo ""
echo "────────────────────────────────────────────────────────────────"
echo "              📦 INSTALANDO DEPENDENCIAS"
echo "────────────────────────────────────────────────────────────────"
echo ""

# Check if pip3 is available
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 no está instalado"
    echo "   Instala Python 3: brew install python3"
    exit 1
fi

# Install requirements
echo "Instalando requests y python-dotenv..."
pip3 install -q -r requirements.txt

echo "✅ Dependencias instaladas"

echo ""
echo "────────────────────────────────────────────────────────────────"
echo "              🔍 TESTEANDO CONEXIÓN"
echo "────────────────────────────────────────────────────────────────"
echo ""

# Load .env (ignorar comentarios)
set -a
source .env
set +a

# Test connection
python3 ha_manager.py test

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "              ✅ CONFIGURACIÓN COMPLETA"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Comandos disponibles:"
echo "  python3 ha_manager.py test       # Test conexión"
echo "  python3 ha_manager.py status     # Ver estado completo"
echo "  python3 ha_manager.py diagnose   # Diagnosticar problemas"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

