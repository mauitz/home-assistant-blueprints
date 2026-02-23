# LightNode - Configuración y Operación

**Versión actual**: v2.2 | **Dispositivo**: lightnode-entrance @ 192.168.1.15

---

## Configuración recomendada

```
MODOS:
  1. Control Automático     → ON   (modo proximidad activo)
  2. Solo de Noche          → ON   (OFF si quieres 24/7)

MANUAL (solo si Control Automático = OFF):
  3. Luz Derecha            → OFF
  4. Dimmer Derecha         → 100%
  5. Luz Izquierda          → OFF
  6. Dimmer Izquierda       → 100%

PARÁMETROS:
  7. Timeout Apagado        → 30s
  8. Umbral Luz             → 30%
  9. Distancia Inicio (X)   → 100cm
  A. Brillo Inicio (Y)      → 10%
  B. Distancia Máxima (Z)   → 0cm

SENSOR LD2410C (crítico):
  Límite Distancia Estático   → 8  ← sin esto solo detecta 30-40cm
  Límite Distancia Movimiento → 8
  Tiempo Espera Sensor        → 5s
```

---

## Efecto de proximidad (v2.2: 1m → 0cm)

```
Distancia  | Brillo
-----------|--------
> 100cm    | 0%  (apagado)
100cm      | 10%
75cm       | 32%
50cm       | 55%
25cm       | 77%
0cm        | 100%
```

**Fórmula**: `brillo = Y + ((X - dist) / (X - Z)) × (100 - Y)`

Con X=100, Y=10, Z=0: `brillo = 10 + ((100 - dist) / 100) × 90`

---

## Controles explicados

| Control | Tipo | Función |
|---|---|---|
| 1. Control Automático | Switch | ON = modo proximidad, OFF = manual |
| 2. Solo de Noche | Switch | ON = solo enciende si Luz Ambiente < Umbral |
| 3/5. Luz Der/Izq | Switch | Control manual (requiere Control Auto = OFF) |
| 4/6. Dimmer Der/Izq | Slider 0-100% | Brillo en modo manual |
| 7. Timeout Apagado | Slider 5-300s | Espera sin presencia antes de apagar |
| 8. Umbral Luz | Slider 0-100% | Umbral para "Solo de Noche" |
| 9. Distancia Inicio (X) | Slider 50-600cm | Distancia donde empieza a encender |
| A. Brillo Inicio (Y) | Slider 5-80% | Brillo al detectar a distancia X |
| B. Distancia Máxima (Z) | Slider 0-200cm | Distancia donde alcanza 100% |

---

## Ajustar el efecto de proximidad

**Rango más amplio** (enciende antes, cambio gradual):
```
X = 200cm, Y = 10%, Z = 0cm  → rango de 200cm
```

**Rango estándar** (configuración actual):
```
X = 100cm, Y = 10%, Z = 0cm  → rango de 100cm
```

**Solo muy cerca** (efecto dramático):
```
X = 50cm, Y = 5%, Z = 20cm   → rango de 30cm
```

---

## Troubleshooting

### Sensor siempre reporta 30-40cm
→ `Límite Distancia (Estático)` y `(Movimiento)` a **8**, luego reiniciar.

### Luces no reaccionan al movimiento
→ `Control Automático` = ON, `Luz Derecha/Izquierda` = OFF.

### No encienden de día
→ `Solo de Noche` = OFF, o subir `Umbral Luz` a 80%.

### Efecto muy abrupto
→ Aumentar X (más distancia de inicio) o bajar Z (más rango de interpolación).

### Ver logs en tiempo real
```bash
utils/monitor_lightnode_logs.sh
# o directamente:
esphome logs esphome/lightnode_entrance.yaml --device 192.168.1.15
```

---

## Sensores disponibles (solo lectura)

| Sensor | Descripción |
|---|---|
| Presencia Entrance | Detectado / No detectado |
| Distancia Detectada | cm (usa fallback: detection → moving → still) |
| Distancia Movimiento | cm |
| Distancia Estático | cm |
| Luz Ambiente | % (0=oscuro, 100=muy iluminado) |
