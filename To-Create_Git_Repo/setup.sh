#!/bin/bash
# Script to set up GitHub token and run Terraform

# Prompt for GitHub token
read -sp "Enter your GitHub Personal Access Token: " token
echo

# Set the token as an environment variable
export GITHUB_TOKEN="$token"

echo "GitHub token set as environment variable GITHUB_TOKEN"
echo "You can now run Terraform commands in this terminal session"
echo "Example: cd terraform-github-repo && terraform init && terraform plan && terraform apply"
