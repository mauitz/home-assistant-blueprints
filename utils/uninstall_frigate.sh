u o#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
# Script de Desinstalación Segura de Frigate
# ════════════════════════════════════════════════════════════════════════════
#
# Este script realiza una desinstalación completa de Frigate con backup
# automático de todas las configuraciones.
#
# USO:
#   ./uninstall_frigate.sh
#
# REQUISITOS:
#   - Acceso SSH al servidor
#   - Permisos sudo
#
# ════════════════════════════════════════════════════════════════════════════

set -e  # Detener en caso de error

# ────────────────────────────────────────────────────────────────────────────
# CONFIGURACIÓN
# ────────────────────────────────────────────────────────────────────────────

SERVER_USER="nico"
SERVER_IP="192.168.1.100"
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="frigate_backup_${BACKUP_DATE}"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ────────────────────────────────────────────────────────────────────────────
# FUNCIONES AUXILIARES
# ────────────────────────────────────────────────────────────────────────────

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

confirm() {
    local prompt="$1"
    local response

    while true; do
        read -p "$prompt [s/n]: " response
        case $response in
            [Ss]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Por favor responde 's' o 'n'.";;
        esac
    done
}

# ────────────────────────────────────────────────────────────────────────────
# VERIFICACIONES INICIALES
# ────────────────────────────────────────────────────────────────────────────

print_header "DESINSTALACIÓN DE FRIGATE"

echo "Este script realizará:"
echo "  1. Backup completo de configuraciones"
echo "  2. Detención del contenedor de Frigate"
echo "  3. Eliminación de archivos de Frigate"
echo "  4. Limpieza de integración en Home Assistant"
echo ""
print_warning "Esta acción detendrá el sistema de detección por IA de Frigate."
echo ""

if ! confirm "¿Deseas continuar con la desinstalación?"; then
    print_info "Desinstalación cancelada."
    exit 0
fi

# Verificar conectividad SSH
print_info "Verificando conexión al servidor ${SERVER_IP}..."
if ! ssh -q ${SERVER_USER}@${SERVER_IP} exit; then
    print_error "No se pudo conectar al servidor ${SERVER_IP}"
    print_info "Verifica la IP y las credenciales SSH."
    exit 1
fi
print_success "Conexión al servidor establecida"

# ────────────────────────────────────────────────────────────────────────────
# PASO 1: BACKUP COMPLETO
# ────────────────────────────────────────────────────────────────────────────

print_header "PASO 1/5: CREANDO BACKUP"

print_info "Creando directorio de backup: ${BACKUP_DIR}"
ssh ${SERVER_USER}@${SERVER_IP} "mkdir -p ~/${BACKUP_DIR}"

# Backup de configuración de Frigate
print_info "Respaldando configuración de Frigate..."
ssh ${SERVER_USER}@${SERVER_IP} "
    if [ -d /home/nico/frigate/config ]; then
        cp -r /home/nico/frigate/config ~/${BACKUP_DIR}/frigate_config_backup
        echo 'Config respaldado'
    else
        echo 'No se encontró directorio de config'
    fi
"

# Backup de docker-compose
print_info "Respaldando docker-compose.yml..."
ssh ${SERVER_USER}@${SERVER_IP} "
    if [ -f /home/nico/frigate/docker-compose.yml ]; then
        cp /home/nico/frigate/docker-compose.yml ~/${BACKUP_DIR}/
        echo 'docker-compose.yml respaldado'
    else
        echo 'No se encontró docker-compose.yml'
    fi
"

# Backup de base de datos (opcional)
print_info "Respaldando base de datos de eventos..."
ssh ${SERVER_USER}@${SERVER_IP} "
    if [ -f /home/nico/frigate/media/frigate.db ]; then
        cp /home/nico/frigate/media/frigate.db ~/${BACKUP_DIR}/frigate_db_backup.db
        echo 'Base de datos respaldada'
    else
        echo 'No se encontró base de datos'
    fi
"

# Backup de automations.yaml
print_info "Respaldando automations.yaml de Home Assistant..."
ssh ${SERVER_USER}@${SERVER_IP} "
    if [ -f /opt/server/containers/homeassistant/config/automations.yaml ]; then
        sudo cp /opt/server/containers/homeassistant/config/automations.yaml \
                ~/${BACKUP_DIR}/automations_backup.yaml
        sudo chown ${SERVER_USER}:${SERVER_USER} ~/${BACKUP_DIR}/automations_backup.yaml
        echo 'automations.yaml respaldado'
    else
        echo 'No se encontró automations.yaml'
    fi
"

# Crear inventario de backup
print_info "Creando inventario de backup..."
ssh ${SERVER_USER}@${SERVER_IP} "cat > ~/${BACKUP_DIR}/INVENTARIO_BACKUP.txt << 'EOF'
BACKUP DE FRIGATE
=================

Fecha: ${BACKUP_DATE}

Contenido respaldado:
✅ Configuración completa de Frigate (config.yml)
✅ docker-compose.yml
✅ Base de datos de eventos (frigate.db)
✅ Automatizaciones de Home Assistant

Ubicación en el servidor:
~/${BACKUP_DIR}/

Documentación completa:
/Users/maui/_maui/domotica/home-assistant-blueprints/docs/frigate/

Para reinstalar en el futuro:
Ver: docs/frigate/INFORME_FRIGATE_ANALISIS_FINAL.md
Sección: 'Proceso de Reinstalación'

IMPORTANTE:
- Este backup contiene todas las configuraciones necesarias
- Las grabaciones NO están incluidas (demasiado grandes)
- Si necesitas clips específicos, cópialos manualmente antes de continuar
EOF
"

# Comprimir backup
print_info "Comprimiendo backup..."
ssh ${SERVER_USER}@${SERVER_IP} "
    cd ~
    tar -czf ${BACKUP_DIR}.tar.gz ${BACKUP_DIR}/
    echo 'Backup comprimido'
"

print_success "Backup completado: ~/${BACKUP_DIR}.tar.gz"

# ────────────────────────────────────────────────────────────────────────────
# PASO 2: DETENER Y ELIMINAR CONTENEDOR
# ────────────────────────────────────────────────────────────────────────────

print_header "PASO 2/5: DETENIENDO CONTENEDOR DE FRIGATE"

print_info "Verificando si el contenedor de Frigate está corriendo..."
FRIGATE_RUNNING=$(ssh ${SERVER_USER}@${SERVER_IP} "docker ps | grep frigate | wc -l" || echo "0")

if [ "$FRIGATE_RUNNING" -gt 0 ]; then
    print_info "Deteniendo contenedor de Frigate..."
    ssh ${SERVER_USER}@${SERVER_IP} "
        cd /home/nico/frigate
        docker-compose down
    "
    print_success "Contenedor detenido"
else
    print_warning "El contenedor no estaba corriendo"
fi

print_info "Eliminando contenedor y volúmenes..."
ssh ${SERVER_USER}@${SERVER_IP} "
    if [ -d /home/nico/frigate ]; then
        cd /home/nico/frigate
        docker-compose down -v 2>/dev/null || echo 'Ya estaba eliminado'
    fi
"
print_success "Contenedor eliminado"

# Eliminar imágenes Docker (opcional)
if confirm "¿Deseas eliminar también las imágenes Docker de Frigate? (Libera ~2GB)"; then
    print_info "Eliminando imágenes de Frigate..."
    ssh ${SERVER_USER}@${SERVER_IP} "
        docker images | grep frigate | awk '{print \$3}' | xargs docker rmi -f 2>/dev/null || echo 'Imágenes eliminadas'
    "
    print_success "Imágenes Docker eliminadas"
else
    print_info "Imágenes Docker conservadas"
fi

# ────────────────────────────────────────────────────────────────────────────
# PASO 3: ELIMINAR ARCHIVOS DE FRIGATE
# ────────────────────────────────────────────────────────────────────────────

print_header "PASO 3/5: ELIMINANDO ARCHIVOS DE FRIGATE"

# Verificar tamaño antes de eliminar
print_info "Calculando espacio ocupado por Frigate..."
FRIGATE_SIZE=$(ssh ${SERVER_USER}@${SERVER_IP} "du -sh /home/nico/frigate/ 2>/dev/null | cut -f1" || echo "0")
print_info "Tamaño total: ${FRIGATE_SIZE}"

if confirm "¿Confirmas la eliminación del directorio /home/nico/frigate/?"; then
    print_info "Eliminando directorio de Frigate..."
    ssh ${SERVER_USER}@${SERVER_IP} "
        sudo rm -rf /home/nico/frigate/
    "
    print_success "Directorio eliminado - Espacio liberado: ${FRIGATE_SIZE}"
else
    print_warning "Directorio de Frigate conservado"
fi

# ────────────────────────────────────────────────────────────────────────────
# PASO 4: LIMPIAR INTEGRACIÓN EN HOME ASSISTANT
# ────────────────────────────────────────────────────────────────────────────

print_header "PASO 4/5: LIMPIANDO HOME ASSISTANT"

print_warning "La integración de Frigate debe eliminarse manualmente desde la UI de Home Assistant:"
echo ""
echo "  1. Ir a: Configuración → Dispositivos y servicios"
echo "  2. Buscar: 'Frigate'"
echo "  3. Click en los 3 puntos → 'Eliminar'"
echo "  4. Confirmar eliminación"
echo ""

if confirm "¿Ya eliminaste la integración de Frigate en Home Assistant?"; then
    print_success "Integración marcada como eliminada"
else
    print_warning "Recuerda eliminar la integración manualmente más tarde"
fi

# Limpiar automatizaciones V3.3
if confirm "¿Deseas eliminar las automatizaciones V3.3 de Frigate?"; then
    print_info "Las automatizaciones deben eliminarse manualmente de automations.yaml"
    print_warning "Buscar y eliminar estas automatizaciones:"
    echo "  - 🚨 Frigate - Entrada - PERSONA (id: 1763080000001)"
    echo "  - 🚗 Frigate - Entrada - VEHÍCULO (id: 1763080000002)"
    echo "  - 🚨 Frigate - Exterior - PERSONA (id: 1763080000003)"
    echo "  - 🚗 Frigate - Exterior - VEHÍCULO (id: 1763080000004)"
    echo "  - 🐕 Frigate - Entrada - ANIMAL (id: 1763080000005)"
    echo ""
    print_info "Archivo: /opt/server/containers/homeassistant/config/automations.yaml"

    if confirm "¿Deseas editarlo ahora via SSH?"; then
        ssh -t ${SERVER_USER}@${SERVER_IP} "sudo nano /opt/server/containers/homeassistant/config/automations.yaml"
    fi
fi

# ────────────────────────────────────────────────────────────────────────────
# PASO 5: REINICIAR HOME ASSISTANT
# ────────────────────────────────────────────────────────────────────────────

print_header "PASO 5/5: REINICIANDO HOME ASSISTANT"

if confirm "¿Deseas reiniciar Home Assistant ahora?"; then
    print_info "Reiniciando Home Assistant..."
    ssh ${SERVER_USER}@${SERVER_IP} "docker restart homeassistant"

    print_info "Esperando 30 segundos a que Home Assistant inicie..."
    sleep 30

    print_success "Home Assistant reiniciado"

    print_info "Verificando logs de Home Assistant..."
    ssh ${SERVER_USER}@${SERVER_IP} "docker logs homeassistant --tail 20"
else
    print_warning "Recuerda reiniciar Home Assistant manualmente más tarde"
fi

# ────────────────────────────────────────────────────────────────────────────
# VERIFICACIÓN FINAL
# ────────────────────────────────────────────────────────────────────────────

print_header "VERIFICACIÓN FINAL"

print_info "Verificando que Frigate fue eliminado correctamente..."

# Verificar contenedores
FRIGATE_CONTAINERS=$(ssh ${SERVER_USER}@${SERVER_IP} "docker ps -a | grep frigate | wc -l" || echo "0")
if [ "$FRIGATE_CONTAINERS" -eq 0 ]; then
    print_success "No hay contenedores de Frigate"
else
    print_warning "Aún hay contenedores de Frigate (${FRIGATE_CONTAINERS})"
fi

# Verificar directorio
FRIGATE_DIR=$(ssh ${SERVER_USER}@${SERVER_IP} "[ -d /home/nico/frigate ] && echo 'exists' || echo 'deleted'")
if [ "$FRIGATE_DIR" = "deleted" ]; then
    print_success "Directorio de Frigate eliminado"
else
    print_warning "Directorio de Frigate aún existe"
fi

# ────────────────────────────────────────────────────────────────────────────
# RESUMEN FINAL
# ────────────────────────────────────────────────────────────────────────────

print_header "DESINSTALACIÓN COMPLETADA"

echo "✅ Backup guardado en el servidor:"
echo "   ~/${BACKUP_DIR}.tar.gz"
echo ""
echo "📁 Documentación completa en el repositorio:"
echo "   docs/frigate/INFORME_FRIGATE_ANALISIS_FINAL.md"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Verificar que cámaras Tapo funcionan correctamente"
echo "   2. Verificar detección de movimiento básica"
echo "   3. Verificar notificaciones"
echo "   4. Revisar dashboard"
echo ""
echo "🔄 Para reinstalar en el futuro:"
echo "   - Con servidor dedicado o Coral TPU"
echo "   - Ver: docs/frigate/INFORME_FRIGATE_ANALISIS_FINAL.md"
echo "   - Sección: 'Proceso de Reinstalación'"
echo ""

print_success "Desinstalación completada con éxito"

# ────────────────────────────────────────────────────────────────────────────
# OPCIONAL: COPIAR BACKUP A LOCAL
# ────────────────────────────────────────────────────────────────────────────

echo ""
if confirm "¿Deseas copiar el backup a tu máquina local?"; then
    LOCAL_BACKUP_DIR="$HOME/frigate_backups"
    mkdir -p "$LOCAL_BACKUP_DIR"

    print_info "Copiando backup a ${LOCAL_BACKUP_DIR}..."
    scp ${SERVER_USER}@${SERVER_IP}:~/${BACKUP_DIR}.tar.gz "$LOCAL_BACKUP_DIR/"

    print_success "Backup copiado a: ${LOCAL_BACKUP_DIR}/${BACKUP_DIR}.tar.gz"
fi

echo ""
print_header "¡LISTO!"



