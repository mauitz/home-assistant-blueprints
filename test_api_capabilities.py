#!/usr/bin/env python3
"""
Test completo de capacidades de la API de Home Assistant
"""

import os
import sys
import json
import requests
from dotenv import load_dotenv

load_dotenv()

url_base = "http://192.168.1.100:8123"
token = os.getenv('HA_TOKEN')

headers = {
    'Authorization': f'Bearer {token}',
    'Content-Type': 'application/json'
}

def test_api_capabilities():
    print("\n" + "="*70)
    print("  🔬 CAPACIDADES DE LA API DE HOME ASSISTANT")
    print("="*70 + "\n")

    capabilities = {
        'read': [],
        'write': [],
        'limited': [],
        'not_available': []
    }

    # ══════════════════════════════════════════════════════════════════════
    # LECTURA (GET)
    # ══════════════════════════════════════════════════════════════════════

    print("─"*70)
    print("  📖 CAPACIDADES DE LECTURA (GET)")
    print("─"*70 + "\n")

    # 1. Ver estados de entidades
    try:
        response = requests.get(f"{url_base}/api/states", headers=headers, timeout=5)
        if response.status_code == 200:
            states = response.json()
            automations = [s for s in states if s['entity_id'].startswith('automation.')]
            print(f"✅ Ver estados de entidades")
            print(f"   • Total entidades: {len(states)}")
            print(f"   • Automatizaciones: {len(automations)}")
            capabilities['read'].append('Ver estados de todas las entidades')
        else:
            print(f"❌ Ver estados: HTTP {response.status_code}")
    except Exception as e:
        print(f"❌ Ver estados: {e}")

    # 2. Ver estado específico
    try:
        response = requests.get(f"{url_base}/api/states/automation.presence_simulation", headers=headers, timeout=5)
        if response.status_code == 200:
            auto = response.json()
            print(f"\n✅ Ver estado de entidad específica")
            print(f"   • Entity: automation.presence_simulation")
            print(f"   • Estado: {auto.get('state')}")
            print(f"   • Atributos: {len(auto.get('attributes', {}))} disponibles")
            capabilities['read'].append('Ver estado de entidad específica')
        else:
            print(f"❌ Ver estado específico: HTTP {response.status_code}")
    except Exception as e:
        print(f"❌ Ver estado específico: {e}")

    # 3. Ver servicios disponibles
    try:
        response = requests.get(f"{url_base}/api/services", headers=headers, timeout=5)
        if response.status_code == 200:
            services = response.json()
            print(f"\n✅ Ver servicios disponibles")
            print(f"   • Total dominios: {len(services)}")

            # Buscar automation
            for service in services:
                if service.get('domain') == 'automation':
                    svc_list = list(service.get('services', {}).keys())
                    print(f"   • Servicios de automation: {', '.join(svc_list)}")
                    capabilities['read'].append(f'Ver servicios: {", ".join(svc_list)}')
        else:
            print(f"❌ Ver servicios: HTTP {response.status_code}")
    except Exception as e:
        print(f"❌ Ver servicios: {e}")

    # 4. Ver configuración
    try:
        response = requests.get(f"{url_base}/api/config", headers=headers, timeout=5)
        if response.status_code == 200:
            config = response.json()
            print(f"\n✅ Ver configuración de HA")
            print(f"   • Versión: {config.get('version')}")
            print(f"   • Location: {config.get('location_name')}")
            capabilities['read'].append('Ver configuración general')
        else:
            print(f"❌ Ver configuración: HTTP {response.status_code}")
    except Exception as e:
        print(f"❌ Ver configuración: {e}")

    # 5. Ver eventos
    try:
        response = requests.get(f"{url_base}/api/events", headers=headers, timeout=5)
        if response.status_code == 200:
            events = response.json()
            print(f"\n✅ Ver eventos disponibles")
            print(f"   • Total eventos: {len(events)}")
            capabilities['read'].append('Ver eventos del sistema')
        else:
            print(f"❌ Ver eventos: HTTP {response.status_code}")
    except Exception as e:
        print(f"❌ Ver eventos: {e}")

    # ══════════════════════════════════════════════════════════════════════
    # ESCRITURA (POST)
    # ══════════════════════════════════════════════════════════════════════

    print("\n" + "─"*70)
    print("  ✍️  CAPACIDADES DE ESCRITURA (POST)")
    print("─"*70 + "\n")

    # 1. Llamar servicios
    print("✅ Llamar servicios (automation.turn_on, automation.trigger, etc.)")
    print("   Endpoint: POST /api/services/{domain}/{service}")
    print("   Ejemplos:")
    print("   • automation.turn_on - Activar automatización")
    print("   • automation.turn_off - Desactivar automatización")
    print("   • automation.trigger - Ejecutar automatización manualmente")
    print("   • automation.reload - Recargar automatizaciones")
    capabilities['write'].append('Llamar servicios (turn_on, turn_off, trigger, reload)')

    # 2. Cambiar estados (limitado)
    print("\n⚠️  Cambiar estados directamente")
    print("   Endpoint: POST /api/states/{entity_id}")
    print("   Limitación: Solo para entidades virtuales/sensores custom")
    print("   ❌ NO funciona para automatizaciones (se gestionan por servicios)")
    capabilities['limited'].append('Cambiar estados (solo entidades específicas)')

    # 3. Disparar eventos
    print("\n✅ Disparar eventos")
    print("   Endpoint: POST /api/events/{event_type}")
    print("   Uso: Activar automatizaciones basadas en eventos")
    capabilities['write'].append('Disparar eventos personalizados')

    # ══════════════════════════════════════════════════════════════════════
    # NO DISPONIBLE VÍA API REST
    # ══════════════════════════════════════════════════════════════════════

    print("\n" + "─"*70)
    print("  ❌ NO DISPONIBLE VÍA API REST")
    print("─"*70 + "\n")

    not_available = [
        "Crear nuevas automatizaciones",
        "Modificar configuración YAML de automatizaciones",
        "Eliminar automatizaciones",
        "Re-importar blueprints",
        "Actualizar blueprints desde origen",
        "Editar código de blueprints",
        "Gestionar archivos de configuración directamente",
        "Acceso a configuration.yaml",
        "Acceso a automations.yaml"
    ]

    for item in not_available:
        print(f"   ❌ {item}")
        capabilities['not_available'].append(item)

    print("\n   ℹ️  Estas operaciones requieren:")
    print("      • Interfaz web de Home Assistant")
    print("      • Acceso SSH al servidor")
    print("      • File Editor add-on")
    print("      • Studio Code Server add-on")

    # ══════════════════════════════════════════════════════════════════════
    # GESTIÓN DE AUTOMATIZACIONES VÍA API
    # ══════════════════════════════════════════════════════════════════════

    print("\n" + "─"*70)
    print("  🤖 QUÉ PUEDO HACER CON AUTOMATIZACIONES")
    print("─"*70 + "\n")

    automation_capabilities = {
        '✅ VER': [
            'Listar todas las automatizaciones',
            'Ver estado (on/off) de cada automatización',
            'Ver atributos (nombre, ID, última ejecución, etc.)',
            'Ver qué blueprint usa (si aplica)',
            'Ver configuración de inputs del blueprint',
            'Ver cuando fue la última ejecución'
        ],
        '✅ CONTROLAR': [
            'Activar automatización (turn_on)',
            'Desactivar automatización (turn_off)',
            'Ejecutar manualmente (trigger)',
            'Recargar todas las automatizaciones (reload)'
        ],
        '❌ NO PUEDO': [
            'Crear automatización nueva',
            'Modificar configuración existente',
            'Cambiar inputs del blueprint',
            'Eliminar automatización',
            'Ver el código YAML completo',
            'Editar condiciones/acciones'
        ]
    }

    for category, items in automation_capabilities.items():
        print(f"{category}:")
        for item in items:
            print(f"   • {item}")
        print()

    # ══════════════════════════════════════════════════════════════════════
    # RESUMEN
    # ══════════════════════════════════════════════════════════════════════

    print("="*70)
    print("  📊 RESUMEN DE CAPACIDADES")
    print("="*70 + "\n")

    print(f"✅ Lectura: {len(capabilities['read'])} capacidades")
    print(f"✅ Escritura: {len(capabilities['write'])} capacidades")
    print(f"⚠️  Limitadas: {len(capabilities['limited'])} capacidades")
    print(f"❌ No disponibles: {len(capabilities['not_available'])} operaciones")

    print("\n" + "="*70)
    print("  💡 RECOMENDACIÓN")
    print("="*70 + "\n")

    print("Para gestión completa de automatizaciones:")
    print("  1. 📖 LECTURA/MONITOREO → Usar API REST ✅")
    print("  2. 🎮 CONTROL (on/off/trigger) → Usar API REST ✅")
    print("  3. ✏️  EDICIÓN/CREACIÓN → Usar Interfaz Web o SSH ⚠️")

    print("\n" + "="*70 + "\n")

if __name__ == '__main__':
    try:
        test_api_capabilities()
    except KeyboardInterrupt:
        print("\n\n⚠️  Interrumpido por el usuario\n")
        sys.exit(0)

