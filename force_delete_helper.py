#!/usr/bin/env python3
"""
Forzar eliminación de helper presence_simulation_2
Primero deshabilitamos, luego intentamos eliminar
"""

import os
import json
import requests
from dotenv import load_dotenv

load_dotenv()

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")

def get_headers():
    return {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json",
    }

def get_states():
    """Obtiene todos los estados para verificar si existe"""
    try:
        response = requests.get(f"{HA_URL}/api/states", headers=get_headers())
        if response.status_code == 200:
            return response.json()
        return []
    except Exception as e:
        print(f"Error: {e}")
        return []

def disable_entity(entity_id):
    """Intenta deshabilitar la entidad primero"""
    try:
        # Actualizar el estado a off
        response = requests.post(
            f"{HA_URL}/api/services/input_boolean/turn_off",
            headers=get_headers(),
            json={"entity_id": entity_id}
        )

        if response.status_code in [200, 201]:
            return True, "Deshabilitada"
        else:
            return False, f"Error {response.status_code}"
    except Exception as e:
        return False, str(e)

def main():
    print("════════════════════════════════════════════════════════════════")
    print("        DIAGNÓSTICO DE presence_simulation_2")
    print("════════════════════════════════════════════════════════════════\n")

    # Verificar si existe
    print("🔍 Verificando existencia...")
    states = get_states()

    target = None
    for state in states:
        if state['entity_id'] == 'input_boolean.presence_simulation_2':
            target = state
            break

    if not target:
        print("✅ input_boolean.presence_simulation_2 NO existe")
        print("   Ya fue eliminada o nunca existió.\n")
        return

    print(f"⚠️  input_boolean.presence_simulation_2 SÍ existe")
    print(f"   Estado actual: {target['state']}")
    print(f"   Nombre: {target['attributes'].get('friendly_name', 'N/A')}")
    print()

    # Verificar de dónde viene
    print("📋 ANÁLISIS:")
    print("─" * 64)

    # Si tiene 'editable' = False, viene de YAML
    # Si tiene 'editable' = True o no tiene el campo, viene de UI
    editable = target['attributes'].get('editable', True)

    if not editable:
        print("⚠️  Esta entidad fue creada en configuration.yaml")
        print("   (tiene editable: false)")
        print()
        print("❌ NO se puede eliminar desde la UI mientras esté en YAML")
        print()
        print("🔧 SOLUCIÓN:")
        print("   1. Verificar que NO esté en configuration.yaml")
        print("   2. Recargar configuración: Herramientas Dev → YAML → Recargar")
        print("   3. Reintentar eliminación desde UI")
    else:
        print("✓ Esta entidad fue creada desde la UI")
        print("  (tiene editable: true o no definido)")
        print()
        print("⚠️  El botón 'Eliminar' puede estar deshabilitado si:")
        print("   • Está siendo usada en una automatización")
        print("   • Está siendo usada en un script")
        print("   • Está siendo usada en un dashboard")
        print("   • Tiene alguna dependencia")
        print()
        print("🔧 SOLUCIÓN:")
        print("   Buscar dónde está siendo usada y eliminar esas referencias")

    print()

    # Buscar uso en automatizaciones
    print("🔎 Buscando uso en automatizaciones...")

    auto_response = requests.get(f"{HA_URL}/api/states", headers=get_headers())
    if auto_response.status_code == 200:
        automations = [s for s in auto_response.json() if s['entity_id'].startswith('automation.')]

        uses = []
        for auto in automations:
            # Esto es aproximado, necesitaríamos el código fuente
            auto_data = json.dumps(auto)
            if 'presence_simulation_2' in auto_data:
                uses.append(auto['attributes'].get('friendly_name', auto['entity_id']))

        if uses:
            print(f"⚠️  Encontrada en {len(uses)} automatización(es):")
            for name in uses:
                print(f"   • {name}")
        else:
            print("✓ No encontrada en automatizaciones activas")

    print()
    print("════════════════════════════════════════════════════════════════")
    print("              💡 RECOMENDACIÓN FINAL")
    print("════════════════════════════════════════════════════════════════\n")

    if not editable:
        print("🎯 Esta entidad DEBE estar definida en algún archivo YAML")
        print("   aunque no aparezca en configuration.yaml del proxy.")
        print()
        print("   Posiblemente está en:")
        print("   • /config/.storage/core.config_entries")
        print("   • Algún archivo en /config/packages/")
        print("   • O fue importada de otra integración")
        print()
        print("   Para eliminarla vía SSH:")
        print()
        print("   ssh nico@192.168.1.100")
        print("   cd /config/.storage")
        print("   grep -l 'presence_simulation_2' *.json")
        print()
    else:
        print("🎯 Intenta recargar la configuración primero:")
        print()
        print("   Herramientas de Desarrollo → YAML")
        print("   → 'Recargar configuración de plantillas'")
        print("   → 'Recargar entidades de input_boolean'")
        print()
        print("   Luego reintenta eliminar desde UI")

    print()
    print("════════════════════════════════════════════════════════════════\n")

if __name__ == "__main__":
    main()


