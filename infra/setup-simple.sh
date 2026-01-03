#!/bin/bash
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== SETUP SIMPLIFICADO: Extrae Secrets ===${NC}"

# Supabase Token
echo -e "${BLUE}[1/4] Extrayendo Supabase token...${NC}"
SUPABASE_TOKEN=$(cat ~/.supabase/access-token 2>/dev/null || echo "")
if [ -z "$SUPABASE_TOKEN" ]; then
  echo -e "${RED}✗ Ejecuta: supabase login${NC}"
  exit 1
fi
echo -e "${GREEN}✓ Supabase token obtenido${NC}"

# GitHub Token
echo -e "${BLUE}[2/4] Extrayendo GitHub token...${NC}"
GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
if [ -z "$GITHUB_TOKEN" ]; then
  echo -e "${RED}✗ Ejecuta: gh auth login${NC}"
  exit 1
fi
GITHUB_OWNER=$(gh api user --jq '.login' 2>/dev/null || echo "tu_usuario")
echo -e "${GREEN}✓ GitHub token obtenido${NC}"

# Netlify Token (placeholder)
echo -e "${BLUE}[3/4] Netlify token (completarás manualmente)...${NC}"
NETLIFY_TOKEN="nfp_PLACEHOLDER_COPIA_TU_TOKEN_AQUI"
echo -e "${YELLOW}⚠ Placeholder usado. Edita secrets.tfvars después y reemplaza con tu token real${NC}"

# Generar secrets.tfvars
echo -e "${BLUE}[4/4] Generando secrets.tfvars...${NC}"

cat > secrets.tfvars <<EOF
supabase_access_token = "$SUPABASE_TOKEN"
supabase_org_id = "tu_org_id_aqui"
supabase_db_password = "SecurePass123!@#"
netlify_token = "$NETLIFY_TOKEN"
github_token = "$GITHUB_TOKEN"
github_owner = "$GITHUB_OWNER"
github_repo = "$GITHUB_OWNER/proyecto-acb"
github_repo_name = "proyecto-acb"
EOF

echo -e "${GREEN}✓ secrets.tfvars creado${NC}"

# Init Terraform
echo -e "${BLUE}Inicializando Terraform...${NC}"
terraform init -upgrade

echo -e "${GREEN}=== LISTO ===${NC}"
echo -e "${BLUE}Próximo paso:${NC}"
echo "1. Edita secrets.tfvars y reemplaza PLACEHOLDER con tu Netlify token real"
echo "2. Edita secrets.tfvars y reemplaza supabase_org_id con tu org_id real"
echo "3. Luego: terraform plan -var-file=secrets.tfvars"
echo "4. Luego: terraform apply -var-file=secrets.tfvars"
