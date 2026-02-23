#!/bin/bash

# Script para capturar logs del SmartNode1 y buscar mensajes del micrófono

echo "🎤 Capturando logs del SmartNode1..."
echo "Esperando 10 segundos para capturar mensajes..."
echo ""

cd /Users/maui/_maui/domotica/home-assistant-blueprints

# Capturar logs por 10 segundos en background
python3 -m esphome logs esphome/smartnode1.yaml 2>&1 > /tmp/smartnode1_logs.txt &
PID=$!

# Esperar 10 segundos
sleep 10

# Terminar el proceso
kill $PID 2>/dev/null
wait $PID 2>/dev/null

echo "✅ Logs capturados"
echo ""
echo "🔍 Buscando mensajes del micrófono e I2S..."
echo "=" * 60
echo ""

# Buscar mensajes relevantes
if grep -i "i2s\|microphone\|mic" /tmp/smartnode1_logs.txt > /dev/null 2>&1; then
    echo "📝 Mensajes encontrados:"
    echo ""
    grep -i "i2s\|microphone\|mic" /tmp/smartnode1_logs.txt
else
    echo "⚠️  No se encontraron mensajes específicos del micrófono"
    echo "Esto puede significar:"
    echo "  1. El dispositivo no está enviando logs (modo silencioso)"
    echo "  2. El micrófono se inicializó correctamente sin mensajes"
    echo ""
    echo "Mostrando todos los logs capturados:"
    echo ""
    cat /tmp/smartnode1_logs.txt
fi

echo ""
echo "=" * 60
echo "Logs completos guardados en: /tmp/smartnode1_logs.txt"
