#!/usr/bin/env python3
"""
Análisis de Automatizaciones - Identificar cuáles borrar
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
    """Obtiene todas las automatizaciones del servidor"""
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
    print("    ANÁLISIS DE AUTOMATIZACIONES - QUÉ BORRAR")
    print("════════════════════════════════════════════════════════════════\n")

    automations = get_all_automations()

    if not automations:
        print("❌ No se pudieron obtener las automatizaciones\n")
        return

    # Automatizaciones que DEBERÍAN estar (según nuestro archivo limpio)
    should_keep = {
        "automation.al_amanecer": "Al Amanecer",
        "automation.anochecer": "Anochecer",
        "automation.camara_grabacion_con_snapshot": "Cámara - Grabación con snapshot",
        "automation.a_dormir": "A dormir",
        "automation.relaycamaswitch": "RelayCamaSwitch",
        "automation.presence_simulation": "Presence Simulation",
        "automation.atardecer_inteligente": "Atardecer Inteligente",
        "automation.regreso_a_casa_desactivar_simulacion": "Regreso a Casa - Desactivar Simulación"
    }

    # Automatizaciones obsoletas conocidas
    known_obsolete = {
        "automation.presencia_on_al_activar_scene_anocheser",
        "automation.presencia_on_por_anocheser",
        "automation.simulacion_de_presencia_al_activar_escena_anochecer",
        "automation.presence_simulation_on_scene_nightfall",
        "automation.presence_simulation_reset_on_stop",
        "automation.presence_simulation_reset_on_start",
        "automation.presence_simulation_update_on_light_change",
        "automation.presence_simulation_update_status_on_input_change",
        "automation.presence_simulation_track_status_changes"
    }

    print("📊 AUTOMATIZACIONES EN EL SERVIDOR:")
    print("─" * 64)

    to_keep = []
    to_delete = []
    unknown = []

    for auto in automations:
        entity_id = auto['entity_id']
        name = auto['attributes'].get('friendly_name', entity_id)
        state = auto['state']

        if entity_id in should_keep:
            to_keep.append((entity_id, name, state))
        elif entity_id in known_obsolete:
            to_delete.append((entity_id, name, state))
        else:
            unknown.append((entity_id, name, state))

    # Mostrar las que DEBEN MANTENERSE
    print("\n✅ MANTENER (8 automatizaciones correctas):")
    print("─" * 64)
    for entity_id, name, state in sorted(to_keep):
        status_icon = "🟢" if state == "on" else "🔴"
        print(f"{status_icon} {name}")
        print(f"   {entity_id}")

    # Mostrar las que HAY QUE BORRAR
    if to_delete:
        print("\n❌ BORRAR MANUALMENTE (obsoletas):")
        print("─" * 64)
        for entity_id, name, state in sorted(to_delete):
            print(f"🗑️  {name}")
            print(f"   {entity_id}")
            print(f"   Motivo: Reemplazada por nuevas automatizaciones")
            print()
    else:
        print("\n✅ No hay automatizaciones obsoletas que borrar")

    # Mostrar las DESCONOCIDAS (no están en nuestro archivo)
    if unknown:
        print("\n⚠️  AUTOMATIZACIONES ADICIONALES (no en automations.yaml):")
        print("─" * 64)
        for entity_id, name, state in sorted(unknown):
            status_icon = "🟢" if state == "on" else "🔴"
            print(f"{status_icon} {name}")
            print(f"   {entity_id}")
        print("\n💡 Estas pueden ser útiles. Revísalas antes de decidir.")

    print("\n════════════════════════════════════════════════════════════════")
    print("                    📋 RESUMEN")
    print("════════════════════════════════════════════════════════════════")
    print(f"\n✅ Mantener:     {len(to_keep)}")
    print(f"❌ Borrar:       {len(to_delete)}")
    print(f"⚠️  Revisar:      {len(unknown)}")
    print(f"📊 Total:        {len(automations)}")

    if to_delete:
        print("\n" + "─" * 64)
        print("🎯 ACCIÓN REQUERIDA:")
        print("─" * 64)
        print("\nEn Home Assistant → Configuración → Automatizaciones:")
        print()
        for entity_id, name, state in sorted(to_delete):
            print(f"  • Busca '{name}' y elimínala")

    print("\n════════════════════════════════════════════════════════════════\n")

if __name__ == "__main__":
    main()

