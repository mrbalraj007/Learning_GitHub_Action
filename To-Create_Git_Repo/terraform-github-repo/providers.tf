provider "github" {
  # The token will be read from the GITHUB_TOKEN environment variable by default
  # Do not set 'token' or 'TF_VAR_github_token'
  owner = var.github_owner
}