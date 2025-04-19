# PowerShell script to set up GitHub token and run Terraform

# Prompt for GitHub token securely
$token = Read-Host -Prompt "Enter your GitHub Personal Access Token" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
$plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Set the token as an environment variable for the current session
$env:GITHUB_TOKEN = $plainToken

Write-Host "GitHub token set as environment variable GITHUB_TOKEN"
Write-Host "You can now run Terraform commands in this PowerShell session"
Write-Host "Example: cd terraform-github-repo && terraform init && terraform plan && terraform apply"
