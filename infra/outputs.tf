output "setup_complete" {
  value = "Terraform setup completado. Todos los secrets han sido configurados en GitHub Actions."
}

output "next_steps" {
  value = <<-EOT
    Próximos pasos:
    1. Revisa los secrets en: https://github.com/${var.github_owner}/${var.github_repo_name}/settings/secrets/actions
    2. Crea el workflow en .github/workflows/ci-cd.yml
    3. Configura tu repositorio Git
    4. Haz push a main para activar CI/CD
  EOT
}
