variable "supabase_access_token" {
  type      = string
  sensitive = true
}

variable "supabase_org_id" {
  type = string
}

variable "supabase_db_password" {
  type      = string
  sensitive = true
}

variable "netlify_token" {
  type      = string
  sensitive = true
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_owner" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "github_repo_name" {
  type = string
}

variable "project_name" {
  type    = string
  default = "proyecto-acb"
}
