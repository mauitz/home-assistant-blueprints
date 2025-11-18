#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
# DIAGNÓSTICO COMPLETO - Widget Simulación de Presencia
# ════════════════════════════════════════════════════════════════════════════

HA_URL="http://192.168.1.100:8123"
HA_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJmMWFlODEwMGY3OWQ0MzU3YTkzZTMxZWY4NTBiODBjZSIsImlhdCI6MTc2MzA2NTA4NiwiZXhwIjoyMDc4NDI1MDg2fQ.0XNUihVrECsEfT3xdBF-eb-Rbzih1r6Z-d5E0jjHk-E"

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
}

print_section() {
    echo -e "\n${CYAN}▶ $1${NC}"
}

print_success() {
    echo -e "  ${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "  ${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "  ${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "  ${BLUE}ℹ️  $1${NC}"
}

# ════════════════════════════════════════════════════════════════════════════
# FUNCIÓN: Obtener estado de entidad
# ════════════════════════════════════════════════════════════════════════════
get_entity_state() {
    local entity_id=$1
    curl -s -H "Authorization: Bearer $HA_TOKEN" \
         -H "Content-Type: application/json" \
         "${HA_URL}/api/states/${entity_id}" 2>/dev/null
}

# ════════════════════════════════════════════════════════════════════════════
# INICIO
# ════════════════════════════════════════════════════════════════════════════

print_header "DIAGNÓSTICO: Widget Simulación de Presencia"

# ════════════════════════════════════════════════════════════════════════════
# 1. VERIFICAR INPUT BOOLEANS
# ════════════════════════════════════════════════════════════════════════════

print_section "1. Input Booleans (Control)"

ENTITIES=(
    "input_boolean.presence_simulation"
    "input_boolean.presence_simulation_running"
)

for entity in "${ENTITIES[@]}"; do
    RESULT=$(get_entity_state "$entity")
    STATE=$(echo "$RESULT" | jq -r '.state' 2>/dev/null)

    if [ "$STATE" = "null" ] || [ -z "$STATE" ]; then
        print_error "$entity: NO EXISTE"
    else
        print_success "$entity: $STATE"
    fi
done

# ════════════════════════════════════════════════════════════════════════════
# 2. VERIFICAR INPUT NUMBERS
# ════════════════════════════════════════════════════════════════════════════

print_section "2. Input Numbers (Contadores)"

ENTITIES=(
    "input_number.presence_simulation_loop_counter"
    "input_number.presence_simulation_loop_total"
    "input_number.presence_simulation_lights_on_count"
)

for entity in "${ENTITIES[@]}"; do
    RESULT=$(get_entity_state "$entity")
    STATE=$(echo "$RESULT" | jq -r '.state' 2>/dev/null)

    if [ "$STATE" = "null" ] || [ -z "$STATE" ]; then
        print_error "$entity: NO EXISTE"
    else
        print_success "$entity: $STATE"
    fi
done

# ════════════════════════════════════════════════════════════════════════════
# 3. VERIFICAR INPUT TEXT
# ════════════════════════════════════════════════════════════════════════════

print_section "3. Input Text (Información)"

ENTITIES=(
    "input_text.presence_simulation_status"
    "input_text.presence_simulation_active_lights"
    "input_text.presence_simulation_last_light_on"
    "input_text.presence_simulation_last_light_off"
)

for entity in "${ENTITIES[@]}"; do
    RESULT=$(get_entity_state "$entity")
    STATE=$(echo "$RESULT" | jq -r '.state' 2>/dev/null)

    if [ "$STATE" = "null" ] || [ -z "$STATE" ]; then
        print_error "$entity: NO EXISTE"
    else
        # Truncar si es muy largo
        STATE_DISPLAY=$(echo "$STATE" | head -c 50)
        if [ ${#STATE} -gt 50 ]; then
            STATE_DISPLAY="${STATE_DISPLAY}..."
        fi
        print_success "$entity: $STATE_DISPLAY"
    fi
done

# ════════════════════════════════════════════════════════════════════════════
# 4. VERIFICAR INPUT DATETIME
# ════════════════════════════════════════════════════════════════════════════

print_section "4. Input DateTime (Tiempo de Inicio)"

ENTITY="input_datetime.presence_simulation_start_time"
RESULT=$(get_entity_state "$ENTITY")
STATE=$(echo "$RESULT" | jq -r '.state' 2>/dev/null)

if [ "$STATE" = "null" ] || [ -z "$STATE" ]; then
    print_error "$ENTITY: NO EXISTE"
else
    print_success "$ENTITY: $STATE"
fi

# ════════════════════════════════════════════════════════════════════════════
# 5. VERIFICAR SENSORES TEMPLATE (LOS CRÍTICOS)
# ════════════════════════════════════════════════════════════════════════════

print_section "5. Sensores Template (Calculados)"

ENTITIES=(
    "sensor.presence_simulation_runtime"
    "sensor.presence_simulation_progress"
    "sensor.presence_simulation_time_remaining"
    "sensor.presence_simulation_status_summary"
)

MISSING_SENSORS=()

for entity in "${ENTITIES[@]}"; do
    RESULT=$(get_entity_state "$entity")
    STATE=$(echo "$RESULT" | jq -r '.state' 2>/dev/null)

    if [ "$STATE" = "null" ] || [ -z "$STATE" ]; then
        print_error "$entity: NO EXISTE ❌"
        MISSING_SENSORS+=("$entity")
    elif [ "$STATE" = "unavailable" ]; then
        print_warning "$entity: unavailable (helper no actualizado)"
    else
        print_success "$entity: $STATE"
    fi
done

# ════════════════════════════════════════════════════════════════════════════
# 6. BUSCAR TODOS LOS HELPERS RELACIONADOS
# ════════════════════════════════════════════════════════════════════════════

print_section "6. Búsqueda Global de Helpers"

ALL_PRESENCE=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | contains("presence_simulation")) | .entity_id' 2>/dev/null | sort)

if [ -z "$ALL_PRESENCE" ]; then
    print_error "NO se encontró NINGÚN helper de presence_simulation"
else
    TOTAL=$(echo "$ALL_PRESENCE" | wc -l | tr -d ' ')
    print_info "Total de entidades encontradas: $TOTAL"
    echo ""
    echo "$ALL_PRESENCE" | while read entity; do
        RESULT=$(get_entity_state "$entity")
        STATE=$(echo "$RESULT" | jq -r '.state' 2>/dev/null)
        DOMAIN=$(echo "$entity" | cut -d'.' -f1)

        if [ "$STATE" = "unavailable" ]; then
            echo -e "    ${YELLOW}[$DOMAIN]${NC} $entity: ${YELLOW}unavailable${NC}"
        elif [ "$STATE" = "null" ] || [ -z "$STATE" ]; then
            echo -e "    ${RED}[$DOMAIN]${NC} $entity: ${RED}ERROR${NC}"
        else
            STATE_DISPLAY=$(echo "$STATE" | head -c 40)
            echo -e "    ${GREEN}[$DOMAIN]${NC} $entity: ${GREEN}$STATE_DISPLAY${NC}"
        fi
    done
fi

# ════════════════════════════════════════════════════════════════════════════
# 7. VERIFICAR AUTOMATIZACIÓN
# ════════════════════════════════════════════════════════════════════════════

print_section "7. Automatización de Simulación de Presencia"

AUTOMATIONS=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | startswith("automation.") and (.entity_id | contains("presence") or contains("simulacion"))) |
            {entity_id: .entity_id, name: .attributes.friendly_name, state: .state}' 2>/dev/null)

if [ -z "$AUTOMATIONS" ]; then
    print_warning "No se encontraron automatizaciones relacionadas"
else
    echo "$AUTOMATIONS" | jq -r '. | "  [\(.state)] \(.entity_id) - \(.name)"' | while read line; do
        if [[ "$line" =~ "[on]" ]]; then
            echo -e "${GREEN}${line}${NC}"
        else
            echo -e "${YELLOW}${line}${NC}"
        fi
    done
fi

# ════════════════════════════════════════════════════════════════════════════
# 8. RESUMEN Y DIAGNÓSTICO
# ════════════════════════════════════════════════════════════════════════════

print_header "RESUMEN Y DIAGNÓSTICO"

# Verificar control principal
CONTROL=$(get_entity_state "input_boolean.presence_simulation" | jq -r '.state' 2>/dev/null)
RUNNING=$(get_entity_state "input_boolean.presence_simulation_running" | jq -r '.state' 2>/dev/null)

echo ""
print_info "Estado Actual:"
echo ""

if [ "$CONTROL" = "on" ]; then
    echo -e "  ${GREEN}Control Principal: ON${NC} ← Usuario activó simulación"
else
    echo -e "  ${YELLOW}Control Principal: ${CONTROL}${NC}"
fi

if [ "$RUNNING" = "on" ]; then
    echo -e "  ${GREEN}Estado Ejecución: ON${NC} ← Simulación en ejecución"
else
    echo -e "  ${YELLOW}Estado Ejecución: ${RUNNING}${NC} ← NO está ejecutándose"
fi

echo ""

# ════════════════════════════════════════════════════════════════════════════
# PROBLEMAS DETECTADOS
# ════════════════════════════════════════════════════════════════════════════

print_section "PROBLEMAS DETECTADOS"
echo ""

PROBLEMS=0

# Problema 1: Sensores template faltantes
if [ ${#MISSING_SENSORS[@]} -gt 0 ]; then
    ((PROBLEMS++))
    echo -e "${RED}❌ PROBLEMA $PROBLEMS: Sensores Template Faltantes${NC}"
    echo ""
    echo "  Los siguientes sensores NO existen:"
    for sensor in "${MISSING_SENSORS[@]}"; do
        echo "    - $sensor"
    done
    echo ""
    echo "  ${CYAN}SOLUCIÓN:${NC}"
    echo "    1. Verificar que configuration.yaml contiene los sensores template"
    echo "    2. Buscar: presence_simulation_helpers.yaml"
    echo "    3. Copiar la sección 'template:' a configuration.yaml"
    echo "    4. Reiniciar Home Assistant"
    echo ""
fi

# Problema 2: Estado inconsistente
if [ "$CONTROL" = "on" ] && [ "$RUNNING" != "on" ]; then
    ((PROBLEMS++))
    echo -e "${YELLOW}⚠️  PROBLEMA $PROBLEMS: Estado Inconsistente${NC}"
    echo ""
    echo "  Control está ON pero Running está ${RUNNING}"
    echo ""
    echo "  ${CYAN}POSIBLE CAUSA:${NC}"
    echo "    - La automatización no está actualizando el helper 'running'"
    echo "    - La automatización se detuvo o nunca arrancó"
    echo ""
    echo "  ${CYAN}SOLUCIÓN:${NC}"
    echo "    1. Apagar y volver a prender el Control Principal"
    echo "    2. Verificar logs de la automatización"
    echo "    3. Revisar que el blueprint actualiza 'presence_simulation_running'"
    echo ""
fi

# Problema 3: Sensores unavailable
UNAVAIL=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | contains("presence_simulation")) | select(.state == "unavailable") | .entity_id' 2>/dev/null)

if [ ! -z "$UNAVAIL" ]; then
    UNAVAIL_COUNT=$(echo "$UNAVAIL" | wc -l | tr -d ' ')
    ((PROBLEMS++))
    echo -e "${YELLOW}⚠️  PROBLEMA $PROBLEMS: Sensores Unavailable ($UNAVAIL_COUNT)${NC}"
    echo ""
    echo "  Los siguientes sensores existen pero están 'unavailable':"
    echo "$UNAVAIL" | sed 's/^/    - /'
    echo ""
    echo "  ${CYAN}POSIBLE CAUSA:${NC}"
    echo "    - Dependen de helpers que no están inicializados"
    echo "    - Falta ejecutar la automatización al menos una vez"
    echo ""
    echo "  ${CYAN}SOLUCIÓN:${NC}"
    echo "    1. Activar manualmente la simulación"
    echo "    2. Esperar 30 segundos"
    echo "    3. Los sensores deberían actualizarse"
    echo ""
fi

# ════════════════════════════════════════════════════════════════════════════
# CONCLUSIÓN
# ════════════════════════════════════════════════════════════════════════════

echo ""
print_header "CONCLUSIÓN"
echo ""

if [ $PROBLEMS -eq 0 ]; then
    echo -e "${GREEN}✅ NO SE DETECTARON PROBLEMAS CRÍTICOS${NC}"
    echo ""
    echo "El widget debería funcionar correctamente."
else
    echo -e "${YELLOW}⚠️  SE DETECTARON $PROBLEMS PROBLEMA(S)${NC}"
    echo ""
    echo "Revisa las soluciones propuestas arriba."
fi

echo ""
print_info "Para más detalles, ver logs de Home Assistant:"
echo "    ssh nico@192.168.1.100 'docker logs --tail 100 homeassistant | grep -i presence'"
echo ""

