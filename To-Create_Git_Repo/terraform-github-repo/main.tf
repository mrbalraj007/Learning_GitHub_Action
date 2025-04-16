resource "github_repository" "new_repo" {
  name          = var.repository_name
  description   = var.repository_description
  visibility    = var.repository_private ? "private" : "public"
  has_issues    = true
  has_projects  = true // Enable Projects tab
  has_wiki      = true
  has_downloads = true
  auto_init     = true # This creates a README.md

  # Give GitHub some time to fully initialize the repo
  # This helps prevent the 404 errors when creating files
  lifecycle {
    ignore_changes = [auto_init]
  }
}

# Create GitHub Actions workflow file directly using github_repository_file
resource "github_repository_file" "workflow_file" {
  repository          = github_repository.new_repo.name
  branch              = "main"
  file                = ".github/workflows/example.yml"
  content             = <<-EOT
name: Example Workflow

on:
  push:
    branches:
      - main
      - master

jobs:
  hello_world:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Say Hello
        run: echo "Hello, GitHub Actions!"
  EOT
  commit_message      = "Add example GitHub Actions workflow"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  # Wait a bit for the repository to be fully initialized before attempting to create the file
  depends_on = [github_repository.new_repo]
}

# Create GitHub Actions workflow file to copy content from another repository
resource "github_repository_file" "copy_content_workflow_file" {
  repository          = github_repository.new_repo.name
  branch              = "main"
  file                = ".github/workflows/copy_content.yml"
  content             = <<-EOT
name: Copy Repository Content

on:
  push:
    branches:
      - main

jobs:
  copy_content:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout target repository
        uses: actions/checkout@v4

      - name: Clone source repository
        run: |
          git clone --depth 1 https://github.com/jaiswaladi246/Github-Actions-Project.git source_repo
          cp -r source_repo/* .
          rm -rf source_repo

      - name: Push changes to target repository
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add .
          git commit -m "Copy content from source repository"
          git push origin main
  EOT
  commit_message      = "Add workflow to copy content from source repository"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  depends_on = [github_repository.new_repo]
}
