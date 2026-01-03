#!/bin/bash

# =============================================================================
# RUN.SH - Script maestro que orquestra todo el proyecto
# Uso: ./run.sh [setup|build|deploy|status|clean]
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

COMMAND=${1:-help}
PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$PROJECT_ROOT"

# Función para mostrar ayuda
show_help() {
  cat << EOF

${BLUE}=== ACB PROJECT - CLI MAESTRO ===${NC}

${YELLOW}Uso:${NC}
  ./run.sh [comando] [opciones]

${YELLOW}Comandos:${NC}
  setup        Configuración inicial (instalar dependencias, crear secrets)
  build        Compilar frontend
  deploy       Desplegar a Netlify y Supabase (requiere build previo)
  status       Mostrar estado del proyecto
  clean        Limpiar artefactos
  help         Mostrar esta ayuda

${YELLOW}Ejemplos:${NC}
  ./run.sh setup              # Configuración inicial
  ./run.sh build              # Compilar frontend
  ./run.sh deploy             # Desplegar a producción
  ./run.sh status             # Ver estado
  ./run.sh clean all          # Limpiar todo

${BLUE}=== SCRIPTS AUXILIARES ===${NC}
  ./infra/infra.sh            # Gestión de Terraform (init, plan, apply)
  ./infra/status.sh           # Estado detallado del proyecto
  ./infra/cleanup.sh          # Limpiar artefactos específicos
  ./infra/secrets.sh          # Gestión de secretos
  ./infra/deploy.sh           # Despliegue manual (bajo nivel)

EOF
}

# Función setup
run_setup() {
  echo -e "${BLUE}=== SETUP INICIAL ===${NC}\n"
  
  # 1. Crear secrets si no existen
  if [ ! -f "infra/secrets.tfvars" ]; then
    echo -e "${YELLOW}[1] Creando secrets...${NC}"
    chmod +x ./infra/secrets.sh
    ./infra/secrets.sh generate
  else
    echo -e "${GREEN}[1] ✓ Secrets ya configurados${NC}"
  fi
  
  # 2. Instalar dependencias del frontend
  if [ ! -d "frontend/node_modules" ]; then
    echo -e "${YELLOW}[2] Instalando dependencias del frontend...${NC}"
    cd "$PROJECT_ROOT/frontend"
    npm install
    cd "$PROJECT_ROOT"
  else
    echo -e "${GREEN}[2] ✓ Dependencias ya instaladas${NC}"
  fi
  
  # 3. Inicializar Terraform
  if [ ! -f "infra/terraform.tfstate" ]; then
    echo -e "${YELLOW}[3] Inicializando Terraform...${NC}"
    chmod +x ./infra/infra.sh
    ./infra/infra.sh init
  else
    echo -e "${GREEN}[3] ✓ Terraform ya inicializado${NC}"
  fi
  
  echo -e "\n${GREEN}=== SETUP COMPLETADO ===${NC}\n"
  echo -e "${BLUE}Próximos pasos:${NC}"
  echo -e "  ${YELLOW}./run.sh build${NC}     # Compilar frontend"
  echo -e "  ${YELLOW}./run.sh deploy${NC}    # Desplegar a producción"
  echo -e "  ${YELLOW}./run.sh status${NC}    # Ver estado del proyecto"
  echo
}

# Función build
run_build() {
  echo -e "${BLUE}=== BUILD ===${NC}\n"
  
  if [ ! -d "frontend/node_modules" ]; then
    echo -e "${YELLOW}Instalando dependencias...${NC}"
    cd "$PROJECT_ROOT/frontend"
    npm install
    cd "$PROJECT_ROOT"
  fi
  
  echo -e "${YELLOW}Compilando frontend...${NC}"
  cd "$PROJECT_ROOT/frontend"
  npm run build
  cd "$PROJECT_ROOT"
  
  echo -e "\n${GREEN}✓ Build completado${NC}"
  echo -e "${BLUE}Output:${NC} frontend/dist/\n"
}

# Función deploy
run_deploy() {
  echo -e "${BLUE}=== DEPLOY ===${NC}\n"
  
  # Verificar que el build existe
  if [ ! -d "frontend/dist" ]; then
    echo -e "${RED}✗ frontend/dist no encontrado${NC}"
    echo -e "${YELLOW}Ejecuta: ./run.sh build${NC}"
    exit 1
  fi
  
  # Ejecutar deploy.sh
  chmod +x ./infra/deploy.sh
  ./infra/deploy.sh
  
  echo -e "\n${GREEN}=== DEPLOY COMPLETADO ===${NC}\n"
}

# Función status
run_status() {
  chmod +x ./infra/status.sh
  ./infra/status.sh
}

# Función clean
run_clean() {
  CLEAN_TYPE=${2:-build}
  chmod +x ./infra/cleanup.sh
  ./infra/cleanup.sh "$CLEAN_TYPE"
}

# Ejecutar comando
case $COMMAND in
  setup)
    run_setup
    ;;
  build)
    run_build
    ;;
  deploy)
    run_deploy
    ;;
  status)
    run_status
    ;;
  clean)
    run_clean
    ;;
  help)
    show_help
    ;;
  *)
    echo -e "${RED}Comando desconocido: $COMMAND${NC}"
    show_help
    exit 1
    ;;
esac
