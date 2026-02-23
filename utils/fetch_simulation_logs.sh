#!/bin/bash
# Script para obtener logs recientes y configuración de la simulación de presencia
# Uso: ./fetch_simulation_logs.sh

# Cargar configuración si existe, sino usar defaults (ajustar según entorno del usuario)
HA_URL="${HA_URL:-http://homeassistant.local:8123}"
# Intentar leer token de .env si existe
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Si no hay token en env, usar el del script anterior como fallback (solo para este contexto)
if [ -z "$HA_TOKEN" ]; then
    HA_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJmMWFlODEwMGY3OWQ0MzU3YTkzZTMxZWY4NTBiODBjZSIsImlhdCI6MTc2MzA2NTA4NiwiZXhwIjoyMDc4NDI1MDg2fQ.0XNUihVrECsEfT3xdBF-eb-Rbzih1r6Z-d5E0jjHk-E"
fi

echo "🔍 Analizando Simulación de Presencia..."
echo "URL: $HA_URL"

# 1. Obtener configuración de la automatización
echo -e "\n📊 Configuración de la Automatización (automation.presence_simulation):"
curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "$HA_URL/api/states/automation.presence_simulation" | jq '.'

# 2. Obtener logs recientes (últimos 20 eventos del logbook para esta automatización y scripts relacionados)
echo -e "\n📜 Últimos eventos en Logbook (Presence Simulation):"
# Calculamos timestamp de hace 1 hora
START_TIME=$(date -v-1H +%Y-%m-%dT%H:%M:%S%z 2>/dev/null || date -d "1 hour ago" +%Y-%m-%dT%H:%M:%S%z)

curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "$HA_URL/api/logbook/$START_TIME?entity=automation.presence_simulation,input_boolean.presence_simulation" | jq 'reverse | .[:20]'

# 3. Buscar entradas de logbook generadas por el blueprint (que usan el servicio logbook.log)
echo -e "\n💡 Logs internos del Blueprint:"
curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "$HA_URL/api/logbook/$START_TIME" | jq '[.[] | select(.name | contains("Presence Simulation"))] | reverse | .[:20]'
