repository_name        = "GithubAction_DevOps_Projects"
repository_description = "An example GitHub repository created with Terraform"
repository_private     = false #true, you have to set as true if you want to create private repo.
github_owner           = "mrbalraj007" # Replace with your GitHub username or organization

# DO NOT include github_token here - use environment variables instead
# Use: export GITHUB_TOKEN="your-token" (Linux/macOS) or $env:GITHUB_TOKEN="your-token" (PowerShell)

actions_secrets = {
  MY_SECRET  = "super_secret_value"
  MY_SECRET1 = "another_secret_value"
  MY_SECRET2 = "yet_another_secret"
}

actions_variables = {
  MY_VARIABLE  = "some_value"
  MY_VARIABLE1 = "another_value"
  MY_VARIABLE2 = "yet_another_value"
}
