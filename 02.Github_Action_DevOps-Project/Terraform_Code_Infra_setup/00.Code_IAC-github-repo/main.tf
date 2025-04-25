resource "github_repository" "new_repo" {
  name          = var.repository_name
  description   = var.repository_description
  visibility    = var.repository_private ? "private" : "public"
  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true
  auto_init     = true # Create initial commit

  # Important: Wait for GitHub to fully initialize the repository
  # before attempting to push content to it
  lifecycle {
    ignore_changes = [auto_init]
  }
}

# Add a resource to clone and push the content from the source repository
resource "null_resource" "clone_and_push_repo" {
  depends_on = [github_repository.new_repo]

  # This trigger ensures that the resource is recreated if the repository changes
  triggers = {
    repo_name = github_repository.new_repo.name
    # Adding a timestamp ensures this runs every time we apply
    timestamp = timestamp()
  }

  # Use PowerShell for Windows compatibility
  provisioner "local-exec" {
    command = <<-EOT
      # Create a unique temporary directory
      $tempDir = "temp_clone_$([System.Guid]::NewGuid().ToString())"
      New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
      Set-Location -Path $tempDir
      
      # Sleep to ensure GitHub repo is ready
      Start-Sleep -Seconds 10
      
      # Clone the source repository with all content (including hidden files)
      # git clone --mirror https://github.com/jaiswaladi246/Github-Actions-Project.git .
       git clone --mirror https://github.com/mrbalraj007/Boardgame.git .
      
      # Set the new repository as the remote
      git remote set-url origin https://${var.github_token}@github.com/${var.github_owner}/${var.repository_name}.git
      
      # Push all content, including hidden files and all branches
      git push --mirror
      
      # Clean up
      Set-Location ..
      Remove-Item -Path $tempDir -Recurse -Force
    EOT

    interpreter = ["PowerShell", "-Command"]
  }
}