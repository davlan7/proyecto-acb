#!/bin/bash
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== SETUP COMPLETO: CI/CD IaC TERRAFORM ===${NC}"

# Verificar herramientas
echo -e "${BLUE}[1/6] Verificando herramientas...${NC}"
for tool in terraform supabase netlify gh act jq; do
  if ! command -v $tool &> /dev/null; then
    echo -e "${RED}✗ $tool NO INSTALADO${NC}"
    exit 1
  fi
done
echo -e "${GREEN}✓ Todas las herramientas instaladas${NC}"

# Auth CLIs (solo si es necesario)
echo -e "${BLUE}[2/6] Verificando autenticaciones...${NC}"

if [ ! -f ~/.supabase/access_token ]; then
  echo -e "${YELLOW}Supabase no autenticado. Ejecuta: supabase login${NC}"
  supabase login
fi
echo -e "${GREEN}✓ Supabase autenticado${NC}"

if ! netlify user:config &>/dev/null 2>&1; then
  echo -e "${YELLOW}Netlify no autenticado. Ejecuta: netlify login${NC}"
  netlify login
fi
echo -e "${GREEN}✓ Netlify autenticado${NC}"

if ! gh auth token &>/dev/null 2>&1; then
  echo -e "${YELLOW}GitHub no autenticado. Ejecuta: gh auth login${NC}"
  gh auth login
fi
echo -e "${GREEN}✓ GitHub autenticado${NC}"

# Extraer secrets automáticamente
echo -e "${BLUE}[3/6] Extrayendo secrets...${NC}"

SUPABASE_TOKEN=$(cat ~/.supabase/access-token 2>/dev/null || cat ~/.config/supabase/access_token 2>/dev/null || echo "")
if [ -z "$SUPABASE_TOKEN" ]; then
  echo -e "${RED}✗ No se pudo obtener SUPABASE_TOKEN. Ejecuta: supabase login${NC}"
  exit 1
fi

SUPABASE_ORG_ID=$(supabase orgs list --json 2>/dev/null | jq -r '.[0].id' 2>/dev/null || echo "")
if [ -z "$SUPABASE_ORG_ID" ]; then
  echo -e "${YELLOW}⚠ SUPABASE_ORG_ID vacío. Usarás manual.${NC}"
  SUPABASE_ORG_ID="tu_org_id"
fi

NETLIFY_TOKEN=$(netlify user:config 2>/dev/null | jq -r '.access_token' 2>/dev/null || echo "")
if [ -z "$NETLIFY_TOKEN" ]; then
  echo -e "${RED}✗ No se pudo obtener NETLIFY_TOKEN${NC}"
  exit 1
fi

GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
if [ -z "$GITHUB_TOKEN" ]; then
  echo -e "${RED}✗ No se pudo obtener GITHUB_TOKEN${NC}"
  exit 1
fi

GITHUB_OWNER=$(gh api user --jq '.login' 2>/dev/null || echo "")
GITHUB_REPO="${GITHUB_OWNER}/proyecto-acb"

echo -e "${GREEN}✓ Secrets extraídos${NC}"

# Crear secrets.tfvars
echo -e "${BLUE}[4/6] Generando secrets.tfvars...${NC}"

cat > secrets.tfvars <<EOF
supabase_access_token = "$SUPABASE_TOKEN"
supabase_org_id = "$SUPABASE_ORG_ID"
supabase_db_password = "SecurePass123!@#"
netlify_token = "$NETLIFY_TOKEN"
github_token = "$GITHUB_TOKEN"
github_owner = "$GITHUB_OWNER"
github_repo = "$GITHUB_REPO"
github_repo_name = "proyecto-acb"
EOF

echo -e "${GREEN}✓ secrets.tfvars creado${NC}"
echo -e "${YELLOW}NOTA: Copia SUPABASE_SERVICE_ROLE_KEY manualmente si es necesario${NC}"

# Crear archivo de secrets para 'act'
echo -e "${BLUE}[5/6] Generando secrets.env para act...${NC}"

cat > ../.github/secrets.env <<EOF
SUPABASE_URL=https://$(echo $SUPABASE_TOKEN | cut -c1-20).supabase.co
SUPABASE_ANON_KEY=$(supabase secrets list --project-ref default --json 2>/dev/null | jq -r '.[] | select(.name=="SUPABASE_ANON_KEY") | .value' 2>/dev/null || echo "placeholder_key")
SUPABASE_SERVICE_ROLE_KEY=placeholder
NETLIFY_TOKEN=$NETLIFY_TOKEN
GITHUB_TOKEN=$GITHUB_TOKEN
EOF

echo -e "${GREEN}✓ secrets.env creado${NC}"

# Terraform init
echo -e "${BLUE}[6/6] Inicializando Terraform...${NC}"
terraform init
echo -e "${GREEN}✓ Terraform inicializado${NC}"

echo -e "${GREEN}=== SETUP COMPLETADO ===${NC}"
echo -e "${BLUE}Próximos pasos:${NC}"
echo "1. Revisa secrets.tfvars y ajusta valores manuales si es necesario"
echo "2. Ejecuta: terraform plan -var-file=secrets.tfvars"
echo "3. Ejecuta: terraform apply -var-file=secrets.tfvars"
echo "4. Luego: crea configs en main.tf, variables.tf, outputs.tf"
