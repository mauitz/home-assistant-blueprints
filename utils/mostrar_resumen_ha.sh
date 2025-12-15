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
echo "   Total Entidades: 399"
echo "   Automatizaciones:"
echo -e "   ${GREEN}└─ Activas (ON): 12 (100% funcionalidad necesaria) ✅${NC}"
echo -e "   ${YELLOW}└─ Obsoletas: 36 (pendientes eliminar)${NC}"
echo "   Scripts: 7 ✅"
echo "   Dominios únicos: 31"
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
echo -e "   ${GREEN}✅${NC} Atardecer Inteligente (ON)"
echo -e "   ${GREEN}✅${NC} Regreso a Casa (ON)"
echo -e "   ${RED}❌${NC} Cleanup Inteligente (ELIMINADA)"
echo ""

echo -e "${BOLD}🎥 Frigate (Detección por IA)${NC}"
echo -e "   Estado: ${YELLOW}🚫 DESINSTALADO INTENCIONALMENTE${NC}"
echo "   Hardware actual incompatible"
echo "   15 automatizaciones obsoletas"
echo -e "   ${YELLOW}→ ACCIÓN: Eliminar automatizaciones obsoletas${NC}"
echo "   ℹ️  Futuro: Se requerirán otros dispositivos para IA"
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

echo -e "${BOLD}🔧 Tareas de Mantenimiento${NC}"
echo -e "   ${YELLOW}🔧${NC}  22 automatizaciones obsoletas a eliminar"
echo -e "   ${YELLOW}  ${NC}  ├─ 15 de Frigate (desinstalado intencionalmente)"
echo -e "   ${YELLOW}  ${NC}  ├─ 5 de monitoreo presencia (integradas en v1.3)"
echo -e "   ${YELLOW}  ${NC}  └─ 2 duplicadas de escenas"
echo -e "   ${YELLOW}⚠️${NC}  ESP32 Riego Z1 Offline (20 sensores)"
echo ""

echo -e "${BOLD}📄 Documentación${NC}"
echo "   Ver: docs/homeassistant_pezaustral.md"
echo ""

echo -e "${BOLD}${GREEN}"
echo "═══════════════════════════════════════════════════════════════════════════"
echo "              Estado General: ✅ OPERATIVO (100% funcionalidad activa)"
echo "═══════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"
echo ""
echo -e "${BOLD}🔧 TAREAS DE MANTENIMIENTO (No Urgente):${NC}"
echo "  1. Eliminar 22 automatizaciones obsoletas"
echo "     → Configuración → Automatizaciones → Filtrar 'unavailable'"
echo "  2. Reconectar ESP32 Riego Z1 (cuando esté disponible)"
echo "  3. Planificar solución alternativa para detección por IA (futuro)"

echo ""
echo "Para más detalles, ejecuta:"
echo "  python3 utils/ha_manager.py status"
echo "  cat docs/homeassistant_pezaustral.md"
echo ""
