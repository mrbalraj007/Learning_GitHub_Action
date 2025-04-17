# Example: Add repository-level GitHub Actions secrets
resource "github_actions_secret" "repo_secrets" {
  for_each        = var.actions_secrets
  repository      = github_repository.new_repo.name
  secret_name     = each.key
  plaintext_value = each.value
}

# Example: Add repository-level GitHub Actions variables
resource "github_actions_variable" "repo_variables" {
  for_each      = var.actions_variables
  repository    = github_repository.new_repo.name
  variable_name = each.key
  value         = each.value
}
