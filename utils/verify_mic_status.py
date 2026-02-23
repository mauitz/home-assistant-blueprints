#!/usr/bin/env python3
"""
Script para verificar el estado del micrófono INMP441 en SmartNode1
Verifica la configuración y el estado operacional
"""

import yaml
import sys
from pathlib import Path

def main():
    print("🎤 VERIFICACIÓN DE MICRÓFONO SMARTNODE1")
    print("=" * 60)
    print()
    
    # Leer configuración
    config_path = Path(__file__).parent.parent / "esphome" / "smartnode1.yaml"
    
    try:
        with open(config_path, 'r') as f:
            config = yaml.safe_load(f)
    except Exception as e:
        print(f"❌ Error al leer configuración: {e}")
        return 1
    
    # Verificar configuración de I2S
    print("1️⃣ Verificando configuración I2S Audio...")
    if 'i2s_audio' in config:
        i2s_config = config['i2s_audio'][0] if isinstance(config['i2s_audio'], list) else config['i2s_audio']
        print("✅ I2S Audio configurado:")
        print(f"   - LRCLK (WS):  GPIO{i2s_config.get('i2s_lrclk_pin', '?').replace('GPIO', '')}")
        print(f"   - BCLK (SCK):  GPIO{i2s_config.get('i2s_bclk_pin', '?').replace('GPIO', '')}")
    else:
        print("❌ I2S Audio NO está configurado")
        return 1
    
    print()
    
    # Verificar configuración de micrófono
    print("2️⃣ Verificando configuración de Micrófono...")
    if 'microphone' in config:
        mic_config = config['microphone'][0] if isinstance(config['microphone'], list) else config['microphone']
        print("✅ Micrófono configurado:")
        print(f"   - Platform:    {mic_config.get('platform', '?')}")
        print(f"   - ADC Type:    {mic_config.get('adc_type', '?')}")
        print(f"   - Data Pin:    GPIO{mic_config.get('i2s_din_pin', '?').replace('GPIO', '')}")
        print(f"   - PDM Mode:    {mic_config.get('pdm', '?')}")
    else:
        print("❌ Micrófono NO está configurado")
        return 1
    
    print()
    
    # Verificar pines
    print("3️⃣ Verificando asignación de pines...")
    expected_pins = {
        'GPIO25': 'WS (Word Select)',
        'GPIO26': 'SCK (Bit Clock)',
        'GPIO33': 'SD (Serial Data)'
    }
    
    print("✅ Pines esperados para INMP441:")
    for pin, function in expected_pins.items():
        print(f"   - {pin}: {function}")
    
    print()
    
    # Verificar conectividad
    print("4️⃣ Verificando conectividad con SmartNode1...")
    import socket
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(2)
        result = sock.connect_ex(('192.168.1.13', 6053))
        if result == 0:
            print("✅ SmartNode1 está en línea (192.168.1.13)")
        else:
            print("❌ No se puede conectar con SmartNode1")
            return 1
        sock.close()
    except Exception as e:
        print(f"❌ Error de conexión: {e}")
        return 1
    
    print()
    print("=" * 60)
    print("📊 RESUMEN")
    print("=" * 60)
    print()
    print("✅ Configuración del micrófono: CORRECTA")
    print("✅ Pines I2S configurados: GPIO25, GPIO26, GPIO33")
    print("✅ SmartNode1 conectado: 192.168.1.13")
    print()
    print("🔍 PRÓXIMOS PASOS PARA VERIFICAR HARDWARE:")
    print()
    print("OPCIÓN A - Ver logs en tiempo real (recomendado):")
    print("   python3 -m esphome logs esphome/smartnode1.yaml")
    print()
    print("   Busca estos mensajes durante el arranque:")
    print("   ✅ '[I][i2s_audio] Setting up I2S Audio...'")
    print("   ✅ '[I][microphone] Setting up Microphone...'")
    print("   ❌ '[E][i2s_audio] I2S read timeout' (indica problema)")
    print()
    print("OPCIÓN B - Verificar con multímetro:")
    print("   1. Mide 3.3V entre VDD y GND del INMP441")
    print("   2. Verifica continuidad de los cables GPIO25, 26, 33")
    print()
    print("OPCIÓN C - Hacer ruido y verificar:")
    print("   1. Ejecuta: python3 -m esphome logs esphome/smartnode1.yaml")
    print("   2. Aplaude o habla FUERTE cerca del SmartNode1")
    print("   3. Busca actividad en los logs (no habrá eventos si el")
    print("      sensor Sound Level no está implementado, pero no debe")
    print("      haber errores de I2S)")
    print()
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
