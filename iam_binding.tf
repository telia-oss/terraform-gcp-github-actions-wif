# The roles.tf file for the terraform-azure-github-actions-wif module
#
# This file contains resources for managing role assignments in Azure,
# including both standard and inline role assignments for the configured repositories and environments.
#


locals {

  # Flatten the environments into a single list
  repo_environments = flatten([
    for repo in var.repositories : [
      for environment in repo.environments : {
        repository_name = repo.repository_name
        sa_email        = try(environment.sa_email, null)
        name_prefix     = environment.name_prefix
        project_id      = environment.project_id
        environment     = environment.environment
        tags            = lookup(environment, "tags", {})
        project_roles   = lookup(environment, "project_roles", {})
      }
    ]
  ])

  # Flatten the standard iam binding roles into a single list
  standard_iam_binding = flatten([
    for env in local.repo_environments : {
      repository_name = env.repository_name
      name_prefix     = env.name_prefix
      project_roles   = env.project_roles
      project_id      = env.project_id
      sa_email        = env.sa_email
      environment     = env.environment
    }]
  )
}

module "iam_member_roles" {

  for_each = {
    for iam_binding in local.standard_iam_binding :

    "${iam_binding.name_prefix}-${iam_binding.repository_name}-${iam_binding.environment}" => iam_binding
  }

  source                  = "terraform-google-modules/iam/google//modules/member_iam"
  version                 = "~> 7.5"
  service_account_address = each.value.sa_email != null ? data.google_service_account.lookup["${each.value.repository_name}-${each.value.project_id}-${each.value.environment}"].email : module.service_accounts["${each.value.repository_name}-${each.value.project_id}-${each.value.environment}"].email
  project_id              = each.value.project_id
  project_roles           = each.value.project_roles
}
