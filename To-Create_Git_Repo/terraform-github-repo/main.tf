resource "github_repository" "new_repo" {
  name          = var.repository_name
  description   = var.repository_description
  visibility    = var.repository_private ? "private" : "public"
  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true
  auto_init     = true # Create initial commit

  lifecycle {
    ignore_changes = [auto_init]
  }
}

# Remove the workflow file resource as we'll clone the entire repository instead
# resource "github_repository_file" "workflow_file" {
#   ...
# }

# Add a resource to clone and push the content from the source repository
resource "null_resource" "clone_and_push_repo" {
  depends_on = [github_repository.new_repo]

  # This trigger ensures that the resource is recreated if the repository changes
  triggers = {
    repo_name = github_repository.new_repo.name
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Create a temporary directory
      mkdir -p temp_clone_dir
      cd temp_clone_dir
      
      # Initialize git
      git init
      
      # Clone the source repository with all content including hidden files
      git clone --mirror https://github.com/jaiswaladi246/Github-Actions-Project.git .
      
      # Set the new repository as the remote
      git remote set-url origin https://${var.github_token}@github.com/${var.github_owner}/${var.repository_name}.git
      
      # Push all content, including hidden files and all branches
      git push --mirror
      
      # Clean up
      cd ..
      rm -rf temp_clone_dir
    EOT

    interpreter = ["bash", "-c"]
  }
}