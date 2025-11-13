#!/usr/bin/env python3
"""
Script para instalar/actualizar el blueprint v1.3 via API
"""

import os
import sys
from pathlib import Path
from ha_manager import HAManager

def read_blueprint():
    """Lee el blueprint v1.3 desde el archivo"""
    blueprint_path = Path(__file__).parent / "blueprints" / "pezaustral_presence_simulation_v1.3.yaml"
    
    if not blueprint_path.exists():
        print(f"❌ No se encontró el blueprint en: {blueprint_path}")
        return None
    
    with open(blueprint_path, 'r', encoding='utf-8') as f:
        return f.read()

def main():
    print("\n" + "="*70)
    print("  📦 INSTALACIÓN DE BLUEPRINT v1.3")
    print("="*70 + "\n")
    
    # Inicializar manager
    try:
        manager = HAManager()
    except ValueError as e:
        print(f"\n❌ Error: {e}\n")
        print("Configura el acceso API primero:")
        print("  ./setup.sh\n")
        sys.exit(1)
    
    # Test conexión
    if not manager.test_connection():
        print("\n❌ No se puede conectar a Home Assistant\n")
        sys.exit(1)
    
    print("\n" + "-"*70)
    print("  📄 LEYENDO BLUEPRINT")
    print("-"*70 + "\n")
    
    blueprint_content = read_blueprint()
    if not blueprint_content:
        sys.exit(1)
    
    print(f"✅ Blueprint leído: {len(blueprint_content)} caracteres")
    
    print("\n" + "-"*70)
    print("  🔍 ESTADO ACTUAL")
    print("-"*70 + "\n")
    
    # Ver automatización actual
    status = manager.get_presence_simulation_status()
    running = status.get('running', {}).get('state') == 'on'
    
    print(f"  Simulación activa: {'⚠️ SÍ (detener antes de actualizar)' if running else '✅ NO'}")
    
    if running:
        print("\n⚠️  ADVERTENCIA:")
        print("   La simulación está corriendo actualmente.")
        print("   Se recomienda detenerla antes de actualizar el blueprint.")
        print("")
        response = input("¿Quieres continuar de todas formas? (y/n): ")
        if response.lower() != 'y':
            print("\n❌ Instalación cancelada\n")
            sys.exit(0)
    
    print("\n" + "-"*70)
    print("  📝 INSTRUCCIONES MANUALES")
    print("-"*70 + "\n")
    
    print("La API REST de Home Assistant no permite crear/actualizar blueprints directamente.")
    print("Debes hacerlo manualmente siguiendo estos pasos:\n")
    
    print("═══════════════════════════════════════════════════════════════════\n")
    print("MÉTODO 1: Vía Interfaz Web (Recomendado)\n")
    print("───────────────────────────────────────────────────────────────────\n")
    print("1. Abre Home Assistant:")
    print("   http://192.168.1.100:8123/\n")
    print("2. Ve a: Configuración → Automatizaciones y Escenas\n")
    print("3. Click en \"Importar Blueprint\"\n")
    print("4. URL del blueprint:")
    print("   https://github.com/mauitz/home-assistant-blueprints/blob/main/blueprints/pezaustral_presence_simulation_v1.3.yaml\n")
    print("   (O copia el contenido de blueprints/pezaustral_presence_simulation_v1.3.yaml)\n")
    print("5. Edita tu automatización \"Presence Simulation\"\n")
    print("6. Cambia a usar el blueprint v1.3\n")
    print("7. Agrega: enable_monitoring: true\n")
    print("8. Guarda\n")
    
    print("═══════════════════════════════════════════════════════════════════\n")
    print("MÉTODO 2: Vía SSH/Terminal\n")
    print("───────────────────────────────────────────────────────────────────\n")
    print("1. Conéctate por SSH:")
    print("   ssh user@192.168.1.100\n")
    print("2. Copia el blueprint:")
    print("   cd /config/blueprints/automation/mauitz/")
    print("   # Copia el contenido de pezaustral_presence_simulation_v1.3.yaml\n")
    print("3. Reinicia Home Assistant o recarga automatizaciones\n")
    
    print("═══════════════════════════════════════════════════════════════════\n")
    print("MÉTODO 3: Vía File Editor (Add-on)\n")
    print("───────────────────────────────────────────────────────────────────\n")
    print("1. Instala el add-on \"File Editor\" si no lo tienes\n")
    print("2. Abre File Editor\n")
    print("3. Navega a: /config/blueprints/automation/mauitz/\n")
    print("4. Crea/edita: pezaustral_presence_simulation_v1.3.yaml\n")
    print("5. Pega el contenido del blueprint\n")
    print("6. Guarda\n")
    
    print("═══════════════════════════════════════════════════════════════════\n")
    
    print("\n📋 VERIFICACIÓN POST-INSTALACIÓN:\n")
    print("   python3 verify_installation.py\n")
    
    print("\n" + "="*70 + "\n")

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Interrumpido por el usuario\n")
        sys.exit(0)

