#!/usr/bin/env python3
"""
Verificador de Automatizaciones Post-Actualización
"""

import os
import sys
import json
import requests
from dotenv import load_dotenv

load_dotenv()

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")

def get_all_automations():
    """Obtiene todas las automatizaciones"""
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json",
    }

    try:
        response = requests.get(f"{HA_URL}/api/states", headers=headers)
        response.raise_for_status()

        all_entities = response.json()
        automations = [e for e in all_entities if e['entity_id'].startswith('automation.')]

        return automations
    except Exception as e:
        print(f"❌ Error al obtener automatizaciones: {e}")
        return []

def main():
    print("════════════════════════════════════════════════════════════════")
    print("         VERIFICACIÓN DE AUTOMATIZACIONES")
    print("════════════════════════════════════════════════════════════════\n")

    automations = get_all_automations()

    if not automations:
        print("❌ No se pudieron obtener las automatizaciones\n")
        return

    # Automatizaciones esperadas (nuevas)
    expected_new = [
        "automation.atardecer_inteligente",
        "automation.regreso_a_casa_desactivar_simulacion"
    ]

    # Automatizaciones obsoletas que NO deberían estar
    obsolete = [
        "automation.presencia_on_al_activar_scene_anocheser",
        "automation.presencia_on_por_anocheser",
        "automation.simulacion_de_presencia_al_activar_escena_anochecer",
        "automation.presence_simulation_on_scene_nightfall",
        "automation.presence_simulation_reset_on_stop",
        "automation.presence_simulation_reset_on_start",
        "automation.presence_simulation_update_on_light_change",
        "automation.presence_simulation_update_status_on_input_change",
        "automation.presence_simulation_track_status_changes"
    ]

    # Automatizaciones clave que deben estar
    critical = [
        "automation.presence_simulation",
        "automation.al_amanecer",
        "automation.anochecer"
    ]

    automation_ids = [a['entity_id'] for a in automations]

    # Verificar nuevas automatizaciones
    print("✨ NUEVAS AUTOMATIZACIONES:")
    print("─" * 64)
    for auto_id in expected_new:
        found = any(a['entity_id'] == auto_id for a in automations)
        status = "✅" if found else "❌"
        print(f"{status} {auto_id}")
        if found:
            auto = next(a for a in automations if a['entity_id'] == auto_id)
            print(f"   Estado: {auto['state']}")
            print(f"   Nombre: {auto['attributes'].get('friendly_name', 'N/A')}")

    print("\n🔧 AUTOMATIZACIONES CRÍTICAS:")
    print("─" * 64)
    for auto_id in critical:
        found = any(a['entity_id'] == auto_id for a in automations)
        status = "✅" if found else "❌"
        print(f"{status} {auto_id}")
        if found:
            auto = next(a for a in automations if a['entity_id'] == auto_id)
            print(f"   Estado: {auto['state']}")

    print("\n🗑️  AUTOMATIZACIONES OBSOLETAS (No deberían estar):")
    print("─" * 64)
    found_obsolete = []
    for auto_id in obsolete:
        found = any(a['entity_id'] == auto_id for a in automations)
        if found:
            found_obsolete.append(auto_id)
            print(f"⚠️  {auto_id} - TODAVÍA EXISTE")

    if not found_obsolete:
        print("✅ Ninguna automatización obsoleta encontrada")

    print(f"\n📊 TOTAL DE AUTOMATIZACIONES: {len(automations)}")
    print("\n════════════════════════════════════════════════════════════════")

    # Resumen
    new_ok = all(any(a['entity_id'] == auto_id for a in automations) for auto_id in expected_new)
    critical_ok = all(any(a['entity_id'] == auto_id for a in automations) for auto_id in critical)
    no_obsolete = len(found_obsolete) == 0

    print("\n🎯 RESUMEN:")
    print("─" * 64)
    print(f"{'✅' if new_ok else '❌'} Nuevas automatizaciones cargadas")
    print(f"{'✅' if critical_ok else '❌'} Automatizaciones críticas presentes")
    print(f"{'✅' if no_obsolete else '⚠️ '} Sin automatizaciones obsoletas")

    if new_ok and critical_ok and no_obsolete:
        print("\n✨ ¡TODO PERFECTO! El sistema está listo.")
    else:
        print("\n⚠️  Hay algunas cosas que revisar (ver arriba)")

    print("\n════════════════════════════════════════════════════════════════\n")

if __name__ == "__main__":
    main()

