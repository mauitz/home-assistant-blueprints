#!/usr/bin/env python3
"""
Script para verificar que el blueprint v1.3 esté correctamente instalado y funcionando
"""

import sys
from ha_manager import HAManager

def main():
    print("\n" + "="*70)
    print("  🔍 VERIFICACIÓN DE INSTALACIÓN v1.3")
    print("="*70 + "\n")
    
    # Inicializar manager
    try:
        manager = HAManager()
    except ValueError as e:
        print(f"\n❌ Error: {e}\n")
        print("Configura el acceso API primero:")
        print("  ./setup.sh\n")
        sys.exit(1)
    
    # Test conexión
    if not manager.test_connection():
        print("\n❌ No se puede conectar a Home Assistant\n")
        sys.exit(1)
    
    print("\n" + "-"*70)
    print("  📊 ESTADO DE HELPERS")
    print("-"*70 + "\n")
    
    status = manager.get_presence_simulation_status()
    
    required_helpers = {
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
    
    all_exist = True
    for key, entity_id in required_helpers.items():
        state = status.get(key, {}).get('state')
        if state in ['unknown', 'unavailable', None]:
            print(f"  ❌ {entity_id} - NO EXISTE")
            all_exist = False
        else:
            print(f"  ✅ {entity_id} - {state}")
    
    if not all_exist:
        print("\n⚠️  FALTAN HELPERS")
        print("   Ver: examples/presence_simulation_helpers.yaml")
        print("   Agrégalos a configuration.yaml y recarga HA\n")
    else:
        print("\n✅ Todos los helpers existen\n")
    
    print("-"*70)
    print("  💡 ESTADO DE SWITCHES")
    print("-"*70 + "\n")
    
    switches = manager.get_switches_status()
    on_count = 0
    for switch, data in switches.items():
        state = data.get('state', 'unknown')
        name = data.get('friendly_name', switch)
        icon = "🟢" if state == "on" else "⚫"
        print(f"  {icon} {name}: {state}")
        if state == "on":
            on_count += 1
    
    print(f"\n  Total encendidos: {on_count}")
    
    # Verificar consistencia
    helper_count = status.get('lights_on_count', {}).get('state', '0')
    
    print("\n" + "-"*70)
    print("  🔍 VERIFICACIÓN DE CONSISTENCIA")
    print("-"*70 + "\n")
    
    try:
        helper_count_int = int(helper_count)
    except:
        helper_count_int = 0
    
    print(f"  Switches realmente encendidos: {on_count}")
    print(f"  Contador en helper:            {helper_count_int}")
    
    if on_count == helper_count_int:
        print("\n  ✅ CONSISTENTE - El monitoreo está funcionando correctamente")
        
        if on_count > 0:
            active_lights = status.get('active_lights', {}).get('state', 'Ninguna')
            print(f"\n  Luces activas según helper:")
            print(f"    {active_lights}")
    else:
        print("\n  ⚠️  INCONSISTENTE - Posibles causas:")
        if helper_count_int == 0 and on_count > 0:
            print("    • El blueprint v1.3 NO está instalado")
            print("    • O enable_monitoring está en false")
            print("    • O la simulación no está ejecutándose actualmente")
        else:
            print("    • Los helpers no se están actualizando correctamente")
    
    print("\n" + "-"*70)
    print("  🤖 AUTOMATIZACIONES")
    print("-"*70 + "\n")
    
    automations = manager.find_presence_automations()
    
    if automations:
        for auto in automations:
            state = auto.get('state', 'unknown')
            name = auto.get('attributes', {}).get('friendly_name', auto['entity_id'])
            icon = "✅" if state == "on" else "❌"
            print(f"  {icon} {name}")
            
            # Check if using v1.3
            attributes = auto.get('attributes', {})
            blueprint = attributes.get('blueprint', {}).get('path', '')
            if 'v1.3' in blueprint or 'pezaustral_presence_simulation_v1.3' in blueprint:
                print(f"      ✅ Usando blueprint v1.3")
            elif 'pezaustral_presence_simulation' in blueprint:
                print(f"      ⚠️  Usando blueprint antiguo: {blueprint}")
                print(f"      → Actualiza a v1.3")
    else:
        print("  ⚠️  No se encontraron automatizaciones de presencia")
    
    print("\n" + "-"*70)
    print("  📝 RECOMENDACIONES")
    print("-"*70 + "\n")
    
    running = status.get('running', {}).get('state') == 'on'
    
    if not running and on_count == 0:
        print("  ℹ️  La simulación no está ejecutándose actualmente")
        print("     Esto es normal si no la has iniciado")
        print("\n  Para probar:")
        print("     1. Activa input_boolean.presence_simulation")
        print("     2. Espera unos segundos")
        print("     3. Ejecuta de nuevo: python3 verify_installation.py")
        print("     4. Verifica que el contador se actualice")
    elif running and on_count > 0 and helper_count_int == 0:
        print("  ⚠️  LA SIMULACIÓN ESTÁ CORRIENDO PERO EL CONTADOR NO SE ACTUALIZA")
        print("\n  Acciones requeridas:")
        print("     1. Detén la simulación")
        print("     2. Verifica que el blueprint v1.3 esté instalado")
        print("     3. Verifica que enable_monitoring: true")
        print("     4. Vuelve a iniciar la simulación")
    elif running and on_count > 0 and helper_count_int > 0:
        print("  ✅ TODO FUNCIONA CORRECTAMENTE")
        print("\n  El blueprint v1.3 está:")
        print("     • Encendiendo/apagando luces ✓")
        print("     • Actualizando contadores en tiempo real ✓")
        print("     • Sincronizado con el dashboard ✓")
    
    print("\n" + "="*70 + "\n")

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Interrumpido por el usuario\n")
        sys.exit(0)

