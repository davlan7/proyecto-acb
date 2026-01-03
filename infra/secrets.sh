#!/bin/bash
set -e

# =============================================================================
# SECRETS.SH - Gestiona secretos (crear, actualizar, exportar)
# Uso: ./secrets.sh [generate|update|export|list]
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

COMMAND=${1:-list}
SECRETS_FILE="infra/secrets.tfvars"

echo -e "${BLUE}=== SECRETS MANAGEMENT ===${NC}\n"

# Función para generar secrets.tfvars
generate_secrets() {
  echo -e "${BLUE}[1] Generando secrets.tfvars...${NC}\n"
  
  # Si ya existe, hacer backup
  if [ -f "$SECRETS_FILE" ]; then
    echo -e "${YELLOW}Archivo $SECRETS_FILE ya existe. Creando backup...${NC}"
    cp "$SECRETS_FILE" "$SECRETS_FILE.bak"
  fi
  
  # Obtener valores existentes o solicitar nuevos
  echo -e "${YELLOW}Ingresa los valores de tus secretos:${NC}\n"
  
  read -p "SUPABASE_ORG_ID: " SUPABASE_ORG_ID
  read -p "SUPABASE_URL: " SUPABASE_URL
  read -sp "SUPABASE_ANON_KEY: " SUPABASE_ANON_KEY
  echo
  read -sp "SUPABASE_SERVICE_ROLE_KEY: " SUPABASE_SERVICE_ROLE_KEY
  echo
  read -sp "NETLIFY_TOKEN: " NETLIFY_TOKEN
  echo
  read -p "NETLIFY_SITE_ID: " NETLIFY_SITE_ID
  read -p "GITHUB_TOKEN: " GITHUB_TOKEN
  read -p "GITHUB_OWNER: " GITHUB_OWNER
  read -sp "POSTGRES_PASSWORD: " POSTGRES_PASSWORD
  echo
  
  # Crear archivo secrets.tfvars
  cat > "$SECRETS_FILE" << EOF
supabase_org_id           = "$SUPABASE_ORG_ID"
supabase_url              = "$SUPABASE_URL"
supabase_anon_key         = "$SUPABASE_ANON_KEY"
supabase_service_role_key = "$SUPABASE_SERVICE_ROLE_KEY"
netlify_token             = "$NETLIFY_TOKEN"
netlify_site_id           = "$NETLIFY_SITE_ID"
github_token              = "$GITHUB_TOKEN"
github_owner              = "$GITHUB_OWNER"
postgres_password         = "$POSTGRES_PASSWORD"
EOF
  
  chmod 600 "$SECRETS_FILE"
  echo -e "\n${GREEN}✓ Secrets guardados en $SECRETS_FILE${NC}"
  echo -e "${YELLOW}⚠ Este archivo está en .gitignore (nunca se commitea)${NC}\n"
}

# Función para actualizar un secret específico
update_secret() {
  if [ ! -f "$SECRETS_FILE" ]; then
    echo -e "${RED}✗ $SECRETS_FILE no existe${NC}"
    exit 1
  fi
  
  echo -e "${BLUE}[2] Actualizando secreto...${NC}\n"
  read -p "Variable a actualizar: " VAR_NAME
  read -sp "Nuevo valor: " VAR_VALUE
  echo
  
  # Usar sed para actualizar (funciona en Linux y macOS)
  sed -i.bak "s/^$VAR_NAME.*=.*/$VAR_NAME = \"$VAR_VALUE\"/" "$SECRETS_FILE"
  
  echo -e "${GREEN}✓ Secret actualizado${NC}\n"
}

# Función para exportar secrets como variables de entorno
export_secrets() {
  if [ ! -f "$SECRETS_FILE" ]; then
    echo -e "${RED}✗ $SECRETS_FILE no existe${NC}"
    exit 1
  fi
  
  echo -e "${BLUE}[3] Exportando como variables de entorno...${NC}\n"
  
  # Parsear y exportar cada variable
  while IFS='=' read -r key value; do
    # Limpiar espacios y comillas
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs | tr -d '"')
    
    if [ -n "$key" ] && [ ! "${key:0:1}" = "#" ]; then
      var_name=$(echo "$key" | tr '[:lower:]' '[:upper:]')
      export "$var_name"="$value"
      echo "  ${GREEN}✓${NC} $var_name"
    fi
  done < "$SECRETS_FILE"
  
  echo -e "\n${GREEN}✓ Secrets exportados a env${NC}\n"
}

# Función para listar secrets (sin mostrar valores)
list_secrets() {
  if [ ! -f "$SECRETS_FILE" ]; then
    echo -e "${RED}✗ $SECRETS_FILE no existe${NC}"
    exit 1
  fi
  
  echo -e "${BLUE}[4] Secrets configurados:${NC}\n"
  
  while IFS='=' read -r key value; do
    key=$(echo "$key" | xargs)
    if [ -n "$key" ] && [ ! "${key:0:1}" = "#" ]; then
      # Mostrar solo primeros/últimos caracteres del valor
      value_hidden=$(echo "$value" | sed 's/.*\(.\{3\}\)$/***\1/')
      echo "  ${GREEN}✓${NC} $key = $value_hidden"
    fi
  done < "$SECRETS_FILE"
  
  echo
}

# Ejecutar comando
case $COMMAND in
  generate)
    generate_secrets
    ;;
  update)
    update_secret
    ;;
  export)
    export_secrets
    ;;
  list)
    list_secrets
    ;;
  *)
    echo -e "${RED}Uso: ./secrets.sh [generate|update|export|list]${NC}"
    exit 1
    ;;
esac
