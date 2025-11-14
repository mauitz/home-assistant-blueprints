#!/usr/bin/env python3
"""
Eliminar Automatizaciones Obsoletas vía API
"""

import os
import sys
import json
import requests
from dotenv import load_dotenv

load_dotenv()

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")

def delete_automation(entity_id: str):
    """Intenta eliminar una automatización"""
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json",
    }

    # Intentar con el servicio automation.delete
    data = {
        "entity_id": entity_id
    }

    try:
        response = requests.post(
            f"{HA_URL}/api/services/automation/delete",
            headers=headers,
            json=data
        )

        if response.status_code in [200, 201]:
            print(f"✅ {entity_id} - Eliminada correctamente")
            return True
        else:
            print(f"❌ {entity_id} - Error {response.status_code}: {response.text}")
            return False

    except Exception as e:
        print(f"❌ {entity_id} - Error: {e}")
        return False

def main():
    print("════════════════════════════════════════════════════════════════")
    print("         ELIMINANDO AUTOMATIZACIONES OBSOLETAS")
    print("════════════════════════════════════════════════════════════════\n")

    obsolete = [
        "automation.presencia_on_al_activar_scene_anocheser",
        "automation.simulacion_de_presencia_al_activar_escena_anochecer"
    ]

    results = []
    for auto_id in obsolete:
        print(f"🗑️  Intentando eliminar: {auto_id}")
        success = delete_automation(auto_id)
        results.append(success)
        print()

    print("════════════════════════════════════════════════════════════════")

    if all(results):
        print("✅ Todas las automatizaciones obsoletas fueron eliminadas\n")
        return 0
    else:
        print("⚠️  No se pudieron eliminar por API\n")
        print("💡 Necesitarás eliminarlas manualmente o actualizar automations.yaml\n")
        return 1

if __name__ == "__main__":
    sys.exit(main())

