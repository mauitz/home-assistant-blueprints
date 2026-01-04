#!/bin/bash

# Script de Diagnóstico Automático para Smart Node
# Fecha: 2 enero 2026
# Propósito: Verificar conectividad y estado del dispositivo

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
ESPHOME_DIR="/Users/maui/_maui/domotica/home-assistant-blueprints/esphome"
DEVICE_YAML="smartnode1.yaml"
USB_PORT="/dev/cu.usbserial-0001"

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Diagnóstico Automático - Smart Node V2              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Función para imprimir secciones
print_section() {
    echo -e "\n${BLUE}▶ $1${NC}"
    echo "────────────────────────────────────────────────────────"
}

# Función para check
print_check() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

# 1. Verificar que ESPHome está instalado
print_section "1. Verificando Entorno"

if command -v python3 &> /dev/null; then
    print_check 0 "Python3 instalado: $(python3 --version)"
else
    print_check 1 "Python3 NO encontrado"
    exit 1
fi

if python3 -m esphome version &> /dev/null; then
    VERSION=$(python3 -m esphome version 2>&1 | head -n1)
    print_check 0 "ESPHome instalado: $VERSION"
else
    print_check 1 "ESPHome NO encontrado"
    echo -e "${YELLOW}   Instalando ESPHome...${NC}"
    pip3 install esphome
fi

# 2. Verificar archivos de configuración
print_section "2. Verificando Archivos de Configuración"

if [ -f "$ESPHOME_DIR/$DEVICE_YAML" ]; then
    print_check 0 "Archivo de configuración: $DEVICE_YAML"
else
    print_check 1 "NO encontrado: $DEVICE_YAML"
    exit 1
fi

if [ -f "$ESPHOME_DIR/secrets.yaml" ]; then
    print_check 0 "Archivo secrets.yaml encontrado"

    # Leer credenciales
    WIFI_SSID=$(grep "wifi_ssid:" "$ESPHOME_DIR/secrets.yaml" | cut -d'"' -f2)

    if [ ! -z "$WIFI_SSID" ]; then
        echo -e "   ${GREEN}SSID configurado:${NC} $WIFI_SSID"

        # Advertir si no es 2.4GHz
        if [[ $WIFI_SSID == *"5G"* ]] || [[ $WIFI_SSID == *"5g"* ]]; then
            echo -e "   ${RED}⚠ ADVERTENCIA:${NC} El SSID parece ser 5GHz"
            echo -e "   ${YELLOW}   ESP32 solo soporta 2.4GHz${NC}"
        fi
    else
        echo -e "   ${RED}⚠${NC} No se pudo leer wifi_ssid de secrets.yaml"
    fi
else
    print_check 1 "NO encontrado: secrets.yaml"
    exit 1
fi

# 3. Verificar dispositivo USB
print_section "3. Verificando Dispositivo USB"

if [ -e "$USB_PORT" ]; then
    print_check 0 "Dispositivo USB conectado: $USB_PORT"
else
    print_check 1 "Dispositivo NO encontrado en $USB_PORT"
    echo -e "${YELLOW}   Dispositivos USB disponibles:${NC}"
    ls -1 /dev/cu.* 2>/dev/null | head -5
    echo ""
    echo -e "${YELLOW}   ¿Está conectado el cable USB?${NC}"
    exit 1
fi

# 4. Validar configuración YAML
print_section "4. Validando Configuración YAML"

cd "$ESPHOME_DIR"
if python3 -m esphome config "$DEVICE_YAML" &> /tmp/esphome_config.log; then
    print_check 0 "Configuración YAML válida"
else
    print_check 1 "Configuración YAML tiene errores"
    echo -e "${YELLOW}   Ver detalles en: /tmp/esphome_config.log${NC}"
    tail -10 /tmp/esphome_config.log
    exit 1
fi

# 5. Probar conexión con el dispositivo
print_section "5. Conectando con ESP32"

echo -e "${YELLOW}Leyendo logs del dispositivo (presiona Ctrl+C después de 10 segundos)...${NC}"
echo -e "${YELLOW}Busca estos mensajes clave:${NC}"
echo -e "  - ${GREEN}WiFi Connected!${NC}"
echo -e "  - ${GREEN}IP Address: 192.168.x.x${NC}"
echo -e "  - ${RED}WiFi authentication failed${NC} (si hay error)"
echo ""
echo -e "${BLUE}Presiona el botón RESET del ESP32 AHORA para ver logs desde el inicio${NC}"
echo ""

# Ejecutar logs por 15 segundos
timeout 15s python3 -m esphome logs "$DEVICE_YAML" --device "$USB_PORT" 2>&1 | \
    grep -E "WiFi|wifi|Connected|connection|IP Address|authentication|setup\(\)|ESPHome version" || true

echo ""
echo -e "${BLUE}══════════════════════════════════════════════════════${NC}"

# 6. Resumen y próximos pasos
print_section "6. Próximos Pasos"

echo -e "${YELLOW}Analiza los logs anteriores:${NC}"
echo ""
echo -e "${GREEN}Si viste 'WiFi Connected!' y una IP:${NC}"
echo -e "  1. Anota la IP del dispositivo"
echo -e "  2. Ve a Home Assistant → Configuración → Dispositivos"
echo -e "  3. Agrega integración ESPHome con esa IP"
echo -e "  4. Usa clave de encriptación del YAML"
echo ""
echo -e "${RED}Si NO se conectó al WiFi:${NC}"
echo -e "  1. Verifica que el SSID en secrets.yaml es correcto"
echo -e "  2. Asegúrate que es red 2.4GHz (NO 5GHz)"
echo -e "  3. Acerca el ESP32 al router"
echo -e "  4. Busca red WiFi 'Test1 Fallback Hotspot' desde tu teléfono"
echo ""
echo -e "${YELLOW}Si necesitas ver más logs:${NC}"
echo -e "  cd $ESPHOME_DIR"
echo -e "  python3 -m esphome logs $DEVICE_YAML --device $USB_PORT"
echo ""

# Ofrecer ver logs continuos
echo -e "${BLUE}¿Quieres ver logs continuos? (S/n)${NC}"
read -t 10 -r RESPONSE || RESPONSE="n"

if [[ $RESPONSE =~ ^[Ss]$ ]]; then
    echo -e "${GREEN}Mostrando logs en tiempo real (Ctrl+C para salir)...${NC}"
    python3 -m esphome logs "$DEVICE_YAML" --device "$USB_PORT"
else
    echo -e "${YELLOW}Para ver logs después, ejecuta:${NC}"
    echo -e "  cd $ESPHOME_DIR && python3 -m esphome logs $DEVICE_YAML --device $USB_PORT"
fi

echo ""
echo -e "${BLUE}Diagnóstico completado${NC}"


