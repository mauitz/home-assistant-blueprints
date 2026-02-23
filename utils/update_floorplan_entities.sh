#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════
# 🔄 SCRIPT PARA ACTUALIZAR ENTIDADES DEL FLOORPLAN
# ═══════════════════════════════════════════════════════════════════════════
#
# Este script te ayuda a actualizar las entidades del floorplan de forma
# interactiva
#
# Uso: ./update_floorplan_entities.sh
#
# ═══════════════════════════════════════════════════════════════════════════

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directorios
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DASHBOARD="${PROJECT_ROOT}/dashboards/maui_dashboard.yaml"
BACKUP_DIR="${PROJECT_ROOT}/backups/dashboards"

echo -e "${BLUE}"
echo "═══════════════════════════════════════════════════════════════════════════"
echo "🔄  ACTUALIZACIÓN DE ENTIDADES DEL FLOORPLAN"
echo "═══════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"

# ───────────────────────────────────────────────────────────────────────────
# Función: Crear backup
# ───────────────────────────────────────────────────────────────────────────
create_backup() {
    echo -e "${YELLOW}📦 Creando backup del dashboard...${NC}"

    mkdir -p "$BACKUP_DIR"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="${BACKUP_DIR}/maui_dashboard_${TIMESTAMP}.yaml"

    cp "$DASHBOARD" "$BACKUP_FILE"

    echo -e "${GREEN}✅ Backup creado: ${BACKUP_FILE}${NC}\n"
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Mostrar entidades disponibles
# ───────────────────────────────────────────────────────────────────────────
show_available_entities() {
    local domain=$1
    local title=$2

    echo -e "${CYAN}${title}:${NC}"

    if [ -f "${PROJECT_ROOT}/HA_config_proxy/home-assistant_v2.db" ]; then
        # Intentar obtener entidades de la base de datos
        sqlite3 "${PROJECT_ROOT}/HA_config_proxy/home-assistant_v2.db" \
            "SELECT entity_id FROM states WHERE entity_id LIKE '${domain}.%' ORDER BY entity_id;" \
            2>/dev/null | head -20 || echo "  (No se pudo acceder a la base de datos)"
    else
        echo "  (Base de datos no encontrada)"
    fi

    echo ""
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Actualizar entidad en el dashboard
# ───────────────────────────────────────────────────────────────────────────
update_entity() {
    local area=$1
    local old_entity=$2
    local new_entity=$3

    echo -e "${YELLOW}Actualizando ${area}...${NC}"

    # Usar sed para reemplazar la entidad
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s|entity: ${old_entity}|entity: ${new_entity}|g" "$DASHBOARD"
        sed -i '' "s|entity_id: ${old_entity}|entity_id: ${new_entity}|g" "$DASHBOARD"
    else
        # Linux
        sed -i "s|entity: ${old_entity}|entity: ${new_entity}|g" "$DASHBOARD"
        sed -i "s|entity_id: ${old_entity}|entity_id: ${new_entity}|g" "$DASHBOARD"
    fi

    echo -e "${GREEN}✅ ${area} actualizado: ${old_entity} → ${new_entity}${NC}\n"
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Menú interactivo
# ───────────────────────────────────────────────────────────────────────────
interactive_menu() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}📋 ÁREAS CONFIGURADAS ACTUALMENTE:${NC}\n"

    echo -e "${YELLOW}1. LIVING/COCINA${NC}"
    echo "   Entidad actual: light.riego_z1_led_wifi"
    echo ""

    echo -e "${YELLOW}2. DECK EXTERIOR${NC}"
    echo "   Entidad actual: sensor.riego_z1_humedad_suelo_z1"
    echo ""

    echo -e "${YELLOW}3. ENTRADA${NC}"
    echo "   Entidad actual: camera.tapo_c530ws_entrada_live_view"
    echo ""

    echo -e "${YELLOW}4. PUERTA PRINCIPAL${NC}"
    echo "   Entidad actual: binary_sensor.riego_z1_presencia_detectada"
    echo ""

    echo -e "${YELLOW}5. SENSOR LIVING${NC}"
    echo "   Entidad actual: sensor.riego_z1_humedad_suelo_z1"
    echo ""

    echo -e "${YELLOW}6. SENSOR ENTRADA${NC}"
    echo "   Entidad actual: camera.tapo_c530ws_entrada_live_view"
    echo ""

    echo -e "${YELLOW}0. Salir${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}\n"

    read -p "Selecciona el área a actualizar (0-6): " choice

    case $choice in
        1)
            echo -e "\n${CYAN}Actualizando LIVING/COCINA${NC}\n"
            show_available_entities "light" "Luces disponibles"
            read -p "Nueva entidad (ej: light.sala_principal): " new_entity
            if [ ! -z "$new_entity" ]; then
                update_entity "LIVING/COCINA" "light.riego_z1_led_wifi" "$new_entity"
            fi
            ;;
        2)
            echo -e "\n${CYAN}Actualizando DECK EXTERIOR${NC}\n"
            show_available_entities "sensor" "Sensores disponibles"
            read -p "Nueva entidad (ej: sensor.deck_temperature): " new_entity
            if [ ! -z "$new_entity" ]; then
                update_entity "DECK EXTERIOR" "sensor.riego_z1_humedad_suelo_z1" "$new_entity"
            fi
            ;;
        3)
            echo -e "\n${CYAN}Actualizando ENTRADA${NC}\n"
            show_available_entities "camera" "Cámaras disponibles"
            read -p "Nueva entidad (ej: camera.entrada_principal): " new_entity
            if [ ! -z "$new_entity" ]; then
                update_entity "ENTRADA" "camera.tapo_c530ws_entrada_live_view" "$new_entity"
            fi
            ;;
        4)
            echo -e "\n${CYAN}Actualizando PUERTA PRINCIPAL${NC}\n"
            show_available_entities "binary_sensor" "Sensores binarios disponibles"
            read -p "Nueva entidad (ej: binary_sensor.puerta_entrada): " new_entity
            if [ ! -z "$new_entity" ]; then
                update_entity "PUERTA PRINCIPAL" "binary_sensor.riego_z1_presencia_detectada" "$new_entity"
            fi
            ;;
        5)
            echo -e "\n${CYAN}Actualizando SENSOR LIVING${NC}\n"
            show_available_entities "sensor" "Sensores disponibles"
            read -p "Nueva entidad (ej: sensor.living_temperature): " new_entity
            if [ ! -z "$new_entity" ]; then
                update_entity "SENSOR LIVING" "sensor.riego_z1_humedad_suelo_z1" "$new_entity"
            fi
            ;;
        6)
            echo -e "\n${CYAN}Actualizando SENSOR ENTRADA${NC}\n"
            show_available_entities "camera" "Cámaras/Sensores disponibles"
            read -p "Nueva entidad (ej: binary_sensor.entrada_motion): " new_entity
            if [ ! -z "$new_entity" ]; then
                update_entity "SENSOR ENTRADA" "camera.tapo_c530ws_entrada_live_view" "$new_entity"
            fi
            ;;
        0)
            echo -e "${GREEN}¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opción inválida${NC}\n"
            ;;
    esac

    # Preguntar si quiere continuar
    echo ""
    read -p "¿Actualizar otra área? (s/n): " continue
    if [[ $continue =~ ^[Ss]$ ]]; then
        echo ""
        interactive_menu
    fi
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Mostrar resumen
# ───────────────────────────────────────────────────────────────────────────
show_summary() {
    echo -e "\n${GREEN}"
    echo "═══════════════════════════════════════════════════════════════════════════"
    echo "✅  ACTUALIZACIÓN COMPLETADA"
    echo "═══════════════════════════════════════════════════════════════════════════"
    echo -e "${NC}"

    echo -e "${CYAN}📋 Próximos pasos:${NC}\n"
    echo "1. Reinicia Home Assistant o recarga la configuración"
    echo "2. Ve a la vista 'Plano' en tu dashboard"
    echo "3. Verifica que las entidades funcionan correctamente"
    echo ""
    echo -e "${YELLOW}💡 Tip:${NC} Si algo no funciona, restaura el backup:"
    echo "   cp ${BACKUP_DIR}/maui_dashboard_*.yaml ${DASHBOARD}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════

main() {
    # Verificar que el dashboard existe
    if [ ! -f "$DASHBOARD" ]; then
        echo -e "${RED}❌ Error: Dashboard no encontrado en ${DASHBOARD}${NC}"
        exit 1
    fi

    # Crear backup
    create_backup

    # Mostrar menú interactivo
    interactive_menu

    # Mostrar resumen
    show_summary
}

# Ejecutar
main



