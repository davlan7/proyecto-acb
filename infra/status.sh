#!/bin/bash

# =============================================================================
# STATUS.SH - Mostraestra estado actual del proyecto
# Uso: ./status.sh
# =============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== ACB PROJECT STATUS ===${NC}\n"

# 1. Verificar herramientas instaladas
echo -e "${BLUE}[1] Herramientas instaladas:${NC}"
for tool in terraform supabase netlify gh act jq docker; do
  if command -v $tool &> /dev/null; then
    version=$($tool --version 2>&1 | head -n 1)
    echo -e "  ${GREEN}✓${NC} $tool: $version"
  else
    echo -e "  ${RED}✗${NC} $tool: NO INSTALADO"
  fi
done

# 2. Verificar archivos críticos
echo -e "\n${BLUE}[2] Archivos críticos:${NC}"
files=(
  "infra/variables.tf"
  "infra/main.tf"
  "infra/outputs.tf"
  "infra/secrets.tfvars"
  ".github/workflows/ci-cd.yml"
  "deploy.sh"
  "infra.sh"
)

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo -e "  ${GREEN}✓${NC} $file"
  else
    echo -e "  ${RED}✗${NC} $file"
  fi
done

# 3. Verificar git
echo -e "\n${BLUE}[3] Git:${NC}"
if [ -d ".git" ]; then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  origin=$(git config --get remote.origin.url 2>/dev/null)
  echo -e "  ${GREEN}✓${NC} Repositorio inicializado (rama: $branch)"
  if [ -n "$origin" ]; then
    echo -e "  ${GREEN}✓${NC} Origen remoto: $origin"
  else
    echo -e "  ${YELLOW}⚠${NC} Sin origen remoto configurado"
  fi
else
  echo -e "  ${RED}✗${NC} Git no inicializado"
fi

# 4. Verificar secretos
echo -e "\n${BLUE}[4] Secretos:${NC}"
if [ -f "infra/secrets.tfvars" ]; then
  secrets_count=$(grep -c "=" infra/secrets.tfvars)
  echo -e "  ${GREEN}✓${NC} secrets.tfvars encontrado ($secrets_count variables)"
  # Mostrar solo los nombres de variables, no los valores
  echo "    Variables:"
  grep "=" infra/secrets.tfvars | sed 's/=.*//' | sed 's/^/      /'
else
  echo -e "  ${RED}✗${NC} secrets.tfvars no encontrado"
fi

# 5. Verificar frontend
echo -e "\n${BLUE}[5] Frontend:${NC}"
if [ -d "frontend" ]; then
  if [ -f "frontend/package.json" ]; then
    echo -e "  ${GREEN}✓${NC} Directorio frontend configurado"
    if [ -d "frontend/node_modules" ]; then
      echo -e "  ${GREEN}✓${NC} Dependencias instaladas"
    else
      echo -e "  ${YELLOW}⚠${NC} npm install pendiente"
    fi
    if [ -d "frontend/dist" ]; then
      echo -e "  ${GREEN}✓${NC} Build compilado"
    else
      echo -e "  ${YELLOW}⚠${NC} npm run build pendiente"
    fi
  else
    echo -e "  ${RED}✗${NC} package.json no encontrado"
  fi
else
  echo -e "  ${RED}✗${NC} Directorio frontend no encontrado"
fi

# 6. Verificar Terraform state
echo -e "\n${BLUE}[6] Terraform:${NC}"
if [ -f "infra/terraform.tfstate" ]; then
  resources=$(grep -c "type" infra/terraform.tfstate 2>/dev/null || echo "0")
  echo -e "  ${GREEN}✓${NC} Estado de Terraform encontrado (~$resources recursos)"
else
  echo -e "  ${YELLOW}⚠${NC} Sin estado de Terraform (requiere 'terraform init')"
fi

# 7. Resumen de próximos pasos
echo -e "\n${BLUE}[7] Próximos pasos:${NC}"
if [ ! -d "frontend/node_modules" ]; then
  echo -e "  1. ${YELLOW}npm install${NC} en frontend/"
fi
if [ ! -f "infra/terraform.tfstate" ]; then
  echo -e "  2. ${YELLOW}./infra.sh init${NC} para inicializar Terraform"
fi
if [ ! -d "frontend/dist" ]; then
  echo -e "  3. ${YELLOW}./deploy.sh${NC} para compilar y desplegar"
fi

echo -e "\n${GREEN}=== END STATUS ===${NC}\n"
