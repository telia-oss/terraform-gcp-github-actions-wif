# Terraform GCP GitHub Actions Workload Identity Federation (WIF) Module

> **WARNING:** This module is currently under active development and is not yet ready for production use.

This Terraform module integrates GitHub Actions with Workload Identity Federation for Google Cloud Platform (GCP). It simplifies the process of setting up and managing GCP IAM for GitHub Actions environments by creating the necessary resources and configuring the required secrets.

## Background

Workload Identity Federation for GCP allows you to use GCP IAM to authenticate and authorize users and applications to access GCP resources. This module simplifies the process of setting up and managing GCP IAM for GitHub Actions environments by creating the necessary resources and configuring the required secrets.

See references below for more information about Workload Identity Federation for GCP and GitHub Actions.

## Prerequisites

- Existing GCP project and service account credentials.
- Permissions to create and manage GCP service accounts, IAM roles, and bindings.
- Existing GitHub repository with GitHub Actions enabled, and GitHub Actions environments configured.
- Credentials for GitHub, either using a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or [GitHub App](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps).

## Features

- Creates and manages GCP service accounts and IAM roles for GitHub repositories' environments.
- Assigns custom and built-in GCP IAM roles to the service account associated with each environment.
- Configures trust against GitHub through GitHub Actions environments with GCP service account credentials.
- Configures existing GitHub repository with environment secrets that provide required configurations.

## Usage

The following example creates a new GCP service account and IAM role for each environment in the repository `teliacompany-gcp-wif-test`. The service account is assigned the built-in IAM roles `roles/compute.networkAdmin` and `roles/appengine.appAdmin` for the project `seismic-shape-293115` in the environment `development`.

```hcl
module "gha_repo1" {
  source = "path/to/terraform-gcp-github-actions-wif"

  name_prefix = "demo"
  environment = "development"

  repositories = [
    {
      repository_name = "teliacompany-gcp-wif-test"
      environments = [
        {
          environment    = "development"
          name_prefix    = "app1-dev"
          project_id     = "seismic-shape-293115"
          tags = {
            Environment = "development"
            Application = "App1"
          }
          project_roles = ["roles/compute.networkAdmin", "roles/appengine.appAdmin"]
        }
      ]
    },
  ]
}
```

## Examples

Please see the [examples](./examples) directory for examples of how to use this module.

## Requirements

| Name                                                                      | Version |
| ------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.0   |
| <a name="requirement_github"></a> [github](#requirement\_github)          | ~>5.0   |
| <a name="requirement_google"></a> [google](#requirement\_google)          | ~>4.60  |
| <a name="requirement_random"></a> [random](#requirement\_random)          | ~>3.4   |

## Providers

| Name                                                       | Version |
| ---------------------------------------------------------- | ------- |
| <a name="provider_github"></a> [github](#provider\_github) | 5.37.0  |
| <a name="provider_google"></a> [google](#provider\_google) | 4.83.0  |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1   |

## Modules

| Name                                                                                     | Source                                                                  | Version |
| ---------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | ------- |
| <a name="module_gh_oidc"></a> [gh\_oidc](#module\_gh\_oidc)                              | terraform-google-modules/github-actions-runners/google//modules/gh-oidc | ~> 3.1  |
| <a name="module_iam_member_roles"></a> [iam\_member\_roles](#module\_iam\_member\_roles) | terraform-google-modules/iam/google//modules/member_iam                 | ~> 7.5  |
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts)   | terraform-google-modules/service-accounts/google                        | ~> 3.0  |

## Resources

| Name                                                                                                                                                                         | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [github_actions_environment_secret.project_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret)                 | resource    |
| [github_actions_environment_secret.service_account](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret)            | resource    |
| [github_actions_environment_secret.workload_identity_provider](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource    |
| [github_repository_environment.repo_environment](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment)                   | resource    |
| [random_string.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                                             | resource    |
| [random_string.unique_sa_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                                        | resource    |
| [github_repository.repo](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository)                                                    | data source |
| [google_service_account.lookup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/service_account)                                           | data source |

## Inputs

| Name                                                                                                                               | Description                                                                                                   | Type                                                                                                                                                                                                                                                                                                                                                      | Default                                         | Required |
| ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- | :------: |
| <a name="input_audience_name"></a> [audience\_name](#input\_audience\_name)                                                        | The value is the audience name for the GitHub OIDC provider.                                                  | `string`                                                                                                                                                                                                                                                                                                                                                  | `"google-wlif"`                                 |    no    |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags)                                                           | The value is a map of default tags to assign to the resource.                                                 | `map(string)`                                                                                                                                                                                                                                                                                                                                             | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> |    no    |
| <a name="input_environment"></a> [environment](#input\_environment)                                                                | value is the environment for the resources created.                                                           | `string`                                                                                                                                                                                                                                                                                                                                                  | n/a                                             |   yes    |
| <a name="input_github_issuer_url"></a> [github\_issuer\_url](#input\_github\_issuer\_url)                                          | value is the issuer URL for the GitHub OIDC provider.                                                         | `string`                                                                                                                                                                                                                                                                                                                                                  | `"https://token.actions.githubusercontent.com"` |    no    |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)                                                              | The value is a prefix for the name of the resources created.                                                  | `string`                                                                                                                                                                                                                                                                                                                                                  | n/a                                             |   yes    |
| <a name="input_override_subject_template_path"></a> [override\_subject\_template\_path](#input\_override\_subject\_template\_path) | set this to override the default subject template for the workload identity subject.                          | `string`                                                                                                                                                                                                                                                                                                                                                  | `null`                                          |    no    |
| <a name="input_owners"></a> [owners](#input\_owners)                                                                               | List of object IDs of the application owners.                                                                 | `list(string)`                                                                                                                                                                                                                                                                                                                                            | `null`                                          |    no    |
| <a name="input_repositories"></a> [repositories](#input\_repositories)                                                             | List of repositories and their respective environments for which to create secrets and configure permissions. | <pre>list(object({<br>    repository_name = string<br>    environments = list(object({<br>      environment   = string<br>      name_prefix   = string<br>      sa_email      = optional(string)<br>      project_id    = optional(string)<br>      tags          = optional(map(string))<br>      project_roles = list(string)<br>    }))<br>  }))</pre> | n/a                                             |   yes    |
| <a name="input_user_defined_tags"></a> [user\_defined\_tags](#input\_user\_defined\_tags)                                          | The value is a map of tags to assign to the resource.                                                         | `map(string)`                                                                                                                                                                                                                                                                                                                                             | `{}`                                            |    no    |

## Outputs

| Name                                                                                                                               | Description                                                   |
| ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| <a name="output_github_repository_environments"></a> [github\_repository\_environments](#output\_github\_repository\_environments) | Information about the created GitHub repository environments. |

## References

- [Workload Identity Federation for GCP](https://cloud.google.com/iam/docs/workload-identity-federation)
- [GitHub Actions: Workload Identity Federation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-google-cloud-platform)
- [GitHub Actions: Azure credentials](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-azure-credentials-for-github-actions)

## Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for details on submitting patches and the contribution workflow.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
