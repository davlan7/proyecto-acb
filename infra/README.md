# Proyecto ACB - Automatización de CI/CD y Despliegue

Infraestructura como Código (IaC) completa y despliegue continuo con Terraform, Netlify y Supabase.

## 🚀 Inicio Rápido

```bash
./run.sh setup      # Configuración inicial (una sola vez)
./run.sh build      # Compilar frontend
./run.sh deploy     # Desplegar a Netlify + Funciones Supabase
```

## 📊 Descripción General de la Arquitectura

**Frontend:** React + TypeScript + Vite → Netlify  
**Backend:** Supabase (PostgreSQL + Funciones Serverless)  
**Infraestructura:** Terraform (Gestión de secretos GitHub)  
**Repositorio:** GitHub (davlan7/proyecto-acb)

## 📁 Estructura de Directorios

```
infra/
├── run.sh                  # Orquestador principal
├── infra.sh               # Gestión de Terraform
├── deploy.sh              # Script de despliegue
├── cleanup.sh             # Limpieza de artefactos
├── secrets.sh             # Gestión de secretos
├── setup.sh               # Configuración interactiva
├── status.sh              # Estado del proyecto
├── variables.tf           # Variables de Terraform
├── main.tf                # Configuración de Terraform
├── outputs.tf             # Outputs de Terraform
├── secrets.tfvars         # Secretos (git-ignored)
└── terraform.tfstate      # Archivo de estado (git-ignored)
```

## 🛠️ Comandos Disponibles

### Desde la Raíz del Proyecto

```bash
./run.sh setup              # Configuración inicial
./run.sh build              # Compilar frontend (npm run build)
./run.sh deploy             # Desplegar a Netlify + Supabase
./run.sh status             # Ver estado del proyecto
./run.sh clean [type]       # Limpiar artefactos (all|build|npm|terraform|git)
```

### Comandos Directos

```bash
./infra/infra.sh init       # Inicializar Terraform
./infra/infra.sh plan       # Vista previa de cambios
./infra/infra.sh apply      # Aplicar cambios de infraestructura
./infra/infra.sh destroy    # Destruir recursos (PELIGROSO)
./infra/secrets.sh generate # Crear secrets.tfvars
./infra/secrets.sh list     # Listar secretos configurados
```

## 🔐 Gestión de Secretos

### Almacenamiento Local (git-ignored)
```bash
./infra/secrets.sh generate  # Crear infra/secrets.tfvars
```

Variables almacenadas:
- `supabase_url`
- `supabase_anon_key`
- `supabase_service_role_key`
- `netlify_token`
- `netlify_site_id`
- `github_token`
- `github_owner`

### Secretos en GitHub (vía Terraform)
```bash
./infra/infra.sh apply  # Sincroniza secretos a GitHub Actions
```

Todos los secretos se sincronizan automáticamente a la configuración de GitHub.

## 📦 Flujo de Despliegue

### Frontend (Netlify)
```bash
./run.sh build          # Compila a frontend/dist/
./run.sh deploy         # Sube a producción en Netlify
```

**URL en Vivo:** https://proyecto-acb-prod.netlify.app

### Backend (Funciones Supabase)
Las funciones se despliegan automáticamente durante `./run.sh deploy`

**Funciones:**
- `test-function` - Endpoint de prueba en `/functions/v1/test-function`
- `hola-mundo` - Endpoint de ejemplo

## ✅ Validaciones

```bash
# Verificar que frontend está en vivo
curl -I https://proyecto-acb-prod.netlify.app

# Probar función Supabase
curl -X POST "https://jvmlvssftpyvxpjiplsu.supabase.co/functions/v1/test-function" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test"}'

# Verificar secretos en GitHub
gh secret list

# Verificar estado de Terraform
terraform state list
```

## 🔄 Ciclo de Desarrollo

1. **Editar Código**
   ```bash
   vim frontend/src/App.tsx
   ```

2. **Compilar**
   ```bash
   ./run.sh build
   ```

3. **Desplegar**
   ```bash
   ./run.sh deploy
   ```

4. **Sincronizar con Git**
   ```bash
   git add . && git commit -m "mensaje" && git push
   ```

## 📋 Infraestructura como Código (Terraform)

Todos los recursos en la nube se gestionan mediante Terraform:

- **Proveedor:** GitHub
- **Recursos:** 5 Secretos de GitHub Actions
- **Estado:** `infra/terraform.tfstate` (local)
- **Variables:** `infra/variables.tf`
- **Configuración:** `infra/main.tf`

### Actualizar Infraestructura

```bash
./infra/infra.sh plan   # Vista previa de cambios
./infra/infra.sh apply  # Aplicar cambios
```

## 🔧 Solución de Problemas

**"frontend/dist no encontrado"**
```bash
./run.sh build
```

**"secrets.tfvars no encontrado"**
```bash
./infra/secrets.sh generate
```

**"El despliegue en Netlify falla"**
```bash
netlify logout
netlify login
./run.sh deploy
```

**"Terraform no inicializado"**
```bash
./infra/infra.sh init
```

## 🚨 Notas Importantes

- **secrets.tfvars** está en git-ignored (nunca se commitea)
- **terraform.tfstate** está en git-ignored (nunca se commitea)
- Todos los datos sensibles almacenados en Secretos de GitHub
- Los scripts locales manejan toda la automatización (sin dependencias de CI/CD externos)

## 📊 Estado Actual

| Componente | Estado | URL |
|-----------|--------|-----|
| Frontend | ✅ En Vivo | https://proyecto-acb-prod.netlify.app |
| Backend | ✅ Activo | https://jvmlvssftpyvxpjiplsu.supabase.co |
| Repositorio | ✅ Sincronizado | https://github.com/davlan7/proyecto-acb |
| Secretos | ✅ Configurados | Secretos de GitHub Actions |
| Terraform | ✅ Aplicado | 5 recursos |

## 📝 Referencia de Archivos

| Archivo | Propósito |
|---------|-----------|
| `run.sh` | Orquestador principal (setup, build, deploy, status, clean) |
| `infra.sh` | Wrapper de Terraform (init, plan, apply, destroy) |
| `deploy.sh` | Despliegue a Netlify + Supabase |
| `cleanup.sh` | Limpieza de artefactos de build, node_modules, estado de terraform |
| `secrets.sh` | Gestionar archivo local de secretos |
| `setup.sh` | Configuración interactiva con autenticación por navegador |
| `status.sh` | Mostrar estado de salud del proyecto |
| `variables.tf` | Variables de entrada de Terraform (8 totales) |
| `main.tf` | Recursos de secretos de GitHub |
| `outputs.tf` | Outputs de Terraform |

## 🎯 Próximos Pasos

- [x] Configurar proyecto Supabase real
- [ ] Crear migraciones de base de datos
- [ ] Agregar más funciones Supabase
- [ ] Configurar flujos de GitHub Actions (opcional)
- [ ] Configurar nombres de dominio
- [ ] Configurar monitoreo/logging
