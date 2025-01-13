variable "project" {
  type        = string
  description = "The project name"
  default     = "rails-vite-example"
}

variable "github_repository" {
  type        = string
  description = "The GitHub repository in the format 'owner/repo'"
  default     = "k0kishima/rails_vite_example"
}
