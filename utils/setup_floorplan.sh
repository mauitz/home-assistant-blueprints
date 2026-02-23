#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════
# 🏠 SCRIPT DE CONFIGURACIÓN RÁPIDA DE FLOORPLAN
# ═══════════════════════════════════════════════════════════════════════════
#
# Este script te ayuda a configurar rápidamente un floorplan en Home Assistant
#
# Uso: ./setup_floorplan.sh
#
# ═══════════════════════════════════════════════════════════════════════════

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorio base
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
HA_CONFIG="${PROJECT_ROOT}/HA_config_proxy"

echo -e "${BLUE}"
echo "═══════════════════════════════════════════════════════════════════════════"
echo "🏠  CONFIGURACIÓN DE FLOORPLAN PARA HOME ASSISTANT"
echo "═══════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"

# ───────────────────────────────────────────────────────────────────────────
# Función: Verificar directorio de Home Assistant
# ───────────────────────────────────────────────────────────────────────────
check_ha_directory() {
    echo -e "${YELLOW}[1/7] Verificando directorio de Home Assistant...${NC}"

    if [ ! -d "$HA_CONFIG" ]; then
        echo -e "${RED}❌ Error: No se encuentra el directorio de Home Assistant${NC}"
        echo -e "${YELLOW}Directorio esperado: $HA_CONFIG${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Directorio de Home Assistant encontrado${NC}"
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Crear estructura de directorios
# ───────────────────────────────────────────────────────────────────────────
create_directories() {
    echo -e "\n${YELLOW}[2/7] Creando estructura de directorios...${NC}"

    mkdir -p "${HA_CONFIG}/www/floorplan"
    mkdir -p "${HA_CONFIG}/www/floorplan/templates"

    echo -e "${GREEN}✅ Directorios creados:${NC}"
    echo "   📁 ${HA_CONFIG}/www/floorplan"
    echo "   📁 ${HA_CONFIG}/www/floorplan/templates"
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Copiar ejemplos
# ───────────────────────────────────────────────────────────────────────────
copy_examples() {
    echo -e "\n${YELLOW}[3/7] Copiando ejemplos de configuración...${NC}"

    if [ -d "${PROJECT_ROOT}/examples/floorplan" ]; then
        cp -r "${PROJECT_ROOT}/examples/floorplan/"* "${HA_CONFIG}/www/floorplan/templates/"
        echo -e "${GREEN}✅ Ejemplos copiados a:${NC}"
        echo "   📄 ${HA_CONFIG}/www/floorplan/templates/"
    else
        echo -e "${YELLOW}⚠️  No se encontraron ejemplos para copiar${NC}"
    fi
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Crear README en la carpeta floorplan
# ───────────────────────────────────────────────────────────────────────────
create_readme() {
    echo -e "\n${YELLOW}[4/7] Creando README con instrucciones...${NC}"

    cat > "${HA_CONFIG}/www/floorplan/README.md" << 'EOF'
# 🏠 Floorplan - Home Assistant

## 📂 Estructura de Carpetas

```
www/floorplan/
├── README.md (este archivo)
├── templates/ (ejemplos de configuración)
├── [tu_imagen].png (coloca aquí el plano de tu casa)
└── [opcional] styles.css
```

## 🚀 Inicio Rápido

### 1. Crea el Plano de tu Casa

Opciones recomendadas:
- **Floorplanner**: https://floorplanner.com/es (online, gratuito)
- **Sweet Home 3D**: http://www.sweethome3d.com/es/ (software gratuito)
- **Draw.io**: https://app.diagrams.net/ (online, gratuito)
- **PowerPoint/Keynote**: Usa formas rectangulares

### 2. Exporta y Sube tu Plano

1. Exporta tu plano como **PNG** (recomendado: 1920x1080px)
2. Nómbralo de forma descriptiva: `casa_completa.png`, `planta_baja.png`, etc.
3. Cópialo a esta carpeta: `www/floorplan/`

```bash
cp mi_plano.png /path/to/homeassistant/www/floorplan/casa.png
```

### 3. Configura el Dashboard

#### Opción A: Via UI (Interfaz)

1. Ve a tu dashboard en Home Assistant
2. Click en "Editar Dashboard"
3. Click en "+ Agregar Tarjeta"
4. Buscar "Picture Elements"
5. Configurar:
   - Image path: `/local/floorplan/casa.png`
   - Añadir elementos interactivos

#### Opción B: Via YAML

1. Revisa los ejemplos en `templates/`
2. Copia el ejemplo que más te guste
3. Adapta las entidades a las tuyas
4. Pégalo en tu dashboard

### 4. Ajusta las Posiciones

Las posiciones se definen con `top` y `left`:
- `top`: % desde arriba (0% = arriba, 100% = abajo)
- `left`: % desde izquierda (0% = izq, 100% = der)

Ejemplo:
```yaml
style:
  top: 30%   # 30% desde arriba
  left: 25%  # 25% desde izquierda
```

## 📚 Recursos

- **Documentación completa**: `docs/dashboard/GUIA_FLOORPLAN.md`
- **Ejemplos**: Revisa la carpeta `templates/`
- **Picture Elements Doc**: https://www.home-assistant.io/dashboards/picture-elements/

## 🆘 Troubleshooting

### La imagen no se muestra
- Verifica la ruta: `/local/floorplan/tu_imagen.png`
- Verifica permisos: `chmod 644 tu_imagen.png`
- Limpia caché del navegador: Ctrl+Shift+R

### Los elementos no responden
- Verifica que las entidades existen en Developer Tools → States
- Verifica la sintaxis YAML en Developer Tools → YAML

### Ajustar posiciones
- Usa el modo de edición visual del dashboard
- Experimenta con diferentes valores de `top` y `left`
- Usa la cuadrícula mental: 0%, 25%, 50%, 75%, 100%

## 💡 Tips

1. **Empieza simple**: Usa Picture Elements Card (nativa)
2. **Un elemento a la vez**: Añade y prueba de a uno
3. **Usa áreas de HA**: Organiza tus dispositivos en áreas
4. **Colores**: Usa fondos semi-transparentes para mejor visualización
5. **Móvil**: Prueba cómo se ve en tu teléfono

¡Disfruta de tu floorplan interactivo! 🎉
EOF

    echo -e "${GREEN}✅ README creado${NC}"
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Crear plantilla HTML simple
# ───────────────────────────────────────────────────────────────────────────
create_simple_template() {
    echo -e "\n${YELLOW}[5/7] Creando plantilla SVG de ejemplo...${NC}"

    cat > "${HA_CONFIG}/www/floorplan/templates/simple_house.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
  <!-- Fondo -->
  <rect x="0" y="0" width="800" height="600" fill="#f5f5f5"/>

  <!-- Casa - contorno exterior -->
  <rect x="50" y="50" width="700" height="500" fill="white" stroke="#333" stroke-width="3"/>

  <!-- Sala -->
  <rect id="sala" x="70" y="70" width="320" height="220" fill="#e0e0e0" stroke="#666" stroke-width="2"/>
  <text x="230" y="180" text-anchor="middle" font-size="24" font-weight="bold" fill="#333">Sala</text>

  <!-- Cocina -->
  <rect id="cocina" x="70" y="310" width="320" height="220" fill="#e0e0e0" stroke="#666" stroke-width="2"/>
  <text x="230" y="420" text-anchor="middle" font-size="24" font-weight="bold" fill="#333">Cocina</text>

  <!-- Dormitorio -->
  <rect id="dormitorio" x="410" y="70" width="320" height="220" fill="#e0e0e0" stroke="#666" stroke-width="2"/>
  <text x="570" y="180" text-anchor="middle" font-size="24" font-weight="bold" fill="#333">Dormitorio</text>

  <!-- Baño -->
  <rect id="bano" x="410" y="310" width="320" height="220" fill="#e0e0e0" stroke="#666" stroke-width="2"/>
  <text x="570" y="420" text-anchor="middle" font-size="24" font-weight="bold" fill="#333">Baño</text>

  <!-- Puerta principal -->
  <rect x="380" y="530" width="40" height="20" fill="#8B4513" stroke="#333" stroke-width="1"/>
  <text x="400" y="570" text-anchor="middle" font-size="14" fill="#333">Entrada</text>
</svg>
EOF

    echo -e "${GREEN}✅ Plantilla SVG creada:${NC}"
    echo "   📄 ${HA_CONFIG}/www/floorplan/templates/simple_house.svg"
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Listar áreas configuradas
# ───────────────────────────────────────────────────────────────────────────
list_areas() {
    echo -e "\n${YELLOW}[6/7] Verificando áreas configuradas en Home Assistant...${NC}"

    if [ -f "${HA_CONFIG}/home-assistant_v2.db" ]; then
        echo -e "${BLUE}Áreas detectadas:${NC}"
        sqlite3 "${HA_CONFIG}/home-assistant_v2.db" "SELECT name FROM areas;" 2>/dev/null || \
            echo -e "${YELLOW}⚠️  No se pudo acceder a la base de datos${NC}"
    else
        echo -e "${YELLOW}⚠️  Base de datos de Home Assistant no encontrada${NC}"
    fi
}

# ───────────────────────────────────────────────────────────────────────────
# Función: Mostrar siguiente pasos
# ───────────────────────────────────────────────────────────────────────────
show_next_steps() {
    echo -e "\n${GREEN}"
    echo "═══════════════════════════════════════════════════════════════════════════"
    echo "✅  CONFIGURACIÓN COMPLETADA"
    echo "═══════════════════════════════════════════════════════════════════════════"
    echo -e "${NC}"

    echo -e "${BLUE}📋 Próximos pasos:${NC}\n"

    echo -e "${YELLOW}1. Crear el plano de tu casa:${NC}"
    echo "   • Usa Floorplanner: https://floorplanner.com/es"
    echo "   • O Sweet Home 3D: http://www.sweethome3d.com/es/"
    echo "   • Exporta como PNG (1920x1080px recomendado)"
    echo ""

    echo -e "${YELLOW}2. Copiar el archivo a Home Assistant:${NC}"
    echo "   cp tu_plano.png ${HA_CONFIG}/www/floorplan/casa.png"
    echo ""

    echo -e "${YELLOW}3. Configurar áreas en Home Assistant:${NC}"
    echo "   • Ve a: Configuración → Áreas y Zonas"
    echo "   • Crea un área para cada habitación"
    echo "   • Asigna dispositivos a cada área"
    echo ""

    echo -e "${YELLOW}4. Agregar el floorplan al dashboard:${NC}"
    echo "   • Revisa los ejemplos en:"
    echo "     ${HA_CONFIG}/www/floorplan/templates/"
    echo "   • Documentación completa:"
    echo "     ${PROJECT_ROOT}/docs/dashboard/GUIA_FLOORPLAN.md"
    echo ""

    echo -e "${YELLOW}5. (Opcional) Usar plantilla SVG de ejemplo:${NC}"
    echo "   • Abre: ${HA_CONFIG}/www/floorplan/templates/simple_house.svg"
    echo "   • Edítalo con Inkscape o un editor de texto"
    echo ""

    echo -e "${BLUE}📚 Recursos:${NC}"
    echo "   • Guía completa: docs/dashboard/GUIA_FLOORPLAN.md"
    echo "   • Ejemplos: examples/floorplan/"
    echo "   • README: www/floorplan/README.md"
    echo ""

    echo -e "${GREEN}¡Todo listo para crear tu floorplan! 🎉${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════

main() {
    check_ha_directory
    create_directories
    copy_examples
    create_readme
    create_simple_template
    list_areas
    show_next_steps
}

# Ejecutar
main



