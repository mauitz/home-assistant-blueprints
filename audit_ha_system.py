#!/usr/bin/env python3
"""
Auditoría Completa del Sistema Home Assistant
Identifica helpers, automatizaciones y configuraciones obsoletas
"""

import os
import sys
import json
import requests
from dotenv import load_dotenv
from collections import defaultdict

load_dotenv()

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")

def get_entities(domain_filter=None):
    """Obtiene todas las entidades del servidor"""
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json",
    }

    try:
        response = requests.get(f"{HA_URL}/api/states", headers=headers)
        response.raise_for_status()
        entities = response.json()

        if domain_filter:
            entities = [e for e in entities if e['entity_id'].startswith(f"{domain_filter}.")]

        return entities
    except Exception as e:
        print(f"❌ Error: {e}")
        return []

def delete_entity(entity_id):
    """Intenta eliminar una entidad (solo funciona con algunas)"""
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json",
    }

    domain = entity_id.split('.')[0]

    try:
        # Intentar con el servicio delete del dominio
        response = requests.post(
            f"{HA_URL}/api/services/{domain}/delete",
            headers=headers,
            json={"entity_id": entity_id}
        )

        if response.status_code in [200, 201]:
            return True, "Eliminada"
        else:
            return False, f"Error {response.status_code}"
    except Exception as e:
        return False, str(e)

def main():
    print("════════════════════════════════════════════════════════════════")
    print("        AUDITORÍA COMPLETA DEL SISTEMA")
    print("════════════════════════════════════════════════════════════════\n")

    # ========================================================================
    # 1. HELPERS PARA SIMULACIÓN DE PRESENCIA
    # ========================================================================
    print("📦 1. HELPERS DE SIMULACIÓN DE PRESENCIA")
    print("─" * 64)

    # Helpers requeridos por blueprint v1.3 (con monitoreo integrado)
    required_helpers_v13 = {
        "input_boolean.presence_simulation": "Control principal",
        "input_boolean.presence_simulation_running": "Estado running (monitoreo)",
        "input_number.presence_simulation_loop_counter": "Contador de loops",
        "input_number.presence_simulation_lights_on_count": "Contador de luces encendidas",
        "input_datetime.presence_simulation_start_time": "Hora de inicio",
        "input_datetime.presence_simulation_last_update": "Última actualización",
        "input_text.presence_simulation_status": "Estado actual",
        "input_text.presence_simulation_active_lights": "Luces activas",
        "input_text.presence_simulation_last_light_on": "Última luz encendida",
        "input_text.presence_simulation_last_light_off": "Última luz apagada",
    }

    # Obtener todos los helpers
    input_entities = {}
    for domain in ['input_boolean', 'input_number', 'input_datetime', 'input_text']:
        entities = get_entities(domain)
        for e in entities:
            input_entities[e['entity_id']] = e

    # Verificar cuáles existen
    print("\n✅ REQUERIDOS (Blueprint v1.3):")
    for helper_id, description in required_helpers_v13.items():
        if helper_id in input_entities:
            print(f"  ✓ {helper_id}")
            print(f"    {description}")
        else:
            print(f"  ❌ FALTA: {helper_id}")
            print(f"    {description}")

    # Identificar obsoletos (relacionados con presence_simulation pero no en la lista)
    print("\n🗑️  POTENCIALMENTE OBSOLETOS:")
    obsolete_found = False
    for entity_id, entity in input_entities.items():
        if 'presence' in entity_id.lower() or 'simulation' in entity_id.lower():
            if entity_id not in required_helpers_v13:
                obsolete_found = True
                print(f"  • {entity_id}")
                print(f"    Nombre: {entity['attributes'].get('friendly_name', 'N/A')}")
                print(f"    Estado: {entity['state']}")

    if not obsolete_found:
        print("  ✓ No se encontraron helpers obsoletos")

    # ========================================================================
    # 2. AUTOMATIZACIONES DESACTIVADAS
    # ========================================================================
    print("\n" + "═" * 64)
    print("🤖 2. AUTOMATIZACIONES DESACTIVADAS")
    print("─" * 64)

    automations = get_entities('automation')
    disabled = [a for a in automations if a['state'] == 'off']

    if disabled:
        print(f"\nEncontradas {len(disabled)} automatizaciones desactivadas:\n")
        for auto in disabled:
            entity_id = auto['entity_id']
            name = auto['attributes'].get('friendly_name', entity_id)
            print(f"  🔴 {name}")
            print(f"     {entity_id}")
    else:
        print("\n✓ No hay automatizaciones desactivadas")

    # ========================================================================
    # 3. SENSORES TEMPLATE RELACIONADOS
    # ========================================================================
    print("\n" + "═" * 64)
    print("📊 3. SENSORES TEMPLATE (Presence Simulation)")
    print("─" * 64)

    sensors = get_entities('sensor')
    presence_sensors = [s for s in sensors if 'presence' in s['entity_id'].lower()
                       or 'simulation' in s['entity_id'].lower()]

    if presence_sensors:
        print()
        for sensor in presence_sensors:
            entity_id = sensor['entity_id']
            name = sensor['attributes'].get('friendly_name', entity_id)
            state = sensor['state']
            print(f"  • {name}")
            print(f"    {entity_id}")
            print(f"    Estado: {state}")
    else:
        print("\n✓ No se encontraron sensores relacionados")

    # ========================================================================
    # 4. SCRIPTS RELACIONADOS
    # ========================================================================
    print("\n" + "═" * 64)
    print("📜 4. SCRIPTS (Presence Simulation)")
    print("─" * 64)

    scripts = get_entities('script')
    presence_scripts = [s for s in scripts if 'presence' in s['entity_id'].lower()
                       or 'simulation' in s['entity_id'].lower()]

    if presence_scripts:
        print()
        for script in presence_scripts:
            entity_id = script['entity_id']
            name = script['attributes'].get('friendly_name', entity_id)
            print(f"  • {name}")
            print(f"    {entity_id}")
    else:
        print("\n✓ No se encontraron scripts relacionados")

    # ========================================================================
    # RESUMEN Y RECOMENDACIONES
    # ========================================================================
    print("\n" + "═" * 64)
    print("                    📋 RESUMEN")
    print("═" * 64)

    print(f"\n📦 Helpers: {len([h for h in required_helpers_v13 if h in input_entities])}/{len(required_helpers_v13)} requeridos presentes")
    print(f"🤖 Automatizaciones desactivadas: {len(disabled)}")
    print(f"📊 Sensores relacionados: {len(presence_sensors)}")
    print(f"📜 Scripts relacionados: {len(presence_scripts)}")

    # Guardar lista de desactivadas para limpieza
    if disabled:
        print("\n" + "─" * 64)
        print("💡 LIMPIEZA RECOMENDADA")
        print("─" * 64)
        print(f"\nSe encontraron {len(disabled)} automatizaciones desactivadas.")
        print("¿Quieres que genere un script para eliminarlas automáticamente?")

        # Guardar IDs en archivo
        with open('/tmp/disabled_automations.txt', 'w') as f:
            for auto in disabled:
                f.write(f"{auto['entity_id']}\n")
        print(f"\nLista guardada en: /tmp/disabled_automations.txt")

    print("\n" + "═" * 64 + "\n")

if __name__ == "__main__":
    main()

