# The github.tf file for the terraform-gcp-github-actions-wif module
#
# This file contains resources for managing GitHub repository environments,
# creating secrets for GCP authentication in GitHub Actions environments,
# and other GitHub-related configurations.

locals {
  github_repository_names = { for repo in data.github_repository.repo : repo.name => repo.name if repo.name != null }
  flattened_environments = flatten([
    for repo in var.repositories : [
      for environment in repo.environments : {
        repository_name = repo.repository_name
        environment     = environment.environment
        name_prefix     = environment.name_prefix
        project_id      = environment.project_id
        sa_email        = try(environment.sa_email, null)
        tags            = try(environment.tags, {})
        project_roles   = try(environment.project_roles, null)
      }
    ]
  ])
  environment_map = { for env in local.flattened_environments : "${env.repository_name}-${env.environment}" => env }
}

# The GitHub repository data source is used to retrieve the repository name
data "github_repository" "repo" {
  for_each = { for repo in var.repositories : repo.repository_name => repo }
  name     = each.value.repository_name
}

# The GitHub repository environment resource is used to create the repository environments
resource "github_repository_environment" "repo_environment" {
  for_each    = local.environment_map
  environment = each.value.environment
  repository  = each.value.repository_name
}

resource "github_actions_environment_secret" "workload_identity_provider" {
  for_each        = local.environment_map
  repository      = github_repository_environment.repo_environment[each.key].repository
  environment     = github_repository_environment.repo_environment[each.key].environment
  secret_name     = "GCP_WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value = module.gh_oidc["${each.value.repository_name}-${each.value.environment}"].provider_name
}

resource "github_actions_environment_secret" "project_id" {
  for_each        = local.environment_map
  repository      = github_repository_environment.repo_environment[each.key].repository
  environment     = github_repository_environment.repo_environment[each.key].environment
  secret_name     = "GCP_PROJECT_ID"
  plaintext_value = each.value.project_id
}

resource "github_actions_environment_secret" "service_account" {
  for_each        = local.environment_map
  repository      = github_repository_environment.repo_environment[each.key].repository
  environment     = github_repository_environment.repo_environment[each.key].environment
  secret_name     = "GCP_SERVICE_ACCOUNT"
  plaintext_value = each.value.sa_email != null ? data.google_service_account.lookup["${each.value.repository_name}-${each.value.project_id}-${each.value.environment}"].email : module.service_accounts["${each.value.repository_name}-${each.value.project_id}-${each.value.environment}"].email
}

