#!/usr/bin/env python3

"""
LightNode - Test de Fórmula de Proximidad
Verifica que la interpolación sea correcta
"""

import sys

def calcular_brillo(distancia, X=200, Y=20, Z=50):
    """
    Calcula el brillo según la fórmula del LightNode
    
    Args:
        distancia: Distancia en cm
        X: Distancia inicio (default 200cm)
        Y: Brillo inicio (default 20%)
        Z: Distancia máxima (default 50cm)
    
    Returns:
        Brillo en porcentaje (0-100)
    """
    if distancia > X:
        return 0
    elif distancia <= Z:
        return 100
    else:
        rango_distancia = X - Z
        rango_brillo = 100 - Y
        progreso = (X - distancia) / rango_distancia
        return Y + (progreso * rango_brillo)


def mostrar_tabla(X=200, Y=20, Z=50):
    """Muestra tabla de valores esperados"""
    print("═" * 60)
    print(f"  TABLA DE INTERPOLACIÓN")
    print(f"  X (Inicio) = {X}cm, Y (Brillo) = {Y}%, Z (Máxima) = {Z}cm")
    print("═" * 60)
    print(f"{'Distancia':>12} │ {'Progreso':>10} │ {'Brillo':>10}")
    print("─" * 12 + "─┼─" + "─" * 10 + "─┼─" + "─" * 10)
    
    # Generar puntos de prueba
    distancias = [X + 50, X, X - 25, X - 50, X - 75, X - 100, X - 125, Z + 10, Z, Z - 10]
    
    for dist in distancias:
        if dist < 0:
            continue
            
        brillo = calcular_brillo(dist, X, Y, Z)
        
        # Calcular progreso
        if dist > X:
            progreso_str = "Fuera"
        elif dist <= Z:
            progreso_str = "Máximo"
        else:
            progreso = (X - dist) / (X - Z)
            progreso_str = f"{progreso*100:.1f}%"
        
        print(f"{dist:>10.0f}cm │ {progreso_str:>10} │ {brillo:>9.0f}%")
    
    print("═" * 60)


def analizar_problema(logs_ejemplo):
    """Analiza logs de ejemplo y detecta problemas"""
    print("\n🔍 ANÁLISIS DE COMPORTAMIENTO\n")
    
    # Parsear logs
    lineas = logs_ejemplo.strip().split('\n')
    distancias = []
    brillos = []
    
    for linea in lineas:
        if "Distancia:" in linea and "→ Brillo:" in linea:
            partes = linea.split("Distancia:")[1].split("→")
            try:
                dist = float(partes[0].replace("cm", "").strip())
                brillo = int(partes[1].replace("Brillo:", "").replace("%", "").strip())
                distancias.append(dist)
                brillos.append(brillo)
            except:
                continue
    
    if not distancias:
        print("❌ No se encontraron datos válidos en los logs")
        return
    
    # Análisis
    print(f"📊 Datos analizados: {len(distancias)} lecturas\n")
    
    # 1. Varianza de distancia
    if len(distancias) > 1:
        variaciones = [abs(distancias[i] - distancias[i-1]) for i in range(1, len(distancias))]
        variacion_promedio = sum(variaciones) / len(variaciones)
        variacion_maxima = max(variaciones)
        
        print(f"Variación de distancia:")
        print(f"  Promedio: {variacion_promedio:.1f}cm")
        print(f"  Máxima: {variacion_maxima:.1f}cm")
        
        if variacion_promedio > 20:
            print("  ⚠️  PROBLEMA: Sensor muy inestable (variación alta)")
            print("  💡 Solución: Agregar filtros de suavizado")
        elif variacion_promedio > 10:
            print("  ⚠️  Sensor moderadamente inestable")
            print("  💡 Solución: Agregar throttle + delta")
        else:
            print("  ✅ Sensor estable")
    
    # 2. Varianza de brillo
    if len(brillos) > 1:
        variaciones_brillo = [abs(brillos[i] - brillos[i-1]) for i in range(1, len(brillos))]
        variacion_brillo_prom = sum(variaciones_brillo) / len(variaciones_brillo)
        
        print(f"\nVariación de brillo:")
        print(f"  Promedio: {variacion_brillo_prom:.1f}%")
        
        if variacion_brillo_prom > 10:
            print("  ⚠️  PROBLEMA: Brillo cambia mucho entre lecturas")
            print("  💡 Solución: Umbral de cambio mínimo (5-10%)")
        else:
            print("  ✅ Brillo estable")
    
    # 3. Detectar saltos a 0
    ceros = sum(1 for d in distancias if d == 0)
    if ceros > len(distancias) * 0.3:
        print(f"\n⚠️  PROBLEMA: {ceros}/{len(distancias)} lecturas son 0cm (pérdida de detección)")
        print("  💡 Solución: Ajustar LD2410C Max Distance gates")
    
    # 4. Verificar fórmula
    print("\n🧮 Verificación de fórmula:")
    X, Y, Z = 200, 20, 50
    
    for i, dist in enumerate(distancias[:5]):  # Primeras 5 lecturas
        if dist > 0:
            brillo_esperado = calcular_brillo(dist, X, Y, Z)
            brillo_real = brillos[i]
            diferencia = abs(brillo_esperado - brillo_real)
            
            simbolo = "✅" if diferencia < 3 else "⚠️ "
            print(f"  {simbolo} {dist:.0f}cm: esperado {brillo_esperado:.0f}%, real {brillo_real}%")


def main():
    print("════════════════════════════════════════════════════════════")
    print("  LIGHTNODE - TEST DE FÓRMULA DE PROXIMIDAD")
    print("════════════════════════════════════════════════════════════\n")
    
    # Configuración default
    X = 200  # Distancia inicio
    Y = 20   # Brillo inicio
    Z = 50   # Distancia máxima
    
    if len(sys.argv) > 1:
        if sys.argv[1] == "--custom":
            try:
                X = int(sys.argv[2])
                Y = int(sys.argv[3])
                Z = int(sys.argv[4])
                print(f"Usando configuración personalizada: X={X}, Y={Y}, Z={Z}\n")
            except:
                print("Uso: python3 test_proximity_formula.py --custom X Y Z")
                print("Ejemplo: python3 test_proximity_formula.py --custom 180 25 60\n")
                return
    
    # Mostrar tabla
    mostrar_tabla(X, Y, Z)
    
    # Ejemplo de análisis
    print("\n" + "═" * 60)
    print("  EJEMPLO: Pega aquí tus logs para análisis")
    print("═" * 60)
    print("\nFormato esperado:")
    print("  [D] auto: Distancia: 125cm → Brillo: 60%")
    print("  [D] auto: Distancia: 128cm → Brillo: 58%")
    print("  ...\n")
    
    print("Ejecuta para analizar:")
    print("  ./utils/analyze_proximity_logs.sh > logs.txt")
    print("  cat logs.txt | grep 'Distancia:' | head -20\n")


if __name__ == "__main__":
    main()
