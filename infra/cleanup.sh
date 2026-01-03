#!/bin/bash

# =============================================================================
# CLEANUP.SH - Limpia artefactos de build, caches, y estados
# Uso: ./cleanup.sh [all|build|terraform|npm|git]
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

TYPE=${1:-build}

echo -e "${BLUE}=== CLEANUP - Eliminando artefactos ===${NC}\n"

# Función para limpiar build artifacts
cleanup_build() {
  echo -e "${YELLOW}[1] Limpiando build artifacts...${NC}"
  rm -rf frontend/dist
  rm -rf frontend/.vite
  rm -rf node_modules/.cache
  echo -e "${GREEN}✓ Build artifacts eliminados${NC}"
}

# Función para limpiar npm
cleanup_npm() {
  echo -e "${YELLOW}[2] Limpiando npm cache...${NC}"
  rm -rf frontend/node_modules
  rm -f frontend/package-lock.json
  npm cache clean --force 2>/dev/null || true
  echo -e "${GREEN}✓ Cache npm eliminado${NC}"
}

# Función para limpiar terraform
cleanup_terraform() {
  echo -e "${YELLOW}[3] Limpiando Terraform...${NC}"
  rm -rf infra/.terraform
  rm -f infra/.terraform.lock.hcl
  rm -f infra/terraform.tfstate*
  echo -e "${GREEN}✓ Estado de Terraform eliminado${NC}"
}

# Función para limpiar git
cleanup_git() {
  echo -e "${YELLOW}[4] Limpiando cambios git sin commitear...${NC}"
  git clean -fd
  git reset --hard
  echo -e "${GREEN}✓ Cambios locales eliminados${NC}"
}

# Ejecutar limpieza según tipo
case $TYPE in
  build)
    cleanup_build
    ;;
  npm)
    cleanup_npm
    ;;
  terraform)
    cleanup_terraform
    ;;
  git)
    echo -e "${RED}⚠ Esto eliminará cambios sin commitear${NC}"
    read -p "¿Continuar? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
      cleanup_git
    else
      echo -e "${YELLOW}Cancelado${NC}"
    fi
    ;;
  all)
    cleanup_build
    cleanup_npm
    cleanup_terraform
    echo -e "${GREEN}✓ Limpieza completa${NC}"
    ;;
  *)
    echo -e "${RED}Uso: ./cleanup.sh [all|build|terraform|npm|git]${NC}"
    exit 1
    ;;
esac

echo -e "\n${GREEN}=== END CLEANUP ===${NC}\n"
