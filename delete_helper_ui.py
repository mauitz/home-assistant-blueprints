#!/usr/bin/env python3
"""
Eliminar Helper creado desde UI (almacenado en .storage)
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

def get_entity_registry():
    """Obtiene el registro de entidades"""
    try:
        response = requests.get(
            f"{HA_URL}/api/config/entity_registry/list",
            headers=get_headers()
        )

        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error {response.status_code}: {response.text}")
            return []
    except Exception as e:
        print(f"Error: {e}")
        return []

def delete_entity(entity_id):
    """Elimina una entidad del registro"""
    try:
        response = requests.delete(
            f"{HA_URL}/api/config/entity_registry/{entity_id}",
            headers=get_headers()
        )

        if response.status_code in [200, 201, 204]:
            return True, "Eliminada del registro"
        else:
            return False, f"Error {response.status_code}: {response.text}"
    except Exception as e:
        return False, str(e)

def main():
    print("════════════════════════════════════════════════════════════════")
    print("        ELIMINAR HELPER CREADO DESDE UI")
    print("════════════════════════════════════════════════════════════════\n")

    # Buscar presence_simulation_2
    print("🔍 Buscando presence_simulation_2...")

    entities = get_entity_registry()

    if not entities:
        print("❌ No se pudo acceder al registro de entidades\n")
        print("💡 SOLUCIÓN MANUAL:")
        print("   1. En Home Assistant: Configuración → Dispositivos y Servicios")
        print("   2. Click en pestaña 'Entidades'")
        print("   3. Buscar 'presence_simulation_2'")
        print("   4. Click en la entidad → Configuración (⚙️)")
        print("   5. Scroll abajo → 'Eliminar'")
        return

    # Buscar la entidad
    target_entity = None
    for entity in entities:
        if 'presence_simulation_2' in entity.get('entity_id', ''):
            target_entity = entity
            break

    if not target_entity:
        print("✅ No se encontró presence_simulation_2")
        print("   Es posible que ya haya sido eliminada.\n")
        return

    entity_id = target_entity.get('entity_id')
    name = target_entity.get('name', entity_id)
    platform = target_entity.get('platform', 'unknown')

    print(f"✓ Encontrada: {entity_id}")
    print(f"  Nombre: {name}")
    print(f"  Plataforma: {platform}")
    print()

    # Intentar eliminar
    print("🗑️  Intentando eliminar...")
    success, message = delete_entity(entity_id)

    if success:
        print(f"✅ {message}")
        print()
        print("🔄 Para aplicar cambios:")
        print("   Configuración → Sistema → Recargar → Entidades")
        print("   O reinicia Home Assistant")
    else:
        print(f"⚠️  {message}")
        print()
        print("💡 Elimínalo manualmente:")
        print("   Configuración → Dispositivos y Servicios → Entidades")
        print("   Buscar 'presence_simulation_2' → Eliminar")

    print()
    print("════════════════════════════════════════════════════════════════\n")

if __name__ == "__main__":
    main()


