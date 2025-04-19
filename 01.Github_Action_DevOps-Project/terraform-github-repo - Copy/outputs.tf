output "repository_name" {
  description = "The name of the repository"
  value       = github_repository.new_repo.name
}

output "repository_description" {
  description = "The description of the repository"
  value       = github_repository.new_repo.description
}

output "repository_url" {
  description = "The URL of the repository"
  value       = github_repository.new_repo.html_url
}

output "repository_id" {
  description = "The ID of the repository"
  value       = github_repository.new_repo.id
}

output "repository_full_name" {
  description = "The full name of the repository (owner/name)"
  value       = github_repository.new_repo.full_name
}

output "repository_git_clone_url" {
  description = "The URL to use for git clone operations"
  value       = github_repository.new_repo.git_clone_url
}

output "repository_ssh_clone_url" {
  description = "The SSH URL to use for git clone operations"
  value       = github_repository.new_repo.ssh_clone_url
}

output "repository_visibility" {
  description = "The visibility of the repository (public or private)"
  value       = github_repository.new_repo.visibility
}
