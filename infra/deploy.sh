#!/bin/bash
set -e

# =============================================================================
# DEPLOY.SH - Despliega frontend a Netlify y funciones a Supabase
# Uso: ./deploy.sh [--prod|--preview]
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

DEPLOY_MODE="${1:---prod}"

echo -e "${BLUE}=== DEPLOY - Frontend a Netlify + Functions a Supabase ===${NC}\n"

# Función para parsear valores de tfvars
get_secret() {
  local var_name="$1"
  grep "^$var_name" infra/secrets.tfvars 2>/dev/null | sed 's/.*= "//' | sed 's/".*//' || echo ""
}

# Verificar prerequisitos
if [ ! -d "frontend/dist" ]; then
  echo -e "${RED}✗ frontend/dist no encontrado${NC}"
  echo -e "${YELLOW}Ejecuta primero: ./run.sh build${NC}"
  exit 1
fi

if [ ! -f "infra/secrets.tfvars" ]; then
  echo -e "${RED}✗ infra/secrets.tfvars no encontrado${NC}"
  exit 1
fi

# =============================================================================
# FASE 1: Validar secretos
# =============================================================================
echo -e "${BLUE}[1] Validando secretos...${NC}"

NETLIFY_SITE_ID=$(get_secret "netlify_site_id")
NETLIFY_TOKEN=$(get_secret "netlify_token")

if [ -z "$NETLIFY_SITE_ID" ] || [ -z "$NETLIFY_TOKEN" ]; then
  echo -e "${RED}✗ Faltan secrets: NETLIFY_SITE_ID o NETLIFY_TOKEN${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Secretos validados${NC}"
echo -e "  NETLIFY_SITE_ID: $(echo $NETLIFY_SITE_ID | cut -c1-8)..."
echo -e "  NETLIFY_TOKEN: $(echo $NETLIFY_TOKEN | cut -c1-8)...\n"

# =============================================================================
# FASE 2: Deploy a Netlify
# =============================================================================
echo -e "${BLUE}[2] Desplegando frontend a Netlify...${NC}"
echo -e "  Modo: ${PURPLE}$DEPLOY_MODE${NC}"
echo -e "  Directorio: ${PURPLE}frontend/dist${NC}\n"

if [ "$DEPLOY_MODE" = "--prod" ]; then
  DEPLOY_MSG="Producción (URL pública)"
else
  DEPLOY_MSG="Preview (URL temporal)"
fi

echo -e "${YELLOW}Desplegando a $DEPLOY_MSG${NC}\n"

# Usar netlify deploy con variables de entorno
export NETLIFY_AUTH_TOKEN="$NETLIFY_TOKEN"
export NETLIFY_SITE_ID="$NETLIFY_SITE_ID"

netlify deploy \
  --dir=frontend/dist \
  --message="Deploy desde deploy.sh" \
  $DEPLOY_MODE \
  --functions=./functions 2>/dev/null || \
netlify deploy \
  --dir=frontend/dist \
  --message="Deploy desde deploy.sh" \
  $DEPLOY_MODE

echo -e "\n${GREEN}✓ Deploy a Netlify completado${NC}\n"

# =============================================================================
# FASE 3: Obtener URL
# =============================================================================
echo -e "${BLUE}[3] Obteniendo URL de tu app...${NC}\n"

SITE_URL=$(netlify status --site="$NETLIFY_SITE_ID" 2>/dev/null | grep "Site URL" | awk '{print $NF}' || echo "https://$NETLIFY_SITE_ID.netlify.app")

echo -e "${GREEN}✓ URL disponible:${NC}"
echo -e "  ${PURPLE}${SITE_URL}${NC}\n"

# =============================================================================
# FASE 4: Deploy a Supabase (opcional)
# =============================================================================
if [ -d "supabase/functions" ] && [ $(find supabase/functions -type f 2>/dev/null | wc -l) -gt 0 ]; then
  echo -e "${BLUE}[4] Desplegando funciones a Supabase...${NC}\n"
  
  if supabase functions deploy 2>/dev/null; then
    echo -e "${GREEN}✓ Deploy a Supabase completado${NC}\n"
  else
    echo -e "${YELLOW}⚠ No se pudo desplegar funciones de Supabase${NC}"
    echo -e "  (Verifica que esté autenticado: supabase login)\n"
  fi
else
  echo -e "${YELLOW}[4] ⚠ supabase/functions no encontrado (omitiendo)${NC}\n"
fi

# =============================================================================
# RESUMEN FINAL
# =============================================================================
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ DEPLOY COMPLETADO EXITOSAMENTE${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Resumen:${NC}"
echo -e "  ${GREEN}✓${NC} Frontend desplegado en Netlify"
echo -e "  ${GREEN}✓${NC} Modo: $DEPLOY_MSG"
echo -e "  ${GREEN}✓${NC} URL: ${PURPLE}${SITE_URL}${NC}\n"

echo -e "${YELLOW}Próximos pasos:${NC}"
echo -e "  1. Abre ${PURPLE}${SITE_URL}${NC} para verificar"
echo -e "  2. Haz cambios en tu código"
echo -e "  3. Ejecuta ${PURPLE}./run.sh build && ./run.sh deploy${NC} nuevamente\n"

echo -e "${YELLOW}Comandos útiles:${NC}"
echo -e "  ${PURPLE}./status.sh${NC}                  # Ver estado"
echo -e "  ${PURPLE}./cleanup.sh build${NC}          # Limpiar dist/"
echo -e "  ${PURPLE}netlify status${NC}              # Info de Netlify"
echo -e "  ${PURPLE}netlify logs${NC}                # Ver logs en vivo\n"
