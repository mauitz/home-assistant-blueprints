#!/usr/bin/env python3
"""
Script de Limpieza del Sistema Home Assistant
Elimina helpers obsoletos y automatizaciones desactivadas
"""

import os
import sys
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

def delete_helper(entity_id):
    """Elimina un helper (input_*)"""
    domain = entity_id.split('.')[0]
    object_id = entity_id.split('.')[1]

    try:
        # Intentar con configuración directa
        response = requests.delete(
            f"{HA_URL}/api/config/{domain}/{object_id}",
            headers=get_headers()
        )

        if response.status_code in [200, 201, 204]:
            return True, "Eliminado"
        else:
            return False, f"Error {response.status_code}: {response.text}"
    except Exception as e:
        return False, str(e)

def delete_automation_by_id(automation_id):
    """Elimina una automatización por su ID interno"""
    try:
        response = requests.delete(
            f"{HA_URL}/api/config/automation/config/{automation_id}",
            headers=get_headers()
        )

        if response.status_code in [200, 201, 204]:
            return True, "Eliminada"
        else:
            return False, f"Error {response.status_code}"
    except Exception as e:
        return False, str(e)

def get_automation_config():
    """Obtiene la configuración de automatizaciones"""
    try:
        response = requests.get(
            f"{HA_URL}/api/config/automation/config",
            headers=get_headers()
        )

        if response.status_code == 200:
            return response.json()
        else:
            return []
    except Exception as e:
        print(f"Error obteniendo configuración: {e}")
        return []

def main():
    print("════════════════════════════════════════════════════════════════")
    print("        LIMPIEZA DEL SISTEMA HOME ASSISTANT")
    print("════════════════════════════════════════════════════════════════\n")

    # ========================================================================
    # 1. ELIMINAR HELPERS OBSOLETOS
    # ========================================================================
    print("🗑️  1. ELIMINANDO HELPERS OBSOLETOS")
    print("─" * 64)

    obsolete_helpers = [
        ("input_boolean.presence_simulation_2", "Helper duplicado - Ya existe presence_simulation"),
        ("input_number.presence_simulation_loop_total", "Ya no necesario en v1.3 (monitoreo integrado)")
    ]

    print()
    for helper_id, reason in obsolete_helpers:
        print(f"Eliminando: {helper_id}")
        print(f"Razón: {reason}")
        success, message = delete_helper(helper_id)

        if success:
            print(f"✅ {message}\n")
        else:
            print(f"⚠️  {message}")
            print(f"   Necesitarás eliminarlo manualmente desde la UI\n")

    # ========================================================================
    # 2. ELIMINAR AUTOMATIZACIONES DESACTIVADAS
    # ========================================================================
    print("─" * 64)
    print("🤖 2. BUSCANDO AUTOMATIZACIONES DESACTIVADAS")
    print("─" * 64)
    print()

    # Obtener configuración de automatizaciones
    automation_config = get_automation_config()

    if not automation_config:
        print("⚠️  No se pudo acceder a la configuración de automatizaciones via API")
        print("   Las automatizaciones desactivadas necesitan eliminarse manualmente\n")
    else:
        # Buscar automatizaciones que estén desactivadas
        disabled_autos = []
        for auto in automation_config:
            # Verificar si tiene el campo 'disabled' o 'initial_state' en false
            if auto.get('disabled', False) or auto.get('initial_state') == 'off':
                disabled_autos.append(auto)

        if disabled_autos:
            print(f"Encontradas {len(disabled_autos)} automatizaciones desactivadas:\n")

            for auto in disabled_autos:
                auto_id = auto.get('id')
                alias = auto.get('alias', 'Sin nombre')

                print(f"  • {alias} (id: {auto_id})")

                if auto_id:
                    print(f"    Eliminando...")
                    success, message = delete_automation_by_id(auto_id)

                    if success:
                        print(f"    ✅ {message}\n")
                    else:
                        print(f"    ⚠️  {message}\n")
                else:
                    print(f"    ⚠️  No se pudo obtener ID\n")
        else:
            print("✅ No se encontraron automatizaciones desactivadas\n")

    # ========================================================================
    # RESUMEN FINAL
    # ========================================================================
    print("═" * 64)
    print("                    ✅ LIMPIEZA COMPLETADA")
    print("═" * 64)
    print("\n🎯 PRÓXIMOS PASOS:")
    print("  1. Reinicia Home Assistant para aplicar cambios")
    print("  2. Verifica el dashboard de monitoreo")
    print("  3. Prueba las automatizaciones nuevas\n")
    print("═" * 64 + "\n")

if __name__ == "__main__":
    main()

