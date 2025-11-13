#!/usr/bin/env python3
"""
Home Assistant Manager - Herramienta para gestionar la simulación de presencia
"""

import os
import sys
import json
import requests
from typing import Dict, List, Optional
from pathlib import Path

class HAManager:
    def __init__(self, url: str = None, token: str = None):
        """
        Initialize HA Manager
        
        Args:
            url: Home Assistant URL (default: from env or http://192.168.1.100:8123)
            token: Long-lived access token (default: from env)
        """
        self.url = url or os.getenv('HA_URL', 'http://192.168.1.100:8123')
        self.token = token or os.getenv('HA_TOKEN')
        
        if not self.token:
            raise ValueError(
                "HA_TOKEN not found. Create .env file or set environment variable.\n"
                "See .env.example for instructions."
            )
        
        self.headers = {
            'Authorization': f'Bearer {self.token}',
            'Content-Type': 'application/json'
        }
    
    def test_connection(self) -> bool:
        """Test connection to Home Assistant"""
        try:
            response = requests.get(f'{self.url}/api/', headers=self.headers, timeout=5)
            if response.status_code == 200:
                print("✅ Connected to Home Assistant")
                print(f"   URL: {self.url}")
                data = response.json()
                print(f"   Message: {data.get('message', 'OK')}")
                return True
            else:
                print(f"❌ Connection failed: HTTP {response.status_code}")
                return False
        except requests.exceptions.RequestException as e:
            print(f"❌ Connection error: {e}")
            return False
    
    def get_states(self, entity_id: str = None) -> Dict:
        """Get state of entity or all entities"""
        try:
            if entity_id:
                url = f'{self.url}/api/states/{entity_id}'
            else:
                url = f'{self.url}/api/states'
            
            response = requests.get(url, headers=self.headers, timeout=5)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"❌ Error getting states: {e}")
            return {}
    
    def get_automations(self) -> List[Dict]:
        """Get all automations"""
        try:
            # Get all entities
            states = self.get_states()
            
            # Filter automations
            automations = [
                state for state in states 
                if state['entity_id'].startswith('automation.')
            ]
            
            return automations
        except Exception as e:
            print(f"❌ Error getting automations: {e}")
            return []
    
    def get_presence_simulation_status(self) -> Dict:
        """Get current status of presence simulation"""
        entities = {
            'control': 'input_boolean.presence_simulation',
            'running': 'input_boolean.presence_simulation_running',
            'loop_counter': 'input_number.presence_simulation_loop_counter',
            'loop_total': 'input_number.presence_simulation_loop_total',
            'lights_on_count': 'input_number.presence_simulation_lights_on_count',
            'start_time': 'input_datetime.presence_simulation_start_time',
            'status': 'input_text.presence_simulation_status',
            'active_lights': 'input_text.presence_simulation_active_lights',
            'last_light_on': 'input_text.presence_simulation_last_light_on',
            'last_light_off': 'input_text.presence_simulation_last_light_off',
        }
        
        status = {}
        for key, entity_id in entities.items():
            state = self.get_states(entity_id)
            if state:
                status[key] = {
                    'state': state.get('state'),
                    'friendly_name': state.get('attributes', {}).get('friendly_name'),
                    'last_changed': state.get('last_changed')
                }
            else:
                status[key] = {'state': 'unknown', 'error': 'Entity not found'}
        
        return status
    
    def get_switches_status(self) -> Dict:
        """Get status of all presence simulation switches"""
        switches = [
            'switch.3gang_switch_switch_1',
            'switch.4gang_switch_2_switch_1',
            'switch.sonoff_10025ffc47_1',
            'switch.4gang_switch_switch_1',
            'switch.3gang_switch_switch_2',
            'switch.bedroom_3_switch_switch_1'
        ]
        
        status = {}
        for switch in switches:
            state = self.get_states(switch)
            if state:
                status[switch] = {
                    'state': state.get('state'),
                    'friendly_name': state.get('attributes', {}).get('friendly_name'),
                    'last_changed': state.get('last_changed')
                }
        
        return status
    
    def find_presence_automations(self) -> List[Dict]:
        """Find all automations related to presence simulation"""
        automations = self.get_automations()
        
        presence_automations = [
            auto for auto in automations
            if 'presence' in auto['entity_id'].lower() or
               'presence' in auto.get('attributes', {}).get('friendly_name', '').lower()
        ]
        
        return presence_automations
    
    def print_status_report(self):
        """Print a comprehensive status report"""
        print("\n" + "="*70)
        print("  📊 REPORTE DE ESTADO - SIMULACIÓN DE PRESENCIA")
        print("="*70 + "\n")
        
        # Test connection
        if not self.test_connection():
            return
        
        print("\n" + "-"*70)
        print("  🎛️  HELPERS DE MONITOREO")
        print("-"*70)
        
        status = self.get_presence_simulation_status()
        for key, data in status.items():
            state = data.get('state', 'unknown')
            name = data.get('friendly_name', key)
            print(f"  {name}: {state}")
        
        print("\n" + "-"*70)
        print("  💡 ESTADO DE SWITCHES")
        print("-"*70)
        
        switches = self.get_switches_status()
        on_count = 0
        for switch, data in switches.items():
            state = data.get('state', 'unknown')
            name = data.get('friendly_name', switch)
            icon = "🟢" if state == "on" else "⚫"
            print(f"  {icon} {name}: {state}")
            if state == "on":
                on_count += 1
        
        print(f"\n  Total encendidos: {on_count}")
        
        print("\n" + "-"*70)
        print("  🤖 AUTOMATIZACIONES RELACIONADAS")
        print("-"*70)
        
        automations = self.find_presence_automations()
        if automations:
            for auto in automations:
                state = auto.get('state', 'unknown')
                name = auto.get('attributes', {}).get('friendly_name', auto['entity_id'])
                icon = "✅" if state == "on" else "❌"
                print(f"  {icon} {name} ({state})")
        else:
            print("  ⚠️  No se encontraron automatizaciones de presencia")
        
        print("\n" + "="*70 + "\n")
    
    def diagnose_monitoring_issue(self):
        """Diagnose why monitoring isn't working"""
        print("\n" + "="*70)
        print("  🔍 DIAGNÓSTICO DEL SISTEMA DE MONITOREO")
        print("="*70 + "\n")
        
        # Check if simulation is running
        status = self.get_presence_simulation_status()
        running = status.get('running', {}).get('state') == 'on'
        
        print(f"  Simulación activa: {'✅ SÍ' if running else '❌ NO'}")
        
        # Check switches
        switches = self.get_switches_status()
        on_switches = [s for s, d in switches.items() if d.get('state') == 'on']
        print(f"  Switches encendidos: {len(on_switches)}")
        
        # Check counter
        lights_on_count = status.get('lights_on_count', {}).get('state', '0')
        print(f"  Contador (helper): {lights_on_count}")
        
        # Diagnosis
        print("\n" + "-"*70)
        print("  📋 DIAGNÓSTICO")
        print("-"*70)
        
        if len(on_switches) > 0 and lights_on_count == '0':
            print("  ⚠️  PROBLEMA DETECTADO:")
            print("     Hay switches encendidos pero el contador está en 0")
            print("     CAUSA: Faltan automatizaciones de monitoreo")
            print("\n  💡 SOLUCIÓN:")
            print("     Opción 1: Instalar automatizaciones de monitoreo externas")
            print("     Opción 2: Actualizar blueprint con monitoreo integrado")
        elif len(on_switches) == 0:
            print("  ℹ️  No hay switches encendidos actualmente")
            print("     Esto es normal si la simulación no está activa")
        else:
            print("  ✅ Todo funciona correctamente")
        
        print("\n" + "="*70 + "\n")


def main():
    """Main CLI interface"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Home Assistant Manager')
    parser.add_argument('command', choices=['test', 'status', 'diagnose'], 
                       help='Command to execute')
    parser.add_argument('--url', help='Home Assistant URL')
    parser.add_argument('--token', help='Access token')
    
    args = parser.parse_args()
    
    try:
        manager = HAManager(url=args.url, token=args.token)
        
        if args.command == 'test':
            manager.test_connection()
        elif args.command == 'status':
            manager.print_status_report()
        elif args.command == 'diagnose':
            manager.diagnose_monitoring_issue()
    
    except ValueError as e:
        print(f"\n❌ Error: {e}\n")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\n\n⚠️  Interrupted by user\n")
        sys.exit(0)


if __name__ == '__main__':
    main()

