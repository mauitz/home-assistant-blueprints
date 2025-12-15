#!/usr/bin/env python3
"""
Script para analizar el estado completo de Home Assistant
"""

import os
import sys
import json
import requests
from pathlib import Path
from collections import defaultdict
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

HA_URL = os.getenv('HA_URL', 'http://192.168.1.100:8123')
HA_TOKEN = os.getenv('HA_TOKEN')

if not HA_TOKEN:
    print("❌ Error: HA_TOKEN no encontrado en .env")
    sys.exit(1)

headers = {
    'Authorization': f'Bearer {HA_TOKEN}',
    'Content-Type': 'application/json'
}

def get_api(endpoint):
    """Llama a la API de HA"""
    try:
        response = requests.get(f'{HA_URL}/api/{endpoint}', headers=headers, timeout=10)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"❌ Error en {endpoint}: {e}")
        return None

def analyze_entities():
    """Analiza todas las entidades"""
    states = get_api('states')
    if not states:
        return {}

    analysis = defaultdict(list)
    for entity in states:
        domain = entity['entity_id'].split('.')[0]
        analysis[domain].append({
            'entity_id': entity['entity_id'],
            'name': entity.get('attributes', {}).get('friendly_name', entity['entity_id']),
            'state': entity.get('state'),
        })

    return dict(analysis)

def analyze_automations():
    """Analiza automatizaciones"""
    states = get_api('states')
    if not states:
        return []

    automations = [s for s in states if s['entity_id'].startswith('automation.')]

    result = []
    for auto in automations:
        result.append({
            'entity_id': auto['entity_id'],
            'name': auto.get('attributes', {}).get('friendly_name', auto['entity_id']),
            'state': auto['state'],
            'last_triggered': auto.get('attributes', {}).get('last_triggered'),
        })

    return result

def analyze_scripts():
    """Analiza scripts"""
    states = get_api('states')
    if not states:
        return []

    scripts = [s for s in states if s['entity_id'].startswith('script.')]

    result = []
    for script in scripts:
        result.append({
            'entity_id': script['entity_id'],
            'name': script.get('attributes', {}).get('friendly_name', script['entity_id']),
        })

    return result

def analyze_integrations():
    """Analiza integraciones desde las entidades"""
    states = get_api('states')
    if not states:
        return {}

    integrations = defaultdict(int)
    for entity in states:
        domain = entity['entity_id'].split('.')[0]
        integrations[domain] += 1

    return dict(integrations)

def get_config():
    """Obtiene la configuración básica"""
    config = get_api('config')
    if not config:
        return {}

    return {
        'version': config.get('version'),
        'location_name': config.get('location_name'),
        'latitude': config.get('latitude'),
        'longitude': config.get('longitude'),
        'time_zone': config.get('time_zone'),
        'unit_system': config.get('unit_system'),
        'components': config.get('components', [])[:50],  # Solo primeras 50
    }

def main():
    print("🔍 Analizando Home Assistant en pezaustral...\n")

    # Obtener información
    print("📊 Obteniendo configuración...")
    config = get_config()

    print("📊 Analizando entidades...")
    entities = analyze_entities()

    print("📊 Analizando automatizaciones...")
    automations = analyze_automations()

    print("📊 Analizando scripts...")
    scripts = analyze_scripts()

    print("📊 Analizando integraciones...")
    integrations = analyze_integrations()

    # Crear reporte JSON
    report = {
        'config': config,
        'entities': entities,
        'automations': automations,
        'scripts': scripts,
        'integrations': integrations,
        'summary': {
            'total_entities': sum(len(entities[d]) for d in entities),
            'total_automations': len(automations),
            'total_scripts': len(scripts),
            'domains_count': len(entities),
        }
    }

    # Guardar reporte
    output_file = Path(__file__).parent.parent / 'HA_config_proxy' / 'ha_analysis.json'
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2, ensure_ascii=False)

    print(f"\n✅ Análisis completado")
    print(f"📄 Reporte guardado en: {output_file}")

    # Mostrar resumen
    print("\n" + "="*70)
    print("📊 RESUMEN")
    print("="*70)
    print(f"  Versión HA: {config.get('version', 'N/A')}")
    print(f"  Ubicación: {config.get('location_name', 'N/A')}")
    print(f"  Zona Horaria: {config.get('time_zone', 'N/A')}")
    print(f"\n  Total Entidades: {report['summary']['total_entities']}")
    print(f"  Total Automatizaciones: {report['summary']['total_automations']}")
    print(f"  Total Scripts: {report['summary']['total_scripts']}")
    print(f"  Dominios únicos: {report['summary']['domains_count']}")

    print("\n  Dominios principales:")
    sorted_domains = sorted(entities.items(), key=lambda x: len(x[1]), reverse=True)[:10]
    for domain, ents in sorted_domains:
        print(f"    - {domain}: {len(ents)}")

    print("\n" + "="*70)

if __name__ == '__main__':
    main()
