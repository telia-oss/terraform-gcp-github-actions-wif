# Terraform Azure GitHub Actions Workload Identity Federation (WIF) Module

> **WARNING:** This module is currently under active development and is not yet ready for production use.

This Terraform module integrates GitHub Actions with Workload Identity Federation for Microsoft Azure. It simplifies the process of setting up and managing Azure Role-based Access Control (RBAC) for GitHub Actions environments by creating the necessary resources and configuring the required secrets.

## Background

Workload Identity Federation for Microsoft Azure allows you to use Azure AD to authenticate and authorize users and applications to access Azure resources. This module simplifies the process of setting up and managing Azure RBAC for GitHub Actions environments by creating the necessary resources and configuring the required secrets.

See references below for more information about Workload Identity Federation for Microsoft Azure and GitHub Actions.

## Prerequisites

- Existing Azure Active Directory (AD) tenant.
- Permissions to create and manage Azure AD applications and service principals.
- Existing GitHub repository with GitHub Actions enabled, and GitHub Actions environments configured.
- Logged in to Azure CLI using `az login`.
- Credentials fo GitHub, either using a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or [GitHub App](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps).

## Features

- Creates and manage existing Azure Active Directory (AD) applications and service principals for GitHub repositories' environments.
- Assign custom and built-in Azure RBAC roles to the service principal associated with each environment.
- Configures trust against GitHub through GitHub Actions environments with Azure AD application federated credentials.
- Configure existing GitHub repository with environment secrets, that provides required configurations.

## Usage

The following example creates a new Azure AD application and service principal for each environment in the repository `my-repo`. The service principal is assigned the built-in Azure RBAC role `Contributor` for the subscription `your-subscription-id` in the environment `staging`. The service principal is assigned the built-in Azure RBAC role `Reader` for the subscription `your-subscription-id` in the environment `production`. The service principal for the environment `production` is configured to use an existing Azure AD application with the ID `your-existing-application-id`.

```hcl
module "azure_gha_wif" {
  source = "github.com/telia-oss/terraform-azure-github-actions-wif"

  repositories = [
    {
      repository_name = "my-repo"
      environments = [
        {
          environment     = "staging"
          name_prefix     = "staging"
          roles           = {
            "Contributor" = ["/subscriptions/your-subscription-id"]
          }
        },
        {
          environment     = "production"
          name_prefix     = "prod"
          application_id  = "your-existing-application-id"
          roles           = {
            "Reader" = ["/subscriptions/your-subscription-id"]
          }
        }
      ]
    }
  ]

  user_defined_tags = {
    "ManagedBy" = "my-team"
  }
}
```

## Examples

Please see the [examples](./examples) directory for examples of how to use this module.

## Requirements

| Name                                                                      | Version |
| ------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.0   |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread)       | 2.36.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | ~>3.51  |
| <a name="requirement_github"></a> [github](#requirement\_github)          | ~> 5.0  |

## Providers

| Name                                                          | Version |
| ------------------------------------------------------------- | ------- |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.36.0  |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.30.0  |
| <a name="provider_github"></a> [github](#provider\_github)    | 5.18.3  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                                       | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [azuread_application.github_oidc](https://registry.terraform.io/providers/hashicorp/azuread/2.36.0/docs/resources/application)                                                             | resource    |
| [azuread_application_federated_identity_credential.github_oidc](https://registry.terraform.io/providers/hashicorp/azuread/2.36.0/docs/resources/application_federated_identity_credential) | resource    |
| [azuread_service_principal.github_oidc](https://registry.terraform.io/providers/hashicorp/azuread/2.36.0/docs/resources/service_principal)                                                 | resource    |
| [azurerm_role_assignment.inline_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)                                          | resource    |
| [azurerm_role_assignment.standard_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)                                        | resource    |
| [azurerm_role_definition.inline_role_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition)                                          | resource    |
| [github_actions_environment_secret.azure_client_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret)                          | resource    |
| [github_actions_environment_secret.azure_project_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret)                         | resource    |
| [github_actions_environment_secret.azure_tenant_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret)                          | resource    |
| [github_repository_environment.repo_environment](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment)                                 | resource    |
| [azuread_application.existing](https://registry.terraform.io/providers/hashicorp/azuread/2.36.0/docs/data-sources/application)                                                             | data source |
| [azuread_service_principal.lookup](https://registry.terraform.io/providers/hashicorp/azuread/2.36.0/docs/data-sources/service_principal)                                                   | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)                                                          | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription)                                                            | data source |
| [github_repository.repo](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository)                                                                  | data source |

## Inputs

| Name                                                                                                                               | Description                                                                                                   | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Default                                         | Required |
| ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- | :------: |
| <a name="input_audience_name"></a> [audience\_name](#input\_audience\_name)                                                        | The value is the audience name for the GitHub OIDC provider.                                                  | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `"api://AzureADTokenExchange"`                  |    no    |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags)                                                           | The value is a map of default tags to assign to the resource.                                                 | `map(string)`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> |    no    |
| <a name="input_environment"></a> [environment](#input\_environment)                                                                | value is the environment for the resources created.                                                           | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | n/a                                             |   yes    |
| <a name="input_github_issuer_url"></a> [github\_issuer\_url](#input\_github\_issuer\_url)                                          | value is the issuer URL for the GitHub OIDC provider.                                                         | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `"https://token.actions.githubusercontent.com"` |    no    |
| <a name="input_location"></a> [location](#input\_location)                                                                         | value is the location/region where the resources in the module should be created.                             | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `"swedencentral"`                               |    no    |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)                                                              | The value is a prefix for the name of the resources created.                                                  | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | n/a                                             |   yes    |
| <a name="input_override_subject_template_path"></a> [override\_subject\_template\_path](#input\_override\_subject\_template\_path) | set this to override the default subject template for the workload identity subject.                          | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `null`                                          |    no    |
| <a name="input_owners"></a> [owners](#input\_owners)                                                                               | List of object IDs of the application owners.                                                                 | `list(string)`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | `null`                                          |    no    |
| <a name="input_repositories"></a> [repositories](#input\_repositories)                                                             | List of repositories and their respective environments for which to create secrets and configure permissions. | <pre>list(object({<br>    repository_name = string<br>    environments = list(object({<br>      environment     = string<br>      name_prefix     = string<br>      application_id  = optional(string)<br>      project_id = optional(string)<br>      tags            = optional(map(string))<br>      roles = optional(map(object({<br>        project_roles = set(string)<br>      })))<br>      inline_roles = optional(map(object({<br>        name              = string<br>        assignable        = bool<br>        scope             = string<br>        assignable_project_roles = optional(set(string))<br>        permissions = object({<br>          actions     = list(string)<br>          not_actions = list(string)<br>        })<br>      })))<br>    }))<br>  }))</pre> | n/a                                             |   yes    |
| <a name="input_user_defined_tags"></a> [user\_defined\_tags](#input\_user\_defined\_tags)                                          | The value is a map of tags to assign to the resource.                                                         | `map(string)`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | `{}`                                            |    no    |

## Outputs

| Name                                                                                                                                 | Description                                                                               |
| ------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------- |
| <a name="output_azure_client_id_secrets"></a> [azure\_client\_id\_secrets](#output\_azure\_client\_id\_secrets)                      | Information about the AZURE\_CLIENT\_ID secrets for GitHub repository environments.       |
| <a name="output_azure_project_id_secrets"></a> [azure\_subscription\_id\_secrets](#output\_azure\_subscription\_id\_secrets)         | Information about the AZURE\_SUBSCRIPTION\_ID secrets for GitHub repository environments. |
| <a name="output_azure_tenant_id_secrets"></a> [azure\_tenant\_id\_secrets](#output\_azure\_tenant\_id\_secrets)                      | Information about the AZURE\_TENANT\_ID secrets for GitHub repository environments.       |
| <a name="output_github_oidc_applications"></a> [github\_oidc\_applications](#output\_github\_oidc\_applications)                     | Information about the created GitHub OIDC applications.                                   |
| <a name="output_github_oidc_service_principals"></a> [github\_oidc\_service\_principals](#output\_github\_oidc\_service\_principals) | Information about the created GitHub OIDC service principals.                             |
| <a name="output_github_repository_environments"></a> [github\_repository\_environments](#output\_github\_repository\_environments)   | Information about the created GitHub repository environments.                             |
| <a name="output_inline_role_assignments"></a> [inline\_role\_assignments](#output\_inline\_role\_assignments)                        | Information about the inline role assignments.                                            |
| <a name="output_inline_role_definitions"></a> [inline\_role\_definitions](#output\_inline\_role\_definitions)                        | Information about the inline role definitions.                                            |
| <a name="output_inline_roles"></a> [inline\_roles](#output\_inline\_roles)                                                           | n/a                                                                                       |
| <a name="output_standard_role_assignments"></a> [standard\_role\_assignments](#output\_standard\_role\_assignments)                  | Information about the standard role assignments.                                          |

## References

- [Workload Identity Federation for Microsoft Azure](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-convert-app-to-be-workload-identity)
- [GitHub Actions: Workload Identity Federation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-workload-identity-federation-for-azure)
- [GitHub Actions: Azure credentials](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-azure-credentials-for-github-actions)

## Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for details on submitting patches and the contribution workflow.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
