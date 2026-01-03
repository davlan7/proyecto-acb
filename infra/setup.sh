#!/bin/bash
set -e

# =============================================================================
# SETUP-INTERACTIVE.SH - Setup guiado paso a paso
# Uso: ./setup-interactive.sh
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

clear

# Banner
cat << "EOF"

    ╔═══════════════════════════════════════════════════════╗
    ║                                                       ║
    ║        ACB PROJECT - SETUP INTERACTIVO               ║
    ║        Infrastructure as Code + Continuous Deploy     ║
    ║                                                       ║
    ╚═══════════════════════════════════════════════════════╝

EOF

echo -e "${YELLOW}Este script te guiará a través de la configuración inicial.${NC}\n"

# Función para esperar confirmación
wait_continue() {
  read -p "Presiona ENTER para continuar..."
}

# Función para hacer pregunta sí/no
ask_yes_no() {
  local prompt="$1"
  local default="$2"
  
  while true; do
    read -p "$(echo -e ${YELLOW}$prompt${NC}) (s/n): " -n 1 response
    echo
    case $response in
      [Ss]*)
        return 0
        ;;
      [Nn]*)
        return 1
        ;;
      *)
        echo -e "${RED}Por favor responde s o n${NC}"
        ;;
    esac
  done
}

# =============================================================================
# PASO 1: Verificar prerequisitos
# =============================================================================
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[PASO 1/4] Verificando herramientas requeridas${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

TOOLS=("terraform" "netlify" "supabase" "gh" "npm" "git" "jq")
MISSING=()

for tool in "${TOOLS[@]}"; do
  if command -v $tool &> /dev/null; then
    version=$($tool --version 2>&1 | head -n 1 | cut -d' ' -f3-)
    echo -e "  ${GREEN}✓${NC} $tool ($version)"
  else
    echo -e "  ${RED}✗${NC} $tool (FALTA INSTALAR)"
    MISSING+=("$tool")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  echo -e "\n${RED}✗ Faltan herramientas: ${MISSING[*]}${NC}"
  echo -e "${YELLOW}Instálalas y vuelve a ejecutar este script.${NC}"
  exit 1
fi

echo -e "\n${GREEN}✓ Todas las herramientas están instaladas${NC}\n"

# =============================================================================
# PASO 2: Autenticación
# =============================================================================
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[PASO 2/4] Autenticación con servicios en la nube${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Necesitaremos autenticarte con 3 servicios.${NC}"
echo -e "${YELLOW}Cada uno abrirá tu navegador para login.${NC}\n"

# GitHub
if ask_yes_no "¿Autenticar con GitHub?"; then
  echo -e "${PURPLE}Abriendo navegador para GitHub...${NC}\n"
  gh auth login || true
fi

# Netlify
if ask_yes_no "¿Autenticar con Netlify?"; then
  echo -e "${PURPLE}Abriendo navegador para Netlify...${NC}\n"
  netlify login || true
fi

# Supabase
if ask_yes_no "¿Autenticar con Supabase?"; then
  echo -e "${PURPLE}Abriendo navegador para Supabase...${NC}\n"
  supabase login || true
fi

echo -e "\n${GREEN}✓ Autenticación completada${NC}\n"

# =============================================================================
# PASO 3: Crear/Verificar secrets
# =============================================================================
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[PASO 3/4] Configurar secretos${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

if [ -f "infra/secrets.tfvars" ]; then
  echo -e "${GREEN}✓ infra/secrets.tfvars ya existe${NC}"
  
  if ask_yes_no "¿Regenerar secretos?"; then
    chmod +x ./secrets.sh
    ./secrets.sh generate
  else
    echo -e "${YELLOW}Usando secretos existentes${NC}"
  fi
else
  echo -e "${YELLOW}Creando infra/secrets.tfvars...${NC}\n"
  chmod +x ./secrets.sh
  ./secrets.sh generate
fi

echo -e "\n${GREEN}✓ Secretos configurados${NC}\n"

# =============================================================================
# PASO 4: Instalar dependencias
# =============================================================================
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[PASO 4/4] Instalar dependencias y finalizar${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

# NPM
if [ ! -d "frontend/node_modules" ]; then
  echo -e "${YELLOW}Instalando dependencias de npm...${NC}\n"
  cd frontend
  npm install
  cd ..
  echo
fi

# Terraform
if [ ! -f "infra/terraform.tfstate" ]; then
  echo -e "${YELLOW}Inicializando Terraform...${NC}\n"
  cd infra
  terraform init
  cd ..
  echo
fi

echo -e "${GREEN}✓ Dependencias instaladas${NC}\n"

# =============================================================================
# RESUMEN FINAL
# =============================================================================
clear

cat << "EOF"

    ╔═══════════════════════════════════════════════════════╗
    ║                                                       ║
    ║        ✅ SETUP COMPLETADO EXITOSAMENTE              ║
    ║                                                       ║
    ╚═══════════════════════════════════════════════════════╝

EOF

echo -e "${GREEN}Estado actual:${NC}\n"

./status.sh

echo -e "\n${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[PRÓXIMOS PASOS]${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

cat << EOF
${YELLOW}1. Compilar frontend:${NC}
   ${PURPLE}./run.sh build${NC}

${YELLOW}2. Desplegar infraestructura (GitHub secrets):${NC}
   ${PURPLE}./infra.sh apply${NC}

${YELLOW}3. Desplegar a producción (Netlify):${NC}
   ${PURPLE}./run.sh deploy${NC}

${YELLOW}4. Ver estado en cualquier momento:${NC}
   ${PURPLE}./status.sh${NC}

${YELLOW}5. Leer documentación de scripts:${NC}
   ${PURPLE}cat SCRIPTS.md${NC}

EOF

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

echo -e "${GREEN}¡Bienvenido a ACB Project!${NC}\n"
