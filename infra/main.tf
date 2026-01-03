terraform {
  required_version = ">= 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# Crear secrets en GitHub Actions
resource "github_actions_secret" "supabase_url" {
  repository      = var.github_repo_name
  secret_name     = "SUPABASE_URL"
  plaintext_value = "https://placeholder.supabase.co"
}

resource "github_actions_secret" "supabase_anon_key" {
  repository      = var.github_repo_name
  secret_name     = "SUPABASE_ANON_KEY"
  plaintext_value = "placeholder_anon_key"
}

resource "github_actions_secret" "supabase_service_role_key" {
  repository      = var.github_repo_name
  secret_name     = "SUPABASE_SERVICE_ROLE_KEY"
  plaintext_value = "placeholder_service_role_key"
}

resource "github_actions_secret" "netlify_token" {
  repository      = var.github_repo_name
  secret_name     = "NETLIFY_TOKEN"
  plaintext_value = var.netlify_token
}

resource "github_actions_secret" "netlify_site_id" {
  repository      = var.github_repo_name
  secret_name     = "NETLIFY_SITE_ID"
  plaintext_value = "placeholder_site_id"
}

output "github_secrets_created" {
  value = "GitHub Actions secrets creados exitosamente"
}
