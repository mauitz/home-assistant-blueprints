#!/bin/bash

# Script para verificar Smart Node remotamente (sin cable USB)
# Fecha: 2 enero 2026

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DEVICE_IP="192.168.1.13"
DEVICE_NAME="smartnode1"
ESPHOME_PORT="6053"

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Verificación Remota - Smart Node V2                 ║${NC}"
echo -e "${BLUE}║   (Funcionando con batería)                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Función para checks
print_check() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
        return 0
    else
        echo -e "${RED}✗${NC} $2"
        return 1
    fi
}

print_section() {
    echo -e "\n${BLUE}▶ $1${NC}"
    echo "────────────────────────────────────────────────────────"
}

# 1. Verificar conectividad básica
print_section "1. Conectividad de Red"

echo -n "Verificando si el ESP32 responde (ping)... "
if ping -c 3 -t 5 $DEVICE_IP &> /dev/null; then
    print_check 0 "ESP32 responde en $DEVICE_IP"
    PING_OK=1
else
    print_check 1 "ESP32 NO responde en $DEVICE_IP"
    PING_OK=0
fi

# 2. Verificar puerto ESPHome
print_section "2. Servicio ESPHome"

echo -n "Verificando puerto $ESPHOME_PORT... "
if nc -z -w 2 $DEVICE_IP $ESPHOME_PORT 2>/dev/null; then
    print_check 0 "Puerto ESPHome ($ESPHOME_PORT) abierto"
    PORT_OK=1
else
    print_check 1 "Puerto ESPHome ($ESPHOME_PORT) cerrado"
    PORT_OK=0
fi

# 3. Verificar mDNS
print_section "3. Resolución mDNS"

echo -n "Resolviendo $DEVICE_NAME.local... "
MDNS_IP=$(dns-sd -G v4 "$DEVICE_NAME.local" 2>/dev/null | grep -m 1 ":" | awk '{print $7}' &)
MDNS_PID=$!
sleep 2
kill $MDNS_PID 2>/dev/null

if [ ! -z "$MDNS_IP" ]; then
    print_check 0 "mDNS resuelve a: $MDNS_IP"
else
    echo -e "${YELLOW}⚠${NC} mDNS no resuelve (normal en algunas redes)"
fi

# 4. Estado del dispositivo
print_section "4. Estado del Dispositivo"

if [ $PING_OK -eq 1 ] && [ $PORT_OK -eq 1 ]; then
    echo -e "${GREEN}✓ Dispositivo ONLINE y funcional${NC}"
    echo ""
    echo -e "  ${GREEN}→${NC} IP: $DEVICE_IP"
    echo -e "  ${GREEN}→${NC} Puerto ESPHome: $ESPHOME_PORT"
    echo -e "  ${GREEN}→${NC} Estado: Funcionando con batería"

    # Calcular tiempo de respuesta
    PING_TIME=$(ping -c 1 $DEVICE_IP 2>/dev/null | grep "time=" | awk -F"time=" '{print $2}' | awk '{print $1}')
    if [ ! -z "$PING_TIME" ]; then
        echo -e "  ${GREEN}→${NC} Latencia: ${PING_TIME}ms"
    fi

elif [ $PING_OK -eq 1 ] && [ $PORT_OK -eq 0 ]; then
    echo -e "${YELLOW}⚠ Dispositivo responde pero ESPHome no está activo${NC}"
    echo ""
    echo "Posibles causas:"
    echo "  • ESP32 se está iniciando (espera 30 segundos)"
    echo "  • Error en el código ESPHome"
    echo "  • ESP32 en bootloop"

else
    echo -e "${RED}✗ Dispositivo OFFLINE${NC}"
    echo ""
    echo "Posibles causas:"
    echo "  • Batería descargada"
    echo "  • Desconectado del WiFi"
    echo "  • ESP32 apagado"
    echo "  • Fuera del alcance del router"
fi

# 5. Información de batería
print_section "5. Estimación de Batería"

echo -e "Batería: ${YELLOW}18650 Li-Ion 2600mAh${NC}"
echo "Autonomía estimada: 13-17 horas (uso normal)"
echo ""
echo -e "${YELLOW}Recomendación:${NC} Monitorea el voltaje de batería con un tester"
echo "  • >3.7V = Buena carga"
echo "  • 3.4-3.7V = Media carga"
echo "  • <3.4V = Batería baja (recargar pronto)"

# 6. Próximos pasos
print_section "6. Acciones Disponibles"

if [ $PING_OK -eq 1 ] && [ $PORT_OK -eq 1 ]; then
    echo -e "${GREEN}Puedes ver logs remotamente:${NC}"
    echo ""
    echo "  Opción 1 (por IP):"
    echo -e "  ${BLUE}cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome${NC}"
    echo -e "  ${BLUE}python3 -m esphome logs smartnode1.yaml --device $DEVICE_IP${NC}"
    echo ""
    echo "  Opción 2 (por mDNS):"
    echo -e "  ${BLUE}python3 -m esphome logs smartnode1.yaml${NC}"
    echo ""
    echo -e "${GREEN}Ver en Home Assistant:${NC}"
    echo "  • Ir a: Configuración → Dispositivos y Servicios → ESPHome"
    echo "  • Buscar: Smart Node 1"
    echo ""

    # Ofrecer conectar ahora
    echo -e "${YELLOW}¿Quieres ver los logs ahora? (s/N)${NC}"
    read -t 10 -r RESPONSE || RESPONSE="n"

    if [[ $RESPONSE =~ ^[Ss]$ ]]; then
        echo ""
        echo -e "${GREEN}Conectando a logs remotos (Ctrl+C para salir)...${NC}"
        echo ""
        cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome
        python3 -m esphome logs smartnode1.yaml --device $DEVICE_IP
    fi

else
    echo -e "${RED}No se puede conectar remotamente en este momento.${NC}"
    echo ""
    echo "Acciones sugeridas:"
    echo "  1. Verifica que el ESP32 está encendido"
    echo "  2. Mide voltaje de batería (debe ser >3.0V)"
    echo "  3. Acerca más el dispositivo al router"
    echo "  4. Conecta por USB para ver logs físicos"
    echo ""
    echo "  Comando para logs por USB:"
    echo -e "  ${BLUE}cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome${NC}"
    echo -e "  ${BLUE}python3 -m esphome logs smartnode1.yaml --device /dev/cu.usbserial-0001${NC}"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Verificación completada${NC}"
echo ""



