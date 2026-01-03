# ACB Project - CI/CD & Deployment Automation

Complete Infrastructure as Code (IaC) and Continuous Integration/Continuous Deployment (CI/CD) setup with Terraform, Netlify, and Supabase.

## 🚀 Quick Start

```bash
./run.sh setup      # Initial setup (one time)
./run.sh build      # Build frontend
./run.sh deploy     # Deploy to Netlify + Supabase Functions
```

## 📊 Architecture Overview

**Frontend:** React + TypeScript + Vite → Netlify  
**Backend:** Supabase (PostgreSQL + Serverless Functions)  
**Infrastructure:** Terraform (GitHub Secrets management)  
**Repository:** GitHub (davlan7/proyecto-acb)

## 📁 Directory Structure

```
infra/
├── run.sh                  # Main orchestrator
├── infra.sh               # Terraform management
├── deploy.sh              # Deploy script
├── cleanup.sh             # Cleanup artifacts
├── secrets.sh             # Secrets management
├── setup.sh               # Interactive setup
├── status.sh              # Project status
├── variables.tf           # Terraform variables
├── main.tf                # Terraform config
├── outputs.tf             # Terraform outputs
├── secrets.tfvars         # Secrets (git-ignored)
└── terraform.tfstate      # State file (git-ignored)
```

## 🛠️ Available Commands

### From Project Root

```bash
./run.sh setup              # Setup initial configuration
./run.sh build              # Compile frontend (npm run build)
./run.sh deploy             # Deploy to Netlify + Supabase
./run.sh status             # Show project status
./run.sh clean [type]       # Clean artifacts (all|build|npm|terraform|git)
```

### Direct Commands

```bash
./infra/infra.sh init       # Initialize Terraform
./infra/infra.sh plan       # Preview changes
./infra/infra.sh apply      # Apply infrastructure changes
./infra/infra.sh destroy    # Destroy resources (DANGEROUS)
./infra/secrets.sh generate # Create secrets.tfvars
./infra/secrets.sh list     # List configured secrets
```

## 🔐 Secrets Management

### Local Storage (git-ignored)
```bash
./infra/secrets.sh generate  # Create infra/secrets.tfvars
```

Variables stored:
- `supabase_url`
- `supabase_anon_key`
- `supabase_service_role_key`
- `netlify_token`
- `netlify_site_id`
- `github_token`
- `github_owner`

### GitHub Secrets (via Terraform)
```bash
./infra/infra.sh apply  # Syncs secrets to GitHub Actions
```

All secrets are automatically synced to GitHub repository settings.

## 📦 Deployment Workflow

### Frontend (Netlify)
```bash
./run.sh build          # Compiles to frontend/dist/
./run.sh deploy         # Uploads to Netlify production
```

**Live URL:** https://proyecto-acb-prod.netlify.app

### Backend (Supabase Functions)
Functions are automatically deployed during `./run.sh deploy`

**Functions:**
- `test-function` - Test endpoint at `/functions/v1/test-function`
- `hola-mundo` - Sample endpoint

## ✅ Validation Checks

```bash
# Check frontend is live
curl -I https://proyecto-acb-prod.netlify.app

# Test Supabase Function
curl -X POST "https://jvmlvssftpyvxpjiplsu.supabase.co/functions/v1/test-function" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test"}'

# Check GitHub secrets
gh secret list

# Check Terraform state
terraform state list
```

## 🔄 Development Cycle

1. **Edit Code**
   ```bash
   vim frontend/src/App.tsx
   ```

2. **Build**
   ```bash
   ./run.sh build
   ```

3. **Deploy**
   ```bash
   ./run.sh deploy
   ```

4. **Git Sync**
   ```bash
   git add . && git commit -m "message" && git push
   ```

## 📋 Infrastructure as Code (Terraform)

All cloud resources are managed via Terraform:

- **Provider:** GitHub
- **Resources:** 5 GitHub Actions Secrets
- **State:** `infra/terraform.tfstate` (local)
- **Variables:** `infra/variables.tf`
- **Config:** `infra/main.tf`

### Update Infrastructure

```bash
./infra/infra.sh plan   # Preview changes
./infra/infra.sh apply  # Apply changes
```

## 🔧 Troubleshooting

**"frontend/dist not found"**
```bash
./run.sh build
```

**"secrets.tfvars not found"**
```bash
./infra/secrets.sh generate
```

**"Netlify deploy fails"**
```bash
netlify logout
netlify login
./run.sh deploy
```

**"Terraform not initialized"**
```bash
./infra/infra.sh init
```

## 🚨 Important Notes

- **secrets.tfvars** is git-ignored (never committed)
- **terraform.tfstate** is git-ignored (never committed)
- All sensitive data stored in GitHub Secrets
- Local scripts handle all automation (no external CI/CD runners needed)

## 📊 Current Status

| Component | Status | URL |
|-----------|--------|-----|
| Frontend | ✅ Live | https://proyecto-acb-prod.netlify.app |
| Backend | ✅ Active | https://jvmlvssftpyvxpjiplsu.supabase.co |
| Repository | ✅ Synced | https://github.com/davlan7/proyecto-acb |
| Secrets | ✅ Configured | GitHub Actions Secrets |
| Terraform | ✅ Applied | 5 resources |

## 📝 File Reference

| File | Purpose |
|------|---------|
| `run.sh` | Main orchestrator (setup, build, deploy, status, clean) |
| `infra.sh` | Terraform wrapper (init, plan, apply, destroy) |
| `deploy.sh` | Deploy to Netlify + Supabase |
| `cleanup.sh` | Clean build artifacts, node_modules, terraform state |
| `secrets.sh` | Manage local secrets file |
| `setup.sh` | Interactive setup with browser auth |
| `status.sh` | Show project health status |
| `variables.tf` | Terraform input variables (8 total) |
| `main.tf` | GitHub secrets resources |
| `outputs.tf` | Terraform outputs |

## 🎯 Next Steps

- [ ] Configure actual Supabase project (done ✓)
- [ ] Create database migrations
- [ ] Add more Supabase Functions
- [ ] Set up GitHub Actions workflows (optional)
- [ ] Configure domain names
- [ ] Set up monitoring/logging
