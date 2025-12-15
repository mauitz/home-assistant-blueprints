#!/bin/bash
# Script para mostrar resumen visual del estado de Home Assistant
# Ejecuta: bash utils/mostrar_resumen_ha.sh

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo -e "${BOLD}${BLUE}"
echo "═══════════════════════════════════════════════════════════════════════════"
echo "                  🏠 HOME ASSISTANT PEZAUSTRAL - RESUMEN"
echo "═══════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"

echo -e "${BOLD}📍 Información General${NC}"
echo "   URL: http://192.168.1.100:8123"
echo "   Versión: 2025.11.1"
echo "   Ubicación: Casa, Montevideo"
echo "   Zona Horaria: America/Montevideo"
echo ""

echo -e "${BOLD}📊 Estadísticas${NC}"
echo "   Total Entidades: 465"
echo "   Automatizaciones: 49"
echo "   Scripts: 7"
echo "   Dominios únicos: 33"
echo ""

echo -e "${BOLD}🔌 Integraciones Principales${NC}"
echo -e "   ${GREEN}✅${NC} Frigate (Detección por IA)"
echo -e "   ${GREEN}✅${NC} ESPHome (Control de Hardware)"
echo -e "   ${GREEN}✅${NC} Tuya (Dispositivos Inteligentes)"
echo -e "   ${GREEN}✅${NC} Sonoff (Switches y Luces)"
echo -e "   ${GREEN}✅${NC} Xiaomi Home"
echo -e "   ${GREEN}✅${NC} Tapo Control (Cámaras)"
echo -e "   ${GREEN}✅${NC} Mobile App (Tracking)"
echo ""

echo -e "${BOLD}🎭 Simulación de Presencia${NC}"
echo -e "   Estado: ${GREEN}✅ OPERATIVA${NC} (v1.3)"
echo "   Switches controlados: 6"
echo "   Máximo simultáneas: 2"
echo "   Loops configurados: 10"
echo "   Última ejecución: 2025-12-13 21:23:56"
echo ""
echo "   Automatizaciones:"
echo -e "   ${GREEN}✅${NC} Presence Simulation (ON)"
echo -e "   ${GREEN}✅${NC} Cleanup Inteligente (ON)"
echo -e "   ${GREEN}✅${NC} Atardecer Inteligente (ON)"
echo -e "   ${GREEN}✅${NC} Regreso a Casa (ON)"
echo ""

echo -e "${BOLD}🎥 Frigate (Detección por IA)${NC}"
echo -e "   Estado: ${GREEN}✅ OPERATIVO${NC}"
echo "   URL: http://192.168.1.100:5000"
echo "   Cámaras: 2 (Entrada, Exterior)"
echo "   Detección: Personas, Vehículos"
echo "   Optimización: Cooldown 2 min activo"
echo ""

echo -e "${BOLD}🌱 Sistema de Riego${NC}"
echo -e "   Estado: ${YELLOW}⚠️  HARDWARE OFFLINE${NC}"
echo "   ESP32: Desconectado (20 sensores unavailable)"
echo "   Scripts: 6 disponibles"
echo "   Automatización: ON (esperando hardware)"
echo ""

echo -e "${BOLD}📱 Notificaciones${NC}"
echo -e "   ${GREEN}✅${NC} mobile_app_blacky (iPhone Nico)"
echo "   Tipos activos:"
echo "   • Alertas de cámaras (críticas)"
echo "   • Simulación de presencia"
echo "   • Eventos solares"
echo ""

echo -e "${BOLD}🔧 Backups${NC}"
echo -e "   Estado: ${GREEN}✅ ACTIVO${NC}"
echo "   Frecuencia: Diaria"
echo "   Último backup: 2025-12-14 08:25:56"
echo "   Próximo: 2025-12-15 08:10:39"
echo ""

echo -e "${BOLD}⚠️  Problemas Conocidos${NC}"
echo -e "   ${YELLOW}⚠️${NC}  ESP32 Riego Z1 Offline"
echo -e "   ${YELLOW}⚠️${NC}  5 automatizaciones de monitoreo unavailable"
echo -e "   ${YELLOW}⚠️${NC}  Package de riego no instalado (usa blueprint)"
echo ""

echo -e "${BOLD}📄 Documentación${NC}"
echo "   Ver: docs/homeassistant_pezaustral.md"
echo ""

echo -e "${BOLD}${BLUE}"
echo "═══════════════════════════════════════════════════════════════════════════"
echo "                           Estado General: ✅ OPERATIVO"
echo "═══════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"

echo ""
echo "Para más detalles, ejecuta:"
echo "  python3 utils/ha_manager.py status"
echo "  cat docs/homeassistant_pezaustral.md"
echo ""
