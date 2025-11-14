#!/usr/bin/env python3
"""
Listar TODAS las automatizaciones que ve la API
"""

import os
import json
import requests
from dotenv import load_dotenv

load_dotenv()

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")

def main():
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json",
    }

    response = requests.get(f"{HA_URL}/api/states", headers=headers)
    response.raise_for_status()

    all_entities = response.json()
    automations = [e for e in all_entities if e['entity_id'].startswith('automation.')]

    print("════════════════════════════════════════════════════════════════")
    print(f"   TODAS LAS AUTOMATIZACIONES (Total: {len(automations)})")
    print("════════════════════════════════════════════════════════════════\n")

    for i, auto in enumerate(sorted(automations, key=lambda x: x['attributes'].get('friendly_name', '')), 1):
        entity_id = auto['entity_id']
        name = auto['attributes'].get('friendly_name', entity_id)
        state = auto['state']
        status_icon = "🟢" if state == "on" else "🔴"

        print(f"{i:2d}. {status_icon} {name}")
        print(f"     {entity_id}")
        print()

if __name__ == "__main__":
    main()

