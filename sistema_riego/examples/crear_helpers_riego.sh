#!/bin/bash

# ============================================
# Script para Crear Helpers de Riego en Home Assistant
# ============================================

# Configuración
HA_URL="http://homeassistant.local:8123"  # O tu IP: http://192.168.1.X:8123
HA_TOKEN="TU_TOKEN_AQUI"  # Reemplazar con tu token

echo "🔧 Creando Helpers para Sistema de Riego..."
echo ""

# ============================================
# 1. Input Boolean - Modo Manual
# ============================================
echo "📍 Creando input_boolean.riego_z1_manual..."
curl -X POST "${HA_URL}/api/config/input_boolean/config/riego_z1_manual" \
  -H "Authorization: Bearer ${HA_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Riego Z1 - Modo Manual",
    "icon": "mdi:hand-back-right",
    "initial": false
  }'
echo ""

# ============================================
# 2. Input DateTime - Último Riego
# ============================================
echo "📍 Creando input_datetime.riego_z1_ultimo..."
curl -X POST "${HA_URL}/api/config/input_datetime/config/riego_z1_ultimo" \
  -H "Authorization: Bearer ${HA_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Riego Z1 - Último Riego",
    "has_date": true,
    "has_time": true,
    "icon": "mdi:calendar-clock"
  }'
echo ""

# ============================================
# 3. Input Number - Contador
# ============================================
echo "📍 Creando input_number.riego_z1_contador..."
curl -X POST "${HA_URL}/api/config/input_number/config/riego_z1_contador" \
  -H "Authorization: Bearer ${HA_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Riego Z1 - Contador de Ciclos",
    "min": 0,
    "max": 1000,
    "step": 1,
    "mode": "box",
    "icon": "mdi:counter"
  }'
echo ""

echo "✅ Helpers creados!"
echo ""
echo "📋 Verifica en: Configuración → Dispositivos y Servicios → Helpers"


