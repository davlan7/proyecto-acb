#!/bin/bash
set -e

# =============================================================================
# INFRA.SH - Script para gestionar infraestructura con Terraform
# Uso: ./infra.sh [init|plan|apply|destroy|output]
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

COMMAND=${1:-plan}

# Verificar que estamos en el directorio correcto
if [ ! -f "infra/variables.tf" ]; then
  echo -e "${RED}✗ Ejecuta este script desde la raíz del proyecto${NC}"
  exit 1
fi

if [ ! -f "infra/secrets.tfvars" ]; then
  echo -e "${RED}✗ infra/secrets.tfvars no encontrado. Ejecuta 'setup.sh' primero.${NC}"
  exit 1
fi

echo -e "${BLUE}=== TERRAFORM - INFRA MANAGEMENT ===${NC}\n"

cd infra

case $COMMAND in
  init)
    echo -e "${BLUE}[1] Inicializando Terraform...${NC}"
    terraform init
    echo -e "${GREEN}✓ Terraform inicializado${NC}\n"
    ;;
  
  plan)
    echo -e "${BLUE}[2] Plan de cambios...${NC}"
    terraform plan -var-file=secrets.tfvars
    echo -e "${GREEN}✓ Plan completado${NC}\n"
    ;;
  
  apply)
    echo -e "${BLUE}[3] Aplicando cambios...${NC}"
    terraform apply -var-file=secrets.tfvars
    echo -e "${GREEN}✓ Cambios aplicados${NC}\n"
    ;;
  
  destroy)
    echo -e "${YELLOW}⚠ Esto elimina toda la infraestructura${NC}"
    read -p "¿Continuar? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
      terraform destroy -var-file=secrets.tfvars
      echo -e "${GREEN}✓ Infraestructura eliminada${NC}\n"
    else
      echo -e "${YELLOW}Cancelado${NC}"
    fi
    ;;
  
  output)
    echo -e "${BLUE}[4] Outputs${NC}"
    terraform output
    echo -e "${GREEN}✓ Outputs mostrados${NC}\n"
    ;;
  
  *)
    echo -e "${RED}Uso: ./infra.sh [init|plan|apply|destroy|output]${NC}"
    exit 1
    ;;
esac

cd ..
