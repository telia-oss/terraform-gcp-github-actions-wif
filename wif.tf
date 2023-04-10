# The app_registration.tf file for the terraform-azure-github-actions-wif module
#
# This file contains resources related to the Azure Active Directory application registrations,
# service principals, and federated identity credentials for the GitHub OIDC app.
#


locals {

  //application_owners = var.owners == null ? [data.azurerm_client_config.current.object_id] : var.owners

  environments_to_create_sa = [
    for env in local.repo_environments : env if env.sa_email == null
  ]

  environments_to_reference_sa = [
    for env in local.repo_environments : env if env.sa_email != null
  ]

  //subject_template_path = var.override_subject_template_path != null ? var.override_subject_template_path : "${path.module}/templates/subject_template.tpl"
}

resource "random_string" "unique_sa_name" {
  for_each = { for env in local.environments_to_create_sa : "${env.repository_name}-${env.project_id}-${env.environment}" => env }
  length   = 4
  special  = false
  lower    = true
  upper    = false

}

# The service accounts for the GitHub Actions
module "service_accounts" {
  for_each     = { for env in local.environments_to_create_sa : "${env.repository_name}-${env.project_id}-${env.environment}" => env }
  source       = "terraform-google-modules/service-accounts/google"
  version      = "~> 3.0"
  project_id   = each.value.project_id
  prefix       = each.value.name_prefix
  display_name = "sa-${each.value.name_prefix}-${each.value.repository_name}"
  names        = [replace("${each.value.environment}", "/", "-")]
}
//"${random_string.unique_sa_name["${each.value.repository_name}-${each.value.project_id}-${each.value.environment}"].result}-

data "google_service_account" "lookup" {
  for_each = {
    for env in local.environments_to_reference_sa : "${env.repository_name}-${env.project_id}-${env.environment}" => env
  }
  account_id = each.value.sa_email
}

resource "random_string" "random_id" {
  length  = 4
  special = false
  lower   = true
  upper   = false
}

module "gh_oidc" {
  for_each              = { for e in local.repo_environments : "${e.repository_name}-${e.environment}" => e }
  source                = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version               = "~> 3.1"
  project_id            = each.value.project_id
  pool_display_name     = "${each.value.environment}-pool"
  provider_display_name = "${each.value.environment}-provider"
  pool_id               = "${each.value.name_prefix}-${random_string.random_id.result}-pool"
  provider_id           = "${each.value.name_prefix}-${random_string.random_id.result}-provider"
  issuer_uri            = var.github_issuer_url
  allowed_audiences     = [var.audience_name]


  sa_mapping = {
    "${each.value.repository_name}-${each.value.project_id}-${each.value.environment}" = {
      sa_name   = each.value.sa_email != null ? data.google_service_account.lookup["${each.value.repository_name}-${each.value.project_id}-${each.value.environment}"].id : "projects/${each.value.project_id}/serviceAccounts/${module.service_accounts["${each.value.repository_name}-${each.value.project_id}-${each.value.environment}"].email}"
      attribute = "attribute.repository/${each.value.repository_name}"
    }
  }
}
