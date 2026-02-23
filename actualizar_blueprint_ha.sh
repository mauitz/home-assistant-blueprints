#!/bin/bash

echo "🚀 ACTUALIZANDO BLUEPRINT EN HOME ASSISTANT"
echo "==========================================="
echo ""

SOURCE="/Users/maui/_maui/domotica/home-assistant-blueprints/blueprints/pezaustral_presence_simulation.yaml"
DEST="/Users/maui/_maui/domotica/home-assistant-blueprints/HA_config_proxy/blueprints/automation/mauitz/pezaustral_presence_simulation.yaml"

# Verificar que el source existe
if [ ! -f "$SOURCE" ]; then
    echo "❌ ERROR: No se encuentra el blueprint source"
    exit 1
fi

# Crear directorio si no existe
mkdir -p "$(dirname "$DEST")"

# Copiar
echo "📄 Copiando blueprint actualizado..."
cp "$SOURCE" "$DEST"

if [ $? -eq 0 ]; then
    echo "✅ Blueprint copiado exitosamente"
    echo ""
    echo "📋 Cambios incluidos:"
    echo "   ✅ Shuffle aleatorio de luces (NUEVO)"
    echo "   ✅ Cleanup mejorado (apaga TODAS las luces)"
    echo "   ✅ Sistema de PAUSE/RESUME"
    echo "   ✅ Sistema de notificaciones"
    echo ""
    echo "🔄 PRÓXIMOS PASOS:"
    echo "   1. Ve a Home Assistant"
    echo "   2. Configuración → Automatizaciones"
    echo "   3. Menú (⋮) → Recargar automatizaciones"
    echo "   4. Prueba iniciar la simulación"
    echo "   5. Verifica que empiece con switches diferentes cada vez"
    echo ""

    # Verificar que el shuffle está presente
    if grep -q "shuffled_lights" "$DEST"; then
        echo "✅ VERIFICADO: Shuffle presente en el blueprint"
    else
        echo "⚠️  ADVERTENCIA: Shuffle NO encontrado (revisar)"
    fi
else
    echo "❌ ERROR al copiar el blueprint"
    exit 1
fi

