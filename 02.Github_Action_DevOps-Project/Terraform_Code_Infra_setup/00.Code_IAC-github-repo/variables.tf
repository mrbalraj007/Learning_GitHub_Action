variable "repository_name" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "repository_description" {
  description = "A brief description of the GitHub repository"
  type        = string
}

variable "repository_private" {
  description = "Specifies whether the repository is private or public"
  type        = bool
  default     = false
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
  default     = "xxxxxxx" # "xxxxxxxxxxxxxxxxxxxxxxx"  # Define here Github Token value
}

variable "github_owner" {
  description = "The GitHub owner (username or organization)"
  type        = string
}

variable "actions_secrets" {
  description = "Map of GitHub Actions secrets to set at the repository level"
  type        = map(string)
  default     = {}
}

variable "actions_variables" {
  description = "Map of GitHub Actions variables to set at the repository level"
  type        = map(string)
  default     = {}
}