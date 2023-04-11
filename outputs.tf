

output "github_repository_environments" {
  value = {
    for key, env in github_repository_environment.repo_environment : key => {
      environment = env.environment
      repository  = env.repository
    }
  }
  description = "Information about the created GitHub repository environments."
}

/*output "gcp_client_id_secrets" {
  value = {
    for key, secret in github_actions_environment_secret.gcp_client_id : key => {
      repository      = secret.repository
      environment     = secret.environment
      secret_name     = secret.secret_name
      plaintext_value = secret.plaintext_value
    }
  }
  description = "Information about the gcp_CLIENT_ID secrets for GitHub repository environments."
}

output "gcp_project_id_secrets" {
  value = {
    for key, secret in github_actions_environment_secret.gcp_project_id : key => {
      repository      = secret.repository
      environment     = secret.environment
      secret_name     = secret.secret_name
      plaintext_value = secret.plaintext_value
    }
  }
  description = "Information about the gcp_project_id secrets for GitHub repository environments."
}

output "gcp_tenant_id_secrets" {
  value = {
    for key, secret in github_actions_environment_secret.gcp_tenant_id : key => {
      repository      = secret.repository
      environment     = secret.environment
      secret_name     = secret.secret_name
      plaintext_value = secret.plaintext_value
    }
  }
  description = "Information about the gcp_TENANT_ID secrets for GitHub repository environments."
}

output "standard_role_assignments" {
  value = {
    for key, assignment in azurerm_role_assignment.standard_role_assignment : key => {
      principal_id         = assignment.principal_id
      scope                = assignment.scope
      role_definition_name = assignment.role_definition_name
    }
  }
  description = "Information about the standard role assignments."
}

output "inline_role_definitions" {
  value = {
    for key, definition in azurerm_role_definition.inline_role_definition : key => {
      name                        = definition.name
      description                 = definition.description
      scope                       = definition.scope
      role_definition_resource_id = definition.role_definition_resource_id
    }
  }
  description = "Information about the inline role definitions."
}

output "inline_role_assignments" {
  value = {
    for key, assignment in azurerm_role_assignment.inline_role_assignment : key => {
      principal_id         = assignment.principal_id
      scope                = assignment.scope
      role_definition_name = assignment.role_definition_name
    }
  }
  description = "Information about the inline role assignments."
}
*/
