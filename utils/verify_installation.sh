#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
# VERIFICACIÓN DE INSTALACIÓN - Optimización Frigate
# ════════════════════════════════════════════════════════════════════════════

HA_URL="http://192.168.1.100:8123"
HA_TOKEN="${HA_TOKEN}"

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "════════════════════════════════════════════════════════════════"
    echo "$1"
    echo "════════════════════════════════════════════════════════════════"
    echo -e "${NC}"
}

print_section() {
    echo -e "${CYAN}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Verificar token
if [ -z "$HA_TOKEN" ]; then
    print_error "Token no configurado"
    echo ""
    echo "Configura primero tu token:"
    echo "  1. Ir a: http://192.168.1.100:8123/profile"
    echo "  2. Crear 'Long-Lived Access Token'"
    echo "  3. Ejecutar: export HA_TOKEN='tu_token_aqui'"
    echo ""
    exit 1
fi

print_header "VERIFICACIÓN DE INSTALACIÓN - FRIGATE OPTIMIZACIÓN"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# 1. VERIFICAR AUTOMATIZACIONES
# ════════════════════════════════════════════════════════════════════════════

print_section "1. Verificando Automatizaciones Instaladas"
echo ""

AUTOMATIONS=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     -H "Content-Type: application/json" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | startswith("automation.frigate")) |
            {entity_id: .entity_id, name: .attributes.friendly_name, state: .state}' 2>/dev/null)

if [ -z "$AUTOMATIONS" ]; then
    print_warning "No se encontraron automatizaciones de Frigate"
    echo "Puede que Home Assistant aún esté cargando..."
else
    echo "$AUTOMATIONS" | jq -r '. | "  [\(.state)] \(.entity_id)\n      \(.name)"' | while read line; do
        if [[ "$line" =~ "on" ]]; then
            echo -e "${GREEN}${line}${NC}"
        elif [[ "$line" =~ "off" ]]; then
            echo -e "${YELLOW}${line}${NC}"
        else
            echo "  $line"
        fi
    done
fi

echo ""

# Contar automatizaciones de optimización
AUTO_COUNT=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '[.[] | select(.entity_id | contains("frigate") and contains("motion"))] | length' 2>/dev/null)

if [ "$AUTO_COUNT" -ge "6" ]; then
    print_success "Todas las automatizaciones instaladas ($AUTO_COUNT)"
else
    print_warning "Solo se encontraron $AUTO_COUNT automatizaciones (esperadas: 6)"
fi

echo ""

# ════════════════════════════════════════════════════════════════════════════
# 2. VERIFICAR SENSORES DE MOVIMIENTO TAPO
# ════════════════════════════════════════════════════════════════════════════

print_section "2. Verificando Sensores de Movimiento Tapo"
echo ""

MOTION_SENSORS=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | contains("tapo") and contains("motion")) |
            {entity_id: .entity_id, state: .state, last_changed: .last_changed}' 2>/dev/null)

if [ -z "$MOTION_SENSORS" ]; then
    print_error "NO se encontraron sensores de movimiento Tapo"
    echo "  → Necesitas instalar integración 'Tapo: Cameras Control'"
    echo "  → Ver: docs/CAMARAS_TAPO_INTEGRACION_CORRECTA.md"
else
    echo "$MOTION_SENSORS" | jq -r '. | "  \(.entity_id): \(.state) (actualizado: \(.last_changed))"'
    print_success "Sensores de movimiento encontrados"
fi

echo ""

# ════════════════════════════════════════════════════════════════════════════
# 3. VERIFICAR SWITCHES DE FRIGATE
# ════════════════════════════════════════════════════════════════════════════

print_section "3. Verificando Switches de Detección de Frigate"
echo ""

FRIGATE_SWITCHES=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | contains("frigate") and contains("detect")) |
            {entity_id: .entity_id, state: .state}' 2>/dev/null)

if [ -z "$FRIGATE_SWITCHES" ]; then
    print_warning "NO se encontraron switches de Frigate"
    echo "  → Verifica que Frigate está corriendo"
    echo "  → Verifica que la integración Frigate está instalada en HA"
else
    echo "$FRIGATE_SWITCHES" | jq -r '. | "  \(.entity_id): \(.state)"' | while read line; do
        if [[ "$line" =~ ": on" ]]; then
            echo -e "${GREEN}${line}${NC}"
        else
            echo -e "${YELLOW}${line}${NC}"
        fi
    done
    print_success "Switches de Frigate encontrados"
fi

echo ""

# ════════════════════════════════════════════════════════════════════════════
# 4. VERIFICAR HELPERS/SENSORES DE OPTIMIZACIÓN
# ════════════════════════════════════════════════════════════════════════════

print_section "4. Verificando Helpers y Sensores de Optimización"
echo ""

# Input booleans
INPUT_BOOLEANS=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | contains("frigate_optimization")) |
            {entity_id: .entity_id, state: .state}' 2>/dev/null)

if [ ! -z "$INPUT_BOOLEANS" ]; then
    echo "Input Booleans:"
    echo "$INPUT_BOOLEANS" | jq -r '. | "  \(.entity_id): \(.state)"'
    print_success "Input booleans configurados"
else
    print_warning "Input booleans no encontrados (pueden tardar en cargar)"
fi

echo ""

# Contadores
COUNTERS=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | startswith("counter.frigate")) |
            {entity_id: .entity_id, state: .state}' 2>/dev/null)

if [ ! -z "$COUNTERS" ]; then
    echo "Contadores:"
    echo "$COUNTERS" | jq -r '. | "  \(.entity_id): \(.state) activaciones"'
    print_success "Contadores configurados"
else
    print_warning "Contadores no encontrados (pueden tardar en cargar)"
fi

echo ""

# Sensor de CPU ahorrado
CPU_SENSOR=$(curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states/sensor.frigate_cpu_ahorrado" 2>/dev/null | \
     jq -r '.state' 2>/dev/null)

if [ ! -z "$CPU_SENSOR" ] && [ "$CPU_SENSOR" != "null" ]; then
    echo "Sensor de CPU:"
    echo -e "  sensor.frigate_cpu_ahorrado: ${GREEN}${CPU_SENSOR}%${NC}"
    print_success "Sensor de CPU ahorrado activo"
else
    print_warning "Sensor de CPU no encontrado (puede tardar en cargar)"
fi

echo ""

# ════════════════════════════════════════════════════════════════════════════
# 5. VERIFICAR ESTADO ACTUAL DEL SISTEMA
# ════════════════════════════════════════════════════════════════════════════

print_section "5. Estado Actual del Sistema"
echo ""

# Estado de cámaras con movimiento
echo "Estado de Movimiento:"
curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | contains("tapo") and contains("motion")) |
            .entity_id + ": " + .state' 2>/dev/null | sed 's/^/  /' | while read line; do
    if [[ "$line" =~ "on" ]]; then
        echo -e "${GREEN}${line}${NC} ← HAY MOVIMIENTO"
    else
        echo -e "${YELLOW}${line}${NC}"
    fi
done

echo ""

# Estado de detección Frigate
echo "Estado de Detección Frigate:"
curl -s -H "Authorization: Bearer $HA_TOKEN" \
     "${HA_URL}/api/states" | \
     jq -r '.[] | select(.entity_id | contains("frigate") and contains("detect")) |
            .entity_id + ": " + .state' 2>/dev/null | sed 's/^/  /' | while read line; do
    if [[ "$line" =~ "on" ]]; then
        echo -e "${GREEN}${line}${NC} ← PROCESANDO IA"
    else
        echo -e "${YELLOW}${line}${NC} ← INACTIVO (ahorrando CPU)"
    fi
done

echo ""

# ════════════════════════════════════════════════════════════════════════════
# RESUMEN
# ════════════════════════════════════════════════════════════════════════════

print_header "RESUMEN DE VERIFICACIÓN"
echo ""

CHECKS_PASSED=0
CHECKS_TOTAL=5

# Check 1: Automatizaciones
if [ "$AUTO_COUNT" -ge "6" ]; then
    print_success "Automatizaciones instaladas"
    ((CHECKS_PASSED++))
else
    print_error "Automatizaciones incompletas"
fi

# Check 2: Sensores de movimiento
if [ ! -z "$MOTION_SENSORS" ]; then
    print_success "Sensores de movimiento OK"
    ((CHECKS_PASSED++))
else
    print_error "Sensores de movimiento NO encontrados"
fi

# Check 3: Switches Frigate
if [ ! -z "$FRIGATE_SWITCHES" ]; then
    print_success "Switches de Frigate OK"
    ((CHECKS_PASSED++))
else
    print_warning "Switches de Frigate NO encontrados"
fi

# Check 4: Helpers
if [ ! -z "$INPUT_BOOLEANS" ]; then
    print_success "Helpers configurados"
    ((CHECKS_PASSED++))
else
    print_warning "Helpers no cargados aún"
fi

# Check 5: Sensor CPU
if [ ! -z "$CPU_SENSOR" ] && [ "$CPU_SENSOR" != "null" ]; then
    print_success "Sensor de CPU activo"
    ((CHECKS_PASSED++))
else
    print_warning "Sensor de CPU no cargado aún"
fi

echo ""
echo "════════════════════════════════════════════════════════════════"

if [ "$CHECKS_PASSED" -eq "$CHECKS_TOTAL" ]; then
    echo -e "${GREEN}✅ TODO INSTALADO CORRECTAMENTE${NC}"
elif [ "$CHECKS_PASSED" -ge "3" ]; then
    echo -e "${YELLOW}⚠️  INSTALACIÓN PARCIAL (${CHECKS_PASSED}/${CHECKS_TOTAL})${NC}"
    echo ""
    echo "Algunos componentes pueden tardar en cargar."
    echo "Espera 2-3 minutos y vuelve a ejecutar este script."
else
    echo -e "${RED}❌ INSTALACIÓN INCOMPLETA (${CHECKS_PASSED}/${CHECKS_TOTAL})${NC}"
    echo ""
    echo "Revisa los logs:"
    echo "  ssh nico@192.168.1.100"
    echo "  docker logs --tail 100 homeassistant"
fi

echo "════════════════════════════════════════════════════════════════"
echo ""


