#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
# Script de Limpieza del Sistema Home Assistant via SSH
# ════════════════════════════════════════════════════════════════════════════

set -e

HA_HOST="192.168.1.100"
HA_USER="nico"
HA_PASSWORD="NicoMaui1"
CONFIG_PATH="/config"

echo "════════════════════════════════════════════════════════════════"
echo "      LIMPIEZA DEL SISTEMA VIA SSH"
echo "════════════════════════════════════════════════════════════════"
echo ""

# ────────────────────────────────────────────────────────────────────────────
# 1. LIMPIAR AUTOMATIZACIONES DESACTIVADAS
# ────────────────────────────────────────────────────────────────────────────
echo "🤖 1. LIMPIANDO AUTOMATIZACIONES DESACTIVADAS"
echo "────────────────────────────────────────────────────────────────"
echo ""

# Obtener lista de automatizaciones desactivadas
echo "Buscando automatizaciones desactivadas..."

sshpass -p "$HA_PASSWORD" ssh -o StrictHostKeyChecking=no "$HA_USER@$HA_HOST" << 'EOF'
cd /config

# Backup del archivo original
cp automations.yaml automations.yaml.backup.$(date +%Y%m%d_%H%M%S)

# Buscar y mostrar automatizaciones con initial_state: off o disabled: true
echo "Automatizaciones desactivadas encontradas:"
echo ""

python3 << 'PYTHON_EOF'
import yaml
import sys

try:
    with open('automations.yaml', 'r') as f:
        automations = yaml.safe_load(f) or []

    # Si no es una lista, convertirla
    if not isinstance(automations, list):
        automations = [automations]

    disabled = []
    enabled = []

    for auto in automations:
        if auto is None:
            continue

        # Verificar si está desactivada
        is_disabled = (
            auto.get('disabled', False) or
            auto.get('initial_state') == 'off' or
            auto.get('initial_state') is False
        )

        if is_disabled:
            disabled.append(auto)
            alias = auto.get('alias', auto.get('id', 'Sin nombre'))
            print(f"  🔴 {alias}")
        else:
            enabled.append(auto)

    # Si hay desactivadas, crear archivo limpio
    if disabled:
        print(f"\nTotal desactivadas: {len(disabled)}")
        print(f"Total activas: {len(enabled)}")

        # Guardar solo las activas
        with open('automations.yaml.clean', 'w') as f:
            yaml.dump(enabled, f, default_flow_style=False, allow_unicode=True, sort_keys=False)

        print("\n✅ Archivo limpio creado: automations.yaml.clean")
        sys.exit(0)
    else:
        print("✅ No se encontraron automatizaciones desactivadas")
        sys.exit(1)

except Exception as e:
    print(f"❌ Error: {e}")
    sys.exit(2)

PYTHON_EOF

# Verificar resultado del script Python
if [ $? -eq 0 ]; then
    echo ""
    echo "¿Deseas aplicar los cambios? (se creará backup)"
    echo "Reemplazando automations.yaml con la versión limpia..."

    # Aplicar cambios
    mv automations.yaml.clean automations.yaml

    echo "✅ Automatizaciones desactivadas eliminadas"
else
    echo "✅ No hay cambios necesarios en automatizaciones"
fi

EOF

echo ""

# ────────────────────────────────────────────────────────────────────────────
# 2. LIMPIAR HELPERS OBSOLETOS DEL CONFIGURATION.YAML
# ────────────────────────────────────────────────────────────────────────────
echo "────────────────────────────────────────────────────────────────"
echo "📦 2. LIMPIANDO HELPERS OBSOLETOS"
echo "────────────────────────────────────────────────────────────────"
echo ""

sshpass -p "$HA_PASSWORD" ssh -o StrictHostKeyChecking=no "$HA_USER@$HA_HOST" << 'EOF'
cd /config

# Backup
cp configuration.yaml configuration.yaml.backup.$(date +%Y%m%d_%H%M%S)

# Eliminar helpers obsoletos
echo "Eliminando helpers obsoletos de configuration.yaml..."

python3 << 'PYTHON_EOF'
import re

try:
    with open('configuration.yaml', 'r') as f:
        content = f.read()

    original_content = content

    # Eliminar input_boolean.presence_simulation_2
    # Buscar el bloque completo
    pattern1 = r'\s*presence_simulation_2:\s*\n(?:\s+[^\n]+\n)*'
    content = re.sub(pattern1, '', content)

    # Eliminar input_number.presence_simulation_loop_total
    pattern2 = r'\s*presence_simulation_loop_total:\s*\n(?:\s+[^\n]+\n)*'
    content = re.sub(pattern2, '', content)

    if content != original_content:
        with open('configuration.yaml', 'w') as f:
            f.write(content)

        print("✅ Helpers obsoletos eliminados:")
        print("  • input_boolean.presence_simulation_2")
        print("  • input_number.presence_simulation_loop_total")
    else:
        print("✅ No se encontraron helpers obsoletos")

except Exception as e:
    print(f"❌ Error: {e}")

PYTHON_EOF

EOF

echo ""

# ────────────────────────────────────────────────────────────────────────────
# 3. RECARGAR HOME ASSISTANT
# ────────────────────────────────────────────────────────────────────────────
echo "────────────────────────────────────────────────────────────────"
echo "🔄 3. RECARGANDO HOME ASSISTANT"
echo "────────────────────────────────────────────────────────────────"
echo ""

echo "Recargando configuración..."

# Usar la API para recargar
python3 << PYTHON_EOF
import os
import requests

HA_URL = os.getenv("HA_URL", "http://$HA_HOST:8123")
HA_TOKEN = os.getenv("HA_TOKEN")

headers = {
    "Authorization": f"Bearer {HA_TOKEN}",
    "Content-Type": "application/json",
}

# Recargar automatizaciones
response = requests.post(f"{HA_URL}/api/services/automation/reload", headers=headers)
if response.status_code in [200, 201]:
    print("✅ Automatizaciones recargadas")
else:
    print(f"⚠️  Error recargando automatizaciones: {response.status_code}")

# Recargar configuración
response = requests.post(f"{HA_URL}/api/services/homeassistant/reload_core_config", headers=headers)
if response.status_code in [200, 201]:
    print("✅ Configuración principal recargada")
else:
    print(f"⚠️  Error recargando configuración: {response.status_code}")

PYTHON_EOF

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "              ✅ LIMPIEZA COMPLETADA"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "📋 Backups creados:"
echo "  • automations.yaml.backup.TIMESTAMP"
echo "  • configuration.yaml.backup.TIMESTAMP"
echo ""
echo "🎯 Próximos pasos:"
echo "  1. Verifica las automatizaciones en la UI"
echo "  2. Revisa los helpers en Configuración → Helpers"
echo "  3. Prueba el sistema de simulación de presencia"
echo ""
echo "════════════════════════════════════════════════════════════════"

