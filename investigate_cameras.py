#!/usr/bin/env python3
"""
Script para investigar cámaras y automatizaciones en Home Assistant
"""

import os
import sys
import json
import requests
from typing import Dict, List
from dotenv import load_dotenv
from datetime import datetime

# Cargar variables de entorno
load_dotenv()

class CameraInvestigator:
    def __init__(self, url: str = None, token: str = None):
        self.url = url or os.getenv('HA_URL', 'http://192.168.1.100:8123')
        self.token = token or os.getenv('HA_TOKEN')

        if not self.token:
            print("\n⚠️  HA_TOKEN no encontrado.")
            print("   Crea un archivo .env con:")
            print("   HA_URL=http://192.168.1.100:8123")
            print("   HA_TOKEN=tu_token_aqui")
            sys.exit(1)

        self.headers = {
            'Authorization': f'Bearer {self.token}',
            'Content-Type': 'application/json'
        }

    def get_states(self) -> List[Dict]:
        """Obtener todos los estados"""
        try:
            response = requests.get(f'{self.url}/api/states', headers=self.headers, timeout=10)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            print(f"❌ Error obteniendo estados: {e}")
            return []

    def find_cameras(self, states: List[Dict]) -> List[Dict]:
        """Buscar todas las entidades de cámaras"""
        cameras = []
        for state in states:
            entity_id = state.get('entity_id', '')
            if entity_id.startswith('camera.'):
                cameras.append(state)
        return cameras

    def find_xiaomi_entities(self, states: List[Dict]) -> List[Dict]:
        """Buscar todas las entidades de Xiaomi"""
        xiaomi = []
        for state in states:
            entity_id = state.get('entity_id', '')
            friendly_name = state.get('attributes', {}).get('friendly_name', '').lower()

            if 'xiaomi' in entity_id.lower() or 'xiaomi' in friendly_name:
                xiaomi.append(state)
            elif 'chuangmi' in entity_id.lower() or 'chuangmi' in friendly_name:
                xiaomi.append(state)
        return xiaomi

    def find_frigate_entities(self, states: List[Dict]) -> List[Dict]:
        """Buscar entidades de Frigate"""
        frigate = []
        for state in states:
            entity_id = state.get('entity_id', '')
            if 'frigate' in entity_id.lower():
                frigate.append(state)
        return frigate

    def find_tapo_entities(self, states: List[Dict]) -> List[Dict]:
        """Buscar entidades de Tapo"""
        tapo = []
        for state in states:
            entity_id = state.get('entity_id', '')
            friendly_name = state.get('attributes', {}).get('friendly_name', '').lower()

            if 'tapo' in entity_id.lower() or 'tapo' in friendly_name:
                tapo.append(state)
        return tapo

    def get_automations(self, states: List[Dict]) -> List[Dict]:
        """Obtener todas las automatizaciones"""
        automations = []
        for state in states:
            entity_id = state.get('entity_id', '')
            if entity_id.startswith('automation.'):
                automations.append(state)
        return automations

    def print_entity_details(self, entity: Dict, indent: str = "  "):
        """Imprimir detalles de una entidad"""
        entity_id = entity.get('entity_id', 'unknown')
        state = entity.get('state', 'unknown')
        attributes = entity.get('attributes', {})
        friendly_name = attributes.get('friendly_name', entity_id)
        last_changed = entity.get('last_changed', 'unknown')

        print(f"{indent}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print(f"{indent}🔹 {friendly_name}")
        print(f"{indent}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print(f"{indent}  Entity ID: {entity_id}")
        print(f"{indent}  Estado: {state}")
        print(f"{indent}  Última actualización: {last_changed}")

        # Atributos importantes
        important_attrs = [
            'device_class', 'supported_features', 'model', 'model_name',
            'manufacturer', 'sw_version', 'hw_version', 'ip_address',
            'stream_source', 'entity_picture', 'access_token',
            'friendly_name', 'device_id'
        ]

        print(f"{indent}  Atributos:")
        for key, value in attributes.items():
            if key in important_attrs or len(str(value)) < 100:
                print(f"{indent}    • {key}: {value}")

        print()

    def investigate(self):
        """Realizar investigación completa"""
        print("\n" + "="*80)
        print("  🔍 INVESTIGACIÓN DE CÁMARAS Y AUTOMATIZACIONES")
        print("="*80 + "\n")

        print("📡 Conectando a Home Assistant...")
        states = self.get_states()

        if not states:
            print("❌ No se pudieron obtener estados")
            return

        print(f"✅ Conectado. Total de entidades: {len(states)}\n")

        # ========== CÁMARAS ==========
        print("=" * 80)
        print("📹 CÁMARAS ENCONTRADAS")
        print("=" * 80)
        cameras = self.find_cameras(states)
        print(f"\nTotal de cámaras: {len(cameras)}\n")

        if cameras:
            for camera in cameras:
                self.print_entity_details(camera)
        else:
            print("  ⚠️  No se encontraron entidades de cámara\n")

        # ========== XIAOMI ==========
        print("=" * 80)
        print("🏠 ENTIDADES XIAOMI/CHUANGMI")
        print("=" * 80)
        xiaomi = self.find_xiaomi_entities(states)
        print(f"\nTotal de entidades Xiaomi: {len(xiaomi)}\n")

        if xiaomi:
            for entity in xiaomi:
                self.print_entity_details(entity)
        else:
            print("  ⚠️  No se encontraron entidades Xiaomi\n")

        # ========== TAPO ==========
        print("=" * 80)
        print("📷 ENTIDADES TAPO")
        print("=" * 80)
        tapo = self.find_tapo_entities(states)
        print(f"\nTotal de entidades Tapo: {len(tapo)}\n")

        if tapo:
            # Agrupar por tipo
            tapo_by_type = {}
            for entity in tapo:
                entity_type = entity['entity_id'].split('.')[0]
                if entity_type not in tapo_by_type:
                    tapo_by_type[entity_type] = []
                tapo_by_type[entity_type].append(entity)

            for entity_type, entities in sorted(tapo_by_type.items()):
                print(f"\n  📌 {entity_type.upper()} ({len(entities)} entidades):")
                for entity in entities:
                    entity_id = entity['entity_id']
                    state = entity['state']
                    name = entity.get('attributes', {}).get('friendly_name', entity_id)
                    print(f"    • {name}")
                    print(f"      ID: {entity_id}")
                    print(f"      Estado: {state}")
        else:
            print("  ⚠️  No se encontraron entidades Tapo\n")

        # ========== FRIGATE ==========
        print("\n" + "=" * 80)
        print("🤖 ENTIDADES FRIGATE")
        print("=" * 80)
        frigate = self.find_frigate_entities(states)
        print(f"\nTotal de entidades Frigate: {len(frigate)}\n")

        if frigate:
            # Agrupar por tipo
            frigate_by_type = {}
            for entity in frigate:
                entity_type = entity['entity_id'].split('.')[0]
                if entity_type not in frigate_by_type:
                    frigate_by_type[entity_type] = []
                frigate_by_type[entity_type].append(entity)

            for entity_type, entities in sorted(frigate_by_type.items()):
                print(f"\n  📌 {entity_type.upper()} ({len(entities)} entidades):")
                for entity in entities[:5]:  # Solo mostrar primeros 5
                    entity_id = entity['entity_id']
                    state = entity['state']
                    name = entity.get('attributes', {}).get('friendly_name', entity_id)
                    print(f"    • {name}: {state}")
                if len(entities) > 5:
                    print(f"    ... y {len(entities) - 5} más")
        else:
            print("  ⚠️  No se encontraron entidades Frigate")
            print("  ℹ️  Esto significa que Frigate no está integrado aún\n")

        # ========== AUTOMATIZACIONES ==========
        print("\n" + "=" * 80)
        print("🤖 AUTOMATIZACIONES ACTIVAS")
        print("=" * 80)
        automations = self.get_automations(states)
        print(f"\nTotal de automatizaciones: {len(automations)}\n")

        if automations:
            # Filtrar las relacionadas con cámaras
            camera_automations = []
            for auto in automations:
                entity_id = auto['entity_id']
                friendly_name = auto.get('attributes', {}).get('friendly_name', '').lower()

                if any(word in friendly_name or word in entity_id.lower()
                      for word in ['camera', 'cámara', 'frigate', 'motion', 'person', 'detection']):
                    camera_automations.append(auto)

            print(f"  Automatizaciones relacionadas con cámaras: {len(camera_automations)}\n")

            for auto in automations:
                entity_id = auto['entity_id']
                state = auto['state']
                friendly_name = auto.get('attributes', {}).get('friendly_name', entity_id)
                last_triggered = auto.get('attributes', {}).get('last_triggered', 'Nunca')

                icon = "✅" if state == "on" else "❌"
                print(f"  {icon} {friendly_name}")
                print(f"     ID: {entity_id}")
                print(f"     Estado: {state}")
                print(f"     Último trigger: {last_triggered}")
                print()

        # ========== RESUMEN ==========
        print("\n" + "=" * 80)
        print("📊 RESUMEN Y RECOMENDACIONES")
        print("=" * 80 + "\n")

        # Análisis de la cámara Xiaomi
        xiaomi_camera = None
        for entity in xiaomi:
            if 'camera' in entity['entity_id'] or 'status' in entity['entity_id']:
                xiaomi_camera = entity
                break

        if xiaomi_camera:
            print("🔍 CÁMARA XIAOMI DETECTADA:")
            print(f"  • Entity: {xiaomi_camera['entity_id']}")
            print(f"  • Estado: {xiaomi_camera['state']}")
            print(f"  • Integración: xiaomi_home (custom component)")
            print()
            print("⚠️  PROBLEMA IDENTIFICADO:")
            print("  La integración xiaomi_home NO genera binary sensors de detección.")
            print("  Los sensores 'status' solo indican si está grabando, pero no hay")
            print("  detección inteligente de personas/objetos.")
            print()

        if not frigate:
            print("💡 RECOMENDACIÓN:")
            print("  ✅ Instalar Frigate para detección inteligente con IA")
            print("  ✅ Frigate puede integrar la cámara Xiaomi si expone RTSP")
            print()
            print("  PASOS:")
            print("  1. Verificar si la cámara Xiaomi expone stream RTSP")
            print("  2. Instalar Frigate en Docker")
            print("  3. Configurar la cámara en Frigate")
            print("  4. Integrar Frigate con Home Assistant")
            print()
        else:
            print("✅ FRIGATE YA ESTÁ INTEGRADO")
            print()
            print("  Para agregar la cámara Xiaomi a Frigate:")
            print("  1. Obtener URL RTSP de la cámara")
            print("  2. Agregar configuración en frigate/config/config.yml")
            print("  3. Reiniciar Frigate")
            print()

        if not tapo:
            print("⚠️  NO SE DETECTARON CÁMARAS TAPO")
            print("  Las automatizaciones Frigate están configuradas para cámaras Tapo")
            print("  pero no se encontraron entidades Tapo en HA.")
            print()

        print("=" * 80 + "\n")

        # Guardar reporte
        self.save_report({
            'cameras': cameras,
            'xiaomi': xiaomi,
            'tapo': tapo,
            'frigate': frigate,
            'automations': automations,
            'timestamp': datetime.now().isoformat()
        })

    def save_report(self, data: Dict):
        """Guardar reporte en archivo JSON"""
        try:
            with open('camera_investigation_report.json', 'w') as f:
                json.dump(data, f, indent=2, default=str)
            print("💾 Reporte guardado en: camera_investigation_report.json\n")
        except Exception as e:
            print(f"⚠️  No se pudo guardar el reporte: {e}\n")


if __name__ == '__main__':
    investigator = CameraInvestigator()
    investigator.investigate()

