repository_name        = "GithubAction_DevOps_Projects"
repository_description = "An example GitHub repository created with Terraform"
repository_private     = false         #true, you have to set as true if you want to create private repo.
github_owner           = "mrbalraj007" # Replace with your GitHub username or organization

# DO NOT include github_token here - use environment variables instead
# Use: export GITHUB_TOKEN="your-token" (Linux/macOS) or $env:GITHUB_TOKEN="your-token" (PowerShell)

actions_secrets = {
  SONAR_TOKEN     = "super_secret_value"
  DOCKERHUB_TOKEN = "another_secret_value"
  MY_GITHUB_PAT_TOKEN     = "need to update value here"
  # AWS_SECRET_ACCESS_KEY = "AWS_SECRET_ACCESS_KEY_values"
  EKS_KUBECONFIG = "yet_another_value"
  SONAR_HOST_URL     = "some_value"
  DOCKERHUB_USERNAME = "another_value"
}

actions_variables = {

  AWS_REGION         = "us-east-1"
  MY_GITHUB_REPO_NAME = "GithubAction_DevOps_Projects.git"
  MY_GITHUB_LOGIN_ID = "mrbalraj007"
}
