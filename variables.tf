
variable "name_prefix" {
  description = "The value is a prefix for the name of the resources created."
  type        = string

  validation {
    condition     = length(var.name_prefix) > 0
    error_message = "The name_prefix value must be a non-empty string."
  }
}

variable "github_issuer_url" {
  type        = string
  default     = "https://token.actions.githubusercontent.com"
  description = "value is the issuer URL for the GitHub OIDC provider."

}

variable "environment" {
  type        = string
  description = "value is the environment for the resources created."
}

variable "repositories" {
  type = list(object({
    repository_name = string
    environments = list(object({
      environment   = string
      name_prefix   = string
      sa_email      = optional(string)
      project_id    = optional(string)
      tags          = optional(map(string))
      project_roles = list(string)
    }))
  }))
  description = "List of repositories and their respective environments for which to create secrets and configure permissions."
}

variable "audience_name" {
  type        = string
  default     = "api://AzureADTokenExchange"
  description = "The value is the audience name for the GitHub OIDC provider."
}

variable "user_defined_tags" {
  description = "The value is a map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "The value is a map of default tags to assign to the resource."
  type        = map(string)
  default = {
    "CreatedBy" = "Terraform"
  }
}

variable "owners" {
  description = "List of object IDs of the application owners."
  type        = list(string)
  default     = null
}

variable "override_subject_template_path" {
  description = "set this to override the default subject template for the workload identity subject."
  type        = string
  default     = null
}
