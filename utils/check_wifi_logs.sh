#!/bin/bash

# Script para verificar conexión WiFi del Smart Node
# Se ejecuta por 15 segundos y luego termina

cd /Users/maui/_maui/domotica/home-assistant-blueprints/esphome

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Verificando Conexión WiFi del ESP32"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Presiona el botón RESET del ESP32 AHORA para ver logs desde el inicio"
echo ""
echo "Buscando mensajes de WiFi (esperando 15 segundos)..."
echo ""

# Ejecutar logs y capturar salida
python3 -m esphome logs smartnode1.yaml --device /dev/cu.usbserial-0001 2>&1 &
PID=$!

# Esperar 15 segundos
sleep 15

# Matar el proceso
kill $PID 2>/dev/null

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Captura de logs completada"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"



