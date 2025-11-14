#!/usr/bin/env python3
"""
Script para obtener información de la cámara Xiaomi y verificar RTSP
"""

import os
import sys
import json
import requests
from dotenv import load_dotenv

load_dotenv()

class XiaomiCameraInfo:
    def __init__(self):
        self.url = os.getenv('HA_URL', 'http://192.168.1.100:8123')
        self.token = os.getenv('HA_TOKEN')

        if not self.token:
            print("\n⚠️  Necesitas configurar HA_TOKEN")
            print("   Crea un archivo .env con:")
            print("   HA_URL=http://192.168.1.100:8123")
            print("   HA_TOKEN=tu_token_aqui")
            sys.exit(1)

        self.headers = {
            'Authorization': f'Bearer {self.token}',
            'Content-Type': 'application/json'
        }

    def get_entity_state(self, entity_id: str) -> dict:
        """Obtener estado de una entidad"""
        try:
            response = requests.get(
                f'{self.url}/api/states/{entity_id}',
                headers=self.headers,
                timeout=5
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            return None

    def get_all_states(self) -> list:
        """Obtener todos los estados"""
        try:
            response = requests.get(
                f'{self.url}/api/states',
                headers=self.headers,
                timeout=10
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            print(f"❌ Error: {e}")
            return []

    def find_xiaomi_camera(self):
        """Buscar y mostrar información de la cámara Xiaomi"""
        print("\n" + "="*80)
        print("  🔍 INFORMACIÓN DE CÁMARA XIAOMI")
        print("="*80 + "\n")

        # Buscar device_tracker de la cámara
        print("📡 Buscando cámara Xiaomi...")
        tracker_state = self.get_entity_state('device_tracker.chuangmi_camera_029a02')

        if tracker_state:
            print("✅ Cámara encontrada!\n")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("📌 INFORMACIÓN BÁSICA")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print(f"  Entity ID: {tracker_state['entity_id']}")
            print(f"  Nombre: {tracker_state.get('attributes', {}).get('friendly_name', 'N/A')}")
            print(f"  Estado: {tracker_state['state']}")
            print(f"  Última actualización: {tracker_state.get('last_changed', 'N/A')}")

            # Atributos
            attrs = tracker_state.get('attributes', {})
            print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("📋 ATRIBUTOS")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

            # Buscar IP
            ip_attrs = ['ip', 'ip_address', 'local_ip', 'host']
            ip_found = None
            for attr in ip_attrs:
                if attr in attrs:
                    ip_found = attrs[attr]
                    print(f"  🌐 IP Address: {ip_found}")
                    break

            if not ip_found:
                print("  ⚠️  IP Address: No encontrada en atributos")

            # Otros atributos importantes
            important_attrs = [
                'mac', 'model', 'model_name', 'manufacturer',
                'sw_version', 'hw_version', 'device_id'
            ]

            for attr in important_attrs:
                if attr in attrs:
                    print(f"  • {attr}: {attrs[attr]}")

            # Todos los atributos
            print("\n  Todos los atributos:")
            for key, value in attrs.items():
                if key not in important_attrs and key not in ip_attrs:
                    if len(str(value)) < 100:
                        print(f"    - {key}: {value}")

        else:
            print("❌ No se encontró el device_tracker de la cámara")

        # Buscar sensor de estado
        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📊 SENSOR DE ESTADO")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        sensor_state = self.get_entity_state('sensor.chuangmi_us_447604776_029a02_status_p_4_1')
        if sensor_state:
            print(f"  Estado actual: {sensor_state['state']}")
            print(f"  Estados posibles: {sensor_state.get('attributes', {}).get('options', [])}")
            print(f"  Última actualización: {sensor_state.get('last_changed', 'N/A')}")

        # Buscar todas las entidades Xiaomi
        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("🔍 TODAS LAS ENTIDADES XIAOMI/CHUANGMI")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

        states = self.get_all_states()
        xiaomi_entities = []

        for state in states:
            entity_id = state['entity_id']
            if 'xiaomi' in entity_id.lower() or 'chuangmi' in entity_id.lower():
                xiaomi_entities.append(state)

        for entity in xiaomi_entities:
            entity_id = entity['entity_id']
            state_val = entity['state']
            friendly_name = entity.get('attributes', {}).get('friendly_name', entity_id)

            print(f"  • {friendly_name}")
            print(f"    ID: {entity_id}")
            print(f"    Estado: {state_val}")

            # Buscar atributos de IP en cada entidad
            attrs = entity.get('attributes', {})
            for attr_name in ['ip', 'ip_address', 'local_ip', 'host', 'host_name']:
                if attr_name in attrs:
                    print(f"    🌐 {attr_name}: {attrs[attr_name]}")

            print()

        # Guía para probar RTSP
        print("\n" + "="*80)
        print("  🎯 PRÓXIMOS PASOS - VERIFICAR RTSP")
        print("="*80 + "\n")

        if ip_found:
            print(f"✅ IP de la cámara encontrada: {ip_found}\n")
            print("📝 Probar acceso RTSP con estos comandos:\n")

            # Comandos comunes para cámaras Xiaomi
            rtsp_urls = [
                f"rtsp://admin:admin@{ip_found}:554/live/ch0",
                f"rtsp://admin:admin@{ip_found}:554/stream1",
                f"rtsp://admin:admin@{ip_found}:8554/live",
                f"rtsp://root:@{ip_found}:554/live/ch0",
            ]

            print("  Opción 1 - Desde tu Mac:")
            print("  " + "-"*60)
            for i, url in enumerate(rtsp_urls, 1):
                print(f"  {i}. ffmpeg -i '{url}' -frames:v 1 test_{i}.jpg")

            print("\n  Opción 2 - Abrir en VLC:")
            print("  " + "-"*60)
            print("  1. Abrir VLC")
            print("  2. Archivo → Abrir Red")
            print("  3. Probar cada URL:")
            for url in rtsp_urls:
                print(f"     • {url}")

            print("\n  Opción 3 - Desde el servidor (SSH):")
            print("  " + "-"*60)
            print("  ssh nico@192.168.1.100")
            for i, url in enumerate(rtsp_urls, 1):
                print(f"  ffmpeg -i '{url}' -frames:v 1 test_{i}.jpg")

            print("\n  📌 Credenciales comunes para Xiaomi:")
            print("     • admin / admin")
            print("     • root / (sin password)")
            print("     • admin / (sin password)")
            print("     • O las credenciales de tu cuenta Xiaomi")

        else:
            print("⚠️  No se encontró IP de la cámara")
            print("\n📝 Pasos alternativos:")
            print("  1. Buscar IP en la app Xiaomi Home")
            print("  2. Buscar IP en tu router (dispositivo Chuangmi)")
            print("  3. Usar herramienta de escaneo de red (Angry IP Scanner)")

        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📚 INFORMACIÓN SOBRE CÁMARAS XIAOMI Y RTSP")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

        print("⚠️  IMPORTANTE:")
        print("  • Algunas cámaras Xiaomi NO tienen RTSP habilitado por defecto")
        print("  • Modelos nuevos pueden tener RTSP bloqueado")
        print("  • Es posible que necesites firmware custom (hack) para RTSP")
        print()
        print("✅ ALTERNATIVAS SI NO TIENE RTSP:")
        print("  1. Instalar firmware custom (Xiaomi Dafang Hacks)")
        print("  2. Usar integración xiaomi_miio con snapshots periódicos")
        print("  3. Considerar reemplazar por cámara compatible (Tapo es buena opción)")
        print()
        print("🔗 RECURSOS:")
        print("  • Xiaomi Camera Hacks: https://github.com/EliasKotlyar/Xiaomi-Dafang-Hacks")
        print("  • Lista de cámaras compatibles con Frigate:")
        print("    https://docs.frigate.video/frigate/camera_setup")
        print()

        print("="*80 + "\n")


if __name__ == '__main__':
    info = XiaomiCameraInfo()
    info.find_xiaomi_camera()

