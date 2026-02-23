# Floorplan - Home Assistant

Plano interactivo de la casa integrado en el dashboard. Permite ver estados en tiempo real y controlar dispositivos directamente desde el plano.

**Plano activo**: `floorplan.svg` (en raíz del repo)  
**Ruta en HA**: `/local/floorplan/casa.svg`

---

## Áreas configuradas

| Área | Entidad | Acción |
|---|---|---|
| Living/Cocina | `light.riego_z1_led_wifi` | Toggle |
| Deck Exterior | `sensor.riego_z1_humedad_suelo_z1` | Navegar a vista Riego |
| Entrada | `camera.tapo_c530ws_entrada_live_view` | Ver cámara |
| Dormitorio | — | Pendiente |
| Baño | — | Pendiente |

---

## Implementación

Hay dos opciones. El dashboard actual usa **Picture Elements** (nativa, sin dependencias).

### Opción 1 — Picture Elements (actual)

```yaml
type: picture-elements
image: /local/floorplan/casa.svg
elements:
  - type: state-icon
    entity: light.sala
    tap_action:
      action: toggle
    style:
      top: 30%
      left: 25%
```

**Posicionamiento**: `top`/`left` en porcentajes (0% = esquina superior izquierda).

### Opción 2 — ha-floorplan (avanzado, vía HACS)

Requiere instalar `ha-floorplan` desde HACS → Frontend. Soporta SVG interactivo con reglas CSS y animaciones.

```yaml
type: custom:floorplan-card
config:
  image: /local/floorplan/casa.svg
  stylesheet: /local/floorplan/casa.css
  rules:
    - element: living_cocina
      entity: light.sala
      state_action:
        - service: floorplan.class_toggle
          service_data:
            class: light-on
      tap_action:
        action: call-service
        service: light.toggle
        service_data:
          entity_id: light.sala
```

---

## Tipos de elementos (Picture Elements)

| Tipo | Uso |
|---|---|
| `state-icon` | Icono que refleja el estado (luces, switches) |
| `state-label` | Texto con valor del sensor (temperatura, humedad) |
| `state-badge` | Badge con icono y estado |
| `custom:button-card` | Botón completamente personalizable |

---

## Clases CSS para ha-floorplan

| Clase | Estado |
|---|---|
| `light-on` / `light-off` | Luz encendida/apagada |
| `motion-on` / `motion-off` | Movimiento detectado |
| `door-open` / `door-closed` | Puerta abierta/cerrada |
| `temp-cold` / `temp-normal` / `temp-hot` | Temperatura (<18 / 18-24 / >24°C) |
| `alert` | Alerta (rojo pulsante) |

---

## Editar el SVG

Para añadir áreas interactivas al SVG, cada forma debe tener un `id` que coincida con el campo `element:` en el dashboard:

```xml
<!-- Antes -->
<rect x="100" y="200" width="250" height="350" fill="#e0e0e0"/>

<!-- Después -->
<rect id="living_cocina" x="100" y="200" width="250" height="350" fill="#e0e0e0"/>
```

IDs usados en la configuración actual: `living_cocina`, `deck_exterior`, `entrada`, `dormitorio`, `bano`.

Editar con Inkscape (gratuito) o cualquier editor de texto.

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Imagen no se muestra | Ruta incorrecta | Usar `/local/floorplan/...` (no `/www/...`) |
| Elementos no responden | Entidad no existe | Verificar en Dev Tools → States |
| Posiciones incorrectas | Valores en px | Usar porcentajes |
| `floorplan-card not found` | ha-floorplan no instalado | HACS → Frontend → ha-floorplan |
| Lento al cargar | Imagen muy pesada | Optimizar SVG/PNG a < 2MB |

---

## Archivos de referencia

| Archivo | Descripción |
|---|---|
| `floorplan.svg` | Plano de la casa (raíz del repo) |
| `examples/floorplan/floorplan_basic_example.yaml` | Ejemplo básico con Picture Elements |
| `examples/floorplan/floorplan_smartnode_integration.yaml` | Integración con SmartNodes |
| `utils/setup_floorplan.sh` | Script de instalación inicial |
| `utils/update_floorplan_entities.sh` | Actualizar entidades en el dashboard |
| `docs/dashboard/FLOORPLAN_CHEATSHEET.md` | Referencia rápida de sintaxis |
